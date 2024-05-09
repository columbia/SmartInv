1 // www.medium.com/@0xsuzume
2 // https://twitter.com/s_shitakiri
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.6.0 <0.9.0;
6 
7 abstract contract Context {
8     function _msgSender() internal view returns (address payable) {
9         return payable(msg.sender);
10     }
11 
12     function _msgData() internal view returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
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
219 contract SUZUME is Context, IERC20Upgradeable {
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
233     mapping (address => bool) private _liquidityHolders;
234    
235     uint256 private startingSupply;
236 
237     string private _name;
238     string private _symbol;
239 
240     uint256 public _reflectFee = 0;
241     uint256 public _liquidityFee = 0;
242     uint256 public _marketingFee =0;
243 
244     uint256 public _buyReflectFee = _reflectFee;
245     uint256 public _buyLiquidityFee = _liquidityFee;
246     uint256 public _buyMarketingFee = _marketingFee;
247 
248     uint256 public _sellReflectFee = 0;
249     uint256 public _sellLiquidityFee = 0;
250     uint256 public _sellMarketingFee = 0;
251     
252     uint256 public _transferReflectFee = 0;
253     uint256 public _transferLiquidityFee = 0;
254     uint256 public _transferMarketingFee = 0;
255     
256     uint256 private maxReflectFee = 1000;
257     uint256 private maxLiquidityFee = 1000;
258     uint256 private maxMarketingFee = 2200;
259 
260     uint256 public _liquidityRatio = 0;
261     uint256 public _marketingRatio = 0;
262 
263     uint256 private masterTaxDivisor = 10000;
264 
265     uint256 public MarketShare = 1;
266     uint256 public DevShare = 0;
267     uint256 public ValueDivisor = 1;
268 
269     uint256 private constant MAX = ~uint256(0);
270     uint8 private _decimals;
271     uint256 private _decimalsMul;
272     uint256 private _tTotal;
273     uint256 private _rTotal;
274     uint256 private _tFeeTotal;
275 
276     IUniswapV2Router02 public dexRouter;
277     address public lpPair;
278 
279     // UNI ROUTER
280     address public _routerAddress;
281 
282     address public DEAD = 0x000000000000000000000000000000000000dEaD;
283     address public ZERO = 0x0000000000000000000000000000000000000000;
284     address payable private _devWallet;
285     address payable private _marketWallet;
286     
287     bool inSwapAndLiquify;
288     bool public swapAndLiquifyEnabled = false;
289     
290     uint256 private _maxTxAmount;
291     uint256 public maxTxAmountUI;
292 
293     uint256 private _maxWalletSize;
294     uint256 public maxWalletSizeUI;
295 
296     uint256 private swapThreshold;
297     uint256 private swapAmount;
298 
299     bool tradingEnabled = false;
300 
301     bool public _hasLiqBeenAdded = false;
302     uint256 private _liqAddBlock = 0;
303     uint256 private _liqAddStamp = 0;
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
316     uint256 Planted;
317     
318     bool contractInitialized = false;
319     
320     modifier lockTheSwap {
321         inSwapAndLiquify = true;
322         _;
323         inSwapAndLiquify = false;
324     }
325 
326     modifier onlyOwner() {
327         require(_owner == _msgSender(), "Ownable: caller is not the owner");
328         _;
329     }
330     
331     constructor () payable {
332         // Set the owner.
333         _owner = msg.sender;
334 
335         if (block.chainid == 56) {
336             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
337         } else if (block.chainid == 97) {
338             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
339         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
340             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
341         } else {
342             revert();
343         }
344 
345         _isExcludedFromFee[owner()] = true;
346         _isExcludedFromFee[address(this)] = true;
347         _liquidityHolders[owner()] = true;
348 
349         _approve(_msgSender(), _routerAddress, MAX);
350         _approve(address(this), _routerAddress, MAX);
351 
352     }
353 
354     receive() external payable {}
355 
356     function intializeContract(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
357         require(!contractInitialized);
358 
359         _marketWallet = payable(setMarketWallet);
360         _devWallet = payable(setDevWallet);
361 
362         _name = _tokenname;
363         _symbol = _tokensymbol;
364         startingSupply = 1_000_000_000_000;
365         if (startingSupply < 10000000000000) {
366             _decimals = 18;
367             _decimalsMul = _decimals;
368         } else {
369             _decimals = 9;
370             _decimalsMul = _decimals;
371         }
372         _tTotal = startingSupply * (10**_decimalsMul);
373         _rTotal = (MAX - (MAX % _tTotal));
374 
375         dexRouter = IUniswapV2Router02(_routerAddress);
376         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
377         lpPairs[lpPair] = true;
378         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
379         
380         _maxTxAmount = (_tTotal * 100) / 100;
381         maxTxAmountUI = (startingSupply * 1000) / 100000;
382         _maxWalletSize = (_tTotal * 100) / 100;
383         maxWalletSizeUI = (startingSupply * 10) / 1000;
384         swapThreshold = (_tTotal * 5) / 10000;
385         swapAmount = (_tTotal * 5) / 1000;
386 
387         approve(_routerAddress, type(uint256).max);
388 
389         contractInitialized = true;
390         _rOwned[owner()] = _rTotal;
391         emit Transfer(ZERO, owner(), _tTotal);
392 
393         _approve(address(this), address(dexRouter), type(uint256).max);
394 
395         _transfer(owner(), address(this), balanceOf(owner()));
396 
397 
398         
399 
400         dexRouter.addLiquidityETH{value: address(this).balance}(
401             address(this),
402             balanceOf(address(this)),
403             0, 
404             0, 
405             owner(),
406             block.timestamp
407         );
408         Planted = block.number;
409     }
410 
411 //===============================================================================================================
412 //===============================================================================================================
413 //===============================================================================================================
414     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
415     // This allows for removal of ownership privelages from the owner once renounced or transferred.
416     function owner() public view returns (address) {
417         return _owner;
418     }
419 
420     function transferOwner(address newOwner) external onlyOwner() {
421         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
422         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
423         setExcludedFromFee(_owner, false);
424         setExcludedFromFee(newOwner, true);
425         setExcludedFromReward(newOwner, true);
426         
427         if (_devWallet == payable(_owner))
428             _devWallet = payable(newOwner);
429         
430         _allowances[_owner][newOwner] = balanceOf(_owner);
431         if(balanceOf(_owner) > 0) {
432             _transfer(_owner, newOwner, balanceOf(_owner));
433         }
434         
435         _owner = newOwner;
436         emit OwnershipTransferred(_owner, newOwner);
437         
438     }
439 
440     function renounceOwnership() public virtual onlyOwner() {
441         setExcludedFromFee(_owner, false);
442         _owner = address(0);
443         emit OwnershipTransferred(_owner, address(0));
444     }
445 //===============================================================================================================
446 //===============================================================================================================
447 //===============================================================================================================
448 
449     function totalSupply() external view override returns (uint256) { return _tTotal; }
450     function decimals() external view returns (uint8) { return _decimals; }
451     function symbol() external view returns (string memory) { return _symbol; }
452     function name() external view returns (string memory) { return _name; }
453     function getOwner() external view returns (address) { return owner(); }
454     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
455 
456     function balanceOf(address account) public view override returns (uint256) {
457         if (_isExcluded[account]) return _tOwned[account];
458         return tokenFromReflection(_rOwned[account]);
459     }
460 
461     function transfer(address recipient, uint256 amount) public override returns (bool) {
462         _transfer(_msgSender(), recipient, amount);
463         return true;
464     }
465 
466     function approve(address spender, uint256 amount) public override returns (bool) {
467         _approve(_msgSender(), spender, amount);
468         return true;
469     }
470 
471     function approveMax(address spender) public returns (bool) {
472         return approve(spender, type(uint256).max);
473     }
474 
475     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
476         _transfer(sender, recipient, amount);
477         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
478         return true;
479     }
480 
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
483         return true;
484     }
485 
486     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
487         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
488         return true;
489     }
490 
491     function setNewRouter(address newRouter) external onlyOwner() {
492         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
493         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
494         if (get_pair == address(0)) {
495             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
496         }
497         else {
498             lpPair = get_pair;
499         }
500         dexRouter = _newRouter;
501         _approve(address(this), newRouter, MAX);
502     }
503 
504     function setLpPair(address pair, bool enabled) external onlyOwner {
505         if (enabled == false) {
506             lpPairs[pair] = false;
507         } else {
508             if (timeSinceLastPair != 0) {
509                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
510             }
511             lpPairs[pair] = true;
512             timeSinceLastPair = block.timestamp;
513         }
514     }
515 
516     function isExcludedFromReward(address account) public view returns (bool) {
517         return _isExcluded[account];
518     }
519 
520     function isExcludedFromFee(address account) public view returns(bool) {
521         return _isExcludedFromFee[account];
522     }
523 
524     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
525         require(reflect <= maxReflectFee
526                 && liquidity <= maxLiquidityFee
527                 && marketing <= maxMarketingFee
528                 );
529         require(reflect + liquidity + marketing <= 4900);
530         _buyReflectFee = reflect;
531         _buyLiquidityFee = liquidity;
532         _buyMarketingFee = marketing;
533     }
534 
535     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
536         require(reflect <= maxReflectFee
537                 && liquidity <= maxLiquidityFee
538                 && marketing <= maxMarketingFee
539                 );
540         require(reflect + liquidity + marketing <= 4900);
541         _sellReflectFee = reflect;
542         _sellLiquidityFee = liquidity;
543         _sellMarketingFee = marketing;
544     }
545 
546     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
547         require(reflect <= maxReflectFee
548                 && liquidity <= maxLiquidityFee
549                 && marketing <= maxMarketingFee
550                 );
551         require(reflect + liquidity + marketing <= 4900);
552         _transferReflectFee = reflect;
553         _transferLiquidityFee = liquidity;
554         _transferMarketingFee = marketing;
555     }
556 
557     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
558         MarketShare = ms;
559         DevShare = ds;
560         ValueDivisor = vd;
561     }
562 
563     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
564         _liquidityRatio = liquidity;
565         _marketingRatio = marketing;
566     }
567 
568     function MaxTx(uint256 percent, uint256 divisor) external onlyOwner {
569         uint256 check = (_tTotal * percent) / divisor;
570         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
571         _maxTxAmount = check;
572         maxTxAmountUI = (startingSupply * percent) / divisor;
573     }
574 
575     function WalletSize(uint256 percent, uint256 divisor) external onlyOwner {
576         uint256 check = (_tTotal * percent) / divisor;
577         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
578         _maxWalletSize = check;
579         maxWalletSizeUI = (startingSupply * percent) / divisor;
580     }
581 
582     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
583         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
584         swapAmount = (_tTotal * amountPercent) / amountDivisor;
585     }
586 
587     function NewMarketWallet(address payable newWallet) external onlyOwner {
588         require(_marketWallet != newWallet, "Wallet already set!");
589         _marketWallet = payable(newWallet);
590     }
591 
592     function NewDevWallet(address payable newWallet) external onlyOwner {
593         require(_devWallet != newWallet, "Wallet already set!");
594         _devWallet = payable(newWallet);
595     }
596     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
597         swapAndLiquifyEnabled = _enabled;
598         emit SwapAndLiquifyEnabledUpdated(_enabled);
599     }
600 
601     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
602         _isExcludedFromFee[account] = enabled;
603     }
604 
605     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
606         if (enabled == true) {
607             require(!_isExcluded[account], "Account is already excluded.");
608             if(_rOwned[account] > 0) {
609                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
610             }
611             _isExcluded[account] = true;
612             _excluded.push(account);
613         } else if (enabled == false) {
614             require(_isExcluded[account], "Account is already included.");
615             for (uint256 i = 0; i < _excluded.length; i++) {
616                 if (_excluded[i] == account) {
617                     _excluded[i] = _excluded[_excluded.length - 1];
618                     _tOwned[account] = 0;
619                     _isExcluded[account] = false;
620                     _excluded.pop();
621                     break;
622                 }
623             }
624         }
625     }
626 
627     function totalFees() public view returns (uint256) {
628         return _tFeeTotal;
629     }
630 
631     function _hasLimits(address from, address to) internal view returns (bool) {
632         return from != owner()
633             && to != owner()
634             && !_liquidityHolders[to]
635             && !_liquidityHolders[from]
636             && to != DEAD
637             && to != address(0)
638             && from != address(this);
639     }
640 
641     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
642         require(rAmount <= _rTotal, "Amount must be less than total reflections");
643         uint256 currentRate =  _getRate();
644         return rAmount / currentRate;
645     }
646     
647     function _approve(address sender, address spender, uint256 amount) internal {
648         require(sender != address(0), "ERC20: approve from the zero address");
649         require(spender != address(0), "ERC20: approve to the zero address");
650 
651         _allowances[sender][spender] = amount;
652         emit Approval(sender, spender, amount);
653     }
654 
655     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
656         require(from != address(0), "ERC20: transfer from the zero address");
657         require(to != address(0), "ERC20: transfer to the zero address");
658         require(amount > 0, "Transfer amount must be greater than zero");
659         if(_hasLimits(from, to)) {
660             if(!tradingEnabled) {
661                 revert("Trading not yet enabled!");
662             }
663             if (sameBlockActive) {
664                 if (lpPairs[from]){
665                     require(lastTrade[to] != block.number);
666                     lastTrade[to] = block.number;
667                 } else {
668                     require(lastTrade[from] != block.number);
669                     lastTrade[from] = block.number;
670                 }
671             }
672             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
673             if(to != _routerAddress && !lpPairs[to]) {
674                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
675             }
676         }
677         bool takeFee = true;
678         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
679             takeFee = false;
680         }
681 
682         if (lpPairs[to]) {
683             if (!inSwapAndLiquify
684                 && swapAndLiquifyEnabled
685             ) {
686                 uint256 contractTokenBalance = balanceOf(address(this));
687                 if (contractTokenBalance >= swapThreshold) {
688                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
689                     swapAndLiquify(contractTokenBalance);
690                 }
691             }      
692         } 
693         return _finalizeTransfer(from, to, amount, takeFee);
694     }
695 
696     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
697         if (_liquidityRatio + _marketingRatio == 0)
698             return;
699         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
700 
701         uint256 toSwapForEth = contractTokenBalance - toLiquify;
702 
703         address[] memory path = new address[](2);
704         path[0] = address(this);
705         path[1] = dexRouter.WETH();
706 
707         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
708             toSwapForEth,
709             0,
710             path,
711             address(this),
712             block.timestamp
713         );
714 
715 
716         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
717 
718         if (toLiquify > 0) {
719             dexRouter.addLiquidityETH{value: liquidityBalance}(
720                 address(this),
721                 toLiquify,
722                 0, 
723                 0, 
724                 DEAD,
725                 block.timestamp
726             );
727             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
728         }
729         if (contractTokenBalance - toLiquify > 0) {
730 
731             uint256 OperationsFee = (address(this).balance);
732             uint256 marketFee = OperationsFee/(ValueDivisor)*(MarketShare);
733             uint256 devfeeshare = OperationsFee/(ValueDivisor)*(DevShare);
734             _marketWallet.transfer(marketFee);
735             _devWallet.transfer(devfeeshare);            
736 
737         }
738     }
739 
740     
741 
742     function _checkLiquidityAdd(address from, address to) internal {
743         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
744         if (!_hasLimits(from, to) && to == lpPair) {
745             _liquidityHolders[from] = true;
746             _hasLiqBeenAdded = true;
747             _liqAddStamp = block.timestamp;
748 
749             swapAndLiquifyEnabled = true;
750             emit SwapAndLiquifyEnabledUpdated(true);
751         }
752     }
753 
754     function enableTrading() public onlyOwner {
755         require(!tradingEnabled, "Trading already enabled!");
756         setExcludedFromReward(address(this), true);
757         setExcludedFromReward(lpPair, true);
758 
759         tradingEnabled = true;
760         swapAndLiquifyEnabled = true;
761     }
762 
763     struct ExtraValues {
764         uint256 tTransferAmount;
765         uint256 tFee;
766         uint256 tLiquidity;
767 
768         uint256 rTransferAmount;
769         uint256 rAmount;
770         uint256 rFee;
771     }
772 
773     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
774 
775 
776         if (!_hasLiqBeenAdded) {
777                 _checkLiquidityAdd(from, to);
778                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
779                     revert("Only owner can transfer at this time.");
780                 }
781         }
782         
783         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
784 
785         _rOwned[from] = _rOwned[from] - values.rAmount;
786         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
787 
788         if (_isExcluded[from] && !_isExcluded[to]) {
789             _tOwned[from] = _tOwned[from] - tAmount;
790         } else if (!_isExcluded[from] && _isExcluded[to]) {
791             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
792         } else if (_isExcluded[from] && _isExcluded[to]) {
793             _tOwned[from] = _tOwned[from] - tAmount;
794             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
795         }
796 
797         if (values.tLiquidity > 0)
798             _takeLiquidity(from, values.tLiquidity);
799         if (values.rFee > 0 || values.tFee > 0)
800             _takeReflect(values.rFee, values.tFee);
801 
802         emit Transfer(from, to, values.tTransferAmount);
803         return true;
804     }
805 
806     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
807         ExtraValues memory values;
808         uint256 currentRate = _getRate();
809 
810         values.rAmount = tAmount * currentRate;
811 
812         if(takeFee) {
813             if (lpPairs[to]) {
814                 _reflectFee = _sellReflectFee;
815                 _liquidityFee = _sellLiquidityFee;
816                 _marketingFee = _sellMarketingFee;
817             } else if (lpPairs[from]) {
818                 _reflectFee = _buyReflectFee;
819                 _liquidityFee = _buyLiquidityFee;
820                 _marketingFee = _buyMarketingFee;
821             } else {
822                 _reflectFee = _transferReflectFee;
823                 _liquidityFee = _transferLiquidityFee;
824                 _marketingFee = _transferMarketingFee;
825             }
826 
827             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
828             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
829             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
830 
831             values.rFee = values.tFee * currentRate;
832         } else {
833             values.tFee = 0;
834             values.tLiquidity = 0;
835             values.tTransferAmount = tAmount;
836 
837             values.rFee = 0;
838         }
839 
840         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
841         return values;
842     }
843 
844     function _getRate() internal view returns(uint256) {
845         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
846         return rSupply / tSupply;
847     }
848 
849     function _getCurrentSupply() internal view returns(uint256, uint256) {
850         uint256 rSupply = _rTotal;
851         uint256 tSupply = _tTotal;
852         for (uint256 i = 0; i < _excluded.length; i++) {
853             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
854             rSupply = rSupply - _rOwned[_excluded[i]];
855             tSupply = tSupply - _tOwned[_excluded[i]];
856         }
857         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
858         return (rSupply, tSupply);
859     }
860     
861     function _takeReflect(uint256 rFee, uint256 tFee) internal {
862         _rTotal = _rTotal - rFee;
863         _tFeeTotal = _tFeeTotal + tFee;
864     }
865 
866     function takeETHback() external onlyOwner {
867         payable(owner()).transfer(address(this).balance);
868     }
869     
870     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
871         uint256 currentRate =  _getRate();
872         uint256 rLiquidity = tLiquidity * currentRate;
873         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
874         if(_isExcluded[address(this)])
875             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
876         emit Transfer(sender, address(this), tLiquidity); 
877     }
878 }