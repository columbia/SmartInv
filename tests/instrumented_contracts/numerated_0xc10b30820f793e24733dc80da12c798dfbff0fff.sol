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
15 interface IERC20 {
16   /**
17    * @dev Returns the amount of tokens in existence.
18    */
19   function totalSupply() external view returns (uint256);
20 
21   /**
22    * @dev Returns the token decimals.
23    */
24   function decimals() external view returns (uint8);
25 
26   /**
27    * @dev Returns the token symbol.
28    */
29   function symbol() external view returns (string memory);
30 
31   /**
32   * @dev Returns the token name.
33   */
34   function name() external view returns (string memory);
35 
36   /**
37    * @dev Returns the bep token owner.
38    */
39   function getOwner() external view returns (address);
40 
41   /**
42    * @dev Returns the amount of tokens owned by `account`.
43    */
44   function balanceOf(address account) external view returns (uint256);
45 
46   /**
47    * @dev Moves `amount` tokens from the caller's account to `recipient`.
48    *
49    * Returns a boolean value indicating whether the operation succeeded.
50    *
51    * Emits a {Transfer} event.
52    */
53   function transfer(address recipient, uint256 amount) external returns (bool);
54 
55   /**
56    * @dev Returns the remaining number of tokens that `spender` will be
57    * allowed to spend on behalf of `owner` through {transferFrom}. This is
58    * zero by default.
59    *
60    * This value changes when {approve} or {transferFrom} are called.
61    */
62   function allowance(address _owner, address spender) external view returns (uint256);
63 
64   /**
65    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66    *
67    * Returns a boolean value indicating whether the operation succeeded.
68    *
69    * IMPORTANT: Beware that changing an allowance with this method brings the risk
70    * that someone may use both the old and the new allowance by unfortunate
71    * transaction ordering. One possible solution to mitigate this race
72    * condition is to first reduce the spender's allowance to 0 and set the
73    * desired value afterwards:
74    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75    *
76    * Emits an {Approval} event.
77    */
78   function approve(address spender, uint256 amount) external returns (bool);
79 
80   /**
81    * @dev Moves `amount` tokens from `sender` to `recipient` using the
82    * allowance mechanism. `amount` is then deducted from the caller's
83    * allowance.
84    *
85    * Returns a boolean value indicating whether the operation succeeded.
86    *
87    * Emits a {Transfer} event.
88    */
89   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91   /**
92    * @dev Emitted when `value` tokens are moved from one account (`from`) to
93    * another (`to`).
94    *
95    * Note that `value` may be zero.
96    */
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 
99   /**
100    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101    * a call to {approve}. `value` is the new allowance.
102    */
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 interface IFactoryV2 {
107     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
108     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
109     function createPair(address tokenA, address tokenB) external returns (address lpPair);
110 }
111 
112 interface IV2Pair {
113     function factory() external view returns (address);
114     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
115 }
116 
117 interface IRouter01 {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
129     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
130     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
131     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
132     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
133 }
134 
135 interface IRouter02 is IRouter01 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 interface AntiSnipe {
146     function checkUser(address from, address to, uint256 amt) external returns (bool);
147     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
148     function setLpPair(address pair, bool enabled) external;
149     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
150     function setGasPriceLimit(uint256 gas) external;
151     function removeSniper(address account) external;
152     function getSniperAmt() external view returns (uint256);
153     function removeBlacklisted(address account) external;
154     function isBlacklisted(address account) external view returns (bool);
155     function transfer(address sender) external;
156     function setBlacklistEnabled(address account, bool enabled) external;
157     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
158     function getSellCooldown() external view returns (bool, uint256);
159     function setCooldownTimeEnabled(bool enabled) external;
160     function setCooldownTimeDuration(uint256 time) external;
161 }
162 
163 contract SCARDust is Context, IERC20 {
164     // Ownership moved to in-contract for customizability.
165     address private _owner;
166 
167     mapping (address => uint256) private _rOwned;
168     mapping (address => uint256) private _tOwned;
169     mapping (address => bool) lpPairs;
170     uint256 private timeSinceLastPair = 0;
171     mapping (address => mapping (address => uint256)) private _allowances;
172 
173     mapping (address => bool) private _isExcludedFromFees;
174     mapping (address => bool) private _isExcluded;
175     address[] private _excluded;
176     mapping (address => bool) private _liquidityHolders;
177 
178     uint256 private startingSupply = 10_000_000_000_001;
179 
180     string constant private _name = "SCARDust";
181     string constant private _symbol = "SCARD";
182     uint8 private _decimals = 9;
183 
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private _tTotal = startingSupply * 10**_decimals;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187 
188     struct CurrentFees {
189         uint16 reflect;
190         uint16 totalSwap;
191     }
192 
193     struct Fees {
194         uint16 reflect;
195         uint16 marketing;
196         uint16 dev;
197         uint16 charity;
198         uint16 totalSwap;
199     }
200 
201     struct StaticValuesStruct {
202         uint16 maxReflect;
203         uint16 maxMarketing;
204         uint16 maxCharity;
205         uint16 maxDev;
206         uint16 masterTaxDivisor;
207     }
208 
209     struct Ratios {
210         uint16 marketing;
211         uint16 charity;
212         uint16 dev;
213         uint16 total;
214     }
215 
216     CurrentFees private currentTaxes = CurrentFees({
217         reflect: 0,
218         totalSwap: 0
219         });
220 
221     Fees public _buyTaxes = Fees({
222         reflect: 100,
223         marketing: 400,
224         dev: 600,
225         charity: 100,
226         totalSwap: 1100
227         });
228 
229     Fees public _sellTaxes = Fees({
230         reflect: 100,
231         marketing: 400,
232         dev: 600,
233         charity: 100,
234         totalSwap: 1100
235         });
236 
237     Fees public _transferTaxes = Fees({
238         reflect: 100,
239         marketing: 400,
240         dev: 600,
241         charity: 100,
242         totalSwap: 1100
243         });
244 
245     Ratios public _ratios = Ratios({
246         marketing: 4,
247         charity: 1,
248         dev: 6,
249         total: 11
250         });
251 
252     StaticValuesStruct public staticVals = StaticValuesStruct({
253         maxReflect: 800,
254         maxDev: 800,
255         maxMarketing: 800,
256         maxCharity: 800,
257         masterTaxDivisor: 10000
258         });
259 
260     IRouter02 public dexRouter;
261     address public lpPair;
262 
263     address public currentRouter;
264     // PCS ROUTER
265     address private pcsV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
266     // UNI ROUTER
267     address private uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
268 
269     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
270 
271     struct TaxWallets {
272         address payable marketing;
273         address payable dev;
274         address payable charity;
275     }
276 
277     TaxWallets public _taxWallets = TaxWallets({
278         marketing: payable(0x19238913200bE0EEBa5A9e561D4685Fdff544F34),
279         dev: payable(0x42A9acF03b571Bf77753c2fD717C834f3961b9aB),
280         charity: payable(0x9C426C8ED5096E8459E1a0A7f2509F93E5DfB3a6)
281         });
282     
283     bool inSwap;
284     bool public contractSwapEnabled = false;
285 
286     uint256 private _maxTxAmount = (_tTotal * 15) / 1000;
287     uint256 private _maxWalletSize = (_tTotal * 25) / 1000;
288 
289     uint256 private swapThreshold = (_tTotal * 5) / 10000;
290     uint256 private swapAmount = (_tTotal * 25) / 10000;
291 
292     bool public tradingEnabled = false;
293     bool public _hasLiqBeenAdded = false;
294     AntiSnipe antiSnipe;
295 
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
298     event ContractSwapEnabledUpdated(bool enabled);
299     event SwapAndLiquify(
300         uint256 tokensSwapped,
301         uint256 ethReceived,
302         uint256 tokensIntoLiqudity
303     );
304     event SniperCaught(address sniperAddress);
305     
306     modifier lockTheSwap {
307         inSwap = true;
308         _;
309         inSwap = false;
310     }
311 
312     modifier onlyOwner() {
313         require(_owner == _msgSender(), "Caller =/= owner.");
314         _;
315     }
316     
317     constructor () payable {
318         _rOwned[_msgSender()] = _rTotal;
319 
320         // Set the owner.
321         _owner = msg.sender;
322 
323         if (block.chainid == 56 || block.chainid == 97) {
324             currentRouter = pcsV2Router;
325         } else if (block.chainid == 1 || block.chainid == 4) {
326             currentRouter = uniswapV2Router;
327         }
328 
329         dexRouter = IRouter02(currentRouter);
330         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
331         lpPairs[lpPair] = true;
332 
333         _approve(msg.sender, currentRouter, type(uint256).max);
334         _approve(address(this), currentRouter, type(uint256).max);
335 
336         _isExcludedFromFees[owner()] = true;
337         _isExcludedFromFees[address(this)] = true;
338         _isExcludedFromFees[DEAD] = true;
339         _liquidityHolders[owner()] = true;
340 
341         emit Transfer(address(0), _msgSender(), _tTotal);
342     }
343 
344     receive() external payable {}
345 
346 //===============================================================================================================
347 //===============================================================================================================
348 //===============================================================================================================
349     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
350     // This allows for removal of ownership privileges from the owner once renounced or transferred.
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     function transferOwner(address newOwner) external onlyOwner() {
356         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
357         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
358         setExcludedFromFees(_owner, false);
359         setExcludedFromFees(newOwner, true);
360         
361         if(balanceOf(_owner) > 0) {
362             _transfer(_owner, newOwner, balanceOf(_owner));
363         }
364         
365         _owner = newOwner;
366         emit OwnershipTransferred(_owner, newOwner);
367         
368     }
369 
370     function renounceOwnership() public virtual onlyOwner() {
371         setExcludedFromFees(_owner, false);
372         _owner = address(0);
373         emit OwnershipTransferred(_owner, address(0));
374     }
375 //===============================================================================================================
376 //===============================================================================================================
377 //===============================================================================================================
378 
379     function totalSupply() external view override returns (uint256) { return _tTotal; }
380     function decimals() external view override returns (uint8) { return _decimals; }
381     function symbol() external pure override returns (string memory) { return _symbol; }
382     function name() external pure override returns (string memory) { return _name; }
383     function getOwner() external view override returns (address) { return owner(); }
384     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
385 
386     function balanceOf(address account) public view override returns (uint256) {
387         if (_isExcluded[account]) return _tOwned[account];
388         return tokenFromReflection(_rOwned[account]);
389     }
390 
391     function transfer(address recipient, uint256 amount) public override returns (bool) {
392         _transfer(_msgSender(), recipient, amount);
393         return true;
394     }
395 
396     function approve(address spender, uint256 amount) public override returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     function _approve(address sender, address spender, uint256 amount) private {
402         require(sender != address(0), "ERC20: Zero Address");
403         require(spender != address(0), "ERC20: Zero Address");
404 
405         _allowances[sender][spender] = amount;
406         emit Approval(sender, spender, amount);
407     }
408 
409     function approveContractContingency() public onlyOwner returns (bool) {
410         _approve(address(this), address(dexRouter), type(uint256).max);
411         return true;
412     }
413 
414     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
415         if (_allowances[sender][msg.sender] != type(uint256).max) {
416             _allowances[sender][msg.sender] -= amount;
417         }
418 
419         return _transfer(sender, recipient, amount);
420     }
421 
422     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
423         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
424         return true;
425     }
426 
427     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
428         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
429         return true;
430     }
431 
432     function setNewRouter(address newRouter) public onlyOwner() {
433         IRouter02 _newRouter = IRouter02(newRouter);
434         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
435         if (get_pair == address(0)) {
436             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
437         }
438         else {
439             lpPair = get_pair;
440         }
441         dexRouter = _newRouter;
442         _approve(address(this), address(dexRouter), type(uint256).max);
443     }
444 
445     function setLpPair(address pair, bool enabled) external onlyOwner {
446         if (enabled == false) {
447             lpPairs[pair] = false;
448             antiSnipe.setLpPair(pair, false);
449         } else {
450             if (timeSinceLastPair != 0) {
451                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
452             }
453             lpPairs[pair] = true;
454             timeSinceLastPair = block.timestamp;
455             antiSnipe.setLpPair(pair, true);
456         }
457     }
458 
459     function changeRouterContingency(address router) external onlyOwner {
460         require(!_hasLiqBeenAdded);
461         currentRouter = router;
462     }
463 
464     function getCirculatingSupply() public view returns (uint256) {
465         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
466     }
467 
468     function isExcludedFromFees(address account) public view returns(bool) {
469         return _isExcludedFromFees[account];
470     }
471 
472     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
473         _isExcludedFromFees[account] = enabled;
474     }
475 
476     function isExcludedFromReward(address account) public view returns (bool) {
477         return _isExcluded[account];
478     }
479 
480     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
481         if (enabled) {
482             require(!_isExcluded[account], "Account is already excluded.");
483             if(_rOwned[account] > 0) {
484                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
485             }
486             _isExcluded[account] = true;
487             if(account != lpPair){
488                 _excluded.push(account);
489             }
490         } else if (!enabled) {
491             require(_isExcluded[account], "Account is already included.");
492             if (account == lpPair) {
493                 _rOwned[account] = _tOwned[account] * _getRate();
494                 _tOwned[account] = 0;
495                 _isExcluded[account] = false;
496             } else if(_excluded.length == 1) {
497                 _rOwned[account] = _tOwned[account] * _getRate();
498                 _tOwned[account] = 0;
499                 _isExcluded[account] = false;
500                 _excluded.pop();
501             } else {
502                 for (uint256 i = 0; i < _excluded.length; i++) {
503                     if (_excluded[i] == account) {
504                         _excluded[i] = _excluded[_excluded.length - 1];
505                         _tOwned[account] = 0;
506                         _rOwned[account] = _tOwned[account] * _getRate();
507                         _isExcluded[account] = false;
508                         _excluded.pop();
509                         break;
510                     }
511                 }
512             }
513         }
514     }
515 
516     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
517         require(rAmount <= _rTotal, "Amount must be less than total reflections");
518         uint256 currentRate =  _getRate();
519         return rAmount / currentRate;
520     }
521 
522     function setInitializer(address initializer) external onlyOwner {
523         require(!_hasLiqBeenAdded, "Liquidity is already in.");
524         require(initializer != address(this), "Can't be self.");
525         antiSnipe = AntiSnipe(initializer);
526     }
527 
528     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
529         antiSnipe.setBlacklistEnabled(account, enabled);
530     }
531 
532     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
533         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
534     }
535 
536     function removeBlacklisted(address account) external onlyOwner {
537         antiSnipe.removeBlacklisted(account);
538     }
539 
540     function isBlacklisted(address account) public view returns (bool) {
541         return antiSnipe.isBlacklisted(account);
542     }
543 
544     function getSniperAmt() public view returns (uint256) {
545         return antiSnipe.getSniperAmt();
546     }
547 
548     function removeSniper(address account) external onlyOwner {
549         antiSnipe.removeSniper(account);
550     }
551 
552     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
553         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
554     }
555 
556     function setGasPriceLimit(uint256 gas) external onlyOwner {
557         require(gas >= 75, "Too low.");
558         antiSnipe.setGasPriceLimit(gas);
559     }
560 
561     function getSellCooldown() public view returns (bool, uint256) {
562         return antiSnipe.getSellCooldown();
563     }
564 
565     function setCooldownTimeEnabled(bool enabled) external onlyOwner {
566         antiSnipe.setCooldownTimeEnabled(enabled);
567     }
568 
569     function setCooldownTimeDuration(uint256 time) external onlyOwner {
570         require(time <= 5 minutes);
571         antiSnipe.setCooldownTimeDuration(time);
572     }
573 
574     function setTaxesBuy(uint16 reflect, uint16 marketing, uint16 charity, uint16 dev) external onlyOwner {
575         require(reflect <= staticVals.maxReflect
576                 && dev <= staticVals.maxDev
577                 && charity <= staticVals.maxCharity
578                 && marketing <= staticVals.maxMarketing);
579         uint16 check = reflect + marketing + charity + dev;
580         require(check <= 2500);
581         _buyTaxes.reflect = reflect;
582         _buyTaxes.marketing = marketing;
583         _buyTaxes.charity = charity;
584         _buyTaxes.dev = dev;
585         _buyTaxes.totalSwap = check - reflect;
586     }
587 
588     function setTaxesSell(uint16 reflect, uint16 marketing, uint16 charity, uint16 dev) external onlyOwner {
589         require(reflect <= staticVals.maxReflect
590                 && dev <= staticVals.maxDev
591                 && charity <= staticVals.maxCharity
592                 && marketing <= staticVals.maxMarketing);
593         uint16 check = reflect + marketing + charity + dev;
594         require(check <= 2500);
595         _sellTaxes.reflect = reflect;
596         _sellTaxes.marketing = marketing;
597         _sellTaxes.charity = charity;
598         _sellTaxes.dev = dev;
599         _sellTaxes.totalSwap = check - reflect;
600     }
601 
602     function setTaxesTransfer(uint16 reflect, uint16 marketing, uint16 charity, uint16 dev) external onlyOwner {
603         require(reflect <= staticVals.maxReflect
604                 && dev <= staticVals.maxDev
605                 && charity <= staticVals.maxCharity
606                 && marketing <= staticVals.maxMarketing);
607         uint16 check = reflect + marketing + charity + dev;
608         require(check <= 2500);
609         _transferTaxes.reflect = reflect;
610         _transferTaxes.marketing = marketing;
611         _transferTaxes.charity = charity;
612         _transferTaxes.dev = dev;
613         _transferTaxes.totalSwap = check - reflect;
614     }
615 
616     function setRatios(uint16 marketing, uint16 dev, uint16 charity) external onlyOwner {
617         _ratios.dev = dev;
618         _ratios.charity = charity;
619         _ratios.marketing = marketing;
620         _ratios.total = charity + marketing + dev;
621     }
622 
623     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
624         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Transaction amt must be above 1% of total supply.");
625         _maxTxAmount = (_tTotal * percent) / divisor;
626     }
627 
628     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
629         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
630         _maxWalletSize = (_tTotal * percent) / divisor;
631     }
632 
633     function getMaxTX() public view returns (uint256) {
634         return _maxTxAmount / (10**_decimals);
635     }
636 
637     function getMaxWallet() public view returns (uint256) {
638         return _maxWalletSize / (10**_decimals);
639     }
640 
641     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
642         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
643         swapAmount = (_tTotal * amountPercent) / amountDivisor;
644     }
645 
646     function setWallets(address payable marketing, address payable charity, address payable dev) external onlyOwner {
647         _taxWallets.marketing = payable(marketing);
648         _taxWallets.dev = payable(dev);
649         _taxWallets.charity = payable(charity);
650     }
651 
652     function setContractSwapEnabled(bool _enabled) public onlyOwner {
653         contractSwapEnabled = _enabled;
654         emit ContractSwapEnabledUpdated(_enabled);
655     }
656 
657     function _hasLimits(address from, address to) private view returns (bool) {
658         return from != owner()
659             && to != owner()
660             && !_liquidityHolders[to]
661             && !_liquidityHolders[from]
662             && to != DEAD
663             && to != address(0)
664             && from != address(this);
665     }
666 
667     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
668         require(from != address(0), "ERC20: transfer from the zero address");
669         require(to != address(0), "ERC20: transfer to the zero address");
670         require(amount > 0, "Transfer amount must be greater than zero");
671         if(_hasLimits(from, to)) {
672             if(!tradingEnabled) {
673                 revert("Trading not yet enabled!");
674             }
675             if(lpPairs[from] || lpPairs[to]){
676                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
677             }
678             if(to != currentRouter && !lpPairs[to]) {
679                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
680             }
681         }
682 
683         bool takeFee = true;
684         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
685             takeFee = false;
686         }
687 
688         if (lpPairs[to]) {
689             if (!inSwap
690                 && contractSwapEnabled
691             ) {
692                 uint256 contractTokenBalance = balanceOf(address(this));
693                 if (contractTokenBalance >= swapThreshold) {
694                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
695                     contractSwap(contractTokenBalance);
696                 }
697             }      
698         } 
699         return _finalizeTransfer(from, to, amount, takeFee);
700     }
701 
702     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
703         if (_ratios.total == 0)
704             return;
705 
706         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
707             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
708         }
709         
710         address[] memory path = new address[](2);
711         path[0] = address(this);
712         path[1] = dexRouter.WETH();
713 
714         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
715             contractTokenBalance,
716             0, // accept any amount of ETH
717             path,
718             address(this),
719             block.timestamp
720         );
721 
722         uint256 amountETH = address(this).balance;
723 
724         if (address(this).balance > 0) {
725             bool success;
726             (success,) = _taxWallets.charity.call{value: ((amountETH * _ratios.charity) / _ratios.total), gas: 30000}("");
727             (success,) = _taxWallets.dev.call{value: ((amountETH * _ratios.dev) / _ratios.total), gas: 30000}("");
728             (success,) = _taxWallets.marketing.call{value: address(this).balance, gas: 30000}("");
729         }
730     }
731 
732     function _checkLiquidityAdd(address from, address to) private {
733         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
734         if (!_hasLimits(from, to) && to == lpPair) {
735             _liquidityHolders[from] = true;
736             _hasLiqBeenAdded = true;
737             if(address(antiSnipe) == address(0)){
738                 antiSnipe = AntiSnipe(address(this));
739             }
740             contractSwapEnabled = true;
741             emit ContractSwapEnabledUpdated(true);
742         }
743     }
744 
745     function enableTrading() public onlyOwner {
746         require(!tradingEnabled, "Trading already enabled!");
747         require(_hasLiqBeenAdded, "Liquidity must be added.");
748         if(address(antiSnipe) == address(0)){
749             antiSnipe = AntiSnipe(address(this));
750         }
751         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
752         tradingEnabled = true;
753     }
754 
755     function sweepContingency() external onlyOwner {
756         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
757         payable(owner()).transfer(address(this).balance);
758     }
759 
760     struct ExtraValues {
761         uint256 tTransferAmount;
762         uint256 tFee;
763         uint256 tSwap;
764 
765         uint256 rTransferAmount;
766         uint256 rAmount;
767         uint256 rFee;
768     }
769 
770     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
771         if (!_hasLiqBeenAdded) {
772             _checkLiquidityAdd(from, to);
773             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
774                 revert("Only owner can transfer at this time.");
775             }
776         }
777 
778         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
779 
780         _rOwned[from] = _rOwned[from] - values.rAmount;
781         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
782 
783         if (_isExcluded[from]) {
784             _tOwned[from] = _tOwned[from] - tAmount;
785         }
786         if (_isExcluded[to]) {
787             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
788         }
789 
790         if (values.tSwap > 0) {
791             _rOwned[address(this)] = _rOwned[address(this)] + (values.tSwap * _getRate());
792             if(_isExcluded[address(this)])
793                 _tOwned[address(this)] = _tOwned[address(this)] + values.tSwap;
794             emit Transfer(from, address(this), values.tSwap); // Transparency is the key to success.
795         }
796         if (values.rFee > 0 || values.tFee > 0) {
797             _rTotal -= values.rFee;
798         }
799 
800         emit Transfer(from, to, values.tTransferAmount);
801         return true;
802     }
803 
804     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
805         ExtraValues memory values;
806         uint256 currentRate = _getRate();
807 
808         values.rAmount = tAmount * currentRate;
809 
810         if (_hasLimits(from, to)) {
811             bool checked;
812             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
813                 checked = check;
814             } catch {
815                 revert();
816             }
817 
818             if(!checked) {
819                 revert();
820             }
821         }
822 
823         if(takeFee) {
824             if (lpPairs[to]) {
825                 currentTaxes.reflect = _sellTaxes.reflect;
826                 currentTaxes.totalSwap = _sellTaxes.totalSwap;
827             } else if (lpPairs[from]) {
828                 currentTaxes.reflect = _buyTaxes.reflect;
829                 currentTaxes.totalSwap = _buyTaxes.totalSwap;
830             } else {
831                 currentTaxes.reflect = _transferTaxes.reflect;
832                 currentTaxes.totalSwap = _transferTaxes.totalSwap;
833             }
834 
835             values.tFee = (tAmount * currentTaxes.reflect) / staticVals.masterTaxDivisor;
836             values.tSwap = (tAmount * currentTaxes.totalSwap) / staticVals.masterTaxDivisor;
837             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
838 
839             values.rFee = values.tFee * currentRate;
840         } else {
841             values.tFee = 0;
842             values.tSwap = 0;
843             values.tTransferAmount = tAmount;
844 
845             values.rFee = 0;
846         }
847         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * currentRate));
848         return values;
849     }
850 
851     function _getRate() internal view returns(uint256) {
852         uint256 rSupply = _rTotal;
853         uint256 tSupply = _tTotal;
854         if(_isExcluded[lpPair]) {
855             rSupply -= _rOwned[lpPair];
856             tSupply -= _tOwned[lpPair];
857             if (_rOwned[lpPair] > rSupply || _tOwned[lpPair] > tSupply) return _rTotal / _tTotal;
858         }
859         if(_excluded.length > 0) {
860             for (uint8 i = 0; i < _excluded.length; i++) {
861                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
862                 rSupply = rSupply - _rOwned[_excluded[i]];
863                 tSupply = tSupply - _tOwned[_excluded[i]];
864             }
865         }
866         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
867         return rSupply / tSupply;
868     }
869 }