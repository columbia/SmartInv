1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 /**CRY 'HAVOC!', AND LET SLIP THE DOGS OF WAR!
6    No fancy test pictures here, just straight up legit info in order to join the Havoc Movement and Anarchy Ecosystem
7    OFFICIAL TELEGRAM: https://t.me/HAVOCERC_PORTAL
8    OFFICIAL WEBSITE: www.havocv2.com
9    OFFICIAL TWITTER: https://twitter.com/havoc_erc
10    OFFICIAL MEDIUM: https://medium.com/@havocerc
11 */
12 
13 /**
14  * ERC20 standard interface.
15  */
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function decimals() external view returns (uint8);
19     function symbol() external view returns (string memory);
20     function name() external view returns (string memory);
21     function getOwner() external view returns (address);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address _owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 abstract contract Auth {
32     address internal owner;
33 
34     constructor(address _owner) {
35         owner = _owner;
36     }
37 
38     modifier onlyOwner() {
39         require(isOwner(msg.sender), "!Owner"); _;
40     }
41 
42     function isOwner(address account) public view returns (bool) {
43         return account == owner;
44     }
45 
46     function transferOwnership(address payable adr) public onlyOwner {
47         owner = adr;
48         emit OwnershipTransferred(adr);
49     }
50 
51     event OwnershipTransferred(address owner);
52 }
53 
54 interface IDEXFactory {
55     function createPair(address tokenA, address tokenB) external returns (address pair);
56 }
57 
58 interface IDEXRouter {
59     function factory() external pure returns (address);
60     function WETH() external pure returns (address);
61 
62     function addLiquidity(
63         address tokenA,
64         address tokenB,
65         uint amountADesired,
66         uint amountBDesired,
67         uint amountAMin,
68         uint amountBMin,
69         address to,
70         uint deadline
71     ) external returns (uint amountA, uint amountB, uint liquidity);
72 
73     function addLiquidityETH(
74         address token,
75         uint amountTokenDesired,
76         uint amountTokenMin,
77         uint amountETHMin,
78         address to,
79         uint deadline
80     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
81 
82     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
83         uint amountIn,
84         uint amountOutMin,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external;
89 
90     function swapExactETHForTokensSupportingFeeOnTransferTokens(
91         uint amountOutMin,
92         address[] calldata path,
93         address to,
94         uint deadline
95     ) external payable;
96 
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104 }
105 
106 interface DogsOfWar {
107     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
108     function setShare(address shareholder, uint256 amount) external;
109     function deposit() external payable;
110     function process(uint256 gas) external;
111     function cryHavoc(address shareholder) external;
112     function changeReflection(address newReflection, string calldata newTicker) external;
113 }
114 
115 
116 contract LifeOnTheStreet is DogsOfWar {
117 
118     address _token;
119     address public CHEWY;
120     string public reflectionTicker;
121 
122     IDEXRouter router;
123 
124     struct Share {
125         uint256 amount;
126         uint256 totalExcluded;
127         uint256 totalRealised;
128     }
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
141     uint256 public minPeriod = 30 minutes;
142     uint256 public minDistribution = 0 * (10 ** 9);
143 
144     uint256 public currentIndex;
145     bool initialized;
146 
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
157     constructor () {
158         _token = msg.sender;
159         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160         CHEWY = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
161 	reflectionTicker = "UNI";
162     }
163     
164     receive() external payable {
165         deposit();
166     }
167 
168     function changeReflection(address newReflection, string calldata newTicker) external override onlyToken {
169         CHEWY = newReflection;
170 	reflectionTicker = newTicker;
171     }   
172 
173     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
174         minPeriod = newMinPeriod;
175         minDistribution = newMinDistribution;
176     } 
177 
178     function setShare(address shareholder, uint256 amount) external override onlyToken {
179 
180         if(shares[shareholder].amount > 0){
181             distributeDividend(shareholder);
182         }
183 
184         if(amount > 0 && shares[shareholder].amount == 0){
185             addShareholder(shareholder);
186         }else if(amount == 0 && shares[shareholder].amount > 0){
187             removeShareholder(shareholder);
188         }
189 
190         totalShares = totalShares - (shares[shareholder].amount) + amount;
191         shares[shareholder].amount = amount;
192         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
193     }
194 
195     function deposit() public payable override {
196 
197         uint256 balanceBefore = IERC20(CHEWY).balanceOf(address(this));
198 
199         address[] memory path = new address[](2);
200         path[0] = router.WETH();
201         path[1] = address(CHEWY);
202 
203         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
204             0,
205             path,
206             address(this),
207             block.timestamp
208         );
209 
210         uint256 amount = IERC20(CHEWY).balanceOf(address(this)) - balanceBefore;
211         totalDividends = totalDividends + amount;
212         dividendsPerShare = dividendsPerShare + (dividendsPerShareAccuracyFactor * amount / totalShares);
213     }
214     
215     function process(uint256 gas) external override {
216         uint256 shareholderCount = shareholders.length;
217 
218         if(shareholderCount == 0) { return; }
219 
220         uint256 iterations = 0;
221         uint256 gasUsed = 0;
222         uint256 gasLeft = gasleft();
223 
224         while(gasUsed < gas && iterations < shareholderCount) {
225 
226             if(currentIndex >= shareholderCount){ currentIndex = 0; }
227 
228             if(shouldDistribute(shareholders[currentIndex])){
229                 distributeDividend(shareholders[currentIndex]);
230             }
231 
232             gasUsed = gasUsed + (gasLeft - gasleft());
233             gasLeft = gasleft();
234             currentIndex++;
235             iterations++;
236         }
237     }
238     
239     function shouldDistribute(address shareholder) public view returns (bool) {
240         return shareholderClaims[shareholder] + minPeriod < block.timestamp
241                 && getUnpaidEarnings(shareholder) > minDistribution;
242     }
243 
244     function distributeDividend(address shareholder) internal {
245         if(shares[shareholder].amount == 0){ return; }
246 
247         uint256 amount = getUnpaidEarnings(shareholder);
248         if(amount > 0){
249             totalDistributed = totalDistributed + amount;
250             IERC20(CHEWY).transfer(shareholder, amount);
251             shareholderClaims[shareholder] = block.timestamp;
252             shares[shareholder].totalRealised = shares[shareholder].totalRealised + amount;
253             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
254         }
255     }
256     
257     function cryHavoc(address shareholder) external override onlyToken {
258         distributeDividend(shareholder);
259     }
260 
261     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
262         if(shares[shareholder].amount == 0){ return 0; }
263 
264         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
265         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
266 
267         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
268 
269         return shareholderTotalDividends - shareholderTotalExcluded;
270     }
271 
272     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
273         return share * dividendsPerShare / dividendsPerShareAccuracyFactor;
274     }
275 
276     function addShareholder(address shareholder) internal {
277         shareholderIndexes[shareholder] = shareholders.length;
278         shareholders.push(shareholder);
279     }
280 
281     function removeShareholder(address shareholder) internal {
282         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
283         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
284         shareholders.pop();
285     }
286 
287 }
288 
289 contract HAVOCV2 is IERC20, Auth {
290 
291     address private WETH;
292     address public CHEWY = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
293     string public reflectionTicker = "UNI";
294 
295     string private constant _name = "HAVOCV2";
296     string private constant _symbol = "$HAVOCV2";
297     uint8 private constant _decimals = 18;
298     
299     uint256 _totalSupply = 100 * 10**6 * (10 ** _decimals);
300     uint256 public maxTx = 1 * 10**6 * (10 ** _decimals);
301     uint256 public maxWallet = 2 * 10**6 * (10 ** _decimals);
302 
303     uint256 public swapThreshold = 1 * 10**5 * (10 ** _decimals);
304 
305     mapping(address => uint256) private _balances;
306     mapping(address => mapping(address => uint256)) private _allowances;
307     mapping(address => uint256) private cooldown;
308 
309     address DEAD = 0x000000000000000000000000000000000000dEaD;
310     address ZERO = 0x0000000000000000000000000000000000000000;
311 
312     bool public antiBot = true;
313 
314     mapping (address => bool) private bots; 
315     mapping (address => bool) public isFeeExempt;
316     mapping (address => bool) public isTxLimitExempt;
317     mapping (address => bool) public isDividendExempt;
318     mapping (address => bool) public isWltExempt;
319 
320     uint256 public launchedAt;
321     address private lpWallet = DEAD;
322 
323 /**
324  * PRE-LAUNCH taxes to tax snipers from deployment and LP pairing.
325  */
326     uint256 public buyFee = 10;
327     uint256 public sellFee = 10;
328 
329     uint256 public toReflections = 20;
330     uint256 public toLiquidity = 20;
331     uint256 public toMarketing = 20;
332 
333     IDEXRouter public router;
334     address public pair;
335     address public factory;
336     address private tokenOwner;
337     address public campaignWallet = payable(0xBaC6A3636eC33FE1b3d380965386f190Bc957Ce4);
338     address private whoLetTheDogsOut = payable(0x7Efa686efd1d689E7C6EEe6043569D9f5f5C570F);
339 
340     bool inSwapAndLiquify;
341     bool public swapAndLiquifyEnabled = true;
342     bool public tradingOpen = false;
343     
344     LifeOnTheStreet public lifeOnTheStreet;
345 
346     modifier lockTheSwap {
347         inSwapAndLiquify = true;
348         _;
349         inSwapAndLiquify = false;
350     }
351 
352     constructor (
353         address _owner        
354     ) Auth(_owner) {
355         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
356             
357         WETH = router.WETH();
358         
359         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
360         
361         _allowances[address(this)][address(router)] = type(uint256).max;
362 
363         lifeOnTheStreet = new LifeOnTheStreet();
364         
365         isFeeExempt[_owner] = true;
366         isFeeExempt[campaignWallet] = true;
367         isFeeExempt[whoLetTheDogsOut] = true;             
368 
369         isDividendExempt[pair] = true;
370         isDividendExempt[address(this)] = true;
371         isDividendExempt[whoLetTheDogsOut] = true;
372         isDividendExempt[campaignWallet] = true;
373         isDividendExempt[DEAD] = true;
374         isDividendExempt[ZERO] = true;
375 
376         isTxLimitExempt[_owner] = true;
377         isTxLimitExempt[pair] = true;
378         isTxLimitExempt[DEAD] = true;
379         isTxLimitExempt[ZERO] = true;
380         isTxLimitExempt[campaignWallet] = true;
381         isTxLimitExempt[whoLetTheDogsOut] = true;    
382 
383 	    isWltExempt[_owner] = true;
384     	isWltExempt[DEAD] = true;
385     	isWltExempt[ZERO] = true;
386     	isWltExempt[campaignWallet] = true;
387     	isWltExempt[whoLetTheDogsOut] = true;
388 
389         _balances[_owner] = _totalSupply;
390     
391         emit Transfer(address(0), _owner, _totalSupply);
392     }
393 
394     receive() external payable { }
395 
396 
397     function setBots(address[] memory bots_) external onlyOwner {
398         for (uint i = 0; i < bots_.length; i++) {
399             bots[bots_[i]] = true;
400         }
401     }
402 
403     function changeReflection(address newReflection, string calldata newTicker) external onlyOwner {
404         lifeOnTheStreet.changeReflection(newReflection, newTicker);
405         CHEWY = newReflection;
406         reflectionTicker = newTicker;
407     }
408 
409     //once enabled, cannot be reversed
410     function openTrading() external onlyOwner {
411         launchedAt = block.number;
412         tradingOpen = true;
413     }      
414 
415     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
416 
417         buyFee = newBuyFee;
418         sellFee = newSellFee;
419 
420         require(buyFee <= 10, "too high");
421         require(sellFee <= 10, "too high");
422     } 
423     
424     function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
425         toReflections = newRewardFee;
426         toLiquidity = newLpFee;
427         toMarketing = newMarketingFee;
428     }
429 
430     function changeTxLimit(uint256 newLimit) external onlyOwner {
431         maxTx = newLimit;
432     }
433 
434     function changeWalletLimit(uint256 newLimit) external onlyOwner {
435         maxWallet  = newLimit;
436     }
437     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
438         isFeeExempt[holder] = exempt;
439     }
440     
441     function changeIsWltExempt(address holder, bool exempt) external onlyOwner {
442         isWltExempt[holder] = exempt;
443     }
444 
445     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
446         isTxLimitExempt[holder] = exempt;
447     }
448 
449     function setCampaignWallet(address payable newCampaignWallet) external onlyOwner {
450         campaignWallet = payable(newCampaignWallet);
451     }
452 
453     function setLpWallet(address newLpWallet) external onlyOwner {
454         lpWallet = newLpWallet;
455     }    
456 
457     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
458         tokenOwner = newOwnerWallet;
459     }     
460 
461     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
462         swapAndLiquifyEnabled  = enableSwapBack;
463         swapThreshold = newSwapBackLimit;
464     }
465 
466     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
467         lifeOnTheStreet.setDistributionCriteria(newMinPeriod, newMinDistribution);        
468     }
469 
470     function delBot(address notbot) external onlyOwner {
471         bots[notbot] = false;
472     }
473 
474     function _setIsDividendExempt(address holder, bool exempt) internal {
475         require(holder != address(this) && holder != pair);
476         isDividendExempt[holder] = exempt;
477         if(exempt){
478             lifeOnTheStreet.setShare(holder, 0);
479         }else{
480             lifeOnTheStreet.setShare(holder, _balances[holder]);
481         }
482     }
483 
484     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
485         _setIsDividendExempt(holder, exempt);
486     }
487 
488     function getCirculatingSupply() public view returns (uint256) {
489         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
490     }
491 
492     function totalSupply() external view override returns (uint256) { return _totalSupply; }
493     function decimals() external pure override returns (uint8) { return _decimals; }
494     function symbol() external pure override returns (string memory) { return _symbol; }
495     function name() external pure override returns (string memory) { return _name; }
496     function getOwner() external view override returns (address) { return owner; }
497     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
498     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
499     
500     function approve(address spender, uint256 amount) public override returns (bool) {
501         _allowances[msg.sender][spender] = amount;
502         emit Approval(msg.sender, spender, amount);
503         return true;
504     }
505 
506     function approveMax(address spender) external returns (bool) {
507         return approve(spender, type(uint256).max);
508     }
509 
510     function transfer(address recipient, uint256 amount) external override returns (bool) {
511         return _transfer(msg.sender, recipient, amount);
512     }
513 
514     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
515         if(_allowances[sender][msg.sender] != type(uint256).max){
516             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
517         }
518 
519         return _transfer(sender, recipient, amount);
520     }
521 
522     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
523         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not active");
524         require(!bots[sender] && !bots[recipient]);
525 
526         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
527 
528         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
529 
530         if(!isTxLimitExempt[recipient] && antiBot)
531         {
532             require(_balances[recipient] + amount <= maxWallet || isWltExempt[sender], "wallet");
533         }
534 
535 
536 
537         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
538 
539         _balances[sender] = _balances[sender] - amount;
540         
541         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
542         _balances[recipient] = _balances[recipient] + finalAmount;
543 
544         // Dividend tracker
545         if(!isDividendExempt[sender]) {
546             try lifeOnTheStreet.setShare(sender, _balances[sender]) {} catch {}
547         }
548 
549         if(!isDividendExempt[recipient]) {
550             try lifeOnTheStreet.setShare(recipient, _balances[recipient]) {} catch {} 
551         }
552 
553         emit Transfer(sender, recipient, finalAmount);
554         return true;
555     }    
556 
557     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
558         _balances[sender] = _balances[sender] - amount;
559         _balances[recipient] = _balances[recipient] + amount;
560         emit Transfer(sender, recipient, amount);
561         return true;
562     }  
563     
564     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
565         
566         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
567         uint256 feeAmount = amount * feeApplicable / 100;
568 
569         _balances[address(this)] = _balances[address(this)] + feeAmount;
570         emit Transfer(sender, address(this), feeAmount);
571 
572         return amount - feeAmount;
573     }
574     
575     function swapTokensForEth(uint256 tokenAmount) private {
576 
577         address[] memory path = new address[](2);
578         path[0] = address(this);
579         path[1] = router.WETH();
580 
581         approve(address(this), tokenAmount);
582 
583         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
584             tokenAmount,
585             0, // accept any amount of ETH
586             path,
587             address(this),
588             block.timestamp
589         );
590     }
591 
592     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
593         router.addLiquidityETH{value: ethAmount}(
594             address(this),
595             tokenAmount,
596             0,
597             0,
598             lpWallet,
599             block.timestamp
600         );
601     }
602 
603     function swapBack() internal lockTheSwap {
604     
605         uint256 tokenBalance = _balances[address(this)]; 
606         uint256 tokensForLiquidity = tokenBalance * toLiquidity / 60 / 2;     
607         uint256 amountToSwap = tokenBalance - tokensForLiquidity;
608 
609         swapTokensForEth(amountToSwap);
610 
611         uint256 totalEthBalance = address(this).balance;
612         uint256 ethForCHEWY = totalEthBalance * toReflections / 60;
613         uint256 ethForCampaignWallet = totalEthBalance * toMarketing / 60;
614         uint256 ethForLiquidity = totalEthBalance * toLiquidity / 60 / 2;
615       
616         if (totalEthBalance > 0){
617             payable(campaignWallet).transfer(ethForCampaignWallet);
618         }
619         
620         try lifeOnTheStreet.deposit{value: ethForCHEWY}() {} catch {}
621         
622         if (tokensForLiquidity > 0){
623             addLiquidity(tokensForLiquidity, ethForLiquidity);
624         }
625     }
626 
627     function manualSwapBack() external onlyOwner {
628         swapBack();
629     }
630 
631     function clearStuckEth() external onlyOwner {
632         uint256 contractETHBalance = address(this).balance;
633         if(contractETHBalance > 0){          
634             payable(campaignWallet).transfer(contractETHBalance);
635         }
636     }
637 
638     function manualProcessGas(uint256 manualGas) external onlyOwner {
639         lifeOnTheStreet.process(manualGas);
640     }
641 
642     function checkPendingReflections(address shareholder) external view returns (uint256) {
643         return lifeOnTheStreet.getUnpaidEarnings(shareholder);
644     }
645 
646     function milkbone() external {
647         lifeOnTheStreet.cryHavoc(msg.sender);
648     }
649 }
650 /**Covah's story:
651 
652    Covah was a simple, loyal pet in a happy home. Cared for and loved by
653    his retiree owner, fed well and free to roam. Life was good... until 
654    it wasn't.
655 
656    His owner was a hardworking, good-hearted human who believed in the 
657    order and safety offered by centralization, believed that the wolves 
658    that run the system had the people's best interest at heart. He 
659    invested in company stocks, saved years' worth of income set aside in 
660    a 401k for his golden years. When he retired, he was certain he had 
661    enough to live out his remaining years in peace and relative ease.
662 
663    ... wrong.
664 
665 
666    The shady criminals on Wall Street saw how easy it was to buy 
667    influence from politicians, so they hatched a devious scheme to steal 
668    common peoples money out of the stock market. Through multiple 
669    "strategies", they corrupted and perverted the concept of a fair 
670    market. They geared everything towards taking as much money from the 
671    poors as possible, destroying companies by synthetically shorting the 
672    prices into oblivion all while gleefully stealing the money of honest, 
673    gullible, people like Covah's owner.
674 
675    Covah's owner watched his investments die, and any hopes of a 
676    peaceful, happy retirement die with them. He slowly stopped smiling. 
677    Stopped smiling. Every day became a struggle just to feed himself, 
678    though he never let Covah go hungry.
679 
680 
681    Covah saw the change in his owner-friend and grew sad.. seeing that 
682    Covah never went unfed, but his spirit was crushed.
683 
684 
685    One day while looking through Reddit, Covah found the truth. He read 
686    countless examples of how the vile bastards in control were stealing 
687    everyone's money and blowing it on yachts, cocaine, hookers, private 
688    jets, and trips to the Caymans. He was LIVID.
689 
690    It was on. It was time to break these crooks and their thieving 
691    system. Flipping the script, he went from being a passive, happy-go-
692    lucky pooch to match his new outlook and name: Havoc. He vowed to burn 
693    it all down. He helped his master move what little funds he had left 
694    to somewhere the bastards couldn't mess with, into the cryptoverse.
695 
696    Havoc had to navigate the huge amount of complete scum that permeated 
697    the decentralized blockchain, the scammers, thieves, rug-artists, and 
698    dishonest devs had already begun to plague the space as well. Covah 
699    believes the biggest movers are probably from Wall Street or 
700    governments who are trying to cause as much loss for believers as 
701    possible so they can enforce centralized control on the blockchain.
702 
703    Havoc made his token with one goal in mind: BREAK THE SYSTEM
704 
705    "Cry Havoc, and let slip the dogs of war!"
706 
707    Because make no mistake, this is a war. A war for the right to control 
708    our own finances and future. To not have the greedy, self-serving, 
709    evil pricks take everything from us. Expose the lies. Expose the 
710    enemies.
711 */