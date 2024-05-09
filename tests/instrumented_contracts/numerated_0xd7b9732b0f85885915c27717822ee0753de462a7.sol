1 /*
2 
3 Shinjew $JEW
4 Web: www.shinjew.com
5 telegram: t.me/Shinjew
6 twitter: twitter.com/Shinjew_ERC20
7 
8 */
9 	 
10 // SPDX-License-Identifier: MIT
11 pragma solidity >=0.6.0 <0.9.0;
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
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20Upgradeable {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 library Address {
104     function isContract(address account) internal view returns (bool) {
105         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
106         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
107         // for accounts without code, i.e. `keccak256('')`
108         bytes32 codehash;
109         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
110         // solhint-disable-next-line no-inline-assembly
111         assembly { codehash := extcodehash(account) }
112         return (codehash != accountHash && codehash != 0x0);
113     }
114 
115     function sendValue(address payable recipient, uint256 amount) internal {
116         require(address(this).balance >= amount, "Address: insufficient balance");
117 
118         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
119         (bool success, ) = recipient.call{ value: amount }("");
120         require(success, "Address: unable to send value, recipient may have reverted");
121     }
122 
123     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
124         return functionCall(target, data, "Address: low-level call failed");
125     }
126 
127     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
128         return _functionCallWithValue(target, data, 0, errorMessage);
129     }
130 
131 
132     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
134     }
135 
136     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         return _functionCallWithValue(target, data, value, errorMessage);
139     }
140 
141     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
142         require(isContract(target), "Address: call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
146         if (success) {
147             return returndata;
148         } else {
149             // Look for revert reason and bubble it up if present
150             if (returndata.length > 0) {
151                 // The easiest way to bubble the revert reason is using memory via assembly
152 
153                 // solhint-disable-next-line no-inline-assembly
154                 assembly {
155                     let returndata_size := mload(returndata)
156                     revert(add(32, returndata), returndata_size)
157                 }
158             } else {
159                 revert(errorMessage);
160             }
161         }
162     }
163 }
164 
165 interface IUniswapV2Factory {
166     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
167     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
168     function createPair(address tokenA, address tokenB) external returns (address lpPair);
169 }
170 
171 interface IUniswapV2Router01 {
172     function factory() external pure returns (address);
173     function WETH() external pure returns (address);
174     function addLiquidityETH(
175         address token,
176         uint amountTokenDesired,
177         uint amountTokenMin,
178         uint amountETHMin,
179         address to,
180         uint deadline
181     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
182 }
183 
184 interface IUniswapV2Router02 is IUniswapV2Router01 {
185     function removeLiquidityETHSupportingFeeOnTransferTokens(
186         address token,
187         uint liquidity,
188         uint amountTokenMin,
189         uint amountETHMin,
190         address to,
191         uint deadline
192     ) external returns (uint amountETH);
193     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
194         address token,
195         uint liquidity,
196         uint amountTokenMin,
197         uint amountETHMin,
198         address to,
199         uint deadline,
200         bool approveMax, uint8 v, bytes32 r, bytes32 s
201     ) external returns (uint amountETH);
202 
203     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
204         uint amountIn,
205         uint amountOutMin,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external;
210     function swapExactETHForTokensSupportingFeeOnTransferTokens(
211         uint amountOutMin,
212         address[] calldata path,
213         address to,
214         uint deadline
215     ) external payable;
216     function swapExactTokensForETHSupportingFeeOnTransferTokens(
217         uint amountIn,
218         uint amountOutMin,
219         address[] calldata path,
220         address to,
221         uint deadline
222     ) external;
223 }
224 
225 contract ShinJew is Context, IERC20Upgradeable {
226     // Ownership moved to in-contract for customizability.
227     address private _owner;
228 
229     mapping (address => uint256) private _rOwned;
230     mapping (address => uint256) private _tOwned;
231     mapping (address => bool) lpPairs;
232     uint256 private timeSinceLastPair = 0;
233     mapping (address => mapping (address => uint256)) private _allowances;
234 
235     mapping (address => bool) private _isExcludedFromFee;
236     mapping (address => bool) private _isExcluded;
237     address[] private _excluded;
238 
239     mapping (address => bool) private _liquidityHolders;
240    
241     uint256 private startingSupply;
242     uint256 private routerSupply;
243 
244     string private _name;
245     string private _symbol;
246 
247     uint256 public _reflectFee = 0;
248     uint256 public _liquidityFee = 100;
249     uint256 public _marketingFee = 600;
250 
251     uint256 public _buyReflectFee = _reflectFee;
252     uint256 public _buyLiquidityFee = _liquidityFee;
253     uint256 public _buyMarketingFee = _marketingFee;
254 
255     uint256 public _sellReflectFee = 0;
256     uint256 public _sellLiquidityFee = 100;
257     uint256 public _sellMarketingFee = 1300;
258     
259     uint256 public _transferReflectFee = _buyReflectFee;
260     uint256 public _transferLiquidityFee = _buyLiquidityFee;
261     uint256 public _transferMarketingFee = _buyMarketingFee;
262     
263     uint256 private maxReflectFee = 1000;
264     uint256 private maxLiquidityFee = 1000;
265     uint256 private maxMarketingFee = 2200;
266 
267     uint256 public _liquidityRatio = 100;
268     uint256 public _marketingRatio = 1300;
269 
270     uint256 private masterTaxDivisor = 10000;
271 
272     uint256 public MarketShare = 7;
273     uint256 public DevShare = 6;
274     uint256 public ValueDivisor = 13;
275 
276     uint256 private constant MAX = ~uint256(0);
277     uint8 private _decimals;
278     uint256 private _decimalsMul;
279     uint256 private _tTotal;
280     uint256 private _rTotal;
281     uint256 private _tFeeTotal;
282 
283     IUniswapV2Router02 public dexRouter;
284     address public lpPair;
285 
286     // UNI ROUTER
287     address public _routerAddress;
288 
289     address public DEAD = 0x000000000000000000000000000000000000dEaD;
290     address public ZERO = 0x0000000000000000000000000000000000000000;
291     address payable private _devWallet;
292     address payable private _marketWallet;
293     
294     bool inSwapAndLiquify;
295     bool public swapAndLiquifyEnabled = false;
296     
297     uint256 private _maxTxAmount;
298     uint256 public maxTxAmountUI;
299 
300     uint256 private _maxWalletSize;
301     uint256 public maxWalletSizeUI;
302 
303     uint256 private swapThreshold;
304     uint256 private swapAmount;
305 
306     bool tradingEnabled = false;
307 
308     bool public _hasLiqBeenAdded = false;
309     uint256 private _liqAddBlock = 0;
310     uint256 private _liqAddStamp = 0;
311     bool private sameBlockActive = true;
312     mapping (address => uint256) private lastTrade;
313 
314     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
315     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
316     event SwapAndLiquifyEnabledUpdated(bool enabled);
317     event SwapAndLiquify(
318         uint256 tokensSwapped,
319         uint256 ethReceived,
320         uint256 tokensIntoLiqudity
321     );
322     event SniperCaught(address sniperAddress);
323     uint256 Planted;
324     
325     bool contractInitialized = false;
326     
327     modifier lockTheSwap {
328         inSwapAndLiquify = true;
329         _;
330         inSwapAndLiquify = false;
331     }
332 
333     modifier onlyOwner() {
334         require(_owner == _msgSender(), "Ownable: caller is not the owner");
335         _;
336     }
337     
338     constructor () payable {
339         // Set the owner.
340         _owner = msg.sender;
341 
342         if (block.chainid == 56) {
343             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
344         } else if (block.chainid == 97) {
345             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
346         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
347             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
348         } else {
349             revert();
350         }
351 
352         _isExcludedFromFee[owner()] = true;
353         _isExcludedFromFee[address(this)] = true;
354         _liquidityHolders[owner()] = true;
355 
356         _approve(_msgSender(), _routerAddress, MAX);
357         _approve(address(this), _routerAddress, MAX);
358 
359     }
360 
361     receive() external payable {}
362 
363     function intializeContract(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
364         require(!contractInitialized);
365 
366         _marketWallet = payable(setMarketWallet);
367         _devWallet = payable(setDevWallet);
368 
369         _name = _tokenname;
370         _symbol = _tokensymbol;
371         startingSupply = 69_000_000_000;
372         if (startingSupply < 100000000000) {
373             _decimals = 18;
374             _decimalsMul = _decimals;
375         } else {
376             _decimals = 9;
377             _decimalsMul = _decimals;
378         }
379         _tTotal = startingSupply * (10**_decimalsMul);
380         _rTotal = (MAX - (MAX % _tTotal));
381         routerSupply = _tTotal/69*56;
382 
383         dexRouter = IUniswapV2Router02(_routerAddress);
384         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
385         lpPairs[lpPair] = true;
386         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
387         
388         _maxTxAmount = (_tTotal * 500) / 100000;
389         maxTxAmountUI = (startingSupply * 500) / 100000;
390         _maxWalletSize = (_tTotal * 10) / 1000;
391         maxWalletSizeUI = (startingSupply * 5) / 1000;
392         swapThreshold = (_tTotal * 5) / 10000;
393         swapAmount = (_tTotal * 5) / 1000;
394 
395         approve(_routerAddress, type(uint256).max);
396 
397         contractInitialized = true;
398         _rOwned[owner()] = _rTotal;
399         emit Transfer(ZERO, owner(), _tTotal);
400 
401         _approve(address(this), address(dexRouter), type(uint256).max);
402 
403         _transfer(owner(), address(this),routerSupply);
404 
405 
406         
407 
408         dexRouter.addLiquidityETH{value: address(this).balance}(
409             address(this),
410             balanceOf(address(this)),
411             0, 
412             0, 
413             owner(),
414             block.timestamp
415         );
416         Planted = block.number;
417     }
418 
419 //===============================================================================================================
420 //===============================================================================================================
421 //===============================================================================================================
422     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
423     // This allows for removal of ownership privelages from the owner once renounced or transferred.
424     function owner() public view returns (address) {
425         return _owner;
426     }
427 
428     function transferOwner(address newOwner) external onlyOwner() {
429         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
430         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
431         setExcludedFromFee(_owner, false);
432         setExcludedFromFee(newOwner, true);
433         setExcludedFromReward(newOwner, true);
434         
435         if (_devWallet == payable(_owner))
436             _devWallet = payable(newOwner);
437         
438         _allowances[_owner][newOwner] = balanceOf(_owner);
439         if(balanceOf(_owner) > 0) {
440             _transfer(_owner, newOwner, balanceOf(_owner));
441         }
442         
443         _owner = newOwner;
444         emit OwnershipTransferred(_owner, newOwner);
445         
446     }
447 
448     function renounceOwnership() public virtual onlyOwner() {
449         setExcludedFromFee(_owner, false);
450         _owner = address(0);
451         emit OwnershipTransferred(_owner, address(0));
452     }
453 //===============================================================================================================
454 //===============================================================================================================
455 //===============================================================================================================
456 
457     function totalSupply() external view override returns (uint256) { return _tTotal; }
458     function decimals() external view returns (uint8) { return _decimals; }
459     function symbol() external view returns (string memory) { return _symbol; }
460     function name() external view returns (string memory) { return _name; }
461     function getOwner() external view returns (address) { return owner(); }
462     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
463 
464     function balanceOf(address account) public view override returns (uint256) {
465         if (_isExcluded[account]) return _tOwned[account];
466         return tokenFromReflection(_rOwned[account]);
467     }
468 
469     function transfer(address recipient, uint256 amount) public override returns (bool) {
470         _transfer(_msgSender(), recipient, amount);
471         return true;
472     }
473 
474     function approve(address spender, uint256 amount) public override returns (bool) {
475         _approve(_msgSender(), spender, amount);
476         return true;
477     }
478 
479     function approveMax(address spender) public returns (bool) {
480         return approve(spender, type(uint256).max);
481     }
482 
483     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
484         _transfer(sender, recipient, amount);
485         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
486         return true;
487     }
488 
489     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
491         return true;
492     }
493 
494     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
496         return true;
497     }
498 
499     function FirstBuyandWalletLimitsIncrease() public onlyOwner() {
500         _maxTxAmount = _tTotal/(1000)*(200);
501         _maxWalletSize = _tTotal/(1000)*(200);
502     }
503 
504     function FirstTaxLowering()
505         external
506         onlyOwner
507     {
508         _sellReflectFee = 0;
509         _sellLiquidityFee = 100;
510         _sellMarketingFee = 600;
511         _buyReflectFee = 0;
512         _buyLiquidityFee = 100;
513         _buyMarketingFee = 600;
514         MarketShare = 3;
515         DevShare = 3;
516         ValueDivisor = 6;
517     }
518 
519     function SecondTaxLowering()
520         external
521         onlyOwner
522     {
523         _sellReflectFee = 0;
524         _sellLiquidityFee = 100;
525         _sellMarketingFee = 300;
526         _buyReflectFee = 0;
527         _buyLiquidityFee = 100;
528         _buyMarketingFee = 300;
529         MarketShare = 2;
530         DevShare = 1;
531         ValueDivisor = 3;
532     }
533 
534     function setNewRouter(address newRouter) external onlyOwner() {
535         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
536         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
537         if (get_pair == address(0)) {
538             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
539         }
540         else {
541             lpPair = get_pair;
542         }
543         dexRouter = _newRouter;
544         _approve(address(this), newRouter, MAX);
545     }
546 
547     function setLpPair(address pair, bool enabled) external onlyOwner {
548         if (enabled == false) {
549             lpPairs[pair] = false;
550         } else {
551             if (timeSinceLastPair != 0) {
552                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
553             }
554             lpPairs[pair] = true;
555             timeSinceLastPair = block.timestamp;
556         }
557     }
558 
559     function isExcludedFromReward(address account) public view returns (bool) {
560         return _isExcluded[account];
561     }
562 
563     function isExcludedFromFee(address account) public view returns(bool) {
564         return _isExcludedFromFee[account];
565     }
566 
567     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
568         require(reflect <= maxReflectFee
569                 && liquidity <= maxLiquidityFee
570                 && marketing <= maxMarketingFee
571                 );
572         require(reflect + liquidity + marketing <= 4900);
573         _buyReflectFee = reflect;
574         _buyLiquidityFee = liquidity;
575         _buyMarketingFee = marketing;
576     }
577 
578     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
579         require(reflect <= maxReflectFee
580                 && liquidity <= maxLiquidityFee
581                 && marketing <= maxMarketingFee
582                 );
583         require(reflect + liquidity + marketing <= 4900);
584         _sellReflectFee = reflect;
585         _sellLiquidityFee = liquidity;
586         _sellMarketingFee = marketing;
587     }
588 
589     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
590         require(reflect <= maxReflectFee
591                 && liquidity <= maxLiquidityFee
592                 && marketing <= maxMarketingFee
593                 );
594         require(reflect + liquidity + marketing <= 4900);
595         _transferReflectFee = reflect;
596         _transferLiquidityFee = liquidity;
597         _transferMarketingFee = marketing;
598     }
599 
600     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
601         MarketShare = ms;
602         DevShare = ds;
603         ValueDivisor = vd;
604     }
605 
606     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
607         _liquidityRatio = liquidity;
608         _marketingRatio = marketing;
609     }
610 
611     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
612         uint256 check = (_tTotal * percent) / divisor;
613         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
614         _maxTxAmount = check;
615         maxTxAmountUI = (startingSupply * percent) / divisor;
616     }
617 
618     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
619         uint256 check = (_tTotal * percent) / divisor;
620         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
621         _maxWalletSize = check;
622         maxWalletSizeUI = (startingSupply * percent) / divisor;
623     }
624 
625     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
626         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
627         swapAmount = (_tTotal * amountPercent) / amountDivisor;
628     }
629 
630     function setNewMarketWallet(address payable newWallet) external onlyOwner {
631         require(_marketWallet != newWallet, "Wallet already set!");
632         _marketWallet = payable(newWallet);
633     }
634 
635     function setNewDevWallet(address payable newWallet) external onlyOwner {
636         require(_devWallet != newWallet, "Wallet already set!");
637         _devWallet = payable(newWallet);
638     }
639     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
640         swapAndLiquifyEnabled = _enabled;
641         emit SwapAndLiquifyEnabledUpdated(_enabled);
642     }
643 
644     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
645         _isExcludedFromFee[account] = enabled;
646     }
647 
648     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
649         if (enabled == true) {
650             require(!_isExcluded[account], "Account is already excluded.");
651             if(_rOwned[account] > 0) {
652                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
653             }
654             _isExcluded[account] = true;
655             _excluded.push(account);
656         } else if (enabled == false) {
657             require(_isExcluded[account], "Account is already included.");
658             for (uint256 i = 0; i < _excluded.length; i++) {
659                 if (_excluded[i] == account) {
660                     _excluded[i] = _excluded[_excluded.length - 1];
661                     _tOwned[account] = 0;
662                     _isExcluded[account] = false;
663                     _excluded.pop();
664                     break;
665                 }
666             }
667         }
668     }
669 
670     function totalFees() public view returns (uint256) {
671         return _tFeeTotal;
672     }
673 
674     function _hasLimits(address from, address to) internal view returns (bool) {
675         return from != owner()
676             && to != owner()
677             && !_liquidityHolders[to]
678             && !_liquidityHolders[from]
679             && to != DEAD
680             && to != address(0)
681             && from != address(this);
682     }
683 
684     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
685         require(rAmount <= _rTotal, "Amount must be less than total reflections");
686         uint256 currentRate =  _getRate();
687         return rAmount / currentRate;
688     }
689     
690     function _approve(address sender, address spender, uint256 amount) internal {
691         require(sender != address(0), "ERC20: approve from the zero address");
692         require(spender != address(0), "ERC20: approve to the zero address");
693 
694         _allowances[sender][spender] = amount;
695         emit Approval(sender, spender, amount);
696     }
697 
698     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
699         require(from != address(0), "ERC20: transfer from the zero address");
700         require(to != address(0), "ERC20: transfer to the zero address");
701         require(amount > 0, "Transfer amount must be greater than zero");
702         if(_hasLimits(from, to)) {
703             if(!tradingEnabled) {
704                 revert("Trading not yet enabled!");
705             }
706             if (sameBlockActive) {
707                 if (lpPairs[from]){
708                     require(lastTrade[to] != block.number);
709                     lastTrade[to] = block.number;
710                 } else {
711                     require(lastTrade[from] != block.number);
712                     lastTrade[from] = block.number;
713                 }
714             }
715             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
716             if(to != _routerAddress && !lpPairs[to]) {
717                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
718             }
719         }
720         bool takeFee = true;
721         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
722             takeFee = false;
723         }
724 
725         if (lpPairs[to]) {
726             if (!inSwapAndLiquify
727                 && swapAndLiquifyEnabled
728             ) {
729                 uint256 contractTokenBalance = balanceOf(address(this));
730                 if (contractTokenBalance >= swapThreshold) {
731                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
732                     swapAndLiquify(contractTokenBalance);
733                 }
734             }      
735         } 
736         return _finalizeTransfer(from, to, amount, takeFee);
737     }
738 
739     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
740         if (_liquidityRatio + _marketingRatio == 0)
741             return;
742         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
743 
744         uint256 toSwapForEth = contractTokenBalance - toLiquify;
745 
746         address[] memory path = new address[](2);
747         path[0] = address(this);
748         path[1] = dexRouter.WETH();
749 
750         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
751             toSwapForEth,
752             0,
753             path,
754             address(this),
755             block.timestamp
756         );
757 
758 
759         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
760 
761         if (toLiquify > 0) {
762             dexRouter.addLiquidityETH{value: liquidityBalance}(
763                 address(this),
764                 toLiquify,
765                 0, 
766                 0, 
767                 DEAD,
768                 block.timestamp
769             );
770             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
771         }
772         if (contractTokenBalance - toLiquify > 0) {
773 
774             uint256 OperationsFee = (address(this).balance);
775             uint256 marketFee = OperationsFee/(ValueDivisor)*(MarketShare);
776             uint256 devfeeshare = OperationsFee/(ValueDivisor)*(DevShare);
777             _marketWallet.transfer(marketFee);
778             _devWallet.transfer(devfeeshare);            
779 
780         }
781     }
782 
783     
784 
785     function _checkLiquidityAdd(address from, address to) internal {
786         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
787         if (!_hasLimits(from, to) && to == lpPair) {
788             _liquidityHolders[from] = true;
789             _hasLiqBeenAdded = true;
790             _liqAddStamp = block.timestamp;
791 
792             swapAndLiquifyEnabled = true;
793             emit SwapAndLiquifyEnabledUpdated(true);
794         }
795     }
796 
797     function enableTrading() public onlyOwner {
798         require(!tradingEnabled, "Trading already enabled!");
799         setExcludedFromReward(address(this), true);
800         setExcludedFromReward(lpPair, true);
801 
802         tradingEnabled = true;
803         swapAndLiquifyEnabled = true;
804     }
805 
806     struct ExtraValues {
807         uint256 tTransferAmount;
808         uint256 tFee;
809         uint256 tLiquidity;
810 
811         uint256 rTransferAmount;
812         uint256 rAmount;
813         uint256 rFee;
814     }
815 
816     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
817 
818 
819         if (!_hasLiqBeenAdded) {
820                 _checkLiquidityAdd(from, to);
821                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
822                     revert("Only owner can transfer at this time.");
823                 }
824         }
825 
826         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
827 
828         _rOwned[from] = _rOwned[from] - values.rAmount;
829         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
830 
831         if (_isExcluded[from] && !_isExcluded[to]) {
832             _tOwned[from] = _tOwned[from] - tAmount;
833         } else if (!_isExcluded[from] && _isExcluded[to]) {
834             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
835         } else if (_isExcluded[from] && _isExcluded[to]) {
836             _tOwned[from] = _tOwned[from] - tAmount;
837             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
838         }
839 
840         if (values.tLiquidity > 0)
841             _takeLiquidity(from, values.tLiquidity);
842         if (values.rFee > 0 || values.tFee > 0)
843             _takeReflect(values.rFee, values.tFee);
844 
845         emit Transfer(from, to, values.tTransferAmount);
846         return true;
847     }
848 
849     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
850         ExtraValues memory values;
851         uint256 currentRate = _getRate();
852 
853         values.rAmount = tAmount * currentRate;
854 
855         if(takeFee) {
856             if (lpPairs[to]) {
857                 _reflectFee = _sellReflectFee;
858                 _liquidityFee = _sellLiquidityFee;
859                 _marketingFee = _sellMarketingFee;
860             } else if (lpPairs[from]) {
861                 _reflectFee = _buyReflectFee;
862                 _liquidityFee = _buyLiquidityFee;
863                 _marketingFee = _buyMarketingFee;
864             } else {
865                 _reflectFee = _transferReflectFee;
866                 _liquidityFee = _transferLiquidityFee;
867                 _marketingFee = _transferMarketingFee;
868             }
869 
870             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
871             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
872             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
873 
874             values.rFee = values.tFee * currentRate;
875         } else {
876             values.tFee = 0;
877             values.tLiquidity = 0;
878             values.tTransferAmount = tAmount;
879 
880             values.rFee = 0;
881         }
882 
883         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
884         return values;
885     }
886 
887     function _getRate() internal view returns(uint256) {
888         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
889         return rSupply / tSupply;
890     }
891 
892     function _getCurrentSupply() internal view returns(uint256, uint256) {
893         uint256 rSupply = _rTotal;
894         uint256 tSupply = _tTotal;
895         for (uint256 i = 0; i < _excluded.length; i++) {
896             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
897             rSupply = rSupply - _rOwned[_excluded[i]];
898             tSupply = tSupply - _tOwned[_excluded[i]];
899         }
900         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
901         return (rSupply, tSupply);
902     }
903     
904     function _takeReflect(uint256 rFee, uint256 tFee) internal {
905         _rTotal = _rTotal - rFee;
906         _tFeeTotal = _tFeeTotal + tFee;
907     }
908 
909     function rescueETH() external onlyOwner {
910         payable(owner()).transfer(address(this).balance);
911     }
912     
913     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
914         uint256 currentRate =  _getRate();
915         uint256 rLiquidity = tLiquidity * currentRate;
916         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
917         if(_isExcluded[address(this)])
918             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
919         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
920     }
921 }