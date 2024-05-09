1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.0;
3 
4 /**
5  * SAFEMATH LIBRARY
6  */
7 library SafeMath {
8     
9     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
10         unchecked {
11             uint256 c = a + b;
12             if (c < a) return (false, 0);
13             return (true, c);
14         }
15     }
16 
17     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             if (b > a) return (false, 0);
20             return (true, a - b);
21         }
22     }
23 
24     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27             // benefit is lost if 'b' is also tested.
28             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
29             if (a == 0) return (true, 0);
30             uint256 c = a * b;
31             if (c / a != b) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b == 0) return (false, 0);
39             return (true, a / b);
40         }
41     }
42 
43     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b == 0) return (false, 0);
46             return (true, a % b);
47         }
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a + b;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a - b;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a * b;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a % b;
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         unchecked {
72             require(b <= a, errorMessage);
73             return a - b;
74         }
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         unchecked {
79             require(b > 0, errorMessage);
80             return a / b;
81         }
82     }
83 
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         unchecked {
86             require(b > 0, errorMessage);
87             return a % b;
88         }
89     }
90 }
91 
92 interface IERC20 {
93     function totalSupply() external view returns (uint256);
94     function decimals() external view returns (uint8);
95     function symbol() external view returns (string memory);
96     function name() external view returns (string memory);
97     function getOwner() external view returns (address);
98     function balanceOf(address account) external view returns (uint256);
99     function transfer(address recipient, uint256 amount) external returns (bool);
100     function allowance(address _owner, address spender) external view returns (uint256);
101     function approve(address spender, uint256 amount) external returns (bool);
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 abstract contract Auth {
108     address internal owner;
109     mapping (address => bool) internal authorizations;
110 
111     constructor(address _owner) {
112         owner = _owner;
113         authorizations[_owner] = true;
114     }
115 
116     /**
117      * Function modifier to require caller to be contract owner
118      */
119     modifier onlyOwner() {
120         require(isOwner(msg.sender), "!OWNER"); _;
121     }
122 
123     /**
124      * Function modifier to require caller to be authorized
125      */
126     modifier authorized() {
127         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
128     }
129 
130     /**
131      * Authorize address. Owner only
132      */
133     function authorize(address adr) public onlyOwner {
134         authorizations[adr] = true;
135     }
136 
137     /**
138      * Remove address' authorization. Owner only
139      */
140     function unauthorize(address adr) public onlyOwner {
141         authorizations[adr] = false;
142     }
143 
144     /**
145      * Check if address is owner
146      */
147     function isOwner(address account) public view returns (bool) {
148         return account == owner;
149     }
150 
151     /**
152      * Return address' authorization status
153      */
154     function isAuthorized(address adr) public view returns (bool) {
155         return authorizations[adr];
156     }
157 
158     /**
159      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
160      */
161     function transferOwnership(address payable adr) public onlyOwner {
162         owner = adr;
163         authorizations[adr] = true;
164         emit OwnershipTransferred(adr);
165     }
166 
167     event OwnershipTransferred(address owner);
168 }
169 
170 interface IDEXFactory {
171     function createPair(
172         address tokenA,
173         address tokenB
174     ) external returns (address pair);
175 
176     function getPair(
177         address tokenA,
178         address tokenB
179     ) external view returns (address pair);
180 }
181 
182 interface IDEXRouter {
183     function factory() external pure returns (address);
184     function WETH() external pure returns (address);
185 
186     function addLiquidity(
187         address tokenA,
188         address tokenB,
189         uint amountADesired,
190         uint amountBDesired,
191         uint amountAMin,
192         uint amountBMin,
193         address to,
194         uint deadline
195     ) external returns (uint amountA, uint amountB, uint liquidity);
196 
197     function addLiquidityETH(
198         address token,
199         uint amountTokenDesired,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
205 
206     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external;
213 
214     function swapExactETHForTokensSupportingFeeOnTransferTokens(
215         uint amountOutMin,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external payable;
220 
221     function swapExactTokensForETHSupportingFeeOnTransferTokens(
222         uint amountIn,
223         uint amountOutMin,
224         address[] calldata path,
225         address to,
226         uint deadline
227     ) external;
228 }
229 
230 interface IDividendDistributor {
231     function setShare(address shareholder, uint256 amount) external;
232     function deposit() external payable;
233 }
234 
235 contract DividendDistributor is IDividendDistributor, Auth {
236     using SafeMath for uint256;
237 
238     address _token;
239 
240     struct Share {
241         uint256 amount;
242         uint256 totalExcluded;
243         uint256 totalRealised;
244     }
245 
246     IERC20 BASE = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
247     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
248     IDEXRouter router;
249 
250     address[] shareholders;
251     mapping (address => uint256) shareholderIndexes;
252     mapping (address => uint256) shareholderClaims;
253 
254     mapping (address => uint256) public totalRewardsDistributed;
255     mapping (address => mapping (address => uint256)) public totalRewardsToUser;
256 
257     mapping (address => mapping (address => bool)) public canClaimDividendOfUser;
258 
259     mapping (address => bool) public availableRewards;
260     mapping (address => address) public pathRewards;
261 
262     mapping (address => bool) public allowed;
263     mapping (address => address) public choice;
264 
265     mapping (address => Share) public shares;
266 
267     uint256 public totalShares;
268     uint256 public totalDividends;
269     uint256 public totalDistributed;
270     uint256 public dividendsPerShare;
271     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
272 
273     modifier onlyToken() {
274         require(msg.sender == _token); _;
275     }
276 
277     constructor (
278         address _router,
279         address _owner
280     ) Auth(_owner) {
281         router = _router != address(0) ? IDEXRouter(_router) : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
282         _token = msg.sender;
283 
284         allowed[WETH] = true;
285 
286         IERC20(BASE).approve(_router, 2**256 - 1);
287     }
288 
289     receive() external payable {}
290 
291     function getTotalRewards(address token) public view returns (uint256) {
292         return totalRewardsDistributed[token];
293     }
294 
295     function getTotalRewardsToUser(address token, address user) public view returns (uint256) {
296         return totalRewardsToUser[token][user];
297     }
298 
299     function checkCanClaimDividendOfUser(address user, address claimer) public view returns (bool) {
300         return canClaimDividendOfUser[user][claimer];
301     }
302 
303     function setReward(
304         address _reward,
305         bool status
306     ) public onlyOwner {
307         availableRewards[_reward] = status;
308     }
309 
310     function setPathReward(
311         address _reward,
312         address _path
313     ) public onlyOwner {
314         pathRewards[_reward] = _path;
315     }
316 
317     function getPathReward(
318         address _reward
319     ) public view returns (address) {
320         return pathRewards[_reward];
321     }
322 
323     function changeRouterVersion(
324         address _router
325     ) external onlyOwner {
326         IDEXRouter _uniswapV2Router = IDEXRouter(_router);
327         router = _uniswapV2Router;
328     }
329 
330     function setShare(
331         address shareholder,
332         uint256 amount
333     ) external override onlyToken {
334 
335         if (shares[shareholder].amount > 0) {
336             if (allowed[choice[shareholder]]) {
337                 distributeDividend(shareholder, choice[shareholder]);
338             } else {
339                 distributeDividend(shareholder, WETH);
340             }
341         }
342 
343         if (amount > 0 && shares[shareholder].amount == 0) {
344             addShareholder(shareholder);
345         } else if (amount == 0 && shares[shareholder].amount > 0) {
346             removeShareholder(shareholder);
347         }
348 
349         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
350         shares[shareholder].amount = amount;
351         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
352     }
353 
354     function deposit() external payable override onlyToken {
355         uint256 amount = msg.value;
356 
357         totalDividends = totalDividends.add(amount);
358         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
359     }
360 
361     function distributeDividend(
362         address shareholder,
363         address rewardAddress
364     ) internal {
365         require(allowed[rewardAddress], "Invalid reward address!");
366 
367         if (shares[shareholder].amount == 0) {
368             return;
369         }
370 
371         uint256 amount = getUnpaidEarnings(shareholder);
372         if (amount > 0) {
373             totalDistributed = totalDistributed.add(amount);
374 
375             shareholderClaims[shareholder] = block.timestamp;
376             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
377             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
378 
379             if (rewardAddress == address(BASE)) {
380 
381                 payable(shareholder).transfer(amount);
382                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(amount);  
383                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(amount);
384 
385             } else {
386 
387                 IERC20 rewardToken = IERC20(rewardAddress);
388 
389                 uint256 beforeBalance = rewardToken.balanceOf(shareholder);
390 
391                 if (pathRewards[rewardAddress] == address(0)) {
392                     address[] memory path = new address[](2);
393                     path[0] = address(BASE);
394                     path[1] = rewardAddress;
395 
396                     router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
397                         0,
398                         path,
399                         shareholder,
400                         block.timestamp
401                     );                 
402                 } else {
403                     address[] memory path = new address[](3);
404                     path[0] = address(BASE);
405                     path[1] = pathRewards[rewardAddress];
406                     path[2] = rewardAddress;
407 
408                     router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
409                         0,
410                         path,
411                         shareholder,
412                         block.timestamp
413                     );
414 
415                 }
416 
417                 uint256 afterBalance = rewardToken.balanceOf(shareholder);
418                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(afterBalance.sub(beforeBalance));
419                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(afterBalance.sub(beforeBalance));
420 
421             }
422 
423         }
424     }
425 
426     function makeApprove(
427         address token,
428         address spender,
429         uint256 amount
430     ) public onlyOwner {
431         IERC20(token).approve(spender, amount);
432     }
433 
434     function claimDividend(
435         address rewardAddress
436     ) external {
437         distributeDividend(msg.sender, rewardAddress);
438     }
439 
440     function setChoice(
441         address _choice
442     ) external {
443         require(allowed[_choice]);
444         choice[msg.sender] = _choice;
445     }
446 
447     function toggleChoice(
448         address _choice
449     ) public onlyOwner {
450         allowed[_choice] = !allowed[_choice];
451     }
452 
453     function getChoice(
454         address _choice
455     ) public view returns (bool) {
456         return allowed[_choice];
457     }
458 
459     function claimDividendOfUser(
460         address user,
461         address rewardAddress
462     ) external {
463         require(canClaimDividendOfUser[user][msg.sender], "You can't do that");
464 
465         distributeDividend(user, rewardAddress);
466     }
467 
468     function setClaimDividendOfUser(
469         address claimer,
470         bool status
471     ) external {
472         canClaimDividendOfUser[msg.sender][claimer] = status;
473     }
474 
475     function getUnpaidEarnings(
476         address shareholder
477     ) public view returns (uint256) {
478         if (shares[shareholder].amount == 0) {
479             return 0;
480         }
481 
482         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
483         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
484 
485         if (shareholderTotalDividends <= shareholderTotalExcluded) {
486             return 0;
487         }
488 
489         return shareholderTotalDividends.sub(shareholderTotalExcluded);
490     }
491 
492     function getCumulativeDividends(
493         uint256 share
494     ) internal view returns (uint256) {
495         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
496     }
497 
498     function addShareholder(
499         address shareholder
500     ) internal {
501         shareholderIndexes[shareholder] = shareholders.length;
502         shareholders.push(shareholder);
503     }
504 
505     function removeShareholder(
506         address shareholder
507     ) internal {
508         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
509         shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
510         shareholders.pop();
511     }
512 
513     function Sweep() external onlyOwner {
514         uint256 balance = address(this).balance;
515         payable(msg.sender).transfer(balance);
516     }
517 
518     function changeBASE(
519         address _BASE
520     ) external onlyOwner {
521         BASE = IERC20(_BASE);
522     }
523 
524     function changeWETH(
525         address _WETH
526     ) external onlyOwner {
527         WETH = _WETH;
528     }
529 
530     function newApproval(
531         address token,
532         address _contract
533     ) external onlyOwner {
534         IERC20(token).approve(_contract, 2**256 - 1);
535     }
536 
537     function transferForeignToken(
538         address token,
539         address _to
540     ) external onlyOwner returns (bool _sent) {
541         require(token != address(this), "Can't withdraw native tokens");
542         uint256 _contractBalance = IERC20(token).balanceOf(address(this));
543         _sent = IERC20(token).transfer(_to, _contractBalance);
544     }
545 
546 }
547 
548 contract BOI is IERC20, Auth {
549     using SafeMath for uint256;
550 
551     uint256 public constant MASK = type(uint128).max;
552     address BASE = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
553     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
554     address DEAD = 0x000000000000000000000000000000000000dEaD;
555     address ZERO = 0x0000000000000000000000000000000000000000;
556     address DEAD_NON_CHECKSUM = 0x000000000000000000000000000000000000dEaD;
557 
558     string constant _name = "Yellow Boi";
559     string constant _symbol = "BOI";
560     uint8 constant _decimals = 9;
561 
562     uint256 _totalSupply = 1_000_000 * (10 ** _decimals);
563     uint256 public _maxWallet = 15_000 * (10 ** _decimals);
564 
565     uint256 public minAmountToTriggerSwap = 0;
566 
567     mapping (address => uint256) _balances;
568     mapping (address => mapping (address => uint256)) _allowances;
569 
570     mapping (address => bool) public isDisabledExempt;
571     mapping (address => bool) public isFeeExempt;
572     mapping (address => bool) public isDividendExempt;
573     mapping (address => bool) public _isFree;
574 
575     bool public isFeeOnTransferEnabled = false;
576 
577     mapping (address => bool) public automatedMarketMakerPairs;
578 
579     uint256 buyLiquidityFee = 0;
580     uint256 buyReflectionFee = 0;
581     uint256 buyOperationsFee = 0;
582     uint256 buyTreasuryFee = 0;
583     uint256 buyTotalFee = 0;
584 
585     uint256 sellLiquidityFee = 0;
586     uint256 sellReflectionFee = 0;
587     uint256 sellOperationsFee = 0;
588     uint256 sellTreasuryFee = 0;
589     uint256 sellTotalFee = 0;
590 
591     uint256 feeDenominator = 10000;
592 
593     uint256 _liquidityTokensToSwap;
594     uint256 _reflectionTokensToSwap;
595     uint256 _operationsTokensToSwap;
596     uint256 _treasuryTokensToSwap;
597 
598     address public autoLiquidityReceiver = 0xdF52768ca8cE88b64Ae1519061711d86186F6eeF;
599     address public operationsFeeReceiver = 0xdF52768ca8cE88b64Ae1519061711d86186F6eeF;
600     address public treasuryFeeReceiver = msg.sender;
601 
602     IDEXRouter public router;
603     address public pair;
604 
605     DividendDistributor distributor;
606     address public distributorAddress;
607 
608     bool public swapEnabled = true;
609     uint256 private swapMinimumTokens = _totalSupply / 5000; // 0.0025%
610 
611     bool public tradingEnabled = false;
612 
613     bool inSwap;
614     modifier swapping() {
615         inSwap = true; _;
616         inSwap = false;
617     }
618 
619     constructor () Auth(msg.sender) {
620         address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
621         router = IDEXRouter(_router);
622         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
623         _allowances[address(this)][address(router)] = _totalSupply;
624         WETH = router.WETH();
625         distributor = new DividendDistributor(_router, msg.sender);
626         distributorAddress = address(distributor);
627 
628         isDisabledExempt[msg.sender] = true;
629         isFeeExempt[msg.sender] = true;
630         isDividendExempt[pair] = true;
631         isDividendExempt[address(this)] = true;
632         isDividendExempt[DEAD] = true;
633 
634         autoLiquidityReceiver = msg.sender;
635 
636         _setAutomatedMarketMakerPair(pair, true);
637 
638         approve(_router, _totalSupply);
639         approve(address(pair), _totalSupply);
640         _balances[msg.sender] = _totalSupply;
641         emit Transfer(address(0), msg.sender, _totalSupply);
642     }
643     
644 
645     receive() external payable {}
646 
647     function totalSupply() external view override returns (uint256) { return _totalSupply; }
648     function decimals() external pure override returns (uint8) { return _decimals; }
649     function symbol() external pure override returns (string memory) { return _symbol; }
650     function name() external pure override returns (string memory) { return _name; }
651     function getOwner() external view override returns (address) { return owner; }
652     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
653     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
654 
655     function approve(
656         address spender,
657         uint256 amount
658     ) public override returns (bool) {
659         _allowances[msg.sender][spender] = amount;
660         emit Approval(msg.sender, spender, amount);
661         return true;
662     }
663 
664     function approveMax(
665         address spender
666     ) external returns (bool) {
667         return approve(spender, _totalSupply);
668     }
669 
670     function transfer(
671         address recipient,
672         uint256 amount
673     ) external override returns (bool) {
674         return _transferFrom(msg.sender, recipient, amount);
675     }
676 
677     function transferFrom(
678         address sender,
679         address recipient,
680         uint256 amount
681     ) external override returns (bool) {
682         if (_allowances[sender][msg.sender] != _totalSupply) {
683             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
684         }
685 
686         return _transferFrom(sender, recipient, amount);
687     }
688 
689     function _transferFrom(
690         address sender,
691         address recipient,
692         uint256 amount
693     ) internal returns (bool) {
694         if (inSwap) {
695             return _basicTransfer(sender, recipient, amount);
696         }
697 
698         require(tradingEnabled || isDisabledExempt[sender], "Trading is currently disabled");
699 
700         address routerAddress = address(router);
701         bool isSell = automatedMarketMakerPairs[recipient] || recipient == routerAddress;
702 
703         if (!isSell && !_isFree[recipient]) {
704             require((_balances[recipient] + amount) < _maxWallet, "Max wallet has been triggered");
705         }
706 
707         if (isSell && amount >= minAmountToTriggerSwap) {
708             if (shouldSwapBack()) {
709                 swapBack();
710             }
711         }
712 
713         _balances[sender] = _balances[sender].sub(amount, "Insufficient balance");
714 
715         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
716 
717         _balances[recipient] = _balances[recipient].add(amountReceived);
718 
719         if (!isDividendExempt[sender]) {
720             try distributor.setShare(sender, _balances[sender]) {} catch {}
721         }
722         if (!isDividendExempt[recipient]) {
723             try distributor.setShare(recipient, _balances[recipient]) {} catch {}
724         }
725 
726         emit Transfer(sender, recipient, amountReceived);
727         return true;
728     }
729 
730     function _basicTransfer(
731         address sender,
732         address recipient,
733         uint256 amount
734     ) internal returns (bool) {
735         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
736         _balances[recipient] = _balances[recipient].add(amount);
737         return true;
738     }
739 
740     function shouldTakeFee(
741         address sender,
742         address recipient
743     ) internal view returns (bool) {
744 
745         if (isFeeOnTransferEnabled) {
746             return !isFeeExempt[sender] && !isFeeExempt[recipient];
747         } else {
748             address routerAddress = address(router);
749             bool isBuy = automatedMarketMakerPairs[sender] || sender == routerAddress;
750             bool isSell =  automatedMarketMakerPairs[recipient]|| recipient == routerAddress;
751 
752             if (isBuy || isSell) {
753                 return !isFeeExempt[sender] && !isFeeExempt[recipient];
754             } else {
755                 return false;
756             }
757         }
758 
759     }
760 
761     function getTotalFee(
762         bool selling
763     ) public view returns (uint256) {
764         if (selling) {
765             return sellTotalFee;
766         }
767         return buyTotalFee;
768     }
769 
770     function takeFee(
771         address sender,
772         address receiver,
773         uint256 amount
774     ) internal returns (uint256) {
775         address routerAddress = address(router);
776         bool isSell = automatedMarketMakerPairs[receiver] || receiver == routerAddress;
777 
778         uint256 totalFee = getTotalFee(isSell);
779         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
780 
781         if (totalFee > 0) {
782             if (isSell) {
783                 if (sellLiquidityFee > 0) {
784                     _liquidityTokensToSwap += feeAmount * sellLiquidityFee / totalFee;
785                 }
786                 if (sellOperationsFee > 0) {
787                     _operationsTokensToSwap += feeAmount * sellOperationsFee / totalFee;
788                 }
789                 if (sellReflectionFee > 0) {
790                     _reflectionTokensToSwap += feeAmount * sellReflectionFee / totalFee;
791                 }
792                 if (sellTreasuryFee > 0) {
793                     _treasuryTokensToSwap += feeAmount * sellTreasuryFee / totalFee;
794                 }
795             } else {
796                 if (buyLiquidityFee > 0) {
797                     _liquidityTokensToSwap += feeAmount * buyLiquidityFee / totalFee;
798                 }
799                 if (buyOperationsFee > 0) {
800                     _operationsTokensToSwap += feeAmount * buyOperationsFee / totalFee;
801                 }
802                 if (buyReflectionFee > 0) {
803                     _reflectionTokensToSwap += feeAmount * buyReflectionFee / totalFee;
804                 }
805                 if (buyTreasuryFee > 0) {
806                     _treasuryTokensToSwap += feeAmount * buyTreasuryFee / totalFee;
807                 }
808             }
809         }
810 
811         _balances[address(this)] = _balances[address(this)].add(feeAmount);
812         emit Transfer(sender, address(this), feeAmount);
813 
814         return amount.sub(feeAmount);
815     }
816 
817     function shouldSwapBack() internal view returns (bool) {
818         return !automatedMarketMakerPairs[msg.sender] && !inSwap && swapEnabled && _balances[address(this)] >= swapMinimumTokens;
819     }
820 
821     function setAutomatedMarketMakerPair(
822         address _pair,
823         bool value
824     ) public onlyOwner {
825         _setAutomatedMarketMakerPair(_pair, value);
826     }
827 
828     function _setAutomatedMarketMakerPair(
829         address _pair,
830         bool value
831     ) private {
832         automatedMarketMakerPairs[_pair] = value;
833         if (value) {
834             isDividendExempt[_pair] = true;
835         }
836         if (!value) {
837             isDividendExempt[_pair] = false;
838         }
839     }
840 
841     function swapBack() internal swapping {
842         uint256 contractBalance = balanceOf(address(this));
843         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_operationsTokensToSwap).add(_reflectionTokensToSwap).add(_treasuryTokensToSwap);
844         
845         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
846         uint256 amountToSwap = contractBalance.sub(tokensForLiquidity);
847 
848         address[] memory path = new address[](2);
849         path[0] = address(this);
850         path[1] = WETH;
851         uint256 balanceBefore = address(this).balance;
852 
853         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
854             amountToSwap,
855             0,
856             path,
857             address(this),
858             block.timestamp
859         );
860 
861         uint256 amountETH = address(this).balance.sub(balanceBefore);
862 
863         uint256 amountETHLiquidity = amountETH.mul(_liquidityTokensToSwap).div(totalTokensToSwap).div(2);
864         uint256 amountETHReflection = amountETH.mul(_reflectionTokensToSwap).div(totalTokensToSwap);
865         uint256 amountETHOperations = amountETH.mul(_operationsTokensToSwap).div(totalTokensToSwap);
866         uint256 amountETHTreasury = amountETH.mul(_treasuryTokensToSwap).div(totalTokensToSwap);
867         
868         _liquidityTokensToSwap = 0;
869         _operationsTokensToSwap = 0;
870         _reflectionTokensToSwap = 0;
871         _treasuryTokensToSwap = 0;
872 
873         if (amountETHReflection > 0) {
874             try distributor.deposit{value: amountETHReflection}() {} catch {}
875         }
876         if (amountETHOperations > 0) {
877             payable(operationsFeeReceiver).transfer(amountETHOperations);
878         }
879         if (amountETHTreasury > 0) {
880             payable(treasuryFeeReceiver).transfer(amountETHTreasury);
881         }
882 
883         if (tokensForLiquidity > 0) {
884             router.addLiquidityETH{value: amountETHLiquidity}(
885                 address(this),
886                 tokensForLiquidity,
887                 0,
888                 0,
889                 autoLiquidityReceiver,
890                 block.timestamp
891             );
892             emit AutoLiquify(amountETHLiquidity, tokensForLiquidity);
893         }
894     }
895 
896     function buyTokens(
897         uint256 amount,
898         address to
899     ) internal swapping {
900         address[] memory path = new address[](2);
901         path[0] = WETH;
902         path[1] = address(this);
903 
904         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
905             0,
906             path,
907             to,
908             block.timestamp
909         );
910     }
911     
912     function Sweep() external onlyOwner {
913         uint256 balance = address(this).balance;
914         payable(msg.sender).transfer(balance);
915     }
916 
917     function changeBASE(
918         address _BASE
919     ) external onlyOwner {
920         BASE = _BASE;
921     }
922 
923     function changeWETH(
924         address _WETH
925     ) external onlyOwner {
926         WETH = _WETH;
927     }
928 
929     function changeRouterPairDistributor(
930         address _router,
931         bool _setWETH
932     ) external onlyOwner {
933         router = IDEXRouter(_router);
934         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
935         _allowances[address(this)][address(router)] = _totalSupply;
936         if (_setWETH) {
937             WETH = router.WETH();
938         }
939         distributor = new DividendDistributor(_router, msg.sender);
940         distributorAddress = address(distributor);
941     }
942 
943     function transferForeignToken(
944         address _token,
945         address _to
946     ) external onlyOwner returns (bool _sent) {
947         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
948         _sent = IERC20(_token).transfer(_to, _contractBalance);
949     }
950 
951     function setMaxWallet(
952         uint256 amount
953     ) external authorized {
954         _maxWallet = amount;
955     }
956 
957     function setMinAmountToTriggerSwap(
958         uint256 amount
959     ) external authorized {
960         minAmountToTriggerSwap = amount;
961     }
962 
963     function setIsFeeOnTransferEnabled(
964         bool status
965     ) external authorized {
966         isFeeOnTransferEnabled = status;
967     }
968 
969     function setIsDividendExempt(
970         address holder,
971         bool exempt
972     ) external authorized {
973         isDividendExempt[holder] = exempt;
974         if (exempt) {
975             distributor.setShare(holder, 0);
976         } else {
977             distributor.setShare(holder, _balances[holder]);
978         }
979     }
980 
981     function checkIsDividendExempt(
982         address holder
983     ) public view returns (bool) {
984         return isDividendExempt[holder];
985     }
986 
987     function setIsDisabledExempt(
988         address holder,
989         bool exempt
990     ) external authorized {
991         isDisabledExempt[holder] = exempt;
992     }
993 
994     function checkIsDisabledExempt(
995         address holder
996     ) public view returns (bool) {
997         return isDisabledExempt[holder];
998     }
999 
1000     function setIsFeeExempt(
1001         address holder,
1002         bool exempt
1003     ) external authorized {
1004         isFeeExempt[holder] = exempt;
1005     }
1006 
1007     function checkIsFeeExempt(
1008         address holder
1009     ) public view returns (bool) {
1010         return isFeeExempt[holder];
1011     }
1012 
1013     function setFree(
1014         address holder
1015     ) public onlyOwner {
1016         _isFree[holder] = true;
1017     }
1018     
1019     function unSetFree(
1020         address holder
1021     ) public onlyOwner {
1022         _isFree[holder] = false;
1023     }
1024 
1025     function checkFree(
1026         address holder
1027     ) public view onlyOwner returns (bool) {
1028         return _isFree[holder];
1029     }
1030 
1031     function setFees(
1032         uint256 _buyLiquidityFee,
1033         uint256 _buyReflectionFee,
1034         uint256 _buyOperationsFee,
1035         uint256 _buyTreasuryFee,
1036         uint256 _sellLiquidityFee,
1037         uint256 _sellReflectionFee,
1038         uint256 _sellOperationsFee,
1039         uint256 _sellTreasuryFee,
1040         uint256 _feeDenominator
1041     ) external authorized {
1042         buyLiquidityFee = _buyLiquidityFee;
1043         buyReflectionFee = _buyReflectionFee;
1044         buyOperationsFee = _buyOperationsFee;
1045         buyTreasuryFee = _buyTreasuryFee;
1046         buyTotalFee = _buyLiquidityFee.add(_buyReflectionFee).add(_buyOperationsFee).add(_buyTreasuryFee);
1047 
1048         sellLiquidityFee = _sellLiquidityFee;
1049         sellReflectionFee = _sellReflectionFee;
1050         sellOperationsFee = _sellOperationsFee;
1051         sellTreasuryFee = _sellTreasuryFee;
1052         sellTotalFee = _sellLiquidityFee.add(_sellReflectionFee).add(_sellOperationsFee).add(_sellTreasuryFee);
1053 
1054         feeDenominator = _feeDenominator;
1055     }
1056 
1057     function setFeeReceivers(
1058         address _autoLiquidityReceiver,
1059         address _operationsFeeReceiver,
1060         address _treasuryFeeReceiver
1061     ) external authorized {
1062         autoLiquidityReceiver = _autoLiquidityReceiver;
1063         operationsFeeReceiver = _operationsFeeReceiver;
1064         treasuryFeeReceiver = _treasuryFeeReceiver;
1065     }
1066 
1067     function enableTrading() external authorized {
1068         if (!tradingEnabled) {
1069             tradingEnabled = true;
1070         }
1071     }
1072 
1073     function toggleTrading(
1074         bool _enabled
1075     ) external authorized {
1076         tradingEnabled = _enabled;
1077     }
1078 
1079     function setSwapBackSettings(
1080         bool _enabled,
1081         uint256 _amount
1082     ) external authorized {
1083         swapEnabled = _enabled;
1084         swapMinimumTokens = _amount;
1085     }
1086 
1087     function getCirculatingSupply() public view returns (uint256) {
1088         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
1089     }
1090     
1091     function changeRouterVersion(
1092         address _router
1093     ) external onlyOwner returns (address _pair) {
1094         IDEXRouter _uniswapV2Router = IDEXRouter(_router);
1095 
1096         _pair = IDEXFactory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1097         if (_pair == address(0)) {
1098             _pair = IDEXFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1099         }
1100         pair = _pair;
1101 
1102         router = _uniswapV2Router;
1103         _allowances[address(this)][address(router)] = _totalSupply;
1104     }
1105 
1106     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
1107 }