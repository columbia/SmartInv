1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 /*                                     
6                                                                                                                  ,&@@@(                  
7                                                                                                            %@@@@%                           
8      .@@@@@@@@@@@@@@@@@(          @@.           @@@         @@@   #@@@         %@     *@@@@@@         %@@@@@                                  
9      @@@@           @@@@          @@@@          @@@@@@/    @@@@   #@@@     @@@@&          %@@@@ .@@@@@@                                       
10      @@@@ .@@@@@@@@@@@@@            @@@@        @@@( @@@@@ @@@@   #@@@@@@@@*                @@@@@@& /                                         
11      @@@@           @@@@    @@@@@@@@@@@@@@      @@@/    &@@@@@@   %@@@    @@@@@@.       *@@@@@@   @@@@@@*                                     
12      @@@@@@@@@@@@@@@@@@                .@@@@    @@@*        @@@   %@@@          @@   *@@@@@@          @@@@@@.
13 
14 
15 bankofx.xyz
16 */
17                                 
18 
19 /**
20  * Standard SafeMath, stripped down to just add/sub/mul/div
21  */
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 }
60 
61 /**
62  * ERC20 standard interface.
63  */
64 interface IERC20 {
65     function totalSupply() external view returns (uint256);
66     function decimals() external view returns (uint8);
67     function symbol() external view returns (string memory);
68     function name() external view returns (string memory);
69     function getOwner() external view returns (address);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool);
72     function allowance(address _owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 abstract contract Auth {
80     address internal owner;
81 
82     constructor(address _owner) {
83         owner = _owner;
84     }
85 
86     /**
87      * Function modifier to require caller to be contract deployer
88      */
89     modifier onlyOwner() {
90         require(isOwner(msg.sender), "!Owner"); _;
91     }
92 
93     /**
94      * Check if address is owner
95      */
96     function isOwner(address account) public view returns (bool) {
97         return account == owner;
98     }
99 
100     /**
101      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
102      */
103     function transferOwnership(address payable adr) public onlyOwner {
104         owner = adr;
105         emit OwnershipTransferred(adr);
106     }
107 
108     event OwnershipTransferred(address owner);
109 }
110 
111 interface IDEXFactory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IDEXRouter {
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118 
119     function addLiquidity(
120         address tokenA,
121         address tokenB,
122         uint amountADesired,
123         uint amountBDesired,
124         uint amountAMin,
125         uint amountBMin,
126         address to,
127         uint deadline
128     ) external returns (uint amountA, uint amountB, uint liquidity);
129 
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 
139     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146 
147     function swapExactETHForTokensSupportingFeeOnTransferTokens(
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external payable;
153 
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161 }
162 
163 interface IDividendDistributor {
164     function setRewardToken(address newRewardToken) external;
165     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
166     function setShare(address shareholder, uint256 amount) external;
167     function deposit(uint256 amount) external;
168     function claimDividend(address shareholder) external;
169     function getDividendsClaimedOf (address shareholder) external returns (uint256);
170     function process(uint256 gas) external;
171 }
172 
173 contract DividendDistributor is IDividendDistributor {
174     using SafeMath for uint256;
175 
176     address public _token;
177     address public _owner;
178 
179     address public RewardToken;
180 
181 
182     struct Share {
183         uint256 amount;
184         uint256 totalExcluded;
185         uint256 totalClaimed;
186     }
187 
188     address[] shareholders;
189     mapping (address => uint256) shareholderIndexes;
190     mapping (address => uint256) shareholderClaims;
191     mapping (address => Share) public shares;
192 
193     uint256 public totalShares;
194     uint256 public totalDividends;
195     uint256 public totalClaimed;
196     uint256 public dividendsPerShare;
197     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
198 
199     uint256 public minPeriod;
200     uint256 public minDistribution;
201 
202     uint256 currentIndex;
203     bool initialized;
204 
205     modifier initialization() {
206         require(!initialized);
207         _;
208         initialized = true;
209     }
210 
211     modifier onlyToken() {
212         require(msg.sender == _token); _;
213     }
214 
215     modifier onlyOwner() {
216         require(msg.sender == _owner); _;
217     }
218 
219     constructor (address owner) {
220         _token = msg.sender;
221         _owner = owner;
222     }
223 
224     receive() external payable { }
225 
226     function setRewardToken(address newRewardToken) external override onlyToken {
227         RewardToken = newRewardToken;
228     }
229 
230     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
231         minPeriod = newMinPeriod;
232         minDistribution = newMinDistribution;
233     }
234 
235     function setShare(address shareholder, uint256 amount) external override onlyToken {
236         if(shares[shareholder].amount > 0){
237             distributeDividend(shareholder);
238         }
239 
240         if(amount > 0 && shares[shareholder].amount == 0){
241             addShareholder(shareholder);
242         }else if(amount == 0 && shares[shareholder].amount > 0){
243             removeShareholder(shareholder);
244         }
245 
246         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
247         shares[shareholder].amount = amount;
248         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
249     }
250 
251     function deposit(uint256 amount) external override onlyToken {
252         
253         if (amount > 0) {        
254             totalDividends = totalDividends.add(amount);
255             dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
256         }
257     }
258 
259     function process(uint256 gas) external override onlyToken {
260         uint256 shareholderCount = shareholders.length;
261 
262         if(shareholderCount == 0) { return; }
263 
264         uint256 iterations = 0;
265         uint256 gasUsed = 0;
266         uint256 gasLeft = gasleft();
267 
268         while(gasUsed < gas && iterations < shareholderCount) {
269 
270             if(currentIndex >= shareholderCount){ currentIndex = 0; }
271 
272             if(shouldDistribute(shareholders[currentIndex])){
273                 distributeDividend(shareholders[currentIndex]);
274             }
275 
276             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
277             gasLeft = gasleft();
278             currentIndex++;
279             iterations++;
280         }
281     }
282         
283     function shouldDistribute(address shareholder) internal view returns (bool) {
284         return shareholderClaims[shareholder] + minPeriod < block.timestamp
285                 && getUnpaidEarnings(shareholder) > minDistribution;
286     }
287 
288     function distributeDividend(address shareholder) internal {
289         if(shares[shareholder].amount == 0){ return; }
290 
291         uint256 amount = getClaimableDividendOf(shareholder);
292         if(amount > 0){
293             totalClaimed = totalClaimed.add(amount);
294             shares[shareholder].totalClaimed = shares[shareholder].totalClaimed.add(amount);
295             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
296             IERC20(RewardToken).transfer(shareholder, amount);
297         }
298     }
299 
300     function claimDividend(address shareholder) external override onlyToken {
301         distributeDividend(shareholder);
302     }
303 
304     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
305         if(shares[shareholder].amount == 0){ return 0; }
306 
307         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
308         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
309 
310         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
311 
312         return shareholderTotalDividends.sub(shareholderTotalExcluded);
313     }
314 
315     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
316         if(shares[shareholder].amount == 0){ return 0; }
317 
318         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
319         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
320 
321         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
322 
323         return shareholderTotalDividends.sub(shareholderTotalExcluded);
324     }
325 
326     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
327         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
328     }
329 
330     function addShareholder(address shareholder) internal {
331         shareholderIndexes[shareholder] = shareholders.length;
332         shareholders.push(shareholder);
333     }
334 
335     function removeShareholder(address shareholder) internal {
336         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
337         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
338         shareholders.pop();
339     }
340 
341     function manualSend(uint256 amount, address holder) external onlyOwner {
342         uint256 contractETHBalance = address(this).balance;
343         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
344     }
345 
346 
347     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
348         require (shares[shareholder].amount > 0, "You're not a BANKX shareholder!");
349         return shares[shareholder].totalClaimed;
350     }
351 }
352 
353 contract BankOfX is IERC20, Auth {
354     using SafeMath for uint256;
355 
356     address public RewardToken;
357 
358     string private constant _name = "BANK OF X";
359     string private constant _symbol = "BANKX";
360     uint8 private constant _decimals = 9;
361     
362     uint256 private _totalSupply = 10000000 * (10 ** _decimals);
363 
364     mapping(address => uint256) private _balances;
365     mapping(address => mapping(address => uint256)) private _allowances;
366     mapping (address => uint256) private cooldown;
367 
368     address private WETH;
369     address DEAD = 0x000000000000000000000000000000000000dEaD;
370     address ZERO = 0x0000000000000000000000000000000000000000;
371 
372     bool public limitsInEffect = true;
373     bool public antiBot = true;
374 
375     mapping (address => bool) private bots; 
376     mapping (address => bool) public isFeeExempt;
377     mapping (address => bool) public isTxLimitExempt;
378     mapping (address => bool) public isDividendExempt;
379 
380     uint256 public launchedAt;
381 
382     uint256 public devFeeBuy = 10;
383     uint256 public rewardFeeBuy = 40;
384     uint256 public lpFeeBuy = 20;
385     uint256 public marketingFeeBuy = 30;
386 
387 
388     uint256 public rewardFeeSell = 40;
389     uint256 public lpFeeSell = 20;
390     uint256 public marketingFeeSell = 30;
391     uint256 public devFeeSell = 10;
392     
393     uint public feeDenominator = 1000;
394 
395     uint256 public totalFeeBuy = devFeeBuy.add(lpFeeBuy).add(rewardFeeBuy).add(marketingFeeBuy);
396     uint256 public totalFeeSell = devFeeSell.add(lpFeeSell).add(rewardFeeSell).add(marketingFeeSell); 
397 
398     IDEXRouter public router;
399     address public pair;
400 
401     DividendDistributor public distributor;
402     uint256 public distributorGas = 0;
403 
404     address payable public marketingWallet = payable(0xcB08Bc1287aCc495DFC981dD2F24e255B8E0b5bE);
405     address payable public devWallet = payable(0xDebe14e19a1D351654e7916a3Cf7ced0ffFFFAb8);
406 
407     bool inSwapAndLiquify;
408     bool public swapAndLiquifyEnabled = true;
409     bool public tradingActive = false;  
410 
411     modifier lockTheSwap {
412         inSwapAndLiquify = true;
413         _;
414         inSwapAndLiquify = false;
415     }
416 
417     uint256 public maxTx = _totalSupply.div(200);
418     uint256 public maxWallet = _totalSupply.div(50);
419     uint256 public swapThreshold = _totalSupply.div(250);
420 
421     constructor (
422         address _owner        
423     ) Auth(_owner) {
424         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
425             
426         WETH = router.WETH();
427         
428         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
429         
430         _allowances[address(this)][address(router)] = type(uint256).max;
431 
432         distributor = new DividendDistributor(_owner);
433         
434         isFeeExempt[_owner] = true;
435         isFeeExempt[marketingWallet] = true;             
436         isFeeExempt[devWallet] = true;
437 
438         isDividendExempt[pair] = true;
439         isDividendExempt[address(this)] = true;
440         isDividendExempt[DEAD] = true;    
441 
442 
443         isTxLimitExempt[_owner] = true;
444         isTxLimitExempt[pair] = true;
445         isTxLimitExempt[DEAD] = true;    
446 
447 
448         _balances[_owner] = _totalSupply;
449     
450         emit Transfer(address(0), _owner, _totalSupply);
451     }
452 
453     receive() external payable { }
454 
455     function _updateRewardToken(address newRewardToken) internal {
456         distributor.setRewardToken(newRewardToken);
457     }
458 
459     function updateRewardToken(address newRewardToken) external onlyOwner {
460         RewardToken = newRewardToken;
461         _updateRewardToken(newRewardToken);
462     }
463 
464     function changeDistributor(DividendDistributor newDistributor) external onlyOwner {
465         distributor = newDistributor;
466     }
467 
468     function changeFees(uint256 newDevFeeBuy, uint256 newDevFeeSell, uint256 newRewardFeeBuy, uint256 newRewardFeeSell, uint256 newLpFeeBuy, uint256 newLpFeeSell,
469         uint256 newMarketingFeeBuy, uint256 newMarketingFeeSell) external onlyOwner {
470 
471         rewardFeeBuy = newRewardFeeBuy;
472         lpFeeBuy = newLpFeeBuy;
473         marketingFeeBuy = newMarketingFeeBuy;
474         devFeeBuy = newDevFeeBuy;
475 
476         rewardFeeSell = newRewardFeeSell;
477         lpFeeSell = newLpFeeSell;
478         marketingFeeSell = newMarketingFeeSell;
479         devFeeSell = newDevFeeSell;
480 
481         totalFeeBuy = devFeeBuy.add(lpFeeBuy).add(rewardFeeBuy).add(marketingFeeBuy);
482         totalFeeSell = devFeeSell.add(lpFeeSell).add(rewardFeeSell).add(marketingFeeSell);
483 
484         require(totalFeeBuy <= 10, "don't be greedy dev");
485         require(totalFeeSell <= 10, "don't be greedy dev");
486     } 
487 
488     function changeMaxTx(uint256 newMaxTx) external onlyOwner {
489         maxTx = newMaxTx;
490     }
491 
492     function changeMaxWallet(uint256 newMaxWallet) external onlyOwner {
493         maxWallet  = newMaxWallet;
494     }
495 
496     function removeLimits(bool) external onlyOwner {            
497         limitsInEffect = false;
498     }
499     
500     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
501         isFeeExempt[holder] = exempt;
502     }
503 
504     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
505         isTxLimitExempt[holder] = exempt;
506     }
507 
508     function setMarketingWallet(address payable newMarketingWallet) external onlyOwner {
509         marketingWallet = payable(newMarketingWallet);
510     }
511 
512     function setDevWallet(address payable newDevWallet) external onlyOwner {
513         devWallet = payable(newDevWallet);
514     }
515 
516     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
517         owner = newOwnerWallet;
518     }     
519 
520     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
521         swapAndLiquifyEnabled  = enableSwapBack;
522         swapThreshold = newSwapBackLimit;
523     }
524 
525     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
526         distributor.setDistributionCriteria(newMinPeriod, newMinDistribution);        
527     }
528 
529     function setBots(address[] memory bots_) external onlyOwner {
530         for (uint i = 0; i < bots_.length; i++) {
531             bots[bots_[i]] = true;
532         }
533     }
534 
535     function delBot(address notbot) external onlyOwner {
536         bots[notbot] = false;
537     }
538 
539     function _setIsDividendExempt(address holder, bool exempt) internal {
540         require(holder != address(this) && holder != pair);
541         isDividendExempt[holder] = exempt;
542         if(exempt){
543             distributor.setShare(holder, 0);
544         }else{
545             distributor.setShare(holder, _balances[holder]);
546         }
547     }
548 
549     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
550         _setIsDividendExempt(holder, exempt);
551     }
552 
553     function changeDistributorGas(uint256 _distributorGas) external onlyOwner {
554         distributorGas = _distributorGas;
555     }           
556 
557     function getCirculatingSupply() public view returns (uint256) {
558         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
559     }
560 
561     function totalSupply() external view override returns (uint256) { return _totalSupply; }
562     function decimals() external pure override returns (uint8) { return _decimals; }
563     function symbol() external pure override returns (string memory) { return _symbol; }
564     function name() external pure override returns (string memory) { return _name; }
565     function getOwner() external view override returns (address) { return owner; }
566     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
567     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
568     
569     function approve(address spender, uint256 amount) public override returns (bool) {
570         _allowances[msg.sender][spender] = amount;
571         emit Approval(msg.sender, spender, amount);
572         return true;
573     }
574 
575     function approveMax(address spender) external returns (bool) {
576         return approve(spender, type(uint256).max);
577     }
578 
579     function transfer(address recipient, uint256 amount) external override returns (bool) {
580         return _transfer(msg.sender, recipient, amount);
581     }
582 
583     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
584         if(_allowances[sender][msg.sender] != type(uint256).max){
585             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
586         }
587 
588         return _transfer(sender, recipient, amount);
589     }
590 
591     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
592         if (sender!= owner && recipient!= owner) require(tradingActive, "Trading not yet active."); //transfers disabled before tradingActive
593         require(!bots[sender] && !bots[recipient]);
594 
595         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
596 
597         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
598 
599         if(!isTxLimitExempt[recipient] && antiBot)
600         {
601             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
602         }
603 
604         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
605 
606         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
607         
608         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
609         _balances[recipient] = _balances[recipient].add(finalAmount);
610 
611         // Dividend tracker
612         if(!isDividendExempt[sender]) {
613             try distributor.setShare(sender, _balances[sender]) {} catch {}
614         }
615 
616         if(!isDividendExempt[recipient]) {
617             try distributor.setShare(recipient, _balances[recipient]) {} catch {} 
618         }
619 
620         if (distributorGas > 0) {
621             try distributor.process(distributorGas) {} catch {}
622         }
623 
624         emit Transfer(sender, recipient, finalAmount);
625         return true;
626     }    
627 
628     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
629         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
630         _balances[recipient] = _balances[recipient].add(amount);
631         emit Transfer(sender, recipient, amount);
632         return true;
633     }  
634     
635     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
636         
637         uint256 feeApplicable = pair == recipient ? totalFeeSell : totalFeeBuy;
638         uint256 feeAmount = amount.mul(feeApplicable).div(feeDenominator);
639 
640         _balances[address(this)] = _balances[address(this)].add(feeAmount);
641         emit Transfer(sender, address(this), feeAmount);
642 
643         return amount.sub(feeAmount);
644     }
645 
646     function swapBack() internal lockTheSwap {
647         
648         uint256 numTokensToSwap = _balances[address(this)];
649         uint256 amountForLp = numTokensToSwap.mul(lpFeeSell).div(totalFeeSell).div(2);
650         uint256 amountForRewardToken = numTokensToSwap.mul(rewardFeeSell).div(totalFeeSell);
651         uint256 amountToSwapForEth = numTokensToSwap.sub(amountForLp).sub(amountForRewardToken);
652 
653         swapTokensForEth(amountToSwapForEth);
654 
655         if (address(RewardToken) == address(this)) {
656             IERC20(RewardToken).transfer(address(distributor), amountForRewardToken);
657             distributor.deposit(amountForRewardToken);
658         }
659 
660         if (address(RewardToken) != address(this)) {
661             swapTokensForRewardToken(amountForRewardToken);
662         }
663 
664     }
665 
666     function swapTokensForRewardToken(uint256 tokenAmount) private {
667         address[] memory path = new address[](3);
668         path[0] = address(this);
669         path[1] = WETH;
670         path[2] = RewardToken;
671 
672         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
673             tokenAmount,
674             0,
675             path,
676             address(this),
677             block.timestamp
678         );
679 
680         uint256 dividends = IERC20(RewardToken).balanceOf(address(this));
681 
682         bool success = IERC20(RewardToken).transfer(address(distributor), dividends);
683 
684         if (success) {
685             distributor.deposit(dividends);            
686         }     
687     }
688 
689     function swapTokensForEth(uint256 tokenAmount) private {
690 
691         // generate the uniswap pair path of token -> weth
692         address[] memory path = new address[](2);
693         path[0] = address(this);
694         path[1] = WETH;
695 
696         // make the swap
697         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
698             tokenAmount,
699             0, // accept any amount of ETH
700             path,
701             address(this),
702             block.timestamp
703         );
704 
705         uint256 amountETH = address(this).balance;
706         uint256 marketingBalance = amountETH.mul(marketingFeeSell).div(totalFeeSell);
707         uint256 devBalance = amountETH.mul(devFeeSell).div(totalFeeSell);
708 
709         uint256 amountEthLiquidity = amountETH.mul(lpFeeSell).div(totalFeeSell).div(2);
710 
711         if(amountETH > 0){          
712             payable(devWallet).transfer(devBalance); 
713             payable(marketingWallet).transfer(marketingBalance);
714         }        
715 
716         if(amountEthLiquidity > 0){
717             router.addLiquidityETH{value: amountEthLiquidity}(
718                 address(this),
719                 amountEthLiquidity,
720                 0,
721                 0,
722                 0x000000000000000000000000000000000000dEaD,
723                 block.timestamp
724             );
725         }      
726     }
727 
728     function manualSwapBack() external onlyOwner {
729         swapBack();
730     }
731 
732     function manualSendEth() external onlyOwner {
733         uint256 contractETHBalance = address(this).balance;
734         uint256 marketingBalanceETH = contractETHBalance.mul(marketingFeeSell).div(totalFeeSell);
735         uint256 devBalanceETH = contractETHBalance.mul(devFeeSell).div(totalFeeSell);
736         if(contractETHBalance > 0){          
737             payable(devWallet).transfer(devBalanceETH); 
738             payable(marketingWallet).transfer(marketingBalanceETH);
739         }
740     }
741 
742     //once enabled, cannot be reversed
743     function openTrading() external onlyOwner {
744         launchedAt = block.number;
745         tradingActive = true;
746     }      
747 
748     //dividend functions
749     function claimDividend() external {
750         distributor.claimDividend(msg.sender);
751     }
752     
753     function claimDividend(address holder) external onlyOwner {
754         distributor.claimDividend(holder);
755     }
756     
757     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
758         return distributor.getClaimableDividendOf(shareholder);
759     }
760 
761     function getTotalDividends() external view returns (uint256) {
762         return distributor.totalDividends();
763     }    
764 
765     function getTotalClaimed() external view returns (uint256) {
766         return distributor.totalClaimed();
767     }
768 
769     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
770         return distributor.getDividendsClaimedOf(shareholder);
771     }
772 
773     function manualProcessGas(uint256 manualGas) external onlyOwner {
774         distributor.process(manualGas);
775     }
776 }