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
156     function setTreasury(address treasury) external;
157     function getDividendsClaimedOf (address shareholder) external returns (uint256);
158 }
159 
160 contract DividendDistributor is IDividendDistributor {
161     using SafeMath for uint256;
162 
163     address public _token;
164     address public _owner;
165     address public _treasury;
166 
167     struct Share {
168         uint256 amount;
169         uint256 totalExcluded;
170         uint256 totalClaimed;
171     }
172 
173     address[] private shareholders;
174     mapping (address => uint256) private shareholderIndexes;
175 
176     mapping (address => Share) public shares;
177 
178     uint256 public totalShares;
179     uint256 public totalDividends;
180     uint256 public totalClaimed;
181     uint256 public dividendsPerShare;
182     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
183 
184     modifier onlyToken() {
185         require(msg.sender == _token); _;
186     }
187     
188     modifier onlyOwner() {
189         require(msg.sender == _owner); _;
190     }
191 
192     constructor (address owner, address treasury) {
193         _token = msg.sender;
194         _owner = owner;
195         _treasury = treasury;
196     }
197 
198    // receive() external payable { }
199 
200     function setShare(address shareholder, uint256 amount) external override onlyToken {
201         if(shares[shareholder].amount > 0){
202             distributeDividend(shareholder);
203         }
204 
205         if(amount > 0 && shares[shareholder].amount == 0){
206             addShareholder(shareholder);
207         }else if(amount == 0 && shares[shareholder].amount > 0){
208             removeShareholder(shareholder);
209         }
210 
211         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
212         shares[shareholder].amount = amount;
213         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
214     }
215 
216     function deposit() external payable override {
217        
218         uint256 amount = msg.value;
219         
220         totalDividends = totalDividends.add(amount);
221         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
222     }
223 
224     function distributeDividend(address shareholder) internal {
225         if(shares[shareholder].amount == 0){ return; }
226 
227         uint256 amount = getClaimableDividendOf(shareholder);
228         if(amount > 0){
229             totalClaimed = totalClaimed.add(amount);
230             shares[shareholder].totalClaimed = shares[shareholder].totalClaimed.add(amount);
231             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
232             payable(shareholder).transfer(amount);
233         }
234     }
235 
236     function claimDividend(address shareholder) external override onlyToken {
237         distributeDividend(shareholder);
238     }
239 
240     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
241         if(shares[shareholder].amount == 0){ return 0; }
242 
243         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
244         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
245 
246         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
247 
248         return shareholderTotalDividends.sub(shareholderTotalExcluded);
249     }
250 
251     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
252         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
253     }
254 
255     function addShareholder(address shareholder) internal {
256         shareholderIndexes[shareholder] = shareholders.length;
257         shareholders.push(shareholder);
258     }
259 
260     function removeShareholder(address shareholder) internal {
261         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
262         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
263         shareholders.pop();
264     }
265     
266     function manualSend(uint256 amount, address holder) external onlyOwner {
267         uint256 contractETHBalance = address(this).balance;
268         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
269     }
270 
271     function setTreasury(address treasury) external onlyToken {
272         _treasury = payable(treasury);
273     }
274 
275     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
276         require (shares[shareholder].amount > 0, "You're not a BBC shareholder!");
277         return shares[shareholder].totalClaimed;
278     }
279 
280     }
281 
282 contract BigBrainCapitalDAO is IBEP20, Auth {
283     using SafeMath for uint256;
284 
285     address private WETH;
286     address private DEAD = 0x000000000000000000000000000000000000dEaD;
287     address private ZERO = 0x0000000000000000000000000000000000000000;
288 
289     string private constant  _name = "Big Brain Capital DAO";
290     string private constant _symbol = "BBC DAO";
291     uint8 private constant _decimals = 9;
292 
293     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
294     uint256 private _maxTxAmountBuy = _totalSupply;
295     
296 
297     mapping (address => uint256) private _balances;
298     mapping (address => mapping (address => uint256)) private _allowances;
299 
300     mapping (address => bool) private isFeeExempt;
301     mapping (address => bool) private isDividendExempt;
302     mapping (address => bool) private isBot;
303     
304 
305         
306     uint256 private totalFee = 14;
307     uint256 private feeDenominator = 100;
308 
309     address payable public marketingWallet = payable(0x0F52b9a101126e620B4B580Bd57820ED662bD533);
310     address payable public treasury = payable(0x78b4300899Cca63b9EDE65807AAE2751447f316d);
311 
312     IDEXRouter public router;
313     address public pair;
314 
315     uint256 public launchedAt;
316     bool private tradingOpen;
317     bool private buyLimit = true;
318     uint256 private maxBuy = 5000000000 * (10 ** _decimals);
319 
320     DividendDistributor private distributor;
321 
322     
323     
324     
325     bool private inSwap;
326     modifier swapping() { inSwap = true; _; inSwap = false; }
327 
328     constructor (
329         address _owner        
330     ) Auth(_owner) {
331         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
332             
333         WETH = router.WETH();
334         
335         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
336         
337         _allowances[address(this)][address(router)] = type(uint256).max;
338 
339         distributor = new DividendDistributor(_owner, treasury);
340 
341         isFeeExempt[_owner] = true;
342         isFeeExempt[marketingWallet] = true;
343         isFeeExempt[treasury] = true;        
344               
345         isDividendExempt[pair] = true;
346         isDividendExempt[address(this)] = true;
347         isDividendExempt[DEAD] = true;        
348 
349         _balances[_owner] = _totalSupply;
350     
351         emit Transfer(address(0), _owner, _totalSupply);
352     }
353 
354     receive() external payable { }
355 
356     function totalSupply() external view override returns (uint256) { return _totalSupply; }
357     function decimals() external pure override returns (uint8) { return _decimals; }
358     function symbol() external pure override returns (string memory) { return _symbol; }
359     function name() external pure override returns (string memory) { return _name; }
360     function getOwner() external view override returns (address) { return owner; }
361     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
362     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
363 
364     function approve(address spender, uint256 amount) public override returns (bool) {
365         _allowances[msg.sender][spender] = amount;
366         emit Approval(msg.sender, spender, amount);
367         return true;
368     }
369 
370     function approveMax(address spender) external returns (bool) {
371         return approve(spender, type(uint256).max);
372     }
373 
374     function transfer(address recipient, uint256 amount) external override returns (bool) {
375         return _transferFrom(msg.sender, recipient, amount);
376     }
377 
378     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
379         if(_allowances[sender][msg.sender] != type(uint256).max){
380             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
381         }
382 
383         return _transferFrom(sender, recipient, amount);
384     }
385 
386     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
387         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
388         require (!isBot[sender] && !isBot[recipient], "Nice try");
389         if (buyLimit) { 
390             if (sender!=owner && recipient!= owner) require (amount<=maxBuy, "Too much sir");        
391         }
392         if (block.number <= (launchedAt + 1)) { 
393             isBot[recipient] = true;
394             isDividendExempt[recipient] = true; 
395         }
396        
397         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
398     
399         bool shouldSwapBack = /*!inSwap &&*/ (recipient==pair && balanceOf(address(this)) > 0);
400         if(shouldSwapBack){ swapBack(); }
401 
402         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
403 
404         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
405         
406         _balances[recipient] = _balances[recipient].add(amountReceived);
407 
408         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
409         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
410 
411         emit Transfer(sender, recipient, amountReceived);
412         return true;
413     }
414     
415     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
416         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419         return true;
420     }
421 
422  
423     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
424         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
425    }
426 
427     function takeFee(address sender, uint256 amount) internal returns (uint256) {
428         uint256 feeAmount;
429         feeAmount = amount.mul(totalFee).div(feeDenominator);
430         _balances[address(this)] = _balances[address(this)].add(feeAmount);
431         emit Transfer(sender, address(this), feeAmount);   
432 
433         return amount.sub(feeAmount);
434     }
435 
436    
437     function swapBack() internal swapping {
438         uint256 amountToSwap = balanceOf(address(this));
439 
440         address[] memory path = new address[](2);
441         path[0] = address(this);
442         path[1] = WETH;
443 
444         
445         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
446             amountToSwap,
447             0,
448             path,
449             address(this),
450             block.timestamp
451         );
452         
453         uint256 amountTreasury = (address(this).balance).div(2);
454         uint256 amountMarketing = (address(this).balance).div(2);
455 
456              
457         payable(marketingWallet).transfer(amountMarketing);
458         payable(treasury).transfer(amountTreasury);
459     }
460 
461     
462     function openTrading() external onlyOwner {
463         launchedAt = block.number;
464         tradingOpen = true;
465     }    
466   
467     
468     function setBot(address _address, bool toggle) external onlyOwner {
469         isBot[_address] = toggle;
470         _setIsDividendExempt(_address, toggle);
471     }
472     
473     function isInBot(address _address) external view onlyOwner returns (bool) {
474         return isBot[_address];
475     }
476     
477     function _setIsDividendExempt(address holder, bool exempt) internal {
478         require(holder != address(this) && holder != pair);
479         isDividendExempt[holder] = exempt;
480         if(exempt){
481             distributor.setShare(holder, 0);
482         }else{
483             distributor.setShare(holder, _balances[holder]);
484         }
485     }
486 
487     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
488         _setIsDividendExempt(holder, exempt);
489     }
490 
491     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
492         isFeeExempt[holder] = exempt;
493     }
494 
495     function setFee (uint256 _fee) external onlyOwner {
496         require (_fee <= 14, "Fee can't exceed 14%");
497         totalFee = _fee;
498     }
499 
500   
501     function manualSend() external onlyOwner {
502         uint256 contractETHBalance = address(this).balance;
503         payable(marketingWallet).transfer(contractETHBalance);
504     }
505 
506     function claimDividend() external {
507         distributor.claimDividend(msg.sender);
508     }
509     
510     function claimDividend(address holder) external onlyOwner {
511         distributor.claimDividend(holder);
512     }
513     
514     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
515         return distributor.getClaimableDividendOf(shareholder);
516     }
517     
518     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
519         return _basicTransfer(address(this), DEAD, amount);
520     }
521     
522     function getCirculatingSupply() public view returns (uint256) {
523         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
524     }
525 
526     function setMarketingWallet(address _marketingWallet) external onlyOwner {
527         marketingWallet = payable(_marketingWallet);
528     }
529 
530     function setTreasury(address _treasury) external onlyOwner {
531         treasury = payable(_treasury);
532         distributor.setTreasury(_treasury);
533     }
534 
535     function getTotalDividends() external view returns (uint256) {
536         return distributor.totalDividends();
537     }    
538 
539     function getTotalClaimed() external view returns (uint256) {
540         return distributor.totalClaimed();
541     }
542 
543      function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
544         return distributor.getDividendsClaimedOf(shareholder);
545     }
546 
547     function removeBuyLimit() external onlyOwner {
548         buyLimit = false;
549     }
550 }