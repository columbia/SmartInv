1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.7;
4 
5 /**
6  * Standard SafeMath, stripped down to just add/sub/mul/div
7  */
8 library SafeMath {
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         // Solidity only automatically asserts when dividing by 0
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43         return c;
44     }
45 }
46 
47 /**
48  * BEP20 standard interface.
49  */
50 interface IBEP20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 /**
66  * Allows for contract ownership along with multi-address authorization
67  */
68 abstract contract Auth {
69     address internal owner;
70 
71     constructor(address _owner) {
72         owner = _owner;
73     }
74 
75     /**
76      * Function modifier to require caller to be contract deployer
77      */
78     modifier onlyOwner() {
79         require(isOwner(msg.sender), "!Owner"); _;
80     }
81 
82     /**
83      * Check if address is owner
84      */
85     function isOwner(address account) public view returns (bool) {
86         return account == owner;
87     }
88 
89     /**
90      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
91      */
92     function transferOwnership(address payable adr) public onlyOwner {
93         owner = adr;
94         emit OwnershipTransferred(adr);
95     }
96 
97     event OwnershipTransferred(address owner);
98 }
99 
100 interface IDEXFactory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IDEXRouter {
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107 
108     function addLiquidity(
109         address tokenA,
110         address tokenB,
111         uint amountADesired,
112         uint amountBDesired,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB, uint liquidity);
118 
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 
128     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 
136     function swapExactETHForTokensSupportingFeeOnTransferTokens(
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external payable;
142 
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 interface IDividendDistributor {
153     function setShare(address shareholder, uint256 amount) external;
154     function deposit() external payable;
155     function claimDividend(address shareholder) external;
156 }
157 
158 contract DividendDistributor is IDividendDistributor {
159     using SafeMath for uint256;
160 
161     address private _token;
162     address private _owner;
163 
164     struct Share {
165         uint256 amount;
166         uint256 totalExcluded;
167         uint256 totalRealised;
168     }
169 
170     address[] private shareholders;
171     mapping (address => uint256) private shareholderIndexes;
172 
173     mapping (address => Share) public shares;
174 
175     uint256 public totalShares;
176     uint256 public totalDividends;
177     uint256 public totalDistributed;
178     uint256 public dividendsPerShare;
179     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
180 
181     modifier onlyToken() {
182         require(msg.sender == _token); _;
183     }
184     
185     modifier onlyOwner() {
186         require(msg.sender == _owner); _;
187     }
188 
189     constructor (address owner) {
190         _token = msg.sender;
191         _owner = owner;
192     }
193 
194     function setShare(address shareholder, uint256 amount) external override onlyToken {
195         if(shares[shareholder].amount > 0){
196             distributeDividend(shareholder);
197         }
198 
199         if(amount > 0 && shares[shareholder].amount == 0){
200             addShareholder(shareholder);
201         }else if(amount == 0 && shares[shareholder].amount > 0){
202             removeShareholder(shareholder);
203         }
204 
205         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
206         shares[shareholder].amount = amount;
207         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
208     }
209 
210     function deposit() external payable override onlyToken {
211         uint256 amount = msg.value;
212 
213         totalDividends = totalDividends.add(amount);
214         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
215     }
216     
217     function distributeDividend(address shareholder) internal {
218         if(shares[shareholder].amount == 0){ return; }
219 
220         uint256 amount = getUnpaidEarnings(shareholder);
221         if(amount > 0){
222             totalDistributed = totalDistributed.add(amount);
223             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
224             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
225             payable(shareholder).transfer(amount);
226         }
227     }
228     
229     function claimDividend(address shareholder) external override onlyToken {
230         distributeDividend(shareholder);
231     }
232 
233     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
234         if(shares[shareholder].amount == 0){ return 0; }
235 
236         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
237         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
238 
239         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
240 
241         return shareholderTotalDividends.sub(shareholderTotalExcluded);
242     }
243 
244     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
245         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
246     }
247 
248     function addShareholder(address shareholder) internal {
249         shareholderIndexes[shareholder] = shareholders.length;
250         shareholders.push(shareholder);
251     }
252 
253     function removeShareholder(address shareholder) internal {
254         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
255         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
256         shareholders.pop();
257     }
258     
259     function manualSend(uint256 amount, address holder) external onlyOwner {
260         uint256 contractETHBalance = address(this).balance;
261         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
262     }
263 }
264 
265 contract CoinMerge is IBEP20, Auth {
266     using SafeMath for uint256;
267 
268     address private WETH;
269     address private DEAD = 0x000000000000000000000000000000000000dEaD;
270     address private ZERO = 0x0000000000000000000000000000000000000000;
271 
272     string private constant  _name = "Coin Merge";
273     string private constant _symbol = "CMERGE";
274     uint8 private constant _decimals = 9;
275 
276     uint256 private _totalSupply = 5000000000 * (10 ** _decimals);
277     uint256 private _maxTxAmountBuy = _totalSupply;
278     uint256 private _maxTxAmountSell = _totalSupply;
279 
280     mapping (address => uint256) private _balances;
281     mapping (address => mapping (address => uint256)) private _allowances;
282 
283     mapping (address => bool) private isFeeExempt;
284     mapping (address => bool) private isTxLimitExempt;
285     mapping (address => bool) private isDividendExempt;
286     mapping (address => bool) private isBot;
287 
288     uint256 private initialBlockLimit = 1;
289     
290     uint256 private reflectionFee = 4;
291     uint256 private teamFee = 4;
292     uint256 private totalFee = 8;
293     uint256 private feeDenominator = 100;
294 
295     address private teamReceiver;
296 
297     IDEXRouter public router;
298     address public pair;
299 
300     uint256 public launchedAt;
301 
302     DividendDistributor private distributor;
303 
304     bool public swapEnabled = true;
305     uint256 public swapThreshold = _totalSupply / 1000; // 5M
306     
307     bool private inSwap;
308     modifier swapping() { inSwap = true; _; inSwap = false; }
309 
310     constructor (
311         address _owner,
312         address _teamWallet
313     ) Auth(_owner) {
314         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315             
316         WETH = router.WETH();
317         
318         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
319         
320         _allowances[address(this)][address(router)] = type(uint256).max;
321 
322         distributor = new DividendDistributor(_owner);
323 
324         isFeeExempt[_owner] = true;
325         isFeeExempt[_teamWallet] = true;
326         
327         isTxLimitExempt[_owner] = true;
328         isTxLimitExempt[DEAD] = true;
329         isTxLimitExempt[_teamWallet] = true;
330         
331         isDividendExempt[pair] = true;
332         isDividendExempt[address(this)] = true;
333         isDividendExempt[DEAD] = true;
334 
335         teamReceiver = _teamWallet;
336 
337         _balances[_owner] = _totalSupply;
338     
339         emit Transfer(address(0), _owner, _totalSupply);
340     }
341 
342     receive() external payable { }
343 
344     function totalSupply() external view override returns (uint256) { return _totalSupply; }
345     function decimals() external pure override returns (uint8) { return _decimals; }
346     function symbol() external pure override returns (string memory) { return _symbol; }
347     function name() external pure override returns (string memory) { return _name; }
348     function getOwner() external view override returns (address) { return owner; }
349     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
350     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
351 
352     function approve(address spender, uint256 amount) public override returns (bool) {
353         _allowances[msg.sender][spender] = amount;
354         emit Approval(msg.sender, spender, amount);
355         return true;
356     }
357 
358     function approveMax(address spender) external returns (bool) {
359         return approve(spender, type(uint256).max);
360     }
361 
362     function transfer(address recipient, uint256 amount) external override returns (bool) {
363         return _transferFrom(msg.sender, recipient, amount);
364     }
365 
366     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
367         if(_allowances[sender][msg.sender] != type(uint256).max){
368             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
369         }
370 
371         return _transferFrom(sender, recipient, amount);
372     }
373 
374     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
375         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
376         
377         checkTxLimit(sender, recipient, amount);
378 
379         if(shouldSwapBack()){ swapBack(); }
380 
381         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
382 
383         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
384 
385         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
386         
387         _balances[recipient] = _balances[recipient].add(amountReceived);
388 
389         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
390         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
391 
392         emit Transfer(sender, recipient, amountReceived);
393         return true;
394     }
395     
396     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
397         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
398         _balances[recipient] = _balances[recipient].add(amount);
399         emit Transfer(sender, recipient, amount);
400         return true;
401     }
402 
403     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
404         sender == pair
405             ? require(amount <= _maxTxAmountBuy || isTxLimitExempt[recipient], "Buy TX Limit Exceeded")
406             : require(amount <= _maxTxAmountSell || isTxLimitExempt[sender], "Sell TX Limit Exceeded");
407     }
408 
409     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
410         return !(isFeeExempt[sender] || isFeeExempt[recipient]);
411     }
412 
413     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
414         uint256 feeAmount;
415         bool bot;
416         
417         // Add all the fees to the contract. In case of Sell, it will be multiplied fees.
418         if (sender != pair) {
419             bot = isBot[sender];
420         } else {
421             bot = isBot[recipient];
422         }
423         
424         if (bot || launchedAt + initialBlockLimit >= block.number) {
425             feeAmount = amount.mul(feeDenominator.sub(1)).div(feeDenominator);
426             _balances[DEAD] = _balances[DEAD].add(feeAmount);
427             emit Transfer(sender, DEAD, feeAmount);
428         } else {
429             feeAmount = amount.mul(totalFee).div(feeDenominator);
430             _balances[address(this)] = _balances[address(this)].add(feeAmount);
431             emit Transfer(sender, address(this), feeAmount);
432         }
433 
434         return amount.sub(feeAmount);
435     }
436 
437     function shouldSwapBack() internal view returns (bool) {
438         return msg.sender != pair
439         && !inSwap
440         && swapEnabled
441         && _balances[address(this)] >= swapThreshold;
442     }
443 
444     function swapBack() internal swapping {
445         uint256 amountToSwap = swapThreshold;
446 
447         address[] memory path = new address[](2);
448         path[0] = address(this);
449         path[1] = WETH;
450 
451         uint256 balanceBefore = address(this).balance;
452 
453         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
454             amountToSwap,
455             0,
456             path,
457             address(this),
458             block.timestamp
459         );
460         uint256 amountETH = address(this).balance.sub(balanceBefore);
461         uint256 amountReflection = amountETH.mul(reflectionFee).div(totalFee);
462         uint256 amountTeam = amountETH.sub(amountReflection);
463 
464         try distributor.deposit{value: amountReflection}() {} catch {}
465         
466         payable(teamReceiver).transfer(amountTeam);
467     }
468 
469     function launched() internal view returns (bool) {
470         return launchedAt != 0;
471     }
472 
473     function launch() internal {
474         //To know when it was launched
475         launchedAt = block.number;
476     }
477     
478     function setInitialBlockLimit(uint256 blocks) external onlyOwner {
479         require(blocks > 0, "Blocks should be greater than 0");
480         initialBlockLimit = blocks;
481     }
482 
483     function setBuyTxLimit(uint256 amount) external onlyOwner {
484         _maxTxAmountBuy = amount;
485     }
486     
487     function setSellTxLimit(uint256 amount) external onlyOwner {
488         _maxTxAmountSell = amount;
489     }
490     
491     function setBot(address _address, bool toggle) external onlyOwner {
492         isBot[_address] = toggle;
493         _setIsDividendExempt(_address, toggle);
494     }
495     
496     function isInBot(address _address) external view onlyOwner returns (bool) {
497         return isBot[_address];
498     }
499     
500     function _setIsDividendExempt(address holder, bool exempt) internal {
501         require(holder != address(this) && holder != pair);
502         isDividendExempt[holder] = exempt;
503         if(exempt){
504             distributor.setShare(holder, 0);
505         }else{
506             distributor.setShare(holder, _balances[holder]);
507         }
508     }
509 
510     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
511         _setIsDividendExempt(holder, exempt);
512     }
513 
514     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
515         isFeeExempt[holder] = exempt;
516     }
517 
518     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
519         isTxLimitExempt[holder] = exempt;
520     }
521 
522     function setFees( uint256 _reflectionFee, uint256 _teamFee, uint256 _feeDenominator) external onlyOwner {
523         reflectionFee = _reflectionFee;
524         teamFee = _teamFee;
525         totalFee = _reflectionFee.add(_teamFee);
526         feeDenominator = _feeDenominator;
527         //Total fees has to be less than 50%
528         require(totalFee < feeDenominator/2);
529     }
530 
531     function setFeeReceiver(address _teamReceiver) external onlyOwner {
532         teamReceiver = _teamReceiver;
533     }
534     
535     function manualSend() external onlyOwner {
536         uint256 contractETHBalance = address(this).balance;
537         payable(teamReceiver).transfer(contractETHBalance);
538     }
539 
540     function setSwapBackSettings(bool enabled, uint256 amount) external onlyOwner {
541         swapEnabled = enabled;
542         swapThreshold = amount;
543     }
544     
545     function claimDividend() external {
546         distributor.claimDividend(msg.sender);
547     }
548     
549     function claimDividend(address holder) external onlyOwner {
550         distributor.claimDividend(holder);
551     }
552     
553     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
554         return distributor.getUnpaidEarnings(shareholder);
555     }
556 
557     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
558         return _basicTransfer(address(this), DEAD, amount);
559     }
560     
561     function getCirculatingSupply() public view returns (uint256) {
562         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
563     }
564 }