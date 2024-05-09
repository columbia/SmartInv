1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
4 
5 /**   
6 
7 $HUSH 
8 
9 Hush Money is simple. Buy, shill, and get paid. And no matter what… Don’t tell the feds 🤫
10 
11 5% Taxes (4% USDC Reflections & 1% Marketing)
12 
13 https://t.me/hushportal
14 
15 */
16 
17 
18 /**
19  * Standard SafeMath, stripped down to just add/sub/mul/div
20  */
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34 
35         return c;
36     }
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
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 }
59 
60 
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73  
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 /**
104  * ERC20 standard interface.
105  */
106 interface IERC20 {
107     function totalSupply() external view returns (uint256);
108     function decimals() external view returns (uint8);
109     function symbol() external view returns (string memory);
110     function name() external view returns (string memory);
111     function balanceOf(address account) external view returns (uint256);
112     function transfer(address recipient, uint256 amount) external returns (bool);
113     function allowance(address _owner, address spender) external view returns (uint256);
114     function approve(address spender, uint256 amount) external returns (bool);
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 interface IDEXFactory {
120     function createPair(address tokenA, address tokenB) external returns (address pair);
121 }
122 
123 interface IDEXRouter {
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126 
127     function addLiquidity(
128         address tokenA,
129         address tokenB,
130         uint amountADesired,
131         uint amountBDesired,
132         uint amountAMin,
133         uint amountBMin,
134         address to,
135         uint deadline
136     ) external returns (uint amountA, uint amountB, uint liquidity);
137 
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 
147     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154 
155     function swapExactETHForTokensSupportingFeeOnTransferTokens(
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external payable;
161 
162     function swapExactTokensForETHSupportingFeeOnTransferTokens(
163         uint amountIn,
164         uint amountOutMin,
165         address[] calldata path,
166         address to,
167         uint deadline
168     ) external;
169 }
170 
171 interface IStormyDaniels {
172     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
173     function setShare(address shareholder, uint256 amount) external;
174     function deposit() external payable;
175     function process(uint256 gas) external;
176     function hush(address shareholder) external;
177 }
178 
179 contract StormyDaniels is IStormyDaniels {
180 
181     using SafeMath for uint256;
182     address _token;
183 
184     address public USDC;
185 
186     IDEXRouter router;
187 
188     struct Share {
189         uint256 amount;
190         uint256 totalExcluded;
191         uint256 totalRealised;
192     }
193 
194     address[] shareholders;
195     mapping (address => uint256) shareholderIndexes;
196     mapping (address => uint256) shareholderClaims;
197     mapping (address => Share) public shares;
198 
199     uint256 public totalShares;
200     uint256 public totalDividends;
201     uint256 public totalDistributed;
202     uint256 public dividendsPerShare;
203     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
204 
205     uint256 public minPeriod = 30 minutes;
206     uint256 public minDistribution = 0 * (10 ** 9);
207 
208     uint256 public currentIndex;
209     bool initialized;
210 
211     modifier initialization() {
212         require(!initialized);
213         _;
214         initialized = true;
215     }
216 
217     modifier onlyToken() {
218         require(msg.sender == _token); _;
219     }
220 
221     constructor () {
222         _token = msg.sender;
223         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
225     }
226     
227     receive() external payable {
228         deposit();
229     }
230 
231     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
232         minPeriod = newMinPeriod;
233         minDistribution = newMinDistribution;
234     }
235 
236     function setShare(address shareholder, uint256 amount) external override onlyToken {
237 
238         if(shares[shareholder].amount > 0){
239             distributeDividend(shareholder);
240         }
241 
242         if(amount > 0 && shares[shareholder].amount == 0){
243             addShareholder(shareholder);
244         }else if(amount == 0 && shares[shareholder].amount > 0){
245             removeShareholder(shareholder);
246         }
247 
248         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
249         shares[shareholder].amount = amount;
250         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
251     }
252 
253     function deposit() public payable override {
254 
255         uint256 balanceBefore = IERC20(USDC).balanceOf(address(this));
256 
257         address[] memory path = new address[](2);
258         path[0] = router.WETH();
259         path[1] = address(USDC);
260 
261         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267 
268         uint256 amount = IERC20(USDC).balanceOf(address(this)).sub(balanceBefore);
269         totalDividends = totalDividends.add(amount);
270         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
271     }
272     
273     function process(uint256 gas) external override {
274         uint256 shareholderCount = shareholders.length;
275 
276         if(shareholderCount == 0) { return; }
277 
278         uint256 iterations = 0;
279         uint256 gasUsed = 0;
280         uint256 gasLeft = gasleft();
281 
282         while(gasUsed < gas && iterations < shareholderCount) {
283 
284             if(currentIndex >= shareholderCount){ currentIndex = 0; }
285 
286             if(shouldDistribute(shareholders[currentIndex])){
287                 distributeDividend(shareholders[currentIndex]);
288             }
289 
290             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
291             gasLeft = gasleft();
292             currentIndex++;
293             iterations++;
294         }
295     }
296     
297     function shouldDistribute(address shareholder) public view returns (bool) {
298         return shareholderClaims[shareholder] + minPeriod < block.timestamp
299                 && getUnpaidEarnings(shareholder) > minDistribution;
300     }
301 
302     function distributeDividend(address shareholder) internal {
303         if(shares[shareholder].amount == 0){ return; }
304 
305         uint256 amount = getUnpaidEarnings(shareholder);
306         if(amount > 0){
307             totalDistributed = totalDistributed.add(amount);
308             IERC20(USDC).transfer(shareholder, amount);
309             shareholderClaims[shareholder] = block.timestamp;
310             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
311             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
312         }
313     }
314     
315     function hush(address shareholder) external override onlyToken {
316         distributeDividend(shareholder);
317     }
318 
319     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
320         if(shares[shareholder].amount == 0){ return 0; }
321 
322         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
323         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
324 
325         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
326 
327         return shareholderTotalDividends.sub(shareholderTotalExcluded);
328     }
329 
330     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
331         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
332     }
333 
334     function addShareholder(address shareholder) internal {
335         shareholderIndexes[shareholder] = shareholders.length;
336         shareholders.push(shareholder);
337     }
338 
339     function removeShareholder(address shareholder) internal {
340         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
341         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
342         shareholders.pop();
343     }
344 }
345 
346 contract HushMoney is IERC20, Ownable {
347     using SafeMath for uint256;
348 
349     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //$USDC token address
350 
351     string private constant _name = "Hush Money";
352     string private constant _symbol = "HUSH";
353     uint8 private constant _decimals = 18;
354     
355     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
356 
357     mapping(address => uint256) private _balances;
358     mapping(address => mapping(address => uint256)) private _allowances;
359     mapping (address => uint256) private cooldown;
360 
361     address private WETH;
362     address DEAD = 0x000000000000000000000000000000000000dEaD;
363     address ZERO = 0x0000000000000000000000000000000000000000;
364 
365     bool public antiBot = true;
366 
367     mapping (address => bool) private bots; 
368     mapping (address => bool) public isFeeExempt;
369     mapping (address => bool) public isTxLimitExempt;
370     mapping (address => bool) public isDividendExempt;
371 
372     uint256 public launchedAt;
373     address private lpWallet = DEAD;
374 
375     uint256 public buyFee = 15;
376     uint256 public sellFee = 25;
377 
378     uint256 public toReflections = 30;
379     uint256 public toLiquidity = 10;
380     uint256 public toMarketing = 60;
381 
382     uint256 public allocationSum = 100;
383 
384     IDEXRouter public router;
385     address public pair;
386     address public factory;
387     address public michaelCohen = payable(0x91144e7A874eB8bF811e66011d7bDD661CedaC38);
388 
389     bool inSwapAndLiquify;
390     bool public swapAndLiquifyEnabled = true;
391     bool public tradingOpen = false;
392     
393     StormyDaniels public stormy;
394     uint256 public stormyGas = 0;
395 
396     modifier lockTheSwap {
397         inSwapAndLiquify = true;
398         _;
399         inSwapAndLiquify = false;
400     }
401 
402     uint256 public maxTx = _totalSupply.div(50);
403     uint256 public maxWallet = _totalSupply.div(50);
404     uint256 public swapThreshold = _totalSupply.div(400);
405 
406     constructor () {
407         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
408             
409         WETH = router.WETH();
410         
411         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
412         
413         _allowances[address(this)][address(router)] = type(uint256).max;
414 
415         stormy = new StormyDaniels();
416         
417         isFeeExempt[owner()] = true;
418         isFeeExempt[michaelCohen] = true;
419 
420         isDividendExempt[pair] = true;
421         isDividendExempt[address(this)] = true;
422         isDividendExempt[DEAD] = true;    
423 
424         isTxLimitExempt[owner()] = true;
425         isTxLimitExempt[pair] = true;
426         isTxLimitExempt[DEAD] = true;
427         isTxLimitExempt[michaelCohen] = true;
428 
429 
430         _balances[owner()] = _totalSupply;
431     
432         emit Transfer(address(0), owner(), _totalSupply);
433     }
434 
435     receive() external payable { }
436 
437 
438     function setBots(address[] memory bots_) external onlyOwner {
439         for (uint i = 0; i < bots_.length; i++) {
440             bots[bots_[i]] = true;
441         }
442     }
443     
444     //once enabled, cannot be reversed
445     function openTrading() external onlyOwner {
446         launchedAt = block.number;
447         tradingOpen = true;
448     }      
449 
450     function changeTotalFees(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
451 
452         buyFee = newBuyFee;
453         sellFee = newSellFee;
454 
455         require(buyFee <= 10, "too high");
456         require(sellFee <= 10, "too high");
457     } 
458     
459     function changeFeeAllocation(uint256 newRewardFee, uint256 newLpFee, uint256 newMarketingFee) external onlyOwner {
460         toReflections = newRewardFee;
461         toLiquidity = newLpFee;
462         toMarketing = newMarketingFee;
463     }
464 
465     function changeTxLimit(uint256 newLimit) external onlyOwner {
466         maxTx = newLimit;
467     }
468 
469     function changeWalletLimit(uint256 newLimit) external onlyOwner {
470         maxWallet  = newLimit;
471     }
472     
473     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
474         isFeeExempt[holder] = exempt;
475     }
476 
477     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
478         isTxLimitExempt[holder] = exempt;
479     }
480 
481     function setMichaelCohen(address payable newMichaelCohen) external onlyOwner {
482         michaelCohen = payable(newMichaelCohen);
483     }
484 
485     function setLpWallet(address newLpWallet) external onlyOwner {
486         lpWallet = newLpWallet;
487     }    
488 
489     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
490         swapAndLiquifyEnabled  = enableSwapBack;
491         swapThreshold = newSwapBackLimit;
492     }
493 
494     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
495         stormy.setDistributionCriteria(newMinPeriod, newMinDistribution);        
496     }
497 
498     function delBot(address notbot) external onlyOwner {
499         bots[notbot] = false;
500     }
501 
502     function _setIsDividendExempt(address holder, bool exempt) internal {
503         require(holder != address(this) && holder != pair);
504         isDividendExempt[holder] = exempt;
505         if(exempt){
506             stormy.setShare(holder, 0);
507         }else{
508             stormy.setShare(holder, _balances[holder]);
509         }
510     }
511 
512     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
513         _setIsDividendExempt(holder, exempt);
514     }
515 
516     function changeStormyGas(uint256 newGas) external onlyOwner {
517         stormyGas = newGas;
518     }           
519 
520     function getCirculatingSupply() public view returns (uint256) {
521         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
522     }
523 
524     function totalSupply() external view override returns (uint256) { return _totalSupply; }
525     function decimals() external pure override returns (uint8) { return _decimals; }
526     function symbol() external pure override returns (string memory) { return _symbol; }
527     function name() external pure override returns (string memory) { return _name; }
528     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
529     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
530     
531     function approve(address spender, uint256 amount) public override returns (bool) {
532         _allowances[msg.sender][spender] = amount;
533         emit Approval(msg.sender, spender, amount);
534         return true;
535     }
536 
537     function approveMax(address spender) external returns (bool) {
538         return approve(spender, type(uint256).max);
539     }
540 
541     function transfer(address recipient, uint256 amount) external override returns (bool) {
542         return _transfer(msg.sender, recipient, amount);
543     }
544 
545     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
546         if(_allowances[sender][msg.sender] != type(uint256).max){
547             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
548         }
549 
550         return _transfer(sender, recipient, amount);
551     }
552 
553     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
554         if (sender!= owner() && recipient!= owner()) require(tradingOpen, "hold ur horses big guy."); //transfers disabled before tradingActive
555         require(!bots[sender] && !bots[recipient]);
556 
557         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
558 
559         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
560 
561         if(!isTxLimitExempt[recipient] && antiBot)
562         {
563             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
564         }
565 
566         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
567 
568         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
569         
570         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
571         _balances[recipient] = _balances[recipient].add(finalAmount);
572 
573         // Dividend tracker
574         if(!isDividendExempt[sender]) {
575             try stormy.setShare(sender, _balances[sender]) {} catch {}
576         }
577 
578         if(!isDividendExempt[recipient]) {
579             try stormy.setShare(recipient, _balances[recipient]) {} catch {} 
580         }
581 
582         emit Transfer(sender, recipient, finalAmount);
583         return true;
584     }    
585 
586     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
587         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
588         _balances[recipient] = _balances[recipient].add(amount);
589         emit Transfer(sender, recipient, amount);
590         return true;
591     }  
592     
593     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
594         
595         uint256 feeApplicable = pair == recipient ? sellFee : buyFee;
596         uint256 feeAmount = amount.mul(feeApplicable).div(100);
597 
598         _balances[address(this)] = _balances[address(this)].add(feeAmount);
599         emit Transfer(sender, address(this), feeAmount);
600 
601         return amount.sub(feeAmount);
602     }
603     
604     function swapTokensForEth(uint256 tokenAmount) private {
605 
606         address[] memory path = new address[](2);
607         path[0] = address(this);
608         path[1] = router.WETH();
609 
610         approve(address(this), tokenAmount);
611 
612         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
613             tokenAmount,
614             0, // accept any amount of ETH
615             path,
616             address(this),
617             block.timestamp
618         );
619     }
620 
621     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
622         router.addLiquidityETH{value: ethAmount}(
623             address(this),
624             tokenAmount,
625             0,
626             0,
627             lpWallet,
628             block.timestamp
629         );
630     }
631 
632     function swapBack() internal lockTheSwap {
633     
634         uint256 tokenBalance = _balances[address(this)]; 
635         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
636         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);
637 
638         swapTokensForEth(amountToSwap);
639 
640         uint256 totalEthBalance = address(this).balance;
641         uint256 ethForHush = totalEthBalance.mul(toReflections).div(100);
642         uint256 ethForMichaelCohen = totalEthBalance.mul(toMarketing).div(100);
643         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
644       
645         if (totalEthBalance > 0){
646             payable(michaelCohen).transfer(ethForMichaelCohen);
647         }
648         
649         try stormy.deposit{value: ethForHush}() {} catch {}
650         
651         if (tokensForLiquidity > 0){
652             addLiquidity(tokensForLiquidity, ethForLiquidity);
653         }
654     }
655 
656     function manualSwapBack() external onlyOwner {
657         swapBack();
658     }
659 
660     function clearStuckEth() external onlyOwner {
661         uint256 contractETHBalance = address(this).balance;
662         if(contractETHBalance > 0){          
663             payable(michaelCohen).transfer(contractETHBalance);
664         }
665     }
666 
667     function manualProcessGas(uint256 manualGas) external onlyOwner {
668         stormy.process(manualGas);
669     }
670 
671     function checkPendingReflections(address shareholder) external view returns (uint256) {
672         return stormy.getUnpaidEarnings(shareholder);
673     }
674 
675     function hush() external {
676         stormy.hush(msg.sender);
677     }
678 }