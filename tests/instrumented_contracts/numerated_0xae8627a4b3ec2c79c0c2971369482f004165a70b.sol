1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 /** 
6  * 🥓🍔 $BCNTR - Baconator 🥓🍔 is here to fuel $CRAMER coin’s moonward journey and beyond.
7  *
8  * https://www.baconatorcoin.com
9  *
10  */
11 
12 /**
13  * Standard SafeMath, stripped down to just add/sub/mul/div
14  */
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28 
29         return c;
30     }
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38 
39         return c;
40     }
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         // Solidity only automatically asserts when dividing by 0
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50         return c;
51     }
52 }
53 
54 /**
55  * ERC20 standard interface.
56  */
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function decimals() external view returns (uint8);
60     function symbol() external view returns (string memory);
61     function name() external view returns (string memory);
62     function getOwner() external view returns (address);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address _owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 abstract contract Auth {
73     address internal owner;
74 
75     constructor(address _owner) {
76         owner = _owner;
77     }
78 
79     /**
80      * Function modifier to require caller to be contract deployer
81      */
82     modifier onlyOwner() {
83         require(isOwner(msg.sender), "!Owner"); _;
84     }
85 
86     /**
87      * Check if address is owner
88      */
89     function isOwner(address account) public view returns (bool) {
90         return account == owner;
91     }
92 
93     function transferOwnership(address payable adr) public onlyOwner {
94         owner = adr;
95         emit OwnershipTransferred(adr);
96     }
97 
98     event OwnershipTransferred(address owner);
99 }
100 
101 interface IDEXFactory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IDEXRouter {
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108 
109     function addLiquidity(
110         address tokenA,
111         address tokenB,
112         uint amountADesired,
113         uint amountBDesired,
114         uint amountAMin,
115         uint amountBMin,
116         address to,
117         uint deadline
118     ) external returns (uint amountA, uint amountB, uint liquidity);
119 
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 
129     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136 
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143 
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 interface IAmLisaCramer {
154     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
155     function setShare(address shareholder, uint256 amount) external;
156     function deposit() external payable;
157     function process(uint256 gas) external;
158     function gibBaconator(address shareholder) external;
159 }
160 
161 
162 contract LisaCramer is IAmLisaCramer {
163 
164     using SafeMath for uint256;
165     address _token;
166 
167     address public CRAMER;
168 
169     IDEXRouter router;
170 
171     struct Share {
172         uint256 amount;
173         uint256 totalExcluded;
174         uint256 totalRealised;
175     }
176 
177     address[] shareholders;
178     mapping (address => uint256) shareholderIndexes;
179     mapping (address => uint256) shareholderClaims;
180     mapping (address => Share) public shares;
181 
182     uint256 public totalShares;
183     uint256 public totalDividends;
184     uint256 public totalDistributed;
185     uint256 public dividendsPerShare;
186     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
187 
188     uint256 public minPeriod = 30 minutes;
189     uint256 public minDistribution = 0 * (10 ** 9);
190 
191     uint256 public currentIndex;
192     bool initialized;
193 
194     modifier initialization() {
195         require(!initialized);
196         _;
197         initialized = true;
198     }
199 
200     modifier onlyToken() {
201         require(msg.sender == _token); _;
202     }
203 
204     constructor () {
205         _token = msg.sender;
206         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
207         CRAMER = 0x64Df3aAB3b21cC275bB76c4A581Cf8B726478ee0;
208     }
209     
210     receive() external payable {
211         deposit();
212     }
213 
214     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
215         minPeriod = newMinPeriod;
216         minDistribution = newMinDistribution;
217     }
218 
219     function setShare(address shareholder, uint256 amount) external override onlyToken {
220 
221         if(shares[shareholder].amount > 0){
222             distributeDividend(shareholder);
223         }
224 
225         if(amount > 0 && shares[shareholder].amount == 0){
226             addShareholder(shareholder);
227         }else if(amount == 0 && shares[shareholder].amount > 0){
228             removeShareholder(shareholder);
229         }
230 
231         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
232         shares[shareholder].amount = amount;
233         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
234     }
235 
236     function deposit() public payable override {
237 
238         uint256 balanceBefore = IERC20(CRAMER).balanceOf(address(this));
239 
240         address[] memory path = new address[](2);
241         path[0] = router.WETH();
242         path[1] = address(CRAMER);
243 
244         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
245             0,
246             path,
247             address(this),
248             block.timestamp
249         );
250 
251         uint256 amount = IERC20(CRAMER).balanceOf(address(this)).sub(balanceBefore);
252         totalDividends = totalDividends.add(amount);
253         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
254     }
255     
256     function process(uint256 gas) external override {
257         uint256 shareholderCount = shareholders.length;
258 
259         if(shareholderCount == 0) { return; }
260 
261         uint256 iterations = 0;
262         uint256 gasUsed = 0;
263         uint256 gasLeft = gasleft();
264 
265         while(gasUsed < gas && iterations < shareholderCount) {
266 
267             if(currentIndex >= shareholderCount){ currentIndex = 0; }
268 
269             if(shouldDistribute(shareholders[currentIndex])){
270                 distributeDividend(shareholders[currentIndex]);
271             }
272 
273             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
274             gasLeft = gasleft();
275             currentIndex++;
276             iterations++;
277         }
278     }
279     
280     function shouldDistribute(address shareholder) public view returns (bool) {
281         return shareholderClaims[shareholder] + minPeriod < block.timestamp
282                 && getUnpaidEarnings(shareholder) > minDistribution;
283     }
284 
285     function distributeDividend(address shareholder) internal {
286         if(shares[shareholder].amount == 0){ return; }
287 
288         uint256 amount = getUnpaidEarnings(shareholder);
289         if(amount > 0){
290             totalDistributed = totalDistributed.add(amount);
291             IERC20(CRAMER).transfer(shareholder, amount);
292             shareholderClaims[shareholder] = block.timestamp;
293             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
294             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
295         }
296     }
297     
298     function gibBaconator(address shareholder) external override onlyToken {
299         distributeDividend(shareholder);
300     }
301 
302     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
303         if(shares[shareholder].amount == 0){ return 0; }
304 
305         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
306         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
307 
308         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
309 
310         return shareholderTotalDividends.sub(shareholderTotalExcluded);
311     }
312 
313     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
314         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
315     }
316 
317     function addShareholder(address shareholder) internal {
318         shareholderIndexes[shareholder] = shareholders.length;
319         shareholders.push(shareholder);
320     }
321 
322     function removeShareholder(address shareholder) internal {
323         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
324         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
325         shareholders.pop();
326     }
327 }
328 
329 contract Baconator is IERC20, Auth {
330     using SafeMath for uint256;
331 
332     address public CRAMER = 0x64Df3aAB3b21cC275bB76c4A581Cf8B726478ee0; //CRAMER COIN
333 
334     string private constant _name = "Baconator";
335     string private constant _symbol = "BCNTR";
336     uint8 private constant _decimals = 18;
337     
338     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
339 
340     mapping(address => uint256) private _balances;
341     mapping(address => mapping(address => uint256)) private _allowances;
342     mapping (address => uint256) private cooldown;
343 
344     address private WETH;
345     address DEAD = 0x000000000000000000000000000000000000dEaD;
346     address ZERO = 0x0000000000000000000000000000000000000000;
347 
348     bool public antiBot = true;
349 
350     mapping (address => bool) private bots; 
351     mapping (address => bool) public isFeeExempt;
352     mapping (address => bool) public isTxLimitExempt;
353     mapping (address => bool) public isDividendExempt;
354 
355     uint256 public launchedAt;
356     address public lpWallet = DEAD;
357 
358     uint256 public buyFee = 10;
359     uint256 public sellFee = 10;
360 
361     uint256 public toReflections = 40;
362     uint256 public toLiquidity = 20;
363     uint256 public toMarketing = 40;
364 
365     uint256 public allocationSum = 100;
366 
367     IDEXRouter public router;
368     address public pair;
369     address public factory;
370     address private tokenOwner;
371     address public lisaWallet = payable(0x1379E6f3863584fd4d004922297eCee5A6A0C65b);
372 
373     bool inSwapAndLiquify;
374     bool public swapAndLiquifyEnabled = true;
375     bool public tradingOpen = false;
376     
377     LisaCramer public lisaCramer;
378     uint256 public lisaCramerGas = 0;
379 
380     modifier lockTheSwap {
381         inSwapAndLiquify = true;
382         _;
383         inSwapAndLiquify = false;
384     }
385 
386     uint256 public maxTx = _totalSupply.div(100);
387     uint256 public maxWallet = _totalSupply.div(50);
388     uint256 public swapThreshold = _totalSupply.div(400);
389 
390     constructor (
391         address _owner        
392     ) Auth(_owner) {
393         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
394             
395         WETH = router.WETH();
396         
397         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
398         
399         _allowances[address(this)][address(router)] = type(uint256).max;
400 
401         lisaCramer = new LisaCramer();
402         
403         isFeeExempt[_owner] = true;
404         isFeeExempt[lisaWallet] = true;            
405 
406         isDividendExempt[pair] = true;
407         isDividendExempt[address(this)] = true;
408         isDividendExempt[DEAD] = true;    
409 
410         isTxLimitExempt[_owner] = true;
411         isTxLimitExempt[pair] = true;
412         isTxLimitExempt[DEAD] = true;
413         isTxLimitExempt[lisaWallet] = true;  
414 
415 
416         _balances[_owner] = _totalSupply;
417     
418         emit Transfer(address(0), _owner, _totalSupply);
419     }
420 
421     receive() external payable { }
422 
423 
424     function setBots(address[] memory bots_) external onlyOwner {
425         for (uint i = 0; i < bots_.length; i++) {
426             bots[bots_[i]] = true;
427         }
428     }
429     
430     //once enabled, cannot be reversed
431     function openTrading() external onlyOwner {
432         launchedAt = block.number;
433         tradingOpen = true;
434     }      
435 
436     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
437 
438         buyFee = newBuyFee;
439         sellFee = newSellFee;
440 
441         require(buyFee <= 10, "too high");
442         require(sellFee <= 10, "too high");
443     } 
444     
445     function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
446         toReflections = newRewardFee;
447         toLiquidity = newLpFee;
448         toMarketing = newMarketingFee;
449     }
450 
451     function changeTxLimit(uint256 newLimit) external onlyOwner {
452         maxTx = newLimit;
453     }
454 
455     function changeWalletLimit(uint256 newLimit) external onlyOwner {
456         maxWallet  = newLimit;
457     }
458     
459     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
460         isFeeExempt[holder] = exempt;
461     }
462 
463     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
464         isTxLimitExempt[holder] = exempt;
465     }
466 
467     function setLisaWallet(address payable newLisaWallet) external onlyOwner {
468         lisaWallet = payable(newLisaWallet);
469     }
470 
471     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
472         tokenOwner = newOwnerWallet;
473     }     
474 
475     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
476         swapAndLiquifyEnabled  = enableSwapBack;
477         swapThreshold = newSwapBackLimit;
478     }
479 
480     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
481         lisaCramer.setDistributionCriteria(newMinPeriod, newMinDistribution);        
482     }
483 
484     function delBot(address notbot) external onlyOwner {
485         bots[notbot] = false;
486     }
487 
488     function _setIsDividendExempt(address holder, bool exempt) internal {
489         require(holder != address(this) && holder != pair);
490         isDividendExempt[holder] = exempt;
491         if(exempt){
492             lisaCramer.setShare(holder, 0);
493         }else{
494             lisaCramer.setShare(holder, _balances[holder]);
495         }
496     }
497 
498     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
499         _setIsDividendExempt(holder, exempt);
500     }
501 
502     function changeLisaCramerGas(uint256 newGas) external onlyOwner {
503         lisaCramerGas = newGas;
504     }           
505 
506     function getCirculatingSupply() public view returns (uint256) {
507         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
508     }
509 
510     function totalSupply() external view override returns (uint256) { return _totalSupply; }
511     function decimals() external pure override returns (uint8) { return _decimals; }
512     function symbol() external pure override returns (string memory) { return _symbol; }
513     function name() external pure override returns (string memory) { return _name; }
514     function getOwner() external view override returns (address) { return owner; }
515     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
516     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
517     
518     function approve(address spender, uint256 amount) public override returns (bool) {
519         _allowances[msg.sender][spender] = amount;
520         emit Approval(msg.sender, spender, amount);
521         return true;
522     }
523 
524     function approveMax(address spender) external returns (bool) {
525         return approve(spender, type(uint256).max);
526     }
527 
528     function transfer(address recipient, uint256 amount) external override returns (bool) {
529         return _transfer(msg.sender, recipient, amount);
530     }
531 
532     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
533         if(_allowances[sender][msg.sender] != type(uint256).max){
534             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
535         }
536 
537         return _transfer(sender, recipient, amount);
538     }
539 
540     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
541         if (sender!= owner && recipient!= owner) require(tradingOpen, "hold ur horses big guy."); //transfers disabled before tradingActive
542         require(!bots[sender] && !bots[recipient]);
543 
544         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
545 
546         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
547 
548         if(!isTxLimitExempt[recipient] && antiBot)
549         {
550             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
551         }
552 
553         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
554 
555         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
556         
557         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
558         _balances[recipient] = _balances[recipient].add(finalAmount);
559 
560         // Dividend tracker
561         if(!isDividendExempt[sender]) {
562             try lisaCramer.setShare(sender, _balances[sender]) {} catch {}
563         }
564 
565         if(!isDividendExempt[recipient]) {
566             try lisaCramer.setShare(recipient, _balances[recipient]) {} catch {} 
567         }
568 
569         emit Transfer(sender, recipient, finalAmount);
570         return true;
571     }    
572 
573     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
574         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
575         _balances[recipient] = _balances[recipient].add(amount);
576         emit Transfer(sender, recipient, amount);
577         return true;
578     }  
579     
580     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
581         
582         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
583         uint256 feeAmount = amount.mul(feeApplicable).div(100);
584 
585         _balances[address(this)] = _balances[address(this)].add(feeAmount);
586         emit Transfer(sender, address(this), feeAmount);
587 
588         return amount.sub(feeAmount);
589     }
590     
591     function swapTokensForEth(uint256 tokenAmount) private {
592 
593         address[] memory path = new address[](2);
594         path[0] = address(this);
595         path[1] = router.WETH();
596 
597         approve(address(this), tokenAmount);
598 
599         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
600             tokenAmount,
601             0, // accept any amount of ETH
602             path,
603             address(this),
604             block.timestamp
605         );
606     }
607 
608     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
609         router.addLiquidityETH{value: ethAmount}(
610             address(this),
611             tokenAmount,
612             0,
613             0,
614             lpWallet,
615             block.timestamp
616         );
617     }
618 
619     function swapBack() internal lockTheSwap {
620     
621         uint256 tokenBalance = _balances[address(this)]; 
622         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
623         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);
624 
625         swapTokensForEth(amountToSwap);
626 
627         uint256 totalEthBalance = address(this).balance;
628         uint256 ethForCRAMER = totalEthBalance.mul(toReflections).div(100);
629         uint256 ethForLisa = totalEthBalance.mul(toMarketing).div(100);
630         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
631       
632         if (totalEthBalance > 0){
633             payable(lisaWallet).transfer(ethForLisa);
634         }
635         
636         try lisaCramer.deposit{value: ethForCRAMER}() {} catch {}
637         
638         if (tokensForLiquidity > 0){
639             addLiquidity(tokensForLiquidity, ethForLiquidity);
640         }
641     }
642 
643     function manualSwapBack() external onlyOwner {
644         swapBack();
645     }
646 
647     function clearStuckEth() external onlyOwner {
648         uint256 contractETHBalance = address(this).balance;
649         if(contractETHBalance > 0){          
650             payable(lisaWallet).transfer(contractETHBalance);
651         }
652     }
653 
654     function manualProcessGas(uint256 manualGas) external onlyOwner {
655         lisaCramer.process(manualGas);
656     }
657 
658     function checkPendingReflections(address shareholder) external view returns (uint256) {
659         return lisaCramer.getUnpaidEarnings(shareholder);
660     }
661 
662     function getBaconator() external {
663         lisaCramer.gibBaconator(msg.sender);
664     }
665 }