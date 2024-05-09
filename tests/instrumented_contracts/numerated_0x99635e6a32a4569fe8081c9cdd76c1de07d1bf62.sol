1 // SPDX-License-Identifier: MIT Licence
2  
3 pragma solidity ^0.7.4;
4  
5  
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10  
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19  
20         return c;
21     }
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26  
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29  
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41  
42 interface IBEP20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56  
57 abstract contract Auth {
58     address internal owner;
59     mapping (address => bool) internal authorizations;
60  
61     constructor(address _owner) {
62         owner = _owner;
63         authorizations[_owner] = true;
64     }
65  
66     modifier onlyOwner() {
67         require(isOwner(msg.sender), "!OWNER"); _;
68     }
69  
70     modifier authorized() {
71         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
72     }
73  
74     function authorize(address adr) public onlyOwner {
75         authorizations[adr] = true;
76     }
77  
78     function unauthorize(address adr) public onlyOwner {
79         authorizations[adr] = false;
80     }
81  
82     function isOwner(address account) public view returns (bool) {
83         return account == owner;
84     }
85  
86     function isAuthorized(address adr) public view returns (bool) {
87         return authorizations[adr];
88     }
89  
90     function transferOwnership(address payable adr) public onlyOwner {
91         owner = adr;
92         authorizations[adr] = true;
93         emit OwnershipTransferred(adr);
94     }
95  
96     event OwnershipTransferred(address owner);
97 }
98  
99 interface IDEXFactory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102  
103 interface IDEXRouter {
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106  
107     function addLiquidity(
108         address tokenA,
109         address tokenB,
110         uint amountADesired,
111         uint amountBDesired,
112         uint amountAMin,
113         uint amountBMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountA, uint amountB, uint liquidity);
117  
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126  
127     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134  
135     function swapExactETHForTokensSupportingFeeOnTransferTokens(
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external payable;
141  
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external;
149 }
150  
151 interface IDividendDistributor {
152     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
153     function setShare(address shareholder, uint256 amount) external;
154     function deposit() external payable;
155     function process(uint256 gas) external;
156 }
157  
158 contract DividendDistributor is IDividendDistributor {
159     using SafeMath for uint256;
160  
161     address _token;
162  
163     struct Share {
164         uint256 amount;
165         uint256 totalExcluded;
166         uint256 totalRealised;
167     }
168  
169     IBEP20 RWRD = IBEP20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
170     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
171     IDEXRouter router;
172  
173     address[] shareholders;
174     mapping (address => uint256) shareholderIndexes;
175     mapping (address => uint256) shareholderClaims;
176  
177     mapping (address => Share) public shares;
178  
179     uint256 public totalShares;
180     uint256 public totalDividends;
181     uint256 public totalDistributed;
182     uint256 public dividendsPerShare;
183     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
184  
185     uint256 public minPeriod = 45 * 60;
186     uint256 public minDistribution = 1 * (10 ** 18);
187  
188     uint256 currentIndex;
189  
190     bool initialized;
191     modifier initialization() {
192         require(!initialized);
193         _;
194         initialized = true;
195     }
196  
197     modifier onlyToken() {
198         require(msg.sender == _token); _;
199     }
200  
201     constructor (address _router) {
202         router = _router != address(0)
203         ? IDEXRouter(_router)
204         : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
205         _token = msg.sender;
206     }
207  
208     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {
209         minPeriod = _minPeriod;
210         minDistribution = _minDistribution;
211     }
212  
213     function setShare(address shareholder, uint256 amount) external override onlyToken {
214         if(shares[shareholder].amount > 0){
215             distributeDividend(shareholder);
216         }
217  
218         if(amount > 0 && shares[shareholder].amount == 0){
219             addShareholder(shareholder);
220         }else if(amount == 0 && shares[shareholder].amount > 0){
221             removeShareholder(shareholder);
222         }
223  
224         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
225         shares[shareholder].amount = amount;
226         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
227     }
228  
229     function deposit() external payable override onlyToken {
230         uint256 balanceBefore = RWRD.balanceOf(address(this));
231  
232         address[] memory path = new address[](2);
233         path[0] = WETH;
234         path[1] = address(RWRD);
235  
236         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
237             0,
238             path,
239             address(this),
240             block.timestamp
241         );
242  
243         uint256 amount = RWRD.balanceOf(address(this)).sub(balanceBefore);
244  
245         totalDividends = totalDividends.add(amount);
246         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
247     }
248  
249     function process(uint256 gas) external override onlyToken {
250         uint256 shareholderCount = shareholders.length;
251  
252         if(shareholderCount == 0) { return; }
253  
254         uint256 gasUsed = 0;
255         uint256 gasLeft = gasleft();
256  
257         uint256 iterations = 0;
258  
259         while(gasUsed < gas && iterations < shareholderCount) {
260             if(currentIndex >= shareholderCount){
261                 currentIndex = 0;
262             }
263  
264             if(shouldDistribute(shareholders[currentIndex])){
265                 distributeDividend(shareholders[currentIndex]);
266             }
267  
268             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
269             gasLeft = gasleft();
270             currentIndex++;
271             iterations++;
272         }
273     }
274  
275     function shouldDistribute(address shareholder) internal view returns (bool) {
276         return shareholderClaims[shareholder] + minPeriod < block.timestamp
277         && getUnpaidEarnings(shareholder) > minDistribution;
278     }
279  
280     function distributeDividend(address shareholder) internal {
281         if(shares[shareholder].amount == 0){ return; }
282  
283         uint256 amount = getUnpaidEarnings(shareholder);
284         if(amount > 0){
285             totalDistributed = totalDistributed.add(amount);
286             RWRD.transfer(shareholder, amount);
287             shareholderClaims[shareholder] = block.timestamp;
288             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
289             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
290         }
291     }
292  
293     function claimDividend() external {
294         distributeDividend(msg.sender);
295     }
296  
297     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
298         if(shares[shareholder].amount == 0){ return 0; }
299  
300         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
301         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
302  
303         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
304  
305         return shareholderTotalDividends.sub(shareholderTotalExcluded);
306     }
307  
308     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
309         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
310     }
311  
312     function addShareholder(address shareholder) internal {
313         shareholderIndexes[shareholder] = shareholders.length;
314         shareholders.push(shareholder);
315     }
316  
317     function removeShareholder(address shareholder) internal {
318         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
319         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
320         shareholders.pop();
321     }
322 }
323  
324 contract Test is IBEP20, Auth {
325     using SafeMath for uint256;
326  
327     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
328     address DEAD = 0x000000000000000000000000000000000000dEaD;
329     address ZERO = 0x0000000000000000000000000000000000000000;
330  
331     string constant _name = "SHIBA PEPE";
332     string constant _symbol = "SHEPE";
333     uint8 constant _decimals = 4;
334  
335     uint256 _totalSupply = 21000000 * 10**6 * 10**_decimals;
336  
337     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
338     uint256 public _maxWalletToken = _totalSupply.mul(4).div(100);
339  
340     mapping (address => uint256) _balances;
341     mapping (address => mapping (address => uint256)) _allowances;
342  
343     bool public blacklistMode = true;
344     mapping (address => bool) public isBlacklisted;
345  
346     mapping (address => bool) isFeeExempt;
347     mapping (address => bool) isTxLimitExempt;
348     mapping (address => bool) isTimelockExempt;
349     mapping (address => bool) isDividendExempt;
350  
351     uint256 public liquidityFee    = 0;
352     uint256 public reflectionFee   = 0;
353     uint256 public marketingFee    = 0;
354     uint256 public ecosystemfee    = 0;
355     uint256 public burnFee         = 0;
356     uint256 private totalFee        = marketingFee + reflectionFee + liquidityFee + ecosystemfee + burnFee;
357     uint256 public feeDenominator  = 100;
358  
359     uint256 public sellMultiplier  = 100;
360  
361     address private autoLiquidityReceiver;
362     address private marketingFeeReceiver;
363     address private ecosystemfeeReceiver;
364     address public burnFeeReceiver;
365  
366     uint256 targetLiquidity = 85;
367     uint256 targetLiquidityDenominator = 100;
368  
369     IDEXRouter public router;
370     address public pair;
371  
372     bool public tradingOpen = false;
373  
374     DividendDistributor public distributor;
375     uint256 distributorGas = 500000;
376  
377     bool public buyCooldownEnabled = false;
378     uint8 public cooldownTimerInterval = 60;
379     mapping (address => uint) private cooldownTimer;
380  
381     bool public swapEnabled = true;
382     uint256 public swapThreshold = _totalSupply * 5 / 10000;
383     bool inSwap;
384 
385     modifier swapping() { inSwap = true; _; inSwap = false; }
386  
387     constructor () Auth(msg.sender) {
388         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
389         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
390         _allowances[address(this)][address(router)] = uint256(-1);
391  
392         distributor = new DividendDistributor(address(router));
393  
394         isFeeExempt[msg.sender] = true;
395         isTxLimitExempt[msg.sender] = true;
396  
397         isTimelockExempt[msg.sender] = true;
398         isTimelockExempt[DEAD] = true;
399         isTimelockExempt[address(this)] = true;
400  
401         isDividendExempt[pair] = true;
402         isDividendExempt[address(this)] = true;
403         isDividendExempt[DEAD] = true;
404  
405         autoLiquidityReceiver = msg.sender;
406         marketingFeeReceiver = 0x080FE3528Ed88Fc9752bC790AA5b272540796bC0;
407         ecosystemfeeReceiver = 0xBe1656240C98f76D0579da82049787d9476D7434;
408         burnFeeReceiver = DEAD;
409  
410         _balances[msg.sender] = _totalSupply;
411         emit Transfer(address(0), msg.sender, _totalSupply);
412     }
413  
414     receive() external payable { }
415  
416     function totalSupply() external view override returns (uint256) { return _totalSupply; }
417     function decimals() external pure override returns (uint8) { return _decimals; }
418     function symbol() external pure override returns (string memory) { return _symbol; }
419     function name() external pure override returns (string memory) { return _name; }
420     function getOwner() external view override returns (address) { return owner; }
421     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
422     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
423  
424     function approve(address spender, uint256 amount) public override returns (bool) {
425         _allowances[msg.sender][spender] = amount;
426         emit Approval(msg.sender, spender, amount);
427         return true;
428     }
429  
430     function approveMax(address spender) external returns (bool) {
431         return approve(spender, uint256(-1));
432     }
433  
434     function transfer(address recipient, uint256 amount) external override returns (bool) {
435         return _transferFrom(msg.sender, recipient, amount);
436     }
437  
438     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
439         if(_allowances[sender][msg.sender] != uint256(-1)){
440             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
441         }
442  
443         return _transferFrom(sender, recipient, amount);
444     }
445  
446     function setMaxWalletPercent_base5000(uint256 maxWallPercent_base5000) external onlyOwner() {
447         _maxWalletToken = (_totalSupply * maxWallPercent_base5000 ) / 5000;
448     }
449     function setMaxTxPercent_base5000(uint256 maxTXPercentage_base5000) external onlyOwner() {
450         _maxTxAmount = (_totalSupply * maxTXPercentage_base5000 ) / 5000;
451     }
452  
453     function setTxLimit(uint256 amount) external authorized {
454         _maxTxAmount = amount;
455     }
456  
457  
458     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
459         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
460  
461         if(!authorizations[sender] && !authorizations[recipient]){
462             require(tradingOpen,"Trading not open yet");
463         }
464  
465         // Blacklist
466         if(blacklistMode){
467             require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
468         }
469  
470  
471         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != marketingFeeReceiver && recipient != ecosystemfeeReceiver  && recipient != autoLiquidityReceiver && recipient != burnFeeReceiver){
472             uint256 heldTokens = balanceOf(recipient);
473             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
474  
475         if (sender == pair &&
476         buyCooldownEnabled &&
477             !isTimelockExempt[recipient]) {
478             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
479             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
480         }
481  
482         // Checks max transaction limit
483         checkTxLimit(sender, amount);
484  
485         if(shouldSwapBack()){ swapBack(); }
486  
487         //Exchange tokens
488         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
489 
490         uint256 amountReceived;
491         
492         if(sender == pair && !isFeeExempt[sender] && !isFeeExempt[recipient]){
493             amountReceived = takeFee(sender, amount, (false));
494         }
495 
496         else if(recipient == pair && !isFeeExempt[sender] && !isFeeExempt[recipient]) {
497             amountReceived = takeFee(sender, amount, (true));
498         } else{
499             amountReceived = amount;
500         }
501  
502         // uint256 amountReceived = (!shouldTakeFee(sender) || !shouldTakeFee(recipient)) ? amount : takeFee(sender, amount,(recipient == pair));
503         _balances[recipient] = _balances[recipient].add(amountReceived);
504  
505         // Dividend tracker
506         if(!isDividendExempt[sender]) {
507             try distributor.setShare(sender, _balances[sender]) {} catch {}
508         }
509  
510         if(!isDividendExempt[recipient]) {
511             try distributor.setShare(recipient, _balances[recipient]) {} catch {}
512         }
513  
514         try distributor.process(distributorGas) {} catch {}
515  
516         emit Transfer(sender, recipient, amountReceived);
517         return true;
518     }
519  
520     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
521         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
522         _balances[recipient] = _balances[recipient].add(amount);
523         emit Transfer(sender, recipient, amount);
524         return true;
525     }
526  
527     function checkTxLimit(address sender, uint256 amount) internal view {
528         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
529     }
530  
531     function shouldTakeFee(address sender) external view returns (bool) {
532         return !isFeeExempt[sender];
533     }
534  
535     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
536  
537         uint256 multiplier = isSell ? sellMultiplier : 100;
538         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
539 
540 
541  
542         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
543         uint256 contractTokens = feeAmount.sub(burnTokens);
544  
545         _balances[address(this)] = _balances[address(this)].add(contractTokens);
546         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
547         emit Transfer(sender, address(this), contractTokens);
548  
549         if(burnTokens > 0){
550             emit Transfer(sender, burnFeeReceiver, burnTokens);
551         }
552  
553         return amount.sub(feeAmount);
554     }
555  
556     function shouldSwapBack() internal view returns (bool) {
557         return msg.sender != pair
558         && !inSwap
559         && swapEnabled
560         && _balances[address(this)] >= swapThreshold;
561     }
562  
563     function clearStuckBalance(uint256 amountPercentage) external authorized {
564         uint256 amountBNB = address(this).balance;
565         payable(msg.sender).transfer(amountBNB * amountPercentage / 100);
566     }
567  
568     function clearStuckBalance_sender(uint256 amountPercentage) external authorized {
569         uint256 amountBNB = address(this).balance;
570         payable(msg.sender).transfer(amountBNB * amountPercentage / 100);
571     }
572  
573     function set_sell_multiplier(uint256 Multiplier) external onlyOwner{
574         sellMultiplier = Multiplier;
575     }
576  
577     // switch Trading
578     function tradingStatus(bool _status) public onlyOwner {
579         tradingOpen = _status;
580     }
581 
582     function whiteList(address _address, bool _status) public onlyOwner {
583         isFeeExempt[_address] = _status;
584         isTxLimitExempt[_address] = _status;
585         isTimelockExempt[_address] = _status;
586     }
587  
588     // enable cooldown between trades
589     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
590         buyCooldownEnabled = _status;
591         cooldownTimerInterval = _interval;
592     }
593  
594     function swapBack() internal swapping {
595         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
596         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
597         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
598  
599         address[] memory path = new address[](2);
600         path[0] = address(this);
601         path[1] = WETH;
602  
603         uint256 balanceBefore = address(this).balance;
604  
605         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
606             amountToSwap,
607             0,
608             path,
609             address(this),
610             block.timestamp
611         );
612  
613         uint256 amountBNB = address(this).balance.sub(balanceBefore);
614  
615         uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2));
616  
617         uint256 amountBNBLiquidity = amountBNB.mul(dynamicLiquidityFee).div(totalBNBFee).div(2);
618         uint256 amountBNBReflection = amountBNB.mul(reflectionFee).div(totalBNBFee);
619         uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
620         uint256 amountBNBDev = amountBNB.mul(ecosystemfee).div(totalBNBFee);
621  
622         try distributor.deposit{value: amountBNBReflection}() {} catch {}
623         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountBNBMarketing, gas: 30000}("");
624         (tmpSuccess,) = payable(ecosystemfeeReceiver).call{value: amountBNBDev, gas: 30000}("");
625  
626         // only to supress warning msg
627         tmpSuccess = false;
628  
629         if(amountToLiquify > 0){
630             router.addLiquidityETH{value: amountBNBLiquidity}(
631                 address(this),
632                 amountToLiquify,
633                 0,
634                 0,
635                 autoLiquidityReceiver,
636                 block.timestamp
637             );
638             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
639         }
640     }
641  
642  
643     function setIsDividendExempt(address holder, bool exempt) external authorized {
644         require(holder != address(this) && holder != pair);
645         isDividendExempt[holder] = exempt;
646         if(exempt){
647             distributor.setShare(holder, 0);
648         }else{
649             distributor.setShare(holder, _balances[holder]);
650         }
651     }
652  
653     function enable_blacklist(bool _status) public onlyOwner {
654         blacklistMode = _status;
655     }
656  
657     function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner {
658         for (uint256 i; i < addresses.length; ++i) {
659             isBlacklisted[addresses[i]] = status;
660         }
661     }
662  
663  
664     function setIsFeeExempt(address holder, bool exempt) external authorized {
665         isFeeExempt[holder] = exempt;
666     }
667  
668     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
669         isTxLimitExempt[holder] = exempt;
670     }
671  
672     function setIsTimelockExempt(address holder, bool exempt) external authorized {
673         isTimelockExempt[holder] = exempt;
674     }
675  
676     function setFees(uint256 _liquidityFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _ecosystemfee, uint256 _burnFee, uint256 _feeDenominator) external authorized {
677         liquidityFee = _liquidityFee;
678         reflectionFee = _reflectionFee;
679         marketingFee = _marketingFee;
680         ecosystemfee = _ecosystemfee;
681         burnFee = _burnFee;
682         totalFee = _liquidityFee.add(_reflectionFee).add(_marketingFee).add(_ecosystemfee).add(_burnFee);
683         feeDenominator = _feeDenominator;
684         require(totalFee < feeDenominator/4, "Fees cannot be more than 25%");
685     }
686  
687     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _ecosystemfeeReceiver, address _burnFeeReceiver ) external authorized {
688         autoLiquidityReceiver = _autoLiquidityReceiver;
689         marketingFeeReceiver = _marketingFeeReceiver;
690         ecosystemfeeReceiver = _ecosystemfeeReceiver;
691         burnFeeReceiver = _burnFeeReceiver;
692     }
693  
694     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
695         swapEnabled = _enabled;
696         swapThreshold = _amount;
697     }
698  
699     function setTargetLiquidity(uint256 _target, uint256 _denominator) external authorized {
700         targetLiquidity = _target;
701         targetLiquidityDenominator = _denominator;
702     }
703  
704     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized {
705         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
706     }
707  
708     function setDistributorSettings(uint256 gas) external authorized {
709         require(gas < 750000);
710         distributorGas = gas;
711     }
712  
713     function getCirculatingSupply() public view returns (uint256) {
714         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
715     }
716  
717     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
718         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
719     }
720  
721     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
722         return getLiquidityBacking(accuracy) > target;
723     }
724  
725  
726  
727     /* Airdrop Begins */
728     function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
729         require(from==msg.sender);
730         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
731         require(addresses.length == tokens.length,"Mismatch between Address and token count");
732  
733         uint256 SCCC = 0;
734  
735         for(uint i=0; i < addresses.length; i++){
736             SCCC = SCCC + tokens[i];
737         }
738  
739         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
740  
741         for(uint i=0; i < addresses.length; i++){
742             _basicTransfer(from,addresses[i],tokens[i]);
743             if(!isDividendExempt[addresses[i]]) {
744                 try distributor.setShare(addresses[i], _balances[addresses[i]]) {} catch {}
745             }
746         }
747  
748         // Dividend tracker
749         if(!isDividendExempt[from]) {
750             try distributor.setShare(from, _balances[from]) {} catch {}
751         }
752     }
753  
754     function multiTransfer_fixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
755         require(from==msg.sender);
756         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
757  
758         uint256 SCCC = tokens * addresses.length;
759  
760         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
761  
762         for(uint i=0; i < addresses.length; i++){
763             _basicTransfer(from,addresses[i],tokens);
764             if(!isDividendExempt[addresses[i]]) {
765                 try distributor.setShare(addresses[i], _balances[addresses[i]]) {} catch {}
766             }
767         }
768  
769         // Dividend tracker
770         if(!isDividendExempt[from]) {
771             try distributor.setShare(from, _balances[from]) {} catch {}
772         }
773     }
774  
775     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
776 }