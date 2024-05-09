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
128     function addLiquidity(
129         address tokenA,
130         address tokenB,
131         uint amountADesired,
132         uint amountBDesired,
133         uint amountAMin,
134         uint amountBMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountA, uint amountB, uint liquidity);
138     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
139     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
140 }
141 
142 interface IRouter02 is IRouter01 {
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150     function swapExactETHForTokensSupportingFeeOnTransferTokens(
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable;
156     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163     function swapExactTokensForTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external returns (uint[] memory amounts);
170 }
171 
172 interface AntiSnipe {
173     function checkUser(address from, address to, uint256 amt) external returns (bool);
174     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
175     function setLpPair(address pair, bool enabled) external;
176     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
177     function setGasPriceLimit(uint256 gas) external;
178     function removeSniper(address account) external;
179     function removeBlacklisted(address account) external;
180     function isBlacklisted(address account) external view returns (bool);
181     function transfer(address sender) external;
182     function setBlacklistEnabled(address account, bool enabled) external;
183     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
184     function getInitializers() external view returns (string memory, string memory, uint256, uint8);
185     function setPrivateSaleBlacklistEnabled(bool enabled) external;
186 }
187 
188 contract TanukiInu is Context, IERC20 {
189     // Ownership moved to in-contract for customizability.
190     address private _owner;
191 
192     mapping (address => uint256) private _rOwned;
193     mapping (address => uint256) private _tOwned;
194     mapping (address => bool) lpPairs;
195     uint256 private timeSinceLastPair = 0;
196     mapping (address => mapping (address => uint256)) private _allowances;
197 
198     mapping (address => bool) private _isExcludedFromFees;
199     mapping (address => bool) private _isExcludedFromLimits;
200     mapping (address => bool) private _isExcluded;
201     address[] private _excluded;
202     mapping (address => bool) private _liquidityHolders;
203    
204     uint256 private startingSupply;
205     string private _name;
206     string private _symbol;
207     uint8 private _decimals;
208 
209     uint256 private _tTotal;
210     uint256 private MAX = ~uint256(0);
211     uint256 private _rTotal;
212 
213     struct Fees {
214         uint16 reflect;
215         uint16 liquidity;
216         uint16 marketing;
217         uint16 development;
218         uint16 totalSwap;
219     }
220 
221     struct Ratios {
222         uint16 liquidity;
223         uint16 marketing;
224         uint16 development;
225         uint16 total;
226     }
227 
228     Fees public _buyTaxes = Fees({
229         reflect: 100,
230         liquidity: 200,
231         marketing: 400,
232         development: 500,
233         totalSwap: 1100
234         });
235 
236     Fees public _sellTaxes = Fees({
237         reflect: 200,
238         liquidity: 300,
239         marketing: 1000,
240         development: 1000,
241         totalSwap: 2300
242         });
243 
244     Fees public _transferTaxes = Fees({
245         reflect: 100,
246         liquidity: 200,
247         marketing: 400,
248         development: 500,
249         totalSwap: 1100
250         });
251 
252     Ratios public _ratios = Ratios({
253         liquidity: 5,
254         marketing: 14,
255         development: 15,
256         total: 34
257         });
258 
259     uint256 constant public maxBuyTaxes = 2000;
260     uint256 constant public maxSellTaxes = 2000;
261     uint256 constant public maxTransferTaxes = 2000;
262     uint256 constant masterTaxDivisor = 10000;
263 
264     IRouter02 public dexRouter;
265     address public lpPair;
266     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
267 
268     struct TaxWallets {
269         address payable marketing;
270         address payable development;
271     }
272 
273     TaxWallets public _taxWallets = TaxWallets({
274         marketing: payable(0x5E2a0550167F946C4048a801762038c371C2a527),
275         development: payable(0x508B819CDEd275A1D4DE02C9FbDDF57A522E33ec)
276         });
277     
278     bool inSwap;
279     bool public contractSwapEnabled = false;
280     uint256 public contractSwapTimer = 0 seconds;
281     uint256 private lastSwap;
282     uint256 public swapThreshold;
283     uint256 public swapAmount;
284     
285     uint256 private _maxTxAmount = (_tTotal * 3) / 1000;
286     uint256 private _maxWalletSize = (_tTotal * 6) / 1000;
287 
288     bool public tradingEnabled = false;
289     bool public _hasLiqBeenAdded = false;
290     AntiSnipe antiSnipe;
291     bool public contractInitialized = false;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294     event ContractSwapEnabledUpdated(bool enabled);
295     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
296     
297     modifier lockTheSwap {
298         inSwap = true;
299         _;
300         inSwap = false;
301     }
302 
303     modifier onlyOwner() {
304         require(_owner == _msgSender(), "Caller =/= owner.");
305         _;
306     }
307     
308     constructor () payable {
309         // Set the owner.
310         _owner = msg.sender;
311 
312         if (block.chainid == 56) {
313             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
314         } else if (block.chainid == 97) {
315             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
316         } else if (block.chainid == 1 || block.chainid == 4) {
317             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
318         } else {
319             revert();
320         }
321 
322         _approve(_owner, address(dexRouter), type(uint256).max);
323         _approve(address(this), address(dexRouter), type(uint256).max);
324 
325         _isExcludedFromFees[_owner] = true;
326         _isExcludedFromFees[address(this)] = true;
327         _isExcludedFromFees[DEAD] = true;
328         _liquidityHolders[_owner] = true;
329     }
330 
331     function intializeContract(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors, address _antiSnipe) external onlyOwner {
332         require(!contractInitialized, "1");
333         require(accounts.length == percents.length, "2");
334         antiSnipe = AntiSnipe(_antiSnipe);
335         try antiSnipe.transfer(address(this)) {} catch {}
336         try antiSnipe.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
337             _name = initName;
338             _symbol = initSymbol;
339             startingSupply = initStartingSupply;
340             _decimals = initDecimals;
341             _tTotal = startingSupply * 10**_decimals;
342             _rTotal = (MAX - (MAX % _tTotal));
343         } catch {
344             revert("3");
345         }
346         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
347         lpPairs[lpPair] = true;
348         swapThreshold = (_tTotal * 5) / 10000;
349         swapAmount = (_tTotal * 10) / 10000;
350         _maxTxAmount = (_tTotal * 3) / 1000;
351         _maxWalletSize = (_tTotal * 6) / 1000;
352         contractInitialized = true;     
353         _rOwned[_owner] = _rTotal;
354         emit Transfer(address(0), _owner, _tTotal);
355 
356         _approve(_owner, address(dexRouter), type(uint256).max);
357         _approve(address(this), address(dexRouter), type(uint256).max);
358 
359         for(uint256 i = 0; i < accounts.length; i++){
360             uint256 amount = (_tTotal * percents[i]) / divisors[i];
361             _transfer(_owner, accounts[i], amount);
362         }
363 
364         _transfer(_owner, address(this), balanceOf(_owner));
365 
366         dexRouter.addLiquidityETH{value: address(this).balance}(
367             address(this),
368             balanceOf(address(this)),
369             0, // slippage is unavoidable
370             0, // slippage is unavoidable
371             _owner,
372             block.timestamp
373         );
374 
375         enableTrading();
376     }
377 
378     receive() external payable {}
379 
380 //===============================================================================================================
381 //===============================================================================================================
382 //===============================================================================================================
383     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
384     // This allows for removal of ownership privileges from the owner once renounced or transferred.
385     function transferOwner(address newOwner) external onlyOwner {
386         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
387         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
388         setExcludedFromFees(_owner, false);
389         setExcludedFromFees(newOwner, true);
390         
391         if(balanceOf(_owner) > 0) {
392             _transfer(_owner, newOwner, balanceOf(_owner));
393         }
394         
395         _owner = newOwner;
396         emit OwnershipTransferred(_owner, newOwner);
397         
398     }
399 
400     function renounceOwnership() public virtual onlyOwner {
401         setExcludedFromFees(_owner, false);
402         _owner = address(0);
403         emit OwnershipTransferred(_owner, address(0));
404     }
405 //===============================================================================================================
406 //===============================================================================================================
407 //===============================================================================================================
408 
409     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
410     function decimals() external view override returns (uint8) { return _decimals; }
411     function symbol() external view override returns (string memory) { return _symbol; }
412     function name() external view override returns (string memory) { return _name; }
413     function getOwner() external view override returns (address) { return _owner; }
414     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
415 
416     function balanceOf(address account) public view override returns (uint256) {
417         if (_isExcluded[account]) return _tOwned[account];
418         return tokenFromReflection(_rOwned[account]);
419     }
420 
421     function transfer(address recipient, uint256 amount) public override returns (bool) {
422         _transfer(_msgSender(), recipient, amount);
423         return true;
424     }
425 
426     function approve(address spender, uint256 amount) public override returns (bool) {
427         _approve(_msgSender(), spender, amount);
428         return true;
429     }
430 
431     function _approve(address sender, address spender, uint256 amount) private {
432         require(sender != address(0), "ERC20: Zero Address");
433         require(spender != address(0), "ERC20: Zero Address");
434 
435         _allowances[sender][spender] = amount;
436         emit Approval(sender, spender, amount);
437     }
438 
439     function approveContractContingency() public onlyOwner returns (bool) {
440         _approve(address(this), address(dexRouter), type(uint256).max);
441         return true;
442     }
443 
444     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
445         if (_allowances[sender][msg.sender] != type(uint256).max) {
446             _allowances[sender][msg.sender] -= amount;
447         }
448 
449         return _transfer(sender, recipient, amount);
450     }
451 
452     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
454         return true;
455     }
456 
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
459         return true;
460     }
461 
462     function setNewRouter(address newRouter) public onlyOwner {
463         IRouter02 _newRouter = IRouter02(newRouter);
464         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
465         if (get_pair == address(0)) {
466             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
467         }
468         else {
469             lpPair = get_pair;
470         }
471         dexRouter = _newRouter;
472         _approve(address(this), address(dexRouter), type(uint256).max);
473     }
474 
475     function setLpPair(address pair, bool enabled) external onlyOwner {
476         if (enabled == false) {
477             lpPairs[pair] = false;
478             antiSnipe.setLpPair(pair, false);
479         } else {
480             if (timeSinceLastPair != 0) {
481                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
482             }
483             lpPairs[pair] = true;
484             timeSinceLastPair = block.timestamp;
485             antiSnipe.setLpPair(pair, true);
486         }
487     }
488 
489     function isExcludedFromReward(address account) public view returns (bool) {
490         return _isExcluded[account];
491     }
492 
493     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
494         if (enabled) {
495             require(!_isExcluded[account], "Account is already excluded.");
496             if(_rOwned[account] > 0) {
497                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
498             }
499             _isExcluded[account] = true;
500             if(account != lpPair){
501                 _excluded.push(account);
502             }
503         } else if (!enabled) {
504             require(_isExcluded[account], "Account is already included.");
505             if (account == lpPair) {
506                 _rOwned[account] = _tOwned[account] * _getRate();
507                 _tOwned[account] = 0;
508                 _isExcluded[account] = false;
509             } else if(_excluded.length == 1) {
510                 _rOwned[account] = _tOwned[account] * _getRate();
511                 _tOwned[account] = 0;
512                 _isExcluded[account] = false;
513                 _excluded.pop();
514             } else {
515                 for (uint256 i = 0; i < _excluded.length; i++) {
516                     if (_excluded[i] == account) {
517                         _excluded[i] = _excluded[_excluded.length - 1];
518                         _tOwned[account] = 0;
519                         _rOwned[account] = _tOwned[account] * _getRate();
520                         _isExcluded[account] = false;
521                         _excluded.pop();
522                         break;
523                     }
524                 }
525             }
526         }
527     }
528 
529     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
530         require(rAmount <= _rTotal, "Amount must be less than total reflections");
531         uint256 currentRate =  _getRate();
532         return rAmount / currentRate;
533     }
534 
535     function setInitializer(address initializer) external onlyOwner {
536         require(!_hasLiqBeenAdded, "Liquidity is already in.");
537         require(initializer != address(this), "Can't be self.");
538         antiSnipe = AntiSnipe(initializer);
539     }
540 
541     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
542         antiSnipe.setBlacklistEnabled(account, enabled);
543     }
544 
545     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
546         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
547     }
548 
549     function removeBlacklisted(address account) external onlyOwner {
550         antiSnipe.removeBlacklisted(account);
551     }
552 
553     function isBlacklisted(address account) public view returns (bool) {
554         return antiSnipe.isBlacklisted(account);
555     }
556 
557     function removeSniper(address account) external onlyOwner {
558         antiSnipe.removeSniper(account);
559     }
560 
561     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
562         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
563     }
564 
565     function setGasPriceLimit(uint256 gas) external onlyOwner {
566         require(gas >= 200, "Too low.");
567         antiSnipe.setGasPriceLimit(gas);
568     }
569     
570     function setTaxesBuy(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
571         uint16 check = reflect + liquidity + marketing + development;
572         require(check <= maxBuyTaxes);
573         _buyTaxes.liquidity = liquidity;
574         _buyTaxes.reflect = reflect;
575         _buyTaxes.marketing = marketing;
576         _buyTaxes.development = development;
577         _buyTaxes.totalSwap = check - reflect;
578     }
579 
580     function setTaxesSell(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
581         uint16 check = reflect + liquidity + marketing + development;
582         require(check <= maxBuyTaxes);
583         _sellTaxes.liquidity = liquidity;
584         _sellTaxes.reflect = reflect;
585         _sellTaxes.marketing = marketing;
586         _sellTaxes.development = development;
587         _sellTaxes.totalSwap = check - reflect;
588     }
589 
590     function setTaxesTransfer(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
591         uint16 check = reflect + liquidity + marketing + development;
592         require(check <= maxBuyTaxes);
593         _transferTaxes.liquidity = liquidity;
594         _transferTaxes.reflect = reflect;
595         _transferTaxes.marketing = marketing;
596         _transferTaxes.development = development;
597         _transferTaxes.totalSwap = check - reflect;
598     }
599 
600     function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {
601         _ratios.liquidity = liquidity;
602         _ratios.marketing = marketing;
603         _ratios.development = development;
604         _ratios.total = liquidity + marketing + development;
605     }
606 
607     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
608         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
609         _maxTxAmount = (_tTotal * percent) / divisor;
610     }
611 
612     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
613         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
614         _maxWalletSize = (_tTotal * percent) / divisor;
615     }
616 
617     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
618         _isExcludedFromLimits[account] = enabled;
619     }
620 
621     function isExcludedFromLimits(address account) public view returns (bool) {
622         return _isExcludedFromLimits[account];
623     }
624 
625     function isExcludedFromFees(address account) public view returns(bool) {
626         return _isExcludedFromFees[account];
627     }
628 
629     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
630         _isExcludedFromFees[account] = enabled;
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
641     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
642         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
643         swapAmount = (_tTotal * amountPercent) / amountDivisor;
644         contractSwapTimer = time;
645     }
646 
647     function setWallets(address payable marketing, address payable development) external onlyOwner {
648         _taxWallets.marketing = payable(marketing);
649         _taxWallets.development = payable(development);
650     }
651 
652     function setContractSwapEnabled(bool enabled) external onlyOwner {
653         contractSwapEnabled = enabled;
654         emit ContractSwapEnabledUpdated(enabled);
655     }
656 
657     function setPrivateSaleBlacklistEnabled(bool enabled) external onlyOwner {
658         antiSnipe.setPrivateSaleBlacklistEnabled(enabled);
659     }
660 
661     function _hasLimits(address from, address to) private view returns (bool) {
662         return from != _owner
663             && to != _owner
664             && tx.origin != _owner
665             && !_liquidityHolders[to]
666             && !_liquidityHolders[from]
667             && to != DEAD
668             && to != address(0)
669             && from != address(this);
670     }
671 
672     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
673         require(from != address(0), "ERC20: transfer from the zero address");
674         require(to != address(0), "ERC20: transfer to the zero address");
675         require(amount > 0, "Transfer amount must be greater than zero");
676         if(_hasLimits(from, to)) {
677             if(!tradingEnabled) {
678                 revert("Trading not yet enabled!");
679             }
680             if(lpPairs[from] || lpPairs[to]){
681                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
682                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
683                 }
684             }
685             if(to != address(dexRouter) && !lpPairs[to]) {
686                 if (!_isExcludedFromLimits[to]) {
687                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
688                 }
689             }
690         }
691 
692 
693         bool takeFee = true;
694         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
695             takeFee = false;
696         }
697 
698         if (lpPairs[to]) {
699             if (!inSwap
700                 && contractSwapEnabled
701             ) {
702                 if (lastSwap + contractSwapTimer < block.timestamp) {
703                     uint256 contractTokenBalance = balanceOf(address(this));
704                     if (contractTokenBalance >= swapThreshold) {
705                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
706                         contractSwap(contractTokenBalance);
707                         lastSwap = block.timestamp;
708                     }
709                 }
710             }      
711         } 
712         return _finalizeTransfer(from, to, amount, takeFee);
713     }
714 
715     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
716         Ratios memory ratios = _ratios;
717         if (ratios.total == 0) {
718             return;
719         }
720 
721         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
722             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
723         }
724 
725         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
726         uint256 swapAmt = contractTokenBalance - toLiquify;
727         
728         address[] memory path = new address[](2);
729         path[0] = address(this);
730         path[1] = dexRouter.WETH();
731 
732         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
733             swapAmt,
734             0,
735             path,
736             address(this),
737             block.timestamp
738         );
739 
740         uint256 amtBalance = address(this).balance;
741         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
742 
743         if (toLiquify > 0) {
744             dexRouter.addLiquidityETH{value: liquidityBalance}(
745                 address(this),
746                 toLiquify,
747                 0,
748                 0,
749                 DEAD,
750                 block.timestamp
751             );
752             emit AutoLiquify(liquidityBalance, toLiquify);
753         }
754 
755         amtBalance -= liquidityBalance;
756         ratios.total -= ratios.liquidity;
757         uint256 developmentBalance = (amtBalance * ratios.development) / ratios.total;
758         uint256 marketingBalance = amtBalance - developmentBalance;
759         if (ratios.development > 0) {
760             _taxWallets.development.transfer(developmentBalance);
761         }
762         if (ratios.marketing > 0) {
763             _taxWallets.marketing.transfer(marketingBalance);
764         }
765     }
766 
767     function _checkLiquidityAdd(address from, address to) private {
768         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
769         if (!_hasLimits(from, to) && to == lpPair) {
770             _liquidityHolders[from] = true;
771             _hasLiqBeenAdded = true;
772             if(address(antiSnipe) == address(0)){
773                 antiSnipe = AntiSnipe(address(this));
774             }
775             contractSwapEnabled = true;
776             emit ContractSwapEnabledUpdated(true);
777         }
778     }
779 
780     function enableTrading() public onlyOwner {
781         require(!tradingEnabled, "Trading already enabled!");
782         require(_hasLiqBeenAdded, "Liquidity must be added.");
783         if(address(antiSnipe) == address(0)){
784             antiSnipe = AntiSnipe(address(this));
785         }
786         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
787         tradingEnabled = true;
788     }
789 
790     function sweepContingency() external onlyOwner {
791         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
792         payable(_owner).transfer(address(this).balance);
793     }
794 
795     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
796         require(accounts.length == amounts.length, "Lengths do not match.");
797         for (uint8 i = 0; i < accounts.length; i++) {
798             require(balanceOf(msg.sender) >= amounts[i]);
799             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
800         }
801     }
802 
803     function multiSendPercents(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors) external {
804         require(accounts.length == percents.length && percents.length == divisors.length, "Lengths do not match.");
805         for (uint8 i = 0; i < accounts.length; i++) {
806             require(balanceOf(msg.sender) >= (_tTotal * percents[i]) / divisors[i]);
807             _transfer(msg.sender, accounts[i], (_tTotal * percents[i]) / divisors[i]);
808         }
809     }
810 
811     struct ExtraValues {
812         uint256 tTransferAmount;
813         uint256 tFee;
814         uint256 tSwap;
815 
816         uint256 rTransferAmount;
817         uint256 rAmount;
818         uint256 rFee;
819 
820         uint256 currentRate;
821     }
822 
823     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
824         if (!_hasLiqBeenAdded) {
825             _checkLiquidityAdd(from, to);
826             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
827                 revert("Only owner can transfer at this time.");
828             }
829         }
830 
831         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
832 
833         _rOwned[from] -= values.rAmount;
834         _rOwned[to] += values.rTransferAmount;
835 
836         if (_isExcluded[from]) {
837             _tOwned[from] = _tOwned[from] - tAmount;
838         }
839         if (_isExcluded[to]) {
840             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
841         }
842 
843         if (values.rFee > 0 || values.tFee > 0) {
844             _rTotal -= values.rFee;
845         }
846 
847         emit Transfer(from, to, values.tTransferAmount);
848         return true;
849     }
850 
851     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
852         ExtraValues memory values;
853         values.currentRate = _getRate();
854 
855         values.rAmount = tAmount * values.currentRate;
856 
857         if (_hasLimits(from, to)) {
858             bool checked;
859             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
860                 checked = check;
861             } catch {
862                 revert();
863             }
864 
865             if(!checked) {
866                 revert();
867             }
868         }
869 
870         if(takeFee) {
871             uint256 currentReflect;
872             uint256 currentSwap;
873             uint256 divisor = masterTaxDivisor;
874 
875             if (lpPairs[to]) {
876                 currentReflect = _sellTaxes.reflect;
877                 currentSwap = _sellTaxes.totalSwap;
878             } else if (lpPairs[from]) {
879                 currentReflect = _buyTaxes.reflect;
880                 currentSwap = _buyTaxes.totalSwap;
881             } else {
882                 currentReflect = _transferTaxes.reflect;
883                 currentSwap = _transferTaxes.totalSwap;
884             }
885 
886             values.tFee = (tAmount * currentReflect) / divisor;
887             values.tSwap = (tAmount * currentSwap) / divisor;
888             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
889 
890             values.rFee = values.tFee * values.currentRate;
891         } else {
892             values.tFee = 0;
893             values.tSwap = 0;
894             values.tTransferAmount = tAmount;
895 
896             values.rFee = 0;
897         }
898 
899         if (values.tSwap > 0) {
900             _rOwned[address(this)] += values.tSwap * values.currentRate;
901             if(_isExcluded[address(this)]) {
902                 _tOwned[address(this)] += values.tSwap;
903             }
904             emit Transfer(from, address(this), values.tSwap);
905         }
906 
907         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * values.currentRate));
908         return values;
909     }
910 
911     function _getRate() internal view returns(uint256) {
912         uint256 rSupply = _rTotal;
913         uint256 tSupply = _tTotal;
914         if(_isExcluded[lpPair]) {
915             if (_rOwned[lpPair] > rSupply || _tOwned[lpPair] > tSupply) return _rTotal / _tTotal;
916             rSupply -= _rOwned[lpPair];
917             tSupply -= _tOwned[lpPair];
918         }
919         if(_excluded.length > 0) {
920             for (uint8 i = 0; i < _excluded.length; i++) {
921                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
922                 rSupply = rSupply - _rOwned[_excluded[i]];
923                 tSupply = tSupply - _tOwned[_excluded[i]];
924             }
925         }
926         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
927         return rSupply / tSupply;
928     }
929 }