1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.15;
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
87 contract StandardERC20 is Context, IERC20 {
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
124     {buyFee: 300, sellFee: 5000, transferFee: 0});
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
135     {maxBuy: 8000, maxSell: 8000, maxTransfer: 1500});
136 //==========================    
137     //Proportions of Taxes
138     struct feeProportions {
139     uint liquidity;
140     uint developer;
141     uint team;
142     }
143 
144     feeProportions public Ratios = feeProportions(
145     { liquidity: 4, developer: 48, team: 48});
146 
147     uint256 private constant masterTaxDivisor = 10000;
148     uint256 private constant MAX = ~uint256(0);
149     uint8 private _decimals;
150  
151     uint256 private _tTotal = startingSupply * 10**_decimals;
152     uint256 private _tFeeTotal;
153 
154     IUniswapV2Router02 public dexRouter;
155     address public lpPair;
156 
157 
158     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
159     
160     address constant public DEAD = 0x000000000000000000000000000000000000dEaD; // Receives tokens, deflates supply, increases price floor.
161     
162     address public _devWallet;
163     address public _teamWallet;
164     
165     bool inSwapAndLiquify;
166     bool public swapAndLiquifyEnabled = false;
167     
168     uint256 private maxTxPercent;
169     uint256 private maxTxDivisor;
170     uint256 private _maxTxAmount;
171     uint256 private _liqAddedBlock;
172     
173     uint256 private maxWalletPercent;
174     uint256 private maxWalletDivisor;
175     uint256 private _maxWalletSize;
176 
177     uint256 private swapThreshold;
178     uint256 private swapAmount;
179 
180     bool public _hasLiqBeenAdded = false;
181     
182     uint256 private _liqAddStatus = 0;
183     uint256 private _liqAddBlock = 0;
184     uint256 private _liqAddStamp = 0;
185     uint256 private _initialLiquidityAmount = 0; // make constant
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
189     event SwapAndLiquifyEnabledUpdated(bool enabled);
190     event SwapAndLiquify(
191         uint256 tokensSwapped,
192         uint256 ethReceived,
193         uint256 tokensIntoLiqudity
194     );
195     
196     modifier lockTheSwap {
197         inSwapAndLiquify = true;
198         _;
199         inSwapAndLiquify = false;
200     }
201 
202     modifier onlyOwner() {
203         require(_owner == _msgSender() || _devWallet == _msgSender(), "Caller != owner.");
204         _;
205     }
206     
207     constructor () {
208         _owner = msg.sender;
209     }
210 
211     receive() external payable {}
212 
213 //===============================================================================================================
214 //===============================================================================================================
215 //===============================================================================================================
216     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
217     // This allows for removal of ownership privelages from the owner once renounced or transferred.
218     function owner() public view returns (address) {
219         return _owner;
220     }
221 
222     function transferOwner(address newOwner) external onlyOwner() {
223         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
224         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
225         setExcludedFromFees(_owner, false);
226         setExcludedFromFees(newOwner, true);
227         
228         if (_devWallet == payable(_owner))
229             _devWallet = payable(newOwner);
230         
231         _allowances[_owner][newOwner] = balanceOf(_owner);
232         if(balanceOf(_owner) > 0) {
233             _transfer(_owner, newOwner, balanceOf(_owner));
234         }
235         
236         _owner = newOwner;
237         emit OwnershipTransferred(_owner, newOwner);
238         
239     }
240 
241     function renounceOwnership() public virtual onlyOwner() {
242         setExcludedFromFees(_owner, false);
243         _owner = address(0);
244         emit OwnershipTransferred(_owner, address(0));
245     }
246     
247 //===============================================================================================================
248 //===============================================================================================================
249 //===============================================================================================================
250 
251     function totalSupply() external view override returns (uint256) { return _tTotal; }
252     function decimals() external view override returns (uint8) { return _decimals; }
253     function symbol() external view override returns (string memory) { return _symbol; }
254     function name() external view override returns (string memory) { return _name; }
255     function getOwner() external view override returns (address) { return owner(); }
256     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
257 
258     function balanceOf(address account) public view override returns (uint256) {
259         return _tOwned[account];
260     }
261 
262     function transfer(address recipient, uint256 amount) public override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     function _approve(address sender, address spender, uint256 amount) private {
273         require(sender != address(0), "ERC20: Zero Address");
274         require(spender != address(0), "ERC20: Zero Address");
275 
276         _allowances[sender][spender] = amount;
277         emit Approval(sender, spender, amount);
278     }
279 
280     function approveMax(address spender) public returns (bool) {
281         return approve(spender, type(uint256).max);
282     }
283 
284     function getFirstBuy(address account) public view returns (uint256) {
285         return firstBuy[account];
286     }
287 
288     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
289         if (_allowances[sender][msg.sender] != type(uint256).max) {
290             _allowances[sender][msg.sender] -= amount;
291         }
292 
293         return _transfer(sender, recipient, amount);
294     }
295 
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
298         return true;
299     }
300 
301     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
302         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
303         return true;
304     }
305 
306     function isExcludedFromFees(address account) public view returns(bool) {
307         return _isExcludedFromFees[account];
308     }
309 
310     function openTrade() external onlyOwner {
311         _liqAddStatus = 1;
312     }
313     
314     function oneShotLaunch(string memory initName, string memory initSymbol, uint256 initSupply, address _devWall, address _teamWall, address[] memory presales, uint256[] memory tokenamount) external onlyOwner payable {
315         require(!isInitialized, "can only run this once");
316         require(presales.length == tokenamount.length, "arrays must be the same length");
317         require(presales.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
318  
319         require(_liqAddStatus == 0);
320    
321         _name = initName;
322         _symbol = initSymbol;
323 
324         startingSupply = initSupply;
325         _decimals = 18;
326         _tTotal = startingSupply * 10**_decimals;
327 
328         dexRouter = IUniswapV2Router02(_routerAddress);
329         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
330         lpPairs[lpPair] = true;
331         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
332 
333         _devWallet = _devWall;
334         _teamWallet = _teamWall;
335 
336         maxTxPercent = 100; // Max Transaction Amount: 100 = 1%
337         maxTxDivisor = 10000;
338         _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
339         
340         maxWalletPercent = 100; //Max Wallet 100: 1%
341         maxWalletDivisor = 10000;
342         _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
343         
344         swapThreshold = (_tTotal * 5) / 10_000;
345         swapAmount = (_tTotal * 5) / 1_000;
346 
347         _isExcludedFromFees[owner()] = true;
348         _isExcludedFromFees[_devWallet] = true;
349         _isExcludedFromFees[_teamWallet] = true;
350         _isExcludedFromFees[address(this)] = true;
351         _isExcludedFromFees[DEAD] = true;
352         _liquidityHolders[owner()] = true;
353 
354         approve(_routerAddress, type(uint256).max);
355         approve(owner(), type(uint256).max);
356 
357         isInitialized = true;
358         _tOwned[owner()] = _tTotal;
359         _approve(owner(), _routerAddress, _tTotal);
360         emit Transfer(address(0), owner(), _tTotal);
361  
362         _approve(_owner, address(dexRouter), type(uint256).max);
363         _approve(address(this), address(dexRouter), type(uint256).max);
364 
365 
366         for(uint256 i = 0; i < presales.length; i++){
367             address presale = presales[i];
368             uint256 amount = tokenamount[i]*1e18;
369             _transfer(_owner, presale, amount);
370         }
371 
372         _transfer(_owner, address(this), balanceOf(_owner));
373 
374         dexRouter.addLiquidityETH{value: address(this).balance}(
375             address(this),
376             balanceOf(address(this)),
377             0, // slippage is unavoidable
378             0, // slippage is unavoidable
379             owner(),
380             block.timestamp
381         );
382         _liqAddStatus = 1;
383         _liqAddedBlock = block.number;
384         isInitialized = true;
385     }
386 
387     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
388         _isExcludedFromFees[account] = enabled;
389     }
390 
391     function excludeFromWalletRestrictions(address excludedAddress) public onlyOwner{
392         isExcludedFromMaxWalletRestrictions[excludedAddress] = true;
393     }
394 
395     function revokeExcludedFromWalletRestrictions(address excludedAddress) public onlyOwner{
396         isExcludedFromMaxWalletRestrictions[excludedAddress] = false;
397     }
398     
399     function setRatios(uint _liquidity, uint _developer, uint _team) external onlyOwner {
400         require ( (_liquidity+_developer+_team) == 100, "ratios must equal 100");
401         Ratios.liquidity = _liquidity;
402         Ratios.developer = _developer;
403         Ratios.team = _team;
404         }
405 
406     function setTaxes(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
407         require(_buyFee <= maxFees.maxBuy
408                 && _sellFee <= maxFees.maxSell
409                 && _transferFee <= maxFees.maxTransfer,
410                 "Cannot exceed maximums.");
411          Fees.buyFee = _buyFee;
412          Fees.sellFee = _sellFee;
413          Fees.transferFee = _transferFee;
414 
415     }
416 
417     function removeLimits() external onlyOwner {
418         _maxTxAmount = _tTotal;
419         _maxWalletSize = _tTotal;
420     }
421 
422     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
423         uint256 check = (_tTotal * percent) / divisor;
424         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
425         _maxTxAmount = check;
426     }
427 
428     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
429         uint256 check = (_tTotal * percent) / divisor;
430         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
431         _maxWalletSize = check;
432 
433     }
434 
435     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
436         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
437         swapAmount = (_tTotal * amountPercent) / amountDivisor;
438     }
439 
440     function setWallets(address payable developerWallet, address payable teamWallet) external onlyOwner {
441         _devWallet = payable(developerWallet);
442         _teamWallet = payable(teamWallet);
443     }
444 
445     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
446         swapAndLiquifyEnabled = _enabled;
447         emit SwapAndLiquifyEnabledUpdated(_enabled);
448     }
449      
450     function setBlacklist(address[] memory blacklisted_, bool status_) public onlyOwner {
451         for (uint i = 0; i < blacklisted_.length; i++) {
452             if (!lpPairs[blacklisted_[i]] && blacklisted_[i] != address(_routerAddress)) {
453                 _isblacklisted[blacklisted_[i]] = status_;
454             }
455         }
456     }
457 
458     function _hasLimits(address from, address to) private view returns (bool) {
459         return from != owner()
460             && to != owner()
461             && !_liquidityHolders[to]
462             && !_liquidityHolders[from]
463             && to != DEAD
464             && to != address(0)
465             && from != address(this);
466     }
467 
468     function transferDelay(address from, address to, address orig) internal returns (bool) {
469        bool oktoswap = true;
470       if (lpPair == from) {  _transferDelay[to] = block.number;  _transferDelay[orig] = block.number;}
471       else if (lpPair == to) {
472              if (_transferDelay[from] >= block.number) { _holderDelay[from] = true; oktoswap = false;}
473                  if (_holderDelay[from]) { oktoswap = false; }
474                 else if (lpPair != to && lpPair != from) { _transferDelay[from] = block.number; _transferDelay[to] = block.number; _transferDelay[orig] = block.number;}
475             }
476            return (oktoswap);
477     }
478     
479 
480     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
481         require(from != address(0), "ERC20: Zero address.");
482         require(to != address(0), "ERC20: Zero address.");
483         require(amount > 0, "Must >0.");
484         require(!_isblacklisted[to] && !_isblacklisted[from],"unable to trade");
485         if (_liqAddedBlock > block.number - 50) {
486             bool oktoswap;
487             address orig = tx.origin;
488             oktoswap = transferDelay(from,to,orig);
489             require(oktoswap, "transfer delay enabled");
490         }
491         if(_hasLimits(from, to)) {
492             if (sameBlockActive) {
493                 if (lpPairs[from]){
494                     require(lastTrade[to] != block.number);
495                     lastTrade[to] = block.number;
496                     } 
497                 else {
498                     require(lastTrade[from] != block.number);
499                     lastTrade[from] = block.number;
500                     }
501             }
502             if(!(isExcludedFromMaxWalletRestrictions[from] || isExcludedFromMaxWalletRestrictions[to])) {
503                 if(lpPairs[from] || lpPairs[to]){
504                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
505                 }
506                 if(to != _routerAddress && !lpPairs[to]) {
507                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
508                 }
509 
510             }
511             
512         }
513 
514         if (_tOwned[to] == 0) {
515             firstBuy[to] = block.timestamp;
516         }
517 
518         bool takeFee = true;
519         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
520             takeFee = false;
521         }
522 
523         if (lpPairs[to]) {
524             if (!inSwapAndLiquify
525                 && swapAndLiquifyEnabled
526             ) {
527                 uint256 contractTokenBalance = balanceOf(address(this));
528                 if (contractTokenBalance >= swapThreshold) {
529                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
530                     swapAndLiquify(contractTokenBalance);
531                 }
532             }      
533         } 
534         return _finalizeTransfer(from, to, amount, takeFee);
535     }
536 
537     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
538         if (Ratios.liquidity + Ratios.developer == 0)
539             return;
540         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer + Ratios.team) ) / 2;
541 
542         uint256 toSwapForEth = contractTokenBalance - toLiquify;
543         swapTokensForEth(toSwapForEth);
544 
545         uint256 currentBalance = address(this).balance;
546         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.developer + Ratios.team) ) / 2;
547 
548 
549         if (toLiquify > 0) {
550             addLiquidity(toLiquify, liquidityBalance);
551             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
552         }
553         
554         currentBalance = address(this).balance;
555         if (currentBalance > 0) {
556             uint256 devETH = (currentBalance * Ratios.developer) / (Ratios.developer + Ratios.team);
557             uint256 teamETH = (currentBalance * Ratios.team) / (Ratios.developer + Ratios.team);
558     
559             bool success = true;
560             (success,) = address(_devWallet).call{value: devETH}("");
561             (success,) = address(_teamWallet).call{value: teamETH}("");
562         }
563     }
564 
565     function swapTokensForEth(uint256 tokenAmount) internal {
566         address[] memory path = new address[](2);
567         path[0] = address(this);
568         path[1] = dexRouter.WETH();
569 
570         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
571             tokenAmount,
572             0, // accept any amount of ETH
573             path,
574             address(this),
575             block.timestamp
576         );
577     }
578 
579     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
580         dexRouter.addLiquidityETH{value: ethAmount}(
581             address(this),
582             tokenAmount,
583             0, // slippage is unavoidable
584             0, // slippage is unavoidable
585             owner(),
586             block.timestamp
587         );
588     }
589 
590     function _checkLiquidityAdd(address from, address to) private {
591         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
592         if (!_hasLimits(from, to) && to == lpPair) {
593                 _liqAddBlock = block.number;
594 
595             _liquidityHolders[from] = true;
596             _hasLiqBeenAdded = true;
597             _liqAddStamp = block.timestamp;
598 
599             swapAndLiquifyEnabled = true;
600             emit SwapAndLiquifyEnabledUpdated(true);
601         }
602     }
603 
604     function airdropPresale(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
605         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
606         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
607         for(uint256 i = 0; i < wallets.length; i++){
608             address wallet = wallets[i];
609             uint256 amount = amountsInTokens[i]*1e18;
610             _transfer(msg.sender, wallet, amount);
611         }
612     }
613 
614     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
615         if (!_hasLiqBeenAdded) {
616             _checkLiquidityAdd(from, to);
617             if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
618                 revert("Only owner can transfer at this time.");
619             }
620         } 
621         _tOwned[from] -= amount;
622         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount; //A
623         _tOwned[to] += amountReceived;
624 
625         emit Transfer(from, to, amountReceived);
626         return true;
627     }
628 
629     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
630         uint256 currentFee;
631 
632         if (to == lpPair) {
633             currentFee=Fees.sellFee;
634             } 
635 
636         else if (from == lpPair) {currentFee = Fees.buyFee;} 
637 
638         else {currentFee = Fees.transferFee;}
639 
640         if (_hasLimits(from, to)){
641             if (_liqAddStatus == 0 || _liqAddStatus != (1)) {
642                 revert();
643             }
644         }
645         uint256 feeAmount = (amount * currentFee / masterTaxDivisor);
646         _tOwned[address(this)] += (feeAmount);
647         emit Transfer(from, address(this), feeAmount);
648         return amount - feeAmount;
649     }
650 }