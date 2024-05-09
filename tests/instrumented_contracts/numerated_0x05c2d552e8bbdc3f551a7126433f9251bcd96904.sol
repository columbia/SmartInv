1 // TELEGRAM : https://t.me/StealthEntryPortalETH
2 // WEBSITE : ShikuETH.com
3 
4 // SPDX-License-Identifier: Unlicensed
5 pragma solidity 0.8.11;
6 
7 abstract contract Context {
8     function _msgSender() internal view returns (address payable) {
9         return payable(msg.sender);
10     }
11 
12     function _msgData() internal view returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19   function totalSupply() external view returns (uint256);
20   function decimals() external view returns (uint8);
21   function symbol() external view returns (string memory);
22   function name() external view returns (string memory);
23   function getOwner() external view returns (address);
24   function balanceOf(address account) external view returns (uint256);
25   function transfer(address recipient, uint256 amount) external returns (bool);
26   function allowance(address _owner, address spender) external view returns (uint256);
27   function approve(address spender, uint256 amount) external returns (bool);
28   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 interface IUniswapV2Factory {
34     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
35     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
36     function createPair(address tokenA, address tokenB) external returns (address lpPair);
37 }
38 
39 interface IUniswapV2Pair {
40     event Approval(address indexed owner, address indexed spender, uint value);
41     event Transfer(address indexed from, address indexed to, uint value);
42     function name() external pure returns (string memory);
43     function symbol() external pure returns (string memory);
44     function decimals() external pure returns (uint8);
45     function totalSupply() external view returns (uint);
46     function balanceOf(address owner) external view returns (uint);
47     function allowance(address owner, address spender) external view returns (uint);
48     function approve(address spender, uint value) external returns (bool);
49     function transfer(address to, uint value) external returns (bool);
50     function transferFrom(address from, address to, uint value) external returns (bool);
51     function factory() external view returns (address);
52 }
53 
54 interface IUniswapV2Router01 {
55     function factory() external pure returns (address);
56     function WETH() external pure returns (address);
57     function addLiquidityETH(
58         address token,
59         uint amountTokenDesired,
60         uint amountTokenMin,
61         uint amountETHMin,
62         address to,
63         uint deadline
64     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
65 }
66 
67 interface IUniswapV2Router02 is IUniswapV2Router01 {
68     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
69         uint amountIn,
70         uint amountOutMin,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external;
75     function swapExactETHForTokensSupportingFeeOnTransferTokens(
76         uint amountOutMin,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external payable;
81     function swapExactTokensForETHSupportingFeeOnTransferTokens(
82         uint amountIn,
83         uint amountOutMin,
84         address[] calldata path,
85         address to,
86         uint deadline
87     ) external;
88 }
89 
90 contract SHIKU is Context, IERC20 {
91     // Ownership moved to in-contract for customizability.
92     address private _owner;
93 
94     mapping (address => uint256) private _tOwned;
95     mapping (address => bool) lpPairs;
96     uint256 private timeSinceLastPair = 0;
97     mapping (address => mapping (address => uint256)) private _allowances;
98 
99     mapping (address => bool) private _liquidityHolders;
100     mapping (address => bool) private _isExcludedFromFees;
101     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
102 
103     mapping (address => bool) private _isSniperOrBlacklisted;
104     
105     bool private sameBlockActive = false;
106     mapping (address => uint256) private lastTrade;    
107 
108     uint256 private startingSupply = 100_000_000_000;
109 
110     string private _name = "Shiku";
111     string private _symbol = "SHIKU";
112 //==========================
113     // FEES
114     struct taxes {
115     uint buyFee;
116     uint sellFee;
117     uint transferFee;
118     }
119 
120     taxes public Fees = taxes(
121     {buyFee: 777, sellFee: 600, transferFee: 600});
122 //==========================
123     // Maxima
124 
125     struct Maxima {
126     uint maxBuy;
127     uint maxSell;
128     uint maxTransfer;
129     }
130 
131     Maxima public maxFees = Maxima(
132     {maxBuy: 1000, maxSell: 1000, maxTransfer: 1000});
133 //==========================    
134     //Proportions of Taxes
135     struct feeProportions {
136     uint liquidity;
137     uint burn;
138     uint operationsFee;
139     }
140 
141     feeProportions public Ratios = feeProportions(
142     { liquidity: 0, burn: 0, operationsFee: 1000});
143 
144     uint256 private constant masterTaxDivisor = 10000;
145     uint256 private constant MAX = ~uint256(0);
146     uint8 constant private _decimals = 9;
147  
148     uint256 private _tTotal = startingSupply * 10**_decimals;
149     uint256 private _tFeeTotal;
150 
151     IUniswapV2Router02 public dexRouter;
152     address public lpPair;
153 
154     // UNI ROUTER
155     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
156     
157     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
158     
159     address payable public _operationsFeeWallet = payable(0xA6627850e661ffbb26fF06C785dD099e2dd07C25);
160     
161     bool inSwapAndLiquify;
162     bool public swapAndLiquifyEnabled = false;
163     
164     uint256 private maxTxPercent = 1;
165     uint256 private maxTxDivisor = 100;
166     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
167     
168     uint256 private maxWalletPercent = 2;
169     uint256 private maxWalletDivisor = 100;
170     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
171     
172     uint256 private swapThreshold = (_tTotal * 5) / 10_000;
173     uint256 private swapAmount = (_tTotal * 5) / 1_000;
174 
175     bool private sniperProtection = true;
176     bool public _hasLiqBeenAdded = false;
177     uint256 private _liqAddStatus = 0;
178     uint256 private _liqAddBlock = 0;
179     uint256 private _liqAddStamp = 0;
180     uint256 private _initialLiquidityAmount = 0; // make constant
181     uint256 private snipeBlockAmt = 0;
182     uint256 public snipersCaught = 0;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
186     event SwapAndLiquifyEnabledUpdated(bool enabled);
187     event SwapAndLiquify(
188         uint256 tokensSwapped,
189         uint256 ethReceived,
190         uint256 tokensIntoLiqudity
191     );
192     event SniperCaught(address sniperAddress);
193     
194     modifier lockTheSwap {
195         inSwapAndLiquify = true;
196         _;
197         inSwapAndLiquify = false;
198     }
199 
200     modifier onlyOwner() {
201         require(_owner == _msgSender(), "Caller != owner.");
202         _;
203     }
204     
205     constructor () payable {
206         _tOwned[_msgSender()] = _tTotal;
207 
208         // Set the owner.
209         _owner = msg.sender;
210 
211         dexRouter = IUniswapV2Router02(_routerAddress);
212         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
213         lpPairs[lpPair] = true;
214         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
215 
216         _isExcludedFromFees[owner()] = true;
217         _isExcludedFromFees[address(this)] = true;
218         _isExcludedFromFees[DEAD] = true;
219         _liquidityHolders[owner()] = true;
220 
221         // Approve the owner for Uniswap, timesaver.
222         _approve(_msgSender(), _routerAddress, _tTotal);
223 
224         // Event regarding the tTotal transferred to the _msgSender.
225         emit Transfer(address(0), _msgSender(), _tTotal);
226     }
227 
228     receive() external payable {}
229 
230 //===============================================================================================================
231 //===============================================================================================================
232 //===============================================================================================================
233     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
234     // This allows for removal of ownership privelages from the owner once renounced or transferred.
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     function transferOwner(address newOwner) external onlyOwner() {
240         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
241         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
242         setExcludedFromFees(_owner, false);
243         setExcludedFromFees(newOwner, true);
244         
245 
246         _allowances[_owner][newOwner] = balanceOf(_owner);
247         if(balanceOf(_owner) > 0) {
248             _transfer(_owner, newOwner, balanceOf(_owner));
249         }
250         
251         _owner = newOwner;
252         emit OwnershipTransferred(_owner, newOwner);
253         
254     }
255 
256     function renounceOwnership() public virtual onlyOwner() {
257         setExcludedFromFees(_owner, false);
258         _owner = address(0);
259         emit OwnershipTransferred(_owner, address(0));
260     }
261     
262 //===============================================================================================================
263 //===============================================================================================================
264 //===============================================================================================================
265 
266     function totalSupply() external view override returns (uint256) { return _tTotal; }
267     function decimals() external pure override returns (uint8) { return _decimals; }
268     function symbol() external view override returns (string memory) { return _symbol; }
269     function name() external view override returns (string memory) { return _name; }
270     function getOwner() external view override returns (address) { return owner(); }
271     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
272 
273     function balanceOf(address account) public view override returns (uint256) {
274         return _tOwned[account];
275     }
276 
277     function transfer(address recipient, uint256 amount) public override returns (bool) {
278         _transfer(_msgSender(), recipient, amount);
279         return true;
280     }
281 
282     function approve(address spender, uint256 amount) public override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     function _approve(address sender, address spender, uint256 amount) private {
288         require(sender != address(0), "ERC20: Zero Address");
289         require(spender != address(0), "ERC20: Zero Address");
290 
291         _allowances[sender][spender] = amount;
292         emit Approval(sender, spender, amount);
293     }
294 
295     function approveMax(address spender) public returns (bool) {
296         return approve(spender, type(uint256).max);
297     }
298 
299     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
300         if (_allowances[sender][msg.sender] != type(uint256).max) {
301             _allowances[sender][msg.sender] -= amount;
302         }
303 
304         return _transfer(sender, recipient, amount);
305     }
306 
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
313         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
314         return true;
315     }
316 
317     function setNewRouter(address newRouter) public onlyOwner() {
318         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
319         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
320         if (get_pair == address(0)) {
321             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
322         }
323         else {
324             lpPair = get_pair;
325         }
326         dexRouter = _newRouter;
327     }
328 
329     function setLpPair(address pair, bool enabled) external onlyOwner {
330         if (enabled == false) {
331             lpPairs[pair] = false;
332         } else {
333             if (timeSinceLastPair != 0) {
334                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
335             }
336             lpPairs[pair] = true;
337             timeSinceLastPair = block.timestamp;
338         }
339     }
340 
341     function isExcludedFromFees(address account) public view returns(bool) {
342         return _isExcludedFromFees[account];
343     }
344 
345     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
346         _isExcludedFromFees[account] = enabled;
347     }
348 
349 
350     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
351         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
352     }
353 
354     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
355         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
356     }
357 
358     function isSniperOrBlacklisted(address account) public view returns (bool) {
359         return _isSniperOrBlacklisted[account];
360     }
361 
362     function isProtected(uint256 rInitializer) external onlyOwner {
363         require (_liqAddStatus == 0, "Error.");
364         _liqAddStatus = rInitializer;
365         snipeBlockAmt = 1;
366     }
367 
368     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
369         _isSniperOrBlacklisted[account] = enabled;
370     }
371 
372     function setRatios(uint _liquidity, uint _operationsFee, uint _burn) external onlyOwner {
373         require ( (_liquidity+_operationsFee+_burn) == 1000, "!= 1k");
374         Ratios.liquidity = _liquidity;
375         Ratios.operationsFee = _operationsFee;
376         Ratios.burn = _burn;}
377 
378     function setTaxes(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
379         require(_buyFee <= maxFees.maxBuy
380                 && _sellFee <= maxFees.maxSell
381                 && _transferFee <= maxFees.maxTransfer,
382                 "Cannot exceed maximums.");
383          Fees.buyFee = _buyFee;
384          Fees.sellFee = _sellFee;
385          Fees.transferFee = _transferFee;
386     }
387 
388     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
389         uint256 check = (_tTotal * percent) / divisor;
390         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
391         _maxTxAmount = check;
392     }
393 
394     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
395         uint256 check = (_tTotal * percent) / divisor;
396         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
397         _maxWalletSize = check;
398 
399     }
400 
401     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
402         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
403         swapAmount = (_tTotal * amountPercent) / amountDivisor;
404     }
405 
406     function setWallets(address payable operationsFeeWallet) external onlyOwner {
407         _operationsFeeWallet = payable(operationsFeeWallet);
408     }
409 
410     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
411         swapAndLiquifyEnabled = _enabled;
412         emit SwapAndLiquifyEnabledUpdated(_enabled);
413     }
414 
415     function _hasLimits(address from, address to) private view returns (bool) {
416         return from != owner()
417             && to != owner()
418             && !_liquidityHolders[to]
419             && !_liquidityHolders[from]
420             && to != DEAD
421             && to != address(0)
422             && from != address(this);
423     }
424 
425     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
426         require(from != address(0), "ERC20: Zero address.");
427         require(to != address(0), "ERC20: Zero address.");
428         require(amount > 0, "Must >0.");
429         if(_hasLimits(from, to)) {
430             if (sameBlockActive) {
431                 if (lpPairs[from]){
432                     require(lastTrade[to] != block.number);
433                     lastTrade[to] = block.number;
434                     } 
435                 else {
436                     require(lastTrade[from] != block.number);
437                     lastTrade[from] = block.number;
438                     }
439             }
440             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])) {
441                 if(lpPairs[from] || lpPairs[to]){
442                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
443                 }
444                 if(to != _routerAddress && !lpPairs[to]) {
445                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
446                 }
447 
448             }
449             
450         }
451         bool takeFee = true;
452         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
453             takeFee = false;
454         }
455 
456         if (lpPairs[to]) {
457             if (!inSwapAndLiquify
458                 && swapAndLiquifyEnabled
459             ) {
460                 uint256 contractTokenBalance = balanceOf(address(this));
461                 if (contractTokenBalance >= swapThreshold) {
462                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
463                     swapAndLiquify(contractTokenBalance);
464                 }
465             }      
466         } 
467         return _finalizeTransfer(from, to, amount, takeFee);
468     }
469 
470     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
471         if (Ratios.liquidity + Ratios.operationsFee == 0)
472             return;
473         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.operationsFee) ) / 2;
474 
475         uint256 toSwapForEth = contractTokenBalance - toLiquify;
476         swapTokensForEth(toSwapForEth);
477 
478         uint256 currentBalance = address(this).balance;
479         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.operationsFee) ) / 2;
480 
481         if (toLiquify > 0) {
482             addLiquidity(toLiquify, liquidityBalance);
483             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
484         }
485         if (contractTokenBalance - toLiquify > 0) {
486             _operationsFeeWallet.transfer(address(this).balance);
487         }
488     }
489 
490     function swapTokensForEth(uint256 tokenAmount) internal {
491         address[] memory path = new address[](2);
492         path[0] = address(this);
493         path[1] = dexRouter.WETH();
494 
495         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
496             tokenAmount,
497             0, // accept any amount of ETH
498             path,
499             address(this),
500             block.timestamp
501         );
502     }
503 
504     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
505         dexRouter.addLiquidityETH{value: ethAmount}(
506             address(this),
507             tokenAmount,
508             0, // slippage is unavoidable
509             0, // slippage is unavoidable
510             owner(),
511             block.timestamp
512         );
513     }
514 
515     function _checkLiquidityAdd(address from, address to) private {
516         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
517         if (!_hasLimits(from, to) && to == lpPair) {
518             if (snipeBlockAmt != 1) {
519                 _liqAddBlock = block.number + 5000;
520             } else {
521                 _liqAddBlock = block.number;
522             }
523             _liquidityHolders[from] = true;
524             _hasLiqBeenAdded = true;
525             _liqAddStamp = block.timestamp;
526 
527             swapAndLiquifyEnabled = true;
528             emit SwapAndLiquifyEnabledUpdated(true);
529         }
530     }
531 
532     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
533         if (sniperProtection){
534             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
535                 revert("Sniper rejected.");
536             }
537 
538             if (!_hasLiqBeenAdded) {
539                 _checkLiquidityAdd(from, to);
540                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
541                     revert("Only owner can transfer at this time.");
542                 }
543             } else {
544                 if (_liqAddBlock > 0 
545                     && lpPairs[from] 
546                     && _hasLimits(from, to)
547                 ) {
548                     if (block.number - _liqAddBlock < snipeBlockAmt) {
549                         _isSniperOrBlacklisted[to] = true;
550                         snipersCaught ++;
551                         emit SniperCaught(to);
552                     }
553                 }
554             }
555         }
556 
557         _tOwned[from] -= amount;
558         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount; //A
559         _tOwned[to] += amountReceived;
560 
561         emit Transfer(from, to, amountReceived);
562         return true;
563     }
564 
565     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
566         uint256 currentFee;
567 
568         if (to == lpPair) {currentFee = Fees.sellFee;}
569 
570         else if (from == lpPair) {currentFee = Fees.buyFee;} 
571 
572         else {currentFee = Fees.transferFee;}
573 
574         if (_hasLimits(from, to)){
575             if (_liqAddStatus == 0 || _liqAddStatus != (_decimals)) {
576                 revert();
577             }
578         }
579         uint256 burnAmt = (amount * currentFee * Ratios.burn) / (Ratios.burn + Ratios.liquidity + Ratios.operationsFee ) / masterTaxDivisor;
580         uint256 feeAmount = (amount * currentFee / masterTaxDivisor) - burnAmt;
581         _tOwned[DEAD] += burnAmt;
582         _tOwned[address(this)] += (feeAmount);
583         emit Transfer(from, DEAD, burnAmt);
584         emit Transfer(from, address(this), feeAmount);
585         return amount - feeAmount - burnAmt;
586     }
587 }