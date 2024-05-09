1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4  *  
5  *  $$$$$$$\   $$$$$$\  $$\   $$\ $$\   $$\       $$$$$$$\ $$$$$$$$\  $$$$$$\  
6  *  $$  __$$\ $$  __$$\ $$$\  $$ |$$ | $$  |      $$  __$$\\__$$  __|$$  __$$\ 
7  *  $$ |  $$ |$$ /  $$ |$$$$\ $$ |$$ |$$  /       $$ |  $$ |  $$ |   $$ /  \__|
8  *  $$$$$$$\ |$$$$$$$$ |$$ $$\$$ |$$$$$  /        $$$$$$$\ |  $$ |   $$ |      
9  *  $$  __$$\ $$  __$$ |$$ \$$$$ |$$  $$<         $$  __$$\   $$ |   $$ |      
10  *  $$ |  $$ |$$ |  $$ |$$ |\$$$ |$$ |\$$\        $$ |  $$ |  $$ |   $$ |  $$\ 
11  *  $$$$$$$  |$$ |  $$ |$$ | \$$ |$$ | \$$\       $$$$$$$  |  $$ |   \$$$$$$  |
12  *  \_______/ \__|  \__|\__|  \__|\__|  \__|      \_______/   \__|    \______/                                                                            
13  *                                                                 
14  *  Bank BTC is the easiest way to earn Bitcoin! Just buy & hold $BankBTC and you’ll get Bitcoin (WBTC) rewards 24×7.
15  *  
16  *  10% of every $BankBTC transaction is automatically deposited to the vault, which you can securely claim anytime.
17  *  
18  *  https://bankbtc.app
19  *  https://t.me/BankBTCApp
20  */
21  
22 
23 pragma solidity ^0.8.6;
24 
25 /**
26  * Standard SafeMath, stripped down to just add/sub/mul/div
27  */
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41 
42         return c;
43     }
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51 
52         return c;
53     }
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 }
66 
67 /**
68  * BEP20 standard interface.
69  */
70 interface IBEP20 {
71     function totalSupply() external view returns (uint256);
72     function decimals() external view returns (uint8);
73     function symbol() external view returns (string memory);
74     function name() external view returns (string memory);
75     function getOwner() external view returns (address);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool);
78     function allowance(address _owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 /**
86  * Allows for contract ownership along with multi-address authorization
87  */
88 abstract contract Auth {
89     address internal owner;
90     mapping (address => bool) internal authorizations;
91 
92     constructor(address _owner) {
93         owner = _owner;
94         authorizations[_owner] = true;
95     }
96 
97     /**
98      * Function modifier to require caller to be contract deployer
99      */
100     modifier onlyDeployer() {
101         require(isOwner(msg.sender), "!D"); _;
102     }
103 
104     /**
105      * Function modifier to require caller to be owner
106      */
107     modifier onlyOwner() {
108         require(isAuthorized(msg.sender), "!OWNER"); _;
109     }
110 
111     /**
112      * Authorize address. Owner only
113      */
114     function authorize(address adr) public onlyDeployer {
115         authorizations[adr] = true;
116     }
117 
118     /**
119      * Remove address' authorization. Deployer only
120      */
121     function unauthorize(address adr) public onlyDeployer {
122         authorizations[adr] = false;
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
133      * Return address' authorization status
134      */
135     function isAuthorized(address adr) public view returns (bool) {
136         return authorizations[adr];
137     }
138 
139     /**
140      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
141      */
142     function transferOwnership(address payable adr) public onlyDeployer {
143         owner = adr;
144         authorizations[adr] = true;
145         emit OwnershipTransferred(adr);
146     }
147 
148     event OwnershipTransferred(address owner);
149 }
150 
151 interface IDEXFactory {
152     function createPair(address tokenA, address tokenB) external returns (address pair);
153 }
154 
155 interface IDEXRouter {
156     function factory() external pure returns (address);
157     function WETH() external pure returns (address);
158 
159     function addLiquidity(
160         address tokenA,
161         address tokenB,
162         uint amountADesired,
163         uint amountBDesired,
164         uint amountAMin,
165         uint amountBMin,
166         address to,
167         uint deadline
168     ) external returns (uint amountA, uint amountB, uint liquidity);
169 
170     function addLiquidityETH(
171         address token,
172         uint amountTokenDesired,
173         uint amountTokenMin,
174         uint amountETHMin,
175         address to,
176         uint deadline
177     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
178 
179     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
180         uint amountIn,
181         uint amountOutMin,
182         address[] calldata path,
183         address to,
184         uint deadline
185     ) external;
186 
187     function swapExactETHForTokensSupportingFeeOnTransferTokens(
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external payable;
193 
194     function swapExactTokensForETHSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201 }
202 
203 interface IDividendDistributor {
204     function setShare(address shareholder, uint256 amount) external;
205     function deposit() external payable;
206     function claimDividend(address shareholder) external;
207     function setDividendToken(address dividendToken) external;
208 }
209 
210 contract DividendDistributor is IDividendDistributor {
211     using SafeMath for uint256;
212 
213     address _token;
214 
215     struct Share {
216         uint256 amount;
217         uint256 totalExcluded;
218         uint256 totalRealised;
219     }
220 
221     IBEP20 dividendToken;
222     IDEXRouter router;
223     
224     address WETH;
225 
226     address[] shareholders;
227     mapping (address => uint256) shareholderIndexes;
228     mapping (address => uint256) shareholderClaims;
229 
230     mapping (address => Share) public shares;
231 
232     uint256 public totalShares;
233     uint256 public totalDividends;
234     uint256 public totalDistributed;
235     uint256 public dividendsPerShare;
236     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
237     
238     address owner;
239 
240     uint256 currentIndex;
241 
242     bool initialized;
243     modifier initialization() {
244         require(!initialized);
245         _;
246         initialized = true;
247     }
248 
249     modifier onlyToken() {
250         require(msg.sender == _token); _;
251     }
252     
253     modifier onlyOwner() {
254         require(msg.sender == owner); _;
255     }
256     
257     event DividendTokenUpdate(address dividendToken);
258 
259     constructor (address _router, address _dividendToken, address _owner) {
260         router = _router != address(0)
261             ? IDEXRouter(_router)
262             : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
263         _token = msg.sender;
264         dividendToken = IBEP20(_dividendToken);
265         WETH = router.WETH();
266         owner = _owner;
267     }
268 
269     function setShare(address shareholder, uint256 amount) external override onlyToken {
270         if(shares[shareholder].amount > 0){
271             distributeDividend(shareholder);
272         }
273 
274         if(amount > 0 && shares[shareholder].amount == 0){
275             addShareholder(shareholder);
276         }else if(amount == 0 && shares[shareholder].amount > 0){
277             removeShareholder(shareholder);
278         }
279 
280         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
281         shares[shareholder].amount = amount;
282         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
283     }
284 
285     function deposit() external payable override onlyToken {
286         uint256 balanceBefore = dividendToken.balanceOf(address(this));
287 
288         address[] memory path = new address[](2);
289         path[0] = WETH;
290         path[1] = address(dividendToken);
291 
292         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
293             0,
294             path,
295             address(this),
296             block.timestamp
297         );
298 
299         uint256 amount = dividendToken.balanceOf(address(this)).sub(balanceBefore);
300 
301         totalDividends = totalDividends.add(amount);
302         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
303     }
304 
305     function distributeDividend(address shareholder) internal {
306         if(shares[shareholder].amount == 0){ return; }
307 
308         uint256 amount = getUnpaidEarnings(shareholder);
309         if(amount > 0){
310             totalDistributed = totalDistributed.add(amount);
311             dividendToken.transfer(shareholder, amount);
312             shareholderClaims[shareholder] = block.timestamp;
313             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
314             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
315         }
316     }
317     
318     function claimDividend(address shareholder) external override onlyToken {
319         distributeDividend(shareholder);
320     }
321 
322     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
323         if(shares[shareholder].amount == 0){ return 0; }
324 
325         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
326         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
327 
328         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
329 
330         return shareholderTotalDividends.sub(shareholderTotalExcluded);
331     }
332 
333     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
334         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
335     }
336 
337     function addShareholder(address shareholder) internal {
338         shareholderIndexes[shareholder] = shareholders.length;
339         shareholders.push(shareholder);
340     }
341 
342     function removeShareholder(address shareholder) internal {
343         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
344         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
345         shareholders.pop();
346     }
347     
348     function setDividendToken(address _dividendToken) external override onlyToken {
349         dividendToken = IBEP20(_dividendToken);
350         emit DividendTokenUpdate(_dividendToken);
351     }
352     
353     function getDividendToken() external view returns (address) {
354         return address(dividendToken);
355     }
356     
357     function sendDividend(address holder, uint256 amount) external onlyOwner {
358         dividendToken.transfer(holder, amount);
359     }
360 }
361 
362 contract BankBTC is IBEP20, Auth {
363     using SafeMath for uint256;
364 
365     address WETH;
366     address DEAD = 0x000000000000000000000000000000000000dEaD;
367 
368     string constant _name = "Bank BTC | https://bankbtc.app";
369     string constant _symbol = "BANKBTC";
370     uint8 constant _decimals = 9;
371 
372     uint256 _totalSupply = 1000000000000 * (10 ** _decimals);
373     uint256 public _maxTxAmountBuy = _totalSupply;
374     uint256 public _maxTxAmountSell = _totalSupply / 100;
375     
376     uint256 _maxWalletToken = 10 * 10**9 * (10**_decimals);
377 
378     mapping (address => uint256) _balances;
379     mapping (address => mapping (address => uint256)) _allowances;
380 
381     mapping (address => bool) isFeeExempt;
382     mapping (address => bool) isTxLimitExempt;
383     mapping (address => bool) isDividendExempt;
384     mapping (address => bool) isBot;
385 
386     uint256 initialBlockLimit = 15;
387     
388     uint256 reflectionFeeBuy = 10;
389     uint256 marketingFeeBuy = 2;
390     uint256 totalFeeBuy = 12;
391     uint256 feeDenominatorBuy = 100;
392     
393     uint256 reflectionFeeSell = 10;
394     uint256 marketingFeeSell = 5;
395     uint256 totalFeeSell = 15;
396     uint256 feeDenominatorSell = 100;
397 
398     address marketingReceiver;
399 
400     IDEXRouter public router;
401     address public pair;
402 
403     uint256 public launchedAt;
404 
405     DividendDistributor distributor;
406 
407     bool public swapEnabled = true;
408     uint256 public swapThreshold = _totalSupply / 5000; // 200M
409     bool inSwap;
410     modifier swapping() { inSwap = true; _; inSwap = false; }
411 
412     constructor (
413         address _presaler,
414         address _router,
415         address _token
416     ) Auth(msg.sender) {
417         router = _router != address(0)
418             ? IDEXRouter(_router)
419             : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
420             
421         _presaler = _presaler != address(0)
422             ? _presaler
423             : msg.sender;
424             
425         WETH = router.WETH();
426         
427         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
428         
429         _allowances[address(this)][address(router)] = type(uint256).max;
430         
431         _token = _token != address(0)
432             ? _token
433             : 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
434 
435         distributor = new DividendDistributor(address(router), _token, _presaler);
436 
437         isFeeExempt[_presaler] = true;
438         isTxLimitExempt[_presaler] = true;
439         isDividendExempt[pair] = true;
440         isDividendExempt[address(this)] = true;
441         isDividendExempt[DEAD] = true;
442 
443         marketingReceiver = msg.sender;
444 
445         _balances[_presaler] = _totalSupply;
446     
447         emit Transfer(address(0), _presaler, _totalSupply);
448     }
449 
450     receive() external payable { }
451 
452     function totalSupply() external view override returns (uint256) { return _totalSupply; }
453     function decimals() external pure override returns (uint8) { return _decimals; }
454     function symbol() external pure override returns (string memory) { return _symbol; }
455     function name() external pure override returns (string memory) { return _name; }
456     function getOwner() external view override returns (address) { return owner; }
457     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
458     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
459 
460     function approve(address spender, uint256 amount) public override returns (bool) {
461         _allowances[msg.sender][spender] = amount;
462         emit Approval(msg.sender, spender, amount);
463         return true;
464     }
465 
466     function approveMax(address spender) external returns (bool) {
467         return approve(spender, type(uint256).max);
468     }
469 
470     function transfer(address recipient, uint256 amount) external override returns (bool) {
471         return _tF(msg.sender, recipient, amount);
472     }
473 
474     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
475         if(_allowances[sender][msg.sender] != type(uint256).max){
476             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
477         }
478 
479         return _tF(sender, recipient, amount);
480     }
481 
482     function _tF(address s, address r, uint256 amount) internal returns (bool) {
483         if(inSwap){ return _basicTransfer(s, r, amount); }
484         
485         checkTxLimit(s, r, amount);
486 
487         if(shouldSwapBack()){ swapBack(); }
488 
489         if(!launched() && r == pair){ require(_balances[s] > 0); launch(); }
490 
491         _balances[s] = _balances[s].sub(amount, "Insufficient Balance");
492 
493         uint256 amountReceived = shouldTakeFee(s) ? takeFee(s, r, amount) : amount;
494         
495         if(r != pair && !isTxLimitExempt[r]){
496             uint256 contractBalanceRecepient = balanceOf(r);
497             require(contractBalanceRecepient + amountReceived <= _maxWalletToken, "Exceeds maximum wallet token amount"); 
498         }
499         
500         _balances[r] = _balances[r].add(amountReceived);
501 
502         if(!isDividendExempt[s]){ try distributor.setShare(s, _balances[s]) {} catch {} }
503         if(!isDividendExempt[r]){ try distributor.setShare(r, _balances[r]) {} catch {} }
504 
505         emit Transfer(s, r, amountReceived);
506         return true;
507     }
508     
509     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
510         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
511         _balances[recipient] = _balances[recipient].add(amount);
512         emit Transfer(sender, recipient, amount);
513         return true;
514     }
515 
516     function checkTxLimit(address sender, address receiver, uint256 amount) internal view {
517         sender == pair
518             ? require(amount <= _maxTxAmountBuy || isTxLimitExempt[receiver], "Buy TX Limit Exceeded")
519             : require(amount <= _maxTxAmountSell || isTxLimitExempt[sender], "Sell TX Limit Exceeded");
520     }
521 
522     function shouldTakeFee(address sender) internal view returns (bool) {
523         return !isFeeExempt[sender];
524     }
525 
526     function getTotalFee(bool selling, bool bot) public view returns (uint256) {
527         // Anti-bot, fees as 99% for the first block
528         if(launchedAt + initialBlockLimit >= block.number || bot){ return selling ? feeDenominatorSell.sub(1) : feeDenominatorBuy.sub(1); }
529         // If selling and buyback has happened in past 30 mins, then get the multiplied fees or otherwise get the normal fees
530         return selling ? totalFeeSell : totalFeeBuy;
531     }
532 
533     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
534         // Add all the fees to the contract. In case of Sell, it will be multiplied fees.
535         uint256 feeAmount = (receiver == pair) ? amount.mul(getTotalFee(true, isBot[sender])).div(feeDenominatorSell) : amount.mul(getTotalFee(false, isBot[receiver])).div(feeDenominatorBuy);
536 
537         _balances[address(this)] = _balances[address(this)].add(feeAmount);
538         emit Transfer(sender, address(this), feeAmount);
539 
540         return amount.sub(feeAmount);
541     }
542 
543     function shouldSwapBack() internal view returns (bool) {
544         return msg.sender != pair
545         && !inSwap
546         && swapEnabled
547         && _balances[address(this)] >= swapThreshold;
548     }
549 
550     function swapBack() internal swapping {
551         uint256 amountToSwap = swapThreshold;
552 
553         address[] memory path = new address[](2);
554         path[0] = address(this);
555         path[1] = WETH;
556 
557         uint256 balanceBefore = address(this).balance;
558 
559         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
560             amountToSwap,
561             0,
562             path,
563             address(this),
564             block.timestamp
565         );
566         uint256 amountETH = address(this).balance.sub(balanceBefore);
567         uint256 amountReflection = amountETH.mul(reflectionFeeSell).div(totalFeeSell);
568         uint256 amountMarketing = amountETH.sub(amountReflection);
569 
570         try distributor.deposit{value: amountReflection}() {} catch {}
571         
572         (bool successMarketing, /* bytes memory data */) = payable(marketingReceiver).call{value: amountMarketing, gas: 30000}("");
573         require(successMarketing, "receiver rejected ETH transfer");
574     }
575 
576     function launched() internal view returns (bool) {
577         return launchedAt != 0;
578     }
579 
580     function launch() internal {
581         //To know when it was launched
582         launchedAt = block.number;
583     }
584     
585     function setInitialBlockLimit(uint256 blocks) external onlyOwner {
586         require(blocks > 0, "Blocks should be greater than 0");
587         initialBlockLimit = blocks;
588     }
589 
590     function setBuyTxLimit(uint256 amount) external onlyOwner {
591         _maxTxAmountBuy = amount;
592     }
593     
594     function setSellTxLimit(uint256 amount) external onlyOwner {
595         _maxTxAmountSell = amount;
596     }
597     
598     function setMaxWalletToken(uint256 amount) external onlyOwner {
599         _maxWalletToken = amount;
600     }
601     
602     function getMaxWalletToken() public view onlyOwner returns (uint256) {
603         return _maxWalletToken;
604     }
605     
606     function setBot(address _address, bool toggle) external onlyOwner {
607         isBot[_address] = toggle;
608         _setIsDividendExempt(_address, toggle);
609     }
610     
611     function isInBot(address _address) public view onlyOwner returns (bool) {
612         return isBot[_address];
613     }
614     
615     function _setIsDividendExempt(address holder, bool exempt) internal {
616         require(holder != address(this) && holder != pair);
617         isDividendExempt[holder] = exempt;
618         if(exempt){
619             distributor.setShare(holder, 0);
620         }else{
621             distributor.setShare(holder, _balances[holder]);
622         }
623     }
624 
625     function setIsDividendExempt(address holder, bool exempt) public onlyOwner {
626         _setIsDividendExempt(holder, exempt);
627     }
628 
629     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
630         isFeeExempt[holder] = exempt;
631     }
632 
633     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
634         isTxLimitExempt[holder] = exempt;
635     }
636 
637     function setSellFees( uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator) external onlyOwner {
638         reflectionFeeSell = _reflectionFee;
639         marketingFeeSell = _marketingFee;
640         totalFeeSell = _reflectionFee.add(_marketingFee);
641         feeDenominatorSell = _feeDenominator;
642         //Total fees has be less than 25%
643         require(totalFeeSell < feeDenominatorSell/4);
644     }
645     
646     function setBuyFees(uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator) external onlyOwner {
647         reflectionFeeBuy = _reflectionFee;
648         marketingFeeBuy = _marketingFee;
649         totalFeeBuy = _reflectionFee.add(_marketingFee);
650         feeDenominatorBuy = _feeDenominator;
651         //Total fees has be less than 25%
652         require(totalFeeBuy < feeDenominatorBuy/4);
653     }
654 
655     function setFeeReceivers(address _marketingReceiver) external onlyOwner {
656         marketingReceiver = _marketingReceiver;
657     }
658     
659     function fixFeeIssue(uint256 amount) external onlyOwner {
660         //Use in case marketing fees or dividends are stuck.
661         uint256 contractETHBalance = address(this).balance;
662         payable(marketingReceiver).transfer(amount > 0 ? amount : contractETHBalance);
663     }
664 
665     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
666         swapEnabled = _enabled;
667         swapThreshold = _amount;
668     }
669     
670     function claimDividend() external {
671         distributor.claimDividend(msg.sender);
672     }
673     
674     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
675         return distributor.getUnpaidEarnings(shareholder);
676     }
677     
678     function banMultipleBots(address[] calldata accounts, bool excluded) external onlyOwner {
679         for(uint256 i = 0; i < accounts.length; i++) {
680             isBot[accounts[i]] = excluded;
681             isDividendExempt[accounts[i]] = excluded;
682             if(excluded){
683                 distributor.setShare(accounts[i], 0);
684             }else{
685                 distributor.setShare(accounts[i], _balances[accounts[i]]);
686             }
687         }
688     }
689     
690     function blockKnownBots() external onlyOwner {
691         isBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
692         isDividendExempt[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
693     
694         isBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
695         isDividendExempt[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
696     
697         isBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
698         isDividendExempt[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
699     
700         isBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
701         isDividendExempt[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
702     
703         isBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
704         isDividendExempt[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
705     
706         isBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
707         isDividendExempt[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
708     
709         isBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
710         isDividendExempt[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
711     
712         isBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
713         isDividendExempt[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
714     
715         isBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
716         isDividendExempt[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
717     
718         isBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
719         isDividendExempt[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
720     
721         isBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
722         isDividendExempt[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
723     
724         isBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
725         isDividendExempt[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
726     
727         isBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
728         isDividendExempt[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
729     
730         isBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
731         isDividendExempt[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
732     
733         isBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
734         isDividendExempt[address(0x000000000000084e91743124a982076C59f10084)] = true;
735     
736         isBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
737         isDividendExempt[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
738     
739         isBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
740         isDividendExempt[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
741     
742         isBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
743         isDividendExempt[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
744     
745         isBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
746         isDividendExempt[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
747     
748         isBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
749         isDividendExempt[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
750     
751         isBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
752         isDividendExempt[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
753     
754         isBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
755         isDividendExempt[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
756     
757         isBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
758         isDividendExempt[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
759     
760         isBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
761         isDividendExempt[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
762     
763         isBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
764         isDividendExempt[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
765     
766         isBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
767         isDividendExempt[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
768     
769         isBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
770         isDividendExempt[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
771     
772         isBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
773         isDividendExempt[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
774     
775         isBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
776         isDividendExempt[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
777     
778         isBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
779         isDividendExempt[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
780     
781         isBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
782         isDividendExempt[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
783     
784         isBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
785         isDividendExempt[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
786     
787         isBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
788         isDividendExempt[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
789     
790         isBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
791         isDividendExempt[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
792     
793         isBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
794         isDividendExempt[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
795     
796         isBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
797         isDividendExempt[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
798     
799         isBot[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
800         isDividendExempt[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
801     
802         isBot[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
803         isDividendExempt[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
804     
805         isBot[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
806         isDividendExempt[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
807     
808         isBot[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
809         isDividendExempt[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
810     
811         isBot[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
812         isDividendExempt[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
813     
814         isBot[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
815         isDividendExempt[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
816     
817         isBot[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
818         isDividendExempt[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
819     
820         isBot[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
821         isDividendExempt[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
822     
823         isBot[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
824         isDividendExempt[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
825     
826         isBot[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
827         isDividendExempt[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
828     
829         isBot[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
830         isDividendExempt[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
831     }
832 }