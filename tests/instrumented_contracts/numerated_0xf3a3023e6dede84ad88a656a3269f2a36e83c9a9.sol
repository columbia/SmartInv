1 // SPDX-License-Identifier: MIT
2 
3 /**
4      _______. __    __       ___      .______      .______    __  
5     /       ||  |  |  |     /   \     |   _  \     |   _  \  |  | 
6    |   (----`|  |__|  |    /  ^  \    |  |_)  |    |  |_)  | |  | 
7     \   \    |   __   |   /  /_\  \   |      /     |   _  <  |  | 
8 .----)   |   |  |  |  |  /  _____  \  |  |\  \----.|  |_)  | |  | 
9 |_______/    |__|  |__| /__/     \__\ | _| `._____||______/  |__| 
10                                                                   
11 */
12 
13 pragma solidity ^0.8.10;
14 
15 library SafeMath {
16     function tryAdd(uint256 a, uint256 b)
17         internal
18         pure
19         returns (bool, uint256)
20     {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     function trySub(uint256 a, uint256 b)
29         internal
30         pure
31         returns (bool, uint256)
32     {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38 
39     function tryMul(uint256 a, uint256 b)
40         internal
41         pure
42         returns (bool, uint256)
43     {
44         unchecked {
45             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46             // benefit is lost if 'b' is also tested.
47             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
48             if (a == 0) return (true, 0);
49             uint256 c = a * b;
50             if (c / a != b) return (false, 0);
51             return (true, c);
52         }
53     }
54 
55     function tryDiv(uint256 a, uint256 b)
56         internal
57         pure
58         returns (bool, uint256)
59     {
60         unchecked {
61             if (b == 0) return (false, 0);
62             return (true, a / b);
63         }
64     }
65 
66     function tryMod(uint256 a, uint256 b)
67         internal
68         pure
69         returns (bool, uint256)
70     {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a % b);
74         }
75     }
76 
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a + b;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a - b;
83     }
84 
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a * b;
87     }
88 
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a / b;
91     }
92 
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a % b;
95     }
96 
97     function sub(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         unchecked {
103             require(b <= a, errorMessage);
104             return a - b;
105         }
106     }
107 
108     function div(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         unchecked {
114             require(b > 0, errorMessage);
115             return a / b;
116         }
117     }
118 
119     function mod(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         unchecked {
125             require(b > 0, errorMessage);
126             return a % b;
127         }
128     }
129 }
130 
131 interface IDexFactory {
132     function createPair(address tokenA, address tokenB)
133         external
134         returns (address pair);
135 }
136 
137 interface IDexRouter {
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint256 amountOutMin,
160         address[] calldata path,
161         address to,
162         uint256 deadline
163     ) external payable;
164 
165     function swapExactTokensForETHSupportingFeeOnTransferTokens(
166         uint256 amountIn,
167         uint256 amountOutMin,
168         address[] calldata path,
169         address to,
170         uint256 deadline
171     ) external;
172 }
173 
174 interface IERC20Extended {
175     function totalSupply() external view returns (uint256);
176 
177     function decimals() external view returns (uint8);
178 
179     function symbol() external view returns (string memory);
180 
181     function name() external view returns (string memory);
182 
183     function balanceOf(address account) external view returns (uint256);
184 
185     function transfer(address recipient, uint256 amount)
186         external
187         returns (bool);
188 
189     function allowance(address _owner, address spender)
190         external
191         view
192         returns (uint256);
193 
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     function transferFrom(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) external returns (bool);
201 
202     event Transfer(address indexed from, address indexed to, uint256 value);
203     event Approval(
204         address indexed owner,
205         address indexed spender,
206         uint256 value
207     );
208 }
209 
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address payable) {
212         return payable(msg.sender);
213     }
214 
215     function _msgData() internal view virtual returns (bytes memory) {
216         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
217         return msg.data;
218     }
219 }
220 
221 contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(
225         address indexed previousOwner,
226         address indexed newOwner
227     );
228 
229     constructor() {
230         _owner = _msgSender();
231         emit OwnershipTransferred(address(0), _owner);
232     }
233 
234     function owner() public view returns (address) {
235         return _owner;
236     }
237 
238     modifier onlyOwner() {
239         require(_owner == _msgSender(), "Ownable: caller is not the owner");
240         _;
241     }
242 
243     function renounceOwnership() public virtual onlyOwner {
244         emit OwnershipTransferred(_owner, address(0));
245         _owner = payable(address(0));
246     }
247 
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(
250             newOwner != address(0),
251             "Ownable: new owner is the zero address"
252         );
253         emit OwnershipTransferred(_owner, newOwner);
254         _owner = newOwner;
255     }
256 }
257 
258 interface IDividendDistributor {
259     function setDistributionCriteria(
260         uint256 _minPeriod,
261         uint256 _minDistribution
262     ) external;
263 
264     function setShare(address shareholder, uint256 amount) external;
265 
266     function deposit() external payable;
267 
268     function process(uint256 gas) external;
269 
270     function claimDividend(address _user) external;
271 
272     function getPaidEarnings(address shareholder)
273         external
274         view
275         returns (uint256);
276 
277     function getUnpaidEarnings(address shareholder)
278         external
279         view
280         returns (uint256);
281 
282     function totalDistributed() external view returns (uint256);
283 }
284 
285 contract DividendDistributor is IDividendDistributor {
286     using SafeMath for uint256;
287 
288     address public token;
289 
290     struct Share {
291         uint256 amount;
292         uint256 totalExcluded;
293         uint256 totalRealised;
294     }
295 
296     IERC20Extended public USDC =
297         IERC20Extended(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
298     IDexRouter public router;
299 
300     address[] public shareholders;
301     mapping(address => uint256) public shareholderIndexes;
302     mapping(address => uint256) public shareholderClaims;
303 
304     mapping(address => Share) public shares;
305 
306     uint256 public totalShares;
307     uint256 public totalDividends;
308     uint256 public totalDistributed;
309     uint256 public dividendsPerShare;
310     uint256 public dividendsPerShareAccuracyFactor = 10**36;
311 
312     uint256 public minPeriod = 1 hours;
313     uint256 public minDistribution = 1 * (10**USDC.decimals());
314 
315     uint256 currentIndex;
316 
317     bool initialized;
318     modifier initializer() {
319         require(!initialized);
320         _;
321         initialized = true;
322     }
323 
324     modifier onlyToken() {
325         require(msg.sender == token);
326         _;
327     }
328 
329     constructor(address router_) {
330         token = msg.sender;
331         router = IDexRouter(router_);
332     }
333 
334     function setDistributionCriteria(
335         uint256 _minPeriod,
336         uint256 _minDistribution
337     ) external override onlyToken {
338         minPeriod = _minPeriod;
339         minDistribution = _minDistribution;
340     }
341 
342     function setShare(address shareholder, uint256 amount)
343         external
344         override
345         onlyToken
346     {
347         if (shares[shareholder].amount > 0) {
348             distributeDividend(shareholder);
349         }
350 
351         if (amount > 0 && shares[shareholder].amount == 0) {
352             addShareholder(shareholder);
353         } else if (amount == 0 && shares[shareholder].amount > 0) {
354             removeShareholder(shareholder);
355         }
356 
357         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
358         shares[shareholder].amount = amount;
359         shares[shareholder].totalExcluded = getCumulativeDividends(
360             shares[shareholder].amount
361         );
362     }
363 
364     function deposit() external payable override onlyToken {
365         uint256 balanceBefore = USDC.balanceOf(address(this));
366 
367         address[] memory path = new address[](2);
368         path[0] = router.WETH();
369         path[1] = address(USDC);
370 
371         router.swapExactETHForTokensSupportingFeeOnTransferTokens{
372             value: msg.value
373         }(0, path, address(this), block.timestamp);
374 
375         uint256 amount = USDC.balanceOf(address(this)).sub(balanceBefore);
376 
377         totalDividends = totalDividends.add(amount);
378         dividendsPerShare = dividendsPerShare.add(
379             dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)
380         );
381     }
382 
383     function process(uint256 gas) external override onlyToken {
384         uint256 shareholderCount = shareholders.length;
385 
386         if (shareholderCount == 0) {
387             return;
388         }
389 
390         uint256 gasUsed = 0;
391         uint256 gasLeft = gasleft();
392 
393         uint256 iterations = 0;
394 
395         while (gasUsed < gas && iterations < shareholderCount) {
396             if (currentIndex >= shareholderCount) {
397                 currentIndex = 0;
398             }
399 
400             if (shouldDistribute(shareholders[currentIndex])) {
401                 distributeDividend(shareholders[currentIndex]);
402             }
403 
404             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
405             gasLeft = gasleft();
406             currentIndex++;
407             iterations++;
408         }
409     }
410 
411     function shouldDistribute(address shareholder)
412         internal
413         view
414         returns (bool)
415     {
416         return
417             shareholderClaims[shareholder] + minPeriod < block.timestamp &&
418             getUnpaidEarnings(shareholder) > minDistribution;
419     }
420 
421     function distributeDividend(address shareholder) internal {
422         if (shares[shareholder].amount == 0) {
423             return;
424         }
425 
426         uint256 amount = getUnpaidEarnings(shareholder);
427         if (amount > 0) {
428             totalDistributed = totalDistributed.add(amount);
429             USDC.transfer(shareholder, amount);
430             shareholderClaims[shareholder] = block.timestamp;
431             shares[shareholder].totalRealised = shares[shareholder]
432                 .totalRealised
433                 .add(amount);
434             shares[shareholder].totalExcluded = getCumulativeDividends(
435                 shares[shareholder].amount
436             );
437         }
438     }
439 
440     function claimDividend(address _user) external {
441         distributeDividend(_user);
442     }
443 
444     function getPaidEarnings(address shareholder)
445         public
446         view
447         returns (uint256)
448     {
449         return shares[shareholder].totalRealised;
450     }
451 
452     function getUnpaidEarnings(address shareholder)
453         public
454         view
455         returns (uint256)
456     {
457         if (shares[shareholder].amount == 0) {
458             return 0;
459         }
460 
461         uint256 shareholderTotalDividends = getCumulativeDividends(
462             shares[shareholder].amount
463         );
464         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
465 
466         if (shareholderTotalDividends <= shareholderTotalExcluded) {
467             return 0;
468         }
469 
470         return shareholderTotalDividends.sub(shareholderTotalExcluded);
471     }
472 
473     function getCumulativeDividends(uint256 share)
474         internal
475         view
476         returns (uint256)
477     {
478         return
479             share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
480     }
481 
482     function addShareholder(address shareholder) internal {
483         shareholderIndexes[shareholder] = shareholders.length;
484         shareholders.push(shareholder);
485     }
486 
487     function removeShareholder(address shareholder) internal {
488         shareholders[shareholderIndexes[shareholder]] = shareholders[
489             shareholders.length - 1
490         ];
491         shareholderIndexes[
492             shareholders[shareholders.length - 1]
493         ] = shareholderIndexes[shareholder];
494         shareholders.pop();
495     }
496 }
497 
498 // main contract
499 contract SHARBI_Token is IERC20Extended, Ownable {
500     using SafeMath for uint256;
501 
502     string private constant _name = "SHARBI";
503     string private constant _symbol = "$SHARBI";
504     uint8 private constant _decimals = 9;
505     uint256 private constant _totalSupply = 1_000_000_000_000 * 10**_decimals;
506 
507     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
508     address private constant DEAD = address(0xdead);
509     address private constant ZERO = address(0);
510     IDexRouter public router;
511     address public pair;
512     address public autoLiquidityReceiver;
513 
514     uint256 _reflectionBuyFee = 4_00;
515     uint256 _liquidityBuyFee = 1_00;
516 
517     uint256 _reflectionSellFee = 4_00;
518     uint256 _liquiditySellFee = 1_00;
519 
520     uint256 _reflectionFeeCount;
521     uint256 _liquidityFeeCount;
522 
523     uint256 public totalBuyFee = 5_00;
524     uint256 public totalSellFee = 5_00;
525     uint256 public feeDenominator = 100_00;
526 
527     DividendDistributor public distributor;
528     uint256 public distributorGas = 500000;
529 
530     uint256 public maxTxnAmount = _totalSupply / 100;
531     uint256 public maxWalletAmount = _totalSupply / 1000;
532     uint256 public launchedAt;
533     uint256 public snipingTime = 30 seconds;
534 
535     mapping(address => uint256) private _balances;
536     mapping(address => mapping(address => uint256)) private _allowances;
537     mapping(address => bool) public isFeeExempt;
538     mapping(address => bool) public isLimitExmpt;
539     mapping(address => bool) public isWalletExmpt;
540     mapping(address => bool) public isDividendExempt;
541     mapping(address => bool) public isBot;
542 
543     uint256 public swapThreshold = _totalSupply / 1000;
544     bool public swapEnabled;
545     bool public trading;
546     bool inSwap;
547     modifier swapping() {
548         inSwap = true;
549         _;
550         inSwap = false;
551     }
552 
553     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
554 
555     constructor() Ownable() {
556         address router_ = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
557         autoLiquidityReceiver = msg.sender;
558 
559         router = IDexRouter(router_);
560         pair = IDexFactory(router.factory()).createPair(
561             address(this),
562             router.WETH()
563         );
564         distributor = new DividendDistributor(router_);
565 
566         isFeeExempt[autoLiquidityReceiver] = true;
567         isFeeExempt[address(this)] = true;
568 
569         isDividendExempt[pair] = true;
570         isDividendExempt[address(router)] = true;
571         isDividendExempt[address(this)] = true;
572         isDividendExempt[DEAD] = true;
573         isDividendExempt[ZERO] = true;
574 
575         isLimitExmpt[autoLiquidityReceiver] = true;
576         isLimitExmpt[address(this)] = true;
577         isLimitExmpt[address(router)] = true;
578 
579         isWalletExmpt[autoLiquidityReceiver] = true;
580         isWalletExmpt[pair] = true;
581         isWalletExmpt[address(router)] = true;
582         isWalletExmpt[address(this)] = true;
583 
584         _allowances[address(this)][address(router)] = _totalSupply;
585         _allowances[address(this)][address(pair)] = _totalSupply;
586 
587         _balances[msg.sender] = _totalSupply;
588         emit Transfer(address(0), msg.sender, _totalSupply);
589     }
590 
591     receive() external payable {}
592 
593     function totalSupply() external pure override returns (uint256) {
594         return _totalSupply;
595     }
596 
597     function decimals() external pure override returns (uint8) {
598         return _decimals;
599     }
600 
601     function symbol() external pure override returns (string memory) {
602         return _symbol;
603     }
604 
605     function name() external pure override returns (string memory) {
606         return _name;
607     }
608 
609     function balanceOf(address account) public view override returns (uint256) {
610         return _balances[account];
611     }
612 
613     function allowance(address holder, address spender)
614         external
615         view
616         override
617         returns (uint256)
618     {
619         return _allowances[holder][spender];
620     }
621 
622     function approve(address spender, uint256 amount)
623         public
624         override
625         returns (bool)
626     {
627         _allowances[msg.sender][spender] = amount;
628         emit Approval(msg.sender, spender, amount);
629         return true;
630     }
631 
632     function approveMax(address spender) external returns (bool) {
633         return approve(spender, _totalSupply);
634     }
635 
636     function transfer(address recipient, uint256 amount)
637         external
638         override
639         returns (bool)
640     {
641         return _transferFrom(msg.sender, recipient, amount);
642     }
643 
644     function transferFrom(
645         address sender,
646         address recipient,
647         uint256 amount
648     ) external override returns (bool) {
649         if (_allowances[sender][msg.sender] != _totalSupply) {
650             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
651                 .sub(amount, "Insufficient Allowance");
652         }
653 
654         return _transferFrom(sender, recipient, amount);
655     }
656 
657     function _transferFrom(
658         address sender,
659         address recipient,
660         uint256 amount
661     ) internal returns (bool) {
662         require(!isBot[sender],"Bot detected");
663         if (!isLimitExmpt[sender] && !isLimitExmpt[recipient]) {
664             require(amount <= maxTxnAmount, "Max txn limit exceeds");
665 
666             // trading disable till launch
667             if (!trading) {
668                 require(
669                     pair != sender && pair != recipient,
670                     "Trading is disable"
671                 );
672             }
673             // anti snipper bot
674             if (
675                 block.timestamp < launchedAt + snipingTime &&
676                 sender != address(router)
677             ) {
678                 if (pair == sender) {
679                     isBot[recipient] = true;
680                 } else if (pair == recipient) {
681                     isBot[sender] = true;
682                 }
683             }
684         }
685 
686         if (!isWalletExmpt[recipient]) {
687             require(
688                 balanceOf(recipient).add(amount) <= maxWalletAmount,
689                 "Max Wallet limit exceeds"
690             );
691         }
692 
693         if (inSwap) {
694             return _basicTransfer(sender, recipient, amount);
695         }
696 
697         if (shouldSwapBack()) {
698             swapBack();
699         }
700 
701         _balances[sender] = _balances[sender].sub(
702             amount,
703             "Insufficient Balance"
704         );
705 
706         uint256 amountReceived;
707         if (
708             isFeeExempt[sender] ||
709             isFeeExempt[recipient] ||
710             (sender != pair && recipient != pair)
711         ) {
712             amountReceived = amount;
713         } else {
714             uint256 feeAmount;
715             if (sender == pair) {
716                 feeAmount = amount.mul(totalBuyFee).div(feeDenominator);
717                 amountReceived = amount.sub(feeAmount);
718                 takeFee(sender, feeAmount);
719                 setBuyAccFee(amount);
720             } else {
721                 feeAmount = amount.mul(totalSellFee).div(feeDenominator);
722                 amountReceived = amount.sub(feeAmount);
723                 takeFee(sender, feeAmount);
724                 setSellAccFee(amount);
725             }
726         }
727 
728         _balances[recipient] = _balances[recipient].add(amountReceived);
729 
730         if (!isDividendExempt[sender]) {
731             try distributor.setShare(sender, _balances[sender]) {} catch {}
732         }
733         if (!isDividendExempt[recipient]) {
734             try
735                 distributor.setShare(recipient, _balances[recipient])
736             {} catch {}
737         }
738 
739         try distributor.process(distributorGas) {} catch {}
740 
741         emit Transfer(sender, recipient, amountReceived);
742         return true;
743     }
744 
745     function _basicTransfer(
746         address sender,
747         address recipient,
748         uint256 amount
749     ) internal returns (bool) {
750         _balances[sender] = _balances[sender].sub(
751             amount,
752             "Insufficient Balance"
753         );
754         _balances[recipient] = _balances[recipient].add(amount);
755         emit Transfer(sender, recipient, amount);
756         return true;
757     }
758 
759     function takeFee(address sender, uint256 feeAmount) internal {
760         _balances[address(this)] = _balances[address(this)].add(feeAmount);
761         emit Transfer(sender, address(this), feeAmount);
762     }
763 
764     function setBuyAccFee(uint256 _amount) internal {
765         _liquidityFeeCount += _amount.mul(_liquidityBuyFee).div(feeDenominator);
766         _reflectionFeeCount += _amount.mul(_reflectionBuyFee).div(
767             feeDenominator
768         );
769     }
770 
771     function setSellAccFee(uint256 _amount) internal {
772         _liquidityFeeCount += _amount.mul(_liquiditySellFee).div(
773             feeDenominator
774         );
775         _reflectionFeeCount += _amount.mul(_reflectionSellFee).div(
776             feeDenominator
777         );
778     }
779 
780     function shouldSwapBack() internal view returns (bool) {
781         return
782             msg.sender != pair &&
783             !inSwap &&
784             swapEnabled &&
785             _balances[address(this)] >= swapThreshold;
786     }
787 
788     function swapBack() internal swapping {
789         uint256 totalFee = _liquidityFeeCount.add(_reflectionFeeCount);
790 
791         uint256 amountToLiquify = swapThreshold
792             .mul(_liquidityFeeCount)
793             .div(totalFee)
794             .div(2);
795 
796         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
797         _allowances[address(this)][address(router)] = _totalSupply;
798         address[] memory path = new address[](2);
799         path[0] = address(this);
800         path[1] = router.WETH();
801         uint256 balanceBefore = address(this).balance;
802 
803         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
804             amountToSwap,
805             0,
806             path,
807             address(this),
808             block.timestamp
809         );
810 
811         uint256 amountBNB = address(this).balance.sub(balanceBefore);
812 
813         uint256 totalBNBFee = totalFee.sub(_liquidityFeeCount.div(2));
814 
815         uint256 amountBNBLiquidity = amountBNB
816             .mul(_liquidityFeeCount)
817             .div(totalBNBFee)
818             .div(2);
819 
820         if (amountToLiquify > 0) {
821             router.addLiquidityETH{value: amountBNBLiquidity}(
822                 address(this),
823                 amountToLiquify,
824                 0,
825                 0,
826                 autoLiquidityReceiver,
827                 block.timestamp
828             );
829             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
830         }
831 
832         uint256 amountBNBReflection = amountBNB.mul(_reflectionFeeCount).div(
833             totalBNBFee
834         );
835         if (amountBNBReflection > 0) {
836             try distributor.deposit{value: amountBNBReflection}() {} catch {}
837         }
838 
839         _liquidityFeeCount = 0;
840         _reflectionFeeCount = 0;
841     }
842 
843     function claimDividend() external {
844         distributor.claimDividend(msg.sender);
845     }
846 
847     function getPaidDividend(address shareholder)
848         public
849         view
850         returns (uint256)
851     {
852         return distributor.getPaidEarnings(shareholder);
853     }
854 
855     function getUnpaidDividend(address shareholder)
856         external
857         view
858         returns (uint256)
859     {
860         return distributor.getUnpaidEarnings(shareholder);
861     }
862 
863     function getTotalDistributedDividend() external view returns (uint256) {
864         return distributor.totalDistributed();
865     }
866 
867     function setIsDividendExempt(address holder, bool exempt)
868         external
869         onlyOwner
870     {
871         require(holder != address(this) && holder != pair);
872         isDividendExempt[holder] = exempt;
873         if (exempt) {
874             distributor.setShare(holder, 0);
875         } else {
876             distributor.setShare(holder, _balances[holder]);
877         }
878     }
879 
880     function enableTrading() external onlyOwner {
881         require(!trading, "Already enabled");
882         trading = true;
883         swapEnabled = true;
884         launchedAt = block.timestamp;
885     }
886 
887     function removeStuckEth(uint256 amount) external onlyOwner {
888         payable(owner()).transfer(amount);
889     }
890 
891     function setMaxTxnAmount(uint256 amount) external onlyOwner {
892         require(amount >= _totalSupply / 1000);
893         maxTxnAmount = amount;
894     }
895 
896     function setMaxWalletAmount(uint256 amount) external onlyOwner {
897         require(amount >= _totalSupply / 1000);
898         maxWalletAmount = amount;
899     }
900 
901     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
902         isFeeExempt[holder] = exempt;
903     }
904 
905     function setIsLimitExempt(address[] memory holders, bool exempt) external onlyOwner {
906         for (uint256 i; i < holders.length; i++) {
907             isLimitExmpt[holders[i]] = exempt;
908         }
909     }
910 
911     function setIsWalletExempt(address holder, bool exempt) external onlyOwner {
912         isWalletExmpt[holder] = exempt;
913     }
914 
915     function removeBots(address[] memory accounts)
916         external
917         onlyOwner
918     {
919         for (uint256 i; i < accounts.length; i++) {
920             isBot[accounts[i]] = false;
921         }
922     }
923 
924     function setBuyFees(
925         uint256 _reflectionFee,
926         uint256 _liquidityFee,
927         uint256 _feeDenominator
928     ) public onlyOwner {
929         _reflectionBuyFee = _reflectionFee;
930         _liquidityBuyFee = _liquidityFee;
931         totalBuyFee = _liquidityFee.add(_reflectionFee);
932         feeDenominator = _feeDenominator;
933         require(
934             totalBuyFee <= feeDenominator.div(10),
935             "Can't be greater than 10%"
936         );
937     }
938 
939     function setSellFees(
940         uint256 _liquidityFee,
941         uint256 _reflectionFee,
942         uint256 _feeDenominator
943     ) public onlyOwner {
944         _liquiditySellFee = _liquidityFee;
945         _reflectionSellFee = _reflectionFee;
946         totalSellFee = _liquidityFee.add(_reflectionFee);
947         feeDenominator = _feeDenominator;
948         require(
949             totalSellFee <= feeDenominator.div(10),
950             "Can't be greater than 10%"
951         );
952     }
953 
954     function setFeeReceivers(address _autoLiquidityReceiver)
955         external
956         onlyOwner
957     {
958         autoLiquidityReceiver = _autoLiquidityReceiver;
959     }
960 
961     function setSwapBackSettings(bool _enabled, uint256 _amount)
962         external
963         onlyOwner
964     {
965         require(swapThreshold > 0);
966         swapEnabled = _enabled;
967         swapThreshold = _amount;
968     }
969 
970     function setDistributionCriteria(
971         uint256 _minPeriod,
972         uint256 _minDistribution
973     ) external onlyOwner {
974         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
975     }
976 
977     function setDistributorSettings(uint256 gas) external onlyOwner {
978         require(gas < 750000, "Gas must be lower than 750000");
979         distributorGas = gas;
980     }
981 
982     function multiTransfer(address[] memory accounts, uint256[] memory amounts)
983         external
984         onlyOwner
985     {
986         require(accounts.length == amounts.length,"Invalid");
987         for (uint256 i; i < accounts.length; i++) {
988             _transferFrom(msg.sender, accounts[i], amounts[i]);
989         }
990     }
991 }