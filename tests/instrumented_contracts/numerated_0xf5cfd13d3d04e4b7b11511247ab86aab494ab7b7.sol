1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 /**
6 FEED THE INU - $KIBBLE
7 t.me/kibbleETH
8 
9 In support of Inu. All taxes generated from $KIBBLE are hardcoded to contribute directly to INU through:
10 1. Buying and reflecting $INU to all $KIBBLE hodlers
11 2. Sending ETH directly to $INU marketing wallet
12 3. Adding and burning $KIBBLE liquidity to encourage trading
13 */
14 
15 /**
16  * Standard SafeMath, stripped down to just add/sub/mul/div
17  */
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41 
42         return c;
43     }
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "SafeMath: division by zero");
46     }
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 }
56 
57 /**
58  * ERC20 standard interface.
59  */
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62     function decimals() external view returns (uint8);
63     function symbol() external view returns (string memory);
64     function name() external view returns (string memory);
65     function getOwner() external view returns (address);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address _owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 abstract contract Auth {
76     address internal owner;
77 
78     constructor(address _owner) {
79         owner = _owner;
80     }
81 
82     /**
83      * Function modifier to require caller to be contract deployer
84      */
85     modifier onlyOwner() {
86         require(isOwner(msg.sender), "!Owner"); _;
87     }
88 
89     /**
90      * Check if address is owner
91      */
92     function isOwner(address account) public view returns (bool) {
93         return account == owner;
94     }
95 
96     /**
97      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
98      */
99     function transferOwnership(address payable adr) public onlyOwner {
100         owner = adr;
101         emit OwnershipTransferred(adr);
102     }
103 
104     event OwnershipTransferred(address owner);
105 }
106 
107 interface IDEXFactory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IDEXRouter {
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114 
115     function addLiquidity(
116         address tokenA,
117         address tokenB,
118         uint amountADesired,
119         uint amountBDesired,
120         uint amountAMin,
121         uint amountBMin,
122         address to,
123         uint deadline
124     ) external returns (uint amountA, uint amountB, uint liquidity);
125 
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 
135     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142 
143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external payable;
149 
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157 }
158 
159 interface IKibbleDist {
160     function setInu (address inuAddress) external;
161     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
162     function setShare(address shareholder, uint256 amount) external;
163     function deposit() external payable;
164     function process(uint256 gas) external;
165     function feedDogs(address shareholder) external;
166 }
167 
168 
169 contract DogFood is IKibbleDist {
170 
171     using SafeMath for uint256;
172     address _token;
173 
174     address public INU;
175 
176     IDEXRouter router;
177 
178     struct Share {
179         uint256 amount;
180         uint256 totalExcluded;
181         uint256 totalRealised;
182     }
183 
184     address[] shareholders;
185     mapping (address => uint256) shareholderIndexes;
186     mapping (address => uint256) shareholderClaims;
187     mapping (address => Share) public shares;
188 
189     uint256 public totalShares;
190     uint256 public totalDividends;
191     uint256 public totalDistributed;
192     uint256 public dividendsPerShare;
193     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
194 
195     uint256 public minPeriod = 30 minutes;
196     uint256 public minDistribution = 0 * (10 ** 9);
197 
198     uint256 public currentIndex;
199     bool initialized;
200 
201     modifier initialization() {
202         require(!initialized);
203         _;
204         initialized = true;
205     }
206 
207     modifier onlyToken() {
208         require(msg.sender == _token); _;
209     }
210 
211     constructor () {
212         _token = msg.sender;
213         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         INU = 0x050D94685c6B0477E1Fc555888AF6e2bB8dFBda5;
215     }
216     
217     receive() external payable {
218         deposit();
219     }
220 
221     function setInu(address inuAddress) external override onlyToken {
222         INU = inuAddress;
223     }
224 
225     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
226         minPeriod = newMinPeriod;
227         minDistribution = newMinDistribution;
228     }
229 
230     function setShare(address shareholder, uint256 amount) external override onlyToken {
231 
232         if(shares[shareholder].amount > 0){
233             distributeDividend(shareholder);
234         }
235 
236         if(amount > 0 && shares[shareholder].amount == 0){
237             addShareholder(shareholder);
238         }else if(amount == 0 && shares[shareholder].amount > 0){
239             removeShareholder(shareholder);
240         }
241 
242         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
243         shares[shareholder].amount = amount;
244         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
245     }
246 
247     function deposit() public payable override {
248 
249         uint256 balanceBefore = IERC20(INU).balanceOf(address(this));
250 
251         address[] memory path = new address[](2);
252         path[0] = router.WETH();
253         path[1] = address(INU);
254 
255         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261 
262         uint256 amount = IERC20(INU).balanceOf(address(this)).sub(balanceBefore);
263         totalDividends = totalDividends.add(amount);
264         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
265     }
266     
267     function process(uint256 gas) external override {
268         uint256 shareholderCount = shareholders.length;
269 
270         if(shareholderCount == 0) { return; }
271 
272         uint256 iterations = 0;
273         uint256 gasUsed = 0;
274         uint256 gasLeft = gasleft();
275 
276         while(gasUsed < gas && iterations < shareholderCount) {
277 
278             if(currentIndex >= shareholderCount){ currentIndex = 0; }
279 
280             if(shouldDistribute(shareholders[currentIndex])){
281                 distributeDividend(shareholders[currentIndex]);
282             }
283 
284             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
285             gasLeft = gasleft();
286             currentIndex++;
287             iterations++;
288         }
289     }
290     
291     function shouldDistribute(address shareholder) public view returns (bool) {
292         return shareholderClaims[shareholder] + minPeriod < block.timestamp
293                 && getUnpaidEarnings(shareholder) > minDistribution;
294     }
295 
296     function distributeDividend(address shareholder) internal {
297         if(shares[shareholder].amount == 0){ return; }
298 
299         uint256 amount = getUnpaidEarnings(shareholder);
300         if(amount > 0){
301             totalDistributed = totalDistributed.add(amount);
302             IERC20(INU).transfer(shareholder, amount);
303             shareholderClaims[shareholder] = block.timestamp;
304             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
305             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
306         }
307     }
308     
309     function feedDogs(address shareholder) external override onlyToken {
310         distributeDividend(shareholder);
311     }
312 
313     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
314         if(shares[shareholder].amount == 0){ return 0; }
315 
316         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
317         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
318 
319         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
320 
321         return shareholderTotalDividends.sub(shareholderTotalExcluded);
322     }
323 
324     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
325         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
326     }
327 
328     function addShareholder(address shareholder) internal {
329         shareholderIndexes[shareholder] = shareholders.length;
330         shareholders.push(shareholder);
331     }
332 
333     function removeShareholder(address shareholder) internal {
334         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
335         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
336         shareholders.pop();
337     }
338 }
339 
340 contract FeedTheInu is IERC20, Auth {
341     using SafeMath for uint256;
342 
343     address public INU = 0x050D94685c6B0477E1Fc555888AF6e2bB8dFBda5; //INU token
344 
345     string private constant _name = "Feed The Inu";
346     string private constant _symbol = "KIBBLE";
347     uint8 private constant _decimals = 18;
348     
349     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
350 
351     mapping(address => uint256) private _balances;
352     mapping(address => mapping(address => uint256)) private _allowances;
353     mapping (address => uint256) private cooldown;
354 
355     address private WETH;
356     address DEAD = 0x000000000000000000000000000000000000dEaD;
357     address ZERO = 0x0000000000000000000000000000000000000000;
358 
359     bool public antiBot = true;
360 
361     mapping (address => bool) private bots; 
362     mapping (address => bool) public isFeeExempt;
363     mapping (address => bool) public isTxLimitExempt;
364     mapping (address => bool) public isDividendExempt;
365 
366     uint256 public launchedAt;
367     address private lpWallet = DEAD;
368 
369     uint256 public buyFee = 10;
370     uint256 public sellFee = 10;
371 
372     uint256 public toReflections = 20;
373     uint256 public toLiquidity = 20;
374     uint256 public toMarketing = 50;
375 
376     uint256 public allocationSum = 100;
377 
378     IDEXRouter public router;
379     address public pair;
380     address public factory;
381     address private tokenOwner;
382     address public inuMarketingWallet = payable(0xc5b1350F8d5E841376fc88706A7915034a50FF3a);
383 
384     bool inSwapAndLiquify;
385     bool public swapAndLiquifyEnabled = true;
386     bool public tradingOpen = false;
387     
388     DogFood public dogFood;
389     uint256 public dogFoodGas = 0;
390 
391     modifier lockTheSwap {
392         inSwapAndLiquify = true;
393         _;
394         inSwapAndLiquify = false;
395     }
396 
397     uint256 public maxTx = _totalSupply.div(50);
398     uint256 public maxWallet = _totalSupply.div(50);
399     uint256 public swapThreshold = _totalSupply.div(100);
400 
401     constructor (
402         address _owner        
403     ) Auth(_owner) {
404         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
405             
406         WETH = router.WETH();
407         
408         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
409         
410         _allowances[address(this)][address(router)] = type(uint256).max;
411 
412         dogFood = new DogFood();
413         
414         isFeeExempt[_owner] = true;
415         isFeeExempt[inuMarketingWallet] = true;             
416 
417         isDividendExempt[pair] = true;
418         isDividendExempt[address(this)] = true;
419         isDividendExempt[DEAD] = true;    
420 
421         isTxLimitExempt[_owner] = true;
422         isTxLimitExempt[pair] = true;
423         isTxLimitExempt[DEAD] = true;    
424 
425 
426         _balances[_owner] = _totalSupply;
427     
428         emit Transfer(address(0), _owner, _totalSupply);
429     }
430 
431     receive() external payable { }
432 
433     function _setInu(address inuAddress) internal {
434         dogFood.setInu(inuAddress);
435     }
436 
437     function setInu(address inuAddress) external onlyOwner {
438         INU = inuAddress;
439         _setInu(inuAddress);
440     }
441 
442     function setBots(address[] memory bots_) external onlyOwner {
443         for (uint i = 0; i < bots_.length; i++) {
444             bots[bots_[i]] = true;
445         }
446     }
447     
448     //once enabled, cannot be reversed
449     function openTrading() external onlyOwner {
450         launchedAt = block.number;
451         tradingOpen = true;
452     }      
453 
454     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
455 
456         buyFee = newBuyFee;
457         sellFee = newSellFee;
458 
459         require(buyFee <= 10, "too high");
460         require(sellFee <= 10, "too high");
461     } 
462     
463     function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
464         toReflections = newRewardFee;
465         toLiquidity = newLpFee;
466         toMarketing = newMarketingFee;
467     }
468 
469     function changeTxLimit(uint256 newLimit) external onlyOwner {
470         maxTx = newLimit;
471     }
472 
473     function changeWalletLimit(uint256 newLimit) external onlyOwner {
474         maxWallet  = newLimit;
475     }
476     
477     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
478         isFeeExempt[holder] = exempt;
479     }
480 
481     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
482         isTxLimitExempt[holder] = exempt;
483     }
484 
485     function setMarketingWallet(address payable newMarketingWallet) external onlyOwner {
486         inuMarketingWallet = payable(newMarketingWallet);
487     }
488 
489     function setLpWallet(address newLpWallet) external onlyOwner {
490         lpWallet = newLpWallet;
491     }    
492 
493     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
494         tokenOwner = newOwnerWallet;
495     }     
496 
497     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
498         swapAndLiquifyEnabled  = enableSwapBack;
499         swapThreshold = newSwapBackLimit;
500     }
501 
502     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
503         dogFood.setDistributionCriteria(newMinPeriod, newMinDistribution);        
504     }
505 
506     function delBot(address notbot) external onlyOwner {
507         bots[notbot] = false;
508     }
509 
510     function _setIsDividendExempt(address holder, bool exempt) internal {
511         require(holder != address(this) && holder != pair);
512         isDividendExempt[holder] = exempt;
513         if(exempt){
514             dogFood.setShare(holder, 0);
515         }else{
516             dogFood.setShare(holder, _balances[holder]);
517         }
518     }
519 
520     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
521         _setIsDividendExempt(holder, exempt);
522     }
523 
524     function changeMoneyPrinterGas(uint256 newGas) external onlyOwner {
525         dogFoodGas = newGas;
526     }           
527 
528     function getCirculatingSupply() public view returns (uint256) {
529         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
530     }
531 
532     function totalSupply() external view override returns (uint256) { return _totalSupply; }
533     function decimals() external pure override returns (uint8) { return _decimals; }
534     function symbol() external pure override returns (string memory) { return _symbol; }
535     function name() external pure override returns (string memory) { return _name; }
536     function getOwner() external view override returns (address) { return owner; }
537     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
538     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
539     
540     function approve(address spender, uint256 amount) public override returns (bool) {
541         _allowances[msg.sender][spender] = amount;
542         emit Approval(msg.sender, spender, amount);
543         return true;
544     }
545 
546     function approveMax(address spender) external returns (bool) {
547         return approve(spender, type(uint256).max);
548     }
549 
550     function transfer(address recipient, uint256 amount) external override returns (bool) {
551         return _transfer(msg.sender, recipient, amount);
552     }
553 
554     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
555         if(_allowances[sender][msg.sender] != type(uint256).max){
556             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
557         }
558 
559         return _transfer(sender, recipient, amount);
560     }
561 
562     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
563         if (sender!= owner && recipient!= owner) require(tradingOpen, "hold ur horses big guy."); //transfers disabled before tradingActive
564         require(!bots[sender] && !bots[recipient]);
565 
566         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
567 
568         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
569 
570         if(!isTxLimitExempt[recipient] && antiBot)
571         {
572             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
573         }
574 
575         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
576 
577         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
578         
579         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
580         _balances[recipient] = _balances[recipient].add(finalAmount);
581 
582         // Dividend tracker
583         if(!isDividendExempt[sender]) {
584             try dogFood.setShare(sender, _balances[sender]) {} catch {}
585         }
586 
587         if(!isDividendExempt[recipient]) {
588             try dogFood.setShare(recipient, _balances[recipient]) {} catch {} 
589         }
590 
591         emit Transfer(sender, recipient, finalAmount);
592         return true;
593     }    
594 
595     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
596         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
597         _balances[recipient] = _balances[recipient].add(amount);
598         emit Transfer(sender, recipient, amount);
599         return true;
600     }  
601     
602     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
603         
604         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
605         uint256 feeAmount = amount.mul(feeApplicable).div(100);
606 
607         _balances[address(this)] = _balances[address(this)].add(feeAmount);
608         emit Transfer(sender, address(this), feeAmount);
609 
610         return amount.sub(feeAmount);
611     }
612     
613     function swapTokensForEth(uint256 tokenAmount) private {
614 
615         address[] memory path = new address[](2);
616         path[0] = address(this);
617         path[1] = router.WETH();
618 
619         approve(address(this), tokenAmount);
620 
621         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
622             tokenAmount,
623             0, // accept any amount of ETH
624             path,
625             address(this),
626             block.timestamp
627         );
628     }
629 
630     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
631         router.addLiquidityETH{value: ethAmount}(
632             address(this),
633             tokenAmount,
634             0,
635             0,
636             lpWallet,
637             block.timestamp
638         );
639     }
640 
641     function swapBack() internal lockTheSwap {
642     
643         uint256 tokenBalance = _balances[address(this)]; 
644         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
645         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);
646 
647         swapTokensForEth(amountToSwap);
648 
649         uint256 totalEthBalance = address(this).balance;
650         uint256 ethForInu = totalEthBalance.mul(toReflections).div(100);
651         uint256 ethForInuMarketing = totalEthBalance.mul(toMarketing).div(100);
652         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
653       
654         if (totalEthBalance > 0){
655             payable(inuMarketingWallet).transfer(ethForInuMarketing);
656         }
657         
658         try dogFood.deposit{value: ethForInu}() {} catch {}
659         
660         if (tokensForLiquidity > 0){
661             addLiquidity(tokensForLiquidity, ethForLiquidity);
662         }
663     }
664 
665     function manualSwapBack() external onlyOwner {
666         swapBack();
667     }
668 
669     function clearStuckEth() external onlyOwner {
670         uint256 contractETHBalance = address(this).balance;
671         if(contractETHBalance > 0){          
672             payable(address(this)).transfer(contractETHBalance);
673         }
674     }
675 
676     function manualProcessGas(uint256 manualGas) external onlyOwner {
677         dogFood.process(manualGas);
678     }
679 
680     function checkPendingReflections(address shareholder) external view returns (uint256) {
681         return dogFood.getUnpaidEarnings(shareholder);
682     }
683 
684     function manualClaim() external {
685         dogFood.feedDogs(msg.sender);
686     }
687 }