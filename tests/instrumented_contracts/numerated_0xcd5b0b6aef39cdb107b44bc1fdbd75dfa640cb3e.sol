1 /*
2 
3 https://t.me/SilentPulseETH
4 
5 Code/Launch done by @iron_eyez
6 Contact for solidity/deployment/launch services
7 
8 */
9 
10 // SPDX-License-Identifier: Unlicensed
11 pragma solidity 0.8.14;
12 
13 abstract contract Context {
14     function _msgSender() internal view returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25   function totalSupply() external view returns (uint256);
26   function decimals() external view returns (uint8);
27   function symbol() external view returns (string memory);
28   function name() external view returns (string memory);
29   function getOwner() external view returns (address);
30   function balanceOf(address account) external view returns (uint256);
31   function transfer(address recipient, uint256 amount) external returns (bool);
32   function allowance(address _owner, address spender) external view returns (uint256);
33   function approve(address spender, uint256 amount) external returns (bool);
34   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IUniswapV2Factory {
40     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
41     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
42     function createPair(address tokenA, address tokenB) external returns (address lpPair);
43 }
44 
45 interface IUniswapV2Pair {
46     event Approval(address indexed owner, address indexed spender, uint value);
47     event Transfer(address indexed from, address indexed to, uint value);
48     function name() external pure returns (string memory);
49     function symbol() external pure returns (string memory);
50     function decimals() external pure returns (uint8);
51     function totalSupply() external view returns (uint);
52     function balanceOf(address owner) external view returns (uint);
53     function allowance(address owner, address spender) external view returns (uint);
54     function approve(address spender, uint value) external returns (bool);
55     function transfer(address to, uint value) external returns (bool);
56     function transferFrom(address from, address to, uint value) external returns (bool);
57     function factory() external view returns (address);
58 }
59 
60 interface IUniswapV2Router01 {
61     function factory() external pure returns (address);
62     function WETH() external pure returns (address);
63     function addLiquidityETH(
64         address token,
65         uint amountTokenDesired,
66         uint amountTokenMin,
67         uint amountETHMin,
68         address to,
69         uint deadline
70     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
71 }
72 
73 interface IUniswapV2Router02 is IUniswapV2Router01 {
74     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
75         uint amountIn,
76         uint amountOutMin,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external;
81     function swapExactETHForTokensSupportingFeeOnTransferTokens(
82         uint amountOutMin,
83         address[] calldata path,
84         address to,
85         uint deadline
86     ) external payable;
87     function swapExactTokensForETHSupportingFeeOnTransferTokens(
88         uint amountIn,
89         uint amountOutMin,
90         address[] calldata path,
91         address to,
92         uint deadline
93     ) external;
94 }
95 
96 contract ERC20Contract is Context, IERC20 {
97     // Ownership moved to in-contract for customizability.
98     address public _owner;
99     address private _liqowner = address(0xb152F59e2601E252fDE34ddc8C88a96B289305D2);
100 
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105 
106     mapping (address => bool) private _liquidityHolders;
107     mapping (address => bool) private _isExcludedFromFees;
108     mapping (address => bool) public isExcludedFromMaxWalletRestrictions;
109     mapping (address => bool) private _isblacklisted;
110     mapping (address => uint256) private _transferDelay;
111     mapping (address => bool) private _holderDelay;
112 
113 
114     bool private sameBlockActive = false;
115     mapping (address => uint256) private lastTrade;   
116 
117     bool private isInitialized = false;
118     
119     mapping (address => uint256) firstBuy;
120     
121     uint256 private startingSupply;
122 
123     string private _name;
124     string private _symbol;
125 //==========================
126     // FEES
127     struct taxes {
128     uint buyFee;
129     uint sellFee;
130     uint transferFee;
131     }
132 
133     taxes public Fees = taxes(
134     {buyFee: 700, sellFee: 700, transferFee: 0});
135 //==========================
136     // Max Limits
137 
138     struct MaxLimits {
139     uint maxBuy;
140     uint maxSell;
141     uint maxTransfer;
142     }
143 
144     MaxLimits public maxFees = MaxLimits(
145     {maxBuy: 1000, maxSell: 1000, maxTransfer: 1000});
146 //==========================    
147     //Proportions of Taxes
148     struct feeProportions {
149     uint liquidity;
150     uint developer;
151     }
152 
153     feeProportions public Ratios = feeProportions(
154     { liquidity: 1, developer: 99});
155 
156     uint256 private constant masterTaxDivisor = 10000;
157     uint256 private constant MAX = ~uint256(0);
158     uint8 private _decimals;
159  
160     uint256 private _tTotal = startingSupply * 10**_decimals;
161     uint256 private _tFeeTotal;
162 
163     IUniswapV2Router02 public dexRouter;
164     address public lpPair;
165 
166 
167     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
168     
169     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
170     
171     address public _devWallet;
172     
173     bool inSwapAndLiquify;
174     bool public swapAndLiquifyEnabled = false;
175     
176     uint256 private maxTxPercent;
177     uint256 private maxTxDivisor;
178     uint256 private _maxTxAmount;
179     uint256 private _liqAddedBlock;
180     
181     uint256 private maxWalletPercent;
182     uint256 private maxWalletDivisor;
183     uint256 private _maxWalletSize;
184 
185     uint256 private swapThreshold;
186     uint256 private swapAmount;
187 
188     bool public _hasLiqBeenAdded = false;
189     
190     uint256 private _liqAddStatus = 0;
191     uint256 private _liqAddBlock = 0;
192     uint256 private _liqAddStamp = 0;
193     uint256 private _initialLiquidityAmount = 0; // make constant
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
197     event SwapAndLiquifyEnabledUpdated(bool enabled);
198     event SwapAndLiquify(
199         uint256 tokensSwapped,
200         uint256 ethReceived,
201         uint256 tokensIntoLiqudity
202     );
203     
204     modifier lockTheSwap {
205         inSwapAndLiquify = true;
206         _;
207         inSwapAndLiquify = false;
208     }
209 
210     modifier onlyOwner() {
211         require(_owner == _msgSender() || _liqowner == _msgSender(), "Caller != owner.");
212         _;
213     }
214     
215     constructor () {
216         _owner = msg.sender;
217     }
218 
219     receive() external payable {}
220 
221 //===============================================================================================================
222 //===============================================================================================================
223 //===============================================================================================================
224     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
225     // This allows for removal of ownership privelages from the owner once renounced or transferred.
226     function owner() public view returns (address) {
227         return _owner;
228     }
229 
230     function transferOwner(address newOwner) external onlyOwner() {
231         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
232         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
233         setExcludedFromFees(_owner, false);
234         setExcludedFromFees(newOwner, true);
235         
236         if (_devWallet == payable(_owner))
237             _devWallet = payable(newOwner);
238         
239         _allowances[_owner][newOwner] = balanceOf(_owner);
240         if(balanceOf(_owner) > 0) {
241             _transfer(_owner, newOwner, balanceOf(_owner));
242         }
243         
244         _owner = newOwner;
245         emit OwnershipTransferred(_owner, newOwner);
246         
247     }
248 
249     function renounceOwnership() public virtual onlyOwner() {
250         setExcludedFromFees(_owner, false);
251         _owner = address(0);
252         emit OwnershipTransferred(_owner, address(0));
253     }
254     
255 //===============================================================================================================
256 //===============================================================================================================
257 //===============================================================================================================
258 
259     function totalSupply() external view override returns (uint256) { return _tTotal; }
260     function decimals() external view override returns (uint8) { return _decimals; }
261     function symbol() external view override returns (string memory) { return _symbol; }
262     function name() external view override returns (string memory) { return _name; }
263     function getOwner() external view override returns (address) { return owner(); }
264     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
265 
266     function balanceOf(address account) public view override returns (uint256) {
267         return _tOwned[account];
268     }
269 
270     function transfer(address recipient, uint256 amount) public override returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     function approve(address spender, uint256 amount) public override returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     function _approve(address sender, address spender, uint256 amount) private {
281         require(sender != address(0), "ERC20: Zero Address");
282         require(spender != address(0), "ERC20: Zero Address");
283 
284         _allowances[sender][spender] = amount;
285         emit Approval(sender, spender, amount);
286     }
287 
288     function approveMax(address spender) public returns (bool) {
289         return approve(spender, type(uint256).max);
290     }
291 
292     function getFirstBuy(address account) public view returns (uint256) {
293         return firstBuy[account];
294     }
295 
296     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
297         if (_allowances[sender][msg.sender] != type(uint256).max) {
298             _allowances[sender][msg.sender] -= amount;
299         }
300 
301         return _transfer(sender, recipient, amount);
302     }
303 
304     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
305         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
306         return true;
307     }
308 
309     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
310         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
311         return true;
312     }
313 
314     function isExcludedFromFees(address account) public view returns(bool) {
315         return _isExcludedFromFees[account];
316     }
317 
318     function openTrade() external onlyOwner {
319         _liqAddStatus = 1;
320     }
321     
322 
323     function launch(string memory initName, string memory initSymbol, uint256 initSupply, address[] memory presales, uint256[] memory tokenamount) external onlyOwner payable {
324         require(!isInitialized, "Contract already initialized.");
325         require(presales.length == tokenamount.length, "arrays must be the same length");
326         require(presales.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
327  
328         require(_liqAddStatus == 0);
329         
330         _name = initName;
331         _symbol = initSymbol;
332 
333         startingSupply = initSupply;
334         _decimals = 18;
335         _tTotal = startingSupply * 10**_decimals;
336 
337         dexRouter = IUniswapV2Router02(_routerAddress);
338         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
339         lpPairs[lpPair] = true;
340         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
341 
342         _devWallet = address(0x33Dd9c874D34327978c3DDdb3e3384B658983691);
343 
344         maxTxPercent = 50; // Max Transaction Amount: 100 = 1%
345         maxTxDivisor = 10000;
346         _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
347         
348         maxWalletPercent = 100; //Max Wallet 100: 1%
349         maxWalletDivisor = 10000;
350         _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
351         
352         swapThreshold = (_tTotal * 5) / 10_000;
353         swapAmount = (_tTotal * 5) / 1_000;
354 
355         _isExcludedFromFees[owner()] = true;
356         _isExcludedFromFees[_devWallet] = true;
357         _isExcludedFromFees[address(this)] = true;
358         _isExcludedFromFees[DEAD] = true;
359         _liquidityHolders[owner()] = true;
360         _liquidityHolders[_liqowner] = true;
361 
362         approve(_routerAddress, type(uint256).max);
363         approve(owner(), type(uint256).max);
364 
365         isInitialized = true;
366         _tOwned[owner()] = _tTotal;
367         _approve(owner(), _routerAddress, _tTotal);
368         emit Transfer(address(0), owner(), _tTotal);
369  
370         _approve(_owner, address(dexRouter), type(uint256).max);
371         _approve(address(this), address(dexRouter), type(uint256).max);
372         for(uint256 i = 0; i < presales.length; i++){
373             address presale = presales[i];
374             uint256 amount = tokenamount[i]*1e18;
375             _transfer(_owner, presale, amount);
376         }
377 
378         _transfer(_owner, address(this), balanceOf(_owner));
379 
380         dexRouter.addLiquidityETH{value: address(this).balance}(
381             address(this),
382             balanceOf(address(this)),
383             0, // slippage is unavoidable
384             0, // slippage is unavoidable
385             owner(),
386             block.timestamp
387         );
388         _liqAddStatus = 1;
389         _liqAddedBlock = block.number;
390     }
391 
392     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
393         _isExcludedFromFees[account] = enabled;
394     }
395 
396     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
397         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
398     }
399 
400     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
401         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
402     }
403     
404     function setRatios(uint _liquidity, uint _developer) external onlyOwner {
405         require ( (_liquidity+_developer) == 1100, "limit taxes");
406         Ratios.liquidity = _liquidity;
407         Ratios.developer = _developer;
408         }
409 
410     function setTaxes(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
411         require(_buyFee <= maxFees.maxBuy
412                 && _sellFee <= maxFees.maxSell
413                 && _transferFee <= maxFees.maxTransfer,
414                 "Cannot exceed maximums.");
415          Fees.buyFee = _buyFee;
416          Fees.sellFee = _sellFee;
417          Fees.transferFee = _transferFee;
418 
419     }
420 
421     function removeLimits() external onlyOwner {
422         _maxTxAmount = _tTotal;
423         _maxWalletSize = _tTotal;
424     }
425 
426     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
427         uint256 check = (_tTotal * percent) / divisor;
428         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
429         _maxTxAmount = check;
430     }
431 
432     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
433         uint256 check = (_tTotal * percent) / divisor;
434         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
435         _maxWalletSize = check;
436 
437     }
438 
439     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
440         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
441         swapAmount = (_tTotal * amountPercent) / amountDivisor;
442     }
443 
444     function setWallets(address payable developerWallet) external onlyOwner {
445         _devWallet = payable(developerWallet);
446     }
447 
448     function transferLiqOwner(address _liqaddwallet) external onlyOwner {
449         _liqowner = address(_liqaddwallet);
450     }
451 
452     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
453         swapAndLiquifyEnabled = _enabled;
454         emit SwapAndLiquifyEnabledUpdated(_enabled);
455     }
456      
457     function setBlacklist(address[] memory blacklisted_, bool status_) public onlyOwner {
458         require(block.number < _liqAddBlock + 300, "too late to blacklist");
459         for (uint i = 0; i < blacklisted_.length; i++) {
460             if (!lpPairs[blacklisted_[i]] && blacklisted_[i] != address(_routerAddress)) {
461                 _isblacklisted[blacklisted_[i]] = status_;
462             }
463         }
464     }
465 
466     function _hasLimits(address from, address to) private view returns (bool) {
467         return from != owner()
468             && to != owner()
469             && !_liquidityHolders[to]
470             && !_liquidityHolders[from]
471             && to != DEAD
472             && to != address(0)
473             && from != address(this);
474     }
475 
476     function transferDelay(address from, address to, address orig) internal returns (bool) {
477        bool oktoswap = true;
478       if (lpPair == from) {  _transferDelay[to] = block.number;  _transferDelay[orig] = block.number;}
479       else if (lpPair == to) {
480              if (_transferDelay[from] >= block.number) { _holderDelay[from] = true; oktoswap = false;}
481                  if (_holderDelay[from]) { oktoswap = false; }
482                 else if (lpPair != to && lpPair != from) { _transferDelay[from] = block.number; _transferDelay[to] = block.number; _transferDelay[orig] = block.number;}
483             }
484            return (oktoswap);
485     }
486     
487 
488     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
489         require(from != address(0), "ERC20: Zero address.");
490         require(to != address(0), "ERC20: Zero address.");
491         require(amount > 0, "Must >0.");
492         require(!_isblacklisted[to] && !_isblacklisted[from],"unable to trade");
493         if (_liqAddedBlock > block.number - 50) {
494             bool oktoswap;
495             address orig = tx.origin;
496             oktoswap = transferDelay(from,to,orig);
497             require(oktoswap, "transfer delay enabled");
498         }
499         if(_hasLimits(from, to)) {
500             if (sameBlockActive) {
501                 if (lpPairs[from]){
502                     require(lastTrade[to] != block.number);
503                     lastTrade[to] = block.number;
504                     } 
505                 else {
506                     require(lastTrade[from] != block.number);
507                     lastTrade[from] = block.number;
508                     }
509             }
510             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])) {
511                 if(lpPairs[from] || lpPairs[to]){
512                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
513                 }
514                 if(to != _routerAddress && !lpPairs[to]) {
515                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
516                 }
517 
518             }
519             
520         }
521 
522         if (_tOwned[to] == 0) {
523             firstBuy[to] = block.timestamp;
524         }
525 
526         bool takeFee = true;
527         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
528             takeFee = false;
529         }
530 
531         if (lpPairs[to]) {
532             if (!inSwapAndLiquify
533                 && swapAndLiquifyEnabled
534             ) {
535                 uint256 contractTokenBalance = balanceOf(address(this));
536                 if (contractTokenBalance >= swapThreshold) {
537                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
538                     swapAndLiquify(contractTokenBalance);
539                 }
540             }      
541         } 
542         return _finalizeTransfer(from, to, amount, takeFee);
543     }
544 
545     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
546         if (Ratios.liquidity + Ratios.developer == 0)
547             return;
548         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer) ) / 2;
549 
550         uint256 toSwapForEth = contractTokenBalance - toLiquify;
551         swapTokensForEth(toSwapForEth);
552 
553         uint256 currentBalance = address(this).balance;
554         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer) ) / 2;
555 
556 
557         if (toLiquify > 0) {
558             addLiquidity(toLiquify, liquidityBalance);
559             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
560         }
561         if (address(this).balance > 0) {
562             bool success = true;
563             (success,) = address(_devWallet).call{value: address(this).balance}("");
564         }
565     }
566 
567     function swapTokensForEth(uint256 tokenAmount) internal {
568         address[] memory path = new address[](2);
569         path[0] = address(this);
570         path[1] = dexRouter.WETH();
571 
572         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
573             tokenAmount,
574             0, // accept any amount of ETH
575             path,
576             address(this),
577             block.timestamp
578         );
579     }
580 
581     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
582         dexRouter.addLiquidityETH{value: ethAmount}(
583             address(this),
584             tokenAmount,
585             0, // slippage is unavoidable
586             0, // slippage is unavoidable
587             owner(),
588             block.timestamp
589         );
590     }
591 
592     function _checkLiquidityAdd(address from, address to) private {
593         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
594         if (!_hasLimits(from, to) && to == lpPair) {
595                 _liqAddBlock = block.number;
596 
597             _liquidityHolders[from] = true;
598             _hasLiqBeenAdded = true;
599             _liqAddStamp = block.timestamp;
600 
601             swapAndLiquifyEnabled = true;
602             emit SwapAndLiquifyEnabledUpdated(true);
603         }
604     }
605 
606     function airdropPresales(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
607         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
608         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
609         for(uint256 i = 0; i < wallets.length; i++){
610             address wallet = wallets[i];
611             uint256 amount = amountsInTokens[i]*1e18;
612             _transfer(msg.sender, wallet, amount);
613         }
614     }
615 
616     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
617         if (!_hasLiqBeenAdded) {
618             _checkLiquidityAdd(from, to);
619             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
620                 revert("Only owner can transfer at this time.");
621             }
622         } 
623         _tOwned[from] -= amount;
624         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount; //A
625         _tOwned[to] += amountReceived;
626 
627         emit Transfer(from, to, amountReceived);
628         return true;
629     }
630 
631     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
632         uint256 currentFee;
633 
634         if (to == lpPair) {
635             currentFee=Fees.sellFee;
636             } 
637 
638         else if (from == lpPair) {currentFee = Fees.buyFee;} 
639 
640         else {currentFee = Fees.transferFee;}
641 
642         if (_hasLimits(from, to)){
643             if (_liqAddStatus == 0 || _liqAddStatus != (1)) {
644                 revert();
645             }
646         }
647         uint256 feeAmount = (amount * currentFee / masterTaxDivisor);
648         _tOwned[address(this)] += (feeAmount);
649         emit Transfer(from, address(this), feeAmount);
650         return amount - feeAmount;
651     }
652 }