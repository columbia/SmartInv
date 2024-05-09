1 /*
2 
3 Empower your trades with Echo.
4 
5 https://t.me/echobotfinance
6 
7 EchoBot.biz
8 
9 https://twitter.com/echofinancebot
10 
11 */
12 
13 // SPDX-License-Identifier: UNLICENSED
14 pragma solidity 0.8.11;
15 
16 abstract contract Context {
17     function _msgSender() internal view returns (address payable) {
18         return payable(msg.sender);
19     }
20 
21     function _msgData() internal view returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IERC20 {
28   function totalSupply() external view returns (uint256);
29   function decimals() external view returns (uint8);
30   function symbol() external view returns (string memory);
31   function name() external view returns (string memory);
32   function getOwner() external view returns (address);
33   function balanceOf(address account) external view returns (uint256);
34   function transfer(address recipient, uint256 amount) external returns (bool);
35   function allowance(address _owner, address spender) external view returns (uint256);
36   function approve(address spender, uint256 amount) external returns (bool);
37   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 interface IUniswapV2Factory {
43     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
44     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
45     function createPair(address tokenA, address tokenB) external returns (address lpPair);
46 }
47 
48 interface IUniswapV2Pair {
49     event Approval(address indexed owner, address indexed spender, uint value);
50     event Transfer(address indexed from, address indexed to, uint value);
51     function name() external pure returns (string memory);
52     function symbol() external pure returns (string memory);
53     function decimals() external pure returns (uint8);
54     function totalSupply() external view returns (uint);
55     function balanceOf(address owner) external view returns (uint);
56     function allowance(address owner, address spender) external view returns (uint);
57     function approve(address spender, uint value) external returns (bool);
58     function transfer(address to, uint value) external returns (bool);
59     function transferFrom(address from, address to, uint value) external returns (bool);
60     function factory() external view returns (address);
61 }
62 
63 interface IUniswapV2Router01 {
64     function factory() external pure returns (address);
65     function WETH() external pure returns (address);
66     function addLiquidityETH(
67         address token,
68         uint amountTokenDesired,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline
73     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
74 }
75 
76 interface IUniswapV2Router02 is IUniswapV2Router01 {
77     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
78         uint amountIn,
79         uint amountOutMin,
80         address[] calldata path,
81         address to,
82         uint deadline
83     ) external;
84     function swapExactETHForTokensSupportingFeeOnTransferTokens(
85         uint amountOutMin,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external payable;
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97 }
98 
99 contract ECHO is Context, IERC20 {
100     // Ownership moved to in-contract for customizability.
101     address private _owner;
102 
103     mapping (address => uint256) private _tOwned;
104     mapping (address => bool) lpPairs;
105     uint256 private timeSinceLastPair = 0;
106     mapping (address => mapping (address => uint256)) private _allowances;
107 
108     mapping (address => bool) private _liquidityHolders;
109     mapping (address => bool) private _isExcludedFromFees;
110     mapping (address => bool) public ExcludedFromWalletRestrictions;
111 
112     mapping (address => bool) private _isSniper;
113     
114     bool private sameBlockActive = true;
115     mapping (address => uint256) private lastTrade;    
116 
117     uint256 private startingSupply = 1_000_000_000;
118 
119     string private _name = "ECHO BOT";
120     string private _symbol = "ECHO";
121 //==========================
122     // FEES
123     struct taxes {
124     uint buyFee;
125     uint sellFee;
126     uint transferFee;
127     }
128 
129     taxes public Fees = taxes(
130     {buyFee: 2000, sellFee: 2000, transferFee: 0});
131 //==========================
132     // Maxima
133 
134     struct Maxima {
135     uint maxBuy;
136     uint maxSell;
137     uint maxTransfer;
138     }
139 
140     Maxima public maxFees = Maxima(
141     {maxBuy: 500, maxSell: 500, maxTransfer: 500});
142 //==========================    
143     //Proportions of Taxes
144     struct feeProportions {
145     uint liquidity;
146     uint tokenFee;
147     uint TreasuryFee;
148     uint RevenueFee;
149     }
150 
151     feeProportions public Ratios = feeProportions(
152     { liquidity: 0, tokenFee: 0, TreasuryFee: 1000, RevenueFee: 0});
153 
154     uint256 private constant masterTaxDivisor = 10000;
155     uint256 private constant MAX = ~uint256(0);
156     uint8 constant private _decimals = 9;
157  
158     uint256 private _tTotal = startingSupply * 10**_decimals;
159     uint256 private _tFeeTotal;
160 
161     IUniswapV2Router02 public dexRouter;
162     address public lpPair;
163 
164     address constant private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // UNISWAP ROUTER
165     
166     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
167     
168     address payable public _treasuryWallet = payable(0xbE47c9aa991189EeadD5279A90f447729aEC326A);  // Treasury, receives taxes
169     address payable public _revenueWallet = payable(0x2858f2C1D89e547c66302ffBCF311109Ec8347C9);  // This wallet will deploy the revenue share dApp.
170     
171     bool inSwapAndLiquify;
172     bool public swapAndLiquifyEnabled = false;
173     
174     uint256 private maxTxPercent = 2;
175     uint256 private maxTxDivisor = 100;
176     uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
177     
178     uint256 private maxWalletPercent = 2;
179     uint256 private maxWalletDivisor = 100;
180     uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
181     
182     uint256 private swapThreshold = (_tTotal * 5) / 10_000;
183     uint256 private swapAmount = (_tTotal * 5) / 1_000;
184 
185     bool private sniperProtection = true;
186     bool public _hasLiqBeenAdded = false;
187     uint256 private _liqAddStatus = 0;
188     uint256 private _liqAddBlock = 0;
189     uint256 private _liqAddStamp = 0;
190     uint256 private _initialLiquidityAmount = 0; // make constant
191     uint256 private snipeBlockAmt = 0;
192     uint256 public snipersCaught = 0;
193 
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
196     event SwapAndLiquifyEnabledUpdated(bool enabled);
197     event SwapAndLiquify(
198         uint256 tokensSwapped,
199         uint256 ethReceived,
200         uint256 tokensIntoLiqudity
201     );
202     event SniperCaught(address sniperAddress);
203     
204     modifier lockTheSwap {
205         inSwapAndLiquify = true;
206         _;
207         inSwapAndLiquify = false;
208     }
209 
210     modifier onlyOwner() {
211         require(_owner == _msgSender(), "Caller != owner.");
212         _;
213     }
214     
215     constructor () payable {
216         _tOwned[_msgSender()] = _tTotal;
217 
218         // Set the owner.
219         _owner = msg.sender;
220 
221         dexRouter = IUniswapV2Router02(_routerAddress);
222         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
223         lpPairs[lpPair] = true;
224         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
225 
226         _isExcludedFromFees[owner()] = true;
227         _isExcludedFromFees[address(this)] = true;
228         _isExcludedFromFees[_treasuryWallet] = true;
229         _isExcludedFromFees[DEAD] = true;
230 
231         _liquidityHolders[owner()] = true;
232         _liquidityHolders[_treasuryWallet] = true;
233         _liquidityHolders[_revenueWallet] = true;
234 
235         // Approve the owner for Uniswap, timesaver.
236         _approve(_msgSender(), _routerAddress, _tTotal);
237 
238         // Event regarding the tTotal transferred to the _msgSender.
239         emit Transfer(address(0), _msgSender(), _tTotal);
240     }
241 
242     receive() external payable {}
243 
244 //===============================================================================================================
245 //===============================================================================================================
246 //===============================================================================================================
247     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
248     // This allows for removal of ownership privelages from the owner once renounced or transferred.
249     function owner() public view returns (address) {
250         return _owner;
251     }
252 
253     function transferOwner(address newOwner) external onlyOwner() {
254         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
255         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
256         setExcludedFromFees(_owner, false);
257         setExcludedFromFees(newOwner, true);
258         
259 
260         _allowances[_owner][newOwner] = balanceOf(_owner);
261         if(balanceOf(_owner) > 0) {
262             _transfer(_owner, newOwner, balanceOf(_owner));
263         }
264         
265         _owner = newOwner;
266         emit OwnershipTransferred(_owner, newOwner);
267         
268     }
269 
270     function renounceOwnership() public virtual onlyOwner() {
271         setExcludedFromFees(_owner, false);
272         _owner = address(0);
273         emit OwnershipTransferred(_owner, address(0));
274     }
275     
276 //===============================================================================================================
277 //===============================================================================================================
278 //===============================================================================================================
279 
280     function totalSupply() external view override returns (uint256) { return _tTotal; }
281     function decimals() external pure override returns (uint8) { return _decimals; }
282     function symbol() external view override returns (string memory) { return _symbol; }
283     function name() external view override returns (string memory) { return _name; }
284     function getOwner() external view override returns (address) { return owner(); }
285     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
286 
287     function balanceOf(address account) public view override returns (uint256) {
288         return _tOwned[account];
289     }
290 
291     function transfer(address recipient, uint256 amount) public override returns (bool) {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295 
296     function approve(address spender, uint256 amount) public override returns (bool) {
297         _approve(_msgSender(), spender, amount);
298         return true;
299     }
300 
301     function _approve(address sender, address spender, uint256 amount) private {
302         require(sender != address(0), "ERC20: Zero Address");
303         require(spender != address(0), "ERC20: Zero Address");
304 
305         _allowances[sender][spender] = amount;
306         emit Approval(sender, spender, amount);
307     }
308 
309     function approveMax(address spender) public returns (bool) {
310         return approve(spender, type(uint256).max);
311     }
312 
313     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
314         if (_allowances[sender][msg.sender] != type(uint256).max) {
315             _allowances[sender][msg.sender] -= amount;
316         }
317 
318         return _transfer(sender, recipient, amount);
319     }
320 
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
323         return true;
324     }
325 
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
328         return true;
329     }
330 
331     function setNewRouter(address newRouter) public onlyOwner() {
332         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
333         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
334         if (get_pair == address(0)) {
335             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
336         }
337         else {
338             lpPair = get_pair;
339         }
340         dexRouter = _newRouter;
341     }
342 
343     function setLpPair(address pair, bool enabled) external onlyOwner {
344         if (enabled == false) {
345             lpPairs[pair] = false;
346         } else {
347             if (timeSinceLastPair != 0) {
348                 require(block.timestamp - timeSinceLastPair > 1 weeks, "One week cooldown.");
349             }
350             lpPairs[pair] = true;
351             timeSinceLastPair = block.timestamp;
352         }
353     }
354 
355     function isExcludedFromFees(address account) public view returns(bool) {
356         return _isExcludedFromFees[account];
357     }
358 
359     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
360         _isExcludedFromFees[account] = enabled;
361     }
362 
363 
364     function excludeFromWalletRestrictions(address excludeAddress) public onlyOwner{
365         ExcludedFromWalletRestrictions[excludeAddress] = true;
366     }
367 
368     function revokeExcludedFromWalletRestrictions(address includeAddress) public onlyOwner{
369         ExcludedFromWalletRestrictions[includeAddress] = false;
370     }
371 
372     function isSniper(address account) public view returns (bool) {
373         return _isSniper[account];
374     }
375 
376     function init() external onlyOwner {
377         require (_liqAddStatus == 0, "Error.");
378         _liqAddStatus = 1;
379         snipeBlockAmt = 0;
380     }
381 
382     // function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
383     //     _isSniper[account] = enabled;
384     // }
385 
386     // we are not racists
387 
388     function setRatios(uint _liquidity, uint _TreasuryFee, uint _RevenueFee , uint _tokenFee) external onlyOwner {
389         require ( (_liquidity + _TreasuryFee + _RevenueFee + _tokenFee) == 1000, "!1K"); // to change the ratio, it must require the sum equal 1000
390         Ratios.liquidity = _liquidity;
391         Ratios.TreasuryFee = _TreasuryFee;
392         Ratios.RevenueFee = _RevenueFee;
393         Ratios.tokenFee = _tokenFee;
394 }
395 
396     function setTaxes(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
397         require(_buyFee <= maxFees.maxBuy
398                 && _sellFee <= maxFees.maxSell
399                 && _transferFee <= maxFees.maxTransfer,
400                 "Cannot exceed maximums.");
401          Fees.buyFee = _buyFee;
402          Fees.sellFee = _sellFee;
403          Fees.transferFee = _transferFee;
404     }
405 
406     function setMaxTxPercent(uint percent, uint divisor) external onlyOwner {
407         uint256 check = (_tTotal * percent) / divisor;
408         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
409         _maxTxAmount = check;
410     }
411 
412     function setMaxWalletSize(uint percent, uint divisor) external onlyOwner {
413         uint256 check = (_tTotal * percent) / divisor;
414         require(check >= (_tTotal / 300), "Must be above 0.33~% of total supply.");
415         _maxWalletSize = check;
416 
417     }
418 
419     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
420         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
421         swapAmount = (_tTotal * amountPercent) / amountDivisor;
422     }
423 
424     // function setWallets(address payable treasuryWallet, address payable revenueWallet) external onlyOwner {
425     //     _treasuryWallet = payable(treasuryWallet);
426     //     _revenueWallet = payable(revenueWallet);
427     // }
428     // removed 
429 
430     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
431         swapAndLiquifyEnabled = _enabled;
432         emit SwapAndLiquifyEnabledUpdated(_enabled);
433     }
434 
435     function _hasLimits(address from, address to) private view returns (bool) {
436         return from != owner()
437             && to != owner()
438             && !_liquidityHolders[to]
439             && !_liquidityHolders[from]
440             && to != DEAD
441             && to != address(0)
442             && from != address(this);
443     }
444 
445     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
446         require(from != address(0), "ERC20: Zero address.");
447         require(to != address(0), "ERC20: Zero address.");
448         require(amount > 0, "Must >0.");
449         if(_hasLimits(from, to)) {
450 
451             if(!(ExcludedFromWalletRestrictions[from] || ExcludedFromWalletRestrictions[to])) {
452                 if(lpPairs[from] || lpPairs[to]){
453                 require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
454                 }
455                 if(to != _routerAddress && !lpPairs[to]) {
456                     require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
457                 }
458 
459             }
460             
461         }
462         bool takeFee = true;
463         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
464             takeFee = false;
465         }
466 
467         if (lpPairs[to]) {
468             if (!inSwapAndLiquify
469                 && swapAndLiquifyEnabled
470             ) {
471                 uint256 contractTokenBalance = balanceOf(address(this));
472                 if (contractTokenBalance >= swapThreshold) {
473                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
474                     swapAndLiquify(contractTokenBalance);
475                 }
476             }      
477         } 
478         return _finalizeTransfer(from, to, amount, takeFee);
479     }
480 
481     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
482         if (Ratios.liquidity + Ratios.TreasuryFee + Ratios.RevenueFee == 0)
483             return;
484         uint256 toLiquify = ((contractTokenBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.TreasuryFee + Ratios.RevenueFee) ) / 2;
485 
486         uint256 toSwapForEth = contractTokenBalance - toLiquify;
487         swapTokensForEth(toSwapForEth);
488 
489         uint256 currentBalance = address(this).balance;
490         uint256 liquidityBalance = ((currentBalance * Ratios.liquidity) / (Ratios.liquidity + Ratios.TreasuryFee + Ratios.RevenueFee) ) / 2;
491 
492         bool success;
493 
494         if (toLiquify > 0) {
495             addLiquidity(toLiquify, liquidityBalance);
496             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
497         }
498         if (contractTokenBalance - toLiquify > 0) {
499             uint ethBal = address(this).balance;
500             uint ethBalForOperations = ((ethBal * Ratios.TreasuryFee) / (Ratios.TreasuryFee + Ratios.RevenueFee));
501 
502             (success,) = address(_treasuryWallet).call{value: ethBalForOperations}("");
503             (success,) = address(_revenueWallet).call{value: address(this).balance}("");
504 
505             // _revenueWallet.transfer(address(this).balance);
506 
507         }
508     }
509 
510     function swapTokensForEth(uint256 tokenAmount) internal {
511         address[] memory path = new address[](2);
512         path[0] = address(this);
513         path[1] = dexRouter.WETH();
514 
515         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
516             tokenAmount,
517             0, // accept any amount of ETH
518             path,
519             address(this),
520             block.timestamp
521         );
522     }
523 
524     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
525         dexRouter.addLiquidityETH{value: ethAmount}(
526             address(this),
527             tokenAmount,
528             0, // slippage is unavoidable
529             0, // slippage is unavoidable
530             _treasuryWallet,
531             block.timestamp
532         );
533     }
534 
535     function _checkLiquidityAdd(address from, address to) private {
536         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
537         if (!_hasLimits(from, to) && to == lpPair) {
538             if (snipeBlockAmt != 0) {
539                 _liqAddBlock = block.number; // removed + 5000
540             } else {
541                 _liqAddBlock = block.number;
542             }
543             _liquidityHolders[from] = true;
544             _hasLiqBeenAdded = true;
545             _liqAddStamp = block.timestamp;
546 
547             swapAndLiquifyEnabled = true;
548             emit SwapAndLiquifyEnabledUpdated(true);
549         }
550     }
551 
552     function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) private returns (bool) {
553         if (sniperProtection){
554             if (isSniper(from) || isSniper(to)) {
555                 revert("Sniper rejected.");
556             }
557 
558             if (!_hasLiqBeenAdded) {
559                 _checkLiquidityAdd(from, to);
560                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
561                     revert("Only owner can transfer at this time.");
562                 }
563             } else {
564                 if (_liqAddBlock > 0 
565                     && lpPairs[from] 
566                     && _hasLimits(from, to)
567                 ) {
568                     if (block.number - _liqAddBlock < snipeBlockAmt) {
569                         _isSniper[to] = true;
570                         snipersCaught ++;
571                         emit SniperCaught(to);
572                     }
573                 }
574             }
575         }
576 
577         _tOwned[from] -= amount;
578         uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount; //A
579         _tOwned[to] += amountReceived;
580 
581         emit Transfer(from, to, amountReceived);
582         return true;
583     }
584 
585     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
586         uint256 currentFee;
587 
588         if (to == lpPair) {currentFee = Fees.sellFee;}
589 
590         else if (from == lpPair) {currentFee = Fees.buyFee;} 
591 
592         else {currentFee = Fees.transferFee;}
593 
594         if (_hasLimits(from, to)){
595             if (_liqAddStatus == 0 || _liqAddStatus != (1)) {
596                 revert();
597             }
598         }
599         uint256 tokenFeeAmt = (amount * currentFee * Ratios.tokenFee) / (Ratios.tokenFee + Ratios.liquidity + Ratios.TreasuryFee + Ratios.RevenueFee ) / masterTaxDivisor;
600         uint256 feeAmount = (amount * currentFee / masterTaxDivisor) - tokenFeeAmt;
601         _tOwned[_treasuryWallet] += tokenFeeAmt;
602         _tOwned[address(this)] += (feeAmount);
603         emit Transfer(from, _treasuryWallet, tokenFeeAmt);
604         emit Transfer(from, address(this), feeAmount);
605         return amount - feeAmount - tokenFeeAmt;
606     }
607 }