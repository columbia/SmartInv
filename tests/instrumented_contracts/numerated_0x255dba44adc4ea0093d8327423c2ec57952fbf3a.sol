1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.14;
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
16   function totalSupply() external view returns (uint256);
17   function decimals() external view returns (uint8);
18   function symbol() external view returns (string memory);
19   function name() external view returns (string memory);
20   function getOwner() external view returns (address);
21   function balanceOf(address account) external view returns (uint256);
22   function transfer(address recipient, uint256 amount) external returns (bool);
23   function allowance(address _owner, address spender) external view returns (uint256);
24   function approve(address spender, uint256 amount) external returns (bool);
25   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IUniswapV2Factory {
31     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
32     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
33     function createPair(address tokenA, address tokenB) external returns (address lpPair);
34 }
35 
36 interface IUniswapV2Pair {
37     event Approval(address indexed owner, address indexed spender, uint value);
38     event Transfer(address indexed from, address indexed to, uint value);
39     function name() external pure returns (string memory);
40     function symbol() external pure returns (string memory);
41     function decimals() external pure returns (uint8);
42     function totalSupply() external view returns (uint);
43     function balanceOf(address owner) external view returns (uint);
44     function allowance(address owner, address spender) external view returns (uint);
45     function approve(address spender, uint value) external returns (bool);
46     function transfer(address to, uint value) external returns (bool);
47     function transferFrom(address from, address to, uint value) external returns (bool);
48     function factory() external view returns (address);
49 }
50 
51 interface IUniswapV2Router01 {
52     function factory() external pure returns (address);
53     function WETH() external pure returns (address);
54     function addLiquidityETH(
55         address token,
56         uint amountTokenDesired,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline
61     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
62 }
63 
64 interface IUniswapV2Router02 is IUniswapV2Router01 {
65     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
66         uint amountIn,
67         uint amountOutMin,
68         address[] calldata path,
69         address to,
70         uint deadline
71     ) external;
72     function swapExactETHForTokensSupportingFeeOnTransferTokens(
73         uint amountOutMin,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external payable;
78     function swapExactTokensForETHSupportingFeeOnTransferTokens(
79         uint amountIn,
80         uint amountOutMin,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external;
85 }
86 
87 contract ERC20Contract is Context, IERC20 {
88     // Ownership moved to in-contract for customizability.
89     address public _owner;
90 
91     mapping (address => uint256) private _tOwned;
92     mapping (address => bool) lpPairs;
93     uint256 private timeSinceLastPair = 0;
94     mapping (address => mapping (address => uint256)) private _allowances;
95 
96     mapping (address => bool) private _liquidityHolders;
97     mapping (address => bool) private _isExcludedFromFees;
98     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
99     mapping (address => bool) private _isblacklisted;
100     mapping (address => uint256) private _transferDelay;
101     mapping (address => bool) private _holderDelay;
102 
103 
104     bool private sameBlockActive = false;
105     mapping (address => uint256) private lastTrade;   
106 
107     bool private isInitialized = false;
108     
109     mapping (address => uint256) firstBuy;
110     
111     uint256 private startingSupply;
112 
113     string private _name;
114     string private _symbol;
115 //==========================
116     // FEES
117     struct taxes {
118     uint buyFee;
119     uint sellFee;
120     uint transferFee;
121     }
122 
123     taxes public Fees = taxes(
124     {buyFee: 40, sellFee: 40, transferFee: 0});
125 //==========================
126     // Max Limits
127 
128     struct MaxLimits {
129     uint maxBuy;
130     uint maxSell;
131     uint maxTransfer;
132     }
133 
134     MaxLimits public maxFees = MaxLimits(
135     {maxBuy: 500, maxSell: 500, maxTransfer: 500});
136 //==========================    
137     //Proportions of Taxes
138     struct feeProportions {
139     uint liquidity;
140     uint developer;
141     }
142 
143     feeProportions public Ratios = feeProportions(
144     { liquidity: 5, developer: 95});
145 
146     uint256 private constant masterTaxDivisor = 10000;
147     uint256 private constant MAX = ~uint256(0);
148     uint8 private _decimals;
149  
150     uint256 private _tTotal = startingSupply * 10**_decimals;
151     uint256 private _tFeeTotal;
152 
153     IUniswapV2Router02 public dexRouter;
154     address public lpPair;
155 
156 
157     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
158     
159     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
160     
161     address public _devWallet;
162     
163     bool inSwapAndLiquify;
164     bool public swapAndLiquifyEnabled = false;
165     
166     uint256 private maxTxPercent;
167     uint256 private maxTxDivisor;
168     uint256 private _maxTxAmount;
169     uint256 private _liqAddedBlock;
170     
171     uint256 private maxWalletPercent;
172     uint256 private maxWalletDivisor;
173     uint256 private _maxWalletSize;
174 
175     uint256 private swapThreshold;
176     uint256 private swapAmount;
177 
178     bool public _hasLiqBeenAdded = false;
179     
180     uint256 private _liqAddStatus = 0;
181     uint256 private _liqAddBlock = 0;
182     uint256 private _liqAddStamp = 0;
183     uint256 private _initialLiquidityAmount = 0; // make constant
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
187     event SwapAndLiquifyEnabledUpdated(bool enabled);
188     event SwapAndLiquify(
189         uint256 tokensSwapped,
190         uint256 ethReceived,
191         uint256 tokensIntoLiqudity
192     );
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
205     constructor () {
206         _owner = msg.sender;
207     }
208 
209     receive() external payable {}
210 
211 //===============================================================================================================
212 //===============================================================================================================
213 //===============================================================================================================
214     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
215     // This allows for removal of ownership privelages from the owner once renounced or transferred.
216     function owner() public view returns (address) {
217         return _owner;
218     }
219 
220     function transferOwner(address newOwner) external onlyOwner() {
221         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
222         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
223         setExcludedFromFees(_owner, false);
224         setExcludedFromFees(newOwner, true);
225         
226         if (_devWallet == payable(_owner))
227             _devWallet = payable(newOwner);
228         
229         _allowances[_owner][newOwner] = balanceOf(_owner);
230         if(balanceOf(_owner) > 0) {
231             _transfer(_owner, newOwner, balanceOf(_owner));
232         }
233         
234         _owner = newOwner;
235         emit OwnershipTransferred(_owner, newOwner);
236         
237     }
238 
239     function renounceOwnership() public virtual onlyOwner() {
240         setExcludedFromFees(_owner, false);
241         _owner = address(0);
242         emit OwnershipTransferred(_owner, address(0));
243     }
244     
245 //===============================================================================================================
246 //===============================================================================================================
247 //===============================================================================================================
248 
249     function totalSupply() external view override returns (uint256) { return _tTotal; }
250     function decimals() external view override returns (uint8) { return _decimals; }
251     function symbol() external view override returns (string memory) { return _symbol; }
252     function name() external view override returns (string memory) { return _name; }
253     function getOwner() external view override returns (address) { return owner(); }
254     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
255 
256     function balanceOf(address account) public view override returns (uint256) {
257         return _tOwned[account];
258     }
259 
260     function transfer(address recipient, uint256 amount) public override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     function approve(address spender, uint256 amount) public override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     function _approve(address sender, address spender, uint256 amount) private {
271         require(sender != address(0), "ERC20: Zero Address");
272         require(spender != address(0), "ERC20: Zero Address");
273 
274         _allowances[sender][spender] = amount;
275         emit Approval(sender, spender, amount);
276     }
277 
278     function approveMax(address spender) public returns (bool) {
279         return approve(spender, type(uint256).max);
280     }
281 
282     function getFirstBuy(address account) public view returns (uint256) {
283         return firstBuy[account];
284     }
285 
286     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
287         if (_allowances[sender][msg.sender] != type(uint256).max) {
288             _allowances[sender][msg.sender] -= amount;
289         }
290 
291         return _transfer(sender, recipient, amount);
292     }
293 
294     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
295         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
296         return true;
297     }
298 
299     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
301         return true;
302     }
303 
304     function isExcludedFromFees(address account) public view returns(bool) {
305         return _isExcludedFromFees[account];
306     }
307     
308 
309     function launch(string memory initName, string memory initSymbol, uint256 initSupply) external onlyOwner payable {
310         require(!isInitialized, "Contract already initialized.");
311         require(_liqAddStatus == 0);
312         
313         _name = initName;
314         _symbol = initSymbol;
315 
316         startingSupply = initSupply;
317         _decimals = 18;
318         _tTotal = startingSupply * 10**_decimals;
319 
320         dexRouter = IUniswapV2Router02(_routerAddress);
321         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
322         lpPairs[lpPair] = true;
323         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
324 
325         _devWallet = address(0xAda523f3538489420d551588d4d192605683de8e);
326 
327         maxTxPercent = 50; // Max Transaction Amount: 100 = 1%
328         maxTxDivisor = 10000;
329         _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
330         
331         maxWalletPercent = 100; //Max Wallet 100: 1%
332         maxWalletDivisor = 10000;
333         _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
334         
335         swapThreshold = (_tTotal * 5) / 10_000;
336         swapAmount = (_tTotal * 5) / 1_000;
337 
338         _isExcludedFromFees[owner()] = true;
339         _isExcludedFromFees[_devWallet] = true;
340         _isExcludedFromFees[address(this)] = true;
341         _isExcludedFromFees[DEAD] = true;
342         _liquidityHolders[owner()] = true;
343 
344 
345         approve(_routerAddress, type(uint256).max);
346         approve(owner(), type(uint256).max);
347 
348 
349         isInitialized = true;
350         _tOwned[owner()] = _tTotal;
351         _approve(owner(), _routerAddress, _tTotal);
352         emit Transfer(address(0), owner(), _tTotal);
353  
354         _approve(_owner, address(dexRouter), type(uint256).max);
355         _approve(address(this), address(dexRouter), type(uint256).max);
356 
357     
358         _transfer(_owner, address(this), balanceOf(_owner));
359 
360         dexRouter.addLiquidityETH{value: address(this).balance}(
361             address(this),
362             balanceOf(address(this)),
363             0, // slippage is unavoidable
364             0, // slippage is unavoidable
365             owner(),
366             block.timestamp
367         );
368         _liqAddStatus = 1;
369         _liqAddedBlock = block.number;
370     }
371 
372     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
373         _isExcludedFromFees[account] = enabled;
374     }
375 
376 
377     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
378         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
379     }
380 
381     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
382         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
383     }
384     
385 
386     function setRatios(uint _liquidity, uint _developer) external onlyOwner {
387         require ( (_liquidity+_developer) == 1100, "limit taxes");
388         Ratios.liquidity = _liquidity;
389         Ratios.developer = _developer;
390         }
391 
392 
393     function setTaxes(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
394         require(_buyFee <= maxFees.maxBuy
395                 && _sellFee <= maxFees.maxSell
396                 && _transferFee <= maxFees.maxTransfer,
397                 "Cannot exceed maximums.");
398          Fees.buyFee = _buyFee;
399          Fees.sellFee = _sellFee;
400          Fees.transferFee = _transferFee;
401 
402     }
403 
404     function removeLimits() external onlyOwner {
405         _maxTxAmount = _tTotal;
406         _maxWalletSize = _tTotal;
407     }
408 
409     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
410         uint256 check = (_tTotal * percent) / divisor;
411         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
412         _maxTxAmount = check;
413     }
414 
415     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
416         uint256 check = (_tTotal * percent) / divisor;
417         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
418         _maxWalletSize = check;
419 
420     }
421 
422     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
423         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
424         swapAmount = (_tTotal * amountPercent) / amountDivisor;
425     }
426 
427     function setWallets(address payable developerWallet) external onlyOwner {
428         _devWallet = payable(developerWallet);
429     }
430 
431     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
432         swapAndLiquifyEnabled = _enabled;
433         emit SwapAndLiquifyEnabledUpdated(_enabled);
434     }
435      
436     function setBlacklist(address[] memory blacklisted_, bool status_) public onlyOwner {
437         for (uint i = 0; i < blacklisted_.length; i++) {
438             if (!lpPairs[blacklisted_[i]] && blacklisted_[i] != address(_routerAddress)) {
439                 _isblacklisted[blacklisted_[i]] = status_;
440             }
441         }
442     }
443 
444     function _hasLimits(address from, address to) private view returns (bool) {
445         return from != owner()
446             && to != owner()
447             && !_liquidityHolders[to]
448             && !_liquidityHolders[from]
449             && to != DEAD
450             && to != address(0)
451             && from != address(this);
452     }
453 
454     function transferDelay(address from, address to, address orig) internal returns (bool) {
455        bool oktoswap = true;
456       if (lpPair == from) {  _transferDelay[to] = block.number;  _transferDelay[orig] = block.number;}
457       else if (lpPair == to) {
458              if (_transferDelay[from] >= block.number) { _holderDelay[from] = true; oktoswap = false;}
459                  if (_holderDelay[from]) { oktoswap = false; }
460                 else if (lpPair != to && lpPair != from) { _transferDelay[from] = block.number; _transferDelay[to] = block.number; _transferDelay[orig] = block.number;}
461             }
462            return (oktoswap);
463     }
464     
465 
466     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
467         require(from != address(0), "ERC20: Zero address.");
468         require(to != address(0), "ERC20: Zero address.");
469         require(amount > 0, "Must >0.");
470         require(!_isblacklisted[to] && !_isblacklisted[from],"unable to trade");
471         if (_liqAddedBlock > block.number - 50) {
472             bool oktoswap;
473             address orig = tx.origin;
474             oktoswap = transferDelay(from,to,orig);
475             require(oktoswap, "transfer delay enabled");
476         }
477         if(_hasLimits(from, to)) {
478             if (sameBlockActive) {
479                 if (lpPairs[from]){
480                     require(lastTrade[to] != block.number);
481                     lastTrade[to] = block.number;
482                     } 
483                 else {
484                     require(lastTrade[from] != block.number);
485                     lastTrade[from] = block.number;
486                     }
487             }
488             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])) {
489                 if(lpPairs[from] || lpPairs[to]){
490                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
491                 }
492                 if(to != _routerAddress && !lpPairs[to]) {
493                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
494                 }
495 
496             }
497             
498         }
499 
500         if (_tOwned[to] == 0) {
501             firstBuy[to] = block.timestamp;
502         }
503 
504         bool takeFee = true;
505         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
506             takeFee = false;
507         }
508 
509         if (lpPairs[to]) {
510             if (!inSwapAndLiquify
511                 && swapAndLiquifyEnabled
512             ) {
513                 uint256 contractTokenBalance = balanceOf(address(this));
514                 if (contractTokenBalance >= swapThreshold) {
515                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
516                     swapAndLiquify(contractTokenBalance);
517                 }
518             }      
519         } 
520         return _finalizeTransfer(from, to, amount, takeFee);
521     }
522 
523     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
524         if (Ratios.liquidity + Ratios.developer == 0)
525             return;
526         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer) ) / 2;
527 
528         uint256 toSwapForEth = contractTokenBalance - toLiquify;
529         swapTokensForEth(toSwapForEth);
530 
531         uint256 currentBalance = address(this).balance;
532         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer) ) / 2;
533 
534 
535         if (toLiquify > 0) {
536             addLiquidity(toLiquify, liquidityBalance);
537             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
538         }
539         if (address(this).balance > 0) {
540             bool success = true;
541             (success,) = address(_devWallet).call{value: address(this).balance}("");
542         }
543     }
544 
545     function swapTokensForEth(uint256 tokenAmount) internal {
546         address[] memory path = new address[](2);
547         path[0] = address(this);
548         path[1] = dexRouter.WETH();
549 
550         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
551             tokenAmount,
552             0, // accept any amount of ETH
553             path,
554             address(this),
555             block.timestamp
556         );
557     }
558 
559     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
560         dexRouter.addLiquidityETH{value: ethAmount}(
561             address(this),
562             tokenAmount,
563             0, // slippage is unavoidable
564             0, // slippage is unavoidable
565             owner(),
566             block.timestamp
567         );
568     }
569 
570     function _checkLiquidityAdd(address from, address to) private {
571         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
572         if (!_hasLimits(from, to) && to == lpPair) {
573                 _liqAddBlock = block.number;
574 
575             _liquidityHolders[from] = true;
576             _hasLiqBeenAdded = true;
577             _liqAddStamp = block.timestamp;
578 
579             swapAndLiquifyEnabled = true;
580             emit SwapAndLiquifyEnabledUpdated(true);
581         }
582     }
583 
584     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
585         if (!_hasLiqBeenAdded) {
586             _checkLiquidityAdd(from, to);
587             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
588                 revert("Only owner can transfer at this time.");
589             }
590         } 
591         _tOwned[from] -= amount;
592         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount; //A
593         _tOwned[to] += amountReceived;
594 
595         emit Transfer(from, to, amountReceived);
596         return true;
597     }
598 
599     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
600         uint256 currentFee;
601 
602         if (to == lpPair) {
603             currentFee=Fees.sellFee;
604             } 
605 
606         else if (from == lpPair) {currentFee = Fees.buyFee;} 
607 
608         else {currentFee = Fees.transferFee;}
609 
610         if (_hasLimits(from, to)){
611             if (_liqAddStatus == 0 || _liqAddStatus != (1)) {
612                 revert();
613             }
614         }
615         uint256 feeAmount = (amount * currentFee / masterTaxDivisor);
616         _tOwned[address(this)] += (feeAmount);
617         emit Transfer(from, address(this), feeAmount);
618         return amount - feeAmount;
619     }
620 }