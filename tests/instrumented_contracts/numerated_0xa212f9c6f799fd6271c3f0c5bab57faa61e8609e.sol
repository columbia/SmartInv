1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.13;
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
48  * ERC20 standard interface.
49  */
50 interface IERC20 {
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
154     function deposit(uint256 amount) external;
155     function claimDividend(address shareholder) external;
156     function getDividendsClaimedOf (address shareholder) external returns (uint256);
157 }
158 
159 contract DividendDistributor is IDividendDistributor {
160     using SafeMath for uint256;
161 
162     address public _token;
163     address public _owner;
164 
165     address public immutable BITCOIN = address(0x72e4f9F808C49A2a61dE9C5896298920Dc4EEEa9); //UNI
166 
167 
168     struct Share {
169         uint256 amount;
170         uint256 totalExcluded;
171         uint256 totalClaimed;
172     }
173 
174     address[] private shareholders;
175     mapping (address => uint256) private shareholderIndexes;
176 
177     mapping (address => Share) public shares;
178 
179     uint256 public totalShares;
180     uint256 public totalDividends;
181     uint256 public totalClaimed;
182     uint256 public dividendsPerShare;
183     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
184 
185     modifier onlyToken() {
186         require(msg.sender == _token); _;
187     }
188     
189     modifier onlyOwner() {
190         require(msg.sender == _owner); _;
191     }
192 
193     constructor (address owner) {
194         _token = msg.sender;
195         _owner = owner;
196     }
197 
198     receive() external payable { }
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
216     function deposit(uint256 amount) external override onlyToken {
217         
218         if (amount > 0) {        
219             totalDividends = totalDividends.add(amount);
220             dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
221         }
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
232             IERC20(BITCOIN).transfer(shareholder, amount);
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
271 
272     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
273         require (shares[shareholder].amount > 0, "You're not a PRINTER shareholder!");
274         return shares[shareholder].totalClaimed;
275     }
276 
277     }
278 
279 contract HPOS10INUPrinter is IERC20, Auth {
280     using SafeMath for uint256;
281 
282     address private WETH;
283     address private DEAD = 0x000000000000000000000000000000000000dEaD;
284     address private ZERO = 0x0000000000000000000000000000000000000000;
285 
286     address public immutable BITCOIN = address(0x72e4f9F808C49A2a61dE9C5896298920Dc4EEEa9); //UNI
287 
288     string private constant  _name = "HPOS10INU Printer";
289     string private constant _symbol = "HP";
290     uint8 private constant _decimals = 9;
291 
292     uint256 private _totalSupply = 690420000000 * (10 ** _decimals);
293     uint256 private _maxTxAmountBuy = _totalSupply;
294     
295 
296     mapping (address => uint256) private _balances;
297     mapping (address => mapping (address => uint256)) private _allowances;
298     mapping (address => uint256) private cooldown;
299 
300     mapping (address => bool) private isFeeExempt;
301     mapping (address => bool) private isDividendExempt;
302     mapping (address => bool) private isBot;
303             
304     uint256 private totalFee = 14;
305     uint256 private feeDenominator = 100;
306 
307     address payable public marketingWallet = payable(0xdAb5AD1E2B2A3ee858C65e673EA90C83CE01ae6E);
308 
309     IDEXRouter public router;
310     address public pair;
311 
312     uint256 public launchedAt;
313     bool private tradingOpen;
314     bool private buyLimit = true;
315     uint256 private maxBuy = 10356300000 * (10 ** _decimals);
316     uint256 public numTokensSellToAddToLiquidity = 2761680000 * 10**9;
317 
318     DividendDistributor private distributor;    
319     
320     bool public blacklistEnabled = false;
321     bool private inSwap;
322     modifier swapping() { inSwap = true; _; inSwap = false; }
323 
324     constructor (
325         address _owner        
326     ) Auth(_owner) {
327         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
328             
329         WETH = router.WETH();
330         
331         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
332         
333         _allowances[address(this)][address(router)] = type(uint256).max;
334 
335         distributor = new DividendDistributor(_owner);
336 
337         isFeeExempt[_owner] = true;
338         isFeeExempt[marketingWallet] = true;             
339               
340         isDividendExempt[pair] = true;
341         isDividendExempt[address(this)] = true;
342         isDividendExempt[DEAD] = true;        
343 
344         _balances[_owner] = _totalSupply;
345     
346         emit Transfer(address(0), _owner, _totalSupply);
347     }
348 
349     receive() external payable { }
350 
351     function totalSupply() external view override returns (uint256) { return _totalSupply; }
352     function decimals() external pure override returns (uint8) { return _decimals; }
353     function symbol() external pure override returns (string memory) { return _symbol; }
354     function name() external pure override returns (string memory) { return _name; }
355     function getOwner() external view override returns (address) { return owner; }
356     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
357     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
358 
359     function approve(address spender, uint256 amount) public override returns (bool) {
360         _allowances[msg.sender][spender] = amount;
361         emit Approval(msg.sender, spender, amount);
362         return true;
363     }
364 
365     function approveMax(address spender) external returns (bool) {
366         return approve(spender, type(uint256).max);
367     }
368 
369     function transfer(address recipient, uint256 amount) external override returns (bool) {
370         return _transferFrom(msg.sender, recipient, amount);
371     }
372 
373     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
374         if(_allowances[sender][msg.sender] != type(uint256).max){
375             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
376         }
377 
378         return _transferFrom(sender, recipient, amount);
379     }
380 
381     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
382         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
383         if (blacklistEnabled) {
384             require (!isBot[sender] && !isBot[recipient], "Bot!");
385         }
386         if (buyLimit) { 
387             if (sender!=owner && recipient!= owner) require (amount<=maxBuy, "Too much sir");        
388         }
389 
390         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
391             require (cooldown[recipient] < block.timestamp);
392             cooldown[recipient] = block.timestamp + 60 seconds; 
393         }
394        
395         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
396 
397         uint256 contractTokenBalance = balanceOf(address(this));
398 
399         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
400     
401         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
402         if(shouldSwapBack){ swapBack(); }
403 
404         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
405 
406         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
407         
408         _balances[recipient] = _balances[recipient].add(amountReceived);
409 
410         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
411         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
412 
413         emit Transfer(sender, recipient, amountReceived);
414         return true;
415     }
416     
417     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
418         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
419         _balances[recipient] = _balances[recipient].add(amount);
420         emit Transfer(sender, recipient, amount);
421         return true;
422     }
423 
424  
425     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
426         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
427    }
428 
429     function takeFee(address sender, uint256 amount) internal returns (uint256) {
430         uint256 feeAmount;
431         feeAmount = amount.mul(totalFee).div(feeDenominator);
432         _balances[address(this)] = _balances[address(this)].add(feeAmount);
433         emit Transfer(sender, address(this), feeAmount);   
434 
435         return amount.sub(feeAmount);
436     }
437 
438    
439     function swapBack() internal swapping {
440 
441         uint256 amountToSwap = balanceOf(address(this));        
442 
443         swapTokensForEth(amountToSwap.div(2));
444         swapTokensForBITCOIN(amountToSwap.div(2));
445 
446         uint256 dividends = IERC20(BITCOIN).balanceOf(address(this));
447 
448         bool success = IERC20(BITCOIN).transfer(address(distributor), dividends);
449 
450         if (success) {
451             distributor.deposit(dividends);            
452         }
453              
454         payable(marketingWallet).transfer(address(this).balance);        
455     }
456 
457     
458 
459     function swapTokensForBITCOIN(uint256 tokenAmount) private {
460 
461         address[] memory path = new address[](3);
462         path[0] = address(this);
463         path[1] = WETH;
464         path[2] = BITCOIN;
465 
466         // make the swap
467         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
468             tokenAmount,
469             0,
470             path,
471             address(this),
472             block.timestamp
473         );
474     }
475 
476     function swapTokensForEth(uint256 tokenAmount) private {
477 
478         // generate the uniswap pair path of token -> weth
479         address[] memory path = new address[](2);
480         path[0] = address(this);
481         path[1] = WETH;
482 
483         // make the swap
484         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
485             tokenAmount,
486             0, // accept any amount of ETH
487             path,
488             address(this),
489             block.timestamp
490         );
491     }
492 
493     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
494         
495         // add the liquidity
496         router.addLiquidityETH{value: ethAmount}(
497             address(this),
498             tokenAmount,
499             0, // slippage is unavoidable
500             0, // slippage is unavoidable
501             owner,
502             block.timestamp
503         );
504     }
505 
506     
507     function openTrading() external onlyOwner {
508         launchedAt = block.number;
509         tradingOpen = true;
510     }    
511   
512     
513     function setBot(address _address, bool toggle) external onlyOwner {
514         isBot[_address] = toggle;
515         _setIsDividendExempt(_address, toggle);
516     }
517     
518     
519     function _setIsDividendExempt(address holder, bool exempt) internal {
520         require(holder != address(this) && holder != pair);
521         isDividendExempt[holder] = exempt;
522         if(exempt){
523             distributor.setShare(holder, 0);
524         }else{
525             distributor.setShare(holder, _balances[holder]);
526         }
527     }
528 
529     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
530         _setIsDividendExempt(holder, exempt);
531     }
532 
533     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
534         isFeeExempt[holder] = exempt;
535     }
536 
537     function setFee (uint256 _fee) external onlyOwner {
538         require (_fee <= 14, "Fee can't exceed 14%");
539         totalFee = _fee;
540     }
541   
542     function manualSend() external onlyOwner {
543         uint256 contractETHBalance = address(this).balance;
544         payable(marketingWallet).transfer(contractETHBalance);
545     }
546 
547     function claimDividend() external {
548         distributor.claimDividend(msg.sender);
549     }
550     
551     function claimDividend(address holder) external onlyOwner {
552         distributor.claimDividend(holder);
553     }
554     
555     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
556         return distributor.getClaimableDividendOf(shareholder);
557     }
558     
559     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
560         return _basicTransfer(address(this), DEAD, amount);
561     }
562     
563     function getCirculatingSupply() public view returns (uint256) {
564         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
565     }
566 
567     function setMarketingWallet(address _marketingWallet) external onlyOwner {
568         marketingWallet = payable(_marketingWallet);
569     } 
570 
571     function getTotalDividends() external view returns (uint256) {
572         return distributor.totalDividends();
573     }    
574 
575     function getTotalClaimed() external view returns (uint256) {
576         return distributor.totalClaimed();
577     }
578 
579      function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
580         return distributor.getDividendsClaimedOf(shareholder);
581     }
582 
583     function removeBuyLimit() external onlyOwner {
584         buyLimit = false;
585     }
586 
587     function checkBot(address account) public view returns (bool) {
588         return isBot[account];
589     }
590 
591     function setBlacklistEnabled() external onlyOwner {
592         require (blacklistEnabled == false, "can only be called once");
593         blacklistEnabled = true;
594     }
595 
596     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
597         require (amount <= _totalSupply.div(100), "can't exceed 1%");
598         numTokensSellToAddToLiquidity = amount * 10 ** 9;
599     } 
600    
601 }