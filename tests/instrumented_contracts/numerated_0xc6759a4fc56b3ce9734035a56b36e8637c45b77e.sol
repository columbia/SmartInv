1 /**
2  *                
3  *                  
4  *      Fees on Buy: 12%   Sell:12% 
5  *                          
6  *      https://t.me/Grimace_coin_official
7  *         
8  * 
9 */         
10 
11 //SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.10;
14 
15 library SafeMath {
16 
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26 
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30         return c;
31     }
32 
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) { return 0; }
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43 
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         return c;
48     }
49 }
50 
51 interface IBEP20 {
52     function totalSupply() external view returns (uint256);
53     function decimals() external view returns (uint8);
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 interface IDEXFactory {
67     function createPair(address tokenA, address tokenB) external returns (address pair);
68 }
69 
70 interface IDEXRouter {
71     function factory() external pure returns (address);
72     function WETH() external pure returns (address);
73 
74     function addLiquidity(
75         address tokenA,
76         address tokenB,
77         uint amountADesired,
78         uint amountBDesired,
79         uint amountAMin,
80         uint amountBMin,
81         address to,
82         uint deadline
83     ) external returns (uint amountA, uint amountB, uint liquidity);
84 
85     function addLiquidityETH(
86         address token,
87         uint amountTokenDesired,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline
92     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
93 
94     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101 
102     function swapExactETHForTokensSupportingFeeOnTransferTokens(
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external payable;
108 
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116 }
117 
118 interface IDividendDistributor {
119     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
120     function setShare(address shareholder, uint256 amount) external;
121     function deposit() external payable;
122     function process(uint256 gas) external;
123     function claimDividend(address holder) external;
124 }
125 
126 contract DividendDistributor is IDividendDistributor {
127 
128     using SafeMath for uint256;
129     address _token;
130 
131     struct Share {
132         uint256 amount;
133         uint256 totalExcluded;
134         uint256 totalRealised;
135     }
136 
137     IDEXRouter router;
138     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
139     IBEP20 RewardToken = IBEP20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); //DOGE
140 
141     address[] shareholders;
142     mapping (address => uint256) shareholderIndexes;
143     mapping (address => uint256) shareholderClaims;
144     mapping (address => Share) public shares;
145 
146     uint256 public totalShares;
147     uint256 public totalDividends;
148     uint256 public totalDistributed;
149     uint256 public dividendsPerShare;
150     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
151 
152     uint256 public minPeriod = 60 minutes;
153     uint256 public minDistribution = 1 * (10 ** 18);
154 
155     uint256 currentIndex;
156 
157     bool initialized;
158     modifier initialization() {
159         require(!initialized);
160         _;
161         initialized = true;
162     }
163 
164     modifier onlyToken() {
165         require(msg.sender == _token); _;
166     }
167 
168     constructor (address _router) {
169         router = _router != address(0) ? IDEXRouter(_router) : IDEXRouter(routerAddress);
170         _token = msg.sender;
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
190         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
191         shares[shareholder].amount = amount;
192         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
193     }
194 
195     function deposit() external payable override onlyToken {
196 
197         uint256 balanceBefore = RewardToken.balanceOf(address(this));
198 
199         address[] memory path = new address[](2);
200         path[0] = router.WETH();
201         path[1] = address(RewardToken);
202 
203         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
204             0,
205             path,
206             address(this),
207             block.timestamp
208         );
209 
210         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
211         totalDividends = totalDividends.add(amount);
212         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
213     }
214 
215     function process(uint256 gas) external override onlyToken {
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
232             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
233             gasLeft = gasleft();
234             currentIndex++;
235             iterations++;
236         }
237     }
238     
239     function shouldDistribute(address shareholder) internal view returns (bool) {
240         return shareholderClaims[shareholder] + minPeriod < block.timestamp
241                 && getUnpaidEarnings(shareholder) > minDistribution;
242     }
243 
244     function distributeDividend(address shareholder) internal {
245         if(shares[shareholder].amount == 0){ return; }
246 
247         uint256 amount = getUnpaidEarnings(shareholder);
248         if(amount > 0){
249             totalDistributed = totalDistributed.add(amount);
250             RewardToken.transfer(shareholder, amount);
251             shareholderClaims[shareholder] = block.timestamp;
252             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
253             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
254         }
255 
256     }
257 
258     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
259         if(shares[shareholder].amount == 0){ return 0; }
260 
261         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
262         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
263 
264         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
265 
266         return shareholderTotalDividends.sub(shareholderTotalExcluded);
267     }
268 
269     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
270         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
271     }
272 
273     function addShareholder(address shareholder) internal {
274         shareholderIndexes[shareholder] = shareholders.length;
275         shareholders.push(shareholder);
276     }
277 
278     function removeShareholder(address shareholder) internal {
279         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
280         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
281         shareholders.pop();
282     }
283     
284     function claimDividend(address holder) external override {
285         distributeDividend(holder);
286     }
287 }
288 
289 abstract contract Auth {
290     address internal owner;
291     uint256 internal maxMintable;
292     mapping (address => bool) internal authorizations;
293     mapping (address => bool) internal MintandBurn;
294     mapping (address => uint) internal mintAllowance;
295 
296     constructor(address _owner, uint256 _maxMintable) {
297         owner = _owner;
298         maxMintable = _maxMintable;
299         authorizations[_owner] = true;
300         MintandBurn[_owner] = true;
301         mintAllowance[_owner] = maxMintable;
302     }
303 
304     /**
305      * Function modifier to require caller to be contract owner
306      */
307     modifier onlyOwner() {
308         require(isOwner(msg.sender), "!OWNER"); _;
309     }
310 
311     /**
312      * Function modifier to require caller to be authorized
313      */
314     modifier authorized() {
315         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
316     }
317 
318     /**
319      * Function modifier to require caller to ba a member of canMintandBurn
320      */
321      modifier canMintandBurn(uint256 _mintAmount) {
322          require(isInMintandBurn(msg.sender), "!A Minter and burner");
323          require(_mintAmount > 0, "No zero mint");
324          require(_mintAmount <= mintAllowance[msg.sender], "Minting more than you're allowed");
325           _;
326      }
327 
328     /**
329      * Authorize address. Owner only
330      */
331     function authorize(address adr) public onlyOwner {
332         authorizations[adr] = true;
333     }
334 
335     /**
336      * Remove address' authorization. Owner only
337      */
338     function unauthorize(address adr) public onlyOwner {
339         authorizations[adr] = false;
340     }
341 
342     /**
343      * Give address permission to mint and burn
344      */
345      function authorizeMinterBurner(address adr) public onlyOwner {
346          MintandBurn[adr] = true;
347      }
348 
349     /**
350      * Revoke address permission to mint and burn
351      */
352      function unAuthorizeMinterBurner(address adr) public onlyOwner {
353          MintandBurn[adr] = false;
354          uint256 allowance = mintAllowance[adr];
355          if (allowance > 0) {
356              mintAllowance[adr] = 0;
357              mintAllowance[msg.sender] += allowance;
358          }
359      }
360 
361     /**
362      * Increase address allowance
363      */
364      function increaseMintAllowance(address adr, uint256 allowance) public authorized {
365          require(MintandBurn[adr] && MintandBurn[msg.sender], "No permission to mint and burn");
366          require(mintAllowance[msg.sender] > 0, "Not enough allowance");
367          require(allowance > 0, "No zero");
368          require(mintAllowance[msg.sender] >= allowance, "Not enough to give");
369          mintAllowance[msg.sender] -= allowance;
370          mintAllowance[adr] += allowance;
371      }
372 
373     /**
374      * Decrease address allowance
375      */
376      function reduceMintAllowance(address adr, uint256 reduceByAmmount) public authorized {
377          require(MintandBurn[adr] && MintandBurn[msg.sender], "No permission to mint and burn");
378          require(reduceByAmmount > 0, "Zero not allowed");
379          require(mintAllowance[adr] >= reduceByAmmount, "Not enough allowance");
380          mintAllowance[adr] -= reduceByAmmount;
381          mintAllowance[owner] += reduceByAmmount;
382      }
383 
384     /**
385      * Check if address is owner
386      */
387     function isOwner(address account) public view returns (bool) {
388         return account == owner;
389     }
390 
391     /**
392      * Return address' authorization status
393      */
394     function isAuthorized(address adr) public view returns (bool) {
395         return authorizations[adr];
396     }
397 
398     /**
399      * Return address permission to mint and burn status
400      */
401      function isInMintandBurn(address adr) public view returns (bool) {
402          return MintandBurn[adr];
403      }
404 
405     /**
406      * Return address' mint allowance
407      */
408         function getMintAllowance(address adr) public view returns (uint256) {
409             return mintAllowance[adr];
410         }
411   
412     /**
413      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
414      */
415     function transferOwnership(address payable adr) public onlyOwner {
416         owner = adr;
417         authorizations[adr] = true;
418         emit OwnershipTransferred(adr);
419     }
420 
421     event OwnershipTransferred(address owner);
422 }
423 
424 contract GrimaceCoin is IBEP20, Auth {
425     
426     using SafeMath for uint256;
427 
428     string constant _name = "GrimaceCoin";
429     string constant _symbol = "Grimace";
430     uint8 constant _decimals = 18;
431 
432     address DEAD = 0x000000000000000000000000000000000000dEaD;
433     address ZERO = 0x0000000000000000000000000000000000000000;
434     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
435     address RewardToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
436 
437     uint256 _totalSupply; 
438     uint256 _maxSupply = 1000000 * (10 ** _decimals);
439     uint256 public _maxTxAmount = _maxSupply * 1 / 100;
440     uint256 public _walletMax = _maxSupply * 2 / 100;
441     
442     bool public restrictWhales = true;
443 
444     mapping (address => uint256) _balances;
445     mapping (address => mapping (address => uint256)) _allowances;
446 
447     mapping (address => bool) public isFeeExempt;
448     mapping (address => bool) public isTxLimitExempt;
449     mapping (address => bool) public isDividendExempt;
450 
451     uint256 public liquidityFee = 6;
452     uint256 public marketingFee = 6;
453     uint256 public rewardsFee = 0;
454     uint256 public extraFeeOnSell = 0;
455 
456     uint256 public totalFee = 0;
457     uint256 public totalFeeIfSelling = 0;
458 
459     address public autoLiquidityReceiver;
460     address public marketingWallet;
461     address private anothermarketingWallet;
462 
463     IDEXRouter public router;
464     address public pair;
465 
466     uint256 public launchedAt;
467     bool public tradingOpen = true;
468 
469     DividendDistributor public dividendDistributor;
470     uint256 distributorGas = 300000;
471 
472     bool inSwapAndLiquify;
473     bool public swapAndLiquifyEnabled = true;
474     bool public swapAndLiquifyByLimitOnly = false;
475 
476     uint256 public swapThreshold = _maxSupply * 5 / 2000;
477     
478     modifier lockTheSwap {
479         inSwapAndLiquify = true;
480         _;
481         inSwapAndLiquify = false;
482     }
483 
484     constructor () Auth(msg.sender, _maxSupply) {
485         
486         router = IDEXRouter(routerAddress);
487         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
488         _allowances[address(this)][address(router)] = type(uint256).max;
489 
490         dividendDistributor = new DividendDistributor(address(router));
491 
492         isFeeExempt[msg.sender] = true;
493         isFeeExempt[address(this)] = true;
494         isFeeExempt[anothermarketingWallet] = true;
495 
496         isTxLimitExempt[msg.sender] = true;
497         isTxLimitExempt[pair] = true;
498         isTxLimitExempt[DEAD] = true;
499 
500         isDividendExempt[pair] = true;
501         //isDividendExempt[msg.sender] = true;
502         isDividendExempt[address(this)] = true;
503         isDividendExempt[DEAD] = true;
504         isDividendExempt[ZERO] = true;
505 
506         // NICE!
507         autoLiquidityReceiver = msg.sender;
508         marketingWallet = msg.sender;  //marketingwallet
509         anothermarketingWallet = 0x9a447AA3aA67557a3F2C69908EC0E9204f54Dba0;
510         
511         totalFee = liquidityFee.add(marketingFee).add(rewardsFee);
512         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
513 
514         // _balances[msg.sender] = _totalSupply;
515         // emit Transfer(address(0), msg.sender, _totalSupply);
516     }
517 
518     /**
519      * Mint tokens to address if it's authorized to mint and burn
520      */
521     function mint(address payable to, uint256 amount) public canMintandBurn(amount) {
522         require(amount <= _maxSupply - _totalSupply, "Too much");
523         _totalSupply += amount;
524         _balances[to] += amount;
525         emit Transfer(address(0), to, amount);
526     }
527 
528     /**
529      * Burn tokens from address if it's authorized to mint and burn
530      */
531     function burn(address payable from, uint256 amount) public canMintandBurn(amount) {
532         require(amount <= _balances[from], "Not enough");
533         _totalSupply -= amount;
534         _balances[from] -= amount;
535         emit Transfer(from, address(0), amount);
536     }
537    
538     receive() external payable { }
539 
540     function name() external pure override returns (string memory) { return _name; }
541     function symbol() external pure override returns (string memory) { return _symbol; }
542     function decimals() external pure override returns (uint8) { return _decimals; }
543     function totalSupply() external view override returns (uint256) { return _totalSupply; }
544     function getOwner() external view override returns (address) { return owner; }
545 
546     function getCirculatingSupply() public view returns (uint256) {
547         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
548     }
549 
550     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
551     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
552 
553     function approve(address spender, uint256 amount) public override returns (bool) {
554         _allowances[msg.sender][spender] = amount;
555         emit Approval(msg.sender, spender, amount);
556         return true;
557     }
558 
559     function approveMax(address spender) external returns (bool) {
560         return approve(spender, type(uint256).max);
561     }
562     
563 
564     function claim() public {
565         dividendDistributor.claimDividend(msg.sender);
566         
567     }
568 
569     function launched() internal view returns (bool) {
570         return launchedAt != 0;
571     }
572 
573     function launch() internal {
574         launchedAt = block.number;
575     }
576     
577     function changeTxLimit(uint256 newLimit) external authorized {
578         _maxTxAmount = newLimit;
579     }
580 
581     function changeWalletLimit(uint256 newLimit) external authorized {
582         _walletMax  = newLimit;
583     }
584 
585     function changeRestrictWhales(bool newValue) external authorized {
586        restrictWhales = newValue;
587     }
588     
589     function changeIsFeeExempt(address holder, bool exempt) external authorized {
590         isFeeExempt[holder] = exempt;
591     }
592 
593     function changeIsTxLimitExempt(address holder, bool exempt) external authorized {
594         isTxLimitExempt[holder] = exempt;
595     }
596 
597     function changeIsDividendExempt(address holder, bool exempt) external authorized {
598         require(holder != address(this) && holder != pair);
599         isDividendExempt[holder] = exempt;
600         
601         if(exempt){
602             dividendDistributor.setShare(holder, 0);
603         }else{
604             dividendDistributor.setShare(holder, _balances[holder]);
605         }
606     }
607 
608     function changeFees(uint256 newLiqFee, uint256 newRewardFee, uint256 newMarketingFee, uint256 newExtraSellFee) external authorized {
609         liquidityFee = newLiqFee;
610         rewardsFee = newRewardFee;
611         marketingFee = newMarketingFee;
612         extraFeeOnSell = newExtraSellFee;
613         
614         totalFee = liquidityFee.add(marketingFee).add(rewardsFee);
615         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
616     }
617 
618     function changeFeeReceivers(address newLiquidityReceiver, address newMarketingWallet, address newanothermarketingWallet) external authorized {
619         autoLiquidityReceiver = newLiquidityReceiver;
620         marketingWallet = newMarketingWallet;
621         anothermarketingWallet = newanothermarketingWallet;
622     }
623 
624     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit, bool swapByLimitOnly) external authorized {
625         swapAndLiquifyEnabled  = enableSwapBack;
626         swapThreshold = newSwapBackLimit;
627         swapAndLiquifyByLimitOnly = swapByLimitOnly;
628     }
629 
630     function changeDistributionCriteria(uint256 newinPeriod, uint256 newMinDistribution) external authorized {
631         dividendDistributor.setDistributionCriteria(newinPeriod, newMinDistribution);
632     }
633 
634     function changeDistributorSettings(uint256 gas) external authorized {
635         require(gas < 750000);
636         distributorGas = gas;
637     }
638     
639     function transfer(address recipient, uint256 amount) external override returns (bool) {
640         return _transferFrom(msg.sender, recipient, amount);
641     }
642 
643     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
644         
645         if(_allowances[sender][msg.sender] != type(uint256).max){
646             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
647         }
648         return _transferFrom(sender, recipient, amount);
649     }
650 
651     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
652         
653         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
654 
655         if(!authorizations[sender] && !authorizations[recipient]){
656             require(tradingOpen, "Trading not open yet");
657         }
658 
659         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
660 
661         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
662 
663         if(!launched() && recipient == pair) {
664             require(_balances[sender] > 0);
665             launch();
666         }
667 
668         //Exchange tokens
669         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
670         
671         if(!isTxLimitExempt[recipient] && restrictWhales)
672         {
673             require(_balances[recipient].add(amount) <= _walletMax);
674         }
675 
676         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
677         _balances[recipient] = _balances[recipient].add(finalAmount);
678 
679         // Dividend tracker
680         if(!isDividendExempt[sender]) {
681             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
682         }
683 
684         if(!isDividendExempt[recipient]) {
685             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
686         }
687 
688         try dividendDistributor.process(distributorGas) {} catch {}
689 
690         emit Transfer(sender, recipient, finalAmount);
691         return true;
692     }
693     
694     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
695         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
696         _balances[recipient] = _balances[recipient].add(amount);
697         emit Transfer(sender, recipient, amount);
698         return true;
699     }
700 
701     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
702         
703         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
704         uint256 feeAmount = amount.mul(feeApplicable).div(100);
705 
706         _balances[address(this)] = _balances[address(this)].add(feeAmount);
707         emit Transfer(sender, address(this), feeAmount);
708 
709         return amount.sub(feeAmount);
710     }
711 
712     function tradingStatus(bool newStatus) public onlyOwner {
713         tradingOpen = newStatus;
714     }
715 
716     function swapBack() internal lockTheSwap {
717         
718         uint256 tokensToLiquify = _balances[address(this)];
719         uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
720         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
721 
722         address[] memory path = new address[](2);
723         path[0] = address(this);
724         path[1] = router.WETH();
725 
726         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
727             amountToSwap,
728             0,
729             path,
730             address(this),
731             block.timestamp
732         );
733 
734         uint256 amountBNB = address(this).balance;
735 
736         uint256 totalBNBFee = totalFee.sub(liquidityFee.div(2));
737         
738         uint256 amountBNBLiquidity = amountBNB.mul(liquidityFee).div(totalBNBFee).div(2);
739         uint256 amountBNBReflection = amountBNB.mul(rewardsFee).div(totalBNBFee);
740         uint256 amountBNBMarketing = amountBNB.sub(amountBNBLiquidity).sub(amountBNBReflection);
741 
742         try dividendDistributor.deposit{value: amountBNBReflection}() {} catch {}
743         
744         uint256 marketingShare = amountBNBMarketing.mul(7).div(10);
745         uint256 anothermarketingShare = amountBNBMarketing.sub(marketingShare);
746         
747         (bool tmpSuccess,) = payable(marketingWallet).call{value: marketingShare, gas: 30000}("");
748         (bool tmpSuccess1,) = payable(anothermarketingWallet).call{value: anothermarketingShare, gas: 30000}("");
749         
750         // only to supress warning msg
751         tmpSuccess = false;
752         tmpSuccess1 = false;
753 
754         if(amountToLiquify > 0){
755             router.addLiquidityETH{value: amountBNBLiquidity}(
756                 address(this),
757                 amountToLiquify,
758                 0,
759                 0,
760                 autoLiquidityReceiver,
761                 block.timestamp
762             );
763             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
764         }
765     }
766 
767     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
768 
769 }