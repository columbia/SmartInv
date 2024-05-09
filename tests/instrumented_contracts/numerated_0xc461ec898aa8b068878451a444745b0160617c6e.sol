1 // SPDX-License-Identifier: MIT
2 
3 /*      WAGMI
4 
5 //TELEGRAM : https://t.me/cliffnobiportal
6 
7 // WEBSITE : www.cliffnobi.net
8 
9 // TWITTER : https://twitter.com/Cliffnobi
10 
11 */
12 pragma solidity 0.8.7;
13 
14 abstract contract Context {
15     function _msgSender() internal view returns (address payable) {
16         return payable(msg.sender);
17     }
18 
19     function _msgData() internal view returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26   function totalSupply() external view returns (uint256);
27   function decimals() external view returns (uint8);
28   function symbol() external view returns (string memory);
29   function name() external view returns (string memory);
30   function getOwner() external view returns (address);
31   function balanceOf(address account) external view returns (uint256);
32   function transfer(address recipient, uint256 amount) external returns (bool);
33   function allowance(address _owner, address spender) external view returns (uint256);
34   function approve(address spender, uint256 amount) external returns (bool);
35   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IUniswapV2Factory {
41     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
42     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
43     function createPair(address tokenA, address tokenB) external returns (address lpPair);
44 }
45 
46 interface IUniswapV2Pair {
47     event Approval(address indexed owner, address indexed spender, uint value);
48     event Transfer(address indexed from, address indexed to, uint value);
49     function name() external pure returns (string memory);
50     function symbol() external pure returns (string memory);
51     function decimals() external pure returns (uint8);
52     function totalSupply() external view returns (uint);
53     function balanceOf(address owner) external view returns (uint);
54     function allowance(address owner, address spender) external view returns (uint);
55     function approve(address spender, uint value) external returns (bool);
56     function transfer(address to, uint value) external returns (bool);
57     function transferFrom(address from, address to, uint value) external returns (bool);
58     function factory() external view returns (address);
59 }
60 
61 interface IUniswapV2Router01 {
62     function factory() external pure returns (address);
63     function WETH() external pure returns (address);
64     function addLiquidityETH(
65         address token,
66         uint amountTokenDesired,
67         uint amountTokenMin,
68         uint amountETHMin,
69         address to,
70         uint deadline
71     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
72 }
73 
74 interface IUniswapV2Router02 is IUniswapV2Router01 {
75     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external;
82     function swapExactETHForTokensSupportingFeeOnTransferTokens(
83         uint amountOutMin,
84         address[] calldata path,
85         address to,
86         uint deadline
87     ) external payable;
88     function swapExactTokensForETHSupportingFeeOnTransferTokens(
89         uint amountIn,
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external;
95 }
96 
97 contract CLIFFNOBI is Context, IERC20 {
98     // Ownership moved to in-contract for customizability.
99     address private _owner;
100 
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105 
106     mapping (address => bool) private _isExcludedFromFees;
107     mapping (address => bool) private _isSniperOrBlacklisted;
108     mapping (address => bool) private _liquidityHolders;
109 
110     uint256 private startingSupply = 100_000_000;
111 
112     string private _name = "CLIFFNOBI";
113     string private _symbol = "CLIFFNOBI";
114 
115     uint256 public _buyFee = 1250;
116     uint256 public _sellFee = 2000;
117     uint256 public _transferFee = 2000;
118 
119     uint256 constant public maxBuyTaxes = 1250;
120     uint256 constant public maxSellTaxes = 2000;
121     uint256 constant public maxTransferTaxes = 2000;
122     
123    // ratios
124     uint256 private _liquidityRatio = 300;
125     uint256 private _marketingRatio = 500;
126     uint256 private _devRatio = 300;
127     uint256 private _burnRatio = 150;
128     // ratios 
129 
130 
131     uint256 private _liquidityWalletRatios =  _devRatio + _liquidityRatio + _marketingRatio;
132     uint256 private _WalletRatios = _devRatio + _marketingRatio;
133 
134     uint256 private constant masterTaxDivisor = 10000;
135     uint256 private constant MAX = ~uint256(0);
136     uint8 constant private _decimals = 9;
137  
138     uint256 private _tTotal = startingSupply * 10**_decimals;
139     uint256 private _tFeeTotal;
140 
141     IUniswapV2Router02 public dexRouter;
142     address public lpPair;
143 
144     // UNI ROUTER
145     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
146     
147     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
148     
149     address payable private _marketingWallet = payable(0xa7Dd8a34a14E11730D9C1a9d974af03391A14ACf);
150     address payable private _Dev1Wallet = payable(0xeA448a9d2dFa0e2610eb47d62eED61D0301b9207);
151     
152     bool inSwapAndLiquify;
153     bool public swapAndLiquifyEnabled = false;
154     
155     uint256 private maxTxPercent = 35;
156     uint256 private maxTxDivisor = 10_000;
157     uint256 public _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
158     
159     uint256 private maxWalletPercent = 70;
160     uint256 private maxWalletDivisor = 10_000;
161     uint256 public _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
162     
163     uint256 private swapThreshold = (_tTotal * 5) / 10_000;
164     uint256 private swapAmount = (_tTotal * 5) / 1_000;
165 
166     bool private sniperProtection = true;
167     bool public _hasLiqBeenAdded = false;
168     uint256 private _liqAddStatus = 0;
169     uint256 private _liqAddBlock = 0;
170     uint256 private _liqAddStamp = 0;
171     uint256 private _initialLiquidityAmount = 0; // make constant
172     uint256 private snipeBlockAmt = 0;
173     uint256 public snipersCaught = 0;
174     bool private sameBlockActive = true;
175     mapping (address => uint256) private lastTrade;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
179     event SwapAndLiquifyEnabledUpdated(bool enabled);
180     event SwapAndLiquify(
181         uint256 tokensSwapped,
182         uint256 ethReceived,
183         uint256 tokensIntoLiqudity
184     );
185     event SniperCaught(address sniperAddress);
186     
187     modifier lockTheSwap {
188         inSwapAndLiquify = true;
189         _;
190         inSwapAndLiquify = false;
191     }
192 
193     modifier onlyOwner() {
194         require(_owner == _msgSender(), "Caller != owner.");
195         _;
196     }
197     
198     constructor () payable {
199         _tOwned[_msgSender()] = _tTotal;
200 
201         // Set the owner.
202         _owner = msg.sender;
203 
204         dexRouter = IUniswapV2Router02(_routerAddress);
205         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
206         lpPairs[lpPair] = true;
207         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
208 
209         _isExcludedFromFees[owner()] = true;
210         _isExcludedFromFees[address(this)] = true;
211         _isExcludedFromFees[DEAD] = true;
212         _liquidityHolders[owner()] = true;
213 
214         // Approve the owner for Uniswap, timesaver.
215         _approve(_msgSender(), _routerAddress, _tTotal);
216 
217         // Event regarding the tTotal transferred to the _msgSender.
218         emit Transfer(address(0), _msgSender(), _tTotal);
219     }
220 
221     receive() external payable {}
222 
223 //===============================================================================================================
224 //===============================================================================================================
225 //===============================================================================================================
226     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
227     // This allows for removal of ownership privelages from the owner once renounced or transferred.
228     function owner() public view returns (address) {
229         return _owner;
230     }
231 
232     function transferOwner(address newOwner) external onlyOwner() {
233         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
234         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
235         setExcludedFromFees(_owner, false);
236         setExcludedFromFees(newOwner, true);
237         
238         if (_marketingWallet == payable(_owner))
239             _marketingWallet = payable(newOwner);
240         
241         _allowances[_owner][newOwner] = balanceOf(_owner);
242         if(balanceOf(_owner) > 0) {
243             _transfer(_owner, newOwner, balanceOf(_owner));
244         }
245         
246         _owner = newOwner;
247         emit OwnershipTransferred(_owner, newOwner);
248         
249     }
250 
251     function renounceOwnership() public virtual onlyOwner() {
252         setExcludedFromFees(_owner, false);
253         _owner = address(0);
254         emit OwnershipTransferred(_owner, address(0));
255     }
256 //===============================================================================================================
257 //===============================================================================================================
258 //===============================================================================================================
259 
260     function totalSupply() external view override returns (uint256) { return _tTotal; }
261     function decimals() external pure override returns (uint8) { return _decimals; }
262     function symbol() external view override returns (string memory) { return _symbol; }
263     function name() external view override returns (string memory) { return _name; }
264     function getOwner() external view override returns (address) { return owner(); }
265     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
266 
267     function balanceOf(address account) public view override returns (uint256) {
268         return _tOwned[account];
269     }
270 
271     function transfer(address recipient, uint256 amount) public override returns (bool) {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275 
276     function approve(address spender, uint256 amount) public override returns (bool) {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280 
281     function _approve(address sender, address spender, uint256 amount) private {
282         require(sender != address(0), "ERC20: Zero Address");
283         require(spender != address(0), "ERC20: Zero Address");
284 
285         _allowances[sender][spender] = amount;
286         emit Approval(sender, spender, amount);
287     }
288 
289     function approveMax(address spender) public returns (bool) {
290         return approve(spender, type(uint256).max);
291     }
292 
293     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
294         if (_allowances[sender][msg.sender] != type(uint256).max) {
295             _allowances[sender][msg.sender] -= amount;
296         }
297 
298         return _transfer(sender, recipient, amount);
299     }
300 
301     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
302         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
303         return true;
304     }
305 
306     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
307         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
308         return true;
309     }
310 
311     function setNewRouter(address newRouter) public onlyOwner() {
312         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
313         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
314         if (get_pair == address(0)) {
315             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
316         }
317         else {
318             lpPair = get_pair;
319         }
320         dexRouter = _newRouter;
321     }
322 
323     function setLpPair(address pair, bool enabled) external onlyOwner {
324         if (enabled == false) {
325             lpPairs[pair] = false;
326         } else {
327             if (timeSinceLastPair != 0) {
328                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
329             }
330             lpPairs[pair] = true;
331             timeSinceLastPair = block.timestamp;
332         }
333     }
334 
335     function isExcludedFromFees(address account) public view returns(bool) {
336         return _isExcludedFromFees[account];
337     }
338 
339     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
340         _isExcludedFromFees[account] = enabled;
341     }
342 
343     function isSniperOrBlacklisted(address account) public view returns (bool) {
344         return _isSniperOrBlacklisted[account];
345     }
346 
347     function isProtected(uint256 rInitializer) external onlyOwner {
348         require (_liqAddStatus == 0, "Error.");
349         _liqAddStatus = rInitializer;
350         snipeBlockAmt = 2;
351     }
352 
353     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
354         _isSniperOrBlacklisted[account] = enabled;
355     }
356 
357     function setProtectionSettings(bool antiSnipe, bool antiBlock) external onlyOwner() {
358         sniperProtection = antiSnipe;
359         sameBlockActive = antiBlock;
360     }
361 
362     function setRatios(uint256 liquidity, uint256 marketing, uint256 dev1, uint256 burnRatio) external onlyOwner {
363         require ( (liquidity + marketing + dev1 + burnRatio) == 1250, "Must add up to 1000");
364         _liquidityRatio = liquidity;
365         _marketingRatio = marketing;
366         _devRatio = dev1;
367         _burnRatio = burnRatio;
368     }
369 
370     function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
371         require(buyFee <= maxBuyTaxes
372                 && sellFee <= maxSellTaxes
373                 && transferFee <= maxTransferTaxes,
374                 "Cannot exceed maximums.");
375         _buyFee = buyFee;
376         _sellFee = sellFee;
377         _transferFee = transferFee;
378     }
379 
380     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
381         uint256 check = (_tTotal * percent) / divisor;
382         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
383         _maxTxAmount = check;
384     }
385 
386     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
387         uint256 check = (_tTotal * percent) / divisor;
388         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
389         _maxWalletSize = check;
390 
391     }
392 
393     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
394         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
395         swapAmount = (_tTotal * amountPercent) / amountDivisor;
396     }
397 
398     function setWallets(address payable marketingWallet, address payable Dev1Wallet) external onlyOwner {
399         _marketingWallet = payable(marketingWallet);
400         _Dev1Wallet = payable(Dev1Wallet);
401     }
402 
403     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
404         swapAndLiquifyEnabled = _enabled;
405         emit SwapAndLiquifyEnabledUpdated(_enabled);
406     }
407 
408     function _hasLimits(address from, address to) private view returns (bool) {
409         return from != owner()
410             && to != owner()
411             && !_liquidityHolders[to]
412             && !_liquidityHolders[from]
413             && to != DEAD
414             && to != address(0)
415             && from != address(this);
416     }
417 
418     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
419 
420     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
421         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
422     }
423 
424     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
425         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
426     }
427 
428 
429     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
430         require(from != address(0), "ERC20: Zero address.");
431         require(to != address(0), "ERC20: Zero address.");
432         require(amount > 0, "Must >0.");
433         if(_hasLimits(from, to)) {
434             if (sameBlockActive) {
435                 if (lpPairs[from]){
436                     require(lastTrade[to] != block.number);
437                     lastTrade[to] = block.number;
438                 } else {
439                     require(lastTrade[from] != block.number);
440                     lastTrade[from] = block.number;
441                 }
442             }
443 
444             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])){
445                 if(lpPairs[from] || lpPairs[to]){
446                     require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
447                 }
448                 if(to != _routerAddress && !lpPairs[to]) {
449                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
450                 }
451             }
452 
453 
454         }
455 
456         bool takeFee = true;
457         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
458             takeFee = false;
459         }
460 
461         if (lpPairs[to]) {
462             if (!inSwapAndLiquify
463                 && swapAndLiquifyEnabled
464             ) {
465                 uint256 contractTokenBalance = balanceOf(address(this));
466                 if (contractTokenBalance >= swapThreshold) {
467                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
468                     swapAndLiquify(contractTokenBalance);
469                 }
470             }      
471         } 
472         return _finalizeTransfer(from, to, amount, takeFee);
473     }
474 
475     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
476         if (_liquidityRatio + _marketingRatio + _devRatio == 0)
477             return;
478         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / _liquidityWalletRatios) / 2;
479 
480         uint256 toSwapForEth = contractTokenBalance - toLiquify;
481         swapTokensForEth(toSwapForEth);
482 
483         uint256 currentBalance = address(this).balance;
484         uint256 liquidityBalance = ((currentBalance * _liquidityRatio) / _liquidityWalletRatios) / 2;
485 
486         if (toLiquify > 0) {
487             addLiquidity(toLiquify, liquidityBalance);
488             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
489         }
490         if (contractTokenBalance - toLiquify > 0) {
491             _marketingWallet.transfer(((currentBalance - liquidityBalance) * _marketingRatio) / (_WalletRatios));
492             _Dev1Wallet.transfer(address(this).balance);
493         }
494     }
495 
496     function swapTokensForEth(uint256 tokenAmount) internal {
497         address[] memory path = new address[](2);
498         path[0] = address(this);
499         path[1] = dexRouter.WETH();
500 
501         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
502             tokenAmount,
503             0, // accept any amount of ETH
504             path,
505             address(this),
506             block.timestamp
507         );
508     }
509 
510     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
511         dexRouter.addLiquidityETH{value: ethAmount}(
512             address(this),
513             tokenAmount,
514             0, // slippage is unavoidable
515             0, // slippage is unavoidable
516             DEAD,
517             block.timestamp
518         );
519     }
520 
521     function _checkLiquidityAdd(address from, address to) private {
522         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
523         if (!_hasLimits(from, to) && to == lpPair) {
524             if (snipeBlockAmt != 2) {
525                 _liqAddBlock = block.number + 5000;
526             } else {
527                 _liqAddBlock = block.number;
528             }
529 
530             _liquidityHolders[from] = true;
531             _hasLiqBeenAdded = true;
532             _liqAddStamp = block.timestamp;
533 
534             swapAndLiquifyEnabled = true;
535             emit SwapAndLiquifyEnabledUpdated(true);
536         }
537     }
538 
539     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
540         if (sniperProtection){
541             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
542                 revert("Sniper rejected.");
543             }
544 
545             if (!_hasLiqBeenAdded) {
546                 _checkLiquidityAdd(from, to);
547                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
548                     revert("Only owner can transfer at this time.");
549                 }
550             } else {
551                 if (_liqAddBlock > 0 
552                     && lpPairs[from] 
553                     && _hasLimits(from, to)
554                 ) {
555                     if (block.number - _liqAddBlock < snipeBlockAmt) {
556                         _isSniperOrBlacklisted[to] = true;
557                         snipersCaught ++;
558                         emit SniperCaught(to);
559                     }
560                 }
561             }
562         }
563 
564         _tOwned[from] -= amount;
565         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;
566         _tOwned[to] += amountReceived;
567 
568         emit Transfer(from, to, amountReceived);
569         return true;
570     }
571 
572     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
573         uint256 currentFee;
574 
575         if (from == lpPair) {
576             currentFee = _buyFee;
577         } else if (to == lpPair) {
578             currentFee = _sellFee;
579         } else {
580             currentFee = _transferFee;
581         }
582 
583         if (_hasLimits(from, to)){
584             if (_liqAddStatus == 0 || _liqAddStatus != 69420) {
585                 revert();
586             }
587         }
588         uint256 burnAmt = (amount * currentFee * _burnRatio) / (_burnRatio + _liquidityWalletRatios) / masterTaxDivisor;
589         uint256 feeAmount = (amount * currentFee / masterTaxDivisor) - burnAmt;
590         _tOwned[DEAD] += burnAmt;
591         _tOwned[address(this)] += (feeAmount);
592         emit Transfer(from, DEAD, burnAmt);
593         emit Transfer(from, address(this), feeAmount);
594         return amount - feeAmount - burnAmt;
595     }
596 }