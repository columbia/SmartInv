1 // WEBSITE : http://www.Hirokage.io
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.8.7;
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
218 contract HIRO is Context, IERC20Upgradeable {
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
232     mapping (address => bool) private _isSniperOrBlacklisted;
233     mapping (address => bool) private _liquidityHolders;
234    
235     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
236 
237     uint256 private startingSupply;
238 
239     string private _name;
240     string private _symbol;
241 
242     uint256 public _reflectFee = 0;
243     uint256 public _liquidityFee = 200;
244     uint256 public _ProjectFundsFee = 1100;
245 
246     uint256 public _buyReflectFee = _reflectFee;
247     uint256 public _buyLiquidityFee = _liquidityFee;
248     uint256 public _buyProjectFundsFee = _ProjectFundsFee;
249 
250     uint256 public _sellReflectFee = 500;
251     uint256 public _sellLiquidityFee = 300;
252     uint256 public _sellProjectFundsFee = 1700;
253     
254     uint256 public _transferReflectFee = _buyReflectFee;
255     uint256 public _transferLiquidityFee = _buyLiquidityFee;
256     uint256 public _transferProjectFundsFee = _buyProjectFundsFee;
257     
258     uint256 private maxReflectFee = 500;
259     uint256 private maxLiquidityFee = 500;
260     uint256 private maxProjectFundsFee = 2000;
261 
262     uint256 public _liquidityRatio = 200;
263     uint256 public _marketingDevelopmentRatio = 800;
264     uint256 public _teamRatio = 300;
265 
266     uint256 private masterTaxDivisor = 10000;
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
279     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
280 
281     address public DEAD = 0x000000000000000000000000000000000000dEaD;
282     address public ZERO = 0x0000000000000000000000000000000000000000;
283     address payable public _marketingDevelopmentWallet = payable(0xC4Db883f25805dbE13E2274F72EF00A3Fe68eff5);
284     address payable public _teamWallet = payable(0x75e43A8801755c8Da579186DB81e9595EECe46AA);
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
300     bool private sniperProtection = true;
301     bool public _hasLiqBeenAdded = false;
302     uint256 private _liqAddStatus = 0;
303     uint256 private _liqAddBlock = 0;
304     uint256 private _liqAddStamp = 0;
305     uint256 private _initialLiquidityAmount = 0;
306     uint256 private snipeBlockAmt = 0;
307     uint256 public snipersCaught = 0;
308     bool private gasLimitActive = true;
309     uint256 private gasPriceLimit;
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
322     
323     bool contractInitialized = false;
324     
325     modifier lockTheSwap {
326         inSwapAndLiquify = true;
327         _;
328         inSwapAndLiquify = false;
329     }
330 
331     modifier onlyOwner() {
332         require(_owner == _msgSender(), "Ownable: caller is not the owner");
333         _;
334     }
335     
336     constructor () payable {
337         // Set the owner.
338         _owner = msg.sender;
339 
340         _isExcludedFromFee[owner()] = true;
341         _isExcludedFromFee[address(this)] = true;
342         _liquidityHolders[owner()] = true;
343 
344         // Approve the owner for PancakeSwap, timesaver.
345         _approve(_msgSender(), _routerAddress, MAX);
346         _approve(address(this), _routerAddress, MAX);
347 
348     }
349 
350     receive() external payable {}
351 
352     function intializeContract() external onlyOwner {
353         require(!contractInitialized, "Contract already initialized.");
354         _name = "Hirokage";
355         _symbol = "HIRO";
356         startingSupply = 10_000_000_000;
357         _decimals = 9;
358 
359 
360         _tTotal = startingSupply * (10**_decimals);
361         _rTotal = (MAX - (MAX % _tTotal));
362 
363         dexRouter = IUniswapV2Router02(_routerAddress);
364         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
365         lpPairs[lpPair] = true;
366         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
367 
368         // wallet holdings
369         _maxTxAmount = _tTotal * 33/10_000;
370         _maxWalletSize = _tTotal/100;
371 
372         //swap settings
373         swapThreshold = (_tTotal * 5) / 10_000;
374         swapAmount = (_tTotal * 5) / 1_000;
375 
376         approve(_routerAddress, type(uint256).max);
377 
378         contractInitialized = true;
379         _rOwned[owner()] = _rTotal;
380         emit Transfer(ZERO, owner(), _tTotal);
381     }
382 
383 //===============================================================================================================
384 //===============================================================================================================
385 //===============================================================================================================
386     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
387     // This allows for removal of ownership privelages from the owner once renounced or transferred.
388     function owner() public view returns (address) {
389         return _owner;
390     }
391 
392     function transferOwner(address newOwner) external onlyOwner() {
393         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
394         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
395         setExcludedFromFee(_owner, false);
396         setExcludedFromFee(newOwner, true);
397         setExcludedFromReward(newOwner, true);
398         
399         _owner = newOwner;
400         emit OwnershipTransferred(_owner, newOwner);
401         
402     }
403 
404     function renounceOwnership() public virtual onlyOwner() {
405         setExcludedFromFee(_owner, false);
406         _owner = address(0);
407         emit OwnershipTransferred(_owner, address(0));
408     }
409 //===============================================================================================================
410 //===============================================================================================================
411 //===============================================================================================================
412 
413     function totalSupply() external view override returns (uint256) { return _tTotal; }
414     function decimals() external view returns (uint8) { return _decimals; }
415     function symbol() external view returns (string memory) { return _symbol; }
416     function name() external view returns (string memory) { return _name; }
417     function getOwner() external view returns (address) { return owner(); }
418     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
419 
420     function balanceOf(address account) public view override returns (uint256) {
421         if (_isExcluded[account]) return _tOwned[account];
422         return tokenFromReflection(_rOwned[account]);
423     }
424 
425     function transfer(address recipient, uint256 amount) public override returns (bool) {
426         _transfer(_msgSender(), recipient, amount);
427         return true;
428     }
429 
430     function approve(address spender, uint256 amount) public override returns (bool) {
431         _approve(_msgSender(), spender, amount);
432         return true;
433     }
434 
435     function approveMax(address spender) public returns (bool) {
436         return approve(spender, type(uint256).max);
437     }
438 
439     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
440         _transfer(sender, recipient, amount);
441         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
442         return true;
443     }
444 
445     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
446         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
447         return true;
448     }
449 
450     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
452         return true;
453     }
454 
455     function setNewRouter(address newRouter) external onlyOwner() {
456         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
457         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
458         if (get_pair == address(0)) {
459             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
460         }
461         else {
462             lpPair = get_pair;
463         }
464         dexRouter = _newRouter;
465         _approve(address(this), newRouter, MAX);
466     }
467 
468     function setLpPair(address pair, bool enabled) external onlyOwner {
469         if (enabled == false) {
470             lpPairs[pair] = false;
471         } else {
472             if (timeSinceLastPair != 0) {
473                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
474             }
475             lpPairs[pair] = true;
476             timeSinceLastPair = block.timestamp;
477         }
478     }
479 
480     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
481         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
482     }
483 
484     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
485         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
486     }
487 
488     function isExcludedFromReward(address account) public view returns (bool) {
489         return _isExcluded[account];
490     }
491 
492     function isExcludedFromFee(address account) public view returns(bool) {
493         return _isExcludedFromFee[account];
494     }
495 
496     function isSniperOrBlacklisted(address account) public view returns (bool) {
497         return _isSniperOrBlacklisted[account];
498     }
499 
500     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
501         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
502         _liqAddStatus = rInitializer;
503         _initialLiquidityAmount = tInitalizer;
504         snipeBlockAmt = 3;
505         gasPriceLimit = 777 gwei;
506     }
507 
508     function setStartingProtections(uint8 _block, uint256 _gas) external onlyOwner{
509         require (snipeBlockAmt == 0 && gasPriceLimit == 0 && !_hasLiqBeenAdded);
510         snipeBlockAmt = _block;
511         gasPriceLimit = _gas * 1 gwei;
512     }
513 
514     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
515         sniperProtection = antiSnipe;
516         gasLimitActive = antiGas;
517         sameBlockActive = antiBlock;
518     }
519 
520     function setGasPriceLimit(uint256 gas) external onlyOwner {
521         require(gas >= 75);
522         gasPriceLimit = gas * 1 gwei;
523     }
524 
525     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
526         _isSniperOrBlacklisted[account] = enabled;
527     }
528     
529     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 projectFunds) external onlyOwner {
530         require(reflect <= maxReflectFee
531                 && liquidity <= maxLiquidityFee
532                 && projectFunds <= maxProjectFundsFee
533                 );
534         require(reflect + liquidity + projectFunds <= 3450);
535         _buyReflectFee = reflect;
536         _buyLiquidityFee = liquidity;
537         _buyProjectFundsFee = projectFunds;
538     }
539 
540     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 projectFunds) external onlyOwner {
541         require(reflect <= maxReflectFee
542                 && liquidity <= maxLiquidityFee
543                 && projectFunds <= maxProjectFundsFee
544                 );
545         require(reflect + liquidity + projectFunds <= 3450);
546         _sellReflectFee = reflect;
547         _sellLiquidityFee = liquidity;
548         _sellProjectFundsFee = projectFunds;
549     }
550 
551     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
552         require(reflect <= maxReflectFee
553                 && liquidity <= maxLiquidityFee
554                 && marketing <= maxProjectFundsFee
555                 );
556         require(reflect + liquidity + marketing <= 3450);
557         _transferReflectFee = reflect;
558         _transferLiquidityFee = liquidity;
559         _transferProjectFundsFee = marketing;
560     }
561 
562     function setRatios(uint256 liquidity, uint256 marketingDevelopment, uint256 team) external onlyOwner {
563         require ( (liquidity + team + marketingDevelopment) == 1300);
564         _liquidityRatio = liquidity;
565         _marketingDevelopmentRatio = marketingDevelopment;
566         _teamRatio = team;
567     }
568 
569     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
570         uint256 check = (_tTotal * percent) / divisor;
571         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
572         _maxTxAmount = check;
573         maxTxAmountUI = (startingSupply * percent) / divisor;
574     }
575 
576     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
577         uint256 check = (_tTotal * percent) / divisor;
578         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
579         _maxWalletSize = check;
580         maxWalletSizeUI = (startingSupply * percent) / divisor;
581     }
582 
583     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
584         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
585         swapAmount = (_tTotal * amountPercent) / amountDivisor;
586     }
587 
588     function setmarketingDevelopmentWallet(address payable newWallet, address payable newWallet2) external onlyOwner {
589         require(_marketingDevelopmentWallet != address(0) && _teamWallet != address(0));
590         _marketingDevelopmentWallet = payable(newWallet);
591         _teamWallet = payable(newWallet2);
592     }
593 
594     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
595         swapAndLiquifyEnabled = _enabled;
596         emit SwapAndLiquifyEnabledUpdated(_enabled);
597     }
598 
599     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
600         _isExcludedFromFee[account] = enabled;
601     }
602 
603     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
604         if (enabled == true) {
605             require(!_isExcluded[account], "Account is already excluded.");
606             if(_rOwned[account] > 0) {
607                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
608             }
609             _isExcluded[account] = true;
610             _excluded.push(account);
611         } else if (enabled == false) {
612             require(_isExcluded[account], "Account is already included.");
613             for (uint256 i = 0; i < _excluded.length; i++) {
614                 if (_excluded[i] == account) {
615                     _excluded[i] = _excluded[_excluded.length - 1];
616                     _tOwned[account] = 0;
617                     _isExcluded[account] = false;
618                     _excluded.pop();
619                     break;
620                 }
621             }
622         }
623     }
624 
625     function totalFees() public view returns (uint256) {
626         return _tFeeTotal;
627     }
628 
629     function _hasLimits(address from, address to) internal view returns (bool) {
630         return from != owner()
631             && to != owner()
632             && !_liquidityHolders[to]
633             && !_liquidityHolders[from]
634             && to != DEAD
635             && to != address(0)
636             && from != address(this);
637     }
638 
639     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
640         require(rAmount <= _rTotal, "Amount must be less than total reflections");
641         uint256 currentRate =  _getRate();
642         return rAmount / currentRate;
643     }
644     
645     function _approve(address sender, address spender, uint256 amount) internal {
646         require(sender != address(0), "ERC20: approve from the zero address");
647         require(spender != address(0), "ERC20: approve to the zero address");
648 
649         _allowances[sender][spender] = amount;
650         emit Approval(sender, spender, amount);
651     }
652 
653     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
654         require(from != address(0), "ERC20: transfer from the zero address");
655         require(to != address(0), "ERC20: transfer to the zero address");
656         require(amount > 0, "Transfer amount must be greater than zero");
657         if (gasLimitActive) {
658             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
659         }
660         if(_hasLimits(from, to)) {
661             if(!tradingEnabled) {
662                 revert("Trading not yet enabled!");
663             }
664             if (sameBlockActive) {
665                 if (lpPairs[from]){
666                     require(lastTrade[to] != block.number);
667                     lastTrade[to] = block.number;
668                 } else {
669                     require(lastTrade[from] != block.number);
670                     lastTrade[from] = block.number;
671                 }
672             }
673             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])){
674                 if(lpPairs[from] || lpPairs[to]){
675                     require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
676                 }
677                 if(to != _routerAddress && !lpPairs[to]) {
678                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
679                 }
680             }
681         }
682 
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
703         if (_liquidityRatio + _marketingDevelopmentRatio + _teamRatio == 0)
704             return;
705         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingDevelopmentRatio + _teamRatio)) / 2;
706 
707         uint256 toSwapForEth = contractTokenBalance - toLiquify;
708         swapTokensForEth(toSwapForEth);
709 
710         //uint256 currentBalance = address(this).balance;
711         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingDevelopmentRatio + _teamRatio )) / 2;
712 
713         if (toLiquify > 0) {
714             addLiquidity(toLiquify, liquidityBalance);
715             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
716         }
717         if (contractTokenBalance - toLiquify > 0) {
718             uint256 ethfunds = address(this).balance;
719             uint256 marketingdevelopmentfunds = (ethfunds* _marketingDevelopmentRatio) / (_marketingDevelopmentRatio + _teamRatio);
720             _marketingDevelopmentWallet.transfer(marketingdevelopmentfunds);
721             _teamWallet.transfer(address(this).balance);
722         }
723     }
724 
725     function swapTokensForEth(uint256 tokenAmount) internal {
726         address[] memory path = new address[](2);
727         path[0] = address(this);
728         path[1] = dexRouter.WETH();
729 
730         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
731             tokenAmount,
732             0,
733             path,
734             address(this),
735             block.timestamp
736         );
737     }
738 
739     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
740         dexRouter.addLiquidityETH{value: ethAmount}(
741             address(this),
742             tokenAmount,
743             0, // slippage is unavoidable
744             0, // slippage is unavoidable
745             DEAD,
746             block.timestamp
747         );
748     }
749 
750     function _checkLiquidityAdd(address from, address to) internal {
751         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
752         if (!_hasLimits(from, to) && to == lpPair) {
753             _liquidityHolders[from] = true;
754             _hasLiqBeenAdded = true;
755             _liqAddStamp = block.timestamp;
756 
757             swapAndLiquifyEnabled = true;
758             emit SwapAndLiquifyEnabledUpdated(true);
759         }
760     }
761 
762     function enableTrading() public onlyOwner {
763         require(!tradingEnabled, "Trading already enabled!");
764         setExcludedFromReward(address(this), true);
765         setExcludedFromReward(lpPair, true);
766         if (snipeBlockAmt != 3) {
767             _liqAddBlock = block.number + 500;
768         } else {
769             _liqAddBlock = block.number;
770         }
771         tradingEnabled = true;
772     }
773 
774     struct ExtraValues {
775         uint256 tTransferAmount;
776         uint256 tFee;
777         uint256 tLiquidity;
778 
779         uint256 rTransferAmount;
780         uint256 rAmount;
781         uint256 rFee;
782     }
783 
784     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
785         if (sniperProtection){
786             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
787                 revert("Rejected.");
788             }
789 
790             if (!_hasLiqBeenAdded) {
791                 _checkLiquidityAdd(from, to);
792                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
793                     revert("Only owner can transfer at this time.");
794                 }
795             } else {
796                 if (_liqAddBlock > 0 
797                     && lpPairs[from] 
798                     && _hasLimits(from, to)
799                 ) {
800                     if (block.number - _liqAddBlock < snipeBlockAmt) {
801                         _isSniperOrBlacklisted[to] = true;
802                         snipersCaught ++;
803                         emit SniperCaught(to);
804                     }
805                 }
806             }
807         }
808 
809         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
810 
811         _rOwned[from] = _rOwned[from] - values.rAmount;
812         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
813 
814         if (_isExcluded[from] && !_isExcluded[to]) {
815             _tOwned[from] = _tOwned[from] - tAmount;
816         } else if (!_isExcluded[from] && _isExcluded[to]) {
817             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
818         } else if (_isExcluded[from] && _isExcluded[to]) {
819             _tOwned[from] = _tOwned[from] - tAmount;
820             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
821         }
822 
823         if (_hasLimits(from, to)){
824             if (_liqAddStatus == 0 || _liqAddStatus != 1337) {
825                 revert("Error.");
826             }
827         }
828 
829         if (values.tLiquidity > 0)
830             _takeLiquidity(from, values.tLiquidity);
831         if (values.rFee > 0 || values.tFee > 0)
832             _takeReflect(values.rFee, values.tFee);
833 
834         emit Transfer(from, to, values.tTransferAmount);
835         return true;
836     }
837 
838     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
839         ExtraValues memory values;
840         uint256 currentRate = _getRate();
841 
842         values.rAmount = tAmount * currentRate;
843 
844         if(takeFee) {
845             if (lpPairs[to]) {
846                 _reflectFee = _sellReflectFee;
847                 _liquidityFee = _sellLiquidityFee;
848                 _ProjectFundsFee = _sellProjectFundsFee;
849             } else if (lpPairs[from]) {
850                 _reflectFee = _buyReflectFee;
851                 _liquidityFee = _buyLiquidityFee;
852                 _ProjectFundsFee = _buyProjectFundsFee;
853             } else {
854                 _reflectFee = _transferReflectFee;
855                 _liquidityFee = _transferLiquidityFee;
856                 _ProjectFundsFee = _transferProjectFundsFee;
857             }
858 
859             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
860             values.tLiquidity = (tAmount * (_liquidityFee + _ProjectFundsFee)) / masterTaxDivisor;
861             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
862 
863             values.rFee = values.tFee * currentRate;
864         } else {
865             values.tFee = 0;
866             values.tLiquidity = 0;
867             values.tTransferAmount = tAmount;
868 
869             values.rFee = 0;
870         }
871         if (_hasLimits(from, to) && (_initialLiquidityAmount == 0 || _initialLiquidityAmount != 1337)) {
872             revert("Error.");
873         }
874         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
875         return values;
876     }
877 
878     function _getRate() internal view returns(uint256) {
879         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
880         return rSupply / tSupply;
881     }
882 
883     function _getCurrentSupply() internal view returns(uint256, uint256) {
884         uint256 rSupply = _rTotal;
885         uint256 tSupply = _tTotal;
886         for (uint256 i = 0; i < _excluded.length; i++) {
887             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
888             rSupply = rSupply - _rOwned[_excluded[i]];
889             tSupply = tSupply - _tOwned[_excluded[i]];
890         }
891         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
892         return (rSupply, tSupply);
893     }
894     
895     function _takeReflect(uint256 rFee, uint256 tFee) internal {
896         _rTotal = _rTotal - rFee;
897         _tFeeTotal = _tFeeTotal + tFee;
898     }
899     
900     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
901         uint256 currentRate =  _getRate();
902         uint256 rLiquidity = tLiquidity * currentRate;
903         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
904         if(_isExcluded[address(this)])
905             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
906         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
907     }
908 }