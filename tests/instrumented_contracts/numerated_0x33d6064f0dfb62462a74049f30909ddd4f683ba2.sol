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
176     function setProtections(bool _as, bool _ab, bool _algo) external;
177     function removeSniper(address account) external;
178     function getSniperAmt() external view returns (uint256);
179     function removeBlacklisted(address account) external;
180     function isBlacklisted(address account) external view returns (bool);
181     function transfer(address sender) external;
182     function setBlacklistEnabled(address account, bool enabled) external;
183     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
184     function getInitializers() external view returns (string memory, string memory, uint256, uint8, address);
185 }
186 
187 contract Serenity is Context, IERC20 {
188     // Ownership moved to in-contract for customizability.
189     address private _owner;
190 
191     mapping (address => uint256) private _rOwned;
192     mapping (address => uint256) private _tOwned;
193     mapping (address => bool) lpPairs;
194     uint256 private timeSinceLastPair = 0;
195     mapping (address => mapping (address => uint256)) private _allowances;
196 
197     mapping (address => bool) private _isExcludedFromFees;
198     mapping (address => bool) private _isExcludedFromLimits;
199     mapping (address => bool) private _isExcluded;
200     address[] private _excluded;
201     mapping (address => bool) private _liquidityHolders;
202    
203     uint256 private startingSupply;
204     string private _name;
205     string private _symbol;
206     uint8 private _decimals;
207 
208     uint256 private _tTotal;
209     uint256 constant private MAX = ~uint256(0);
210     uint256 private _rTotal;
211 
212     struct Fees {
213         uint16 reflect;
214         uint16 buyback;
215         uint16 charity;
216         uint16 team;
217         uint16 totalSwap;
218     }
219 
220     struct Ratios {
221         uint16 buyback;
222         uint16 charity;
223         uint16 team;
224         uint16 total;
225     }
226 
227     Fees public _buyTaxes = Fees({
228         reflect: 300,
229         buyback: 400,
230         charity: 100,
231         team: 700,
232         totalSwap: 1200
233         });
234 
235     Fees public _sellTaxes = Fees({
236         reflect: 300,
237         buyback: 900,
238         charity: 100,
239         team: 700,
240         totalSwap: 1700
241         });
242 
243     Fees public _transferTaxes = Fees({
244         reflect: 300,
245         buyback: 400,
246         charity: 100,
247         team: 700,
248         totalSwap: 1200
249         });
250 
251     Ratios public _ratios = Ratios({
252         buyback: 13,
253         charity: 2,
254         team: 14,
255         total: 14 + 13 + 2
256         });
257 
258     uint256 constant public maxBuyTaxes = 2000;
259     uint256 constant public maxSellTaxes = 2000;
260     uint256 constant public maxTransferTaxes = 2000;
261     uint256 constant masterTaxDivisor = 10000;
262 
263     IRouter02 public dexRouter;
264     address public lpPair;
265     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
266 
267     struct TaxWallets {
268         address payable buyback;
269         address payable charity;
270         address payable team;
271     }
272 
273     TaxWallets public _taxWallets = TaxWallets({
274         buyback: payable(0x37a42A6eDd1a6E33C31f5DBa132297cd857ee92E),
275         charity: payable(0xD6A55b7B875a8ffa78479138DE54a6b71a3BBEF3),
276         team: payable(0x69665a0f1346d30a1B85311632b1d8E3C3A9A17b)
277         });
278     
279     bool inSwap;
280     bool public contractSwapEnabled = false;
281     uint256 public contractSwapTimer = 0;
282     uint256 private lastSwap;
283     uint256 public swapThreshold;
284     uint256 public swapAmount;
285     
286     uint256 private _maxTxAmount;
287 
288     bool public tradingEnabled = false;
289     bool public _hasLiqBeenAdded = false;
290     AntiSnipe antiSnipe;
291     bool contractInitialized = false;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294     event ContractSwapEnabledUpdated(bool enabled);
295     
296     modifier lockTheSwap {
297         inSwap = true;
298         _;
299         inSwap = false;
300     }
301 
302     modifier onlyOwner() {
303         require(_owner == _msgSender(), "Caller =/= owner.");
304         _;
305     }
306     
307     constructor () payable {
308         // Set the owner.
309         _owner = msg.sender;
310 
311         if (block.chainid == 56) {
312             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
313         } else if (block.chainid == 97) {
314             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
315         } else if (block.chainid == 1 || block.chainid == 4) {
316             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
317         } else {
318             revert();
319         }
320 
321         _isExcludedFromFees[_owner] = true;
322         _isExcludedFromFees[address(this)] = true;
323         _isExcludedFromFees[DEAD] = true;
324         _liquidityHolders[_owner] = true;
325     }
326 
327     function intializeContract(address _antiSnipe) external onlyOwner {
328         require(!contractInitialized, "1");
329         antiSnipe = AntiSnipe(_antiSnipe);
330         try antiSnipe.transfer(address(this)) {} catch {}
331         address newOwner;
332         try antiSnipe.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals, address initOwner) {
333             _name = initName;
334             _symbol = initSymbol;
335             startingSupply = initStartingSupply;
336             _decimals = initDecimals;
337             _tTotal = startingSupply * (10**_decimals);
338             _rTotal = (MAX - (MAX % _tTotal));
339             newOwner = initOwner;
340         } catch {
341             revert("3");
342         }
343         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
344         lpPairs[lpPair] = true;
345         swapThreshold = (_tTotal * 2) / 10000;
346         swapAmount = (_tTotal * 5) / 10000;
347         _maxTxAmount = (_tTotal * 5) / 1000;
348         contractInitialized = true;     
349         _rOwned[_owner] = _rTotal;
350         emit Transfer(address(0), _owner, _tTotal);
351 
352         _approve(msg.sender, address(dexRouter), type(uint256).max);
353         _approve(address(this), address(dexRouter), type(uint256).max);
354         _transfer(_owner, address(this), balanceOf(_owner));
355 
356         dexRouter.addLiquidityETH{value: address(this).balance}(
357             address(this),
358             balanceOf(address(this)),
359             0, // slippage is unavoidable
360             0, // slippage is unavoidable
361             newOwner,
362             block.timestamp
363         );
364 
365         enableTrading();
366         transferOwner(newOwner);
367     }
368 
369     receive() external payable {}
370 
371 //===============================================================================================================
372 //===============================================================================================================
373 //===============================================================================================================
374     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
375     // This allows for removal of ownership privileges from the owner once renounced or transferred.
376     function transferOwner(address newOwner) public onlyOwner {
377         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
378         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
379         setExcludedFromFees(_owner, false);
380         setExcludedFromFees(newOwner, true);
381         
382         if(balanceOf(_owner) > 0) {
383             _transfer(_owner, newOwner, balanceOf(_owner));
384         }
385         
386         _owner = newOwner;
387         emit OwnershipTransferred(_owner, newOwner);
388         
389     }
390 
391     function renounceOwnership() public virtual onlyOwner {
392         setExcludedFromFees(_owner, false);
393         _owner = address(0);
394         emit OwnershipTransferred(_owner, address(0));
395     }
396 //===============================================================================================================
397 //===============================================================================================================
398 //===============================================================================================================
399 
400     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
401     function decimals() external view override returns (uint8) { return _decimals; }
402     function symbol() external view override returns (string memory) { return _symbol; }
403     function name() external view override returns (string memory) { return _name; }
404     function getOwner() external view override returns (address) { return _owner; }
405     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
406 
407     function balanceOf(address account) public view override returns (uint256) {
408         if (_isExcluded[account]) return _tOwned[account];
409         return tokenFromReflection(_rOwned[account]);
410     }
411 
412     function transfer(address recipient, uint256 amount) public override returns (bool) {
413         _transfer(_msgSender(), recipient, amount);
414         return true;
415     }
416 
417     function approve(address spender, uint256 amount) public override returns (bool) {
418         _approve(_msgSender(), spender, amount);
419         return true;
420     }
421 
422     function _approve(address sender, address spender, uint256 amount) private {
423         require(sender != address(0), "ERC20: Zero Address");
424         require(spender != address(0), "ERC20: Zero Address");
425 
426         _allowances[sender][spender] = amount;
427         emit Approval(sender, spender, amount);
428     }
429 
430     function approveContractContingency() public onlyOwner returns (bool) {
431         _approve(address(this), address(dexRouter), type(uint256).max);
432         return true;
433     }
434 
435     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
436         if (_allowances[sender][msg.sender] != type(uint256).max) {
437             _allowances[sender][msg.sender] -= amount;
438         }
439 
440         return _transfer(sender, recipient, amount);
441     }
442 
443     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
444         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
445         return true;
446     }
447 
448     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
449         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
450         return true;
451     }
452 
453     function setNewRouter(address newRouter) public onlyOwner {
454         IRouter02 _newRouter = IRouter02(newRouter);
455         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
456         if (get_pair == address(0)) {
457             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
458         }
459         else {
460             lpPair = get_pair;
461         }
462         dexRouter = _newRouter;
463         _approve(address(this), address(dexRouter), type(uint256).max);
464     }
465 
466     function setLpPair(address pair, bool enabled) external onlyOwner {
467         if (enabled == false) {
468             lpPairs[pair] = false;
469             antiSnipe.setLpPair(pair, false);
470         } else {
471             if (timeSinceLastPair != 0) {
472                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");
473             }
474             lpPairs[pair] = true;
475             timeSinceLastPair = block.timestamp;
476             antiSnipe.setLpPair(pair, true);
477         }
478     }
479 
480     function isExcludedFromReward(address account) public view returns (bool) {
481         return _isExcluded[account];
482     }
483 
484     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
485         if (enabled) {
486             require(!_isExcluded[account], "Account is already excluded.");
487             if(_rOwned[account] > 0) {
488                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
489             }
490             _isExcluded[account] = true;
491             if(account != lpPair){
492                 _excluded.push(account);
493             }
494         } else if (!enabled) {
495             require(_isExcluded[account], "Account is already included.");
496             if (account == lpPair) {
497                 _rOwned[account] = _tOwned[account] * _getRate();
498                 _tOwned[account] = 0;
499                 _isExcluded[account] = false;
500             } else if(_excluded.length == 1) {
501                 _rOwned[account] = _tOwned[account] * _getRate();
502                 _tOwned[account] = 0;
503                 _isExcluded[account] = false;
504                 _excluded.pop();
505             } else {
506                 for (uint256 i = 0; i < _excluded.length; i++) {
507                     if (_excluded[i] == account) {
508                         _excluded[i] = _excluded[_excluded.length - 1];
509                         _tOwned[account] = 0;
510                         _rOwned[account] = _tOwned[account] * _getRate();
511                         _isExcluded[account] = false;
512                         _excluded.pop();
513                         break;
514                     }
515                 }
516             }
517         }
518     }
519 
520     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
521         require(rAmount <= _rTotal, "Amount must be less than total reflections");
522         uint256 currentRate =  _getRate();
523         return rAmount / currentRate;
524     }
525 
526     function setInitializer(address initializer) external onlyOwner {
527         require(!_hasLiqBeenAdded, "Liquidity is already in.");
528         require(initializer != address(this), "Can't be self.");
529         antiSnipe = AntiSnipe(initializer);
530     }
531 
532     function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
533         antiSnipe.setBlacklistEnabled(account, enabled);
534     }
535 
536     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {
537         antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);
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
552     function setProtectionSettings(bool _antiSnipe, bool _antiBlock, bool _algo) external onlyOwner {
553         antiSnipe.setProtections(_antiSnipe, _antiBlock, _algo);
554     }
555 
556     function lowerTaxes72hrs() external onlyOwner {
557         _sellTaxes.reflect = 300;
558         _sellTaxes.buyback = 400;
559         _sellTaxes.charity = 100;
560         _sellTaxes.team = 700;
561         _sellTaxes.totalSwap = 400 + 100 + 700;
562         _ratios.buyback = 4;
563         _ratios.charity = 1;
564         _ratios.team = 7;
565         _ratios.total = 12;
566     }
567     
568     function setTaxesBuy(uint16 reflect, uint16 buyback, uint16 charity, uint16 team) external onlyOwner {
569         uint16 check = reflect + buyback + charity + team;
570         require(check <= maxBuyTaxes);
571         _buyTaxes.reflect = reflect;
572         _buyTaxes.buyback = buyback;
573         _buyTaxes.charity = charity;
574         _buyTaxes.team = team;
575         _buyTaxes.totalSwap = check - reflect;
576     }
577 
578     function setTaxesSell(uint16 reflect, uint16 buyback, uint16 charity, uint16 team) external onlyOwner {
579         uint16 check = reflect + buyback + charity + team;
580         require(check <= maxSellTaxes);
581         _sellTaxes.reflect = reflect;
582         _sellTaxes.buyback = buyback;
583         _sellTaxes.charity = charity;
584         _sellTaxes.team = team;
585         _sellTaxes.totalSwap = check - reflect;
586     }
587 
588     function setTaxesTransfer(uint16 reflect, uint16 buyback, uint16 charity, uint16 team) external onlyOwner {
589         uint16 check = reflect + buyback + charity + team;
590         require(check <= maxTransferTaxes);
591         _transferTaxes.reflect = reflect;
592         _transferTaxes.buyback = buyback;
593         _transferTaxes.charity = charity;
594         _transferTaxes.team = team;
595         _transferTaxes.totalSwap = check - reflect;
596     }
597 
598     function setRatios(uint16 buyback, uint16 charity, uint16 team) external onlyOwner {
599         _ratios.buyback = buyback;
600         _ratios.charity = charity;
601         _ratios.team = team;
602         _ratios.total = buyback + charity + team;
603     }
604 
605     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
606         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
607         _maxTxAmount = (_tTotal * percent) / divisor;
608     }
609 
610     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
611         _isExcludedFromLimits[account] = enabled;
612     }
613 
614     function isExcludedFromLimits(address account) public view returns (bool) {
615         return _isExcludedFromLimits[account];
616     }
617 
618     function isExcludedFromFees(address account) public view returns(bool) {
619         return _isExcludedFromFees[account];
620     }
621 
622     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
623         _isExcludedFromFees[account] = enabled;
624     }
625 
626     function getMaxTX() public view returns (uint256) {
627         return _maxTxAmount / (10**_decimals);
628     }
629 
630     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
631         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
632         swapAmount = (_tTotal * amountPercent) / amountDivisor;
633         contractSwapTimer = time;
634     }
635 
636     function setWallets(address payable buyback, address payable charity, address payable team) external onlyOwner {
637         _taxWallets.buyback = payable(buyback);
638         _taxWallets.charity = payable(charity);
639         _taxWallets.team = payable(team);
640     }
641 
642     function setContractSwapEnabled(bool enabled) external onlyOwner {
643         contractSwapEnabled = enabled;
644         emit ContractSwapEnabledUpdated(enabled);
645     }
646 
647     function _hasLimits(address from, address to) private view returns (bool) {
648         return from != _owner
649             && to != _owner
650             && tx.origin != _owner
651             && !_liquidityHolders[to]
652             && !_liquidityHolders[from]
653             && to != DEAD
654             && to != address(0)
655             && from != address(this);
656     }
657 
658     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
659         require(from != address(0), "ERC20: transfer from the zero address");
660         require(to != address(0), "ERC20: transfer to the zero address");
661         require(amount > 0, "Transfer amount must be greater than zero");
662         if(_hasLimits(from, to)) {
663             if(!tradingEnabled) {
664                 revert("Trading not yet enabled!");
665             }
666             if(lpPairs[from] || lpPairs[to]){
667                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
668                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
669                 }
670             }
671         }
672 
673         bool takeFee = true;
674         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
675             takeFee = false;
676         }
677 
678         if (lpPairs[to]) {
679             if (!inSwap
680                 && contractSwapEnabled
681             ) {
682                 if (lastSwap + contractSwapTimer <= block.timestamp) {
683                     uint256 contractTokenBalance = balanceOf(address(this));
684                     if (contractTokenBalance >= swapThreshold) {
685                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
686                         contractSwap(contractTokenBalance);
687                         lastSwap = block.timestamp;
688                     }
689                 }
690             }      
691         } 
692         return _finalizeTransfer(from, to, amount, takeFee);
693     }
694 
695     function contractSwap(uint256 contractTokenBalance) private lockTheSwap {
696         Ratios memory ratios = _ratios;
697         if (ratios.total == 0) {
698             return;
699         }
700 
701         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
702             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
703         }
704         
705         address[] memory path = new address[](2);
706         path[0] = address(this);
707         path[1] = dexRouter.WETH();
708 
709         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
710             contractTokenBalance,
711             0,
712             path,
713             address(this),
714             block.timestamp
715         );
716 
717         uint256 amtBalance = address(this).balance;
718         uint256 buybackBalance = (amtBalance * ratios.buyback) / ratios.total;
719         uint256 charityBalance = (amtBalance * ratios.charity) / ratios.total;
720         uint256 teamBalance = (amtBalance * ratios.team) / ratios.total;
721         bool success;
722         if (ratios.buyback > 0) {
723             (success,) = _taxWallets.buyback.call{value: buybackBalance, gas: 30000}("");
724         }
725         if (ratios.charity > 0) {
726             (success,) = _taxWallets.charity.call{value: charityBalance, gas: 30000}("");
727         }
728         if (ratios.team > 0) {
729             (success,) = _taxWallets.team.call{value: teamBalance, gas: 30000}("");
730         }
731     }
732 
733     function _checkLiquidityAdd(address from, address to) private {
734         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
735         if (!_hasLimits(from, to) && to == lpPair) {
736             _liquidityHolders[from] = true;
737             _hasLiqBeenAdded = true;
738             if(address(antiSnipe) == address(0)){
739                 antiSnipe = AntiSnipe(address(this));
740             }
741             contractSwapEnabled = true;
742             emit ContractSwapEnabledUpdated(true);
743         }
744     }
745 
746     function enableTrading() public onlyOwner {
747         require(!tradingEnabled, "Trading already enabled!");
748         require(_hasLiqBeenAdded, "Liquidity must be added.");
749         if(address(antiSnipe) == address(0)){
750             antiSnipe = AntiSnipe(address(this));
751         }
752         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
753         tradingEnabled = true;
754     }
755 
756     function sweepContingency() external onlyOwner {
757         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
758         payable(_owner).transfer(address(this).balance);
759     }
760 
761     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
762         require(accounts.length == amounts.length, "Lengths do not match.");
763         for (uint8 i = 0; i < accounts.length; i++) {
764             require(balanceOf(msg.sender) >= amounts[i]);
765             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
766         }
767     }
768 
769     function multiSendPercents(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors) external {
770         require(accounts.length == percents.length && percents.length == divisors.length, "Lengths do not match.");
771         for (uint8 i = 0; i < accounts.length; i++) {
772             require(balanceOf(msg.sender) >= (_tTotal * percents[i]) / divisors[i]);
773             _transfer(msg.sender, accounts[i], (_tTotal * percents[i]) / divisors[i]);
774         }
775     }
776 
777     struct ExtraValues {
778         uint256 tTransferAmount;
779         uint256 tFee;
780         uint256 tSwap;
781 
782         uint256 rTransferAmount;
783         uint256 rAmount;
784         uint256 rFee;
785 
786         uint256 currentRate;
787     }
788 
789     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) private returns (bool) {
790         if (!_hasLiqBeenAdded) {
791             _checkLiquidityAdd(from, to);
792             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
793                 revert("Only owner can transfer at this time.");
794             }
795         }
796 
797         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
798 
799         _rOwned[from] -= values.rAmount;
800         _rOwned[to] += values.rTransferAmount;
801 
802         if (_isExcluded[from]) {
803             _tOwned[from] = _tOwned[from] - tAmount;
804         }
805         if (_isExcluded[to]) {
806             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
807         }
808 
809         if (values.rFee > 0 || values.tFee > 0) {
810             _rTotal -= values.rFee;
811         }
812 
813         emit Transfer(from, to, values.tTransferAmount);
814         return true;
815     }
816 
817     function _getValues(address from, address to, uint256 tAmount, bool takeFee) private returns (ExtraValues memory) {
818         ExtraValues memory values;
819         values.currentRate = _getRate();
820 
821         values.rAmount = tAmount * values.currentRate;
822 
823         if (_hasLimits(from, to)) {
824             bool checked;
825             try antiSnipe.checkUser(from, to, tAmount) returns (bool check) {
826                 checked = check;
827             } catch {
828                 revert();
829             }
830 
831             if(!checked) {
832                 revert();
833             }
834         }
835 
836         if(takeFee) {
837             uint256 currentReflect;
838             uint256 currentSwap;
839             uint256 divisor = masterTaxDivisor;
840 
841             if (lpPairs[to]) {
842                 currentReflect = _sellTaxes.reflect;
843                 currentSwap = _sellTaxes.totalSwap;
844             } else if (lpPairs[from]) {
845                 currentReflect = _buyTaxes.reflect;
846                 currentSwap = _buyTaxes.totalSwap;
847             } else {
848                 currentReflect = _transferTaxes.reflect;
849                 currentSwap = _transferTaxes.totalSwap;
850             }
851 
852             values.tFee = (tAmount * currentReflect) / divisor;
853             values.tSwap = (tAmount * currentSwap) / divisor;
854             values.tTransferAmount = tAmount - (values.tFee + values.tSwap);
855 
856             values.rFee = values.tFee * values.currentRate;
857         } else {
858             values.tFee = 0;
859             values.tSwap = 0;
860             values.tTransferAmount = tAmount;
861 
862             values.rFee = 0;
863         }
864 
865         if (values.tSwap > 0) {
866             _rOwned[address(this)] += values.tSwap * values.currentRate;
867             if(_isExcluded[address(this)]) {
868                 _tOwned[address(this)] += values.tSwap;
869             }
870             emit Transfer(from, address(this), values.tSwap);
871         }
872 
873         values.rTransferAmount = values.rAmount - (values.rFee + (values.tSwap * values.currentRate));
874         return values;
875     }
876 
877     function _getRate() internal view returns(uint256) {
878         uint256 rSupply = _rTotal;
879         uint256 tSupply = _tTotal;
880         if(_isExcluded[lpPair]) {
881             if (_rOwned[lpPair] > rSupply || _tOwned[lpPair] > tSupply) return _rTotal / _tTotal;
882             rSupply -= _rOwned[lpPair];
883             tSupply -= _tOwned[lpPair];
884         }
885         if(_excluded.length > 0) {
886             for (uint8 i = 0; i < _excluded.length; i++) {
887                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return _rTotal / _tTotal;
888                 rSupply = rSupply - _rOwned[_excluded[i]];
889                 tSupply = tSupply - _tOwned[_excluded[i]];
890             }
891         }
892         if (rSupply < _rTotal / _tTotal) return _rTotal / _tTotal;
893         return rSupply / tSupply;
894     }
895 }