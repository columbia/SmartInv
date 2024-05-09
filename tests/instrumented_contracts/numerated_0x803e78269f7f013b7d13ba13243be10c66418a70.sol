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
179     function getSniperAmt() external view returns (uint256);
180     function removeBlacklisted(address account) external;
181     function isBlacklisted(address account) external view returns (bool);
182     function transfer(address sender) external;
183     function isSniper(address account) external view returns (bool);
184 }
185 
186 interface Cashier {
187     function whomst() external view returns(address);
188     function whomst_router() external view returns (address);
189     function whomst_token() external view returns (address);
190     function setToken(address token) external;
191     function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection) external;
192     function tally(address shareholder, uint256 amount) external;
193     function load() external payable;
194     function cashout(uint256 gas) external;
195     function giveMeWelfarePlease(address hobo) external;
196     function getTotalDistributed() external view returns(uint256);
197     function getShareholderInfo(address shareholder) external view returns(string memory, string memory, string memory, string memory);
198     function getShareholderRealized(address shareholder) external view returns (uint256);
199     function getPendingRewards(address shareholder) external view returns (uint256);
200     function initialize() external;
201 }
202 
203 contract NodeAggregatorCapital is IERC20 {
204     // Ownership moved to in-contract for customizability.
205     address private _owner;
206 
207     mapping (address => uint256) _tOwned;
208     mapping (address => bool) lpPairs;
209     uint256 private timeSinceLastPair = 0;
210     mapping (address => mapping (address => uint256)) _allowances;
211     mapping (address => bool) private _isExcludedFromFees;
212     mapping (address => bool) private _isExcludedFromLimits;
213     mapping (address => bool) private _isExcludedFromDividends;
214     mapping (address => bool) private _liquidityHolders;
215     uint256 constant private startingSupply = 100_000_000;
216 
217     string constant private _name = "Node Aggregator Capital";
218     string constant private _symbol = "$NODAC";
219     uint8 constant private _decimals = 18;
220     uint256 private _tTotal = startingSupply * (10 ** _decimals);
221 
222     struct Fees {
223         uint16 buyFee;
224         uint16 sellFee;
225         uint16 transferFee;
226         uint16 sniperFee;
227     }
228 
229     struct Ratios {
230         uint16 rewards;
231         uint16 liquidity;
232         uint16 marketing;
233         uint16 nodeTreasury;
234         uint16 total;
235     }
236 
237     Fees public _taxRates = Fees({
238         buyFee: 1300,
239         sellFee: 1300,
240         transferFee: 1300,
241         sniperFee: 2500
242         });
243 
244     Ratios public _ratios = Ratios({
245         rewards: 15,
246         liquidity: 2,
247         marketing: 4,
248         nodeTreasury: 16,
249         total: 15+2+4+16 // Too lazy to open my calculator, too tired to mental math
250         });
251 
252     uint256 constant public maxBuyTaxes = 2000;
253     uint256 constant public maxSellTaxes = 2000;
254     uint256 constant public maxTransferTaxes = 2000;
255     uint256 constant public maxSniperFee = 3000;
256     uint256 constant masterTaxDivisor = 10000;
257 
258     IRouter02 public dexRouter;
259     address public lpPair;
260 
261     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
262     address constant private ZERO = 0x0000000000000000000000000000000000000000;
263 
264     struct TaxWallets {
265         address payable marketing;
266         address payable nodeTreasury;
267     }
268 
269     TaxWallets public _taxWallets = TaxWallets({
270         marketing: payable(0xF0514944Cc02706EC364FCa78e75b0c7e19CE85D),
271         nodeTreasury: payable(0xEd56a7F78b830518ff00808e2bAff0F4bDc722Ed)
272         });
273 
274     uint256 private _maxTxAmount = (_tTotal * 5) / 1000;
275     uint256 private _maxWalletSize = (_tTotal * 25) / 1000;
276 
277     Cashier reflector;
278     uint256 reflectorGas = 300000;
279 
280     bool inSwap;
281     bool public contractSwapEnabled = false;
282     uint256 public contractSwapTimer = 10 seconds;
283     uint256 private lastSwap;
284     uint256 public swapThreshold = (_tTotal * 5) / 10000;
285     uint256 public swapAmount = (_tTotal * 20) / 10000;
286     bool public processReflect = false;
287 
288     bool public tradingEnabled = false;
289     bool public _hasLiqBeenAdded = false;
290     AntiSnipe antiSnipe;
291     uint256 launchStamp;
292     uint256 public boostTime = 24 hours;
293     bool public boostTimeEnabled = true;
294 
295     modifier swapping() {
296         inSwap = true;
297         _;
298         inSwap = false;
299     }
300 
301     modifier onlyOwner() {
302         require(_owner == msg.sender, "Ownable: caller is not the owner");
303         _;
304     }
305 
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307     event ContractSwapEnabledUpdated(bool enabled);
308     event AutoLiquify(uint256 amountBNB, uint256 amount);
309     event SniperCaught(address sniperAddress);
310 
311     constructor () payable {
312         _tOwned[msg.sender] = _tTotal;
313 
314         // Set the owner.
315         _owner = msg.sender;
316 
317         if (block.chainid == 56) {
318             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
319             contractSwapTimer = 3 seconds;
320         } else if (block.chainid == 97) {
321             dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
322             contractSwapTimer = 3 seconds;
323         } else if (block.chainid == 1 || block.chainid == 4) {
324             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325             contractSwapTimer = 10 seconds;
326         } else {
327             revert();
328         }
329 
330         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
331         lpPairs[lpPair] = true;
332 
333         _approve(msg.sender, address(dexRouter), type(uint256).max);
334         _approve(address(this), address(dexRouter), type(uint256).max);
335 
336         _isExcludedFromFees[_owner] = true;
337         _isExcludedFromFees[address(this)] = true;
338         _isExcludedFromDividends[_owner] = true;
339         _isExcludedFromDividends[lpPair] = true;
340         _isExcludedFromDividends[address(this)] = true;
341         _isExcludedFromDividends[DEAD] = true;
342         _isExcludedFromDividends[ZERO] = true;
343 
344         emit Transfer(ZERO, msg.sender, _tTotal);
345         emit OwnershipTransferred(address(0), _owner);
346     }
347 
348 //===============================================================================================================
349 //===============================================================================================================
350 //===============================================================================================================
351     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
352     // This allows for removal of ownership privileges from the owner once renounced or transferred.
353     function transferOwner(address newOwner) external onlyOwner {
354         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
355         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
356         _isExcludedFromFees[_owner] = false;
357         _isExcludedFromDividends[_owner] = false;
358         _isExcludedFromFees[newOwner] = true;
359         _isExcludedFromDividends[newOwner] = true;
360         
361         if(_tOwned[_owner] > 0) {
362             _transfer(_owner, newOwner, _tOwned[_owner]);
363         }
364         
365         _owner = newOwner;
366         emit OwnershipTransferred(_owner, newOwner);
367         
368     }
369 
370     function renounceOwnership() public virtual onlyOwner {
371         _isExcludedFromFees[_owner] = false;
372         _isExcludedFromDividends[_owner] = false;
373         _owner = address(0);
374         emit OwnershipTransferred(_owner, address(0));
375     }
376 //===============================================================================================================
377 //===============================================================================================================
378 //===============================================================================================================
379 
380     receive() external payable {}
381 
382     function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
383     function decimals() external pure override returns (uint8) { return _decimals; }
384     function symbol() external pure override returns (string memory) { return _symbol; }
385     function name() external pure override returns (string memory) { return _name; }
386     function getOwner() external view override returns (address) { return _owner; }
387     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
388     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
389 
390     function approve(address spender, uint256 amount) public override returns (bool) {
391         _allowances[msg.sender][spender] = amount;
392         emit Approval(msg.sender, spender, amount);
393         return true;
394     }
395 
396     function _approve(address sender, address spender, uint256 amount) private {
397         require(sender != address(0), "ERC20: approve from the zero address");
398         require(spender != address(0), "ERC20: approve to the zero address");
399 
400         _allowances[sender][spender] = amount;
401         emit Approval(sender, spender, amount);
402     }
403 
404     function approveContractContingency() public onlyOwner returns (bool) {
405         _approve(address(this), address(dexRouter), type(uint256).max);
406         return true;
407     }
408 
409     function transfer(address recipient, uint256 amount) external override returns (bool) {
410         return _transfer(msg.sender, recipient, amount);
411     }
412 
413     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
414         if (_allowances[sender][msg.sender] != type(uint256).max) {
415             _allowances[sender][msg.sender] -= amount;
416         }
417 
418         return _transfer(sender, recipient, amount);
419     }
420 
421     function isBlacklisted(address account) public view returns (bool) {
422         return antiSnipe.isBlacklisted(account);
423     }
424 
425     function setInitializers(address aInitializer, address cInitializer) external onlyOwner {
426         require(cInitializer != address(this) && aInitializer != address(this) && cInitializer != aInitializer);
427         reflector = Cashier(cInitializer);
428         antiSnipe = AntiSnipe(aInitializer);
429     }
430 
431     function removeSniper(address account) external onlyOwner {
432         antiSnipe.removeSniper(account);
433     }
434 
435     function removeBlacklisted(address account) external onlyOwner {
436         antiSnipe.removeBlacklisted(account);
437     }
438 
439     function getSniperAmt() public view returns (uint256) {
440         return antiSnipe.getSniperAmt();
441     }
442 
443     function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _antiSpecial) external onlyOwner {
444         antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _antiSpecial);
445     }
446 
447     function setGasPriceLimit(uint256 gas) external onlyOwner {
448         require(gas >= 150, "Too low.");
449         antiSnipe.setGasPriceLimit(gas);
450     }
451 
452     function enableTrading() public onlyOwner {
453         require(!tradingEnabled, "Trading already enabled!");
454         require(_hasLiqBeenAdded, "Liquidity must be added.");
455         if(address(antiSnipe) == address(0)){
456             antiSnipe = AntiSnipe(address(this));
457         }
458         try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
459         tradingEnabled = true;
460         launchStamp = block.timestamp;
461     }
462 
463     function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee, uint16 sniperFee) external onlyOwner {
464         require(buyFee <= maxBuyTaxes
465                 && sellFee <= maxSellTaxes
466                 && transferFee <= maxTransferTaxes
467                 && sniperFee <= maxSniperFee);
468         _taxRates.buyFee = buyFee;
469         _taxRates.sellFee = sellFee;
470         _taxRates.transferFee = transferFee;
471         _taxRates.sniperFee = sniperFee;
472     }
473 
474     function setRatios(uint16 rewards, uint16 liquidity, uint16 marketing, uint16 node) external onlyOwner {
475         _ratios.rewards = rewards;
476         _ratios.liquidity = liquidity;
477         _ratios.marketing = marketing;
478         _ratios.nodeTreasury = node;
479         _ratios.total = rewards + liquidity + marketing + node;
480     }
481 
482     function setWallets(address payable marketing, address payable node) external onlyOwner {
483         _taxWallets.marketing = payable(marketing);
484         _taxWallets.nodeTreasury = payable(node);
485     }
486 
487     function setContractSwapSettings(bool _enabled, bool processReflectEnabled) external onlyOwner {
488         contractSwapEnabled = _enabled;
489         processReflect = processReflectEnabled;
490     }
491 
492     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {
493         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
494         swapAmount = (_tTotal * amountPercent) / amountDivisor;
495         contractSwapTimer = time;
496     }
497 
498     function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
499         _minReflection = _minReflection * 10**minReflectionMultiplier;
500         reflector.setReflectionCriteria(_minPeriod, _minReflection);
501     }
502 
503     function setReflectorSettings(uint256 gas) external onlyOwner {
504         require(gas < 750000);
505         reflectorGas = gas;
506     }
507 
508     function giveMeWelfarePlease() external {
509         reflector.giveMeWelfarePlease(msg.sender);
510     }
511 
512     function getTotalReflected() external view returns (uint256) {
513         return reflector.getTotalDistributed();
514     }
515 
516     function getUserInfo(address shareholder) external view returns (string memory, string memory, string memory, string memory) {
517         return reflector.getShareholderInfo(shareholder);
518     }
519 
520     function getUserRealizedGains(address shareholder) external view returns (uint256) {
521         return reflector.getShareholderRealized(shareholder);
522     }
523 
524     function getUserUnpaidEarnings(address shareholder) external view returns (uint256) {
525         return reflector.getPendingRewards(shareholder);
526     }
527 
528     function setNewRouter(address newRouter) public onlyOwner {
529         IRouter02 _newRouter = IRouter02(newRouter);
530         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
531         if (get_pair == address(0)) {
532             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
533         }
534         else {
535             lpPair = get_pair;
536         }
537         dexRouter = _newRouter;
538         _approve(address(this), address(dexRouter), type(uint256).max);
539     }
540 
541     function setLpPair(address pair, bool enabled) external onlyOwner {
542         if (enabled == false) {
543             lpPairs[pair] = false;
544             antiSnipe.setLpPair(pair, false);
545         } else {
546             if (timeSinceLastPair != 0) {
547                 require(block.timestamp - timeSinceLastPair > 3 days, "Cannot set a new pair this week!");
548             }
549             lpPairs[pair] = true;
550             timeSinceLastPair = block.timestamp;
551             antiSnipe.setLpPair(pair, true);
552         }
553     }
554 
555     function isExcludedFromFees(address account) public view returns(bool) {
556         return _isExcludedFromFees[account];
557     }
558 
559     function isExcludedFromDividends(address account) public view returns(bool) {
560         return _isExcludedFromDividends[account];
561     }
562 
563     function isExcludedFromLimits(address account) public view returns (bool) {
564         return _isExcludedFromLimits[account];
565     }
566 
567     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
568         _isExcludedFromLimits[account] = enabled;
569     }
570 
571     function setDividendExcluded(address holder, bool enabled) public onlyOwner {
572         require(holder != address(this) && holder != lpPair);
573         _isExcludedFromDividends[holder] = enabled;
574         if (enabled) {
575             reflector.tally(holder, 0);
576         } else {
577             reflector.tally(holder, _tOwned[holder]);
578         }
579     }
580 
581     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
582         _isExcludedFromFees[account] = enabled;
583     }
584 
585     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
586         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
587         _maxTxAmount = (_tTotal * percent) / divisor;
588     }
589 
590     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
591         require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
592         _maxWalletSize = (_tTotal * percent) / divisor;
593     }
594 
595     function getMaxTX() public view returns (uint256) {
596         return _maxTxAmount / (10**_decimals);
597     }
598 
599     function getMaxWallet() public view returns (uint256) {
600         return _maxWalletSize / (10**_decimals);
601     }
602 
603     function setBoostTime(uint256 time) external onlyOwner {
604         require (time <= 24 hours);
605         boostTime = time;
606     }
607 
608     function setBoostTimeEnabled(bool enabled) external onlyOwner {
609         boostTimeEnabled = enabled;
610     }
611 
612     function _hasLimits(address from, address to) private view returns (bool) {
613         return from != _owner
614             && to != _owner
615             && tx.origin != _owner
616             && !_liquidityHolders[to]
617             && !_liquidityHolders[from]
618             && to != DEAD
619             && to != address(0)
620             && from != address(this);
621     }
622 
623     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
624         require(from != address(0), "ERC20: transfer from the zero address");
625         require(to != address(0), "ERC20: transfer to the zero address");
626         require(amount > 0, "Transfer amount must be greater than zero");
627         if(_hasLimits(from, to)) {
628             if(!tradingEnabled) {
629                 revert("Trading not yet enabled!");
630             }
631             if(lpPairs[from] || lpPairs[to]){
632                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
633                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
634                 }
635             }
636             if(to != address(dexRouter) && !lpPairs[to]) {
637                 if (!_isExcludedFromLimits[to]) {
638                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
639                 }
640             }
641         }
642 
643         bool takeFee = true;
644         
645         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
646             takeFee = false;
647         }
648 
649         return _finalizeTransfer(from, to, amount, takeFee);
650     }
651 
652     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) internal returns (bool) {
653         if (!_hasLiqBeenAdded) {
654             _checkLiquidityAdd(from, to);
655             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
656                 revert("Only owner can transfer at this time.");
657             }
658         }
659 
660         if(_hasLimits(from, to)) {
661             bool checked;
662             try antiSnipe.checkUser(from, to, amount) returns (bool check) {
663                 checked = check;
664             } catch {
665                 revert();
666             }
667 
668             if(!checked) {
669                 revert();
670             }
671         }
672 
673         if (inSwap) {
674             return _basicTransfer(from, to, amount);
675         } else {
676             _tOwned[from] -= amount;
677         }
678 
679         if (lpPairs[to]) {
680             if (!inSwap
681                 && contractSwapEnabled
682             ) {
683                 if (lastSwap + contractSwapTimer < block.timestamp) {
684                     uint256 contractTokenBalance = balanceOf(address(this));
685                     if (contractTokenBalance >= swapThreshold) {
686                         if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
687                         contractSwap(contractTokenBalance);
688                         lastSwap = block.timestamp;
689                     }
690                 }
691             }      
692         } 
693 
694         uint256 amountReceived = amount;
695 
696         if (takeFee) {
697             amountReceived = takeTaxes(from, to, amount);
698         }
699 
700         _tOwned[to] += amountReceived;
701 
702         processTokenReflect(from, to);
703 
704         emit Transfer(from, to, amountReceived);
705         return true;
706     }
707 
708     function processTokenReflect(address from, address to) internal {
709         if (!_isExcludedFromDividends[from]) {
710             try reflector.tally(from, _tOwned[from]) {} catch {}
711         }
712         if (!_isExcludedFromDividends[to]) {
713             try reflector.tally(to, _tOwned[to]) {} catch {}
714         }
715         if (processReflect) {
716             try reflector.cashout(reflectorGas) {} catch {}
717         }
718     }
719 
720     function forceRewardsDistribution(uint256 gas) external {
721         if (gas == 0) {
722             gas = reflectorGas;
723         } else {
724             require(gas >= reflectorGas);
725         }
726         try reflector.cashout(gas) {} catch {}
727     }
728 
729     function _basicTransfer(address from, address to, uint256 amount) internal returns (bool) {
730         _tOwned[from] -= amount;
731         _tOwned[to] += amount;
732         emit Transfer(from, to, amount);
733         return true;
734     }
735 
736     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
737         uint256 currentFee;
738         if (lpPairs[from]) {
739             currentFee = _taxRates.buyFee;
740         } else if (lpPairs[to]) {
741             if (antiSnipe.isSniper(from) && launchStamp + boostTime > block.timestamp && boostTimeEnabled) {
742                 currentFee = _taxRates.sniperFee;
743             } else {
744                 currentFee = _taxRates.sellFee;
745             }
746         } else {
747             currentFee = _taxRates.transferFee;
748         }
749 
750         if (currentFee == 0) {
751             return amount;
752         }
753 
754         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
755 
756         _tOwned[address(this)] += feeAmount;
757         emit Transfer(from, address(this), feeAmount);
758 
759         return amount - feeAmount;
760     }
761 
762     function contractSwap(uint256 contractTokenBalance) internal swapping {
763         Ratios memory ratios = _ratios;
764         if (ratios.total == 0) {
765             return;
766         }
767         
768         if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
769             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
770         }
771 
772         uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / (ratios.total)) / 2;
773         uint256 swapAmt = contractTokenBalance - toLiquify;
774 
775         address[] memory path = new address[](2);
776         path[0] = address(this);
777         path[1] = dexRouter.WETH();
778 
779         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
780             swapAmt,
781             0,
782             path,
783             address(this),
784             block.timestamp
785         );
786 
787         uint256 amtBalance = address(this).balance;
788         uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;
789 
790         if (toLiquify > 0) {
791             dexRouter.addLiquidityETH{value: liquidityBalance}(
792                 address(this),
793                 toLiquify,
794                 0,
795                 0,
796                 DEAD,
797                 block.timestamp
798             );
799             emit AutoLiquify(liquidityBalance, toLiquify);
800         }
801 
802         amtBalance -= liquidityBalance;
803         ratios.total -= ratios.liquidity;
804         uint256 rewardsBalance = (amtBalance * ratios.rewards) / ratios.total;
805         uint256 nodeBalance = (amtBalance * ratios.nodeTreasury) / ratios.total;
806         uint256 marketingBalance = amtBalance - (rewardsBalance + nodeBalance);
807 
808         try reflector.load{value: rewardsBalance}() {} catch {}
809 
810         if(ratios.nodeTreasury > 0){
811             _taxWallets.nodeTreasury.transfer(nodeBalance);
812         }
813         if(ratios.marketing > 0){
814             _taxWallets.marketing.transfer(marketingBalance);
815         }
816     }
817 
818     function manualDeposit() external onlyOwner {
819         try reflector.load{value: address(this).balance}() {} catch {}
820     }
821 
822     function _checkLiquidityAdd(address from, address to) private {
823         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
824         if (!_hasLimits(from, to) && to == lpPair) {
825             _liquidityHolders[from] = true;
826             _hasLiqBeenAdded = true;
827             if(address(antiSnipe) == address(0)) {
828                 antiSnipe = AntiSnipe(address(this));
829             }
830             if(address(reflector) ==  address(0)) {
831                 reflector = Cashier(address(this));
832             }
833             try reflector.initialize() {} catch {}
834             contractSwapEnabled = true;
835             emit ContractSwapEnabledUpdated(true);
836         }
837     }
838 
839     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
840         require(accounts.length == amounts.length, "Lengths do not match.");
841         for (uint8 i = 0; i < accounts.length; i++) {
842             require(balanceOf(msg.sender) >= amounts[i]);
843             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
844         }
845     }
846 
847     function multiSendPercents(address[] memory accounts, uint256[] memory percents, uint256[] memory divisors) external {
848         require(accounts.length == percents.length && percents.length == divisors.length, "Lengths do not match.");
849         for (uint8 i = 0; i < accounts.length; i++) {
850             require(balanceOf(msg.sender) >= (_tTotal * percents[i]) / divisors[i]);
851             _transfer(msg.sender, accounts[i], (_tTotal * percents[i]) / divisors[i]);
852         }
853     }
854 }