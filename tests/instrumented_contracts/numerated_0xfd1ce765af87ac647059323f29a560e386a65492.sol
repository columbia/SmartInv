1 /**
2  * BEAR BUCKS                   BEARBUCKS.FINANCE                     T.ME/BEARBUCKS
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.0;
7 
8 /**
9  * SAFEMATH LIBRARY
10  */
11 library SafeMath {
12     
13     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
14         unchecked {
15             uint256 c = a + b;
16             if (c < a) return (false, 0);
17             return (true, c);
18         }
19     }
20 
21     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             if (b > a) return (false, 0);
24             return (true, a - b);
25         }
26     }
27 
28     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31             // benefit is lost if 'b' is also tested.
32             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
33             if (a == 0) return (true, 0);
34             uint256 c = a * b;
35             if (c / a != b) return (false, 0);
36             return (true, c);
37         }
38     }
39 
40     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (b == 0) return (false, 0);
43             return (true, a / b);
44         }
45     }
46 
47     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b == 0) return (false, 0);
50             return (true, a % b);
51         }
52     }
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a + b;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a - b;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a * b;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a / b;
68     }
69 
70     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a % b;
72     }
73 
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         unchecked {
76             require(b <= a, errorMessage);
77             return a - b;
78         }
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         unchecked {
83             require(b > 0, errorMessage);
84             return a / b;
85         }
86     }
87 
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         unchecked {
90             require(b > 0, errorMessage);
91             return a % b;
92         }
93     }
94 }
95 
96 interface IERC20 {
97     function totalSupply() external view returns (uint256);
98     function decimals() external view returns (uint8);
99     function symbol() external view returns (string memory);
100     function name() external view returns (string memory);
101     function getOwner() external view returns (address);
102     function balanceOf(address account) external view returns (uint256);
103     function transfer(address recipient, uint256 amount) external returns (bool);
104     function allowance(address _owner, address spender) external view returns (uint256);
105     function approve(address spender, uint256 amount) external returns (bool);
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 abstract contract Auth {
112     address internal owner;
113     mapping (address => bool) internal authorizations;
114 
115     constructor(address _owner) {
116         owner = _owner;
117         authorizations[_owner] = true;
118     }
119 
120     /**
121      * Function modifier to require caller to be contract owner
122      */
123     modifier onlyOwner() {
124         require(isOwner(msg.sender), "!OWNER"); _;
125     }
126 
127     /**
128      * Function modifier to require caller to be authorized
129      */
130     modifier authorized() {
131         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
132     }
133 
134     /**
135      * Authorize address. Owner only
136      */
137     function authorize(address adr) public onlyOwner {
138         authorizations[adr] = true;
139     }
140 
141     /**
142      * Remove address' authorization. Owner only
143      */
144     function unauthorize(address adr) public onlyOwner {
145         authorizations[adr] = false;
146     }
147 
148     /**
149      * Check if address is owner
150      */
151     function isOwner(address account) public view returns (bool) {
152         return account == owner;
153     }
154 
155     /**
156      * Return address' authorization status
157      */
158     function isAuthorized(address adr) public view returns (bool) {
159         return authorizations[adr];
160     }
161 
162     /**
163      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
164      */
165     function transferOwnership(address payable adr) public onlyOwner {
166         owner = adr;
167         authorizations[adr] = true;
168         emit OwnershipTransferred(adr);
169     }
170 
171     event OwnershipTransferred(address owner);
172 }
173 
174 interface IDEXFactory {
175     function createPair(
176         address tokenA,
177         address tokenB
178     ) external returns (address pair);
179 
180     function getPair(
181         address tokenA,
182         address tokenB
183     ) external view returns (address pair);
184 }
185 
186 interface IDEXRouter {
187     function factory() external pure returns (address);
188     function WETH() external pure returns (address);
189 
190     function addLiquidity(
191         address tokenA,
192         address tokenB,
193         uint amountADesired,
194         uint amountBDesired,
195         uint amountAMin,
196         uint amountBMin,
197         address to,
198         uint deadline
199     ) external returns (uint amountA, uint amountB, uint liquidity);
200 
201     function addLiquidityETH(
202         address token,
203         uint amountTokenDesired,
204         uint amountTokenMin,
205         uint amountETHMin,
206         address to,
207         uint deadline
208     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
209 
210     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
211         uint amountIn,
212         uint amountOutMin,
213         address[] calldata path,
214         address to,
215         uint deadline
216     ) external;
217 
218     function swapExactETHForTokensSupportingFeeOnTransferTokens(
219         uint amountOutMin,
220         address[] calldata path,
221         address to,
222         uint deadline
223     ) external payable;
224 
225     function swapExactTokensForETHSupportingFeeOnTransferTokens(
226         uint amountIn,
227         uint amountOutMin,
228         address[] calldata path,
229         address to,
230         uint deadline
231     ) external;
232 }
233 
234 interface IDividendDistributor {
235     function setShare(address shareholder, uint256 amount) external;
236     function deposit() external payable;
237 }
238 
239 contract DividendDistributor is IDividendDistributor, Auth {
240     using SafeMath for uint256;
241 
242     address _token;
243 
244     struct Share {
245         uint256 amount;
246         uint256 totalExcluded;
247         uint256 totalRealised;
248     }
249 
250     IERC20 BASE = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
251     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
252     IDEXRouter router;
253 
254     address[] shareholders;
255     mapping (address => uint256) shareholderIndexes;
256     mapping (address => uint256) shareholderClaims;
257 
258     mapping (address => uint256) public totalRewardsDistributed;
259     mapping (address => mapping (address => uint256)) public totalRewardsToUser;
260 
261     mapping (address => mapping (address => bool)) public canClaimDividendOfUser;
262 
263     mapping (address => bool) public availableRewards;
264     mapping (address => address) public pathRewards;
265 
266     mapping (address => bool) public allowed;
267     mapping (address => address) public choice;
268 
269     mapping (address => Share) public shares;
270 
271     //bool public blacklistMode = true;
272 
273     address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
274     address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
275     address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
276 
277     uint256 public totalShares;
278     uint256 public totalDividends;
279     uint256 public totalDistributed; // to be shown in UI
280     uint256 public dividendsPerShare;
281     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
282 
283     modifier onlyToken() {
284         require(msg.sender == _token); _;
285     }
286 
287     constructor (
288         address _router,
289         address _owner
290     ) Auth(_owner) {
291         router = _router != address(0) ? IDEXRouter(_router) : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
292         _token = msg.sender;
293 
294         allowed[USDT] = true;
295         allowed[USDC] = true;
296         allowed[DAI] = true;
297 
298         IERC20(BASE).approve(_router, 2**256 - 1);
299     }
300 
301     receive() external payable {}
302 
303     function getTotalRewards(address token) public view returns (uint256) {
304         return totalRewardsDistributed[token];
305     }
306 
307     function getTotalRewardsToUser(address token, address user) public view returns (uint256) {
308         return totalRewardsToUser[token][user];
309     }
310 
311     function checkCanClaimDividendOfUser(address user, address claimer) public view returns (bool) {
312         return canClaimDividendOfUser[user][claimer];
313     }
314 
315     function setReward(
316         address _reward,
317         bool status
318     ) public onlyOwner {
319         availableRewards[_reward] = status;
320     }
321 
322     function setPathReward(
323         address _reward,
324         address _path
325     ) public onlyOwner {
326         pathRewards[_reward] = _path;
327     }
328 
329     function getPathReward(
330         address _reward
331     ) public view returns (address) {
332         return pathRewards[_reward];
333     }
334 
335     function changeRouterVersion(
336         address _router
337     ) external onlyOwner {
338         IDEXRouter _uniswapV2Router = IDEXRouter(_router);
339         router = _uniswapV2Router;
340     }
341 
342     function setShare(
343         address shareholder,
344         uint256 amount
345     ) external override onlyToken {
346 
347         if (shares[shareholder].amount > 0) {
348             if (allowed[choice[shareholder]]) {
349                 distributeDividend(shareholder, choice[shareholder]);
350             } else {
351                 distributeDividend(shareholder, USDT);
352             }
353         }
354 
355         if (amount > 0 && shares[shareholder].amount == 0) {
356             addShareholder(shareholder);
357         } else if (amount == 0 && shares[shareholder].amount > 0) {
358             removeShareholder(shareholder);
359         }
360 
361         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
362         shares[shareholder].amount = amount;
363         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
364     }
365 
366     function deposit() external payable override onlyToken {
367         uint256 amount = msg.value;
368 
369         totalDividends = totalDividends.add(amount);
370         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
371     }
372 
373     function distributeDividend(
374         address shareholder,
375         address rewardAddress
376     ) internal {
377         require(allowed[rewardAddress], "Invalid reward address!");
378 
379         if (shares[shareholder].amount == 0) {
380             return;
381         }
382 
383         uint256 amount = getUnpaidEarnings(shareholder);
384         if (amount > 0) {
385             totalDistributed = totalDistributed.add(amount);
386 
387             shareholderClaims[shareholder] = block.timestamp;
388             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
389             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
390 
391             if (rewardAddress == address(BASE)) {
392 
393                 payable(shareholder).transfer(amount);
394                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(amount);  
395                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(amount);
396 
397             } else {
398 
399                 IERC20 rewardToken = IERC20(rewardAddress);
400 
401                 uint256 beforeBalance = rewardToken.balanceOf(shareholder);
402 
403                 if (pathRewards[rewardAddress] == address(0)) {
404                     address[] memory path = new address[](2);
405                     path[0] = address(BASE);
406                     path[1] = rewardAddress;
407 
408                     router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
409                         0,
410                         path,
411                         shareholder,
412                         block.timestamp
413                     );                 
414                 } else {
415                     address[] memory path = new address[](3);
416                     path[0] = address(BASE);
417                     path[1] = pathRewards[rewardAddress];
418                     path[2] = rewardAddress;
419 
420                     router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
421                         0,
422                         path,
423                         shareholder,
424                         block.timestamp
425                     );
426 
427                 }
428 
429                 uint256 afterBalance = rewardToken.balanceOf(shareholder);
430                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(afterBalance.sub(beforeBalance));
431                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(afterBalance.sub(beforeBalance));
432 
433             }
434 
435         }
436     }
437 
438     function makeApprove(
439         address token,
440         address spender,
441         uint256 amount
442     ) public onlyOwner {
443         IERC20(token).approve(spender, amount);
444     }
445 
446     function claimDividend(
447         address rewardAddress
448     ) external {
449         distributeDividend(msg.sender, rewardAddress);
450     }
451 
452     function setChoice(
453         address _choice
454     ) external {
455         require(allowed[_choice]);
456         choice[msg.sender] = _choice;
457     }
458 
459     function toggleChoice(
460         address _choice
461     ) public onlyOwner {
462         allowed[_choice] = !allowed[_choice];
463     }
464 
465     function getChoice(
466         address _choice
467     ) public view returns (bool) {
468         return allowed[_choice];
469     }
470 
471     function claimDividendOfUser(
472         address user,
473         address rewardAddress
474     ) external {
475         require(canClaimDividendOfUser[user][msg.sender], "You can't do that");
476 
477         distributeDividend(user, rewardAddress);
478     }
479 
480     function setClaimDividendOfUser(
481         address claimer,
482         bool status
483     ) external {
484         canClaimDividendOfUser[msg.sender][claimer] = status;
485     }
486 
487     function getUnpaidEarnings(
488         address shareholder
489     ) public view returns (uint256) {
490         if (shares[shareholder].amount == 0) {
491             return 0;
492         }
493 
494         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
495         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
496 
497         if (shareholderTotalDividends <= shareholderTotalExcluded) {
498             return 0;
499         }
500 
501         return shareholderTotalDividends.sub(shareholderTotalExcluded);
502     }
503 
504     function getCumulativeDividends(
505         uint256 share
506     ) internal view returns (uint256) {
507         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
508     }
509 
510     function addShareholder(
511         address shareholder
512     ) internal {
513         shareholderIndexes[shareholder] = shareholders.length;
514         shareholders.push(shareholder);
515     }
516 
517     function removeShareholder(
518         address shareholder
519     ) internal {
520         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
521         shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
522         shareholders.pop();
523     }
524 
525     function Sweep() external onlyOwner {
526         uint256 balance = address(this).balance;
527         payable(msg.sender).transfer(balance);
528     }
529 
530     function changeBASE(
531         address _BASE
532     ) external onlyOwner {
533         BASE = IERC20(_BASE);
534     }
535 
536     function changeWETH(
537         address _WETH
538     ) external onlyOwner {
539         WETH = _WETH;
540     }
541 
542     function changeUSDT(
543         address _USDT
544     ) external onlyOwner {
545         USDT = _USDT;
546     }
547 
548     function newApproval(
549         address token,
550         address _contract
551     ) external onlyOwner {
552         IERC20(token).approve(_contract, 2**256 - 1);
553     }
554 
555     function transferForeignToken(
556         address token,
557         address _to
558     ) external onlyOwner returns (bool _sent) {
559         require(token != address(this), "Can't withdraw native tokens");
560         uint256 _contractBalance = IERC20(token).balanceOf(address(this));
561         _sent = IERC20(token).transfer(_to, _contractBalance);
562     }
563 
564 }
565 
566 contract BEAR is IERC20, Auth {
567     using SafeMath for uint256;
568 
569     uint256 public constant MASK = type(uint128).max;
570     address BASE = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
571     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
572     address DEAD = 0x000000000000000000000000000000000000dEaD;
573     address ZERO = 0x0000000000000000000000000000000000000000;
574     address DEAD_NON_CHECKSUM = 0x000000000000000000000000000000000000dEaD;
575 
576     string constant _name = "Bear Bucks";
577     string constant _symbol = "BEAR";
578     uint8 constant _decimals = 9;
579 
580     uint256 _totalSupply = 1000000000 * (10 ** _decimals);
581     uint256 public _maxWallet = _totalSupply.div(50);
582 
583     uint256 public minAmountToTriggerSwap = 0;
584 
585     mapping (address => uint256) _balances;
586     mapping (address => mapping (address => uint256)) _allowances;
587 
588     mapping (address => bool) public isDisabledExempt;
589     mapping (address => bool) public isFeeExempt;
590     mapping (address => bool) public isDividendExempt;
591     mapping (address => bool) public _isFree;
592 
593     bool public isFeeOnTransferEnabled = false;
594 
595     mapping (address => bool) public automatedMarketMakerPairs;
596 
597     uint256 buyLiquidityFee = 0;
598     uint256 buyReflectionFee = 300;
599     uint256 buyOperationsFee = 700;
600     uint256 buyTreasuryFee = 0;
601     uint256 buyTotalFee = 1000;
602 
603     uint256 sellLiquidityFee = 250;
604     uint256 sellReflectionFee = 1750;
605     uint256 sellOperationsFee = 0;
606     uint256 sellTreasuryFee = 0;
607     uint256 sellTotalFee = 2000;
608 
609     uint256 feeDenominator = 10000;
610 
611     uint256 _liquidityTokensToSwap;
612     uint256 _reflectionTokensToSwap;
613     uint256 _operationsTokensToSwap;
614     uint256 _treasuryTokensToSwap;
615 
616     address public autoLiquidityReceiver = 0x2FFBfc2715037A9Af201aFeF7e998912cC2b048c;
617     address public operationsFeeReceiver = 0x6F33931D8F66e52f44acd3De3F870191699E98a2;
618     address public treasuryFeeReceiver = msg.sender;
619 
620     IDEXRouter public router;
621     address public pair;
622 
623     DividendDistributor distributor;
624     address public distributorAddress;
625 
626     bool public swapEnabled = true;
627     uint256 private swapMinimumTokens = _totalSupply / 5000; // 0.0025%
628 
629     bool public tradingEnabled = false;
630 
631     bool inSwap;
632     modifier swapping() {
633         inSwap = true; _;
634         inSwap = false;
635     }
636 
637     constructor () Auth(msg.sender) {
638         address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
639         router = IDEXRouter(_router);
640         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
641         _allowances[address(this)][address(router)] = _totalSupply;
642         WETH = router.WETH();
643         distributor = new DividendDistributor(_router, msg.sender);
644         distributorAddress = address(distributor);
645 
646         isDisabledExempt[msg.sender] = true;
647         isFeeExempt[msg.sender] = true;
648         isDividendExempt[pair] = true;
649         isDividendExempt[address(this)] = true;
650         isDividendExempt[DEAD] = true;
651 
652         autoLiquidityReceiver = msg.sender;
653 
654         _setAutomatedMarketMakerPair(pair, true);
655 
656         approve(_router, _totalSupply);
657         approve(address(pair), _totalSupply);
658         _balances[msg.sender] = _totalSupply;
659         emit Transfer(address(0), msg.sender, _totalSupply);
660     }
661     
662 
663     receive() external payable {}
664 
665     function totalSupply() external view override returns (uint256) { return _totalSupply; }
666     function decimals() external pure override returns (uint8) { return _decimals; }
667     function symbol() external pure override returns (string memory) { return _symbol; }
668     function name() external pure override returns (string memory) { return _name; }
669     function getOwner() external view override returns (address) { return owner; }
670     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
671     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
672 
673     function approve(
674         address spender,
675         uint256 amount
676     ) public override returns (bool) {
677         _allowances[msg.sender][spender] = amount;
678         emit Approval(msg.sender, spender, amount);
679         return true;
680     }
681 
682     function approveMax(
683         address spender
684     ) external returns (bool) {
685         return approve(spender, _totalSupply);
686     }
687 
688     function transfer(
689         address recipient,
690         uint256 amount
691     ) external override returns (bool) {
692         return _transferFrom(msg.sender, recipient, amount);
693     }
694 
695     function transferFrom(
696         address sender,
697         address recipient,
698         uint256 amount
699     ) external override returns (bool) {
700         if (_allowances[sender][msg.sender] != _totalSupply) {
701             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
702         }
703 
704         return _transferFrom(sender, recipient, amount);
705     }
706 
707     function _transferFrom(
708         address sender,
709         address recipient,
710         uint256 amount
711     ) internal returns (bool) {
712         if (inSwap) {
713             return _basicTransfer(sender, recipient, amount);
714         }
715 
716         require(tradingEnabled || isDisabledExempt[sender], "Trading is currently disabled");
717 
718         address routerAddress = address(router);
719         bool isSell = automatedMarketMakerPairs[recipient] || recipient == routerAddress;
720 
721         if (!isSell && !_isFree[recipient]) {
722             require((_balances[recipient] + amount) < _maxWallet, "Max wallet has been triggered");
723         }
724 
725         if (isSell && amount >= minAmountToTriggerSwap) {
726             if (shouldSwapBack()) {
727                 swapBack();
728             }
729         }
730 
731         _balances[sender] = _balances[sender].sub(amount, "Insufficient balance");
732 
733         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
734 
735         _balances[recipient] = _balances[recipient].add(amountReceived);
736 
737         if (!isDividendExempt[sender]) {
738             try distributor.setShare(sender, _balances[sender]) {} catch {}
739         }
740         if (!isDividendExempt[recipient]) {
741             try distributor.setShare(recipient, _balances[recipient]) {} catch {}
742         }
743 
744         emit Transfer(sender, recipient, amountReceived);
745         return true;
746     }
747 
748     function _basicTransfer(
749         address sender,
750         address recipient,
751         uint256 amount
752     ) internal returns (bool) {
753         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
754         _balances[recipient] = _balances[recipient].add(amount);
755         return true;
756     }
757 
758     function shouldTakeFee(
759         address sender,
760         address recipient
761     ) internal view returns (bool) {
762 
763         if (isFeeOnTransferEnabled) {
764             return !isFeeExempt[sender] && !isFeeExempt[recipient];
765         } else {
766             address routerAddress = address(router);
767             bool isBuy = automatedMarketMakerPairs[sender] || sender == routerAddress;
768             bool isSell =  automatedMarketMakerPairs[recipient]|| recipient == routerAddress;
769 
770             if (isBuy || isSell) {
771                 return !isFeeExempt[sender] && !isFeeExempt[recipient];
772             } else {
773                 return false;
774             }
775         }
776 
777     }
778 
779     function getTotalFee(
780         bool selling
781     ) public view returns (uint256) {
782         if (selling) {
783             return sellTotalFee;
784         }
785         return buyTotalFee;
786     }
787 
788     function takeFee(
789         address sender,
790         address receiver,
791         uint256 amount
792     ) internal returns (uint256) {
793         address routerAddress = address(router);
794         bool isSell = automatedMarketMakerPairs[receiver] || receiver == routerAddress;
795 
796         uint256 totalFee = getTotalFee(isSell);
797         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
798 
799         if (totalFee > 0) {
800             if (isSell) {
801                 if (sellLiquidityFee > 0) {
802                     _liquidityTokensToSwap += feeAmount * sellLiquidityFee / totalFee;
803                 }
804                 if (sellOperationsFee > 0) {
805                     _operationsTokensToSwap += feeAmount * sellOperationsFee / totalFee;
806                 }
807                 if (sellReflectionFee > 0) {
808                     _reflectionTokensToSwap += feeAmount * sellReflectionFee / totalFee;
809                 }
810                 if (sellTreasuryFee > 0) {
811                     _treasuryTokensToSwap += feeAmount * sellTreasuryFee / totalFee;
812                 }
813             } else {
814                 if (buyLiquidityFee > 0) {
815                     _liquidityTokensToSwap += feeAmount * buyLiquidityFee / totalFee;
816                 }
817                 if (buyOperationsFee > 0) {
818                     _operationsTokensToSwap += feeAmount * buyOperationsFee / totalFee;
819                 }
820                 if (buyReflectionFee > 0) {
821                     _reflectionTokensToSwap += feeAmount * buyReflectionFee / totalFee;
822                 }
823                 if (buyTreasuryFee > 0) {
824                     _treasuryTokensToSwap += feeAmount * buyTreasuryFee / totalFee;
825                 }
826             }
827         }
828 
829         _balances[address(this)] = _balances[address(this)].add(feeAmount);
830         emit Transfer(sender, address(this), feeAmount);
831 
832         return amount.sub(feeAmount);
833     }
834 
835     function shouldSwapBack() internal view returns (bool) {
836         return !automatedMarketMakerPairs[msg.sender] && !inSwap && swapEnabled && _balances[address(this)] >= swapMinimumTokens;
837     }
838 
839     function setAutomatedMarketMakerPair(
840         address _pair,
841         bool value
842     ) public onlyOwner {
843         _setAutomatedMarketMakerPair(_pair, value);
844     }
845 
846     function _setAutomatedMarketMakerPair(
847         address _pair,
848         bool value
849     ) private {
850         automatedMarketMakerPairs[_pair] = value;
851         if (value) {
852             isDividendExempt[_pair] = true;
853         }
854         if (!value) {
855             isDividendExempt[_pair] = false;
856         }
857     }
858 
859     function swapBack() internal swapping {
860         uint256 contractBalance = balanceOf(address(this));
861         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_operationsTokensToSwap).add(_reflectionTokensToSwap).add(_treasuryTokensToSwap);
862         
863         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
864         uint256 amountToSwap = contractBalance.sub(tokensForLiquidity);
865 
866         address[] memory path = new address[](2);
867         path[0] = address(this);
868         path[1] = WETH;
869         uint256 balanceBefore = address(this).balance;
870 
871         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
872             amountToSwap,
873             0,
874             path,
875             address(this),
876             block.timestamp
877         );
878 
879         uint256 amountETH = address(this).balance.sub(balanceBefore);
880 
881         uint256 amountETHLiquidity = amountETH.mul(_liquidityTokensToSwap).div(totalTokensToSwap).div(2);
882         uint256 amountETHReflection = amountETH.mul(_reflectionTokensToSwap).div(totalTokensToSwap);
883         uint256 amountETHOperations = amountETH.mul(_operationsTokensToSwap).div(totalTokensToSwap);
884         uint256 amountETHTreasury = amountETH.mul(_treasuryTokensToSwap).div(totalTokensToSwap);
885         
886         _liquidityTokensToSwap = 0;
887         _operationsTokensToSwap = 0;
888         _reflectionTokensToSwap = 0;
889         _treasuryTokensToSwap = 0;
890 
891         if (amountETHReflection > 0) {
892             try distributor.deposit{value: amountETHReflection}() {} catch {}
893         }
894         if (amountETHOperations > 0) {
895             payable(operationsFeeReceiver).transfer(amountETHOperations);
896         }
897         if (amountETHTreasury > 0) {
898             payable(treasuryFeeReceiver).transfer(amountETHTreasury);
899         }
900 
901         if (tokensForLiquidity > 0) {
902             router.addLiquidityETH{value: amountETHLiquidity}(
903                 address(this),
904                 tokensForLiquidity,
905                 0,
906                 0,
907                 autoLiquidityReceiver,
908                 block.timestamp
909             );
910             emit AutoLiquify(amountETHLiquidity, tokensForLiquidity);
911         }
912     }
913 
914     function buyTokens(
915         uint256 amount,
916         address to
917     ) internal swapping {
918         address[] memory path = new address[](2);
919         path[0] = WETH;
920         path[1] = address(this);
921 
922         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
923             0,
924             path,
925             to,
926             block.timestamp
927         );
928     }
929     
930     function Sweep() external onlyOwner {
931         uint256 balance = address(this).balance;
932         payable(msg.sender).transfer(balance);
933     }
934 
935     function changeBASE(
936         address _BASE
937     ) external onlyOwner {
938         BASE = _BASE;
939     }
940 
941     function changeWETH(
942         address _WETH
943     ) external onlyOwner {
944         WETH = _WETH;
945     }
946 
947     function changeRouterPairDistributor(
948         address _router,
949         bool _setWETH
950     ) external onlyOwner {
951         router = IDEXRouter(_router);
952         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
953         _allowances[address(this)][address(router)] = _totalSupply;
954         if (_setWETH) {
955             WETH = router.WETH();
956         }
957         distributor = new DividendDistributor(_router, msg.sender);
958         distributorAddress = address(distributor);
959     }
960 
961     function transferForeignToken(
962         address _token,
963         address _to
964     ) external onlyOwner returns (bool _sent) {
965         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
966         _sent = IERC20(_token).transfer(_to, _contractBalance);
967     }
968 
969     function setMaxWallet(
970         uint256 amount
971     ) external authorized {
972         _maxWallet = amount;
973     }
974 
975     function setMinAmountToTriggerSwap(
976         uint256 amount
977     ) external authorized {
978         minAmountToTriggerSwap = amount;
979     }
980 
981     function setIsFeeOnTransferEnabled(
982         bool status
983     ) external authorized {
984         isFeeOnTransferEnabled = status;
985     }
986 
987     function setIsDividendExempt(
988         address holder,
989         bool exempt
990     ) external authorized {
991         isDividendExempt[holder] = exempt;
992         if (exempt) {
993             distributor.setShare(holder, 0);
994         } else {
995             distributor.setShare(holder, _balances[holder]);
996         }
997     }
998 
999     function checkIsDividendExempt(
1000         address holder
1001     ) public view returns (bool) {
1002         return isDividendExempt[holder];
1003     }
1004 
1005     function setIsDisabledExempt(
1006         address holder,
1007         bool exempt
1008     ) external authorized {
1009         isDisabledExempt[holder] = exempt;
1010     }
1011 
1012     function checkIsDisabledExempt(
1013         address holder
1014     ) public view returns (bool) {
1015         return isDisabledExempt[holder];
1016     }
1017 
1018     function setIsFeeExempt(
1019         address holder,
1020         bool exempt
1021     ) external authorized {
1022         isFeeExempt[holder] = exempt;
1023     }
1024 
1025     function checkIsFeeExempt(
1026         address holder
1027     ) public view returns (bool) {
1028         return isFeeExempt[holder];
1029     }
1030 
1031     function setFree(
1032         address holder
1033     ) public onlyOwner {
1034         _isFree[holder] = true;
1035     }
1036     
1037     function unSetFree(
1038         address holder
1039     ) public onlyOwner {
1040         _isFree[holder] = false;
1041     }
1042 
1043     function checkFree(
1044         address holder
1045     ) public view onlyOwner returns (bool) {
1046         return _isFree[holder];
1047     }
1048 
1049     function setFees(
1050         uint256 _buyLiquidityFee,
1051         uint256 _buyReflectionFee,
1052         uint256 _buyOperationsFee,
1053         uint256 _buyTreasuryFee,
1054         uint256 _sellLiquidityFee,
1055         uint256 _sellReflectionFee,
1056         uint256 _sellOperationsFee,
1057         uint256 _sellTreasuryFee,
1058         uint256 _feeDenominator
1059     ) external authorized {
1060         buyLiquidityFee = _buyLiquidityFee;
1061         buyReflectionFee = _buyReflectionFee;
1062         buyOperationsFee = _buyOperationsFee;
1063         buyTreasuryFee = _buyTreasuryFee;
1064         buyTotalFee = _buyLiquidityFee.add(_buyReflectionFee).add(_buyOperationsFee).add(_buyTreasuryFee);
1065 
1066         sellLiquidityFee = _sellLiquidityFee;
1067         sellReflectionFee = _sellReflectionFee;
1068         sellOperationsFee = _sellOperationsFee;
1069         sellTreasuryFee = _sellTreasuryFee;
1070         sellTotalFee = _sellLiquidityFee.add(_sellReflectionFee).add(_sellOperationsFee).add(_sellTreasuryFee);
1071 
1072         feeDenominator = _feeDenominator;
1073     }
1074 
1075     function setFeeReceivers(
1076         address _autoLiquidityReceiver,
1077         address _operationsFeeReceiver,
1078         address _treasuryFeeReceiver
1079     ) external authorized {
1080         autoLiquidityReceiver = _autoLiquidityReceiver;
1081         operationsFeeReceiver = _operationsFeeReceiver;
1082         treasuryFeeReceiver = _treasuryFeeReceiver;
1083     }
1084 
1085     function enableTrading() external authorized {
1086         if (!tradingEnabled) {
1087             tradingEnabled = true;
1088         }
1089     }
1090 
1091     function toggleTrading(
1092         bool _enabled
1093     ) external authorized {
1094         tradingEnabled = _enabled;
1095     }
1096 
1097     function setSwapBackSettings(
1098         bool _enabled,
1099         uint256 _amount
1100     ) external authorized {
1101         swapEnabled = _enabled;
1102         swapMinimumTokens = _amount;
1103     }
1104 
1105     function getCirculatingSupply() public view returns (uint256) {
1106         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
1107     }
1108     
1109     function changeRouterVersion(
1110         address _router
1111     ) external onlyOwner returns (address _pair) {
1112         IDEXRouter _uniswapV2Router = IDEXRouter(_router);
1113 
1114         _pair = IDEXFactory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1115         if (_pair == address(0)) {
1116             _pair = IDEXFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1117         }
1118         pair = _pair;
1119 
1120         router = _uniswapV2Router;
1121         _allowances[address(this)][address(router)] = _totalSupply;
1122     }
1123 
1124     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
1125 }