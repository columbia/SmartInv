1 // SPDX-License-Identifier: MIT
2 
3 // $LEFT CURVE COIN: "left curve see coin, left curve buy coin"
4 
5 // https://t.me/LeftCoin
6 
7 // https://twitter.com/leftcoineth
8 
9 pragma solidity ^0.7.6;
10 
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22 
23     function sub(
24         uint256 a,
25         uint256 b,
26         string memory errorMessage
27     ) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41 
42         return c;
43     }
44 
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48 
49     function div(
50         uint256 a,
51         uint256 b,
52         string memory errorMessage
53     ) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 }
59 
60 /**
61  * BEP20 standard interface.
62  */
63 interface IBEP20 {
64     function totalSupply() external view returns (uint256);
65 
66     function decimals() external view returns (uint8);
67 
68     function symbol() external view returns (string memory);
69 
70     function name() external view returns (string memory);
71 
72     function getOwner() external view returns (address);
73 
74     function balanceOf(address account) external view returns (uint256);
75 
76     function transfer(address recipient, uint256 amount)
77         external
78         returns (bool);
79 
80     function allowance(address _owner, address spender)
81         external
82         view
83         returns (uint256);
84 
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(
95         address indexed owner,
96         address indexed spender,
97         uint256 value
98     );
99 }
100 
101 abstract contract Auth {
102     address public owner;
103     mapping(address => bool) internal authorizations;
104 
105     constructor(address _owner) {
106         owner = _owner;
107         authorizations[_owner] = true;
108     }
109 
110     modifier onlyOwner() {
111         require(isOwner(msg.sender), "!OWNER");
112         _;
113     }
114 
115     modifier authorized() {
116         require(isAuthorized(msg.sender), "!AUTHORIZED");
117         _;
118     }
119 
120     function authorize(address adr) public onlyOwner {
121         authorizations[adr] = true;
122     }
123 
124     function unauthorize(address adr) public onlyOwner {
125         authorizations[adr] = false;
126     }
127 
128     function isOwner(address account) public view returns (bool) {
129         return account == owner;
130     }
131 
132     function isAuthorized(address adr) public view returns (bool) {
133         return authorizations[adr];
134     }
135 
136     function transferOwnership(address payable adr) public onlyOwner {
137         owner = adr;
138         authorizations[adr] = true;
139         emit OwnershipTransferred(adr);
140     }
141 
142     event OwnershipTransferred(address owner);
143 }
144 
145 interface IDEXFactory {
146     function createPair(address tokenA, address tokenB)
147         external
148         returns (address pair);
149 
150     function getPair(address tokenA, address tokenB)
151         external
152         view
153         returns (address pair);
154 }
155 
156 interface IDEXRouter {
157     function factory() external pure returns (address);
158 
159     function WETH() external pure returns (address);
160 
161     function getAmountOut(
162         uint256 amountIn,
163         uint256 reserveIn,
164         uint256 reserveOut
165     ) external pure returns (uint256 amountOut);
166 
167     function getAmountsOut(uint256 amountIn, address[] calldata path)
168         external
169         view
170         returns (uint256[] memory amounts);
171 
172     function addLiquidity(
173         address tokenA,
174         address tokenB,
175         uint256 amountADesired,
176         uint256 amountBDesired,
177         uint256 amountAMin,
178         uint256 amountBMin,
179         address to,
180         uint256 deadline
181     )
182         external
183         returns (
184             uint256 amountA,
185             uint256 amountB,
186             uint256 liquidity
187         );
188 
189     function addLiquidityETH(
190         address token,
191         uint256 amountTokenDesired,
192         uint256 amountTokenMin,
193         uint256 amountETHMin,
194         address to,
195         uint256 deadline
196     )
197         external
198         payable
199         returns (
200             uint256 amountToken,
201             uint256 amountETH,
202             uint256 liquidity
203         );
204 
205     function removeLiquidityETH(
206         address token,
207         uint256 liquidity,
208         uint256 amountTokenMin,
209         uint256 amountETHMin,
210         address to,
211         uint256 deadline
212     ) external returns (uint256 amountToken, uint256 amountETH);
213 
214     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
215         uint256 amountIn,
216         uint256 amountOutMin,
217         address[] calldata path,
218         address to,
219         uint256 deadline
220     ) external;
221 
222     function swapExactETHForTokensSupportingFeeOnTransferTokens(
223         uint256 amountOutMin,
224         address[] calldata path,
225         address to,
226         uint256 deadline
227     ) external payable;
228 
229     function swapExactTokensForETHSupportingFeeOnTransferTokens(
230         uint256 amountIn,
231         uint256 amountOutMin,
232         address[] calldata path,
233         address to,
234         uint256 deadline
235     ) external;
236 }
237 
238 contract LeftCurveCoin is IBEP20, Auth {
239     using SafeMath for uint256;
240     // WETH 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
241     address WBNB = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
242     address DEAD = 0x000000000000000000000000000000000000dEaD;
243     address ZERO = 0x0000000000000000000000000000000000000000;
244     address DEV;
245 
246     string constant _name = "Left Curve Coin";
247     string constant _symbol = "LEFT";
248     uint8 constant _decimals = 18;
249 
250     uint256 _totalSupply = 420_690_000_000 * 1e18;
251 
252     uint256 public _maxTxAmount = _totalSupply;
253     uint256 public _maxWalletToken = (_totalSupply * 2) / 100; // 2% of total supply
254 
255     mapping(address => uint256) _balances;
256     mapping(address => mapping(address => uint256)) _allowances;
257 
258     bool public blacklistMode = false;
259     mapping(address => bool) public isBlacklisted;
260 
261     mapping(address => bool) isFeeExempt;
262     mapping(address => bool) isTxLimitExempt;
263     mapping(address => bool) isTimelockExempt;
264 
265     uint256 public liquidityFee = 0;
266     uint256 public marketingFee = 90;
267     uint256 public devFee = 0;
268     uint256 public totalFee = marketingFee + liquidityFee + devFee;
269     uint256 public feeDenominator = 100;
270 
271     uint256 public sellMultiplier = 0;
272 
273     address public autoLiquidityReceiver;
274     address public marketingFeeReceiver;
275     address public devFeeReceiver;
276 
277     uint256 targetLiquidity = 20;
278     uint256 targetLiquidityDenominator = 100;
279 
280     IDEXRouter public router;
281     address public pair;
282 
283     bool public tradingOpen = false;
284 
285     bool public buyCooldownEnabled = false;
286     uint8 public cooldownTimerInterval = 1;
287     mapping(address => uint256) private cooldownTimer;
288 
289     bool public swapEnabled = true;
290     uint256 public swapThreshold = (_totalSupply * 30) / 10000;
291     bool inSwap;
292     modifier swapping() {
293         inSwap = true;
294         _;
295         inSwap = false;
296     }
297 
298     constructor() Auth(msg.sender) {
299         DEV = msg.sender;
300         // Uniswap V2 - 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D 
301         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
302         pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
303         _allowances[address(this)][address(router)] = uint256(-1);
304 
305         isFeeExempt[msg.sender] = true;
306         isFeeExempt[address(DEV)] = true;
307         isTxLimitExempt[msg.sender] = true;
308         isTxLimitExempt[address(DEV)] = true;
309 
310         isTimelockExempt[msg.sender] = true;
311         isTimelockExempt[address(DEV)] = true;
312         isTimelockExempt[DEAD] = true;
313         isTimelockExempt[address(this)] = true;
314         isTimelockExempt[address(DEV)] = true;
315 
316         autoLiquidityReceiver = address(DEV);
317         marketingFeeReceiver = address(DEV);
318         devFeeReceiver = address(DEV);
319 
320         _balances[msg.sender] = _totalSupply;
321         emit Transfer(address(0), msg.sender, _totalSupply);
322     }
323 
324     receive() external payable {}
325 
326     function totalSupply() external view override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     function decimals() external pure override returns (uint8) {
331         return _decimals;
332     }
333 
334     function symbol() external pure override returns (string memory) {
335         return _symbol;
336     }
337 
338     function name() external pure override returns (string memory) {
339         return _name;
340     }
341 
342     function getOwner() external view override returns (address) {
343         return owner;
344     }
345 
346     function balanceOf(address account) public view override returns (uint256) {
347         return _balances[account];
348     }
349 
350     function allowance(address holder, address spender)
351         external
352         view
353         override
354         returns (uint256)
355     {
356         return _allowances[holder][spender];
357     }
358 
359     function approve(address spender, uint256 amount)
360         public
361         override
362         returns (bool)
363     {
364         _allowances[msg.sender][spender] = amount;
365         emit Approval(msg.sender, spender, amount);
366         return true;
367     }
368 
369     function approveMax(address spender) external returns (bool) {
370         return approve(spender, uint256(-1));
371     }
372 
373     function transfer(address recipient, uint256 amount)
374         external
375         override
376         returns (bool)
377     {
378         return _transferFrom(msg.sender, recipient, amount);
379     }
380 
381     function transferFrom(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) external override returns (bool) {
386         if (_allowances[sender][msg.sender] != uint256(-1)) {
387             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
388                 .sub(amount, "Insufficient Allowance");
389         }
390 
391         return _transferFrom(sender, recipient, amount);
392     }
393 
394     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000)
395         external
396         onlyOwner
397     {
398         _maxWalletToken = (_totalSupply * maxWallPercent_base1000) / 1000;
399     }
400 
401     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000)
402         external
403         onlyOwner
404     {
405         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000) / 1000;
406     }
407 
408     function setTxLimit(uint256 amount) external authorized {
409         _maxTxAmount = amount;
410     }
411 
412     function setSwapPair(address _pair) external authorized {
413         pair = _pair;
414     }
415 
416     function _transferFrom(
417         address sender,
418         address recipient,
419         uint256 amount
420     ) internal returns (bool) {
421         if (inSwap) {
422             return _basicTransfer(sender, recipient, amount);
423         }
424 
425         if (!authorizations[sender] && !authorizations[recipient]) {
426             require(tradingOpen, "Trading not open yet");
427         }
428 
429         // Blacklist
430         if (blacklistMode) {
431             require(
432                 !isBlacklisted[sender] && !isBlacklisted[recipient],
433                 "Blacklisted"
434             );
435         }
436 
437         if (
438             !authorizations[sender] &&
439             recipient != address(this) &&
440             recipient != address(DEAD) &&
441             recipient != pair &&
442             recipient != marketingFeeReceiver &&
443             recipient != devFeeReceiver &&
444             recipient != autoLiquidityReceiver
445         ) {
446             uint256 heldTokens = balanceOf(recipient);
447             require(
448                 (heldTokens + amount) <= _maxWalletToken,
449                 "Total Holding is currently limited, you can not buy that much."
450             );
451         }
452 
453         if (
454             sender == pair && buyCooldownEnabled && !isTimelockExempt[recipient]
455         ) {
456             require(
457                 cooldownTimer[recipient] < block.timestamp,
458                 "Please wait for 1min between two buys"
459             );
460             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
461         }
462 
463         // Checks max transaction limit
464         checkTxLimit(sender, amount);
465 
466         if (shouldSwapBack()) {
467             swapBack();
468         }
469 
470         //Exchange tokens
471         _balances[sender] = _balances[sender].sub(
472             amount,
473             "Insufficient Balance"
474         );
475 
476         uint256 amountReceived = shouldTakeFee(sender)
477             ? takeFee(sender, amount, (recipient == pair))
478             : amount;
479         _balances[recipient] = _balances[recipient].add(amountReceived);
480 
481         emit Transfer(sender, recipient, amountReceived);
482         return true;
483     }
484 
485     function _basicTransfer(
486         address sender,
487         address recipient,
488         uint256 amount
489     ) internal returns (bool) {
490         _balances[sender] = _balances[sender].sub(
491             amount,
492             "Insufficient Balance"
493         );
494         _balances[recipient] = _balances[recipient].add(amount);
495         emit Transfer(sender, recipient, amount);
496         return true;
497     }
498 
499     function checkTxLimit(address sender, uint256 amount) internal view {
500         require(
501             amount <= _maxTxAmount || isTxLimitExempt[sender],
502             "TX Limit Exceeded"
503         );
504     }
505 
506     function shouldTakeFee(address sender) internal view returns (bool) {
507         return !isFeeExempt[sender];
508     }
509 
510     function takeFee(
511         address sender,
512         uint256 amount,
513         bool isSell
514     ) internal returns (uint256) {
515         uint256 multiplier = isSell ? sellMultiplier : 100;
516         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(
517             feeDenominator * 100
518         );
519 
520         _balances[address(this)] = _balances[address(this)].add(feeAmount);
521         emit Transfer(sender, address(this), feeAmount);
522 
523         return amount.sub(feeAmount);
524     }
525 
526     function shouldSwapBack() internal view returns (bool) {
527         return
528             msg.sender != pair &&
529             !inSwap &&
530             swapEnabled &&
531             _balances[address(this)] >= swapThreshold;
532     }
533 
534     function clearStuckBalance(uint256 amountPercentage) external authorized {
535         uint256 amountBNB = address(this).balance;
536         payable(marketingFeeReceiver).transfer(
537             (amountBNB * amountPercentage) / 100
538         );
539     }
540 
541     function clearStuckBalance_sender(uint256 amountPercentage)
542         external
543         authorized
544     {
545         uint256 amountBNB = address(this).balance;
546         payable(msg.sender).transfer((amountBNB * amountPercentage) / 100);
547     }
548 
549     function set_sell_multiplier(uint256 _multiplier) public onlyOwner {
550         sellMultiplier = _multiplier;
551     }
552 
553     // switch Trading
554     function tradingStatus(bool _status) public onlyOwner {
555         tradingOpen = _status;
556     }
557 
558     // enable cooldown between trades
559     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
560         buyCooldownEnabled = _status;
561         cooldownTimerInterval = _interval;
562     }
563 
564     function swapBack() internal swapping {
565         uint256 dynamicLiquidityFee = isOverLiquified(
566             targetLiquidity,
567             targetLiquidityDenominator
568         )
569             ? 0
570             : liquidityFee;
571         uint256 amountToLiquify = swapThreshold
572             .mul(dynamicLiquidityFee)
573             .div(totalFee)
574             .div(2);
575         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
576 
577         address[] memory path = new address[](2);
578         path[0] = address(this);
579         path[1] = WBNB;
580 
581         uint256 balanceBefore = address(this).balance;
582 
583         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
584             amountToSwap,
585             0,
586             path,
587             address(this),
588             block.timestamp
589         );
590 
591         uint256 amountBNB = address(this).balance.sub(balanceBefore);
592 
593         uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2));
594 
595         uint256 amountBNBLiquidity = amountBNB
596             .mul(dynamicLiquidityFee)
597             .div(totalBNBFee)
598             .div(2);
599         uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(
600             totalBNBFee
601         );
602         uint256 amountBNBDev = amountBNB.mul(devFee).div(totalBNBFee);
603 
604         (bool tmpSuccess, ) = payable(marketingFeeReceiver).call{
605             value: amountBNBMarketing,
606             gas: 30000
607         }("");
608         (tmpSuccess, ) = payable(devFeeReceiver).call{
609             value: amountBNBDev,
610             gas: 30000
611         }("");
612 
613         // Supress warning msg
614         tmpSuccess = false;
615 
616         if (amountToLiquify > 0) {
617             router.addLiquidityETH{value: amountBNBLiquidity}(
618                 address(this),
619                 amountToLiquify,
620                 0,
621                 0,
622                 autoLiquidityReceiver,
623                 block.timestamp
624             );
625             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
626         }
627     }
628 
629     function enable_blacklist(bool _status) public onlyOwner {
630         blacklistMode = _status;
631     }
632 
633     function manage_blacklist(address[] calldata addresses, bool status)
634         public
635         onlyOwner
636     {
637         for (uint256 i; i < addresses.length; ++i) {
638             isBlacklisted[addresses[i]] = status;
639         }
640     }
641 
642     function setIsFeeExempt(address holder, bool exempt) external authorized {
643         isFeeExempt[holder] = exempt;
644     }
645 
646     function setIsTxLimitExempt(address holder, bool exempt)
647         external
648         authorized
649     {
650         isTxLimitExempt[holder] = exempt;
651     }
652 
653     function setIsTimelockExempt(address holder, bool exempt)
654         external
655         authorized
656     {
657         isTimelockExempt[holder] = exempt;
658     }
659 
660     function setFees(
661         uint256 _liquidityFee,
662         uint256 _marketingFee,
663         uint256 _feeDenominator
664     ) external authorized {
665         liquidityFee = _liquidityFee;
666         marketingFee = _marketingFee;
667         devFee = 0;
668         totalFee = _liquidityFee.add(_marketingFee).add(devFee);
669         feeDenominator = _feeDenominator;
670         require(totalFee < feeDenominator / 3, "Fees cannot be more than 33%");
671     }
672 
673     function setFeeReceivers(
674         address _autoLiquidityReceiver,
675         address _marketingFeeReceiver,
676         address _devFeeReceiver
677     ) external authorized {
678         autoLiquidityReceiver = _autoLiquidityReceiver;
679         marketingFeeReceiver = _marketingFeeReceiver;
680         devFeeReceiver = _devFeeReceiver;
681     }
682 
683     function setSwapBackSettings(bool _enabled, uint256 _amount)
684         external
685         authorized
686     {
687         swapEnabled = _enabled;
688         swapThreshold = _amount;
689     }
690 
691     function setTargetLiquidity(uint256 _target, uint256 _denominator)
692         external
693         authorized
694     {
695         targetLiquidity = _target;
696         targetLiquidityDenominator = _denominator;
697     }
698 
699     function getCirculatingSupply() public view returns (uint256) {
700         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
701     }
702 
703     function getLiquidityBacking(uint256 accuracy)
704         public
705         view
706         returns (uint256)
707     {
708         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
709     }
710 
711     function isOverLiquified(uint256 target, uint256 accuracy)
712         public
713         view
714         returns (bool)
715     {
716         return getLiquidityBacking(accuracy) > target;
717     }
718 
719     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
720 }