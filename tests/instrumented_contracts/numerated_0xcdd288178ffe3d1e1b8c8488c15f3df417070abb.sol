1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.7;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 interface ERC20 {
42     function totalSupply() external view returns (uint256);
43     function decimals() external view returns (uint8);
44     function symbol() external view returns (string memory);
45     function name() external view returns (string memory);
46     function getOwner() external view returns (address);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address _owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 abstract contract Auth {
57     address internal owner;
58     mapping (address => bool) internal authorizations;
59 
60     constructor(address _owner) {
61         owner = _owner;
62         authorizations[_owner] = true;
63     }
64 
65     modifier onlyOwner() {
66         require(isOwner(msg.sender), "!OWNER"); _;
67     }
68 
69     modifier authorized() {
70         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
71     }
72 
73     function authorize(address adr) public onlyOwner {
74         authorizations[adr] = true;
75     }
76 
77     function unauthorize(address adr) public onlyOwner {
78         authorizations[adr] = false;
79     }
80 
81     function isOwner(address account) public view returns (bool) {
82         return account == owner;
83     }
84 
85     function isAuthorized(address adr) public view returns (bool) {
86         return authorizations[adr];
87     }
88 
89     function transferOwnership(address payable adr) public onlyOwner {
90         owner = adr;
91         authorizations[adr] = true;
92         emit OwnershipTransferred(adr);
93     }
94 
95     event OwnershipTransferred(address owner);
96 }
97 
98 interface IDEXFactory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IDEXRouter {
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105 
106     function addLiquidity(
107         address tokenA,
108         address tokenB,
109         uint amountADesired,
110         uint amountBDesired,
111         uint amountAMin,
112         uint amountBMin,
113         address to,
114         uint deadline
115     ) external returns (uint amountA, uint amountB, uint liquidity);
116 
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 
126     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133 
134     function swapExactETHForTokensSupportingFeeOnTransferTokens(
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external payable;
140 
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 }
149 
150 interface InterfaceLP {
151     function sync() external;
152 }
153 
154 contract CULTIVATOR is ERC20, Auth {
155     using SafeMath for uint256;
156 
157     //events
158 
159     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
160     event SetMaxWalletExempt(address _address, bool _bool);
161     event SellFeesChanged(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee);
162     event BuyFeesChanged(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee);
163     event TransferFeeChanged(uint256 _transferFee);
164     event SetFeeReceivers(address _liquidityReceiver, address _marketingReceiver, address _devFeeReceiver, address _stakingFeeReceiver);
165     event ChangedSwapBack(bool _enabled, uint256 _amount);
166     event SetFeeExempt(address _addr, bool _value);
167     event InitialDistributionFinished(bool _value);
168     event Fupdated(uint256 _timeF);
169     event ChangedMaxWallet(uint256 _maxWalletDenom);
170     event ChangedMaxTX(uint256 _maxSellDenom);
171     event BlacklistUpdated(address[] addresses, bool status);
172     event SingleBlacklistUpdated(address _address, bool status);
173     event SetTxLimitExempt(address holder, bool exempt);
174     event ChangedPrivateRestrictions(uint256 _maxSellAmount, bool _restricted, uint256 _interval);
175     event ChangeMaxPrivateSell(uint256 amount);
176     event ManagePrivate(address[] addresses, bool status);
177 
178     address private WETH;
179     address private DEAD = 0x000000000000000000000000000000000000dEaD;
180     address private ZERO = 0x0000000000000000000000000000000000000000;
181 
182     string constant private _name = "CULTIVATOR";
183     string constant private _symbol = "CLTVTR";
184     uint8 constant private _decimals = 18;
185 
186     uint256 private _totalSupply = 1000000000* 10**_decimals;
187 
188     uint256 public _maxTxAmount = _totalSupply * 15 / 1000;
189     uint256 public _maxWalletAmount = _totalSupply / 50;
190 
191     mapping (address => uint256) private _balances;
192     mapping (address => mapping (address => uint256)) private _allowances;
193 
194     address[] public _markerPairs;
195     mapping (address => bool) public automatedMarketMakerPairs;
196 
197 
198     mapping (address => bool) public isBlacklisted;
199 
200     mapping (address => bool) public isFeeExempt;
201     mapping (address => bool) public isTxLimitExempt;
202     mapping (address => bool) public isMaxWalletExempt;
203 
204     //Snipers
205     uint256 private deadblocks = 1;
206     uint256 public launchBlock;
207     uint256 private latestSniperBlock;
208 
209     //privateSale
210     bool public privateSaleLimitsEnabled = true;
211     mapping (address => bool) private privateSaleHolders;
212     uint256 public _maxPvtSellAmount;
213 
214     uint256 public cooldownTimerIntervalPrivate = 24 hours;
215     mapping (address => uint) public cooldownTimerPrivate;
216 
217 
218     //buyFees
219     uint256 private liquidityFee = 2;
220     uint256 private marketingFee = 4;
221     uint256 private devFee = 4;
222     uint256 private stakingFee = 2;
223 
224     //sellFees
225     uint256 private sellFeeLiquidity = 2;
226     uint256 private sellFeeMarketing = 4;
227     uint256 private sellFeeDev = 4;
228     uint256 private sellFeeStaking = 2;
229 
230     //transfer fee
231     uint256 private transferFee = 0;
232     uint256 public maxFee = 30; 
233 
234     //totalFees
235     uint256 private totalBuyFee = liquidityFee.add(marketingFee).add(devFee).add(stakingFee);
236     uint256 private totalSellFee = sellFeeLiquidity.add(sellFeeMarketing).add(sellFeeDev).add(sellFeeStaking);
237 
238     uint256 private feeDenominator  = 100;
239 
240     address private autoLiquidityReceiver =0xB54Ff952a8a44Be04063e4a7F6eE36bAb8C1a2DD;
241     address private marketingFeeReceiver =0xB54Ff952a8a44Be04063e4a7F6eE36bAb8C1a2DD;
242     address private devFeeReceiver =0x6c0D87bba3290F1AE1D9F4B7CD75Fb4af855930f;
243     address private stakingFeeReceiver =0x88bB71e6A1127d2b1dc167b77a2a66cC204C2fFf;
244 
245 
246     IDEXRouter public router;
247     address public pair;
248 
249     bool public tradingEnabled = false;
250     bool public swapEnabled = true;
251     uint256 public swapThreshold = _totalSupply * 1 / 5000;
252 
253     bool private inSwap;
254     modifier swapping() { inSwap = true; _; inSwap = false; }
255 
256     constructor () Auth(msg.sender) {
257         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
258         WETH = router.WETH();
259         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
260 
261         setAutomatedMarketMakerPair(pair, true);
262 
263         _allowances[address(this)][address(router)] = type(uint256).max;
264 
265         isFeeExempt[msg.sender] = true;
266         isTxLimitExempt[msg.sender] = true;
267         isMaxWalletExempt[msg.sender] = true;
268         
269         isFeeExempt[address(this)] = true; 
270         isTxLimitExempt[address(this)] = true;
271         isMaxWalletExempt[address(this)] = true;
272 
273         isMaxWalletExempt[pair] = true;
274 
275 
276         _balances[msg.sender] = _totalSupply;
277         emit Transfer(address(0), msg.sender, _totalSupply);
278     }
279 
280     receive() external payable { }
281 
282     function totalSupply() external view override returns (uint256) { return _totalSupply; }
283     function decimals() external pure override returns (uint8) { return _decimals; }
284     function symbol() external pure override returns (string memory) { return _symbol; }
285     function name() external pure override returns (string memory) { return _name; }
286     function getOwner() external view override returns (address) { return owner; }
287     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
288     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
289 
290     function approve(address spender, uint256 amount) public override returns (bool) {
291         _allowances[msg.sender][spender] = amount;
292         emit Approval(msg.sender, spender, amount);
293         return true;
294     }
295 
296     function approveMax(address spender) external returns (bool) {
297         return approve(spender, type(uint256).max);
298     }
299 
300     function transfer(address recipient, uint256 amount) external override returns (bool) {
301         return _transferFrom(msg.sender, recipient, amount);
302     }
303 
304     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
305         if(_allowances[sender][msg.sender] != type(uint256).max){
306             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
307         }
308 
309         return _transferFrom(sender, recipient, amount);
310     }
311 
312     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
313         require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
314         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
315 
316         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){
317             require(tradingEnabled,"Trading not open yet");
318         }
319 
320         if(shouldSwapBack()){ swapBack(); }
321 
322 
323         uint256 amountReceived = amount; 
324 
325         if(automatedMarketMakerPairs[sender]) { //buy
326             if(!isFeeExempt[recipient]) {
327                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
328                 require(amount <= _maxTxAmount || isTxLimitExempt[recipient], "TX Limit Exceeded");
329                 amountReceived = takeBuyFee(sender, recipient, amount);
330             }
331 
332         } else if(automatedMarketMakerPairs[recipient]) { //sell
333             if(!isFeeExempt[sender]) {
334                 require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
335                 amountReceived = takeSellFee(sender, amount);
336 
337                 if (privateSaleHolders[sender]  && privateSaleLimitsEnabled) {
338                 require(cooldownTimerPrivate[sender] < block.timestamp,"Pvt sale time restricted");
339                 require(amount <= _maxPvtSellAmount,"Pvt sale have max sell restriction");
340                 cooldownTimerPrivate[sender] = block.timestamp + cooldownTimerIntervalPrivate;
341                 }
342             }
343         } else {	
344             if (!isFeeExempt[sender]) {	
345                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
346                 require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
347                 amountReceived = takeTransferFee(sender, amount);
348 
349                 if (privateSaleHolders[sender]  && privateSaleLimitsEnabled) {
350                 require(cooldownTimerPrivate[sender] < block.timestamp,"Pvt sale time restricted");
351                 require(amount <= _maxPvtSellAmount,"Pvt sale have max sell restriction");
352                 cooldownTimerPrivate[sender] = block.timestamp + cooldownTimerIntervalPrivate;
353                 }
354             }
355         }
356 
357         _balances[sender] = _balances[sender].sub(amount);
358         _balances[recipient] = _balances[recipient].add(amountReceived);
359         
360 
361         emit Transfer(sender, recipient, amountReceived);
362         return true;
363     }
364     
365     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
366         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
367         _balances[recipient] = _balances[recipient].add(amount);
368         emit Transfer(sender, recipient, amount);
369         return true;
370     }
371 
372     // Fees
373     function takeBuyFee(address sender, address recipient, uint256 amount) internal returns (uint256){
374              
375         if (block.number < latestSniperBlock) {
376             if (recipient != pair && recipient != address(router)) {
377                 isBlacklisted[recipient] = true;
378             }
379             }
380         
381         uint256 feeAmount = amount.mul(totalBuyFee.sub(stakingFee)).div(feeDenominator);
382         uint256 stakingFeeAmount = amount.mul(stakingFee).div(feeDenominator);
383         uint256 totalFeeAmount = feeAmount.add(stakingFeeAmount);
384 
385         _balances[address(this)] = _balances[address(this)].add(feeAmount);
386         emit Transfer(sender, address(this), feeAmount);
387 
388         if(stakingFeeAmount > 0) {
389             _balances[stakingFeeReceiver] = _balances[stakingFeeReceiver].add(stakingFeeAmount);
390             emit Transfer(sender, stakingFeeReceiver, stakingFeeAmount);
391         }
392 
393         return amount.sub(totalFeeAmount);
394     }
395 
396     function takeSellFee(address sender, uint256 amount) internal returns (uint256){
397 
398         uint256 feeAmount = amount.mul(totalSellFee.sub(sellFeeStaking)).div(feeDenominator);
399         uint256 stakingFeeAmount = amount.mul(sellFeeStaking).div(feeDenominator);
400         uint256 totalFeeAmount = feeAmount.add(stakingFeeAmount);
401 
402         _balances[address(this)] = _balances[address(this)].add(feeAmount);
403         emit Transfer(sender, address(this), feeAmount);
404 
405         if(stakingFeeAmount > 0) {
406             _balances[stakingFeeReceiver] = _balances[stakingFeeReceiver].add(stakingFeeAmount);
407             emit Transfer(sender, stakingFeeReceiver, stakingFeeAmount);
408         }
409 
410         return amount.sub(totalFeeAmount);
411             
412     }
413 
414     function takeTransferFee(address sender, uint256 amount) internal returns (uint256){
415         uint256 _realFee = transferFee;
416         if (block.number < latestSniperBlock) {
417             _realFee = 99; 
418             }
419         uint256 feeAmount = amount.mul(_realFee).div(feeDenominator);
420           
421             
422         if (feeAmount > 0) {
423             _balances[address(this)] = _balances[address(this)].add(feeAmount);	
424             emit Transfer(sender, address(this), feeAmount); 
425         }
426             	
427         return amount.sub(feeAmount);	
428     }    
429 
430     function shouldSwapBack() internal view returns (bool) {
431         return
432         !automatedMarketMakerPairs[msg.sender]
433         && !inSwap
434         && swapEnabled
435         && _balances[address(this)] >= swapThreshold;
436     }
437 
438     function clearStuckBalance() external authorized {
439         payable(msg.sender).transfer(address(this).balance);
440     }
441 
442     function rescueERC20(address tokenAddress, uint256 amount) external authorized returns (bool) {
443         return ERC20(tokenAddress).transfer(msg.sender, amount);
444     }
445 
446     // switch Trading
447     function tradingStatus(bool _status) external authorized {
448 	require(tradingEnabled == false, "Can't stop trading");
449         tradingEnabled = _status;
450         launchBlock = block.number;
451         latestSniperBlock = block.number.add(deadblocks);
452 
453         emit InitialDistributionFinished(_status);
454     }
455 
456     function swapBack() internal swapping {
457         uint256 swapLiquidityFee = liquidityFee.add(sellFeeLiquidity);
458         uint256 realTotalFee =totalBuyFee.add(totalSellFee).sub(stakingFee).sub(sellFeeStaking);
459 
460         uint256 contractTokenBalance = _balances[address(this)];
461         uint256 amountToLiquify = contractTokenBalance.mul(swapLiquidityFee).div(realTotalFee).div(2);
462         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
463 
464         uint256 balanceBefore = address(this).balance;
465 
466         address[] memory path = new address[](2);
467         path[0] = address(this);
468         path[1] = WETH;
469 
470         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
471             amountToSwap,
472             0,
473             path,
474             address(this),
475             block.timestamp
476         );
477 
478         uint256 amountETH = address(this).balance.sub(balanceBefore);
479 
480         uint256 totalETHFee = realTotalFee.sub(swapLiquidityFee.div(2));
481         
482         uint256 amountETHLiquidity = amountETH.mul(liquidityFee.add(sellFeeLiquidity)).div(totalETHFee).div(2);
483         uint256 amountETHMarketing = amountETH.mul(marketingFee.add(sellFeeMarketing)).div(totalETHFee);
484         uint256 amountETHDev = amountETH.mul(devFee.add(sellFeeDev)).div(totalETHFee);
485 
486         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
487         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHDev}("");
488         
489         tmpSuccess = false;
490 
491         if(amountToLiquify > 0){
492             router.addLiquidityETH{value: amountETHLiquidity}(
493                 address(this),
494                 amountToLiquify,
495                 0,
496                 0,
497                 autoLiquidityReceiver,
498                 block.timestamp
499             );
500         }
501 
502 
503     
504     }
505 
506     // Admin Functions
507 
508     function setTxLimit(uint256 amount) external authorized {
509         require(amount > _totalSupply.div(10000), "Can't restrict trading");
510         _maxTxAmount = amount;
511 
512         emit ChangedMaxTX(amount);
513     }
514 
515     function setMaxWallet(uint256 amount) external authorized {
516         require(amount > _totalSupply.div(10000), "Can't restrict trading");
517         _maxWalletAmount = amount;
518 
519         emit ChangedMaxWallet(amount);
520     }
521 
522     function manage_blacklist(address[] calldata addresses, bool status) external authorized {
523         require (addresses.length < 200, "Can't update too many wallets at once");
524         for (uint256 i; i < addresses.length; ++i) {
525             isBlacklisted[addresses[i]] = status;
526         }
527 
528         emit BlacklistUpdated(addresses, status);
529     }
530 
531     function setBL(address _address, bool _bool) external authorized {
532         isBlacklisted[_address] = _bool;
533         
534         emit SingleBlacklistUpdated(_address, _bool);
535     }
536 
537     function updateF (uint256 _number) external authorized {
538         require(_number < 50, "Can't go that high");
539         deadblocks = _number;
540         
541         emit Fupdated(_number);
542     }
543 
544     function setIsFeeExempt(address holder, bool exempt) external authorized {
545         isFeeExempt[holder] = exempt;
546 
547         emit SetFeeExempt(holder, exempt);
548     }
549 
550     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
551         isTxLimitExempt[holder] = exempt;
552 
553         emit SetTxLimitExempt(holder, exempt);
554     }
555 
556     function setIsMaxWalletExempt(address holder, bool exempt) external authorized {
557         isMaxWalletExempt[holder] = exempt;
558 
559         emit SetMaxWalletExempt(holder, exempt);
560     }
561 
562     function setBuyFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee, uint256 _feeDenominator) external authorized {
563         liquidityFee = _liquidityFee;
564         marketingFee = _marketingFee;
565         devFee = _devFee;
566         stakingFee = _stakingFee; 
567         totalBuyFee = _liquidityFee.add(_marketingFee).add(_devFee).add(stakingFee);
568         feeDenominator = _feeDenominator;
569         require(totalBuyFee <= maxFee, "Fees cannot be higher than 30%");
570 
571         emit BuyFeesChanged(_liquidityFee, _marketingFee, _devFee, _stakingFee);
572     }
573 
574     function setSellFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee, uint256 _feeDenominator) external authorized {
575         sellFeeLiquidity = _liquidityFee;
576         sellFeeMarketing = _marketingFee;
577         sellFeeDev = _devFee;
578         sellFeeStaking = _stakingFee;
579         totalSellFee = _liquidityFee.add(_marketingFee).add(_devFee).add(_stakingFee);
580         feeDenominator = _feeDenominator;
581         require(totalSellFee <= maxFee, "Fees cannot be higher than 30%");
582 
583         emit SellFeesChanged(_liquidityFee, _marketingFee, _devFee, _stakingFee);
584     }
585 
586     function setTransferFee(uint256 _transferFee) external authorized {
587         require(_transferFee < maxFee, "Fees cannot be higher than 30%");
588         transferFee = _transferFee;
589 
590         emit TransferFeeChanged(_transferFee);
591     }
592 
593 
594     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _stakingFeeReceiver) external authorized {
595         require(_autoLiquidityReceiver != address(0) && _marketingFeeReceiver != address(0) && _devFeeReceiver != address(0) && _stakingFeeReceiver != address(0), "Zero Address validation" );
596         autoLiquidityReceiver = _autoLiquidityReceiver;
597         marketingFeeReceiver = _marketingFeeReceiver;
598         devFeeReceiver = _devFeeReceiver;
599         stakingFeeReceiver = _stakingFeeReceiver; 
600 
601         emit SetFeeReceivers(_autoLiquidityReceiver, _marketingFeeReceiver, _devFeeReceiver, _stakingFeeReceiver);
602     }
603 
604     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
605         swapEnabled = _enabled;
606         swapThreshold = _amount;
607 
608         emit ChangedSwapBack(_enabled, _amount);
609     }
610 
611     function setAutomatedMarketMakerPair(address _pair, bool _value) public authorized {
612             require(automatedMarketMakerPairs[_pair] != _value, "Value already set");
613 
614             automatedMarketMakerPairs[_pair] = _value;
615 
616             if(_value){
617                 _markerPairs.push(_pair);
618             }else{
619                 require(_markerPairs.length > 1, "Required 1 pair");
620                 for (uint256 i = 0; i < _markerPairs.length; i++) {
621                     if (_markerPairs[i] == _pair) {
622                         _markerPairs[i] = _markerPairs[_markerPairs.length - 1];
623                         _markerPairs.pop();
624                         break;
625                     }
626                 }
627             }
628 
629             emit SetAutomatedMarketMakerPair(_pair, _value);
630         }
631 
632     function setPvtSaleRestrictions(uint256 _maxSellAmount, bool _restricted, uint256 _interval) external authorized {
633         require(_maxSellAmount > 0, "Can't restrict trading");
634         _maxPvtSellAmount = _maxSellAmount;
635         privateSaleLimitsEnabled = _restricted;
636         cooldownTimerIntervalPrivate = _interval;
637 
638         emit ChangedPrivateRestrictions(_maxSellAmount, _restricted, _interval);
639     }
640 
641     function manage_pvtseller(address[] calldata addresses, bool status) external authorized {
642         require (addresses.length < 200, "Can't update too many wallets at once");
643         for (uint256 i; i < addresses.length; ++i) {
644             privateSaleHolders[addresses[i]] = status;
645         }
646 
647         emit ManagePrivate(addresses, status);
648         
649     }
650 
651     function setPvtSaleRestrictions_maxsell(uint256 amount) external authorized {
652         require(amount > 0, "Can't restrict trading");
653         _maxPvtSellAmount = amount;
654 
655         emit ChangeMaxPrivateSell(amount);
656     }
657 
658     function manualSwapback() external authorized {
659         swapBack();
660     }
661     
662     function getCirculatingSupply() public view returns (uint256) {
663         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
664     }
665 
666 }