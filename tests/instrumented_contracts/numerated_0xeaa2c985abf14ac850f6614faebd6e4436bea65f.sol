1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 /*
5 
6 
7   _________.__                          
8  /   _____/|  |__  __ __  _____   ____  
9  \_____  \ |  |  \|  |  \/     \ /  _ \ 
10  /        \|   Y  \  |  /  Y Y  (  <_> )
11 /_______  /|___|  /____/|__|_|  /\____/ 
12         \/      \/            \/        
13 
14 
15 t.me/ShumoOfficial
16 https://twitter.com/ShumoOfficial
17 https://www.shumo.io/
18 https://medium.com/@Shumoofficial
19 
20 
21 */
22 
23 interface IERC20 {
24   /**
25    * @dev Returns the amount of tokens in existence.
26    */
27   function totalSupply() external view returns (uint256);
28 
29   /**
30    * @dev Returns the token decimals.
31    */
32   function decimals() external view returns (uint8);
33 
34   /**
35    * @dev Returns the token symbol.
36    */
37   function symbol() external view returns (string memory);
38 
39   /**
40   * @dev Returns the token name.
41   */
42   function name() external view returns (string memory);
43 
44   /**
45    * @dev Returns the bep token owner.
46    */
47   function getOwner() external view returns (address);
48 
49   /**
50    * @dev Returns the amount of tokens owned by `account`.
51    */
52   function balanceOf(address account) external view returns (uint256);
53 
54   /**
55    * @dev Moves `amount` tokens from the caller's account to `recipient`.
56    *
57    * Returns a boolean value indicating whether the operation succeeded.
58    *
59    * Emits a {Transfer} event.
60    */
61   function transfer(address recipient, uint256 amount) external returns (bool);
62 
63   /**
64    * @dev Returns the remaining number of tokens that `spender` will be
65    * allowed to spend on behalf of `owner` through {transferFrom}. This is
66    * zero by default.
67    *
68    * This value changes when {approve} or {transferFrom} are called.
69    */
70   function allowance(address _owner, address spender) external view returns (uint256);
71 
72   /**
73    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74    *
75    * Returns a boolean value indicating whether the operation succeeded.
76    *
77    * IMPORTANT: Beware that changing an allowance with this method brings the risk
78    * that someone may use both the old and the new allowance by unfortunate
79    * transaction ordering. One possible solution to mitigate this race
80    * condition is to first reduce the spender's allowance to 0 and set the
81    * desired value afterwards:
82    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83    *
84    * Emits an {Approval} event.
85    */
86   function approve(address spender, uint256 amount) external returns (bool);
87 
88   /**
89    * @dev Moves `amount` tokens from `sender` to `recipient` using the
90    * allowance mechanism. `amount` is then deducted from the caller's
91    * allowance.
92    *
93    * Returns a boolean value indicating whether the operation succeeded.
94    *
95    * Emits a {Transfer} event.
96    */
97   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99   /**
100    * @dev Emitted when `value` tokens are moved from one account (`from`) to
101    * another (`to`).
102    *
103    * Note that `value` may be zero.
104    */
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 
107   /**
108    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109    * a call to {approve}. `value` is the new allowance.
110    */
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 interface IFactoryV2 {
115     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
116     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
117     function createPair(address tokenA, address tokenB) external returns (address lpPair);
118 }
119 
120 interface IV2Pair {
121     function factory() external view returns (address);
122     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
123 }
124 
125 interface IRouter01 {
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136     function addLiquidity(
137         address tokenA,
138         address tokenB,
139         uint amountADesired,
140         uint amountBDesired,
141         uint amountAMin,
142         uint amountBMin,
143         address to,
144         uint deadline
145     ) external returns (uint amountA, uint amountB, uint liquidity);
146     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
147     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
148 }
149 
150 interface IRouter02 is IRouter01 {
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external payable;
164     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171     function swapExactTokensForTokens(
172         uint amountIn,
173         uint amountOutMin,
174         address[] calldata path,
175         address to,
176         uint deadline
177     ) external returns (uint[] memory amounts);
178 }
179 
180 interface AntiSnipe {
181     function checkUser(address from, address to, uint256 amt) external returns (bool);
182     function setLaunch(address _initialLpPair, uint256 _liqAddBlock, uint8 dec) external;
183     function setLpPair(address pair, bool enabled) external;
184     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
185     function setGasPriceLimit(uint256 gas) external;
186     function removeSniper(address account) external;
187     function removeBlacklisted(address account) external;
188     function isBlacklisted(address account) external view returns (bool);
189     function getMarketCap(address token) external view returns (uint256);
190     function transfer(address sender) external;
191     function setBlacklistEnabled(address account, bool enabled) external;
192     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
193     function getInitializers() external view returns (string memory, string memory, uint256, uint8);
194     function setTradesBlockDelay(uint8 delay) external;
195 }
196 
197 contract Shumo is IERC20 {
198     // Ownership moved to in-contract for customizability.
199     address private _owner;
200 
201     mapping (address => uint256) private _rOwned;
202     mapping (address => uint256) private _tOwned;
203     mapping (address => bool) lpPairs;
204     uint256 private timeSinceLastPair = 0;
205     mapping (address => mapping (address => uint256)) private _allowances;
206 
207     mapping (address => bool) private _isExcludedFromFees;
208     mapping (address => bool) private _isExcludedFromLimits;
209     mapping (address => bool) private _isExcluded;
210     address[] private _excluded;
211 
212     mapping (address => bool) private presaleAddresses;
213     bool private allowedPresaleExclusion = true;
214     mapping (address => bool) private _liquidityHolders;
215    
216     uint256 private startingSupply;
217     string private _name;
218     string private _symbol;
219     uint8 private _decimals;
220     uint256 private _tTotal;
221     uint256 constant private MAX = ~uint256(0);
222     uint256 private _rTotal;
223 
224     struct Fees {
225         uint16 reflect;
226         uint16 liquidity;
227         uint16 marketing;
228         uint16 empire;
229         uint16 totalSwap;
230     }
231 
232     struct Ratios {
233         uint16 liquidity;
234         uint16 marketing;
235         uint16 empire;
236         uint16 total;
237     }
238 
239     Fees public _buyTaxes = Fees({
240         reflect: 200,
241         liquidity: 500,
242         marketing: 300,
243         empire: 400,
244         totalSwap: 1200
245         });
246 
247     Fees public _sellTaxes = Fees({
248         reflect: 200,
249         liquidity: 500,
250         marketing: 900,
251         empire: 400,
252         totalSwap: 1800
253         });
254 
255     Fees public _transferTaxes = Fees({
256         reflect: 200,
257         liquidity: 500,
258         marketing: 300,
259         empire: 400,
260         totalSwap: 1200
261         });
262 
263     Ratios public _ratios = Ratios({
264         liquidity: 10,
265         marketing: 12,
266         empire: 8,
267         total: 30
268         });
269 
270     uint256 constant public maxBuyTaxes = 2000;
271     uint256 constant public maxSellTaxes = 2000;
272     uint256 constant public maxTransferTaxes = 2000;
273     uint256 constant masterTaxDivisor = 10000;
274 
275     IRouter02 public dexRouter;
276     address public lpPair;
277     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
278 
279     struct TaxWallets {
280         address payable marketing;
281         address payable empire;
282     }
283 
284     TaxWallets public _taxWallets = TaxWallets({
285         marketing: payable(0x53f9A814ad6BB38101e96f0708b491D70aA00F7D),
286         empire: payable(0xC310237250c13443968C429053A2695B15e520D5)
287         });
288     
289     bool inSwap;
290     bool public contractSwapEnabled = false;
291     uint256 public contractSwapTimer = 0 seconds;
292     uint256 private lastSwap;
293     uint256 public swapThreshold;
294     uint256 public swapAmount;
295     
296     bool public maxETHTradesEnabled = true;
297     uint256 private maxETHBuy = 25*10**16;
298     uint256 private maxETHSell = 25*10**16;
299 
300     bool public tradingEnabled = false;
301     bool public _hasLiqBeenAdded = false;
302     AntiSnipe antiSnipe;
303 
304     bool contractInitialized = false;
305 
306     mapping (address => bool) privateSaleHolders;
307     mapping (address => uint256) privateSaleSold;
308     mapping (address => uint256) privateSaleSellTime;
309     uint256 public privateSaleMaxDailySell = 5*10**17;
310     uint256 public privateSaleDelay = 24 hours;
311     bool public privateSaleLimitsEnabled = true;
312 
313     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
314     event ContractSwapEnabledUpdated(bool enabled);
315     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
316     
317     modifier lockTheSwap {
318         inSwap = true;
319         _;
320         inSwap = false;
321     }
322 
323     modifier onlyOwner() {
324         require(_owner == msg.sender, "Caller =/= owner.");
325         _;
326     }
327     
328     constructor () payable {
329         // Set the owner.
330         _owner = msg.sender;
331 
332         if (block.chainid == 56) {
333             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
334         } else if (block.chainid == 97) {
335             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
336         } else if (block.chainid == 1 || block.chainid == 4) {
337             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
338         } else if (block.chainid == 43114) {
339             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
340         } else {
341             revert();
342         }
343 
344         _isExcludedFromFees[_owner] = true;
345         _isExcludedFromFees[address(this)] = true;
346         _isExcludedFromFees[DEAD] = true;
347         _liquidityHolders[_owner] = true;
348     }
349 
350     function intializeContract(address[] memory accounts, uint256[] memory amounts, address _antiSnipe) external onlyOwner {
351         require(!contractInitialized, "1");
352         require(accounts.length == amounts.length, "2");
353         antiSnipe = AntiSnipe(_antiSnipe);
354         try antiSnipe.transfer(address(this)) {} catch {}
355         try antiSnipe.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {
356             _name = initName;
357             _symbol = initSymbol;
358             startingSupply = initStartingSupply;
359             _decimals = initDecimals;
360             _tTotal = startingSupply * 10**_decimals;
361             _rTotal = (MAX - (MAX % _tTotal));
362         } catch {
363             revert("3");
364         }
365         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
366         lpPairs[lpPair] = true;
367         swapThreshold = (_tTotal * 3) / 10000;
368         swapAmount = (_tTotal * 5) / 10000;
369         contractInitialized = true;     
370         _rOwned[_owner] = _rTotal;
371         emit Transfer(address(0), _owner, _tTotal);
372 
373         _approve(_owner, address(dexRouter), type(uint256).max);
374         _approve(address(this), address(dexRouter), type(uint256).max);
375 
376         for(uint256 i = 0; i < accounts.length; i++){
377             uint256 amount = amounts[i] * 10**_decimals;
378             _transfer(_owner, accounts[i], amount);
379         }
380 
381         _transfer(_owner, address(this), balanceOf(_owner));
382 
383         dexRouter.addLiquidityETH{value: address(this).balance}(
384             address(this),
385             balanceOf(address(this)),
386             0, // slippage is unavoidable
387             0, // slippage is unavoidable
388             _owner,
389             block.timestamp
390         );
391 
392         enableTrading();
393     }
394 
395     receive() external payable {}
396 
397 //===============================================================================================================
398 //===============================================================================================================
399 //===============================================================================================================
400     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
401     // This allows for removal of ownership privileges from the owner once renounced or transferred.
402     function transferOwner(address newOwner) external onlyOwner {
403         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
404         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
405         setExcludedFromFees(_owner, false);
406         setExcludedFromFees(newOwner, true);
407         
408         if(balanceOf(_owner) > 0) {
409             _transfer(_owner, newOwner, balanceOf(_owner));
410         }
411         
412         _owner = newOwner;
413         emit OwnershipTransferred(_owner, newOwner);
414         
415     }
416 
417     function renounceOwnership() public virtual onlyOwner {
418         setExcludedFromFees(_owner, false);
419         _owner = address(0);
420         emit OwnershipTransferred(_owner, address(0));
421     }
422 //===============================================================================================================
423 //===============================================================================================================
424 //===============================================================================================================
425 
426     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
427     function decimals() external view override returns (uint8) { return _decimals; }
428     function symbol() external view override returns (string memory) { return _symbol; }
429     function name() external view override returns (string memory) { return _name; }
430     function getOwner() external view override returns (address) { return _owner; }
431     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
432 
433     function balanceOf(address account) public view override returns (uint256) {
434         if (_isExcluded[account]) return _tOwned[account];
435         return tokenFromReflection(_rOwned[account]);
436     }
437 
438     function transfer(address recipient, uint256 amount) public override returns (bool) {
439         _transfer(msg.sender, recipient, amount);
440         return true;
441     }
442 
443     function approve(address spender, uint256 amount) public override returns (bool) {
444         _approve(msg.sender, spender, amount);
445         return true;
446     }
447 
448     function _approve(address sender, address spender, uint256 amount) private {
449         require(sender != address(0), "ERC20: Zero Address");
450         require(spender != address(0), "ERC20: Zero Address");
451 
452         _allowances[sender][spender] = amount;
453         emit Approval(sender, spender, amount);
454     }
455 
456     function approveContractContingency() public onlyOwner returns (bool) {
457         _approve(address(this), address(dexRouter), type(uint256).max);
458         return true;
459     }
460 
461     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
462         if (_allowances[sender][msg.sender] != type(uint256).max) {
463             _allowances[sender][msg.sender] -= amount;
464         }
465 
466         return _transfer(sender, recipient, amount);
467     }
468 
469     function setNewRouter(address newRouter) public onlyOwner {
470         IRouter02 _newRouter = IRouter02(newRouter);
471         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
472         if (get_pair == address(0)) {
473             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
474         }
475         else {
476             lpPair = get_pair;
477         }
478         dexRouter = _newRouter;
479         _approve(address(this), address(dexRouter), type(uint256).max);
480     }
481 
482     function setLpPair(address pair, bool enabled) external onlyOwner {
483         if (enabled == false) {
484             lpPairs[pair] = false;
485             antiSnipe.setLpPair(pair, false);
486         } else {
487             if (timeSinceLastPair != 0) {
488                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
489             }
490             lpPairs[pair] = true;
491             timeSinceLastPair = block.timestamp;
492             antiSnipe.setLpPair(pair, true);
493         }
494     }
495 
496     function isExcludedFromReward(address account) public view returns (bool) {
497         return _isExcluded[account];
498     }
499 
500     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
501         if (enabled) {
502             require(!_isExcluded[account], "Account is already excluded.");
503             if(_rOwned[account] > 0) {
504                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
505             }
506             _isExcluded[account] = true;
507             if(account != lpPair){
508                 _excluded.push(account);
509             }
510         } else if (!enabled) {
511             require(_isExcluded[account], "Account is already included.");
512             if (account == lpPair) {
513                 _rOwned[account] = _tOwned[account] * _getRate();
514                 _tOwned[account] = 0;
515                 _isExcluded[account] = false;
516             } else if(_excluded.length == 1) {
517                 _rOwned[account] = _tOwned[account] * _getRate();
518                 _tOwned[account] = 0;
519                 _isExcluded[account] = false;
520                 _excluded.pop();
521             } else {
522                 for (uint256 i = 0; i < _excluded.length; i++) {
523                     if (_excluded[i] == account) {
524                         _excluded[i] = _excluded[_excluded.length - 1];
525                         _tOwned[account] = 0;
526                         _rOwned[account] = _tOwned[account] * _getRate();
527                         _isExcluded[account] = false;
528                         _excluded.pop();
529                         break;
530                     }
531                 }
532             }
533         }
534     }
535 
536     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
537         require(rAmount <= _rTotal, "Amount must be less than total reflections");
538         uint256 currentRate =  _getRate();
539         return rAmount / currentRate;
540     }
541 
542     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
543         antiSnipe.setBlacklistEnabled(account, enabled);
544     }
545 
546     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
547         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
548     }
549 
550     function removeBlacklisted(address account) external onlyOwner {
551         antiSnipe.removeBlacklisted(account);
552     }
553 
554     function isBlacklisted(address account) public view returns (bool) {
555         return antiSnipe.isBlacklisted(account);
556     }
557 
558     function removeSniper(address account) external onlyOwner {
559         antiSnipe.removeSniper(account);
560     }
561 
562     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {
563         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);
564     }
565 
566     function setGasPriceLimit(uint256 gas) external onlyOwner {
567         require(gas >= 200, "Too low.");
568         antiSnipe.setGasPriceLimit(gas);
569     }
570 
571     function setTradesBlockDelay(uint8 delay) external onlyOwner {
572         require(delay <= 10);
573         antiSnipe.setTradesBlockDelay(delay);
574     }
575     
576     function setTaxesBuy(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 empire) external onlyOwner {
577         uint16 check = reflect + liquidity + marketing + empire;
578         require(check <= maxBuyTaxes);
579         _buyTaxes.reflect = reflect;
580         _buyTaxes.liquidity = liquidity;
581         _buyTaxes.marketing = marketing;
582         _buyTaxes.empire = empire;
583         _buyTaxes.totalSwap = check - reflect;
584     }
585 
586     function setTaxesSell(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 empire) external onlyOwner {
587         uint16 check = reflect + liquidity + marketing + empire;
588         require(check <= maxBuyTaxes);
589         _sellTaxes.reflect = reflect;
590         _sellTaxes.liquidity = liquidity;
591         _sellTaxes.marketing = marketing;
592         _sellTaxes.empire = empire;
593         _sellTaxes.totalSwap = check - reflect;
594     }
595 
596     function setTaxesTransfer(uint16 reflect, uint16 liquidity, uint16 marketing, uint16 empire) external onlyOwner {
597         uint16 check = reflect + liquidity + marketing + empire;
598         require(check <= maxBuyTaxes);
599         _transferTaxes.reflect = reflect;
600         _transferTaxes.liquidity = liquidity;
601         _transferTaxes.marketing = marketing;
602         _transferTaxes.empire = empire;
603         _transferTaxes.totalSwap = check - reflect;
604     }
605 
606     function setRatios(uint16 liquidity, uint16 marketing, uint16 empire) external onlyOwner {
607         _ratios.liquidity = liquidity;
608         _ratios.marketing = marketing;
609         _ratios.empire = empire;
610         _ratios.total = liquidity + marketing + empire;
611     }
612 
613     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
614         _isExcludedFromLimits[account] = enabled;
615     }
616 
617     function isExcludedFromLimits(address account) public view returns (bool) {
618         return _isExcludedFromLimits[account];
619     }
620 
621     function isExcludedFromFees(address account) public view returns(bool) {
622         return _isExcludedFromFees[account];
623     }
624 
625     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
626         _isExcludedFromFees[account] = enabled;
627     }
628 
629     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
630         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
631         swapAmount = (_tTotal * amountPercent) / amountDivisor;
632         contractSwapTimer = time;
633     }
634 
635     function setWallets(address payable marketing, address payable empire) external onlyOwner {
636         _taxWallets.empire = payable(empire);
637         _taxWallets.marketing = payable(marketing);
638     }
639 
640     function setContractSwapEnabled(bool enabled) external onlyOwner {
641         contractSwapEnabled = enabled;
642         emit ContractSwapEnabledUpdated(enabled);
643     }
644 
645     function setPrivateSaleLimitsEnabled(bool enabled) external onlyOwner {
646         privateSaleLimitsEnabled = enabled;
647     }
648 
649     function setPrivateSalersEnabled(address[] memory accounts, bool enabled) external onlyOwner {
650         for (uint256 i = 0; i < accounts.length; i++) {
651             privateSaleHolders[accounts[i]] = enabled;
652         }
653     }
654 
655     function setPrivateSaleSettings(uint256 value, uint256 multiplier, uint256 time) external onlyOwner {
656         require(value * 10**multiplier >= 5 * 10**17);
657         require(time <= 48 hours);
658         privateSaleMaxDailySell = value * 10**multiplier;
659         privateSaleDelay = time;
660     }
661 
662     function setETHLimits(uint256 buyVal, uint256 buyMult, uint256 sellVal, uint256 sellMult) external onlyOwner {
663         maxETHBuy = buyVal * 10**buyMult;
664         maxETHSell = sellVal * 10**sellMult;
665         require(maxETHBuy >= 25 * 10**16 && maxETHSell >= 25 * 10**16);
666     }
667 
668     function setEthLimitsEnabled(bool maxEthTrades) external onlyOwner {
669         maxETHTradesEnabled = maxEthTrades;
670     }
671 
672     function _hasLimits(address from, address to) private view returns (bool) {
673         return from != _owner
674             && to != _owner
675             && tx.origin != _owner
676             && !_liquidityHolders[to]
677             && !_liquidityHolders[from]
678             && to != DEAD
679             && to != address(0)
680             && from != address(this);
681     }
682 
683     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
684         require(from != address(0), "ERC20: transfer from the zero address");
685         require(to != address(0), "ERC20: transfer to the zero address");
686         require(amount > 0, "Transfer amount must be greater than zero");
687         if(_hasLimits(from, to)) {
688             if(!tradingEnabled) {
689                 revert("Trading not yet enabled!");
690             }
691             address[] memory path = new address[](2);
692             path[0] = address(this);
693             path[1] = dexRouter.WETH();
694             if (maxETHTradesEnabled) {
695                 uint256 ethBalance = dexRouter.getAmountsOut(amount, path)[1];
696                 if(lpPairs[from]) {
697                     require(ethBalance <= maxETHBuy);
698                 } else if (lpPairs[to]) {
699                     require(ethBalance <= maxETHSell);
700                 }
701             }
702 
703             if(privateSaleLimitsEnabled) {
704                 if(privateSaleHolders[from]) {
705                     require(lpPairs[to] || lpPairs[from]);
706                 }
707                 if(lpPairs[to] && privateSaleHolders[from] && !inSwap) {
708                     uint256 ethBalance = dexRouter.getAmountsOut(amount, path)[1];
709                     if(privateSaleSellTime[from] + privateSaleDelay < block.timestamp) {
710                         require(ethBalance <= privateSaleMaxDailySell);
711                         privateSaleSellTime[from] = block.timestamp;
712                         privateSaleSold[from] = ethBalance;
713                     } else if (privateSaleSellTime[from] + privateSaleDelay > block.timestamp) {
714                         require(privateSaleSold[from] + ethBalance <= privateSaleMaxDailySell);
715                         privateSaleSold[from] += ethBalance;
716                     }
717                 }
718             }
719         }
720 
721         bool takeFee = true;
722         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
723             takeFee = false;
724         }
725 
726         if (lpPairs[to]) {
727             if (!inSwap
728                 && contractSwapEnabled
729             ) {
730                 if (lastSwap + contractSwapTimer < block.timestamp) {
731                     uint256 contractTokenBalance = balanceOf(address(this));
732                     if (contractTokenBalance >= swapThreshold) {
733                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
734                         contractSwap(contractTokenBalance);
735                         lastSwap = block.timestamp;
736                     }
737                 }
738             }      
739         } 
740         return _finalizeTransfer(from, to, amount, takeFee);
741     }
742 
743     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
744         Ratios memory ratios = _ratios;
745         if (ratios.total == 0) {
746             return;
747         }
748 
749         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
750             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
751         }
752 
753         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;
754         uint256 swapAmt = contractTokenBalance - toLiquify;
755         
756         address[] memory path = new address[](2);
757         path[0] = address(this);
758         path[1] = dexRouter.WETH();
759 
760         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
761             swapAmt,
762             0,
763             path,
764             address(this),
765             block.timestamp
766         );
767 
768         uint256 amtBalance = address(this).balance;
769         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
770 
771         if (toLiquify > 0) {
772             dexRouter.addLiquidityETH{value: liquidityBalance}(
773                 address(this),
774                 toLiquify,
775                 0,
776                 0,
777                 DEAD,
778                 block.timestamp
779             );
780             emit AutoLiquify(liquidityBalance, toLiquify);
781         }
782 
783         amtBalance -= liquidityBalance;
784         ratios.total -= ratios.liquidity;
785         uint256 empireBalance = (amtBalance * ratios.empire) / ratios.total;
786         uint256 marketingBalance = amtBalance - empireBalance;
787         bool success;
788         if (ratios.empire > 0) {
789             (success,) = _taxWallets.empire.call{value: empireBalance, gas: 30000}("");
790         }
791         if (ratios.marketing > 0) {
792             (success,) = _taxWallets.marketing.call{value: marketingBalance, gas: 30000}("");
793         }
794     }
795 
796     struct ExtraValues {
797         uint256 tTransferAmount;
798         uint256 tFee;
799         uint256 tSwap;
800 
801         uint256 rTransferAmount;
802         uint256 rAmount;
803         uint256 rFee;
804 
805         uint256 currentRate;
806     }
807 
808     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
809         if (!_hasLiqBeenAdded) {
810             _checkLiquidityAdd(from, to);
811             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
812                 revert("Only owner can transfer at this time.");
813             }
814         }
815 
816         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
817 
818         _rOwned[from] -= values.rAmount;
819         _rOwned[to] += values.rTransferAmount;
820 
821         if (_isExcluded[from]) {
822             _tOwned[from] = _tOwned[from] - tAmount;
823         }
824         if (_isExcluded[to]) {
825             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
826         }
827 
828         if (values.rFee > 0 || values.tFee > 0) {
829             _rTotal -= values.rFee;
830         }
831 
832         emit Transfer(from, to, values.tTransferAmount);
833         return true;
834     }
835 
836     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
837         ExtraValues memory values;
838         values.currentRate = _getRate();
839 
840         values.rAmount = tAmount * values.currentRate;
841 
842         if (_hasLimits(from, to)) {
843             bool checked;
844             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
845                 checked = check;
846             } catch {
847                 revert();
848             }
849 
850             if(!checked) {
851                 revert();
852             }
853         }
854 
855         if(takeFee) {
856             uint256 currentReflect;
857             uint256 currentSwap;
858             uint256 divisor = masterTaxDivisor;
859 
860             if (lpPairs[to]) {
861                 currentReflect = _sellTaxes.reflect;
862                 currentSwap = _sellTaxes.totalSwap;
863             } else if (lpPairs[from]) {
864                 currentReflect = _buyTaxes.reflect;
865                 currentSwap = _buyTaxes.totalSwap;
866             } else {
867                 currentReflect = _transferTaxes.reflect;
868                 currentSwap = _transferTaxes.totalSwap;
869             }
870 
871             values.tFee = (tAmount * currentReflect) / divisor;
872             values.tSwap = (tAmount * currentSwap) / divisor;
873             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
874 
875             values.rFee = values.tFee * values.currentRate;
876         } else {
877             values.tFee = 0;
878             values.tSwap = 0;
879             values.tTransferAmount = tAmount;
880 
881             values.rFee = 0;
882         }
883 
884         if (values.tSwap > 0) {
885             _rOwned[address(this)] += values.tSwap * values.currentRate;
886             if(_isExcluded[address(this)]) {
887                 _tOwned[address(this)] += values.tSwap;
888             }
889             emit Transfer(from, address(this), values.tSwap);
890         }
891 
892         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * values.currentRate));
893         return values;
894     }
895 
896     function _getRate() internal view returns(uint256) {
897         uint256 rSupply = _rTotal;
898         uint256 tSupply = _tTotal;
899         if(_isExcluded[lpPair]) {
900             if (_rOwned[lpPair] > rSupply || _tOwned[lpPair] > tSupply) return _rTotal / _tTotal;
901             rSupply -= _rOwned[lpPair];
902             tSupply -= _tOwned[lpPair];
903         }
904         if(_excluded.length > 0) {
905             for (uint8 i = 0; i < _excluded.length; i++) {
906                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
907                 rSupply = rSupply - _rOwned[_excluded[i]];
908                 tSupply = tSupply - _tOwned[_excluded[i]];
909             }
910         }
911         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
912         return rSupply / tSupply;
913     }
914 
915     function _checkLiquidityAdd(address from, address to) private {
916         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
917         if (!_hasLimits(from, to) && to == lpPair) {
918             _liquidityHolders[from] = true;
919             _hasLiqBeenAdded = true;
920             if(address(antiSnipe) == address(0)){
921                 antiSnipe = AntiSnipe(address(this));
922             }
923             contractSwapEnabled = true;
924             emit ContractSwapEnabledUpdated(true);
925         }
926     }
927 
928     function enableTrading() public onlyOwner {
929         require(!tradingEnabled, "Trading already enabled!");
930         require(_hasLiqBeenAdded, "Liquidity must be added.");
931         if(address(antiSnipe) == address(0)){
932             antiSnipe = AntiSnipe(address(this));
933         }
934         try antiSnipe.setLaunch(lpPair, block.number, _decimals) {} catch {}
935         tradingEnabled = true;
936     }
937 
938     function sweepContingency() external onlyOwner {
939         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
940         payable(_owner).transfer(address(this).balance);
941     }
942     
943     function recoverNonNativeTokens(address token) external onlyOwner {
944         require (token != address(this), "Cannot reclaim native.");
945         IERC20 TOKEN = IERC20(token);
946         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
947     }
948 }