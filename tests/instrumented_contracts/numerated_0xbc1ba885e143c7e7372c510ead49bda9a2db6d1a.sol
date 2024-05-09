1 /*
2 
3 $SHIAR - SHIA Reflections
4 Reflecting on the epic success of Shiba Saga, SHIAR is the mirrored version of SHIA, rewarding holders with juicy reflections. 
5 
6 4% TAX, 3% automatic $SHIA reflections to all $SHIAR holders, 1% marketing.
7 
8 https://t.me/shiareflections
9 
10 */
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 pragma solidity 0.8.13;
15 
16 /**
17  * Standard SafeMath, stripped down to just add/sub/mul/div
18  */
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0, errorMessage);
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54         return c;
55     }
56 }
57 
58 /**
59  * ERC20 standard interface.
60  */
61 interface IERC20 {
62     function totalSupply() external view returns (uint256);
63     function decimals() external view returns (uint8);
64     function symbol() external view returns (string memory);
65     function name() external view returns (string memory);
66     function getOwner() external view returns (address);
67     function balanceOf(address account) external view returns (uint256);
68     function transfer(address recipient, uint256 amount) external returns (bool);
69     function allowance(address _owner, address spender) external view returns (uint256);
70     function approve(address spender, uint256 amount) external returns (bool);
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76  
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81  
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89  
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 }
118 
119 
120 interface IDEXFactory {
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IDEXRouter {
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127 
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
138 
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 
148     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155 
156     function swapExactETHForTokensSupportingFeeOnTransferTokens(
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external payable;
162 
163     function swapExactTokensForETHSupportingFeeOnTransferTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external;
170 }
171 
172 interface IShiaReflections {
173     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
174     function setShare(address shareholder, uint256 amount) external;
175     function deposit() external payable;
176     function process(uint256 gas) external;
177     function gibTokens(address shareholder) external;
178 }
179 
180 
181 contract ShiaReflections is IShiaReflections {
182 
183     using SafeMath for uint256;
184     address _token;
185 
186     address public SHIA;
187 
188     IDEXRouter router;
189 
190     struct Share {
191         uint256 amount;
192         uint256 totalExcluded;
193         uint256 totalRealised;
194     }
195 
196     address[] shareholders;
197     mapping (address => uint256) shareholderIndexes;
198     mapping (address => uint256) shareholderClaims;
199     mapping (address => Share) public shares;
200 
201     uint256 public totalShares;
202     uint256 public totalDividends;
203     uint256 public totalDistributed;
204     uint256 public dividendsPerShare;
205     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
206 
207     uint256 public minPeriod = 30 minutes;
208     uint256 public minDistribution = 0 * (10 ** 9);
209 
210     uint256 public currentIndex;
211     bool initialized;
212 
213     modifier initialization() {
214         require(!initialized);
215         _;
216         initialized = true;
217     }
218 
219     modifier onlyToken() {
220         require(msg.sender == _token); _;
221     }
222 
223     constructor () {
224         _token = msg.sender;
225         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         SHIA = 0x43D7E65B8fF49698D9550a7F315c87E67344FB59;
227     }
228     
229     receive() external payable {
230         deposit();
231     }
232 
233     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
234         minPeriod = newMinPeriod;
235         minDistribution = newMinDistribution;
236     }
237 
238     function setShare(address shareholder, uint256 amount) external override onlyToken {
239 
240         if(shares[shareholder].amount > 0){
241             distributeDividend(shareholder);
242         }
243 
244         if(amount > 0 && shares[shareholder].amount == 0){
245             addShareholder(shareholder);
246         }else if(amount == 0 && shares[shareholder].amount > 0){
247             removeShareholder(shareholder);
248         }
249 
250         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
251         shares[shareholder].amount = amount;
252         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
253     }
254 
255     function deposit() public payable override {
256 
257         uint256 balanceBefore = IERC20(SHIA).balanceOf(address(this));
258 
259         address[] memory path = new address[](2);
260         path[0] = router.WETH();
261         path[1] = address(SHIA);
262 
263         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
269 
270         uint256 amount = IERC20(SHIA).balanceOf(address(this)).sub(balanceBefore);
271         totalDividends = totalDividends.add(amount);
272         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
273     }
274     
275     function process(uint256 gas) external override {
276         uint256 shareholderCount = shareholders.length;
277 
278         if(shareholderCount == 0) { return; }
279 
280         uint256 iterations = 0;
281         uint256 gasUsed = 0;
282         uint256 gasLeft = gasleft();
283 
284         while(gasUsed < gas && iterations < shareholderCount) {
285 
286             if(currentIndex >= shareholderCount){ currentIndex = 0; }
287 
288             if(shouldDistribute(shareholders[currentIndex])){
289                 distributeDividend(shareholders[currentIndex]);
290             }
291 
292             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
293             gasLeft = gasleft();
294             currentIndex++;
295             iterations++;
296         }
297     }
298     
299     function shouldDistribute(address shareholder) public view returns (bool) {
300         return shareholderClaims[shareholder] + minPeriod < block.timestamp
301                 && getUnpaidEarnings(shareholder) > minDistribution;
302     }
303 
304     function distributeDividend(address shareholder) internal {
305         if(shares[shareholder].amount == 0){ return; }
306 
307         uint256 amount = getUnpaidEarnings(shareholder);
308         if(amount > 0){
309             totalDistributed = totalDistributed.add(amount);
310             IERC20(SHIA).transfer(shareholder, amount);
311             shareholderClaims[shareholder] = block.timestamp;
312             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
313             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
314         }
315     }
316     
317     function gibTokens(address shareholder) external override onlyToken {
318         distributeDividend(shareholder);
319     }
320 
321     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
322         if(shares[shareholder].amount == 0){ return 0; }
323 
324         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
325         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
326 
327         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
328 
329         return shareholderTotalDividends.sub(shareholderTotalExcluded);
330     }
331 
332     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
333         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
334     }
335 
336     function addShareholder(address shareholder) internal {
337         shareholderIndexes[shareholder] = shareholders.length;
338         shareholders.push(shareholder);
339     }
340 
341     function removeShareholder(address shareholder) internal {
342         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
343         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
344         shareholders.pop();
345     }
346 }
347 
348 contract shiar is Context, IERC20, Ownable {
349     using SafeMath for uint256;
350 
351     address public SHIA = 0x43D7E65B8fF49698D9550a7F315c87E67344FB59; //SHIA CA
352 
353     string private constant _name = "Shia Reflections";
354     string private constant _symbol = "SHIAR";
355     uint8 private constant _decimals = 18;
356     
357     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
358 
359     mapping(address => uint256) private _balances;
360     mapping(address => mapping(address => uint256)) private _allowances;
361     mapping (address => uint256) private cooldown;
362 
363     address private WETH;
364     address DEAD = 0x000000000000000000000000000000000000dEaD;
365     address ZERO = 0x0000000000000000000000000000000000000000;
366 
367     bool public antiBot = true;
368 
369     mapping (address => bool) private bots; 
370     mapping (address => bool) public isFeeExempt;
371     mapping (address => bool) public isTxLimitExempt;
372     mapping (address => bool) public isDividendExempt;
373 
374     uint256 public launchedAt;
375     address public lpWallet = DEAD;
376 
377     uint256 public buyFee = 90;
378     uint256 public sellFee = 90;
379 
380     uint256 public toReflections = 50;
381     uint256 public toLiquidity = 0;
382     uint256 public toMarketing = 50;
383 
384     uint256 public allocationSum = 100;
385 
386     IDEXRouter public router;
387     address public pair;
388     address public factory;
389     address private tokenOwner;
390     address public devWallet = payable(0xa5d4d9A5b4b3de255aDAb44D88C2D9139cAd2794);
391 
392     bool inSwapAndLiquify;
393     bool public swapAndLiquifyEnabled = true;
394     bool public tradingOpen = false;
395     
396     ShiaReflections public shiaReflections;
397     uint256 public shiaReflectionsGas = 0;
398 
399     modifier lockTheSwap {
400         inSwapAndLiquify = true;
401         _;
402         inSwapAndLiquify = false;
403     }
404 
405     uint256 public maxTx = _totalSupply.div(100);
406     uint256 public maxWallet = _totalSupply.div(50);
407     uint256 public swapThreshold = _totalSupply.div(400);
408 
409     constructor () {
410         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
411             
412         WETH = router.WETH();
413         
414         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
415         
416         _allowances[address(this)][address(router)] = type(uint256).max;
417 
418         shiaReflections = new ShiaReflections();
419         
420         isFeeExempt[owner()] = true;
421         isFeeExempt[devWallet] = true;            
422 
423         isDividendExempt[pair] = true;
424         isDividendExempt[address(this)] = true;
425         isDividendExempt[DEAD] = true;    
426 
427         isTxLimitExempt[owner()] = true;
428         isTxLimitExempt[pair] = true;
429         isTxLimitExempt[DEAD] = true;
430         isTxLimitExempt[devWallet] = true;  
431 
432 
433         _balances[owner()] = _totalSupply;
434     
435         emit Transfer(address(0), owner(), _totalSupply);
436     }
437 
438     receive() external payable { }
439 
440 
441     function setBots(address[] memory bots_) external onlyOwner {
442         for (uint i = 0; i < bots_.length; i++) {
443             bots[bots_[i]] = true;
444         }
445     }
446     
447     //once enabled, cannot be reversed
448     function openTrading() external onlyOwner {
449         launchedAt = block.number;
450         tradingOpen = true;
451     }      
452 
453     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
454 
455         buyFee = newBuyFee;
456         sellFee = newSellFee;
457     } 
458     
459     function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
460         toReflections = newRewardFee;
461         toLiquidity = newLpFee;
462         toMarketing = newMarketingFee;
463     }
464 
465     function changeTxLimit(uint256 newLimit) external onlyOwner {
466         maxTx = newLimit;
467     }
468 
469     function changeWalletLimit(uint256 newLimit) external onlyOwner {
470         maxWallet  = newLimit;
471     }
472     
473     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
474         isFeeExempt[holder] = exempt;
475     }
476 
477     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
478         isTxLimitExempt[holder] = exempt;
479     }
480 
481     function setDevWallet(address payable newDevWallet) external onlyOwner {
482         devWallet = payable(newDevWallet);
483     }
484 
485     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
486         tokenOwner = newOwnerWallet;
487     }     
488 
489     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
490         swapAndLiquifyEnabled  = enableSwapBack;
491         swapThreshold = newSwapBackLimit;
492     }
493 
494     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
495         shiaReflections.setDistributionCriteria(newMinPeriod, newMinDistribution);        
496     }
497 
498     function delBot(address notbot) external onlyOwner {
499         bots[notbot] = false;
500     }
501 
502     function _setIsDividendExempt(address holder, bool exempt) internal {
503         require(holder != address(this) && holder != pair);
504         isDividendExempt[holder] = exempt;
505         if(exempt){
506             shiaReflections.setShare(holder, 0);
507         }else{
508             shiaReflections.setShare(holder, _balances[holder]);
509         }
510     }
511 
512     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
513         _setIsDividendExempt(holder, exempt);
514     }
515 
516     function changeShiaReflectionsGas(uint256 newGas) external onlyOwner {
517         shiaReflectionsGas = newGas;
518     }           
519 
520     function getCirculatingSupply() public view returns (uint256) {
521         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
522     }
523 
524     function totalSupply() external view override returns (uint256) { return _totalSupply; }
525     function decimals() external pure override returns (uint8) { return _decimals; }
526     function symbol() external pure override returns (string memory) { return _symbol; }
527     function name() external pure override returns (string memory) { return _name; }
528     function getOwner() external view override returns (address) { return owner(); }
529     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
530     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
531     
532     function approve(address spender, uint256 amount) public override returns (bool) {
533         _allowances[msg.sender][spender] = amount;
534         emit Approval(msg.sender, spender, amount);
535         return true;
536     }
537 
538     function approveMax(address spender) external returns (bool) {
539         return approve(spender, type(uint256).max);
540     }
541 
542     function transfer(address recipient, uint256 amount) external override returns (bool) {
543         return _transfer(msg.sender, recipient, amount);
544     }
545 
546     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
547         if(_allowances[sender][msg.sender] != type(uint256).max){
548             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
549         }
550 
551         return _transfer(sender, recipient, amount);
552     }
553 
554     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
555         if (sender!= owner() && recipient!= owner()) require(tradingOpen, "hold ur horses big guy."); //transfers disabled before tradingActive
556         require(!bots[sender] && !bots[recipient]);
557 
558         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
559 
560         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
561 
562         if(!isTxLimitExempt[recipient] && antiBot)
563         {
564             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
565         }
566 
567         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
568 
569         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
570         
571         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
572         _balances[recipient] = _balances[recipient].add(finalAmount);
573 
574         // Dividend tracker
575         if(!isDividendExempt[sender]) {
576             try shiaReflections.setShare(sender, _balances[sender]) {} catch {}
577         }
578 
579         if(!isDividendExempt[recipient]) {
580             try shiaReflections.setShare(recipient, _balances[recipient]) {} catch {} 
581         }
582 
583         emit Transfer(sender, recipient, finalAmount);
584         return true;
585     }    
586 
587     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
588         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
589         _balances[recipient] = _balances[recipient].add(amount);
590         emit Transfer(sender, recipient, amount);
591         return true;
592     }  
593     
594     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
595         
596         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
597         uint256 feeAmount = amount.mul(feeApplicable).div(100);
598 
599         _balances[address(this)] = _balances[address(this)].add(feeAmount);
600         emit Transfer(sender, address(this), feeAmount);
601 
602         return amount.sub(feeAmount);
603     }
604     
605     function swapTokensForEth(uint256 tokenAmount) private {
606 
607         address[] memory path = new address[](2);
608         path[0] = address(this);
609         path[1] = router.WETH();
610 
611         approve(address(this), tokenAmount);
612 
613         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
614             tokenAmount,
615             0, // accept any amount of ETH
616             path,
617             address(this),
618             block.timestamp
619         );
620     }
621 
622     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
623         router.addLiquidityETH{value: ethAmount}(
624             address(this),
625             tokenAmount,
626             0,
627             0,
628             lpWallet,
629             block.timestamp
630         );
631     }
632 
633     function swapBack() internal lockTheSwap {
634     
635         uint256 tokenBalance = _balances[address(this)]; 
636         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
637         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);
638 
639         swapTokensForEth(amountToSwap);
640 
641         uint256 totalEthBalance = address(this).balance;
642         uint256 ethForSHIA = totalEthBalance.mul(toReflections).div(100);
643         uint256 ethForDev = totalEthBalance.mul(toMarketing).div(100);
644         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
645       
646         if (totalEthBalance > 0){
647             payable(devWallet).transfer(ethForDev);
648         }
649         
650         try shiaReflections.deposit{value: ethForSHIA}() {} catch {}
651         
652         if (tokensForLiquidity > 0){
653             addLiquidity(tokensForLiquidity, ethForLiquidity);
654         }
655     }
656 
657     function manualSwapBack() external onlyOwner {
658         swapBack();
659     }
660 
661     function clearStuckEth() external onlyOwner {
662         uint256 contractETHBalance = address(this).balance;
663         if(contractETHBalance > 0){          
664             payable(devWallet).transfer(contractETHBalance);
665         }
666     }
667 
668     function manualProcessGas(uint256 manualGas) external onlyOwner {
669         shiaReflections.process(manualGas);
670     }
671 
672     function checkPendingReflections(address shareholder) external view returns (uint256) {
673         return shiaReflections.getUnpaidEarnings(shareholder);
674     }
675 
676     function getSHIA() external {
677         shiaReflections.gibTokens(msg.sender);
678     }
679 }