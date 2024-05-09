1 /*                                         
2 MoonChan                                                                                                                  
3 */
4 
5 //SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.6;
7 
8 /**
9  * SAFEMATH LIBRARY
10  */
11 library SafeMath {
12     function tryAdd(uint256 a, uint256 b)
13         internal
14         pure
15         returns (bool, uint256)
16     {
17         unchecked {
18             uint256 c = a + b;
19             if (c < a) return (false, 0);
20             return (true, c);
21         }
22     }
23 
24     function trySub(uint256 a, uint256 b)
25         internal
26         pure
27         returns (bool, uint256)
28     {
29         unchecked {
30             if (b > a) return (false, 0);
31             return (true, a - b);
32         }
33     }
34 
35     function tryMul(uint256 a, uint256 b)
36         internal
37         pure
38         returns (bool, uint256)
39     {
40         unchecked {
41             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42             // benefit is lost if 'b' is also tested.
43             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
44             if (a == 0) return (true, 0);
45             uint256 c = a * b;
46             if (c / a != b) return (false, 0);
47             return (true, c);
48         }
49     }
50 
51     function tryDiv(uint256 a, uint256 b)
52         internal
53         pure
54         returns (bool, uint256)
55     {
56         unchecked {
57             if (b == 0) return (false, 0);
58             return (true, a / b);
59         }
60     }
61 
62     function tryMod(uint256 a, uint256 b)
63         internal
64         pure
65         returns (bool, uint256)
66     {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a % b);
70         }
71     }
72 
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a + b;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a - b;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a * b;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a / b;
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a % b;
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         unchecked {
99             require(b <= a, errorMessage);
100             return a - b;
101         }
102     }
103 
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         unchecked {
110             require(b > 0, errorMessage);
111             return a / b;
112         }
113     }
114 
115     function mod(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         unchecked {
121             require(b > 0, errorMessage);
122             return a % b;
123         }
124     }
125 }
126 
127 interface IERC20 {
128     function totalSupply() external view returns (uint256);
129 
130     function decimals() external view returns (uint8);
131 
132     function symbol() external view returns (string memory);
133 
134     function name() external view returns (string memory);
135 
136     function getOwner() external view returns (address);
137 
138     function balanceOf(address account) external view returns (uint256);
139 
140     function transfer(address recipient, uint256 amount)
141         external
142         returns (bool);
143 
144     function allowance(address _owner, address spender)
145         external
146         view
147         returns (uint256);
148 
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156 
157     event Transfer(address indexed from, address indexed to, uint256 value);
158     event Approval(
159         address indexed owner,
160         address indexed spender,
161         uint256 value
162     );
163 }
164 
165 abstract contract Ownable {
166     address internal owner;
167 
168     constructor(address _owner) {
169         owner = _owner;
170     }
171 
172     modifier onlyOwner() {
173         require(isOwner(msg.sender), "NOT AN OWNER");
174         _;
175     }
176 
177     function isOwner(address account) public view returns (bool) {
178         return account == owner;
179     }
180 
181     function transferOwnership(address payable adr) public onlyOwner {
182         owner = adr;
183         emit OwnershipTransferred(adr);
184     }
185 
186     event OwnershipTransferred(address owner);
187 }
188 
189 interface IDEXFactory {
190     function createPair(address tokenA, address tokenB)
191         external
192         returns (address pair);
193 }
194 
195 interface Irouter {
196     function factory() external pure returns (address);
197 
198     function WETH() external pure returns (address);
199 
200     function addLiquidity(
201         address tokenA,
202         address tokenB,
203         uint256 amountADesired,
204         uint256 amountBDesired,
205         uint256 amountAMin,
206         uint256 amountBMin,
207         address to,
208         uint256 deadline
209     )
210         external
211         returns (
212             uint256 amountA,
213             uint256 amountB,
214             uint256 liquidity
215         );
216 
217     function addLiquidityETH(
218         address token,
219         uint256 amountTokenDesired,
220         uint256 amountTokenMin,
221         uint256 amountETHMin,
222         address to,
223         uint256 deadline
224     )
225         external
226         payable
227         returns (
228             uint256 amountToken,
229             uint256 amountETH,
230             uint256 liquidity
231         );
232 
233     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
234         uint256 amountIn,
235         uint256 amountOutMin,
236         address[] calldata path,
237         address to,
238         uint256 deadline
239     ) external;
240 
241     function swapExactETHForTokensSupportingFeeOnTransferTokens(
242         uint256 amountOutMin,
243         address[] calldata path,
244         address to,
245         uint256 deadline
246     ) external payable;
247 
248     function swapExactTokensForETHSupportingFeeOnTransferTokens(
249         uint256 amountIn,
250         uint256 amountOutMin,
251         address[] calldata path,
252         address to,
253         uint256 deadline
254     ) external;
255 }
256 
257 contract MoonChan is IERC20, Ownable {
258     using SafeMath for uint256;
259 
260     address public WETH;
261     address public staking;
262     address DEAD = 0x000000000000000000000000000000000000dEaD;
263 
264     string constant _name = "MoonChan";
265     string constant _symbol = "MC";
266     uint8 constant _decimals = 18;
267 
268     uint256 _totalSupply = 1 * 10**6 * (10**_decimals);
269     uint256 public maxTxAmount = _totalSupply.mul(10).div(1000); // 1%
270     uint256 public maxHoldingLimit = _totalSupply.mul(10).div(1000); // 1%
271 
272     mapping(address => uint256) _balances;
273     mapping(address => mapping(address => uint256)) _allowances;
274 
275     mapping(address => bool) isFeeExempt;
276     mapping(address => bool) isTxLimitExempt;
277     mapping(address => bool) isExcludedFromMaxHold;
278     mapping(address => bool) isSniper;
279 
280     uint256 liquidityFee = 20;
281     uint256 teamFee = 10;
282     uint256 marketFee = 20;
283     uint256 totalFee = 50;
284     uint256 feeDenominator = 1000;
285     uint256 maxFee = 150;
286     bool public enableAutoBlacklist;
287     uint256 public gasLimit = 200000000000; // gas limit threshold for blacklist / 1 GWEI = 1,000,000,000
288 
289     address public autoLiquidityReceiver;
290     address public marketingFeeReceiver;
291     address public teamFeeReceiver;
292 
293     uint256 targetLiquidity = 45;
294     uint256 targetLiquidityDenominator = 100;
295 
296     Irouter public router;
297     address public pair;
298 
299     uint256 public launchedAt;
300     uint256 public launchedAtTimestamp;
301     uint256 antiSnipingTime = 60 seconds;
302 
303     uint256 distributorGas = 500000;
304 
305     bool public swapEnabled;
306     bool public tradingOpen;
307 
308     uint256 public swapThreshold = _totalSupply / 2000; // 0.005%
309     bool inSwap;
310     modifier swapping() {
311         inSwap = true;
312         _;
313         inSwap = false;
314     }
315 
316     constructor(
317         address _router,
318         address _market,
319         address _teamFee,
320         address newOwner
321     ) Ownable(newOwner) {
322         router = Irouter(_router);
323         WETH = router.WETH();
324         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
325         _allowances[address(this)][address(router)] = _totalSupply;
326 
327         isFeeExempt[newOwner] = true;
328         isExcludedFromMaxHold[newOwner] = true;
329         isExcludedFromMaxHold[address(this)] = true;
330         isExcludedFromMaxHold[pair] = true;
331         isTxLimitExempt[newOwner] = true;
332         autoLiquidityReceiver = newOwner;
333         marketingFeeReceiver = _market;
334         teamFeeReceiver = _teamFee;
335 
336         approve(_router, _totalSupply);
337         approve(address(pair), _totalSupply);
338         _balances[newOwner] = _totalSupply;
339 
340         emit Transfer(address(0), newOwner, _totalSupply);
341     }
342 
343     receive() external payable {}
344 
345     function totalSupply() external view override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     function decimals() external pure override returns (uint8) {
350         return _decimals;
351     }
352 
353     function symbol() external pure override returns (string memory) {
354         return _symbol;
355     }
356 
357     function name() external pure override returns (string memory) {
358         return _name;
359     }
360 
361     function getOwner() external view override returns (address) {
362         return owner;
363     }
364 
365     function balanceOf(address account) public view override returns (uint256) {
366         return _balances[account];
367     }
368 
369     function allowance(address holder, address spender)
370         external
371         view
372         override
373         returns (uint256)
374     {
375         return _allowances[holder][spender];
376     }
377 
378     function approve(address spender, uint256 amount)
379         public
380         override
381         returns (bool)
382     {
383         _allowances[msg.sender][spender] = amount;
384         emit Approval(msg.sender, spender, amount);
385         return true;
386     }
387 
388     function approveMax(address spender) external returns (bool) {
389         return approve(spender, _totalSupply);
390     }
391 
392     function transfer(address recipient, uint256 amount)
393         external
394         override
395         returns (bool)
396     {
397         return _transferFrom(msg.sender, recipient, amount);
398     }
399 
400     function transferFrom(
401         address sender,
402         address recipient,
403         uint256 amount
404     ) external override returns (bool) {
405         if (_allowances[sender][msg.sender] != _totalSupply) {
406             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
407                 .sub(amount, "Insufficient Allowance");
408         }
409 
410         return _transferFrom(sender, recipient, amount);
411     }
412 
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415         _totalSupply = _totalSupply.add(amount);
416         _balances[account] = _balances[account].add(amount);
417         emit Transfer(address(0), account, amount);
418     }
419 
420     function _transferFrom(
421         address sender,
422         address recipient,
423         uint256 amount
424     ) internal returns (bool) {
425         require(!isSniper[sender], "Sniper detected");
426         require(!isSniper[recipient], "Sniper detected");
427         if (!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
428             // trading disable till launch
429             if (!tradingOpen) {
430                 require(
431                     sender != pair && recipient != pair,
432                     "Trading is not enabled yet"
433                 );
434             }
435             // antibot
436             if (
437                 block.timestamp < launchedAtTimestamp + antiSnipingTime &&
438                 sender != address(router)
439             ) {
440                 if (sender == pair) {
441                     isSniper[recipient] = true;
442                 } else if (recipient == pair) {
443                     isSniper[sender] = true;
444                 }
445             }
446 
447             require(amount <= maxTxAmount, "TX Limit Exceeded");
448         }
449 
450         bool isBuy = sender == pair || sender == address(router);
451         bool isSell = recipient == pair || recipient == address(router);
452 
453         if (isBuy || isSell) {
454             if (tx.gasprice > gasLimit && enableAutoBlacklist) {
455                 if (isBuy) {
456                     isSniper[recipient] = true;
457                     emit antiBotBan(recipient);
458                 } else if (isSell) {
459                     isSniper[sender] = true;
460                     emit antiBotBan(sender);
461                 }
462                 return false;
463             }
464         }
465 
466         if (inSwap) {
467             return _basicTransfer(sender, recipient, amount);
468         }
469 
470         if (shouldSwapBack()) {
471             swapBack();
472         }
473 
474         _balances[sender] = _balances[sender].sub(
475             amount,
476             "Insufficient Balance"
477         );
478         uint256 amountReceived;
479         if (
480             isFeeExempt[sender] ||
481             isFeeExempt[recipient] ||
482             (sender != pair && recipient != pair)
483         ) {
484             amountReceived = amount;
485         } else {
486             amountReceived = takeFee(sender, amount);
487         }
488 
489         // Check for max holding of receiver
490         if (!isExcludedFromMaxHold[recipient]) {
491             require(
492                 _balances[recipient] + amountReceived <= maxHoldingLimit,
493                 "Max holding limit exceeded"
494             );
495         }
496 
497         _balances[recipient] = _balances[recipient].add(amountReceived);
498 
499         emit Transfer(sender, recipient, amountReceived);
500         return true;
501     }
502 
503     function stakingReward(address _to, uint256 _amount) external {
504         require(msg.sender == staking, "Not authorized");
505         _mint(_to, _amount);
506     }
507 
508     function _basicTransfer(
509         address sender,
510         address recipient,
511         uint256 amount
512     ) internal returns (bool) {
513         _balances[sender] = _balances[sender].sub(
514             amount,
515             "Insufficient Balance"
516         );
517         _balances[recipient] = _balances[recipient].add(amount);
518         emit Transfer(sender, recipient, amount);
519         return true;
520     }
521 
522     function takeFee(address sender, uint256 amount)
523         internal
524         returns (uint256)
525     {
526         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
527 
528         _balances[address(this)] = _balances[address(this)].add(feeAmount);
529         emit Transfer(sender, address(this), feeAmount);
530 
531         return amount.sub(feeAmount);
532     }
533 
534     function shouldSwapBack() internal view returns (bool) {
535         return
536             msg.sender != pair &&
537             !inSwap &&
538             swapEnabled &&
539             _balances[address(this)] >= swapThreshold;
540     }
541 
542     function swapBack() internal swapping {
543         uint256 dynamicLiquidityFee = isOverLiquified(
544             targetLiquidity,
545             targetLiquidityDenominator
546         )
547             ? 0
548             : liquidityFee;
549         uint256 amountToLiquify = swapThreshold
550             .mul(dynamicLiquidityFee)
551             .div(totalFee)
552             .div(2);
553         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
554 
555         address[] memory path = new address[](2);
556         path[0] = address(this);
557         path[1] = WETH;
558         uint256 balanceBefore = address(this).balance;
559 
560         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
561             amountToSwap,
562             0,
563             path,
564             address(this),
565             block.timestamp
566         );
567 
568         uint256 amountETH = address(this).balance.sub(balanceBefore);
569 
570         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
571 
572         uint256 amountETHLiquidity = amountETH
573             .mul(dynamicLiquidityFee)
574             .div(totalETHFee)
575             .div(2);
576         uint256 amountETHMarketing = amountETH.mul(marketFee).div(totalETHFee);
577         uint256 amountETHBuyback = amountETH.mul(teamFee).div(totalETHFee);
578 
579         payable(marketingFeeReceiver).transfer(amountETHMarketing);
580         payable(teamFeeReceiver).transfer(amountETHBuyback);
581 
582         if (amountToLiquify > 0) {
583             router.addLiquidityETH{value: amountETHLiquidity}(
584                 address(this),
585                 amountToLiquify,
586                 0,
587                 0,
588                 autoLiquidityReceiver,
589                 block.timestamp
590             );
591             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
592         }
593     }
594 
595     function launched() internal view returns (bool) {
596         return launchedAt != 0;
597     }
598 
599     function launch() public onlyOwner {
600         require(launchedAt == 0, "Already launched boi");
601         launchedAt = block.number;
602         launchedAtTimestamp = block.timestamp;
603         tradingOpen = true;
604         swapEnabled = true;
605     }
606 
607     function setTxLimit(uint256 amount) external onlyOwner {
608         maxTxAmount = amount;
609     }
610 
611     function withdrawFunds(address _user, uint256 _amount) external onlyOwner {
612         require(_amount > 0, "Amount must be greater than 0");
613         payable(_user).transfer(_amount);
614     }
615 
616     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
617         isFeeExempt[holder] = exempt;
618     }
619 
620     function setIsExcludedFromMaxHold(address holder, bool excluded)
621         external
622         onlyOwner
623     {
624         isExcludedFromMaxHold[holder] = excluded;
625     }
626 
627     //Sets new gas limit threshold for blacklist.
628     function setGasLimit(uint256 _limit) external onlyOwner {
629         gasLimit = _limit;
630     }
631 
632     function setEnableAutoBlacklist(bool _status) external onlyOwner {
633         enableAutoBlacklist = _status;
634     }
635 
636     function setIsTxLimitExempt(address holder, bool exempt)
637         external
638         onlyOwner
639     {
640         isTxLimitExempt[holder] = exempt;
641     }
642 
643     function setFees(
644         uint256 _liquidityFee,
645         uint256 _teamFee,
646         uint256 _marketFee
647     ) external onlyOwner {
648         liquidityFee = _liquidityFee;
649         teamFee = _teamFee;
650         marketFee = _marketFee;
651         totalFee = _liquidityFee.add(_teamFee).add(_marketFee);
652         require(totalFee <= maxFee, "can't set fee more than 25%");
653     }
654 
655     function setFeeReceivers(
656         address _autoLiquidityReceiver,
657         address _marketingFeeReceiver,
658         address _teamFeeReceiver
659     ) external onlyOwner {
660         autoLiquidityReceiver = _autoLiquidityReceiver;
661         marketingFeeReceiver = _marketingFeeReceiver;
662         teamFeeReceiver = _teamFeeReceiver;
663     }
664 
665     function setSwapBackSettings(bool _enabled, uint256 _amount)
666         external
667         onlyOwner
668     {
669         swapEnabled = _enabled;
670         swapThreshold = _amount;
671     }
672 
673     function setTargetLiquidity(uint256 _target, uint256 _denominator)
674         external
675         onlyOwner
676     {
677         targetLiquidity = _target;
678         targetLiquidityDenominator = _denominator;
679     }
680 
681     function setMaxHoldingLimit(uint256 _limit) external onlyOwner {
682         maxHoldingLimit = _limit;
683     }
684 
685     function setDistributorSettings(uint256 gas) external onlyOwner {
686         require(gas < 750000);
687         distributorGas = gas;
688     }
689 
690     function getCirculatingSupply() public view returns (uint256) {
691         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
692     }
693 
694     function getLiquidityBacking(uint256 accuracy)
695         public
696         view
697         returns (uint256)
698     {
699         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
700     }
701 
702     function isOverLiquified(uint256 target, uint256 accuracy)
703         public
704         view
705         returns (bool)
706     {
707         return getLiquidityBacking(accuracy) > target;
708     }
709 
710     function setRoute(Irouter _router, address _pair) external onlyOwner {
711         require(
712             address(_router) != address(0),
713             "Router adress cannot be address zero"
714         );
715         require(_pair != address(0), "Pair adress cannot be address zero");
716         router = _router;
717         pair = _pair;
718     }
719 
720     function setStaking(address _stakingAddr) external onlyOwner {
721         staking = _stakingAddr;
722     }
723 
724     function addSniperInList(address _account) external onlyOwner {
725         require(_account != address(router), "We can not blacklist router");
726         require(!isSniper[_account], "Sniper already exist");
727         isSniper[_account] = true;
728     }
729 
730     function removeSniperFromList(address _account) external onlyOwner {
731         require(isSniper[_account], "Not a sniper");
732         isSniper[_account] = false;
733     }
734 
735     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
736     event antiBotBan(address indexed value);
737 }