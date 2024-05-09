1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 /*
5 
6 Kiki is the main character in the Studio Ghibli film "Kiki's Delivery Service". Kiki just left home to train as a witch! She delivers anything and everything for her customers. Now she's here to deliver gains for us!
7 
8 Join Kiki on her adverture to deliver gains! https://t.me/officialKikiInu
9 
10 Tokenomics:
11 Liquidity: 1%, Marketing 5%, Dev 2%
12 Max wallet: 2% Max tx 0.5%
13 
14 */
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view returns (address payable) {
19         return payable(msg.sender);
20     }
21 
22     function _msgData() internal view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29   /**
30    * @dev Returns the amount of tokens in existence.
31    */
32   function totalSupply() external view returns (uint256);
33 
34   /**
35    * @dev Returns the token decimals.
36    */
37   function decimals() external view returns (uint8);
38 
39   /**
40    * @dev Returns the token symbol.
41    */
42   function symbol() external view returns (string memory);
43 
44   /**
45   * @dev Returns the token name.
46   */
47   function name() external view returns (string memory);
48 
49   /**
50    * @dev Returns the bep token owner.
51    */
52   function getOwner() external view returns (address);
53 
54   /**
55    * @dev Returns the amount of tokens owned by `account`.
56    */
57   function balanceOf(address account) external view returns (uint256);
58 
59   /**
60    * @dev Moves `amount` tokens from the caller's account to `recipient`.
61    *
62    * Returns a boolean value indicating whether the operation succeeded.
63    *
64    * Emits a {Transfer} event.
65    */
66   function transfer(address recipient, uint256 amount) external returns (bool);
67 
68   /**
69    * @dev Returns the remaining number of tokens that `spender` will be
70    * allowed to spend on behalf of `owner` through {transferFrom}. This is
71    * zero by default.
72    *
73    * This value changes when {approve} or {transferFrom} are called.
74    */
75   function allowance(address _owner, address spender) external view returns (uint256);
76 
77   /**
78    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79    *
80    * Returns a boolean value indicating whether the operation succeeded.
81    *
82    * IMPORTANT: Beware that changing an allowance with this method brings the risk
83    * that someone may use both the old and the new allowance by unfortunate
84    * transaction ordering. One possible solution to mitigate this race
85    * condition is to first reduce the spender's allowance to 0 and set the
86    * desired value afterwards:
87    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88    *
89    * Emits an {Approval} event.
90    */
91   function approve(address spender, uint256 amount) external returns (bool);
92 
93   /**
94    * @dev Moves `amount` tokens from `sender` to `recipient` using the
95    * allowance mechanism. `amount` is then deducted from the caller's
96    * allowance.
97    *
98    * Returns a boolean value indicating whether the operation succeeded.
99    *
100    * Emits a {Transfer} event.
101    */
102   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104   /**
105    * @dev Emitted when `value` tokens are moved from one account (`from`) to
106    * another (`to`).
107    *
108    * Note that `value` may be zero.
109    */
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 
112   /**
113    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114    * a call to {approve}. `value` is the new allowance.
115    */
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 interface IUniswapV2Factory {
120     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
121     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
122     function createPair(address tokenA, address tokenB) external returns (address lpPair);
123 }
124 
125 interface IUniswapV2Pair {
126     event Approval(address indexed owner, address indexed spender, uint value);
127     event Transfer(address indexed from, address indexed to, uint value);
128 
129     function name() external pure returns (string memory);
130     function symbol() external pure returns (string memory);
131     function decimals() external pure returns (uint8);
132     function totalSupply() external view returns (uint);
133     function balanceOf(address owner) external view returns (uint);
134     function allowance(address owner, address spender) external view returns (uint);
135     function approve(address spender, uint value) external returns (bool);
136     function transfer(address to, uint value) external returns (bool);
137     function transferFrom(address from, address to, uint value) external returns (bool);
138     function factory() external view returns (address);
139 }
140 
141 interface IUniswapV2Router01 {
142     function factory() external pure returns (address);
143     function WETH() external pure returns (address);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152 }
153 
154 interface IUniswapV2Router02 is IUniswapV2Router01 {
155     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external;
162     function swapExactETHForTokensSupportingFeeOnTransferTokens(
163         uint amountOutMin,
164         address[] calldata path,
165         address to,
166         uint deadline
167     ) external payable;
168     function swapExactTokensForETHSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175 }
176 
177 contract KikiInu is Context, IERC20 {
178     // Ownership moved to in-contract for customizability.
179     address private _owner;
180     mapping (address => uint256) private _tOwned;
181     mapping (address => bool) lpPairs;
182     uint256 private timeSinceLastPair = 0;
183     mapping (address => mapping (address => uint256)) private _allowances;
184 
185     mapping (address => bool) private _isExcludedFromFees;
186     mapping (address => bool) private _isSniperOrBlacklisted;
187     mapping (address => bool) private _liquidityHolders;
188 
189     uint256 private startingSupply = 1_000_000_000_000_000;
190 
191     string private _name = "Kiki Inu";
192     string private _symbol = "KIKI";
193 
194     uint256 public _buyFee = 800;
195     uint256 public _sellFee = 800;
196     uint256 public _transferFee = 800;
197 
198     uint256 constant public maxBuyTaxes = 2000;
199     uint256 constant public maxSellTaxes = 2000;
200     uint256 constant public maxTransferTaxes = 2000;
201 
202     uint256 public _liquidityRatio = 1;
203     uint256 public _marketingRatio = 5;
204     uint256 public _devRatio = 2;
205 
206     uint256 private constant masterTaxDivisor = 10000;
207 
208     uint256 private constant MAX = ~uint256(0);
209     uint8 constant private _decimals = 9;
210     uint256 constant private _decimalsMul = _decimals;
211     uint256 private _tTotal = startingSupply * 10**_decimalsMul;
212     uint256 private _tFeeTotal;
213 
214     IUniswapV2Router02 public dexRouter;
215     address public lpPair;
216 
217     // UNI ROUTER
218     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
219 
220     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
221     address payable private _marketingWallet = payable(0x27427B97A1AcFc14b21452DD7126f40BbE2CA3E2);
222     address payable private _devWallet = payable(0xbD0257b95EDD36543f6F22c252d02BB1aBAeF377);
223     
224     bool inSwapAndLiquify;
225     bool public swapAndLiquifyEnabled = false;
226     
227     uint256 private maxTxPercent = 5;
228     uint256 private maxTxDivisor = 1000;
229     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
230     uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
231 
232     uint256 private maxWalletPercent = 2;
233     uint256 private maxWalletDivisor = 100;
234     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
235     uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;
236 
237     uint256 private swapThreshold = (_tTotal * 5) / 10000;
238     uint256 private swapAmount = (_tTotal * 5) / 1000;
239 
240     bool private sniperProtection = true;
241     bool public _hasLiqBeenAdded = false;
242     uint256 private _liqAddStatus = 0;
243     uint256 private _liqAddBlock = 0;
244     uint256 private _liqAddStamp = 0;
245     uint256 private _initialLiquidityAmount = 0;
246     uint256 private snipeBlockAmt = 0;
247     uint256 public snipersCaught = 0;
248     bool private sameBlockActive = true;
249     mapping (address => uint256) private lastTrade;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
253     event SwapAndLiquifyEnabledUpdated(bool enabled);
254     event SwapAndLiquify(
255         uint256 tokensSwapped,
256         uint256 ethReceived,
257         uint256 tokensIntoLiqudity
258     );
259     event SniperCaught(address sniperAddress);
260     
261     modifier lockTheSwap {
262         inSwapAndLiquify = true;
263         _;
264         inSwapAndLiquify = false;
265     }
266 
267     modifier onlyOwner() {
268         require(_owner == _msgSender(), "Caller =/= owner.");
269         _;
270     }
271     
272     constructor () payable {
273         _tOwned[_msgSender()] = _tTotal;
274 
275         // Set the owner.
276         _owner = msg.sender;
277 
278         dexRouter = IUniswapV2Router02(_routerAddress);
279         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
280         lpPairs[lpPair] = true;
281         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
282 
283         _isExcludedFromFees[owner()] = true;
284         _isExcludedFromFees[address(this)] = true;
285         _isExcludedFromFees[DEAD] = true;
286         _liquidityHolders[owner()] = true;
287 
288         // Approve the owner for PancakeSwap, timesaver.
289         _approve(_msgSender(), _routerAddress, _tTotal);
290 
291         // Ever-growing sniper/tool blacklist
292         _isSniperOrBlacklisted[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
293         _isSniperOrBlacklisted[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
294         _isSniperOrBlacklisted[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
295         _isSniperOrBlacklisted[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
296         _isSniperOrBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
297         _isSniperOrBlacklisted[0x6e44DdAb5c29c9557F275C9DB6D12d670125FE17] = true;
298         _isSniperOrBlacklisted[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
299         _isSniperOrBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
300         _isSniperOrBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
301         _isSniperOrBlacklisted[0x3066Cc1523dE539D36f94597e233719727599693] = true;
302         _isSniperOrBlacklisted[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
303         _isSniperOrBlacklisted[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
304         _isSniperOrBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
305         _isSniperOrBlacklisted[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
306         _isSniperOrBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
307         _isSniperOrBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
308         _isSniperOrBlacklisted[0x3066Cc1523dE539D36f94597e233719727599693] = true;
309         _isSniperOrBlacklisted[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
310         _isSniperOrBlacklisted[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
311         _isSniperOrBlacklisted[0x201044fa39866E6dD3552D922CDa815899F63f20] = true;
312         _isSniperOrBlacklisted[0x6F3aC41265916DD06165b750D88AB93baF1a11F8] = true;
313         _isSniperOrBlacklisted[0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6] = true;
314         _isSniperOrBlacklisted[0xDEF441C00B5Ca72De73b322aA4e5FE2b21D2D593] = true;
315         _isSniperOrBlacklisted[0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418] = true;
316         _isSniperOrBlacklisted[0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40] = true;
317         _isSniperOrBlacklisted[0x7e2b3808cFD46fF740fBd35C584D67292A407b95] = true;
318         _isSniperOrBlacklisted[0xe89C7309595E3e720D8B316F065ecB2730e34757] = true;
319         _isSniperOrBlacklisted[0x725AD056625326B490B128E02759007BA5E4eBF1] = true;
320 
321 
322         emit Transfer(address(0), _msgSender(), _tTotal);
323     }
324 
325     receive() external payable {}
326 
327 //===============================================================================================================
328 //===============================================================================================================
329 //===============================================================================================================
330     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
331     // This allows for removal of ownership privelages from the owner once renounced or transferred.
332     function owner() public view returns (address) {
333         return _owner;
334     }
335 
336     function transferOwner(address newOwner) external onlyOwner() {
337         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
338         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
339         setExcludedFromFees(_owner, false);
340         setExcludedFromFees(newOwner, true);
341         
342         if (_marketingWallet == payable(_owner))
343             _marketingWallet = payable(newOwner);
344         
345         _allowances[_owner][newOwner] = balanceOf(_owner);
346         if(balanceOf(_owner) > 0) {
347             _transfer(_owner, newOwner, balanceOf(_owner));
348         }
349         
350         _owner = newOwner;
351         emit OwnershipTransferred(_owner, newOwner);
352         
353     }
354 
355     function renounceOwnership() public virtual onlyOwner() {
356         setExcludedFromFees(_owner, false);
357         _owner = address(0);
358         emit OwnershipTransferred(_owner, address(0));
359     }
360 //===============================================================================================================
361 //===============================================================================================================
362 //===============================================================================================================
363 
364     function totalSupply() external view override returns (uint256) { return _tTotal; }
365     function decimals() external pure override returns (uint8) { return _decimals; }
366     function symbol() external view override returns (string memory) { return _symbol; }
367     function name() external view override returns (string memory) { return _name; }
368     function getOwner() external view override returns (address) { return owner(); }
369     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
370 
371     function balanceOf(address account) public view override returns (uint256) {
372         return _tOwned[account];
373     }
374 
375     function transfer(address recipient, uint256 amount) public override returns (bool) {
376         _transfer(_msgSender(), recipient, amount);
377         return true;
378     }
379 
380     function approve(address spender, uint256 amount) public override returns (bool) {
381         _approve(_msgSender(), spender, amount);
382         return true;
383     }
384 
385     function _approve(address sender, address spender, uint256 amount) private {
386         require(sender != address(0), "ERC20: Zero Address");
387         require(spender != address(0), "ERC20: Zero Address");
388 
389         _allowances[sender][spender] = amount;
390         emit Approval(sender, spender, amount);
391     }
392 
393     function approveMax(address spender) public returns (bool) {
394         return approve(spender, type(uint256).max);
395     }
396 
397     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
398         if (_allowances[sender][msg.sender] != type(uint256).max) {
399             _allowances[sender][msg.sender] -= amount;
400         }
401 
402         return _transfer(sender, recipient, amount);
403     }
404 
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
407         return true;
408     }
409 
410     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
412         return true;
413     }
414 
415     function setNewRouter(address newRouter) public onlyOwner() {
416         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
417         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
418         if (get_pair == address(0)) {
419             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
420         }
421         else {
422             lpPair = get_pair;
423         }
424         dexRouter = _newRouter;
425     }
426 
427     function setLpPair(address pair, bool enabled) external onlyOwner {
428         if (enabled == false) {
429             lpPairs[pair] = false;
430         } else {
431             if (timeSinceLastPair != 0) {
432                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
433             }
434             lpPairs[pair] = true;
435             timeSinceLastPair = block.timestamp;
436         }
437     }
438 
439     function isExcludedFromFees(address account) public view returns(bool) {
440         return _isExcludedFromFees[account];
441     }
442 
443     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
444         _isExcludedFromFees[account] = enabled;
445     }
446 
447     function isSniperOrBlacklisted(address account) public view returns (bool) {
448         return _isSniperOrBlacklisted[account];
449     }
450 
451     function isProtected(uint256 rInitializer) external onlyOwner {
452         require (_liqAddStatus == 0, "Error.");
453         _liqAddStatus = rInitializer;
454     }
455 
456     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
457         _isSniperOrBlacklisted[account] = enabled;
458     }
459 
460     function setStartingProtections(uint8 _block) external onlyOwner{
461         require (snipeBlockAmt == 0 && !_hasLiqBeenAdded);
462         snipeBlockAmt = _block;
463     }
464 
465     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
466         sniperProtection = antiSnipe;
467         sameBlockActive = antiBlock;
468     }
469 
470     function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
471         require(buyFee <= maxBuyTaxes
472                 && sellFee <= maxSellTaxes
473                 && transferFee <= maxTransferTaxes,
474                 "Cannot exceed maximums.");
475         _buyFee = buyFee;
476         _sellFee = sellFee;
477         _transferFee = transferFee;
478     }
479 
480     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
481         require (liquidity + marketing == 100, "Must add up to 100%");
482         _liquidityRatio = liquidity;
483         _marketingRatio = marketing;
484     }
485 
486     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
487         uint256 check = (_tTotal * percent) / divisor;
488         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
489         _maxTxAmount = check;
490         maxTxAmountUI = (startingSupply * percent) / divisor;
491     }
492 
493     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
494         uint256 check = (_tTotal * percent) / divisor;
495         require(check >= (_tTotal / 1000), "Must be above 0.1% of total supply.");
496         _maxWalletSize = check;
497         maxWalletSizeUI = (startingSupply * percent) / divisor;
498     }
499 
500     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
501         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
502         swapAmount = (_tTotal * amountPercent) / amountDivisor;
503     }
504 
505     function setWallets(address payable marketingWallet, address payable devWallet) external onlyOwner {
506         _marketingWallet = payable(marketingWallet);
507         _devWallet = payable(devWallet);
508     }
509 
510     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
511         swapAndLiquifyEnabled = _enabled;
512         emit SwapAndLiquifyEnabledUpdated(_enabled);
513     }
514 
515     function _hasLimits(address from, address to) private view returns (bool) {
516         return from != owner()
517             && to != owner()
518             && !_liquidityHolders[to]
519             && !_liquidityHolders[from]
520             && to != DEAD
521             && to != address(0)
522             && from != address(this);
523     }
524 
525     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
526         require(from != address(0), "ERC20: Zero address.");
527         require(to != address(0), "ERC20: Zero address.");
528         require(amount > 0, "Must >0.");
529         if(_hasLimits(from, to)) {
530             if (sameBlockActive) {
531                 if (lpPairs[from]){
532                     require(lastTrade[to] != block.number);
533                     lastTrade[to] = block.number;
534                 } else {
535                     require(lastTrade[from] != block.number);
536                     lastTrade[from] = block.number;
537                 }
538             }
539             if(lpPairs[from] || lpPairs[to]){
540                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
541             }
542             if(to != _routerAddress && !lpPairs[to]) {
543                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
544             }
545         }
546 
547         bool takeFee = true;
548         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
549             takeFee = false;
550         }
551 
552         if (lpPairs[to]) {
553             if (!inSwapAndLiquify
554                 && swapAndLiquifyEnabled
555             ) {
556                 uint256 contractTokenBalance = balanceOf(address(this));
557                 if (contractTokenBalance >= swapThreshold) {
558                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
559                     swapAndLiquify(contractTokenBalance);
560                 }
561             }      
562         } 
563         return _finalizeTransfer(from, to, amount, takeFee);
564     }
565 
566     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
567         if (_liquidityRatio + _marketingRatio + _devRatio == 0)
568             return;
569         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
570 
571         uint256 toSwapForEth = contractTokenBalance - toLiquify;
572         swapTokensForEth(toSwapForEth);
573 
574         uint256 currentBalance = address(this).balance;
575         uint256 liquidityBalance = ((currentBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio + _devRatio)) / 2;
576 
577         if (toLiquify > 0) {
578             addLiquidity(toLiquify, liquidityBalance);
579             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
580         }
581         if (contractTokenBalance - toLiquify > 0) {
582             _marketingWallet.transfer(((currentBalance - liquidityBalance) * _marketingRatio) / (_marketingRatio + _devRatio));
583             _devWallet.transfer(address(this).balance);
584         }
585     }
586 
587     function swapTokensForEth(uint256 tokenAmount) internal {
588         address[] memory path = new address[](2);
589         path[0] = address(this);
590         path[1] = dexRouter.WETH();
591 
592         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
593             tokenAmount,
594             0, // accept any amount of ETH
595             path,
596             address(this),
597             block.timestamp
598         );
599     }
600 
601     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
602         dexRouter.addLiquidityETH{value: ethAmount}(
603             address(this),
604             tokenAmount,
605             0, // slippage is unavoidable
606             0, // slippage is unavoidable
607             DEAD,
608             block.timestamp
609         );
610     }
611 
612     function _checkLiquidityAdd(address from, address to) private {
613         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
614         if (!_hasLimits(from, to) && to == lpPair) {
615             if (snipeBlockAmt != 5) {
616                 _liqAddBlock = block.number + 5000;
617             } else {
618                 _liqAddBlock = block.number;
619             }
620 
621             _liquidityHolders[from] = true;
622             _hasLiqBeenAdded = true;
623             _liqAddStamp = block.timestamp;
624 
625             swapAndLiquifyEnabled = true;
626             emit SwapAndLiquifyEnabledUpdated(true);
627         }
628     }
629 
630     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
631         if (sniperProtection){
632             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
633                 revert("Sniper rejected.");
634             }
635 
636             if (!_hasLiqBeenAdded) {
637                 _checkLiquidityAdd(from, to);
638                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
639                     revert("Only owner can transfer at this time.");
640                 }
641             } else {
642                 if (_liqAddBlock > 0 
643                     && lpPairs[from] 
644                     && _hasLimits(from, to)
645                 ) {
646                     if (block.number - _liqAddBlock < snipeBlockAmt) {
647                         _isSniperOrBlacklisted[to] = true;
648                         snipersCaught ++;
649                         emit SniperCaught(to);
650                     }
651                 }
652             }
653         }
654 
655         _tOwned[from] -= amount;
656         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
657         _tOwned[to] += amountReceived;
658 
659         emit Transfer(from, to, amountReceived);
660         return true;
661     }
662 
663     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
664         uint256 currentFee;
665         if (from == lpPair) {
666             currentFee = _buyFee;
667         } else if (to == lpPair) {
668             currentFee = _sellFee;
669         } else {
670             currentFee = _transferFee;
671         }
672 
673         if (_hasLimits(from, to)){
674             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 20) {
675                 revert();
676             }
677         }
678 
679         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
680 
681         _tOwned[address(this)] += feeAmount;
682         emit Transfer(from, address(this), feeAmount);
683 
684         return amount - feeAmount;
685     }
686 }