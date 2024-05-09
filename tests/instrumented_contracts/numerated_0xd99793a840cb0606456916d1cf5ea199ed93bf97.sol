1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 /**
6                                            .                                              
7                                           +%:                                             
8                                          .%%%                                             
9                                          +%%%:                                            
10                                          *%%%*                                            
11                                          #%%%%+                                           
12                                         =%%%%%%:                                          
13                                         *%%%%%%#                                          
14                                        .%%%%%%%%:                                         
15                                       +%%%%%%%%%%                                         
16                                     .*%%%%%%%%%%%#****=:                                  
17                                .:=+#%%%%%%%%%%%%%%%%%%%%#+-                               
18                           :+*##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#*-:                          
19                         -*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#=                        
20                       :*%%%%%%%%%%%%%%%%%%#=%%%%%%%%%%%%%%%%%%%%%%*:                      
21                    .*%%%%%%%%%%%%%*%%%%%%%: -%%%%%%%*+%%%%%%%%%%%%%%#=.                   
22                   -%%%%%%%%%%%%=-..%%%%%%=   %%%%%%%#  .=+%%%%%%%%%%%%%:             .--- 
23                  +%%%%%%%%%%+-    #%%%%%#    .%%%%%%%-     :=%%%%%%%%%%%+:.. ..-=*+#%%%%%:
24                :#%%%%%%%%#=      +%%%%%%*     -%%%%%%%-      .=%%%%%%%%%%%%%%%%%%%%%%#=-. 
25               .%%%%%%%%%=       =%%%%%%%:      =%%%%%%%-       .*%%%%%%%%%%%%%%%%%#-      
26              :%%%%%%%%*        :%%%%%%%#        *%%%%%%%.   .-+#%%%%%%%%%%%%%%%%#-        
27             -%%%%%%%%+         %%%%%%%+          *%%%%%%**#%%%%%%%%%%%%%%%%%%#=:          
28             #%%%%%%%*         -%%%%%%%:          :%%%%%%%%%%%%%%%%%%%%%%%%%%%             
29            #%%%%%%%%         :%%%%%%%+      .=*#%%%%%%%%%%%%%%%%%#+: .%%%%%%%             
30           =%%%%%%%%-         +%%%%%%*:-=+*#%%%%%%%%%%%%%%%%%*=-       %%%%%%%-            
31          :#%%%%%%%%         .%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%+        .%%%%%%%:            
32          =%%%%%%%%=     -*#%%%%%%%%%%%%%%%%%%%%%#*+=+%%%%%%%%-       :%%%%%%%:            
33          .%%%%%%%%-.=*#%%%%%%%%%%%%%%%%%###=.        .#%%%%%%#.      -%%%%%%%.            
34           *%%%%%%%#%%%%%%%%%%%%%%%%#=.                =%%%%%%%*      +%%%%%%%.            
35           -%%%%%%%%%%%%%%%%%%%%%%%-                   .%%%%%%%%:    .%%%%%%%*             
36          :#%%%%%%%%%%%%%%%%%%%%%%-                     -%%%%%%%-    *%%%%%%%%             
37       .=#%%%%%%%%%%%#+=+%%%%%%%%:                       #%%%%%%%.  +%%%%%%%%-             
38    .-#%%%%%%%%%%%%%*   *%%%%%%%-                        .%%%%%%%+:.%%%%%%%%-              
39 .=#%%%%%%%**%%%%%%%%: =%%%%%%%*                          :#%%%%%%%%%%%%%%%*               
40 :%%%#*=-:.  =%%%%%%%%*#%%%%%%%.                           =%%%%%%%%%%%%%%%-               
41              -%%%%%%%%%%%%%%%#                             #%%%%%%%%%%%%+.                
42                =#%%%%%%%%%%%%#.                            :%%%%%%%%%%%:                  
43                  =#%%%%%%%%%%%%%*+: .                   :+%%%%%%%%%%%%=                   
44                    -%%%%%%%%%%%%%%%%%#+=.:.      .:-+*#%%%%%%%%%%%%%%%*                   
45                     *%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#                   
46                     *%%%%= .=#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*=: *#%%%%%.                  
47                    :%%%%*     .=++*#%%%%%%%%%%%%%%%%%%%#+=.       *%%%%#                  
48                    *%%%#              :----==+++==----.           .%%%%%:                 
49                    %%%%.                                           .=%%%#                 
50                    =*+-                                              .+*+   
51                 
52 
53                                 $CHAOS -- FVCK THE SYSTEM
54 
55                 INSPIRED BY $ANARCHY AND CREATED BY ANARCHISTS, FOR ANARCHISTS              
56                                  t.me/fvckthesystemtoken
57 
58         TOKEN SPECS: 
59             10M SUPPLY (40% BURNED AT LAUNCH, 10% SENT TO ANARCHYINITIATOR.ETH)
60             MAX WALLET/TX: 2%
61             ALL TAXES GO TOWARDS: 
62                 A) $ANARCHY REFLECTIONS 
63                 B) BURNING $CHAOS LIQUIDITY
64                 C) ETH CONTROLLED BY ANARCHISTS TO BRING DOWN THE SYSTEM
65     
66 */
67 
68 
69 /**
70  * Standard SafeMath, stripped down to just add/sub/mul/div
71  */
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76 
77         return c;
78     }
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85 
86         return c;
87     }
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         // Solidity only automatically asserts when dividing by 0
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 }
110 
111 /**
112  * ERC20 standard interface.
113  */
114 interface IERC20 {
115     function totalSupply() external view returns (uint256);
116     function decimals() external view returns (uint8);
117     function symbol() external view returns (string memory);
118     function name() external view returns (string memory);
119     function getOwner() external view returns (address);
120     function balanceOf(address account) external view returns (uint256);
121     function transfer(address recipient, uint256 amount) external returns (bool);
122     function allowance(address _owner, address spender) external view returns (uint256);
123     function approve(address spender, uint256 amount) external returns (bool);
124     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
125     event Transfer(address indexed from, address indexed to, uint256 value);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 abstract contract Auth {
130     address internal owner;
131 
132     constructor(address _owner) {
133         owner = _owner;
134     }
135 
136     /**
137      * Function modifier to require caller to be contract deployer
138      */
139     modifier onlyOwner() {
140         require(isOwner(msg.sender), "!Owner"); _;
141     }
142 
143     /**
144      * Check if address is owner
145      */
146     function isOwner(address account) public view returns (bool) {
147         return account == owner;
148     }
149 
150     function transferOwnership(address payable adr) public onlyOwner {
151         owner = adr;
152         emit OwnershipTransferred(adr);
153     }
154 
155     event OwnershipTransferred(address owner);
156 }
157 
158 interface IDEXFactory {
159     function createPair(address tokenA, address tokenB) external returns (address pair);
160 }
161 
162 interface IDEXRouter {
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165 
166     function addLiquidity(
167         address tokenA,
168         address tokenB,
169         uint amountADesired,
170         uint amountBDesired,
171         uint amountAMin,
172         uint amountBMin,
173         address to,
174         uint deadline
175     ) external returns (uint amountA, uint amountB, uint liquidity);
176 
177     function addLiquidityETH(
178         address token,
179         uint amountTokenDesired,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline
184     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
185 
186     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193 
194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external payable;
200 
201     function swapExactTokensForETHSupportingFeeOnTransferTokens(
202         uint amountIn,
203         uint amountOutMin,
204         address[] calldata path,
205         address to,
206         uint deadline
207     ) external;
208 }
209 
210 interface IAmAnAnarchist {
211     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
212     function setShare(address shareholder, uint256 amount) external;
213     function deposit() external payable;
214     function process(uint256 gas) external;
215     function fuckTheSystem(address shareholder) external;
216 }
217 
218 
219 contract AnarchyDist is IAmAnAnarchist {
220 
221     using SafeMath for uint256;
222     address _token;
223 
224     address public ANARCHY;
225 
226     IDEXRouter router;
227 
228     struct Share {
229         uint256 amount;
230         uint256 totalExcluded;
231         uint256 totalRealised;
232     }
233 
234     address[] shareholders;
235     mapping (address => uint256) shareholderIndexes;
236     mapping (address => uint256) shareholderClaims;
237     mapping (address => Share) public shares;
238 
239     uint256 public totalShares;
240     uint256 public totalDividends;
241     uint256 public totalDistributed;
242     uint256 public dividendsPerShare;
243     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
244 
245     uint256 public minPeriod = 30 minutes;
246     uint256 public minDistribution = 0 * (10 ** 9);
247 
248     uint256 public currentIndex;
249     bool initialized;
250 
251     modifier initialization() {
252         require(!initialized);
253         _;
254         initialized = true;
255     }
256 
257     modifier onlyToken() {
258         require(msg.sender == _token); _;
259     }
260 
261     constructor () {
262         _token = msg.sender;
263         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
264         ANARCHY = 0x53fD2342B43eCD24AEf1535BC3797F509616Ce8c;
265     }
266     
267     receive() external payable {
268         deposit();
269     }
270 
271     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
272         minPeriod = newMinPeriod;
273         minDistribution = newMinDistribution;
274     }
275 
276     function setShare(address shareholder, uint256 amount) external override onlyToken {
277 
278         if(shares[shareholder].amount > 0){
279             distributeDividend(shareholder);
280         }
281 
282         if(amount > 0 && shares[shareholder].amount == 0){
283             addShareholder(shareholder);
284         }else if(amount == 0 && shares[shareholder].amount > 0){
285             removeShareholder(shareholder);
286         }
287 
288         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
289         shares[shareholder].amount = amount;
290         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
291     }
292 
293     function deposit() public payable override {
294 
295         uint256 balanceBefore = IERC20(ANARCHY).balanceOf(address(this));
296 
297         address[] memory path = new address[](2);
298         path[0] = router.WETH();
299         path[1] = address(ANARCHY);
300 
301         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
302             0,
303             path,
304             address(this),
305             block.timestamp
306         );
307 
308         uint256 amount = IERC20(ANARCHY).balanceOf(address(this)).sub(balanceBefore);
309         totalDividends = totalDividends.add(amount);
310         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
311     }
312     
313     function process(uint256 gas) external override {
314         uint256 shareholderCount = shareholders.length;
315 
316         if(shareholderCount == 0) { return; }
317 
318         uint256 iterations = 0;
319         uint256 gasUsed = 0;
320         uint256 gasLeft = gasleft();
321 
322         while(gasUsed < gas && iterations < shareholderCount) {
323 
324             if(currentIndex >= shareholderCount){ currentIndex = 0; }
325 
326             if(shouldDistribute(shareholders[currentIndex])){
327                 distributeDividend(shareholders[currentIndex]);
328             }
329 
330             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
331             gasLeft = gasleft();
332             currentIndex++;
333             iterations++;
334         }
335     }
336     
337     function shouldDistribute(address shareholder) public view returns (bool) {
338         return shareholderClaims[shareholder] + minPeriod < block.timestamp
339                 && getUnpaidEarnings(shareholder) > minDistribution;
340     }
341 
342     function distributeDividend(address shareholder) internal {
343         if(shares[shareholder].amount == 0){ return; }
344 
345         uint256 amount = getUnpaidEarnings(shareholder);
346         if(amount > 0){
347             totalDistributed = totalDistributed.add(amount);
348             IERC20(ANARCHY).transfer(shareholder, amount);
349             shareholderClaims[shareholder] = block.timestamp;
350             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
351             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
352         }
353     }
354     
355     function fuckTheSystem(address shareholder) external override onlyToken {
356         distributeDividend(shareholder);
357     }
358 
359     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
360         if(shares[shareholder].amount == 0){ return 0; }
361 
362         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
363         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
364 
365         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
366 
367         return shareholderTotalDividends.sub(shareholderTotalExcluded);
368     }
369 
370     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
371         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
372     }
373 
374     function addShareholder(address shareholder) internal {
375         shareholderIndexes[shareholder] = shareholders.length;
376         shareholders.push(shareholder);
377     }
378 
379     function removeShareholder(address shareholder) internal {
380         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
381         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
382         shareholders.pop();
383     }
384 }
385 
386 contract FvckTheSystem is IERC20, Auth {
387     using SafeMath for uint256;
388 
389     address public Anarchy = 0x53fD2342B43eCD24AEf1535BC3797F509616Ce8c; //Anarchy token
390 
391     string private constant _name = "Fvck The System";
392     string private constant _symbol = "CHAOS";
393     uint8 private constant _decimals = 18;
394     
395     uint256 private _totalSupply = 10000000 * (10 ** _decimals);
396 
397     mapping(address => uint256) private _balances;
398     mapping(address => mapping(address => uint256)) private _allowances;
399     mapping (address => uint256) private cooldown;
400 
401     address private WETH;
402     address DEAD = 0x000000000000000000000000000000000000dEaD;
403     address ZERO = 0x0000000000000000000000000000000000000000;
404 
405     bool public antiBot = true;
406 
407     mapping (address => bool) private bots; 
408     mapping (address => bool) public isFeeExempt;
409     mapping (address => bool) public isTxLimitExempt;
410     mapping (address => bool) public isDividendExempt;
411 
412     uint256 public launchedAt;
413     address private lpWallet = DEAD;
414 
415     uint256 public buyFee = 10;
416     uint256 public sellFee = 15;
417 
418     uint256 public toReflections = 30;
419     uint256 public toLiquidity = 20;
420     uint256 public toMarketing = 50;
421 
422     uint256 public allocationSum = 100;
423 
424     IDEXRouter public router;
425     address public pair;
426     address public factory;
427     address private tokenOwner;
428     address public anarchyWallet = payable(0x2969dCDCB643Bc0979bA0bEcE76C25F99a7758D5);
429     address private anarchyinitiator = payable(0x7300e9eeA578f775230DEd8C1E0E531386C423B3);
430 
431     bool inSwapAndLiquify;
432     bool public swapAndLiquifyEnabled = true;
433     bool public tradingOpen = false;
434     
435     AnarchyDist public anarchyDist;
436     uint256 public anarchyDistGas = 0;
437 
438     modifier lockTheSwap {
439         inSwapAndLiquify = true;
440         _;
441         inSwapAndLiquify = false;
442     }
443 
444     uint256 public maxTx = _totalSupply.div(50);
445     uint256 public maxWallet = _totalSupply.div(50);
446     uint256 public swapThreshold = _totalSupply.div(100);
447 
448     constructor (
449         address _owner        
450     ) Auth(_owner) {
451         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
452             
453         WETH = router.WETH();
454         
455         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
456         
457         _allowances[address(this)][address(router)] = type(uint256).max;
458 
459         anarchyDist = new AnarchyDist();
460         
461         isFeeExempt[_owner] = true;
462         isFeeExempt[anarchyWallet] = true;
463         isFeeExempt[anarchyinitiator] = true;             
464 
465         isDividendExempt[pair] = true;
466         isDividendExempt[address(this)] = true;
467         isDividendExempt[anarchyinitiator] = true;
468         isDividendExempt[DEAD] = true;    
469 
470         isTxLimitExempt[_owner] = true;
471         isTxLimitExempt[pair] = true;
472         isTxLimitExempt[DEAD] = true;
473         isTxLimitExempt[anarchyWallet] = true;
474         isTxLimitExempt[anarchyinitiator] = true;    
475 
476 
477         _balances[_owner] = _totalSupply;
478     
479         emit Transfer(address(0), _owner, _totalSupply);
480     }
481 
482     receive() external payable { }
483 
484 
485     function setBots(address[] memory bots_) external onlyOwner {
486         for (uint i = 0; i < bots_.length; i++) {
487             bots[bots_[i]] = true;
488         }
489     }
490     
491     //once enabled, cannot be reversed
492     function openTrading() external onlyOwner {
493         launchedAt = block.number;
494         tradingOpen = true;
495     }      
496 
497     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
498 
499         buyFee = newBuyFee;
500         sellFee = newSellFee;
501 
502         require(buyFee <= 10, "too high");
503         require(sellFee <= 10, "too high");
504     } 
505     
506     function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
507         toReflections = newRewardFee;
508         toLiquidity = newLpFee;
509         toMarketing = newMarketingFee;
510     }
511 
512     function changeTxLimit(uint256 newLimit) external onlyOwner {
513         maxTx = newLimit;
514     }
515 
516     function changeWalletLimit(uint256 newLimit) external onlyOwner {
517         maxWallet  = newLimit;
518     }
519     
520     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
521         isFeeExempt[holder] = exempt;
522     }
523 
524     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
525         isTxLimitExempt[holder] = exempt;
526     }
527 
528     function setAnarchyWallet(address payable newAnarchyWallet) external onlyOwner {
529         anarchyWallet = payable(newAnarchyWallet);
530     }
531 
532     function setLpWallet(address newLpWallet) external onlyOwner {
533         lpWallet = newLpWallet;
534     }    
535 
536     function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
537         tokenOwner = newOwnerWallet;
538     }     
539 
540     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
541         swapAndLiquifyEnabled  = enableSwapBack;
542         swapThreshold = newSwapBackLimit;
543     }
544 
545     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
546         anarchyDist.setDistributionCriteria(newMinPeriod, newMinDistribution);        
547     }
548 
549     function delBot(address notbot) external onlyOwner {
550         bots[notbot] = false;
551     }
552 
553     function _setIsDividendExempt(address holder, bool exempt) internal {
554         require(holder != address(this) && holder != pair);
555         isDividendExempt[holder] = exempt;
556         if(exempt){
557             anarchyDist.setShare(holder, 0);
558         }else{
559             anarchyDist.setShare(holder, _balances[holder]);
560         }
561     }
562 
563     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
564         _setIsDividendExempt(holder, exempt);
565     }
566 
567     function changeMoneyPrinterGas(uint256 newGas) external onlyOwner {
568         anarchyDistGas = newGas;
569     }           
570 
571     function getCirculatingSupply() public view returns (uint256) {
572         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
573     }
574 
575     function totalSupply() external view override returns (uint256) { return _totalSupply; }
576     function decimals() external pure override returns (uint8) { return _decimals; }
577     function symbol() external pure override returns (string memory) { return _symbol; }
578     function name() external pure override returns (string memory) { return _name; }
579     function getOwner() external view override returns (address) { return owner; }
580     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
581     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
582     
583     function approve(address spender, uint256 amount) public override returns (bool) {
584         _allowances[msg.sender][spender] = amount;
585         emit Approval(msg.sender, spender, amount);
586         return true;
587     }
588 
589     function approveMax(address spender) external returns (bool) {
590         return approve(spender, type(uint256).max);
591     }
592 
593     function transfer(address recipient, uint256 amount) external override returns (bool) {
594         return _transfer(msg.sender, recipient, amount);
595     }
596 
597     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
598         if(_allowances[sender][msg.sender] != type(uint256).max){
599             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
600         }
601 
602         return _transfer(sender, recipient, amount);
603     }
604 
605     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
606         if (sender!= owner && recipient!= owner) require(tradingOpen, "hold ur horses big guy."); //transfers disabled before tradingActive
607         require(!bots[sender] && !bots[recipient]);
608 
609         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
610 
611         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
612 
613         if(!isTxLimitExempt[recipient] && antiBot)
614         {
615             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
616         }
617 
618         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
619 
620         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
621         
622         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
623         _balances[recipient] = _balances[recipient].add(finalAmount);
624 
625         // Dividend tracker
626         if(!isDividendExempt[sender]) {
627             try anarchyDist.setShare(sender, _balances[sender]) {} catch {}
628         }
629 
630         if(!isDividendExempt[recipient]) {
631             try anarchyDist.setShare(recipient, _balances[recipient]) {} catch {} 
632         }
633 
634         emit Transfer(sender, recipient, finalAmount);
635         return true;
636     }    
637 
638     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
639         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
640         _balances[recipient] = _balances[recipient].add(amount);
641         emit Transfer(sender, recipient, amount);
642         return true;
643     }  
644     
645     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
646         
647         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
648         uint256 feeAmount = amount.mul(feeApplicable).div(100);
649 
650         _balances[address(this)] = _balances[address(this)].add(feeAmount);
651         emit Transfer(sender, address(this), feeAmount);
652 
653         return amount.sub(feeAmount);
654     }
655     
656     function swapTokensForEth(uint256 tokenAmount) private {
657 
658         address[] memory path = new address[](2);
659         path[0] = address(this);
660         path[1] = router.WETH();
661 
662         approve(address(this), tokenAmount);
663 
664         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
665             tokenAmount,
666             0, // accept any amount of ETH
667             path,
668             address(this),
669             block.timestamp
670         );
671     }
672 
673     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
674         router.addLiquidityETH{value: ethAmount}(
675             address(this),
676             tokenAmount,
677             0,
678             0,
679             lpWallet,
680             block.timestamp
681         );
682     }
683 
684     function swapBack() internal lockTheSwap {
685     
686         uint256 tokenBalance = _balances[address(this)]; 
687         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
688         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);
689 
690         swapTokensForEth(amountToSwap);
691 
692         uint256 totalEthBalance = address(this).balance;
693         uint256 ethForANARCHY = totalEthBalance.mul(toReflections).div(100);
694         uint256 ethForAnarchyWallet = totalEthBalance.mul(toMarketing).div(100);
695         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
696       
697         if (totalEthBalance > 0){
698             payable(anarchyWallet).transfer(ethForAnarchyWallet);
699         }
700         
701         try anarchyDist.deposit{value: ethForANARCHY}() {} catch {}
702         
703         if (tokensForLiquidity > 0){
704             addLiquidity(tokensForLiquidity, ethForLiquidity);
705         }
706     }
707 
708     function manualSwapBack() external onlyOwner {
709         swapBack();
710     }
711 
712     function clearStuckEth() external onlyOwner {
713         uint256 contractETHBalance = address(this).balance;
714         if(contractETHBalance > 0){          
715             payable(anarchyWallet).transfer(contractETHBalance);
716         }
717     }
718 
719     function manualProcessGas(uint256 manualGas) external onlyOwner {
720         anarchyDist.process(manualGas);
721     }
722 
723     function checkPendingReflections(address shareholder) external view returns (uint256) {
724         return anarchyDist.getUnpaidEarnings(shareholder);
725     }
726 
727     function fvckTheSystem() external {
728         anarchyDist.fuckTheSystem(msg.sender);
729     }
730 }