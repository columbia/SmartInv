1 /*                                         
2               /$$$$$$                  /$$       /$$                 /$$$$$$$$ /$$
3              /$$__  $$                | $$      | $$                | $$_____/|__/
4             | $$  \__/  /$$$$$$   /$$$$$$$  /$$$$$$$  /$$$$$$       | $$       /$$
5             | $$ /$$$$ |____  $$ /$$__  $$ /$$__  $$ |____  $$      | $$$$$   | $$
6             | $$|_  $$  /$$$$$$$| $$  | $$| $$  | $$  /$$$$$$$      | $$__/   | $$
7             | $$  \ $$ /$$__  $$| $$  | $$| $$  | $$ /$$__  $$      | $$      | $$
8             |  $$$$$$/|  $$$$$$$|  $$$$$$$|  $$$$$$$|  $$$$$$$      | $$      | $$
9              \______/  \_______/ \_______/ \_______/ \_______/      |__/      |__/
10                                                                                   
11                                                                                   
12                                                                                                                                                                                                                                                                                                   
13 */
14 
15 //SPDX-License-Identifier: MIT
16 pragma solidity 0.8.15;
17 
18 /**
19  * SAFEMATH LIBRARY
20  */
21 library SafeMath {
22     function tryAdd(uint256 a, uint256 b)
23         internal
24         pure
25         returns (bool, uint256)
26     {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     function trySub(uint256 a, uint256 b)
35         internal
36         pure
37         returns (bool, uint256)
38     {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     function tryMul(uint256 a, uint256 b)
46         internal
47         pure
48         returns (bool, uint256)
49     {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     function tryDiv(uint256 a, uint256 b)
62         internal
63         pure
64         returns (bool, uint256)
65     {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     function tryMod(uint256 a, uint256 b)
73         internal
74         pure
75         returns (bool, uint256)
76     {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a % b);
80         }
81     }
82 
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a + b;
85     }
86 
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a - b;
89     }
90 
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a * b;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a / b;
97     }
98 
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a % b;
101     }
102 
103     function sub(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         unchecked {
109             require(b <= a, errorMessage);
110             return a - b;
111         }
112     }
113 
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         unchecked {
120             require(b > 0, errorMessage);
121             return a / b;
122         }
123     }
124 
125     function mod(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         unchecked {
131             require(b > 0, errorMessage);
132             return a % b;
133         }
134     }
135 }
136 
137 interface IERC20 {
138     function totalSupply() external view returns (uint256);
139 
140     function decimals() external view returns (uint8);
141 
142     function symbol() external view returns (string memory);
143 
144     function name() external view returns (string memory);
145 
146     function getOwner() external view returns (address);
147 
148     function balanceOf(address account) external view returns (uint256);
149 
150     function transfer(address recipient, uint256 amount)
151         external
152         returns (bool);
153 
154     function allowance(address _owner, address spender)
155         external
156         view
157         returns (uint256);
158 
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) external returns (bool);
166 
167     event Transfer(address indexed from, address indexed to, uint256 value);
168     event Approval(
169         address indexed owner,
170         address indexed spender,
171         uint256 value
172     );
173 }
174 
175 abstract contract Ownable {
176     address internal owner;
177 
178     constructor(address _owner) {
179         owner = _owner;
180     }
181 
182     modifier onlyOwner() {
183         require(isOwner(msg.sender), "NOT AN OWNER");
184         _;
185     }
186 
187     function isOwner(address account) public view returns (bool) {
188         return account == owner;
189     }
190 
191     function transferOwnership(address payable adr) public onlyOwner {
192         owner = adr;
193         emit OwnershipTransferred(adr);
194     }
195 
196     event OwnershipTransferred(address owner);
197 }
198 
199 interface IDEXFactory {
200     function createPair(address tokenA, address tokenB)
201         external
202         returns (address pair);
203 }
204 
205 interface Irouter {
206     function factory() external pure returns (address);
207 
208     function WETH() external pure returns (address);
209 
210     function addLiquidity(
211         address tokenA,
212         address tokenB,
213         uint256 amountADesired,
214         uint256 amountBDesired,
215         uint256 amountAMin,
216         uint256 amountBMin,
217         address to,
218         uint256 deadline
219     )
220         external
221         returns (
222             uint256 amountA,
223             uint256 amountB,
224             uint256 liquidity
225         );
226 
227     function addLiquidityETH(
228         address token,
229         uint256 amountTokenDesired,
230         uint256 amountTokenMin,
231         uint256 amountETHMin,
232         address to,
233         uint256 deadline
234     )
235         external
236         payable
237         returns (
238             uint256 amountToken,
239             uint256 amountETH,
240             uint256 liquidity
241         );
242 
243     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
244         uint256 amountIn,
245         uint256 amountOutMin,
246         address[] calldata path,
247         address to,
248         uint256 deadline
249     ) external;
250 
251     function swapExactETHForTokensSupportingFeeOnTransferTokens(
252         uint256 amountOutMin,
253         address[] calldata path,
254         address to,
255         uint256 deadline
256     ) external payable;
257 
258     function swapExactTokensForETHSupportingFeeOnTransferTokens(
259         uint256 amountIn,
260         uint256 amountOutMin,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external;
265 }
266 
267 contract GaddaFi is IERC20, Ownable {
268     using SafeMath for uint256;
269 
270     address public WETH;
271     address DEAD = 0x000000000000000000000000000000000000dEaD;
272 
273     string constant _name = "GaddaFi";
274     string constant _symbol = "GADDA";
275     uint8 constant _decimals = 18;
276 
277     uint256 _totalSupply = 1 * 10**6 * (10**_decimals);
278     uint256 public maxTxAmount = _totalSupply.mul(10).div(1000); // 1%
279 
280     mapping(address => uint256) _balances;
281     mapping(address => mapping(address => uint256)) _allowances;
282 
283     mapping(address => bool) isFeeExempt;
284     mapping(address => bool) isTxLimitExempt;
285     mapping(address => bool) isExcludedFromMaxHold;
286     mapping(address => bool) isSniper;
287 
288     uint256 liquidityFee = 100;
289     uint256 burnFee = 100;
290     uint256 validatorsFee = 500;
291     uint256 totalFee = 700;
292     uint256 feeDenominator = 10000;
293     uint256 maxHoldingLimit = _totalSupply.mul(20).div(1000); // 2%
294 
295     address public autoLiquidityReceiver;
296     address public validatorsFeeReceiver;
297     address public burnFeeReceiver;
298 
299     uint256 targetLiquidity = 45;
300     uint256 targetLiquidityDenominator = 100;
301 
302     Irouter public router;
303     address public pair;
304 
305     uint256 public launchedAt;
306     uint256 public launchedAtTimestamp; 
307 
308     uint256 distributorGas = 500000;
309 
310     bool public swapEnabled;
311     bool public tradingOpen;
312 
313     uint256 public swapThreshold = _totalSupply / 2000; // 0.005%
314     bool inSwap;
315     modifier swapping() {
316         inSwap = true;
317         _;
318         inSwap = false;
319     }
320 
321     constructor(
322         address _router,
323         address _market, 
324         address newOwner
325     ) Ownable(newOwner) {
326         router = Irouter(_router);
327         WETH = router.WETH();
328         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
329         _allowances[address(this)][address(router)] = _totalSupply;
330 
331         isFeeExempt[0x25Ec5bbDFD7f0dD2bb7f172883675C2eDf6Fc81F] = true;
332         isExcludedFromMaxHold[0x25Ec5bbDFD7f0dD2bb7f172883675C2eDf6Fc81F] = true;
333         isExcludedFromMaxHold[address(this)] = true;
334         isExcludedFromMaxHold[pair] = true;
335         isTxLimitExempt[0x25Ec5bbDFD7f0dD2bb7f172883675C2eDf6Fc81F] = true;
336 
337         autoLiquidityReceiver = newOwner;
338         validatorsFeeReceiver = _market;
339         burnFeeReceiver = DEAD;
340 
341         approve(_router, _totalSupply);
342         approve(address(pair), _totalSupply);
343         _balances[0x25Ec5bbDFD7f0dD2bb7f172883675C2eDf6Fc81F] = _totalSupply;
344 
345         emit Transfer(address(0), 0x25Ec5bbDFD7f0dD2bb7f172883675C2eDf6Fc81F, _totalSupply);
346     }
347 
348     receive() external payable {}
349 
350     function totalSupply() external view override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     function decimals() external pure override returns (uint8) {
355         return _decimals;
356     }
357 
358     function symbol() external pure override returns (string memory) {
359         return _symbol;
360     }
361 
362     function name() external pure override returns (string memory) {
363         return _name;
364     }
365 
366     function getOwner() external view override returns (address) {
367         return owner;
368     }
369 
370     function balanceOf(address account) public view override returns (uint256) {
371         return _balances[account];
372     }
373 
374     function allowance(address holder, address spender)
375         external
376         view
377         override
378         returns (uint256)
379     {
380         return _allowances[holder][spender];
381     }
382 
383     function approve(address spender, uint256 amount)
384         public
385         override
386         returns (bool)
387     {
388         _allowances[msg.sender][spender] = amount;
389         emit Approval(msg.sender, spender, amount);
390         return true;
391     }
392 
393     function approveMax(address spender) external returns (bool) {
394         return approve(spender, _totalSupply);
395     }
396 
397     function transfer(address recipient, uint256 amount)
398         external
399         override
400         returns (bool)
401     {
402         return _transferFrom(msg.sender, recipient, amount);
403     }
404 
405     function transferFrom(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) external override returns (bool) {
410         if (_allowances[sender][msg.sender] != _totalSupply) {
411             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
412                 .sub(amount, "Insufficient Allowance");
413         }
414 
415         return _transferFrom(sender, recipient, amount);
416     }
417 
418     function _transferFrom(
419         address sender,
420         address recipient,
421         uint256 amount
422     ) internal returns (bool) {
423         require(!isSniper[sender], "Sniper detected");
424         require(!isSniper[recipient], "Sniper detected");
425         if (!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
426             // trading disable till launch
427             if (!tradingOpen) {
428                 require(
429                     sender != pair && recipient != pair,
430                     "Trading is not enabled yet"
431                 );
432             } 
433 
434             require(amount <= maxTxAmount, "TX Limit Exceeded");
435         }
436 
437         if (inSwap) {
438             return _basicTransfer(sender, recipient, amount);
439         }
440 
441         if (shouldSwapBack()) {
442             swapBack();
443         }
444 
445         _balances[sender] = _balances[sender].sub(
446             amount,
447             "Insufficient Balance"
448         );
449         uint256 amountReceived;
450         if (
451             isFeeExempt[sender] ||
452             isFeeExempt[recipient] ||
453             (sender != pair && recipient != pair)
454         ) {
455             amountReceived = amount;
456         } else {
457             amountReceived = takeFee(sender, amount);
458         }
459 
460         // Check for max holding of receiver
461         if (!isExcludedFromMaxHold[recipient]) {
462             require(
463                 _balances[recipient] + amountReceived <= maxHoldingLimit,
464                 "Max holding limit exceeded"
465             );
466         }
467 
468         _balances[recipient] = _balances[recipient].add(amountReceived);
469 
470         emit Transfer(sender, recipient, amountReceived);
471         return true;
472     }
473 
474     function _basicTransfer(
475         address sender,
476         address recipient,
477         uint256 amount
478     ) internal returns (bool) {
479         _balances[sender] = _balances[sender].sub(
480             amount,
481             "Insufficient Balance"
482         );
483         _balances[recipient] = _balances[recipient].add(amount);
484         emit Transfer(sender, recipient, amount);
485         return true;
486     }
487 
488     function takeFee(address sender, uint256 amount)
489         internal
490         returns (uint256)
491     {
492         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
493 
494         _balances[address(this)] = _balances[address(this)].add(feeAmount);
495         emit Transfer(sender, address(this), feeAmount);
496 
497         return amount.sub(feeAmount);
498     }
499 
500     function shouldSwapBack() internal view returns (bool) {
501         return
502             msg.sender != pair &&
503             !inSwap &&
504             swapEnabled &&
505             _balances[address(this)] >= swapThreshold;
506     }
507 
508     function swapBack() internal swapping {
509         uint256 dynamicLiquidityFee = isOverLiquified(
510             targetLiquidity,
511             targetLiquidityDenominator
512         )
513             ? 0
514             : liquidityFee;
515         uint256 amountToLiquify = swapThreshold
516             .mul(dynamicLiquidityFee)
517             .div(totalFee)
518             .div(2);
519         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
520 
521         address[] memory path = new address[](2);
522         path[0] = address(this);
523         path[1] = WETH;
524         uint256 balanceBefore = address(this).balance;
525 
526         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
527             amountToSwap,
528             0,
529             path,
530             address(this),
531             block.timestamp
532         );
533 
534         uint256 amountETH = address(this).balance.sub(balanceBefore);
535 
536         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
537 
538         uint256 amountETHLiquidity = amountETH
539             .mul(dynamicLiquidityFee)
540             .div(totalETHFee)
541             .div(2);
542         uint256 amountETHMarketing = amountETH.mul(validatorsFee).div(
543             totalETHFee
544         );
545         uint256 amountETHBuyback = amountETH.mul(burnFee).div(totalETHFee);
546 
547         payable(validatorsFeeReceiver).transfer(amountETHMarketing);
548         payable(burnFeeReceiver).transfer(amountETHBuyback);
549 
550         if (amountToLiquify > 0) {
551             router.addLiquidityETH{value: amountETHLiquidity}(
552                 address(this),
553                 amountToLiquify,
554                 0,
555                 0,
556                 autoLiquidityReceiver,
557                 block.timestamp
558             );
559             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
560         }
561     }
562 
563     function launched() internal view returns (bool) {
564         return launchedAt != 0;
565     }
566 
567     function launch() public onlyOwner {
568         require(launchedAt == 0, "Already launched boi");
569         launchedAt = block.number;
570         launchedAtTimestamp = block.timestamp;
571         tradingOpen = true;
572         swapEnabled = true;
573     }
574 
575     function setTxLimit(uint256 amount) external onlyOwner {
576         require(amount >= 1000 ether,"amount should be greater than 1k");
577         maxTxAmount = amount;
578         
579     }
580 
581     function withdrawFunds(address _user, uint256 _amount) external onlyOwner {
582         require(_amount > 0, "Amount must be greater than 0");
583         payable(_user).transfer(_amount);
584     }
585 
586     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
587         isFeeExempt[holder] = exempt;
588     }
589 
590     function setIsExcludedFromMaxHold(address holder, bool excluded)
591         external
592         onlyOwner
593     {
594         isExcludedFromMaxHold[holder] = excluded;
595     }
596 
597     function setIsTxLimitExempt(address holder, bool exempt)
598         external
599         onlyOwner
600     {
601         isTxLimitExempt[holder] = exempt;
602     }
603 
604     function setFees(
605         uint256 _liquidityFee,
606         uint256 _burnFee,
607         uint256 _validatorsFee,
608         uint256 _feeDenominator
609     ) external onlyOwner {
610         liquidityFee = _liquidityFee;
611         burnFee = _burnFee;
612         validatorsFee = _validatorsFee;
613         totalFee = _liquidityFee.add(_burnFee).add(_validatorsFee);
614         feeDenominator = _feeDenominator;
615          require(totalFee <= 2000,"totalFee must be less than 20%");
616     }
617 
618     function setFeeReceivers(
619         address _autoLiquidityReceiver,
620         address _validatorsFeeReceiver,
621         address _burnFeeReceiver
622     ) external onlyOwner {
623         autoLiquidityReceiver = _autoLiquidityReceiver;
624         validatorsFeeReceiver = _validatorsFeeReceiver;
625         burnFeeReceiver = _burnFeeReceiver;
626     }
627 
628     function setSwapBackSettings(bool _enabled, uint256 _amount)
629         external
630         onlyOwner
631     {
632         swapEnabled = _enabled;
633         swapThreshold = _amount;
634     }
635 
636     function setTargetLiquidity(uint256 _target, uint256 _denominator)
637         external
638         onlyOwner
639     {
640         targetLiquidity = _target;
641         targetLiquidityDenominator = _denominator;
642     }
643 
644     function setMaxHoldingLimit(uint256 _limit) external onlyOwner {
645         require(_limit >= 1000 ether,"minimum hloding limit can be set 1k");
646         maxHoldingLimit = _limit;
647 
648     }
649 
650     function setDistributorSettings(uint256 gas) external onlyOwner {
651         require(gas < 750000);
652         distributorGas = gas;
653     }
654 
655     function getCirculatingSupply() public view returns (uint256) {
656         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
657     }
658 
659     function getLiquidityBacking(uint256 accuracy)
660         public
661         view
662         returns (uint256)
663     {
664         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
665     }
666 
667     function isOverLiquified(uint256 target, uint256 accuracy)
668         public
669         view
670         returns (bool)
671     {
672         return getLiquidityBacking(accuracy) > target;
673     }
674 
675     function addSniperInList(address _account) external onlyOwner {
676         require(_account != address(router), "We can not blacklist router");
677         require(!isSniper[_account], "Sniper already exist");
678         isSniper[_account] = true;
679     }
680 
681     function removeSniperFromList(address _account) external onlyOwner {
682         require(isSniper[_account], "Not a sniper");
683         isSniper[_account] = false;
684     }
685 
686     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
687     event BuybackMultiplierActive(uint256 duration);
688 }