1 // Tg: @baby_sharbi
2 //website: babysharbi.net
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.10;
7 
8 library SafeMath {
9     function tryAdd(uint256 a, uint256 b)
10         internal
11         pure
12         returns (bool, uint256)
13     {
14         unchecked {
15             uint256 c = a + b;
16             if (c < a) return (false, 0);
17             return (true, c);
18         }
19     }
20 
21     function trySub(uint256 a, uint256 b)
22         internal
23         pure
24         returns (bool, uint256)
25     {
26         unchecked {
27             if (b > a) return (false, 0);
28             return (true, a - b);
29         }
30     }
31 
32     function tryMul(uint256 a, uint256 b)
33         internal
34         pure
35         returns (bool, uint256)
36     {
37         unchecked {
38             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39             // benefit is lost if 'b' is also tested.
40             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
41             if (a == 0) return (true, 0);
42             uint256 c = a * b;
43             if (c / a != b) return (false, 0);
44             return (true, c);
45         }
46     }
47 
48     function tryDiv(uint256 a, uint256 b)
49         internal
50         pure
51         returns (bool, uint256)
52     {
53         unchecked {
54             if (b == 0) return (false, 0);
55             return (true, a / b);
56         }
57     }
58 
59     function tryMod(uint256 a, uint256 b)
60         internal
61         pure
62         returns (bool, uint256)
63     {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a % b);
67         }
68     }
69 
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a + b;
72     }
73 
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a - b;
76     }
77 
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         return a * b;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a / b;
84     }
85 
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a % b;
88     }
89 
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         unchecked {
96             require(b <= a, errorMessage);
97             return a - b;
98         }
99     }
100 
101     function div(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         unchecked {
107             require(b > 0, errorMessage);
108             return a / b;
109         }
110     }
111 
112     function mod(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         unchecked {
118             require(b > 0, errorMessage);
119             return a % b;
120         }
121     }
122 }
123 
124 interface IDexFactory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129 
130 interface IDexRouter {
131     function factory() external pure returns (address);
132 
133     function WETH() external pure returns (address);
134 
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 
151     function swapExactETHForTokensSupportingFeeOnTransferTokens(
152         uint256 amountOutMin,
153         address[] calldata path,
154         address to,
155         uint256 deadline
156     ) external payable;
157 
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint256 amountIn,
160         uint256 amountOutMin,
161         address[] calldata path,
162         address to,
163         uint256 deadline
164     ) external;
165 }
166 
167 interface IERC20Extended {
168     function totalSupply() external view returns (uint256);
169 
170     function decimals() external view returns (uint8);
171 
172     function symbol() external view returns (string memory);
173 
174     function name() external view returns (string memory);
175 
176     function balanceOf(address account) external view returns (uint256);
177 
178     function transfer(address recipient, uint256 amount)
179         external
180         returns (bool);
181 
182     function allowance(address _owner, address spender)
183         external
184         view
185         returns (uint256);
186 
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) external returns (bool);
194 
195     event Transfer(address indexed from, address indexed to, uint256 value);
196     event Approval(
197         address indexed owner,
198         address indexed spender,
199         uint256 value
200     );
201 }
202 
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address payable) {
205         return payable(msg.sender);
206     }
207 
208     function _msgData() internal view virtual returns (bytes memory) {
209         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
210         return msg.data;
211     }
212 }
213 
214 contract Ownable is Context {
215     address private _owner;
216 
217     event OwnershipTransferred(
218         address indexed previousOwner,
219         address indexed newOwner
220     );
221 
222     constructor() {
223         _owner = _msgSender();
224         emit OwnershipTransferred(address(0), _owner);
225     }
226 
227     function owner() public view returns (address) {
228         return _owner;
229     }
230 
231     modifier onlyOwner() {
232         require(_owner == _msgSender(), "Ownable: caller is not the owner");
233         _;
234     }
235 
236     function renounceOwnership() public virtual onlyOwner {
237         emit OwnershipTransferred(_owner, address(0));
238         _owner = payable(address(0));
239     }
240 
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(
243             newOwner != address(0),
244             "Ownable: new owner is the zero address"
245         );
246         emit OwnershipTransferred(_owner, newOwner);
247         _owner = newOwner;
248     }
249 }
250 
251 interface IDividendDistributor {
252     function setDistributionCriteria(
253         uint256 _minPeriod,
254         uint256 _minDistribution
255     ) external;
256 
257     function setShare(address shareholder, uint256 amount) external;
258 
259     function deposit() external payable;
260 
261     function process(uint256 gas) external;
262 
263     function claimDividend(address _user) external;
264 
265     function getPaidEarnings(address shareholder)
266         external
267         view
268         returns (uint256);
269 
270     function getUnpaidEarnings(address shareholder)
271         external
272         view
273         returns (uint256);
274 
275     function totalDistributed() external view returns (uint256);
276 }
277 
278 contract DividendDistributor is IDividendDistributor {
279     using SafeMath for uint256;
280 
281     address public token;
282 
283     struct Share {
284         uint256 amount;
285         uint256 totalExcluded;
286         uint256 totalRealised;
287     }
288 
289     IERC20Extended public Sharbi =
290         IERC20Extended(0xF3A3023e6Dede84AD88a656A3269F2A36e83c9a9);
291     IDexRouter public router;
292 
293     address[] public shareholders;
294     mapping(address => uint256) public shareholderIndexes;
295     mapping(address => uint256) public shareholderClaims;
296 
297     mapping(address => Share) public shares;
298 
299     uint256 public totalShares;
300     uint256 public totalDividends;
301     uint256 public totalDistributed;
302     uint256 public dividendsPerShare;
303     uint256 public dividendsPerShareAccuracyFactor = 10**36;
304 
305     uint256 public minPeriod = 1 hours;
306     uint256 public minDistribution = 1 * (10**Sharbi.decimals());
307 
308     uint256 currentIndex;
309 
310     bool initialized;
311     modifier initializer() {
312         require(!initialized);
313         _;
314         initialized = true;
315     }
316 
317     modifier onlyToken() {
318         require(msg.sender == token);
319         _;
320     }
321 
322     constructor(address router_) {
323         token = msg.sender;
324         router = IDexRouter(router_);
325     }
326 
327     function setDistributionCriteria(
328         uint256 _minPeriod,
329         uint256 _minDistribution
330     ) external override onlyToken {
331         minPeriod = _minPeriod;
332         minDistribution = _minDistribution;
333     }
334 
335     function setShare(address shareholder, uint256 amount)
336         external
337         override
338         onlyToken
339     {
340         if (shares[shareholder].amount > 0) {
341             distributeDividend(shareholder);
342         }
343 
344         if (amount > 0 && shares[shareholder].amount == 0) {
345             addShareholder(shareholder);
346         } else if (amount == 0 && shares[shareholder].amount > 0) {
347             removeShareholder(shareholder);
348         }
349 
350         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
351         shares[shareholder].amount = amount;
352         shares[shareholder].totalExcluded = getCumulativeDividends(
353             shares[shareholder].amount
354         );
355     }
356 
357     function deposit() external payable override onlyToken {
358         uint256 balanceBefore = Sharbi.balanceOf(address(this));
359 
360         address[] memory path = new address[](2);
361         path[0] = router.WETH();
362         path[1] = address(Sharbi);
363 
364         router.swapExactETHForTokensSupportingFeeOnTransferTokens{
365             value: msg.value
366         }(0, path, address(this), block.timestamp);
367 
368         uint256 amount = Sharbi.balanceOf(address(this)).sub(balanceBefore);
369 
370         totalDividends = totalDividends.add(amount);
371         dividendsPerShare = dividendsPerShare.add(
372             dividendsPerShareAccuracyFactor.mul(amount).div(totalShares)
373         );
374     }
375 
376     function process(uint256 gas) external override onlyToken {
377         uint256 shareholderCount = shareholders.length;
378 
379         if (shareholderCount == 0) {
380             return;
381         }
382 
383         uint256 gasUsed = 0;
384         uint256 gasLeft = gasleft();
385 
386         uint256 iterations = 0;
387 
388         while (gasUsed < gas && iterations < shareholderCount) {
389             if (currentIndex >= shareholderCount) {
390                 currentIndex = 0;
391             }
392 
393             if (shouldDistribute(shareholders[currentIndex])) {
394                 distributeDividend(shareholders[currentIndex]);
395             }
396 
397             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
398             gasLeft = gasleft();
399             currentIndex++;
400             iterations++;
401         }
402     }
403 
404     function shouldDistribute(address shareholder)
405         internal
406         view
407         returns (bool)
408     {
409         return
410             shareholderClaims[shareholder] + minPeriod < block.timestamp &&
411             getUnpaidEarnings(shareholder) > minDistribution;
412     }
413 
414     function distributeDividend(address shareholder) internal {
415         if (shares[shareholder].amount == 0) {
416             return;
417         }
418 
419         uint256 amount = getUnpaidEarnings(shareholder);
420         if (amount > 0) {
421             totalDistributed = totalDistributed.add(amount);
422             Sharbi.transfer(shareholder, amount);
423             shareholderClaims[shareholder] = block.timestamp;
424             shares[shareholder].totalRealised = shares[shareholder]
425                 .totalRealised
426                 .add(amount);
427             shares[shareholder].totalExcluded = getCumulativeDividends(
428                 shares[shareholder].amount
429             );
430         }
431     }
432 
433     function claimDividend(address _user) external {
434         distributeDividend(_user);
435     }
436 
437     function getPaidEarnings(address shareholder)
438         public
439         view
440         returns (uint256)
441     {
442         return shares[shareholder].totalRealised;
443     }
444 
445     function getUnpaidEarnings(address shareholder)
446         public
447         view
448         returns (uint256)
449     {
450         if (shares[shareholder].amount == 0) {
451             return 0;
452         }
453 
454         uint256 shareholderTotalDividends = getCumulativeDividends(
455             shares[shareholder].amount
456         );
457         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
458 
459         if (shareholderTotalDividends <= shareholderTotalExcluded) {
460             return 0;
461         }
462 
463         return shareholderTotalDividends.sub(shareholderTotalExcluded);
464     }
465 
466     function getCumulativeDividends(uint256 share)
467         internal
468         view
469         returns (uint256)
470     {
471         return
472             share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
473     }
474 
475     function addShareholder(address shareholder) internal {
476         shareholderIndexes[shareholder] = shareholders.length;
477         shareholders.push(shareholder);
478     }
479 
480     function removeShareholder(address shareholder) internal {
481         shareholders[shareholderIndexes[shareholder]] = shareholders[
482             shareholders.length - 1
483         ];
484         shareholderIndexes[
485             shareholders[shareholders.length - 1]
486         ] = shareholderIndexes[shareholder];
487         shareholders.pop();
488     }
489 }
490 
491 // main contract
492 contract BABY_SHARBI_ETH is IERC20Extended, Ownable {
493     using SafeMath for uint256;
494 
495     string private constant _name = "Baby Sharbi";
496     string private constant _symbol = "$BSHARBI";
497     uint8 private constant _decimals = 9;
498     uint256 private constant _totalSupply = 1_000_000_000_000 * 10**_decimals;
499 
500     address public Sharbi = 0xF3A3023e6Dede84AD88a656A3269F2A36e83c9a9;
501     address private constant DEAD = address(0xdead);
502     address private constant ZERO = address(0);
503     IDexRouter public router;
504     address public pair;
505     address public autoLiquidityReceiver;
506     address public marketingFeeReceiver;
507 
508     uint256 _reflectionBuyFee = 3_00;
509     uint256 _liquidityBuyFee = 1_00;
510     uint256 _marketingBuyFee = 2_00;
511 
512     uint256 _reflectionSellFee = 3_00;
513     uint256 _liquiditySellFee = 1_00;
514     uint256 _marketingSellFee = 11_00;
515 
516     uint256 _reflectionFeeCount;
517     uint256 _liquidityFeeCount;
518     uint256 _marketingFeeCount;
519 
520     uint256 public totalBuyFee = 6_00;
521     uint256 public totalSellFee = 15_00;
522     uint256 public feeDenominator = 100_00;
523 
524     DividendDistributor public distributor;
525     uint256 public distributorGas = 500000;
526 
527     uint256 public maxTxnAmount = _totalSupply / 100;
528     uint256 public maxWalletAmount = _totalSupply / 100;
529     uint256 public launchedAt;
530     uint256 public snipingTime = 60 seconds;
531 
532     mapping(address => uint256) private _balances;
533     mapping(address => mapping(address => uint256)) private _allowances;
534     mapping(address => bool) public isFeeExempt;
535     mapping(address => bool) public isLimitExmpt;
536     mapping(address => bool) public isWalletExmpt;
537     mapping(address => bool) public isDividendExempt;
538     mapping(address => bool) public isBot;
539 
540     uint256 public swapThreshold = _totalSupply / 1000;
541     bool public swapEnabled;
542     bool public trading;
543     bool inSwap;
544     modifier swapping() {
545         inSwap = true;
546         _;
547         inSwap = false;
548     }
549 
550     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
551 
552     constructor() Ownable() {
553         address router_ = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
554         autoLiquidityReceiver = msg.sender;
555         marketingFeeReceiver = 0xFbE80249C95D20f8c87327dB3721c77581999493;
556 
557         router = IDexRouter(router_);
558         pair = IDexFactory(router.factory()).createPair(
559             address(this),
560             router.WETH()
561         );
562         distributor = new DividendDistributor(router_);
563 
564         isFeeExempt[autoLiquidityReceiver] = true;
565         isFeeExempt[marketingFeeReceiver] = true;
566         isFeeExempt[address(this)] = true;
567 
568         isDividendExempt[pair] = true;
569         isDividendExempt[address(router)] = true;
570         isDividendExempt[address(this)] = true;
571         isDividendExempt[DEAD] = true;
572         isDividendExempt[ZERO] = true;
573 
574         isLimitExmpt[autoLiquidityReceiver] = true;
575         isLimitExmpt[marketingFeeReceiver] = true;
576         isLimitExmpt[address(this)] = true;
577         isLimitExmpt[address(router)] = true;
578 
579         isWalletExmpt[autoLiquidityReceiver] = true;
580         isWalletExmpt[marketingFeeReceiver] = true;
581         isWalletExmpt[pair] = true;
582         isWalletExmpt[address(router)] = true;
583         isWalletExmpt[address(this)] = true;
584 
585         _allowances[address(this)][address(router)] = _totalSupply;
586         _allowances[address(this)][address(pair)] = _totalSupply;
587 
588         _balances[msg.sender] = _totalSupply;
589         emit Transfer(address(0), msg.sender, _totalSupply);
590     }
591 
592     receive() external payable {}
593 
594     function totalSupply() external pure override returns (uint256) {
595         return _totalSupply;
596     }
597 
598     function decimals() external pure override returns (uint8) {
599         return _decimals;
600     }
601 
602     function symbol() external pure override returns (string memory) {
603         return _symbol;
604     }
605 
606     function name() external pure override returns (string memory) {
607         return _name;
608     }
609 
610     function balanceOf(address account) public view override returns (uint256) {
611         return _balances[account];
612     }
613 
614     function allowance(address holder, address spender)
615         external
616         view
617         override
618         returns (uint256)
619     {
620         return _allowances[holder][spender];
621     }
622 
623     function approve(address spender, uint256 amount)
624         public
625         override
626         returns (bool)
627     {
628         _allowances[msg.sender][spender] = amount;
629         emit Approval(msg.sender, spender, amount);
630         return true;
631     }
632 
633     function approveMax(address spender) external returns (bool) {
634         return approve(spender, _totalSupply);
635     }
636 
637     function transfer(address recipient, uint256 amount)
638         external
639         override
640         returns (bool)
641     {
642         return _transferFrom(msg.sender, recipient, amount);
643     }
644 
645     function transferFrom(
646         address sender,
647         address recipient,
648         uint256 amount
649     ) external override returns (bool) {
650         if (_allowances[sender][msg.sender] != _totalSupply) {
651             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
652                 .sub(amount, "Insufficient Allowance");
653         }
654 
655         return _transferFrom(sender, recipient, amount);
656     }
657 
658     function _transferFrom(
659         address sender,
660         address recipient,
661         uint256 amount
662     ) internal returns (bool) {
663         require(!isBot[sender], "Bot detected");
664         if (!isLimitExmpt[sender] && !isLimitExmpt[recipient]) {
665             require(amount <= maxTxnAmount, "Max txn limit exceeds");
666 
667             // trading disable till launch
668             if (!trading) {
669                 require(
670                     pair != sender && pair != recipient,
671                     "Trading is disable"
672                 );
673             }
674             // anti snipper bot
675             if (
676                 block.timestamp < launchedAt + snipingTime &&
677                 sender != address(router)
678             ) {
679                 if (pair == sender) {
680                     isBot[recipient] = true;
681                 } else if (pair == recipient) {
682                     isBot[sender] = true;
683                 }
684             }
685         }
686 
687         if (!isWalletExmpt[recipient]) {
688             require(
689                 balanceOf(recipient).add(amount) <= maxWalletAmount,
690                 "Max Wallet limit exceeds"
691             );
692         }
693 
694         if (inSwap) {
695             return _basicTransfer(sender, recipient, amount);
696         }
697 
698         if (shouldSwapBack()) {
699             swapBack();
700         }
701 
702         _balances[sender] = _balances[sender].sub(
703             amount,
704             "Insufficient Balance"
705         );
706 
707         uint256 amountReceived;
708         if (
709             isFeeExempt[sender] ||
710             isFeeExempt[recipient] ||
711             (sender != pair && recipient != pair)
712         ) {
713             amountReceived = amount;
714         } else {
715             uint256 feeAmount;
716             if (sender == pair) {
717                 feeAmount = amount.mul(totalBuyFee).div(feeDenominator);
718                 amountReceived = amount.sub(feeAmount);
719                 takeFee(sender, feeAmount);
720                 setBuyAccFee(amount);
721             } else {
722                 feeAmount = amount.mul(totalSellFee).div(feeDenominator);
723                 amountReceived = amount.sub(feeAmount);
724                 takeFee(sender, feeAmount);
725                 setSellAccFee(amount);
726             }
727         }
728 
729         _balances[recipient] = _balances[recipient].add(amountReceived);
730 
731         if (!isDividendExempt[sender]) {
732             try distributor.setShare(sender, _balances[sender]) {} catch {}
733         }
734         if (!isDividendExempt[recipient]) {
735             try
736                 distributor.setShare(recipient, _balances[recipient])
737             {} catch {}
738         }
739 
740         try distributor.process(distributorGas) {} catch {}
741 
742         emit Transfer(sender, recipient, amountReceived);
743         return true;
744     }
745 
746     function _basicTransfer(
747         address sender,
748         address recipient,
749         uint256 amount
750     ) internal returns (bool) {
751         _balances[sender] = _balances[sender].sub(
752             amount,
753             "Insufficient Balance"
754         );
755         _balances[recipient] = _balances[recipient].add(amount);
756         emit Transfer(sender, recipient, amount);
757         return true;
758     }
759 
760     function takeFee(address sender, uint256 feeAmount) internal {
761         _balances[address(this)] = _balances[address(this)].add(feeAmount);
762         emit Transfer(sender, address(this), feeAmount);
763     }
764 
765     function setBuyAccFee(uint256 _amount) internal {
766         _liquidityFeeCount += _amount.mul(_liquidityBuyFee).div(feeDenominator);
767         _reflectionFeeCount += _amount.mul(_reflectionBuyFee).div(
768             feeDenominator
769         );
770         _marketingFeeCount += _amount.mul(_marketingBuyFee).div(feeDenominator);
771     }
772 
773     function setSellAccFee(uint256 _amount) internal {
774         _liquidityFeeCount += _amount.mul(_liquiditySellFee).div(
775             feeDenominator
776         );
777         _reflectionFeeCount += _amount.mul(_reflectionSellFee).div(
778             feeDenominator
779         );
780         _marketingFeeCount += _amount.mul(_marketingSellFee).div(
781             feeDenominator
782         );
783     }
784 
785     function shouldSwapBack() internal view returns (bool) {
786         return
787             msg.sender != pair &&
788             !inSwap &&
789             swapEnabled &&
790             _balances[address(this)] >= swapThreshold;
791     }
792 
793     function swapBack() internal swapping {
794         uint256 totalFee = _liquidityFeeCount.add(_reflectionFeeCount).add(
795             _marketingFeeCount
796         );
797 
798         uint256 amountToLiquify = swapThreshold
799             .mul(_liquidityFeeCount)
800             .div(totalFee)
801             .div(2);
802 
803         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
804         _allowances[address(this)][address(router)] = _totalSupply;
805         address[] memory path = new address[](2);
806         path[0] = address(this);
807         path[1] = router.WETH();
808         uint256 balanceBefore = address(this).balance;
809 
810         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
811             amountToSwap,
812             0,
813             path,
814             address(this),
815             block.timestamp
816         );
817 
818         uint256 amountBNB = address(this).balance.sub(balanceBefore);
819 
820         uint256 totalBNBFee = totalFee.sub(_liquidityFeeCount.div(2));
821 
822         uint256 amountBNBLiquidity = amountBNB
823             .mul(_liquidityFeeCount)
824             .div(totalBNBFee)
825             .div(2);
826 
827         if (amountToLiquify > 0) {
828             router.addLiquidityETH{value: amountBNBLiquidity}(
829                 address(this),
830                 amountToLiquify,
831                 0,
832                 0,
833                 autoLiquidityReceiver,
834                 block.timestamp
835             );
836             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
837         }
838 
839         uint256 amountBNBReflection = amountBNB.mul(_reflectionFeeCount).div(
840             totalBNBFee
841         );
842         if (amountBNBReflection > 0) {
843             try distributor.deposit{value: amountBNBReflection}() {} catch {}
844         }
845 
846         uint256 amountBNBMarketing = amountBNB.mul(_marketingFeeCount).div(
847             totalBNBFee
848         );
849 
850         if (amountBNBMarketing > 0) {
851             payable(marketingFeeReceiver).transfer(amountBNBMarketing);
852         }
853 
854         _liquidityFeeCount = 0;
855         _reflectionFeeCount = 0;
856         _marketingFeeCount = 0;
857     }
858 
859     function claimDividend() external {
860         distributor.claimDividend(msg.sender);
861     }
862 
863     function getPaidDividend(address shareholder)
864         public
865         view
866         returns (uint256)
867     {
868         return distributor.getPaidEarnings(shareholder);
869     }
870 
871     function getUnpaidDividend(address shareholder)
872         external
873         view
874         returns (uint256)
875     {
876         return distributor.getUnpaidEarnings(shareholder);
877     }
878 
879     function getTotalDistributedDividend() external view returns (uint256) {
880         return distributor.totalDistributed();
881     }
882 
883     function setIsDividendExempt(address holder, bool exempt)
884         external
885         onlyOwner
886     {
887         require(holder != address(this) && holder != pair);
888         isDividendExempt[holder] = exempt;
889         if (exempt) {
890             distributor.setShare(holder, 0);
891         } else {
892             distributor.setShare(holder, _balances[holder]);
893         }
894     }
895 
896     function enableTrading() external onlyOwner {
897         require(!trading, "Already enabled");
898         trading = true;
899         swapEnabled = true;
900         launchedAt = block.timestamp;
901     }
902 
903     function removeStuckEth(uint256 amount) external onlyOwner {
904         payable(owner()).transfer(amount);
905     }
906 
907     function setMaxTxnAmount(uint256 amount) external onlyOwner {
908         require(amount >= _totalSupply / 10000);
909         maxTxnAmount = amount;
910     }
911 
912     function setMaxWalletAmount(uint256 amount) external onlyOwner {
913         require(amount >= _totalSupply / 10000);
914         maxWalletAmount = amount;
915     }
916 
917     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
918         isFeeExempt[holder] = exempt;
919     }
920 
921     function setIsLimitExempt(address[] memory holders, bool exempt)
922         external
923         onlyOwner
924     {
925         for (uint256 i; i < holders.length; i++) {
926             isLimitExmpt[holders[i]] = exempt;
927         }
928     }
929 
930     function setIsWalletExempt(address holder, bool exempt) external onlyOwner {
931         isWalletExmpt[holder] = exempt;
932     }
933 
934     function addOrRemoveBots(address[] memory accounts, bool exempt)
935         external
936         onlyOwner
937     {
938         for (uint256 i; i < accounts.length; i++) {
939             isBot[accounts[i]] = exempt;
940         }
941     }
942 
943     function setBuyFees(
944         uint256 _reflectionFee,
945         uint256 _liquidityFee,
946         uint256 _marketingFee,
947         uint256 _feeDenominator
948     ) public onlyOwner {
949         _reflectionBuyFee = _reflectionFee;
950         _liquidityBuyFee = _liquidityFee;
951         _marketingBuyFee = _marketingFee;
952         totalBuyFee = _liquidityFee.add(_reflectionFee).add(_marketingFee);
953         feeDenominator = _feeDenominator;
954         require(
955             totalBuyFee <= feeDenominator.mul(15).div(100),
956             "Can't be greater than 15%"
957         );
958     }
959 
960     function setSellFees(
961         uint256 _liquidityFee,
962         uint256 _reflectionFee,
963         uint256 _marketingFee,
964         uint256 _feeDenominator
965     ) public onlyOwner {
966         _liquiditySellFee = _liquidityFee;
967         _reflectionSellFee = _reflectionFee;
968         _marketingSellFee = _marketingFee;
969         totalSellFee = _liquidityFee.add(_reflectionFee).add(_marketingFee);
970         feeDenominator = _feeDenominator;
971         require(
972             totalSellFee <= feeDenominator.mul(15).div(100),
973             "Can't be greater than 15%"
974         );
975     }
976 
977     function setFeeReceivers(
978         address _autoLiquidityReceiver,
979         address _marketingFeeReceiver
980     ) external onlyOwner {
981         autoLiquidityReceiver = _autoLiquidityReceiver;
982         marketingFeeReceiver = _marketingFeeReceiver;
983     }
984 
985     function setSwapBackSettings(bool _enabled, uint256 _amount)
986         external
987         onlyOwner
988     {
989         require(swapThreshold > 0);
990         swapEnabled = _enabled;
991         swapThreshold = _amount;
992     }
993 
994     function setDistributionCriteria(
995         uint256 _minPeriod,
996         uint256 _minDistribution
997     ) external onlyOwner {
998         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
999     }
1000 
1001     function setDistributorSettings(uint256 gas) external onlyOwner {
1002         require(gas < 750000, "Gas must be lower than 750000");
1003         distributorGas = gas;
1004     }
1005 }