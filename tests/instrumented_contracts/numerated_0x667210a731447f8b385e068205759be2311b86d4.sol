1 // https://etf.live/
2 // https://twitter.com/bet_etf
3 // https://t.me/bet_etf
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity 0.8.21;
8 
9 /**
10  * Standard SafeMath, stripped down to just add/sub/mul/div
11  */
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25 
26         return c;
27     }
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 }
50 
51 /**
52  * ERC20 standard interface.
53  */
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69  
70 abstract contract Context {
71     function _msgSender() internal view virtual returns (address) {
72         return msg.sender;
73     }
74  
75     function _msgData() internal view virtual returns (bytes calldata) {
76         return msg.data;
77     }
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82  
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 
113 interface IDEXFactory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IDEXRouter {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120 
121     function addLiquidity(
122         address tokenA,
123         address tokenB,
124         uint amountADesired,
125         uint amountBDesired,
126         uint amountAMin,
127         uint amountBMin,
128         address to,
129         uint deadline
130     ) external returns (uint amountA, uint amountB, uint liquidity);
131 
132     function addLiquidityETH(
133         address token,
134         uint amountTokenDesired,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
140 
141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 
149     function swapExactETHForTokensSupportingFeeOnTransferTokens(
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external payable;
155 
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163 }
164 
165 interface IETFReflections {
166     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
167     function setShare(address shareholder, uint256 amount) external;
168     function deposit(uint256 newRewards) external;
169     function process(uint256 gas) external;
170     function gibTokens(address shareholder) external;
171 }
172 
173 
174 contract ETFreflections is IETFReflections {
175 
176     using SafeMath for uint256;
177     address _token;
178 
179     address public ETFLP;
180 
181     IDEXRouter router;
182 
183     struct Share {
184         uint256 amount;
185         uint256 totalExcluded;
186         uint256 totalRealised;
187     }
188 
189     address[] shareholders;
190     mapping (address => uint256) shareholderIndexes;
191     mapping (address => uint256) shareholderClaims;
192     mapping (address => Share) public shares;
193 
194     uint256 public totalShares;
195     uint256 public totalDividends;
196     uint256 public totalDistributed;
197     uint256 public dividendsPerShare;
198     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
199 
200     uint256 public minPeriod = 30 minutes;
201     uint256 public minDistribution = 0 * (10 ** 9);
202 
203     uint256 public currentIndex;
204     bool initialized;
205 
206     modifier initialization() {
207         require(!initialized);
208         _;
209         initialized = true;
210     }
211 
212     modifier onlyToken() {
213         require(msg.sender == _token); _;
214     }
215 
216     constructor () {
217         _token = msg.sender;
218         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
219     }
220     
221     receive() external payable {}
222 
223     function _setETFLP(address rewardsAddress) external onlyToken {
224         ETFLP = rewardsAddress;
225     }
226 
227     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
228         minPeriod = newMinPeriod;
229         minDistribution = newMinDistribution;
230     }
231 
232     function setShare(address shareholder, uint256 amount) external override onlyToken {
233 
234         if(shares[shareholder].amount > 0){
235             distributeDividend(shareholder);
236         }
237 
238         if(amount > 0 && shares[shareholder].amount == 0){
239             addShareholder(shareholder);
240         }else if(amount == 0 && shares[shareholder].amount > 0){
241             removeShareholder(shareholder);
242         }
243 
244         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
245         shares[shareholder].amount = amount;
246         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
247     }
248 
249     function deposit(uint256 newRewards) external override onlyToken {
250         totalDividends = totalDividends.add(newRewards);
251         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(newRewards).div(totalShares));
252     }
253     
254     function process(uint256 gas) external override {
255         uint256 shareholderCount = shareholders.length;
256 
257         if(shareholderCount == 0) { return; }
258 
259         uint256 iterations = 0;
260         uint256 gasUsed = 0;
261         uint256 gasLeft = gasleft();
262 
263         while(gasUsed < gas && iterations < shareholderCount) {
264 
265             if(currentIndex >= shareholderCount){ currentIndex = 0; }
266 
267             if(shouldDistribute(shareholders[currentIndex])){
268                 distributeDividend(shareholders[currentIndex]);
269             }
270 
271             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
272             gasLeft = gasleft();
273             currentIndex++;
274             iterations++;
275         }
276     }
277     
278     function shouldDistribute(address shareholder) public view returns (bool) {
279         return shareholderClaims[shareholder] + minPeriod < block.timestamp
280                 && getUnpaidEarnings(shareholder) > minDistribution;
281     }
282 
283     function distributeDividend(address shareholder) internal {
284         if(shares[shareholder].amount == 0){ return; }
285 
286         uint256 amount = getUnpaidEarnings(shareholder);
287         if(amount > 0){
288             totalDistributed = totalDistributed.add(amount);
289             IERC20(ETFLP).transfer(shareholder, amount);
290             shareholderClaims[shareholder] = block.timestamp;
291             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
292             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
293         }
294     }
295     
296     function gibTokens(address shareholder) external override onlyToken {
297         distributeDividend(shareholder);
298     }
299 
300     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
301         if(shares[shareholder].amount == 0){ return 0; }
302 
303         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
304         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
305 
306         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
307 
308         return shareholderTotalDividends.sub(shareholderTotalExcluded);
309     }
310 
311     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
312         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
313     }
314 
315     function addShareholder(address shareholder) internal {
316         shareholderIndexes[shareholder] = shareholders.length;
317         shareholders.push(shareholder);
318     }
319 
320     function removeShareholder(address shareholder) internal {
321         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
322         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
323         shareholders.pop();
324     }
325 }
326 
327 contract BETETF is Context, IERC20, Ownable {
328     using SafeMath for uint256;
329 
330     address public ETFLP;
331 
332     string private constant _name = "ETF The Token";
333     string private constant _symbol = "ETF";
334     uint8 private constant _decimals = 18;
335     
336     uint256 private _totalSupply = 21000000 * (10 ** _decimals);
337 
338     mapping(address => uint256) private _balances;
339     mapping(address => mapping(address => uint256)) private _allowances;
340     mapping (address => uint256) private cooldown;
341 
342     address private WETH;
343     address DEAD = 0x000000000000000000000000000000000000dEaD;
344     address ZERO = 0x0000000000000000000000000000000000000000;
345 
346     bool public antiBot = true;
347 
348     mapping (address => bool) private bots; 
349     mapping (address => bool) public isFeeExempt;
350     mapping (address => bool) public isTxLimitExempt;
351     mapping (address => bool) public isDividendExempt;
352 
353     uint256 public launchedAt;
354     address public lpWallet;
355 
356     uint256 public buyFee = 900;
357     uint256 public sellFee = 990; //tax divisor 1000
358 
359     uint256 public toLpReflections = 50;
360     uint256 public toDev = 50;
361 
362     uint256 public allocationSum = 100;
363 
364     IDEXRouter public router;
365     address public pair;
366     address public factory;
367     address private tokenOwner;
368     address public devWallet = payable(0xD21140A5Ba25520b5487E3761290dA1D95153bB0);
369 
370     bool inSwapAndLiquify;
371     bool public swapAndLiquifyEnabled = true;
372     bool public tradingOpen = false;
373     
374     ETFreflections public etfReflections;
375     uint256 public etfReflectionsGas = 0;
376 
377     modifier lockTheSwap {
378         inSwapAndLiquify = true;
379         _;
380         inSwapAndLiquify = false;
381     }
382 
383     uint256 public maxTx = _totalSupply.div(50);
384     uint256 public maxWallet = _totalSupply.div(50);
385     uint256 public swapThreshold = _totalSupply.div(400);
386 
387     constructor () {
388         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
389             
390         WETH = router.WETH();
391         
392         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
393         
394         _allowances[address(this)][address(router)] = type(uint256).max;
395 
396         etfReflections = new ETFreflections();
397         
398         isFeeExempt[owner()] = true;
399         isFeeExempt[devWallet] = true;            
400 
401         isDividendExempt[pair] = true;
402         isDividendExempt[address(this)] = true;
403         isDividendExempt[DEAD] = true;    
404 
405         isTxLimitExempt[owner()] = true;
406         isTxLimitExempt[pair] = true;
407         isTxLimitExempt[DEAD] = true;
408         isTxLimitExempt[devWallet] = true;  
409 
410 
411         _balances[owner()] = _totalSupply;
412     
413         emit Transfer(address(0), owner(), _totalSupply);
414     }
415 
416     receive() external payable { }
417 
418 
419     function setBots(address[] memory bots_) external onlyOwner {
420         for (uint i = 0; i < bots_.length; i++) {
421             bots[bots_[i]] = true;
422         }
423     }
424 
425     function setETFLP(address rewardsAddress) external onlyOwner {
426         ETFLP = rewardsAddress;
427         etfReflections._setETFLP(rewardsAddress);
428     }
429 
430     function setLPWallet(address lpReceiver) external onlyOwner {
431         lpWallet = lpReceiver;
432     }
433 
434     //once enabled, cannot be reversed
435     function openTrading() external onlyOwner {
436         launchedAt = block.number;
437         tradingOpen = true;
438     }      
439 
440     function changeBuyFees(uint256 newBuyFee) external onlyOwner {
441         require (newBuyFee <= 1000, "must keep fees below 10%");
442         buyFee = newBuyFee;
443     }
444 
445     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
446         require(newBuyFee <= 1000, "must keep fees below 10%"); 
447         require(newSellFee <= 1000, "must keep fees below 10%");
448         buyFee = newBuyFee;
449         sellFee = newSellFee;
450     } 
451     
452     function changeFeeAllocation(uint256 newRewardFee, uint256 newDevFee) external onlyOwner {
453         toLpReflections = newRewardFee;
454         toDev = newDevFee;
455     }
456 
457     function changeTxLimit(uint256 newLimit) external onlyOwner {
458         maxTx = newLimit;
459     }
460 
461     function changeWalletLimit(uint256 newLimit) external onlyOwner {
462         maxWallet  = newLimit;
463     }
464     
465     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
466         isFeeExempt[holder] = exempt;
467     }
468 
469     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
470         isTxLimitExempt[holder] = exempt;
471     }
472 
473     function setDevWallet(address payable newDevWallet) external onlyOwner {
474         devWallet = payable(newDevWallet);
475     }
476 
477     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
478         tokenOwner = newOwnerWallet;
479     }     
480 
481     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
482         swapAndLiquifyEnabled  = enableSwapBack;
483         swapThreshold = newSwapBackLimit;
484     }
485 
486     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
487         etfReflections.setDistributionCriteria(newMinPeriod, newMinDistribution);        
488     }
489 
490     function delBot(address notbot) external onlyOwner {
491         bots[notbot] = false;
492     }
493 
494     function _setIsDividendExempt(address holder, bool exempt) internal {
495         require(holder != address(this) && holder != pair);
496         isDividendExempt[holder] = exempt;
497         if(exempt){
498             etfReflections.setShare(holder, 0);
499         }else{
500             etfReflections.setShare(holder, _balances[holder]);
501         }
502     }
503 
504     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
505         _setIsDividendExempt(holder, exempt);
506     }
507 
508     function changeEtfReflectionsGas(uint256 newGas) external onlyOwner {
509         etfReflectionsGas = newGas;
510     }           
511 
512     function getCirculatingSupply() public view returns (uint256) {
513         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
514     }
515 
516     function totalSupply() external view override returns (uint256) { return _totalSupply; }
517     function decimals() external pure override returns (uint8) { return _decimals; }
518     function symbol() external pure override returns (string memory) { return _symbol; }
519     function name() external pure override returns (string memory) { return _name; }
520     function getOwner() external view override returns (address) { return owner(); }
521     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
522     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
523     
524     function approve(address spender, uint256 amount) public override returns (bool) {
525         _allowances[msg.sender][spender] = amount;
526         emit Approval(msg.sender, spender, amount);
527         return true;
528     }
529 
530     function approveMax(address spender) external returns (bool) {
531         return approve(spender, type(uint256).max);
532     }
533 
534     function transfer(address recipient, uint256 amount) external override returns (bool) {
535         return _transfer(msg.sender, recipient, amount);
536     }
537 
538     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
539         if(_allowances[sender][msg.sender] != type(uint256).max){
540             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
541         }
542 
543         return _transfer(sender, recipient, amount);
544     }
545 
546     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
547         if (sender!= owner() && recipient!= owner()) require(tradingOpen, "pump the breaks."); //transfers disabled before tradingActive
548         require(!bots[sender] && !bots[recipient]);
549 
550         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
551 
552         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
553 
554         if(!isTxLimitExempt[recipient] && antiBot)
555         {
556             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
557         }
558 
559         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
560 
561         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
562         
563         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
564         _balances[recipient] = _balances[recipient].add(finalAmount);
565 
566         // Dividend tracker
567         if(!isDividendExempt[sender]) {
568             try etfReflections.setShare(sender, _balances[sender]) {} catch {}
569         }
570 
571         if(!isDividendExempt[recipient]) {
572             try etfReflections.setShare(recipient, _balances[recipient]) {} catch {} 
573         }
574 
575         emit Transfer(sender, recipient, finalAmount);
576         return true;
577     }    
578 
579     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
580         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
581         _balances[recipient] = _balances[recipient].add(amount);
582         emit Transfer(sender, recipient, amount);
583         return true;
584     }  
585     
586     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
587         
588         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
589         uint256 feeAmount = amount.mul(feeApplicable).div(1000);
590 
591         _balances[address(this)] = _balances[address(this)].add(feeAmount);
592         emit Transfer(sender, address(this), feeAmount);
593 
594         return amount.sub(feeAmount);
595     }
596     
597     function swapTokensForEth(uint256 tokenAmount) private {
598 
599         address[] memory path = new address[](2);
600         path[0] = address(this);
601         path[1] = router.WETH();
602 
603         approve(address(this), tokenAmount);
604 
605         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
606             tokenAmount,
607             0, // accept any amount of ETH
608             path,
609             address(this),
610             block.timestamp
611         );
612     }
613 
614     function addLpRewards(uint256 tokenAmount, uint256 ethAmount) private {
615         router.addLiquidityETH{value: ethAmount}(
616             address(this),
617             tokenAmount,
618             0,
619             0,
620             lpWallet,
621             block.timestamp
622         );
623     }
624 
625     function swapBack() internal lockTheSwap {
626     
627         uint256 tokenBalance = _balances[address(this)]; 
628         uint256 tokensForLpRewards = tokenBalance.mul(toLpReflections).div(100).div(2);     
629         uint256 amountToSwap = tokenBalance.sub(tokensForLpRewards);
630 
631         swapTokensForEth(amountToSwap);
632 
633         uint256 rewardBalanceBefore = IERC20(ETFLP).balanceOf(address(etfReflections));
634         uint256 totalEthBalance = address(this).balance;
635         uint256 ethForLpRewards = totalEthBalance.mul(toLpReflections).div(100).div(2);
636 
637         if (tokensForLpRewards > 0){
638             addLpRewards(tokensForLpRewards, ethForLpRewards);
639         }
640 
641         uint256 newRewards = IERC20(ETFLP).balanceOf(address(etfReflections)).sub(rewardBalanceBefore);
642         
643         etfReflections.deposit(newRewards);
644       
645         if (totalEthBalance > 0){
646             payable(devWallet).transfer(address(this).balance);
647         }
648     }
649 
650     function manualSwapBack() external onlyOwner {
651         swapBack();
652     }
653 
654     function clearStuckEth() external onlyOwner {
655         uint256 contractETHBalance = address(this).balance;
656         if(contractETHBalance > 0){          
657             payable(devWallet).transfer(contractETHBalance);
658         }
659     }
660 
661     function manualDeposit() external {
662         uint256 newRewards = IERC20(ETFLP).balanceOf(address(this));
663         etfReflections.deposit(newRewards);
664     }
665 
666     function manualProcessGas(uint256 manualGas) external onlyOwner {
667         etfReflections.process(manualGas);
668     }
669 
670     function checkPendingReflections(address shareholder) external view returns (uint256) {
671         return etfReflections.getUnpaidEarnings(shareholder);
672     }
673 
674     function getRewards() external {
675         etfReflections.gibTokens(msg.sender);
676     }
677 }