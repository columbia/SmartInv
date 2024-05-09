1 /*
2 
3 https://t.me/GLITCHportal
4 
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity 0.8.13;
10 
11 /**
12  * Standard SafeMath, stripped down to just add/sub/mul/div
13  */
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25 
26     function sub(
27         uint256 a,
28         uint256 b,
29         string memory errorMessage
30     ) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33 
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44 
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(
53         uint256 a,
54         uint256 b,
55         string memory errorMessage
56     ) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 }
65 
66 /**
67  * ERC20 standard interface.
68  */
69 interface IERC20 {
70     function totalSupply() external view returns (uint256);
71 
72     function decimals() external view returns (uint8);
73 
74     function symbol() external view returns (string memory);
75 
76     function name() external view returns (string memory);
77 
78     function getOwner() external view returns (address);
79 
80     function balanceOf(address account) external view returns (uint256);
81 
82     function transfer(address recipient, uint256 amount)
83         external
84         returns (bool);
85 
86     function allowance(address _owner, address spender)
87         external
88         view
89         returns (uint256);
90 
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     event Transfer(address indexed from, address indexed to, uint256 value);
100     event Approval(
101         address indexed owner,
102         address indexed spender,
103         uint256 value
104     );
105 }
106 
107 /**
108  * Allows for contract ownership along with multi-address authorization
109  */
110 abstract contract Auth {
111     address internal owner;
112 
113     constructor(address _owner) {
114         owner = _owner;
115     }
116 
117     /**
118      * Function modifier to require caller to be contract deployer
119      */
120     modifier onlyOwner() {
121         require(isOwner(msg.sender), "!Owner");
122         _;
123     }
124 
125     /**
126      * Check if address is owner
127      */
128     function isOwner(address account) public view returns (bool) {
129         return account == owner;
130     }
131 
132     /**
133      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
134      */
135     function transferOwnership(address payable adr) public onlyOwner {
136         owner = adr;
137         emit OwnershipTransferred(adr);
138     }
139 
140     event OwnershipTransferred(address owner);
141 }
142 
143 interface IDEXFactory {
144     function createPair(address tokenA, address tokenB)
145         external
146         returns (address pair);
147 }
148 
149 interface IDEXRouter {
150     function factory() external pure returns (address);
151 
152     function WETH() external pure returns (address);
153 
154     function addLiquidity(
155         address tokenA,
156         address tokenB,
157         uint256 amountADesired,
158         uint256 amountBDesired,
159         uint256 amountAMin,
160         uint256 amountBMin,
161         address to,
162         uint256 deadline
163     )
164         external
165         returns (
166             uint256 amountA,
167             uint256 amountB,
168             uint256 liquidity
169         );
170 
171     function addLiquidityETH(
172         address token,
173         uint256 amountTokenDesired,
174         uint256 amountTokenMin,
175         uint256 amountETHMin,
176         address to,
177         uint256 deadline
178     )
179         external
180         payable
181         returns (
182             uint256 amountToken,
183             uint256 amountETH,
184             uint256 liquidity
185         );
186 
187     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
188         uint256 amountIn,
189         uint256 amountOutMin,
190         address[] calldata path,
191         address to,
192         uint256 deadline
193     ) external;
194 
195     function swapExactETHForTokensSupportingFeeOnTransferTokens(
196         uint256 amountOutMin,
197         address[] calldata path,
198         address to,
199         uint256 deadline
200     ) external payable;
201 
202     function swapExactTokensForETHSupportingFeeOnTransferTokens(
203         uint256 amountIn,
204         uint256 amountOutMin,
205         address[] calldata path,
206         address to,
207         uint256 deadline
208     ) external;
209 }
210 
211 interface IDividendDistributor {
212     function setShare(address shareholder, uint256 amount) external;
213 
214     function claimDividend(address shareholder) external;
215 
216     function getDividendsClaimedPP(address shareholder)
217         external
218         view
219         returns (uint256);
220 
221     function getDividendsClaimedPL(address shareholder)
222         external
223         view
224         returns (uint256);
225 }
226 
227 contract DividendDistributor is IDividendDistributor {
228     using SafeMath for uint256;
229 
230     address public _token;
231     address public _owner;
232 
233     address public immutable PP =
234         address(0x8442E0e292186854BB6875b2A0fc1308b9Ded793); //UNI
235     address public immutable PL =
236         address(0xFB033FA09706fA92acE768736EC94AD68688888B); //UNI
237 
238     struct Share {
239         uint256 amount;
240         uint256 totalExcludedPP;
241         uint256 totalExcludedPL;
242         uint256 totalClaimedPP;
243         uint256 totalClaimedPL;
244     }
245 
246     address[] private shareholders;
247     mapping(address => uint256) private shareholderIndexes;
248 
249     mapping(address => Share) public shares;
250 
251     uint256 public totalShares;
252     uint256 public totalDividendsPP;
253     uint256 public totalDividendsPL;
254     uint256 public totalClaimedPP;
255     uint256 public totalClaimedPL;
256     uint256 public dividendsPerSharePP;
257     uint256 public dividendsPerSharePL;
258     uint256 private dividendsPerShareAccuracyFactor = 10**36;
259 
260     modifier onlyToken() {
261         require(msg.sender == _token, "Caller is not the token contract");
262         _;
263     }
264 
265     modifier onlyOwner() {
266         require(msg.sender == _owner, "Caller is not the owner");
267         _;
268     }
269 
270     constructor(address owner) {
271         _token = msg.sender;
272         _owner = owner;
273     }
274 
275     receive() external payable {}
276 
277     function setShare(address shareholder, uint256 amount)
278         external
279         override
280         onlyToken
281     {
282         if (shares[shareholder].amount > 0) {
283             distributeDividendPP(shareholder);
284             distributeDividendPL(shareholder);
285         }
286 
287         if (amount > 0 && shares[shareholder].amount == 0) {
288             addShareholder(shareholder);
289         } else if (amount == 0 && shares[shareholder].amount > 0) {
290             removeShareholder(shareholder);
291         }
292 
293         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
294         shares[shareholder].amount = amount;
295         shares[shareholder].totalExcludedPP = getCumulativeDividendsPP(
296             shares[shareholder].amount
297         );
298         shares[shareholder].totalExcludedPL = getCumulativeDividendsPL(
299             shares[shareholder].amount
300         );
301     }
302 
303     function depositPP(uint256 amount) external onlyToken {
304         require(amount > 0, "Amount must be greater than zero");
305         totalDividendsPP = totalDividendsPP.add(amount);
306         dividendsPerSharePP = dividendsPerSharePP.add(
307             dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)
308         );
309     }
310 
311     function depositPL(uint256 amount) external onlyToken {
312         require(amount > 0, "Amount must be greater than zero");
313         totalDividendsPL = totalDividendsPL.add(amount);
314         dividendsPerSharePL = dividendsPerSharePL.add(
315             dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)
316         );
317     }
318 
319     function distributeDividendPP(address shareholder) internal {
320         if (shares[shareholder].amount == 0) {
321             return;
322         }
323 
324         uint256 amount = getClaimableDividendPPOf(shareholder);
325         if (amount > 0) {
326             totalClaimedPP = totalClaimedPP.add(amount);
327             shares[shareholder].totalClaimedPP = shares[shareholder]
328                 .totalClaimedPP
329                 .add(amount);
330             shares[shareholder].totalExcludedPP = getCumulativeDividendsPP(
331                 shares[shareholder].amount
332             );
333             IERC20(PP).transfer(shareholder, amount);
334         }
335     }
336 
337     function distributeDividendPL(address shareholder) internal {
338         if (shares[shareholder].amount == 0) {
339             return;
340         }
341 
342         uint256 amount = getClaimableDividendPLOf(shareholder);
343         if (amount > 0) {
344             totalClaimedPL = totalClaimedPL.add(amount);
345             shares[shareholder].totalClaimedPL = shares[shareholder]
346                 .totalClaimedPL
347                 .add(amount);
348             shares[shareholder].totalExcludedPL = getCumulativeDividendsPL(
349                 shares[shareholder].amount
350             );
351             IERC20(PL).transfer(shareholder, amount);
352         }
353     }
354 
355     function claimDividend(address shareholder) external override onlyToken {
356         distributeDividendPP(shareholder);
357         distributeDividendPL(shareholder);
358     }
359 
360     function getClaimableDividendPPOf(address shareholder)
361         public
362         view
363         returns (uint256)
364     {
365         if (shares[shareholder].amount == 0) {
366             return 0;
367         }
368 
369         uint256 shareholderTotalDividends = getCumulativeDividendsPP(
370             shares[shareholder].amount
371         );
372         uint256 shareholderTotalExcluded = shares[shareholder].totalExcludedPP;
373 
374         if (shareholderTotalDividends <= shareholderTotalExcluded) {
375             return 0;
376         }
377 
378         return shareholderTotalDividends.sub(shareholderTotalExcluded);
379     }
380 
381     function getClaimableDividendPLOf(address shareholder)
382         public
383         view
384         returns (uint256)
385     {
386         if (shares[shareholder].amount == 0) {
387             return 0;
388         }
389 
390         uint256 shareholderTotalDividends = getCumulativeDividendsPL(
391             shares[shareholder].amount
392         );
393         uint256 shareholderTotalExcluded = shares[shareholder].totalExcludedPL;
394 
395         if (shareholderTotalDividends <= shareholderTotalExcluded) {
396             return 0;
397         }
398 
399         return shareholderTotalDividends.sub(shareholderTotalExcluded);
400     }
401 
402     function getCumulativeDividendsPP(uint256 share)
403         internal
404         view
405         returns (uint256)
406     {
407         return
408             share.mul(dividendsPerSharePP).div(dividendsPerShareAccuracyFactor);
409     }
410 
411     function getCumulativeDividendsPL(uint256 share)
412         internal
413         view
414         returns (uint256)
415     {
416         return
417             share.mul(dividendsPerSharePL).div(dividendsPerShareAccuracyFactor);
418     }
419 
420     function addShareholder(address shareholder) internal {
421         shareholderIndexes[shareholder] = shareholders.length;
422         shareholders.push(shareholder);
423     }
424 
425     function removeShareholder(address shareholder) internal {
426         shareholders[shareholderIndexes[shareholder]] = shareholders[
427             shareholders.length - 1
428         ];
429         shareholderIndexes[
430             shareholders[shareholders.length - 1]
431         ] = shareholderIndexes[shareholder];
432         shareholders.pop();
433     }
434 
435     function manualSend(uint256 amount, address holder) external onlyOwner {
436         uint256 contractETHBalance = address(this).balance;
437         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
438     }
439 
440     function getDividendsClaimedPP(address shareholder)
441         external
442         view
443         override
444         returns (uint256)
445     {
446         require(shares[shareholder].amount > 0, "You're not a shareholder!");
447 
448         return shares[shareholder].totalClaimedPP;
449     }
450 
451     function getDividendsClaimedPL(address shareholder)
452         external
453         view
454         override
455         returns (uint256)
456     {
457         require(shares[shareholder].amount > 0, "You're not a shareholder!");
458 
459         return shares[shareholder].totalClaimedPL;
460     }
461 }
462 
463 contract IMG is IERC20, Auth {
464     using SafeMath for uint256;
465 
466     address private WETH;
467     address private DEAD = 0x000000000000000000000000000000000000dEaD;
468     address private ZERO = 0x0000000000000000000000000000000000000000;
469 
470     address public immutable PP =
471         address(0x8442E0e292186854BB6875b2A0fc1308b9Ded793); //UNI
472     address public immutable PL =
473         address(0xFB033FA09706fA92acE768736EC94AD68688888B); //UNI
474 
475     string private constant _name = "Infinite Money Glitch";
476     string private constant _symbol = "GLITCH";
477     uint8 private constant _decimals = 9;
478 
479     uint256 private _totalSupply = 133713371337 * (10**_decimals);
480     uint256 private _maxTxAmountBuy = _totalSupply;
481 
482     mapping(address => uint256) private _balances;
483     mapping(address => mapping(address => uint256)) private _allowances;
484     mapping(address => uint256) private cooldown;
485 
486     mapping(address => bool) private isFeeExempt;
487     mapping(address => bool) private isDividendExempt;
488     mapping(address => bool) private isBot;
489 
490     uint256 private totalFee = 10;
491     uint256 private feeDenominator = 100;
492 
493     address payable public marketingWallet =
494         payable(0x2d3D3Cca83F9fAff5a13cDAf6Eaad4EF3b4EC5f3);
495 
496     IDEXRouter public router;
497     address public pair;
498 
499     uint256 public launchedAt;
500     bool private tradingOpen = true;
501     bool private buyLimit = true;
502     uint256 private maxBuy = 1337133713 * (10**_decimals);
503     uint256 public numTokensSellToSwap = 133713371 * 10**9;
504     uint256 public ppPercentage = 40;
505     uint256 public plPercentage = 30;
506     uint256 public ethPercentage = 30;
507 
508     DividendDistributor public distributor;
509 
510     bool public blacklistEnabled = false;
511     bool private inSwap;
512     modifier swapping() {
513         inSwap = true;
514         _;
515         inSwap = false;
516     }
517 
518     constructor(address _owner) Auth(_owner) {
519         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
520 
521         WETH = router.WETH();
522 
523         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
524 
525         _allowances[address(this)][address(router)] = type(uint256).max;
526 
527         distributor = new DividendDistributor(_owner);
528 
529         isFeeExempt[_owner] = true;
530         isFeeExempt[marketingWallet] = true;
531 
532         isDividendExempt[pair] = true;
533         isDividendExempt[DEAD] = true;
534 
535         _balances[_owner] = _totalSupply;
536 
537         emit Transfer(address(0), _owner, _totalSupply);
538     }
539 
540     receive() external payable {}
541 
542     function totalSupply() external view override returns (uint256) {
543         return _totalSupply;
544     }
545 
546     function decimals() external pure override returns (uint8) {
547         return _decimals;
548     }
549 
550     function symbol() external pure override returns (string memory) {
551         return _symbol;
552     }
553 
554     function name() external pure override returns (string memory) {
555         return _name;
556     }
557 
558     function getOwner() external view override returns (address) {
559         return owner;
560     }
561 
562     function balanceOf(address account) public view override returns (uint256) {
563         return _balances[account];
564     }
565 
566     function allowance(address holder, address spender)
567         external
568         view
569         override
570         returns (uint256)
571     {
572         return _allowances[holder][spender];
573     }
574 
575     function approve(address spender, uint256 amount)
576         public
577         override
578         returns (bool)
579     {
580         _allowances[msg.sender][spender] = amount;
581         emit Approval(msg.sender, spender, amount);
582         return true;
583     }
584 
585     function approveMax(address spender) external returns (bool) {
586         return approve(spender, type(uint256).max);
587     }
588 
589     function transfer(address recipient, uint256 amount)
590         external
591         override
592         returns (bool)
593     {
594         return _transferFrom(msg.sender, recipient, amount);
595     }
596 
597     function transferFrom(
598         address sender,
599         address recipient,
600         uint256 amount
601     ) external override returns (bool) {
602         if (_allowances[sender][msg.sender] != type(uint256).max) {
603             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
604                 .sub(amount, "Insufficient Allowance");
605         }
606 
607         return _transferFrom(sender, recipient, amount);
608     }
609 
610     function _transferFrom(
611         address sender,
612         address recipient,
613         uint256 amount
614     ) internal returns (bool) {
615         if (sender != owner && recipient != owner)
616             require(tradingOpen, "Trading not yet enabled.");
617         if (blacklistEnabled) {
618             require(!isBot[sender] && !isBot[recipient], "Bot!");
619         }
620         if (buyLimit) {
621            if (sender != owner && recipient != owner && sender != address(this) && recipient != address(this))
622                 require(amount <= maxBuy, "Too much sir");
623         }
624 
625         if (
626             sender == pair &&
627             recipient != address(router) &&
628             !isFeeExempt[recipient]
629         ) {
630             require(cooldown[recipient] < block.timestamp);
631             cooldown[recipient] = block.timestamp + 60 seconds;
632         }
633 
634         if (inSwap) {
635             return _basicTransfer(sender, recipient, amount);
636         }
637 
638         uint256 contractTokenBalance = balanceOf(address(this));
639 
640         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToSwap;
641 
642         bool shouldSwapBack = (overMinTokenBalance &&
643             recipient == pair &&
644             balanceOf(address(this)) > 0);
645         if (shouldSwapBack) {
646             swapBack();
647         }
648 
649         _balances[sender] = _balances[sender].sub(
650             amount,
651             "Insufficient Balance"
652         );
653 
654         uint256 amountReceived = shouldTakeFee(sender, recipient)
655             ? takeFee(sender, amount)
656             : amount;
657 
658         _balances[recipient] = _balances[recipient].add(amountReceived);
659 
660         if (sender != pair && !isDividendExempt[sender]) {
661             try distributor.setShare(sender, _balances[sender]) {} catch {}
662         }
663         if (recipient != pair && !isDividendExempt[recipient]) {
664             try
665                 distributor.setShare(recipient, _balances[recipient])
666             {} catch {}
667         }
668 
669         emit Transfer(sender, recipient, amountReceived);
670         return true;
671     }
672 
673     function _basicTransfer(
674         address sender,
675         address recipient,
676         uint256 amount
677     ) internal returns (bool) {
678         _balances[sender] = _balances[sender].sub(
679             amount,
680             "Insufficient Balance"
681         );
682         _balances[recipient] = _balances[recipient].add(amount);
683         emit Transfer(sender, recipient, amount);
684         return true;
685     }
686 
687     function shouldTakeFee(address sender, address recipient)
688         internal
689         view
690         returns (bool)
691     {
692         return (!(isFeeExempt[sender] || isFeeExempt[recipient]) &&
693             (sender == pair || recipient == pair));
694     }
695 
696     function takeFee(address sender, uint256 amount)
697         internal
698         returns (uint256)
699     {
700         uint256 feeAmount;
701         feeAmount = amount.mul(totalFee).div(feeDenominator);
702         _balances[address(this)] = _balances[address(this)].add(feeAmount);
703         emit Transfer(sender, address(this), feeAmount);
704 
705         return amount.sub(feeAmount);
706     }
707 
708     function setSwapPercentages(
709         uint256 newPPPercentage,
710         uint256 newPLPercentage,
711         uint256 newEthPercentage
712     ) external onlyOwner {
713         require(
714             newPPPercentage.add(newPLPercentage).add(newEthPercentage) == 100,
715             "Percentages must add up to 100"
716         );
717         ppPercentage = newPPPercentage;
718         plPercentage = newPLPercentage;
719         ethPercentage = newEthPercentage;
720     }
721 
722     function swapBack() internal swapping {
723         uint256 amountToSwap = balanceOf(address(this));
724 
725         uint256 amountToSwapPP = amountToSwap.mul(ppPercentage).div(100);
726         uint256 amountToSwapPL = amountToSwap.mul(plPercentage).div(100);
727         uint256 amountToSwapEth = amountToSwap.mul(ethPercentage).div(100);
728 
729         swapTokensForEth(amountToSwapEth);
730         swapTokensForPP(amountToSwapPP);
731         swapTokensForPL(amountToSwapPL);
732 
733         claimPPDividendContract();
734         claimPLDividendContract();
735 
736         uint256 dividendsPP = IERC20(PP).balanceOf(address(this));
737         uint256 dividendsPL = IERC20(PL).balanceOf(address(this));
738 
739         bool successPP = IERC20(PP).transfer(address(distributor), dividendsPP);
740         bool successPL = IERC20(PL).transfer(address(distributor), dividendsPL);
741 
742         if (successPP) {
743             distributor.depositPP(dividendsPP);
744         }
745         if (successPL) {
746             distributor.depositPL(dividendsPL);
747         }
748 
749         payable(marketingWallet).transfer(address(this).balance);
750     }
751 
752     function swapTokensForPP(uint256 tokenAmount) private {
753         address[] memory path = new address[](3);
754         path[0] = address(this);
755         path[1] = WETH;
756         path[2] = PP;
757 
758         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
759             tokenAmount,
760             0,
761             path,
762             address(this),
763             block.timestamp
764         );
765     }
766 
767     function swapTokensForPL(uint256 tokenAmount) private {
768         address[] memory path = new address[](3);
769         path[0] = address(this);
770         path[1] = WETH;
771         path[2] = PL;
772 
773         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
774             tokenAmount,
775             0,
776             path,
777             address(this),
778             block.timestamp
779         );
780     }
781 
782     function swapTokensForEth(uint256 tokenAmount) private {
783         address[] memory path = new address[](2);
784         path[0] = address(this);
785         path[1] = WETH;
786 
787         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
788             tokenAmount,
789             0,
790             path,
791             address(this),
792             block.timestamp
793         );
794     }
795 
796     function openTrading() external onlyOwner {
797         launchedAt = block.number;
798         tradingOpen = true;
799     }
800 
801     function setBot(address _address, bool toggle) external onlyOwner {
802         isBot[_address] = toggle;
803         _setIsDividendExempt(_address, toggle);
804     }
805 
806     function _setIsDividendExempt(address holder, bool exempt) internal {
807         require(holder != address(this) && holder != pair);
808         isDividendExempt[holder] = exempt;
809         if (exempt) {
810             distributor.setShare(holder, 0);
811         } else {
812             distributor.setShare(holder, _balances[holder]);
813         }
814     }
815 
816     function setIsDividendExempt(address holder, bool exempt)
817         external
818         onlyOwner
819     {
820         _setIsDividendExempt(holder, exempt);
821     }
822 
823     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
824         isFeeExempt[holder] = exempt;
825     }
826 
827     function setFee(uint256 _fee) external onlyOwner {
828         require(_fee <= 20, "Fee can't exceed 20%");
829         totalFee = _fee;
830     }
831 
832     function manualSend() external onlyOwner {
833         uint256 contractETHBalance = address(this).balance;
834         payable(marketingWallet).transfer(contractETHBalance);
835     }
836 
837     function claimDividend() external {
838         distributor.claimDividend(msg.sender);
839     }
840 
841     function claimDividend(address holder) external onlyOwner {
842         distributor.claimDividend(holder);
843     }
844 
845     function claimPPDividendContract() public {
846         (bool success, ) = PP.call(abi.encodeWithSelector(bytes4(0xf0fc6bca)));
847         require(success, "Claiming dividend failed");
848     }
849 
850     function claimPLDividendContract() public {
851         (bool success, ) = PL.call(abi.encodeWithSelector(bytes4(0xf0fc6bca)));
852         require(success, "Claiming dividend failed");
853     }
854 
855     function getClaimableDividendPPOf(address shareholder)
856         public
857         view
858         returns (uint256)
859     {
860         return distributor.getClaimableDividendPPOf(shareholder);
861     }
862 
863     function getClaimableDividendPLOf(address shareholder)
864         public
865         view
866         returns (uint256)
867     {
868         return distributor.getClaimableDividendPLOf(shareholder);
869     }
870 
871     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
872         return _basicTransfer(address(this), DEAD, amount);
873     }
874 
875     function getCirculatingSupply() public view returns (uint256) {
876         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
877     }
878 
879     function setMarketingWallet(address _marketingWallet) external onlyOwner {
880         marketingWallet = payable(_marketingWallet);
881     }
882 
883     function getTotalDividendsPP() external view returns (uint256) {
884         return distributor.totalDividendsPP();
885     }
886 
887     function getTotalDividendsPL() external view returns (uint256) {
888         return distributor.totalDividendsPL();
889     }
890 
891     function getTotalClaimedPP() external view returns (uint256) {
892         return distributor.totalClaimedPP();
893     }
894 
895     function getTotalClaimedPL() external view returns (uint256) {
896         return distributor.totalClaimedPL();
897     }
898 
899     function removeBuyLimit() external onlyOwner {
900         buyLimit = false;
901     }
902 
903     function checkBot(address account) public view returns (bool) {
904         return isBot[account];
905     }
906 
907     function setBlacklistEnabled() external onlyOwner {
908         require(blacklistEnabled == false, "can only be called once");
909         blacklistEnabled = true;
910     }
911 
912     function setSwapThresholdAmount(uint256 amount) external onlyOwner {
913         numTokensSellToSwap = amount * 10**9;
914     }
915 }