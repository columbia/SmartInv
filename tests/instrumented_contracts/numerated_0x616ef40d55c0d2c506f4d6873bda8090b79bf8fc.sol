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
15 interface IERC20Upgradeable {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 interface IUniswapV2Factory {
91     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
92     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
93     function createPair(address tokenA, address tokenB) external returns (address lpPair);
94 }
95 
96 interface IUniswapV2Pair {
97     event Approval(address indexed owner, address indexed spender, uint value);
98     event Transfer(address indexed from, address indexed to, uint value);
99 
100     function name() external pure returns (string memory);
101     function symbol() external pure returns (string memory);
102     function decimals() external pure returns (uint8);
103     function totalSupply() external view returns (uint);
104     function balanceOf(address owner) external view returns (uint);
105     function allowance(address owner, address spender) external view returns (uint);
106     function approve(address spender, uint value) external returns (bool);
107     function transfer(address to, uint value) external returns (bool);
108     function transferFrom(address from, address to, uint value) external returns (bool);
109     function DOMAIN_SEPARATOR() external view returns (bytes32);
110     function PERMIT_TYPEHASH() external pure returns (bytes32);
111     function nonces(address owner) external view returns (uint);
112     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
113     function factory() external view returns (address);
114 }
115 
116 interface IUniswapV2Router01 {
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 }
128 
129 interface IUniswapV2Router02 is IUniswapV2Router01 {
130     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 interface AntiSnipe {
153     function checkUser(address from, address to, uint256 amt) external returns (bool);
154     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp) external;
155     function setLpPair(address pair, bool enabled) external;
156     function setProtections(bool _as, bool _ag, bool _ab, bool _aspecial) external;
157     function setGasPriceLimit(uint256 gas) external;
158     function removeSniper(address account) external;
159     function getSniperAmt() external view returns (uint256);
160     function removeBlacklisted(address account) external;
161     function isBlacklisted(address account) external view returns (bool);
162 }
163 
164 contract Kounotori is Context, IERC20Upgradeable {
165     // Ownership moved to in-contract for customizability.
166     address private _owner;
167 
168     mapping (address => uint256) private _rOwned;
169     mapping (address => uint256) private _tOwned;
170     mapping (address => bool) lpPairs;
171     uint256 private timeSinceLastPair = 0;
172     mapping (address => mapping (address => uint256)) private _allowances;
173 
174     mapping (address => bool) private _isExcludedFromFees;
175     mapping (address => bool) private _isExcludedFromLimits;
176     mapping (address => bool) private _isExcluded;
177     address[] private _excluded;
178 
179     bool private allowedPresaleExclusion = true;
180     mapping (address => bool) private _isSniper;
181     mapping (address => bool) private _liquidityHolders;
182    
183     uint256 private startingSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     struct FeesStruct {
189         uint16 reflectFee;
190         uint16 liquidityFee;
191         uint16 marketingFee;
192     }
193 
194     struct StaticValuesStruct {
195         uint16 maxReflectFee;
196         uint16 maxLiquidityFee;
197         uint16 maxMarketingFee;
198         uint16 masterTaxDivisor;
199     }
200 
201     struct Ratios {
202         uint16 liquidityRatio;
203         uint16 marketingRatio;
204         uint16 totalRatio;
205     }
206 
207     FeesStruct private currentTaxes = FeesStruct({
208         reflectFee: 0,
209         liquidityFee: 0,
210         marketingFee: 0
211         });
212 
213     FeesStruct public _buyTaxes = FeesStruct({
214         reflectFee: 300,
215         liquidityFee: 300,
216         marketingFee: 300
217         });
218 
219     FeesStruct public _sellTaxes = FeesStruct({
220         reflectFee: 300,
221         liquidityFee: 300,
222         marketingFee: 300
223         });
224 
225     FeesStruct public _transferTaxes = FeesStruct({
226         reflectFee: 300,
227         liquidityFee: 300,
228         marketingFee: 300
229         });
230 
231     Ratios public _ratios = Ratios({
232         liquidityRatio: _buyTaxes.liquidityFee,
233         marketingRatio: _buyTaxes.marketingFee,
234         totalRatio: _buyTaxes.liquidityFee + _buyTaxes.marketingFee
235         });
236 
237     StaticValuesStruct public staticVals = StaticValuesStruct({
238         maxReflectFee: 800,
239         maxLiquidityFee: 800,
240         maxMarketingFee: 800,
241         masterTaxDivisor: 10000
242         });
243 
244     uint256 private constant MAX = ~uint256(0);
245     uint8 private _decimals;
246     uint256 private _tTotal;
247     uint256 private _rTotal;
248     uint256 private _tFeeTotal;
249 
250     IUniswapV2Router02 public dexRouter;
251     address public lpPair;
252 
253     address public currentRouter;
254     // PCS ROUTER
255     address private pcsV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
256     // UNI ROUTER
257     address private uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
258 
259     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
260     address payable private _marketingWallet = payable(0x990C36e0871857534a55F8f756cDecF360d59B08);
261     
262     bool inSwap;
263     bool public contractSwapEnabled = false;
264     
265     uint256 private _maxTxAmount;
266     uint256 public maxTxAmountUI;
267 
268     uint256 private _maxWalletSize;
269     uint256 public maxWalletSizeUI;
270 
271     uint256 private swapThreshold;
272     uint256 private swapAmount;
273 
274     bool public tradingEnabled = false;
275     bool public _hasLiqBeenAdded = false;
276     AntiSnipe antiSnipe;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
280     event ContractSwapEnabledUpdated(bool enabled);
281     event SwapAndLiquify(
282         uint256 tokensSwapped,
283         uint256 ethReceived,
284         uint256 tokensIntoLiqudity
285     );
286     event SniperCaught(address sniperAddress);
287     
288     modifier lockTheSwap {
289         inSwap = true;
290         _;
291         inSwap = false;
292     }
293 
294     modifier onlyOwner() {
295         require(_owner == _msgSender(), "Caller =/= owner.");
296         _;
297     }
298     
299     constructor () payable {
300         // Set the owner.
301         _owner = msg.sender;
302 
303 
304         if (block.chainid == 56 || block.chainid == 97) {
305             currentRouter = pcsV2Router;
306         } else if (block.chainid == 1) {
307             currentRouter = uniswapV2Router;
308         }
309 
310         _approve(_msgSender(), currentRouter, type(uint256).max);
311         _approve(address(this), currentRouter, type(uint256).max);
312 
313         _isExcludedFromFees[owner()] = true;
314         _isExcludedFromFees[address(this)] = true;
315         _isExcludedFromFees[DEAD] = true;
316         _liquidityHolders[owner()] = true;
317     }
318     
319     bool contractInitialized = false;
320 
321     function intializeContract(address[] memory accounts, uint256[] memory amounts, address newOwner) external onlyOwner {
322         require(!contractInitialized, "1");
323         require(accounts.length < 100, "2");
324         require(accounts.length == amounts.length, "3");
325 
326         _name = "Kounotori";
327         _symbol = "KTO";
328         startingSupply = 1_000_000_000_000_000;
329         if (startingSupply < 10000000000) {
330             _decimals = 18;
331         } else {
332             _decimals = 9;
333         }
334         _tTotal = startingSupply * (10**_decimals);
335         _rTotal = (MAX - (MAX % _tTotal));
336 
337         dexRouter = IUniswapV2Router02(currentRouter);
338         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
339         lpPairs[lpPair] = true;
340 
341         uint256 percent = 2;
342         uint256 divisor = 1000;
343         _maxTxAmount = (_tTotal * percent) / divisor;
344         maxTxAmountUI = (startingSupply * percent) / divisor;
345         percent = 55;
346         divisor = 10000;
347         _maxWalletSize = (_tTotal * percent) / divisor;
348         maxWalletSizeUI = (startingSupply * percent) / divisor;
349         swapThreshold = (_tTotal * 5) / 10000;
350         swapAmount = (_tTotal * 5) / 1000;
351         if(address(antiSnipe) == address(0)){
352             antiSnipe = AntiSnipe(address(this));
353         }
354         contractInitialized = true;     
355         _rOwned[owner()] = _rTotal;
356         emit Transfer(address(0), owner(), _tTotal);
357 
358         _approve(address(this), address(dexRouter), type(uint256).max);
359 
360         for(uint256 i = 0; i < accounts.length; i++){
361             address wallet = accounts[i];
362             uint256 amount = amounts[i]*10**_decimals;
363             _transfer(owner(), wallet, amount);
364         }
365 
366         _transfer(owner(), address(this), balanceOf(owner()));
367 
368         dexRouter.addLiquidityETH{value: address(this).balance}(
369             address(this),
370             balanceOf(address(this)),
371             0, // slippage is unavoidable
372             0, // slippage is unavoidable
373             owner(),
374             block.timestamp
375         );
376 
377         enableTrading();
378         transferOwner(newOwner);
379     }
380 
381     receive() external payable {}
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
392     function transferOwner(address newOwner) public onlyOwner() {
393         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
394         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
395         setExcludedFromFees(_owner, false);
396         setExcludedFromFees(newOwner, true);
397         if (tradingEnabled){
398             setExcludedFromReward(newOwner, true);
399         }
400         
401         if (_marketingWallet == payable(_owner))
402             _marketingWallet = payable(newOwner);
403         
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
414         setExcludedFromFees(_owner, false);
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
444     function _approve(address sender, address spender, uint256 amount) private {
445         require(sender != address(0), "ERC20: Zero Address");
446         require(spender != address(0), "ERC20: Zero Address");
447 
448         _allowances[sender][spender] = amount;
449         emit Approval(sender, spender, amount);
450     }
451 
452     function approveContractContingency() public onlyOwner returns (bool) {
453         _approve(address(this), address(dexRouter), type(uint256).max);
454         return true;
455     }
456 
457     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
458         if (_allowances[sender][msg.sender] != type(uint256).max) {
459             _allowances[sender][msg.sender] -= amount;
460         }
461 
462         return _transfer(sender, recipient, amount);
463     }
464 
465     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
466         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
467         return true;
468     }
469 
470     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
471         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
472         return true;
473     }
474 
475     function setNewRouter(address newRouter) public onlyOwner() {
476         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
477         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
478         if (get_pair == address(0)) {
479             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
480         }
481         else {
482             lpPair = get_pair;
483         }
484         dexRouter = _newRouter;
485         _approve(address(this), address(dexRouter), type(uint256).max);
486     }
487 
488     function setLpPair(address pair, bool enabled) external onlyOwner {
489         if (enabled == false) {
490             lpPairs[pair] = false;
491             antiSnipe.setLpPair(pair, false);
492         } else {
493             if (timeSinceLastPair != 0) {
494                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
495             }
496             lpPairs[pair] = true;
497             timeSinceLastPair = block.timestamp;
498             antiSnipe.setLpPair(pair, true);
499         }
500     }
501 
502     function isExcludedFromFees(address account) public view returns(bool) {
503         return _isExcludedFromFees[account];
504     }
505 
506     function isExcludedFromLimits(address account) public view returns(bool) {
507         return _isExcludedFromLimits[account];
508     }
509 
510     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
511         _isExcludedFromFees[account] = enabled;
512     }
513 
514     function isExcludedFromReward(address account) public view returns (bool) {
515         return _isExcluded[account];
516     }
517 
518     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
519         _isExcludedFromLimits[account] = enabled;
520     }
521 
522     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
523         if (enabled == true) {
524             require(!_isExcluded[account], "Account is already excluded.");
525             if(_rOwned[account] > 0) {
526                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
527             }
528             _isExcluded[account] = true;
529             _excluded.push(account);
530         } else if (enabled == false) {
531             require(_isExcluded[account], "Account is already included.");
532             if(_excluded.length == 1){
533                 _tOwned[account] = 0;
534                 _isExcluded[account] = false;
535                 _excluded.pop();
536             } else {
537                 for (uint256 i = 0; i < _excluded.length; i++) {
538                     if (_excluded[i] == account) {
539                         _excluded[i] = _excluded[_excluded.length - 1];
540                         _tOwned[account] = 0;
541                         _isExcluded[account] = false;
542                         _excluded.pop();
543                         break;
544                     }
545                 }
546             }
547         }
548     }
549 
550     function setInitializer(address initializer) external onlyOwner {
551         require(!_hasLiqBeenAdded, "Liquidity is already in.");
552         antiSnipe = AntiSnipe(initializer);
553     }
554 
555     function removeSniper(address account) external onlyOwner {
556         antiSnipe.removeSniper(account);
557     }
558 
559 
560     function isBlacklisted(address account) public view returns (bool) {
561         return antiSnipe.isBlacklisted(account);
562     }
563 
564     function removeBlacklisted(address account) external onlyOwner {
565         antiSnipe.removeBlacklisted(account);
566     }
567 
568     function getSniperAmt() public view returns (uint256) {
569         return antiSnipe.getSniperAmt();
570     }
571 
572     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _antiSpecial) external onlyOwner {
573         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _antiSpecial);
574     }
575 
576     function setGasPriceLimit(uint256 gas) external onlyOwner {
577         require(gas >= 75, "Too low.");
578         antiSnipe.setGasPriceLimit(gas);
579     }
580     
581     function setTaxesBuy(uint16 reflectFee, uint16 liquidityFee, uint16 marketingFee) external onlyOwner {
582         require(reflectFee <= staticVals.maxReflectFee
583                 && liquidityFee <= staticVals.maxLiquidityFee
584                 && marketingFee <= staticVals.maxMarketingFee);
585         require(liquidityFee + reflectFee + marketingFee <= 3450);
586         _buyTaxes.liquidityFee = liquidityFee;
587         _buyTaxes.reflectFee = reflectFee;
588         _buyTaxes.marketingFee = marketingFee;
589     }
590 
591     function setTaxesSell(uint16 reflectFee, uint16 liquidityFee, uint16 marketingFee) external onlyOwner {
592         require(reflectFee <= staticVals.maxReflectFee
593                 && liquidityFee <= staticVals.maxLiquidityFee
594                 && marketingFee <= staticVals.maxMarketingFee);
595         require(liquidityFee + reflectFee + marketingFee <= 3450);
596         _sellTaxes.liquidityFee = liquidityFee;
597         _sellTaxes.reflectFee = reflectFee;
598         _sellTaxes.marketingFee = marketingFee;
599     }
600 
601     function setTaxesTransfer(uint16 reflectFee, uint16 liquidityFee, uint16 marketingFee) external onlyOwner {
602         require(reflectFee <= staticVals.maxReflectFee
603                 && liquidityFee <= staticVals.maxLiquidityFee
604                 && marketingFee <= staticVals.maxMarketingFee);
605         require(liquidityFee + reflectFee + marketingFee <= 3450);
606         _transferTaxes.liquidityFee = liquidityFee;
607         _transferTaxes.reflectFee = reflectFee;
608         _transferTaxes.marketingFee = marketingFee;
609     }
610 
611     function setRatios(uint16 liquidity, uint16 marketing) external onlyOwner {
612         require (liquidity + marketing == 100, "Must add up to 100%");
613         _ratios.liquidityRatio = liquidity;
614         _ratios.marketingRatio = marketing;
615         _ratios.totalRatio = liquidity + marketing;
616     }
617 
618     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
619         uint256 check = (_tTotal * percent) / divisor;
620         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
621         _maxTxAmount = check;
622         maxTxAmountUI = (startingSupply * percent) / divisor;
623     }
624 
625     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
626         uint256 check = (_tTotal * percent) / divisor;
627         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
628         _maxWalletSize = check;
629         maxWalletSizeUI = (startingSupply * percent) / divisor;
630     }
631 
632     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
633         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
634         swapAmount = (_tTotal * amountPercent) / amountDivisor;
635     }
636 
637     function setWallets(address payable marketingWallet) external onlyOwner {
638         _marketingWallet = payable(marketingWallet);
639     }
640 
641     function setContractSwapEnabled(bool _enabled) public onlyOwner {
642         contractSwapEnabled = _enabled;
643         emit ContractSwapEnabledUpdated(_enabled);
644     }
645 
646     function _hasLimits(address from, address to) private view returns (bool) {
647         return from != owner()
648             && to != owner()
649             && !_liquidityHolders[to]
650             && !_liquidityHolders[from]
651             && to != DEAD
652             && to != address(0)
653             && from != address(this);
654     }
655 
656     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
657         require(rAmount <= _rTotal, "Amount must be less than total reflections");
658         uint256 currentRate =  _getRate();
659         return rAmount / currentRate;
660     }
661 
662     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
663         require(from != address(0), "ERC20: transfer from the zero address");
664         require(to != address(0), "ERC20: transfer to the zero address");
665         require(amount > 0, "Transfer amount must be greater than zero");
666         if(_hasLimits(from, to)) {
667             if(!tradingEnabled) {
668                 revert("Trading not yet enabled!");
669             }
670             if(lpPairs[from] || lpPairs[to]){
671                 if (!(_isExcludedFromLimits[to] || _isExcludedFromLimits[from])){
672                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
673                 }
674             }
675             if(to != currentRouter && !lpPairs[to]) {
676                 if(!_isExcludedFromLimits[to]) {
677                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
678                 }
679             }
680         }
681 
682         bool takeFee = true;
683         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
684             takeFee = false;
685         }
686 
687         if (lpPairs[to]) {
688             if (!inSwap
689                 && contractSwapEnabled
690             ) {
691                 uint256 contractTokenBalance = balanceOf(address(this));
692                 if (contractTokenBalance >= swapThreshold) {
693                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
694                     contractSwap(contractTokenBalance);
695                 }
696             }      
697         } 
698         return _finalizeTransfer(from, to, amount, takeFee);
699     }
700 
701     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
702         if (_ratios.totalRatio == 0)
703             return;
704 
705         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
706             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
707         }
708 
709         uint256 toLiquify = ((contractTokenBalance * _ratios.liquidityRatio) / _ratios.totalRatio) / 2;
710 
711         uint256 toSwapForEth = contractTokenBalance - toLiquify;
712         
713         address[] memory path = new address[](2);
714         path[0] = address(this);
715         path[1] = dexRouter.WETH();
716 
717         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
718             toSwapForEth,
719             0, // accept any amount of ETH
720             path,
721             address(this),
722             block.timestamp
723         );
724 
725         //uint256 currentBalance = address(this).balance;
726         uint256 liquidityBalance = ((address(this).balance * _ratios.liquidityRatio) / _ratios.totalRatio) / 2;
727 
728         if (toLiquify > 0) {
729             dexRouter.addLiquidityETH{value: liquidityBalance}(
730                 address(this),
731                 toLiquify,
732                 0, // slippage is unavoidable
733                 0, // slippage is unavoidable
734                 DEAD,
735                 block.timestamp
736             );
737             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
738         }
739         if (contractTokenBalance - toLiquify > 0) {
740             _marketingWallet.transfer(address(this).balance);
741         }
742     }
743 
744     function _checkLiquidityAdd(address from, address to) private {
745         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
746         if (!_hasLimits(from, to) && to == lpPair) {
747             if (from == address(this)){
748                 _liquidityHolders[owner()] = true;
749             } else {
750                 _liquidityHolders[from] = true;
751             }
752             _hasLiqBeenAdded = true;
753             if(address(antiSnipe) == address(0)){
754                 antiSnipe = AntiSnipe(address(this));
755             }
756             contractSwapEnabled = true;
757             emit ContractSwapEnabledUpdated(true);
758         }
759     }
760 
761     function enableTrading() public onlyOwner {
762         require(!tradingEnabled, "Trading already enabled!");
763         require(_hasLiqBeenAdded, "Liquidity must be added.");
764         setExcludedFromReward(address(this), true);
765         setExcludedFromReward(lpPair, true);
766         if(address(antiSnipe) == address(0)){
767             antiSnipe = AntiSnipe(address(this));
768         }
769         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp)) {} catch {}
770         tradingEnabled = true;
771     }
772 
773     struct ExtraValues {
774         uint256 tTransferAmount;
775         uint256 tFee;
776         uint256 tLiquidity;
777 
778         uint256 rTransferAmount;
779         uint256 rAmount;
780         uint256 rFee;
781     }
782 
783     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
784         if (!_hasLiqBeenAdded) {
785             _checkLiquidityAdd(from, to);
786             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
787                 revert("Only owner can transfer at this time.");
788             }
789         }
790 
791         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
792 
793         _rOwned[from] = _rOwned[from] - values.rAmount;
794         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
795 
796         if (_isExcluded[from] && !_isExcluded[to]) {
797             _tOwned[from] = _tOwned[from] - tAmount;
798         } else if (!_isExcluded[from] && _isExcluded[to]) {
799             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
800         } else if (_isExcluded[from] && _isExcluded[to]) {
801             _tOwned[from] = _tOwned[from] - tAmount;
802             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
803         }
804 
805         if (values.tLiquidity > 0)
806             _takeLiquidity(from, values.tLiquidity);
807         if (values.rFee > 0 || values.tFee > 0)
808             _rTotal -= values.rFee;
809             _tFeeTotal += values.tFee;
810 
811         emit Transfer(from, to, values.tTransferAmount);
812         return true;
813     }
814 
815     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
816         ExtraValues memory values;
817         uint256 currentRate = _getRate();
818 
819         values.rAmount = tAmount * currentRate;
820 
821         if (_hasLimits(from, to)) {
822             bool checked;
823             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
824                 checked = check;
825             } catch {
826                 revert();
827             }
828 
829             if(!checked) {
830                 revert();
831             }
832         }
833 
834         if(takeFee) {
835             if (lpPairs[to]) {
836                 currentTaxes.reflectFee = _sellTaxes.reflectFee;
837                 currentTaxes.liquidityFee = _sellTaxes.liquidityFee;
838                 currentTaxes.marketingFee = _sellTaxes.marketingFee;
839             } else if (lpPairs[from]) {
840                 currentTaxes.reflectFee = _buyTaxes.reflectFee;
841                 currentTaxes.liquidityFee = _buyTaxes.liquidityFee;
842                 currentTaxes.marketingFee = _buyTaxes.marketingFee;
843             } else {
844                 currentTaxes.reflectFee = _transferTaxes.reflectFee;
845                 currentTaxes.liquidityFee = _transferTaxes.liquidityFee;
846                 currentTaxes.marketingFee = _transferTaxes.marketingFee;
847             }
848 
849             values.tFee = (tAmount * currentTaxes.reflectFee) / staticVals.masterTaxDivisor;
850             values.tLiquidity = (tAmount * (currentTaxes.liquidityFee + currentTaxes.marketingFee)) / staticVals.masterTaxDivisor;
851             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
852 
853             values.rFee = values.tFee * currentRate;
854         } else {
855             values.tFee = 0;
856             values.tLiquidity = 0;
857             values.tTransferAmount = tAmount;
858 
859             values.rFee = 0;
860         }
861         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
862         return values;
863     }
864 
865     function _getRate() private view returns(uint256) {
866         uint256 rSupply = _rTotal;
867         uint256 tSupply = _tTotal;
868         for (uint256 i = 0; i < _excluded.length; i++) {
869             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
870             rSupply = rSupply - _rOwned[_excluded[i]];
871             tSupply = tSupply - _tOwned[_excluded[i]];
872         }
873         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
874         return rSupply / tSupply;
875     }
876     
877     function _takeLiquidity(address sender, uint256 tLiquidity) private {
878         _rOwned[address(this)] = _rOwned[address(this)] + (tLiquidity * _getRate());
879         if(_isExcluded[address(this)])
880             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
881         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
882     }
883 
884     function sweepContingency() external onlyOwner {
885         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
886         payable(owner()).transfer(address(this).balance);
887     }
888 }