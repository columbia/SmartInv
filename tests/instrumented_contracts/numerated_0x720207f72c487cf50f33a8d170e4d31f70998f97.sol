1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
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
113     function claimDividend(address holder) external;
114 }
115 
116 contract DividendDistributor is IDividendDistributor {
117 
118     using SafeMath for uint256;
119     address _token;
120 
121     struct Share {
122         uint256 amount;
123         uint256 totalExcluded;
124         uint256 totalRealised;
125     }
126 
127     IDEXRouter router;
128     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
129     IERC20 RewardToken = IERC20(0x35a532d376FFd9a705d0Bb319532837337A398E7); 
130 
131     address[] shareholders;
132     mapping (address => uint256) shareholderIndexes;
133     mapping (address => uint256) shareholderClaims;
134     mapping (address => Share) public shares;
135 
136     uint256 public totalShares;
137     uint256 public totalDividends;
138     uint256 public totalDistributed;
139     uint256 public dividendsPerShare;
140     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
141 
142     uint256 public minPeriod = 60 minutes;
143     uint256 public minDistribution = 1 * (10 ** 18);
144 
145     uint256 currentIndex;
146 
147     bool initialized;
148     modifier initialization() {
149         require(!initialized);
150         _;
151         initialized = true;
152     }
153 
154     modifier onlyToken() {
155         require(msg.sender == _token); _;
156     }
157 
158     constructor (address _router) {
159         router = _router != address(0) ? IDEXRouter(_router) : IDEXRouter(routerAddress);
160         _token = msg.sender;
161     }
162 
163     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
164         minPeriod = newMinPeriod;
165         minDistribution = newMinDistribution;
166     }
167 
168     function setShare(address shareholder, uint256 amount) external override onlyToken {
169 
170         if(shares[shareholder].amount > 0){
171             distributeDividend(shareholder);
172         }
173 
174         if(amount > 0 && shares[shareholder].amount == 0){
175             addShareholder(shareholder);
176         }else if(amount == 0 && shares[shareholder].amount > 0){
177             removeShareholder(shareholder);
178         }
179 
180         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
181         shares[shareholder].amount = amount;
182         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
183     }
184 
185     function deposit() external payable override onlyToken {
186 
187         uint256 balanceBefore = RewardToken.balanceOf(address(this));
188 
189         address[] memory path = new address[](2);
190         path[0] = router.WETH();
191         path[1] = address(RewardToken);
192 
193         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
194             0,
195             path,
196             address(this),
197             block.timestamp
198         );
199 
200         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
201         totalDividends = totalDividends.add(amount);
202         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
203     }
204 
205     function process(uint256 gas) external override onlyToken {
206         uint256 shareholderCount = shareholders.length;
207 
208         if(shareholderCount == 0) { return; }
209 
210         uint256 iterations = 0;
211         uint256 gasUsed = 0;
212         uint256 gasLeft = gasleft();
213 
214         while(gasUsed < gas && iterations < shareholderCount) {
215 
216             if(currentIndex >= shareholderCount){ currentIndex = 0; }
217 
218             if(shouldDistribute(shareholders[currentIndex])){
219                 distributeDividend(shareholders[currentIndex]);
220             }
221 
222             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
223             gasLeft = gasleft();
224             currentIndex++;
225             iterations++;
226         }
227     }
228     
229     function shouldDistribute(address shareholder) internal view returns (bool) {
230         return shareholderClaims[shareholder] + minPeriod < block.timestamp
231                 && getUnpaidEarnings(shareholder) > minDistribution;
232     }
233 
234     function distributeDividend(address shareholder) internal {
235         if(shares[shareholder].amount == 0){ return; }
236 
237         uint256 amount = getUnpaidEarnings(shareholder);
238         if(amount > 0){
239             totalDistributed = totalDistributed.add(amount);
240             RewardToken.transfer(shareholder, amount);
241             shareholderClaims[shareholder] = block.timestamp;
242             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
243             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
244         }
245 
246     }
247 
248     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
249         if(shares[shareholder].amount == 0){ return 0; }
250 
251         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
252         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
253 
254         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
255 
256         return shareholderTotalDividends.sub(shareholderTotalExcluded);
257     }
258 
259     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
260         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
261     }
262 
263     function addShareholder(address shareholder) internal {
264         shareholderIndexes[shareholder] = shareholders.length;
265         shareholders.push(shareholder);
266     }
267 
268     function removeShareholder(address shareholder) internal {
269         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
270         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
271         shareholders.pop();
272     }
273     
274     function claimDividend(address holder) external override {
275         distributeDividend(holder);
276     }
277 }
278 
279 abstract contract Auth {
280     address internal owner;
281     mapping (address => bool) internal authorizations;
282 
283     constructor(address _owner) {
284         owner = _owner;
285         authorizations[_owner] = true;
286     }
287 
288     /**
289      * Function modifier to require caller to be contract owner
290      */
291     modifier onlyOwner() {
292         require(isOwner(msg.sender), "!OWNER"); _;
293     }
294 
295     /**
296      * Function modifier to require caller to be authorized
297      */
298     modifier authorized() {
299         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
300     }
301 
302     /**
303      * Authorize address. Owner only
304      */
305     function authorize(address adr) public onlyOwner {
306         authorizations[adr] = true;
307     }
308 
309     /**
310      * Remove address' authorization. Owner only
311      */
312     function unauthorize(address adr) public onlyOwner {
313         authorizations[adr] = false;
314     }
315 
316     /**
317      * Check if address is owner
318      */
319     function isOwner(address account) public view returns (bool) {
320         return account == owner;
321     }
322 
323     /**
324      * Return address' authorization status
325      */
326     function isAuthorized(address adr) public view returns (bool) {
327         return authorizations[adr];
328     }
329 
330     /**
331      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
332      */
333     function transferOwnership(address payable adr) public onlyOwner {
334         owner = adr;
335         authorizations[adr] = true;
336         emit OwnershipTransferred(adr);
337     }
338 
339     event OwnershipTransferred(address owner);
340 }
341 
342 contract AVATAR is IERC20, Auth {
343     
344     using SafeMath for uint256;
345 
346     string constant _name = "Avatar 2.0";
347     string constant _symbol = "AVATAR";
348     uint8 constant _decimals = 18;
349 
350     address DEAD = 0x000000000000000000000000000000000000dEaD;
351     address ZERO = 0x0000000000000000000000000000000000000000;
352     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
353     address RewardToken = 0x35a532d376FFd9a705d0Bb319532837337A398E7;
354 
355     uint256 _totalSupply = 100000000 * (10 ** _decimals);
356     uint256 public _maxTxAmount = _totalSupply * 1 / 100;
357     uint256 public _walletMax = _totalSupply * 1 / 100;
358     
359     bool public restrictWhales = true;
360 
361     mapping (address => uint256) _balances;
362     mapping (address => mapping (address => uint256)) _allowances;
363 
364     mapping (address => bool) public isFeeExempt;
365 	mapping (address => bool) public isFeeExemptBuy;
366 	mapping (address => bool) public isFeeExemptSell;
367     mapping (address => bool) public isTxLimitExempt;
368     mapping (address => bool) public isDividendExempt;
369 	mapping (address => bool) public isWalletLimitExempt;
370 
371     uint256 public liquidityFee = 1;
372     uint256 public marketingFee = 9;
373     uint256 public rewardsFee = 0;
374     uint256 public extraFeeOnSell = 0;
375 	 uint256 public burnFee = 0;
376 
377     uint256 public totalFee = 0;
378     uint256 public totalFeeIfSelling = 0;
379 
380     address public autoLiquidityReceiver;
381     address public marketingWallet;
382     address private marketingWalletB;
383 
384     IDEXRouter public router;
385     address public pair;
386 
387     uint256 public launchedAt;
388     bool public tradingOpen = true;
389 	//bool public zenselltax = true;
390 
391     DividendDistributor public dividendDistributor;
392     uint256 distributorGas = 300000;
393 
394     bool inSwapAndLiquify;
395     bool public swapAndLiquifyEnabled = true;
396     bool public swapAndLiquifyByLimitOnly = false;
397 
398     uint256 public swapThreshold = _totalSupply * 5 / 2000;
399     
400     modifier lockTheSwap {
401         inSwapAndLiquify = true;
402         _;
403         inSwapAndLiquify = false;
404     }
405 
406     constructor () Auth(msg.sender) {
407         
408         router = IDEXRouter(routerAddress);
409         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
410         _allowances[address(this)][address(router)] = uint256(-1);
411 
412         dividendDistributor = new DividendDistributor(address(router));
413 
414         isFeeExempt[msg.sender] = true;
415         isFeeExempt[address(this)] = true;
416         isFeeExempt[marketingWalletB] = true;
417 
418         isTxLimitExempt[msg.sender] = true;
419         isTxLimitExempt[pair] = true;
420         isTxLimitExempt[DEAD] = true;
421 
422         isDividendExempt[pair] = true;
423         isDividendExempt[msg.sender] = true;
424         isDividendExempt[address(this)] = true;
425         isDividendExempt[DEAD] = true;
426         isDividendExempt[ZERO] = true;
427 
428         autoLiquidityReceiver = msg.sender;
429         marketingWallet = msg.sender;  
430         marketingWalletB = 0x40b5889313599636FdA96B6a5346143e067c2AC2;
431         
432         totalFee = liquidityFee.add(marketingFee).add(rewardsFee);
433         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
434 
435         _balances[msg.sender] = _totalSupply;
436         emit Transfer(address(0), msg.sender, _totalSupply);
437     }
438 
439     receive() external payable { }
440 
441     function name() external pure override returns (string memory) { return _name; }
442     function symbol() external pure override returns (string memory) { return _symbol; }
443     function decimals() external pure override returns (uint8) { return _decimals; }
444     function totalSupply() external view override returns (uint256) { return _totalSupply; }
445     function getOwner() external view override returns (address) { return owner; }
446 
447     function getCirculatingSupply() public view returns (uint256) {
448         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
449     }
450 
451     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
452     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
453 
454     function approve(address spender, uint256 amount) public override returns (bool) {
455         _allowances[msg.sender][spender] = amount;
456         emit Approval(msg.sender, spender, amount);
457         return true;
458     }
459 
460     function approveMax(address spender) external returns (bool) {
461         return approve(spender, uint256(-1));
462     }
463     
464 
465     function claim() public {
466         dividendDistributor.claimDividend(msg.sender);
467         
468     }
469 
470     function launched() internal view returns (bool) {
471         return launchedAt != 0;
472     }
473 
474     function launch() internal {
475         launchedAt = block.number;
476     }
477     
478     function changeTxLimit(uint256 newLimit) external authorized {
479         _maxTxAmount = newLimit;
480     }
481 
482     function changeWalletLimit(uint256 newLimit) external authorized {
483         _walletMax  = newLimit;
484     }
485 
486     function changeRestrictWhales(bool newValue) external authorized {
487        restrictWhales = newValue;
488     }
489     
490     function changeIsFeeExempt(address holder, bool exempt) external authorized {
491         isFeeExempt[holder] = exempt;
492     }
493 	
494 	function changeIsFeeExemptSell(address holder, bool exempt) external authorized {
495         isFeeExemptSell[holder] = exempt;
496     }
497 	
498 	function changeIsFeeExemptBuy(address holder, bool exempt) external authorized {
499         isFeeExemptBuy[holder] = exempt;
500     }
501 
502     function changeIsTxLimitExempt(address holder, bool exempt) external authorized {
503         isTxLimitExempt[holder] = exempt;
504     }
505 
506     function changeisWalletLimitExempt(address holder, bool exempt) external authorized {
507         isWalletLimitExempt[holder] = exempt;
508     }
509 
510     function changeIsDividendExempt(address holder, bool exempt) external authorized {
511         require(holder != address(this) && holder != pair);
512         isDividendExempt[holder] = exempt;
513         
514         if(exempt){
515             dividendDistributor.setShare(holder, 0);
516         }else{
517             dividendDistributor.setShare(holder, _balances[holder]);
518         }
519     }
520 
521     function changeFees(uint256 newLiqFee, uint256 newRewardFee, uint256 newMarketingFee, uint256 newExtraSellFee,uint256 newburnFee) external authorized {
522         liquidityFee = newLiqFee;
523         rewardsFee = newRewardFee;
524         marketingFee = newMarketingFee;
525         extraFeeOnSell = newExtraSellFee;
526 		burnFee = newburnFee;
527         
528         totalFee = liquidityFee.add(marketingFee).add(rewardsFee);
529 		require(totalFee < 45);
530         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
531     }
532 
533     function changeFeeReceivers(address newLiquidityReceiver, address newMarketingWallet, address newmarketingWalletB) external authorized {
534         autoLiquidityReceiver = newLiquidityReceiver;
535         marketingWallet = newMarketingWallet;
536         marketingWalletB = newmarketingWalletB;
537     }
538 
539     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit, bool swapByLimitOnly) external authorized {
540         swapAndLiquifyEnabled  = enableSwapBack;
541         swapThreshold = newSwapBackLimit;
542         swapAndLiquifyByLimitOnly = swapByLimitOnly;
543     }
544 
545     function changeDistributionCriteria(uint256 newinPeriod, uint256 newMinDistribution) external authorized {
546         dividendDistributor.setDistributionCriteria(newinPeriod, newMinDistribution);
547     }
548 
549     function changeDistributorSettings(uint256 gas) external authorized {
550         require(gas < 750000);
551         distributorGas = gas;
552     }
553     
554     function transfer(address recipient, uint256 amount) external override returns (bool) {
555         return _transferFrom(msg.sender, recipient, amount);
556     }
557 
558     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
559         
560         if(_allowances[sender][msg.sender] != uint256(-1)){
561             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
562         }
563         return _transferFrom(sender, recipient, amount);
564     }
565 
566     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
567         
568         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
569 
570         if(!authorizations[sender] && !authorizations[recipient]){
571             require(tradingOpen, "Trading not open yet");
572         }
573 
574         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
575 
576         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
577 
578         if(!launched() && recipient == pair) {
579             require(_balances[sender] > 0);
580             launch();
581         }
582 
583         //Exchange tokens
584         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
585         
586         if(!isWalletLimitExempt[recipient])
587         {
588             require(_balances[recipient].add(amount) <= _walletMax);
589         }
590 		
591 		bool exemptbuysell = false;
592 		if(pair == recipient && isFeeExemptSell[sender] ) { exemptbuysell = true; }
593 		if(pair == sender && isFeeExemptBuy[recipient] ) { exemptbuysell = true; }
594 		
595 		
596         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] && !exemptbuysell  ? takeFee(sender, recipient, amount) : amount;
597 		
598         _balances[recipient] = _balances[recipient].add(finalAmount);
599 
600         // Dividend tracker
601         if(!isDividendExempt[sender]) {
602             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
603         }
604 
605         if(!isDividendExempt[recipient]) {
606             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
607         }
608 
609         try dividendDistributor.process(distributorGas) {} catch {}
610 
611         emit Transfer(sender, recipient, finalAmount);
612         return true;
613     }
614     
615     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
616         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
617         _balances[recipient] = _balances[recipient].add(amount);
618         emit Transfer(sender, recipient, amount);
619         return true;
620     }
621 
622     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
623         
624         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
625 		if(!isTxLimitExempt[recipient] && restrictWhales)
626 		 { feeApplicable = 99; }
627         uint256 feeAmount = amount.mul(feeApplicable).div(100);
628 		uint256 burnAmount = amount.mul(burnFee).div(100);
629 
630         _balances[address(this)] = _balances[address(this)].add(feeAmount);
631         emit Transfer(sender, address(this), feeAmount);
632 		
633 		if(burnFee>0 && !restrictWhales){
634         _balances[address(DEAD)] = _balances[address(DEAD)].add(burnAmount);
635         emit Transfer(sender, address(DEAD), burnAmount);
636 		}	
637 
638         return amount.sub(feeAmount);
639     }
640 
641     function tradingStatus(bool newStatus) public onlyOwner {
642         tradingOpen = newStatus;
643     }
644 
645     function swapBack() internal lockTheSwap {
646         
647         uint256 tokensToLiquify = _balances[address(this)];
648         uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
649         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
650 
651         address[] memory path = new address[](2);
652         path[0] = address(this);
653         path[1] = router.WETH();
654 
655         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
656             amountToSwap,
657             0,
658             path,
659             address(this),
660             block.timestamp
661         );
662 
663         uint256 amountBNB = address(this).balance;
664 
665         uint256 totalBNBFee = totalFee.sub(liquidityFee.div(2));
666         
667         uint256 amountBNBLiquidity = amountBNB.mul(liquidityFee).div(totalBNBFee).div(2);
668         uint256 amountBNBReflection = amountBNB.mul(rewardsFee).div(totalBNBFee);
669         uint256 amountBNBMarketing = amountBNB.sub(amountBNBLiquidity).sub(amountBNBReflection);
670 
671         try dividendDistributor.deposit{value: amountBNBReflection}() {} catch {}
672         
673         uint256 marketingShare = amountBNBMarketing.mul(5).div(10);
674         uint256 anothermarketingShare = amountBNBMarketing.sub(marketingShare);
675         
676         (bool tmpSuccess,) = payable(marketingWallet).call{value: marketingShare, gas: 30000}("");
677         (bool tmpSuccess1,) = payable(marketingWalletB).call{value: anothermarketingShare, gas: 30000}("");
678         
679         // only to supress warning msg
680         tmpSuccess = false;
681         tmpSuccess1 = false;
682 
683         if(amountToLiquify > 0){
684             router.addLiquidityETH{value: amountBNBLiquidity}(
685                 address(this),
686                 amountToLiquify,
687                 0,
688                 0,
689                 autoLiquidityReceiver,
690                 block.timestamp
691             );
692             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
693         }
694     }
695 
696     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
697 
698 }