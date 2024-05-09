1 /*
2 TG: https://t.me/RickMortyERC
3 
4 Twitter: https://twitter.com/RickMortyERC
5 
6 Website: https://RickMortyERC.com
7 */
8 
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
225 contract RickMorty is Context, IERC20Upgradeable {
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
242 
243     string private _name;
244     string private _symbol;
245 
246     uint256 public _reflectFee = 0;
247     uint256 public _liquidityFee = 200;
248     uint256 public _marketingFee = 300;
249 
250     uint256 public _buyReflectFee = _reflectFee;
251     uint256 public _buyLiquidityFee = _liquidityFee;
252     uint256 public _buyMarketingFee = _marketingFee;
253 
254     uint256 public _sellReflectFee = 0;
255     uint256 public _sellLiquidityFee = 500;
256     uint256 public _sellMarketingFee = 2500;
257     
258     uint256 public _transferReflectFee = 0;
259     uint256 public _transferLiquidityFee = 100;
260     uint256 public _transferMarketingFee = 0;
261     
262     uint256 private maxReflectFee = 1000;
263     uint256 private maxLiquidityFee = 1000;
264     uint256 private maxMarketingFee = 2500;
265 
266     uint256 public _liquidityRatio = 0;
267     uint256 public _marketingRatio = 0;
268 
269     uint256 private masterTaxDivisor = 10000;
270 
271     uint256 public MarketShare = 1;
272     uint256 public DevShare = 1;
273     uint256 public ValueDivisor = 2;
274 
275     uint256 private constant MAX = ~uint256(0);
276     uint8 private _decimals;
277     uint256 private _decimalsMul;
278     uint256 private _tTotal;
279     uint256 private _rTotal;
280     uint256 private _tFeeTotal;
281 
282     IUniswapV2Router02 public dexRouter;
283     address public lpPair;
284 
285     // UNI ROUTER
286     address public _routerAddress;
287 
288     address public DEAD = 0x000000000000000000000000000000000000dEaD;
289     address public ZERO = 0x0000000000000000000000000000000000000000;
290     address payable private _devWallet;
291     address payable private _marketWallet;
292     
293     bool inSwapAndLiquify;
294     bool public swapAndLiquifyEnabled = false;
295     
296     uint256 private _maxTxAmount;
297     uint256 public maxTxAmountUI;
298 
299     uint256 private _maxWalletSize;
300     uint256 public maxWalletSizeUI;
301 
302     uint256 private swapThreshold;
303     uint256 private swapAmount;
304 
305     bool tradingEnabled = false;
306 
307     bool public _hasLiqBeenAdded = false;
308     uint256 private _liqAddBlock = 0;
309     uint256 private _liqAddStamp = 0;
310     bool private sameBlockActive = true;
311     mapping (address => uint256) private lastTrade;
312 
313     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
314     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
315     event SwapAndLiquifyEnabledUpdated(bool enabled);
316     event SwapAndLiquify(
317         uint256 tokensSwapped,
318         uint256 ethReceived,
319         uint256 tokensIntoLiqudity
320     );
321     event SniperCaught(address sniperAddress);
322     uint256 Planted;
323     
324     bool contractInitialized = false;
325     
326     modifier lockTheSwap {
327         inSwapAndLiquify = true;
328         _;
329         inSwapAndLiquify = false;
330     }
331 
332     modifier onlyOwner() {
333         require(_owner == _msgSender(), "Ownable: caller is not the owner");
334         _;
335     }
336     
337     constructor () payable {
338         // Set the owner.
339         _owner = msg.sender;
340 
341         if (block.chainid == 56) {
342             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
343         } else if (block.chainid == 97) {
344             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
345         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
346             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
347         } else {
348             revert();
349         }
350 
351         _isExcludedFromFee[owner()] = true;
352         _isExcludedFromFee[address(this)] = true;
353         _liquidityHolders[owner()] = true;
354 
355         _approve(_msgSender(), _routerAddress, MAX);
356         _approve(address(this), _routerAddress, MAX);
357 
358     }
359 
360     receive() external payable {}
361 
362     function intializeContract(address payable setMarketWallet, address payable setDevWallet, string memory _tokenname, string memory _tokensymbol) external onlyOwner {
363         require(!contractInitialized);
364 
365         _marketWallet = payable(setMarketWallet);
366         _devWallet = payable(setDevWallet);
367 
368         _name = _tokenname;
369         _symbol = _tokensymbol;
370         startingSupply = 1_000_000_000_000;
371         if (startingSupply < 10000000000000) {
372             _decimals = 18;
373             _decimalsMul = _decimals;
374         } else {
375             _decimals = 9;
376             _decimalsMul = _decimals;
377         }
378         _tTotal = startingSupply * (10**_decimalsMul);
379         _rTotal = (MAX - (MAX % _tTotal));
380 
381         dexRouter = IUniswapV2Router02(_routerAddress);
382         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
383         lpPairs[lpPair] = true;
384         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
385         
386         _maxTxAmount = (_tTotal * 50) / 100;
387         maxTxAmountUI = (startingSupply * 1000) / 100000;
388         _maxWalletSize = (_tTotal * 100) / 100;
389         maxWalletSizeUI = (startingSupply * 10) / 1000;
390         swapThreshold = (_tTotal * 5) / 10000;
391         swapAmount = (_tTotal * 5) / 1000;
392 
393         approve(_routerAddress, type(uint256).max);
394 
395         contractInitialized = true;
396         _rOwned[owner()] = _rTotal;
397         emit Transfer(ZERO, owner(), _tTotal);
398 
399         _approve(address(this), address(dexRouter), type(uint256).max);
400 
401         _transfer(owner(), address(this), balanceOf(owner()));
402 
403 
404         
405 
406         dexRouter.addLiquidityETH{value: address(this).balance}(
407             address(this),
408             balanceOf(address(this)),
409             0, 
410             0, 
411             owner(),
412             block.timestamp
413         );
414         Planted = block.number;
415     }
416 
417 //===============================================================================================================
418 //===============================================================================================================
419 //===============================================================================================================
420     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
421     // This allows for removal of ownership privelages from the owner once renounced or transferred.
422     function owner() public view returns (address) {
423         return _owner;
424     }
425 
426     function transferOwner(address newOwner) external onlyOwner() {
427         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
428         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
429         setExcludedFromFee(_owner, false);
430         setExcludedFromFee(newOwner, true);
431         setExcludedFromReward(newOwner, true);
432         
433         if (_devWallet == payable(_owner))
434             _devWallet = payable(newOwner);
435         
436         _allowances[_owner][newOwner] = balanceOf(_owner);
437         if(balanceOf(_owner) > 0) {
438             _transfer(_owner, newOwner, balanceOf(_owner));
439         }
440         
441         _owner = newOwner;
442         emit OwnershipTransferred(_owner, newOwner);
443         
444     }
445 
446     function renounceOwnership() public virtual onlyOwner() {
447         setExcludedFromFee(_owner, false);
448         _owner = address(0);
449         emit OwnershipTransferred(_owner, address(0));
450     }
451 //===============================================================================================================
452 //===============================================================================================================
453 //===============================================================================================================
454 
455     function totalSupply() external view override returns (uint256) { return _tTotal; }
456     function decimals() external view returns (uint8) { return _decimals; }
457     function symbol() external view returns (string memory) { return _symbol; }
458     function name() external view returns (string memory) { return _name; }
459     function getOwner() external view returns (address) { return owner(); }
460     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
461 
462     function balanceOf(address account) public view override returns (uint256) {
463         if (_isExcluded[account]) return _tOwned[account];
464         return tokenFromReflection(_rOwned[account]);
465     }
466 
467     function transfer(address recipient, uint256 amount) public override returns (bool) {
468         _transfer(_msgSender(), recipient, amount);
469         return true;
470     }
471 
472     function approve(address spender, uint256 amount) public override returns (bool) {
473         _approve(_msgSender(), spender, amount);
474         return true;
475     }
476 
477     function approveMax(address spender) public returns (bool) {
478         return approve(spender, type(uint256).max);
479     }
480 
481     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
482         _transfer(sender, recipient, amount);
483         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
484         return true;
485     }
486 
487     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
488         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
489         return true;
490     }
491 
492     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
494         return true;
495     }
496 
497     function setNewRouter(address newRouter) external onlyOwner() {
498         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
499         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
500         if (get_pair == address(0)) {
501             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
502         }
503         else {
504             lpPair = get_pair;
505         }
506         dexRouter = _newRouter;
507         _approve(address(this), newRouter, MAX);
508     }
509 
510     function setLpPair(address pair, bool enabled) external onlyOwner {
511         if (enabled == false) {
512             lpPairs[pair] = false;
513         } else {
514             if (timeSinceLastPair != 0) {
515                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
516             }
517             lpPairs[pair] = true;
518             timeSinceLastPair = block.timestamp;
519         }
520     }
521 
522     function isExcludedFromReward(address account) public view returns (bool) {
523         return _isExcluded[account];
524     }
525 
526     function isExcludedFromFee(address account) public view returns(bool) {
527         return _isExcludedFromFee[account];
528     }
529 
530     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
531         require(reflect <= maxReflectFee
532                 && liquidity <= maxLiquidityFee
533                 && marketing <= maxMarketingFee
534                 );
535         require(reflect + liquidity + marketing <= 4900);
536         _buyReflectFee = reflect;
537         _buyLiquidityFee = liquidity;
538         _buyMarketingFee = marketing;
539     }
540 
541     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
542         require(reflect <= maxReflectFee
543                 && liquidity <= maxLiquidityFee
544                 && marketing <= maxMarketingFee
545                 );
546         require(reflect + liquidity + marketing <= 4900);
547         _sellReflectFee = reflect;
548         _sellLiquidityFee = liquidity;
549         _sellMarketingFee = marketing;
550     }
551 
552     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
553         require(reflect <= maxReflectFee
554                 && liquidity <= maxLiquidityFee
555                 && marketing <= maxMarketingFee
556                 );
557         require(reflect + liquidity + marketing <= 4900);
558         _transferReflectFee = reflect;
559         _transferLiquidityFee = liquidity;
560         _transferMarketingFee = marketing;
561     }
562 
563     function setValues(uint256 ms, uint256 ds, uint256 vd) external onlyOwner {
564         MarketShare = ms;
565         DevShare = ds;
566         ValueDivisor = vd;
567     }
568 
569     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
570         _liquidityRatio = liquidity;
571         _marketingRatio = marketing;
572     }
573 
574     function MaxTx(uint256 percent, uint256 divisor) external onlyOwner {
575         uint256 check = (_tTotal * percent) / divisor;
576         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
577         _maxTxAmount = check;
578         maxTxAmountUI = (startingSupply * percent) / divisor;
579     }
580 
581     function WalletSize(uint256 percent, uint256 divisor) external onlyOwner {
582         uint256 check = (_tTotal * percent) / divisor;
583         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
584         _maxWalletSize = check;
585         maxWalletSizeUI = (startingSupply * percent) / divisor;
586     }
587 
588     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
589         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
590         swapAmount = (_tTotal * amountPercent) / amountDivisor;
591     }
592 
593     function NewMarketWallet(address payable newWallet) external onlyOwner {
594         require(_marketWallet != newWallet, "Wallet already set!");
595         _marketWallet = payable(newWallet);
596     }
597 
598     function NewDevWallet(address payable newWallet) external onlyOwner {
599         require(_devWallet != newWallet, "Wallet already set!");
600         _devWallet = payable(newWallet);
601     }
602     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
603         swapAndLiquifyEnabled = _enabled;
604         emit SwapAndLiquifyEnabledUpdated(_enabled);
605     }
606 
607     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
608         _isExcludedFromFee[account] = enabled;
609     }
610 
611     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
612         if (enabled == true) {
613             require(!_isExcluded[account], "Account is already excluded.");
614             if(_rOwned[account] > 0) {
615                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
616             }
617             _isExcluded[account] = true;
618             _excluded.push(account);
619         } else if (enabled == false) {
620             require(_isExcluded[account], "Account is already included.");
621             for (uint256 i = 0; i < _excluded.length; i++) {
622                 if (_excluded[i] == account) {
623                     _excluded[i] = _excluded[_excluded.length - 1];
624                     _tOwned[account] = 0;
625                     _isExcluded[account] = false;
626                     _excluded.pop();
627                     break;
628                 }
629             }
630         }
631     }
632 
633     function totalFees() public view returns (uint256) {
634         return _tFeeTotal;
635     }
636 
637     function _hasLimits(address from, address to) internal view returns (bool) {
638         return from != owner()
639             && to != owner()
640             && !_liquidityHolders[to]
641             && !_liquidityHolders[from]
642             && to != DEAD
643             && to != address(0)
644             && from != address(this);
645     }
646 
647     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
648         require(rAmount <= _rTotal, "Amount must be less than total reflections");
649         uint256 currentRate =  _getRate();
650         return rAmount / currentRate;
651     }
652     
653     function _approve(address sender, address spender, uint256 amount) internal {
654         require(sender != address(0), "ERC20: approve from the zero address");
655         require(spender != address(0), "ERC20: approve to the zero address");
656 
657         _allowances[sender][spender] = amount;
658         emit Approval(sender, spender, amount);
659     }
660 
661     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
662         require(from != address(0), "ERC20: transfer from the zero address");
663         require(to != address(0), "ERC20: transfer to the zero address");
664         require(amount > 0, "Transfer amount must be greater than zero");
665         if(_hasLimits(from, to)) {
666             if(!tradingEnabled) {
667                 revert("Trading not yet enabled!");
668             }
669             if (sameBlockActive) {
670                 if (lpPairs[from]){
671                     require(lastTrade[to] != block.number);
672                     lastTrade[to] = block.number;
673                 } else {
674                     require(lastTrade[from] != block.number);
675                     lastTrade[from] = block.number;
676                 }
677             }
678             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
679             if(to != _routerAddress && !lpPairs[to]) {
680                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
681             }
682         }
683         bool takeFee = true;
684         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
685             takeFee = false;
686         }
687 
688         if (lpPairs[to]) {
689             if (!inSwapAndLiquify
690                 && swapAndLiquifyEnabled
691             ) {
692                 uint256 contractTokenBalance = balanceOf(address(this));
693                 if (contractTokenBalance >= swapThreshold) {
694                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
695                     swapAndLiquify(contractTokenBalance);
696                 }
697             }      
698         } 
699         return _finalizeTransfer(from, to, amount, takeFee);
700     }
701 
702     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
703         if (_liquidityRatio + _marketingRatio == 0)
704             return;
705         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
706 
707         uint256 toSwapForEth = contractTokenBalance - toLiquify;
708 
709         address[] memory path = new address[](2);
710         path[0] = address(this);
711         path[1] = dexRouter.WETH();
712 
713         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
714             toSwapForEth,
715             0,
716             path,
717             address(this),
718             block.timestamp
719         );
720 
721 
722         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
723 
724         if (toLiquify > 0) {
725             dexRouter.addLiquidityETH{value: liquidityBalance}(
726                 address(this),
727                 toLiquify,
728                 0, 
729                 0, 
730                 DEAD,
731                 block.timestamp
732             );
733             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
734         }
735         if (contractTokenBalance - toLiquify > 0) {
736 
737             uint256 OperationsFee = (address(this).balance);
738             uint256 marketFee = OperationsFee/(ValueDivisor)*(MarketShare);
739             uint256 devfeeshare = OperationsFee/(ValueDivisor)*(DevShare);
740             _marketWallet.transfer(marketFee);
741             _devWallet.transfer(devfeeshare);            
742 
743         }
744     }
745 
746     
747 
748     function _checkLiquidityAdd(address from, address to) internal {
749         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
750         if (!_hasLimits(from, to) && to == lpPair) {
751             _liquidityHolders[from] = true;
752             _hasLiqBeenAdded = true;
753             _liqAddStamp = block.timestamp;
754 
755             swapAndLiquifyEnabled = true;
756             emit SwapAndLiquifyEnabledUpdated(true);
757         }
758     }
759 
760     function enableTrading() public onlyOwner {
761         require(!tradingEnabled, "Trading already enabled!");
762         setExcludedFromReward(address(this), true);
763         setExcludedFromReward(lpPair, true);
764 
765         tradingEnabled = true;
766         swapAndLiquifyEnabled = true;
767     }
768 
769     struct ExtraValues {
770         uint256 tTransferAmount;
771         uint256 tFee;
772         uint256 tLiquidity;
773 
774         uint256 rTransferAmount;
775         uint256 rAmount;
776         uint256 rFee;
777     }
778 
779     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
780 
781 
782         if (!_hasLiqBeenAdded) {
783                 _checkLiquidityAdd(from, to);
784                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
785                     revert("Only owner can transfer at this time.");
786                 }
787         }
788         
789         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
790 
791         _rOwned[from] = _rOwned[from] - values.rAmount;
792         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
793 
794         if (_isExcluded[from] && !_isExcluded[to]) {
795             _tOwned[from] = _tOwned[from] - tAmount;
796         } else if (!_isExcluded[from] && _isExcluded[to]) {
797             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
798         } else if (_isExcluded[from] && _isExcluded[to]) {
799             _tOwned[from] = _tOwned[from] - tAmount;
800             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
801         }
802 
803         if (values.tLiquidity > 0)
804             _takeLiquidity(from, values.tLiquidity);
805         if (values.rFee > 0 || values.tFee > 0)
806             _takeReflect(values.rFee, values.tFee);
807 
808         emit Transfer(from, to, values.tTransferAmount);
809         return true;
810     }
811 
812     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
813         ExtraValues memory values;
814         uint256 currentRate = _getRate();
815 
816         values.rAmount = tAmount * currentRate;
817 
818         if(takeFee) {
819             if (lpPairs[to]) {
820                 _reflectFee = _sellReflectFee;
821                 _liquidityFee = _sellLiquidityFee;
822                 _marketingFee = _sellMarketingFee;
823             } else if (lpPairs[from]) {
824                 _reflectFee = _buyReflectFee;
825                 _liquidityFee = _buyLiquidityFee;
826                 _marketingFee = _buyMarketingFee;
827             } else {
828                 _reflectFee = _transferReflectFee;
829                 _liquidityFee = _transferLiquidityFee;
830                 _marketingFee = _transferMarketingFee;
831             }
832 
833             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
834             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
835             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
836 
837             values.rFee = values.tFee * currentRate;
838         } else {
839             values.tFee = 0;
840             values.tLiquidity = 0;
841             values.tTransferAmount = tAmount;
842 
843             values.rFee = 0;
844         }
845 
846         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
847         return values;
848     }
849 
850     function _getRate() internal view returns(uint256) {
851         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
852         return rSupply / tSupply;
853     }
854 
855     function _getCurrentSupply() internal view returns(uint256, uint256) {
856         uint256 rSupply = _rTotal;
857         uint256 tSupply = _tTotal;
858         for (uint256 i = 0; i < _excluded.length; i++) {
859             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
860             rSupply = rSupply - _rOwned[_excluded[i]];
861             tSupply = tSupply - _tOwned[_excluded[i]];
862         }
863         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
864         return (rSupply, tSupply);
865     }
866     
867     function _takeReflect(uint256 rFee, uint256 tFee) internal {
868         _rTotal = _rTotal - rFee;
869         _tFeeTotal = _tFeeTotal + tFee;
870     }
871 
872     function refund() external onlyOwner {
873         payable(owner()).transfer(address(this).balance);
874     }
875     
876     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
877         uint256 currentRate =  _getRate();
878         uint256 rLiquidity = tLiquidity * currentRate;
879         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
880         if(_isExcluded[address(this)])
881             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
882         emit Transfer(sender, address(this), tLiquidity); 
883     }
884 }