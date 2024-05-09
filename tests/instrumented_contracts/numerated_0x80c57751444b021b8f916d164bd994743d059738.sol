1 //
2 //
3 //      On-Chain Capital
4 //      Investing in on-chain games with profits spread amongst holders.
5 //
6 //      https://www.occ.capital/
7 //      https://t.me/OnChainCapital
8 //      https://twitter.com/OCCapitalETH
9 //      https://medium.com/@onchaincapital
10 //
11 //
12 //
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.7;
16 
17 /**
18  * Standard SafeMath, stripped down to just add/sub/mul/div
19  */
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33 
34         return c;
35     }
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43 
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 }
58 
59 /**
60  * BEP20 standard interface.
61  */
62 interface IBEP20 {
63     function totalSupply() external view returns (uint256);
64     function decimals() external view returns (uint8);
65     function symbol() external view returns (string memory);
66     function name() external view returns (string memory);
67     function getOwner() external view returns (address);
68     function balanceOf(address account) external view returns (uint256);
69     function transfer(address recipient, uint256 amount) external returns (bool);
70     function allowance(address _owner, address spender) external view returns (uint256);
71     function approve(address spender, uint256 amount) external returns (bool);
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * Allows for contract ownership along with multi-address authorization
79  */
80 abstract contract Auth {
81     address internal owner;
82 
83     constructor(address _owner) {
84         owner = _owner;
85     }
86 
87     /**
88      * Function modifier to require caller to be contract deployer
89      */
90     modifier onlyOwner() {
91         require(isOwner(msg.sender), "!Owner"); _;
92     }
93 
94     /**
95      * Check if address is owner
96      */
97     function isOwner(address account) public view returns (bool) {
98         return account == owner;
99     }
100 
101     /**
102      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
103      */
104     function transferOwnership(address payable adr) public onlyOwner {
105         owner = adr;
106         emit OwnershipTransferred(adr);
107     }
108 
109     event OwnershipTransferred(address owner);
110 }
111 
112 interface IDEXFactory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IDEXRouter {
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119 
120     function addLiquidity(
121         address tokenA,
122         address tokenB,
123         uint amountADesired,
124         uint amountBDesired,
125         uint amountAMin,
126         uint amountBMin,
127         address to,
128         uint deadline
129     ) external returns (uint amountA, uint amountB, uint liquidity);
130 
131     function addLiquidityETH(
132         address token,
133         uint amountTokenDesired,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline
138     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
139 
140     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external;
147 
148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external payable;
154 
155     function swapExactTokensForETHSupportingFeeOnTransferTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external;
162 }
163 
164 interface IDividendDistributor {
165     function setShare(address shareholder, uint256 amount) external;
166     function deposit() external payable;
167     function claimDividend(address shareholder) external;
168     function setTreasury(address treasury) external;
169     function getDividendsClaimedOf (address shareholder) external returns (uint256);
170 }
171 
172 contract DividendDistributor is IDividendDistributor {
173     using SafeMath for uint256;
174 
175     address public _token;
176     address public _owner;
177     address public _treasury;
178 
179     struct Share {
180         uint256 amount;
181         uint256 totalExcluded;
182         uint256 totalClaimed;
183     }
184 
185     address[] private shareholders;
186     mapping (address => uint256) private shareholderIndexes;
187 
188     mapping (address => Share) public shares;
189 
190     uint256 public totalShares;
191     uint256 public totalDividends;
192     uint256 public totalClaimed;
193     uint256 public dividendsPerShare;
194     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
195 
196     modifier onlyToken() {
197         require(msg.sender == _token); _;
198     }
199     
200     modifier onlyOwner() {
201         require(msg.sender == _owner); _;
202     }
203 
204     constructor (address owner, address treasury) {
205         _token = msg.sender;
206         _owner = owner;
207         _treasury = treasury;
208     }
209 
210    // receive() external payable { }
211 
212     function setShare(address shareholder, uint256 amount) external override onlyToken {
213         if(shares[shareholder].amount > 0){
214             distributeDividend(shareholder);
215         }
216 
217         if(amount > 0 && shares[shareholder].amount == 0){
218             addShareholder(shareholder);
219         }else if(amount == 0 && shares[shareholder].amount > 0){
220             removeShareholder(shareholder);
221         }
222 
223         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
224         shares[shareholder].amount = amount;
225         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
226     }
227 
228     function deposit() external payable override {
229        
230         uint256 amount = msg.value;
231         
232         totalDividends = totalDividends.add(amount);
233         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
234     }
235 
236     function distributeDividend(address shareholder) internal {
237         if(shares[shareholder].amount == 0){ return; }
238 
239         uint256 amount = getClaimableDividendOf(shareholder);
240         if(amount > 0){
241             totalClaimed = totalClaimed.add(amount);
242             shares[shareholder].totalClaimed = shares[shareholder].totalClaimed.add(amount);
243             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
244             payable(shareholder).transfer(amount);
245         }
246     }
247 
248     function claimDividend(address shareholder) external override onlyToken {
249         distributeDividend(shareholder);
250     }
251 
252     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
253         if(shares[shareholder].amount == 0){ return 0; }
254 
255         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
256         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
257 
258         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
259 
260         return shareholderTotalDividends.sub(shareholderTotalExcluded);
261     }
262 
263     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
264         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
265     }
266 
267     function addShareholder(address shareholder) internal {
268         shareholderIndexes[shareholder] = shareholders.length;
269         shareholders.push(shareholder);
270     }
271 
272     function removeShareholder(address shareholder) internal {
273         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
274         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
275         shareholders.pop();
276     }
277     
278     function manualSend(uint256 amount, address holder) external onlyOwner {
279         uint256 contractETHBalance = address(this).balance;
280         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
281     }
282 
283     function setTreasury(address treasury) external onlyToken {
284         _treasury = payable(treasury);
285     }
286 
287     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
288         require (shares[shareholder].amount > 0, "You're not an OCC shareholder!");
289         return shares[shareholder].totalClaimed;
290     }
291 
292     }
293 
294 contract OnChainCapital is IBEP20, Auth {
295     using SafeMath for uint256;
296 
297     address private WETH;
298     address private DEAD = 0x000000000000000000000000000000000000dEaD;
299     address private ZERO = 0x0000000000000000000000000000000000000000;
300 
301     string private constant  _name = "On Chain Capital";
302     string private constant _symbol = "OCC";
303     uint8 private constant _decimals = 9;
304 
305     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
306     uint256 private _maxTxAmountBuy = _totalSupply;
307     
308 
309     mapping (address => uint256) private _balances;
310     mapping (address => mapping (address => uint256)) private _allowances;
311 
312     mapping (address => bool) private isFeeExempt;
313     mapping (address => bool) private isDividendExempt;
314     mapping (address => bool) private isBot;
315     
316 
317         
318     uint256 private totalFee = 14;
319     uint256 private feeDenominator = 100;
320 
321     address payable public marketingWallet = payable(0x80BfD092114559fee61657B13C401De445cE1bA7);
322     address payable public treasury = payable(0xfc5D9FeB7b70798AD343e6c7624eDE6B302190f3);
323 
324     IDEXRouter public router;
325     address public pair;
326 
327     uint256 public launchedAt;
328     bool private tradingOpen;
329     bool private buyLimit = true;
330     uint256 private maxBuy = 5000000000 * (10 ** _decimals);
331 
332     DividendDistributor private distributor;
333 
334     
335     
336     
337     bool private inSwap;
338     modifier swapping() { inSwap = true; _; inSwap = false; }
339 
340     constructor (
341         address _owner        
342     ) Auth(_owner) {
343         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
344             
345         WETH = router.WETH();
346         
347         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
348         
349         _allowances[address(this)][address(router)] = type(uint256).max;
350 
351         distributor = new DividendDistributor(_owner, treasury);
352 
353         isFeeExempt[_owner] = true;
354         isFeeExempt[marketingWallet] = true;
355         isFeeExempt[treasury] = true;        
356               
357         isDividendExempt[pair] = true;
358         isDividendExempt[address(this)] = true;
359         isDividendExempt[DEAD] = true;        
360 
361         _balances[_owner] = _totalSupply;
362     
363         emit Transfer(address(0), _owner, _totalSupply);
364     }
365 
366     receive() external payable { }
367 
368     function totalSupply() external view override returns (uint256) { return _totalSupply; }
369     function decimals() external pure override returns (uint8) { return _decimals; }
370     function symbol() external pure override returns (string memory) { return _symbol; }
371     function name() external pure override returns (string memory) { return _name; }
372     function getOwner() external view override returns (address) { return owner; }
373     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
374     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
375 
376     function approve(address spender, uint256 amount) public override returns (bool) {
377         _allowances[msg.sender][spender] = amount;
378         emit Approval(msg.sender, spender, amount);
379         return true;
380     }
381 
382     function approveMax(address spender) external returns (bool) {
383         return approve(spender, type(uint256).max);
384     }
385 
386     function transfer(address recipient, uint256 amount) external override returns (bool) {
387         return _transferFrom(msg.sender, recipient, amount);
388     }
389 
390     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
391         if(_allowances[sender][msg.sender] != type(uint256).max){
392             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
393         }
394 
395         return _transferFrom(sender, recipient, amount);
396     }
397 
398     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
399         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
400         require (!isBot[sender] && !isBot[recipient], "Nice try");
401         if (buyLimit) { 
402             if (sender!=owner && recipient!= owner) require (amount<=maxBuy, "Too much sir");        
403         }
404         if (block.number <= (launchedAt + 1)) { 
405             isBot[recipient] = true;
406             isDividendExempt[recipient] = true; 
407         }
408        
409         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
410     
411         bool shouldSwapBack = /*!inSwap &&*/ (recipient==pair && balanceOf(address(this)) > 0);
412         if(shouldSwapBack){ swapBack(); }
413 
414         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
415 
416         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
417         
418         _balances[recipient] = _balances[recipient].add(amountReceived);
419 
420         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
421         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
422 
423         emit Transfer(sender, recipient, amountReceived);
424         return true;
425     }
426     
427     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
428         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
429         _balances[recipient] = _balances[recipient].add(amount);
430         emit Transfer(sender, recipient, amount);
431         return true;
432     }
433 
434  
435     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
436         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
437    }
438 
439     function takeFee(address sender, uint256 amount) internal returns (uint256) {
440         uint256 feeAmount;
441         feeAmount = amount.mul(totalFee).div(feeDenominator);
442         _balances[address(this)] = _balances[address(this)].add(feeAmount);
443         emit Transfer(sender, address(this), feeAmount);   
444 
445         return amount.sub(feeAmount);
446     }
447 
448    
449     function swapBack() internal swapping {
450         uint256 amountToSwap = balanceOf(address(this));
451 
452         address[] memory path = new address[](2);
453         path[0] = address(this);
454         path[1] = WETH;
455 
456         
457         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
458             amountToSwap,
459             0,
460             path,
461             address(this),
462             block.timestamp
463         );
464         
465         uint256 amountTreasury = (address(this).balance).div(2);
466         uint256 amountMarketing = (address(this).balance).div(2);
467 
468              
469         payable(marketingWallet).transfer(amountMarketing);
470         payable(treasury).transfer(amountTreasury);
471     }
472 
473     
474     function openTrading() external onlyOwner {
475         launchedAt = block.number;
476         tradingOpen = true;
477     }    
478   
479     
480     function setBot(address _address, bool toggle) external onlyOwner {
481         isBot[_address] = toggle;
482         _setIsDividendExempt(_address, toggle);
483     }
484     
485     function isInBot(address _address) external view onlyOwner returns (bool) {
486         return isBot[_address];
487     }
488     
489     function _setIsDividendExempt(address holder, bool exempt) internal {
490         require(holder != address(this) && holder != pair);
491         isDividendExempt[holder] = exempt;
492         if(exempt){
493             distributor.setShare(holder, 0);
494         }else{
495             distributor.setShare(holder, _balances[holder]);
496         }
497     }
498 
499     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
500         _setIsDividendExempt(holder, exempt);
501     }
502 
503     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
504         isFeeExempt[holder] = exempt;
505     }
506 
507     function setFee (uint256 _fee) external onlyOwner {
508         require (_fee <= 14, "Fee can't exceed 14%");
509         totalFee = _fee;
510     }
511 
512   
513     function manualSend() external onlyOwner {
514         uint256 contractETHBalance = address(this).balance;
515         payable(marketingWallet).transfer(contractETHBalance);
516     }
517 
518     function claimDividend() external {
519         distributor.claimDividend(msg.sender);
520     }
521     
522     function claimDividend(address holder) external onlyOwner {
523         distributor.claimDividend(holder);
524     }
525     
526     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
527         return distributor.getClaimableDividendOf(shareholder);
528     }
529     
530     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
531         return _basicTransfer(address(this), DEAD, amount);
532     }
533     
534     function getCirculatingSupply() public view returns (uint256) {
535         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
536     }
537 
538     function setMarketingWallet(address _marketingWallet) external onlyOwner {
539         marketingWallet = payable(_marketingWallet);
540     }
541 
542     function setTreasury(address _treasury) external onlyOwner {
543         treasury = payable(_treasury);
544         distributor.setTreasury(_treasury);
545     }
546 
547     function getTotalDividends() external view returns (uint256) {
548         return distributor.totalDividends();
549     }    
550 
551     function getTotalClaimed() external view returns (uint256) {
552         return distributor.totalClaimed();
553     }
554 
555      function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
556         return distributor.getDividendsClaimedOf(shareholder);
557     }
558 
559     function removeBuyLimit() external onlyOwner {
560         buyLimit = false;
561     }
562 }