1 /*
2 
3 https://printthepepe.com
4 https://twitter.com/PrintThePepe
5 
6 */
7 
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity 0.8.13;
12 
13 /**
14  * Standard SafeMath, stripped down to just add/sub/mul/div
15  */
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51         return c;
52     }
53 }
54 
55 /**
56  * ERC20 standard interface.
57  */
58 interface IERC20 {
59     function totalSupply() external view returns (uint256);
60     function decimals() external view returns (uint8);
61     function symbol() external view returns (string memory);
62     function name() external view returns (string memory);
63     function getOwner() external view returns (address);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address _owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * Allows for contract ownership along with multi-address authorization
75  */
76 abstract contract Auth {
77     address internal owner;
78 
79     constructor(address _owner) {
80         owner = _owner;
81     }
82 
83     /**
84      * Function modifier to require caller to be contract deployer
85      */
86     modifier onlyOwner() {
87         require(isOwner(msg.sender), "!Owner"); _;
88     }
89 
90     /**
91      * Check if address is owner
92      */
93     function isOwner(address account) public view returns (bool) {
94         return account == owner;
95     }
96 
97     /**
98      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
99      */
100     function transferOwnership(address payable adr) public onlyOwner {
101         owner = adr;
102         emit OwnershipTransferred(adr);
103     }
104 
105     event OwnershipTransferred(address owner);
106 }
107 
108 interface IDEXFactory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IDEXRouter {
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115 
116     function addLiquidity(
117         address tokenA,
118         address tokenB,
119         uint amountADesired,
120         uint amountBDesired,
121         uint amountAMin,
122         uint amountBMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountA, uint amountB, uint liquidity);
126 
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 
136     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 
144     function swapExactETHForTokensSupportingFeeOnTransferTokens(
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external payable;
150 
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158 }
159 
160 interface IDividendDistributor {
161     function setShare(address shareholder, uint256 amount) external;
162     function deposit(uint256 amount) external;
163     function claimDividend(address shareholder) external;
164     function getDividendsClaimedOf (address shareholder) external returns (uint256);
165 }
166 
167 contract DividendDistributor is IDividendDistributor {
168     using SafeMath for uint256;
169 
170     address public _token;
171     address public _owner;
172 
173     address public immutable PEPE = address(0x6982508145454Ce325dDbE47a25d4ec3d2311933); //UNI
174 
175 
176     struct Share {
177         uint256 amount;
178         uint256 totalExcluded;
179         uint256 totalClaimed;
180     }
181 
182     address[] private shareholders;
183     mapping (address => uint256) private shareholderIndexes;
184 
185     mapping (address => Share) public shares;
186 
187     uint256 public totalShares;
188     uint256 public totalDividends;
189     uint256 public totalClaimed;
190     uint256 public dividendsPerShare;
191     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
192 
193     modifier onlyToken() {
194         require(msg.sender == _token); _;
195     }
196     
197     modifier onlyOwner() {
198         require(msg.sender == _owner); _;
199     }
200 
201     constructor (address owner) {
202         _token = msg.sender;
203         _owner = owner;
204     }
205 
206     receive() external payable { }
207 
208     function setShare(address shareholder, uint256 amount) external override onlyToken {
209         if(shares[shareholder].amount > 0){
210             distributeDividend(shareholder);
211         }
212 
213         if(amount > 0 && shares[shareholder].amount == 0){
214             addShareholder(shareholder);
215         }else if(amount == 0 && shares[shareholder].amount > 0){
216             removeShareholder(shareholder);
217         }
218 
219         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
220         shares[shareholder].amount = amount;
221         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
222     }
223 
224     function deposit(uint256 amount) external override onlyToken {
225         
226         if (amount > 0) {        
227             totalDividends = totalDividends.add(amount);
228             dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
229         }
230     }
231 
232     function distributeDividend(address shareholder) internal {
233         if(shares[shareholder].amount == 0){ return; }
234 
235         uint256 amount = getClaimableDividendOf(shareholder);
236         if(amount > 0){
237             totalClaimed = totalClaimed.add(amount);
238             shares[shareholder].totalClaimed = shares[shareholder].totalClaimed.add(amount);
239             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
240             IERC20(PEPE).transfer(shareholder, amount);
241         }
242     }
243 
244     function claimDividend(address shareholder) external override onlyToken {
245         distributeDividend(shareholder);
246     }
247 
248     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
249         if(shares[shareholder].amount == 0){ return 0; }
250 
251         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
252         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
253 
254         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
255 
256         return shareholderTotalDividends.sub(shareholderTotalExcluded);
257     }
258 
259     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
260         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
261     }
262 
263     function addShareholder(address shareholder) internal {
264         shareholderIndexes[shareholder] = shareholders.length;
265         shareholders.push(shareholder);
266     }
267 
268     function removeShareholder(address shareholder) internal {
269         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
270         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
271         shareholders.pop();
272     }
273     
274     function manualSend(uint256 amount, address holder) external onlyOwner {
275         uint256 contractETHBalance = address(this).balance;
276         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
277     }
278 
279 
280     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
281         require (shares[shareholder].amount > 0, "You're not a PRINTER shareholder!");
282         return shares[shareholder].totalClaimed;
283     }
284 
285     }
286 
287 contract PrintThePepe is IERC20, Auth {
288     using SafeMath for uint256;
289 
290     address private WETH;
291     address private DEAD = 0x000000000000000000000000000000000000dEaD;
292     address private ZERO = 0x0000000000000000000000000000000000000000;
293 
294     address public immutable PEPE = address(0x6982508145454Ce325dDbE47a25d4ec3d2311933); //UNI
295 
296     string private constant  _name = "Print The Pepe";
297     string private constant _symbol = "PP";
298     uint8 private constant _decimals = 9;
299 
300     uint256 private _totalSupply = 69696969 * (10 ** _decimals);
301     uint256 private _maxTxAmountBuy = _totalSupply;
302     
303 
304     mapping (address => uint256) private _balances;
305     mapping (address => mapping (address => uint256)) private _allowances;
306     mapping (address => uint256) private cooldown;
307 
308     mapping (address => bool) private isFeeExempt;
309     mapping (address => bool) private isDividendExempt;
310     mapping (address => bool) private isBot;
311             
312     uint256 private totalFee = 14;
313     uint256 private feeDenominator = 100;
314 
315     address payable public marketingWallet = payable(0x5B95162A51856195c224b40A0805E30929463c95);
316 
317     IDEXRouter public router;
318     address public pair;
319 
320     uint256 public launchedAt;
321     bool private tradingOpen;
322     bool private buyLimit = true;
323     uint256 private maxBuy = 1393939 * (10 ** _decimals);
324     uint256 public numTokensSellToAddToLiquidity = 278787 * 10**9;
325 
326     DividendDistributor private distributor;    
327     
328     bool public blacklistEnabled = false;
329     bool private inSwap;
330     modifier swapping() { inSwap = true; _; inSwap = false; }
331 
332     constructor (
333         address _owner        
334     ) Auth(_owner) {
335         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
336             
337         WETH = router.WETH();
338         
339         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
340         
341         _allowances[address(this)][address(router)] = type(uint256).max;
342 
343         distributor = new DividendDistributor(_owner);
344 
345         isFeeExempt[_owner] = true;
346         isFeeExempt[marketingWallet] = true;             
347               
348         isDividendExempt[pair] = true;
349         isDividendExempt[address(this)] = true;
350         isDividendExempt[DEAD] = true;        
351 
352         _balances[_owner] = _totalSupply;
353     
354         emit Transfer(address(0), _owner, _totalSupply);
355     }
356 
357     receive() external payable { }
358 
359     function totalSupply() external view override returns (uint256) { return _totalSupply; }
360     function decimals() external pure override returns (uint8) { return _decimals; }
361     function symbol() external pure override returns (string memory) { return _symbol; }
362     function name() external pure override returns (string memory) { return _name; }
363     function getOwner() external view override returns (address) { return owner; }
364     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
365     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
366 
367     function approve(address spender, uint256 amount) public override returns (bool) {
368         _allowances[msg.sender][spender] = amount;
369         emit Approval(msg.sender, spender, amount);
370         return true;
371     }
372 
373     function approveMax(address spender) external returns (bool) {
374         return approve(spender, type(uint256).max);
375     }
376 
377     function transfer(address recipient, uint256 amount) external override returns (bool) {
378         return _transferFrom(msg.sender, recipient, amount);
379     }
380 
381     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
382         if(_allowances[sender][msg.sender] != type(uint256).max){
383             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
384         }
385 
386         return _transferFrom(sender, recipient, amount);
387     }
388 
389     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
390         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
391         if (blacklistEnabled) {
392             require (!isBot[sender] && !isBot[recipient], "Bot!");
393         }
394         if (buyLimit) { 
395             if (sender!=owner && recipient!= owner) require (amount<=maxBuy, "Too much sir");        
396         }
397 
398         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
399             require (cooldown[recipient] < block.timestamp);
400             cooldown[recipient] = block.timestamp + 60 seconds; 
401         }
402        
403         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
404 
405         uint256 contractTokenBalance = balanceOf(address(this));
406 
407         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
408     
409         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
410         if(shouldSwapBack){ swapBack(); }
411 
412         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
413 
414         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
415         
416         _balances[recipient] = _balances[recipient].add(amountReceived);
417 
418         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
419         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
420 
421         emit Transfer(sender, recipient, amountReceived);
422         return true;
423     }
424     
425     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
426         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
427         _balances[recipient] = _balances[recipient].add(amount);
428         emit Transfer(sender, recipient, amount);
429         return true;
430     }
431 
432  
433     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
434         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
435    }
436 
437     function takeFee(address sender, uint256 amount) internal returns (uint256) {
438         uint256 feeAmount;
439         feeAmount = amount.mul(totalFee).div(feeDenominator);
440         _balances[address(this)] = _balances[address(this)].add(feeAmount);
441         emit Transfer(sender, address(this), feeAmount);   
442 
443         return amount.sub(feeAmount);
444     }
445 
446    
447     function swapBack() internal swapping {
448 
449         uint256 amountToSwap = balanceOf(address(this));        
450 
451         swapTokensForEth(amountToSwap.div(2));
452         swapTokensForPEPE(amountToSwap.div(2));
453 
454         uint256 dividends = IERC20(PEPE).balanceOf(address(this));
455 
456         bool success = IERC20(PEPE).transfer(address(distributor), dividends);
457 
458         if (success) {
459             distributor.deposit(dividends);            
460         }
461              
462         payable(marketingWallet).transfer(address(this).balance);        
463     }
464 
465     
466 
467     function swapTokensForPEPE(uint256 tokenAmount) private {
468 
469         address[] memory path = new address[](3);
470         path[0] = address(this);
471         path[1] = WETH;
472         path[2] = PEPE;
473 
474         // make the swap
475         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
476             tokenAmount,
477             0,
478             path,
479             address(this),
480             block.timestamp
481         );
482     }
483 
484     function swapTokensForEth(uint256 tokenAmount) private {
485 
486         // generate the uniswap pair path of token -> weth
487         address[] memory path = new address[](2);
488         path[0] = address(this);
489         path[1] = WETH;
490 
491         // make the swap
492         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
493             tokenAmount,
494             0, // accept any amount of ETH
495             path,
496             address(this),
497             block.timestamp
498         );
499     }
500 
501     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
502         
503         // add the liquidity
504         router.addLiquidityETH{value: ethAmount}(
505             address(this),
506             tokenAmount,
507             0, // slippage is unavoidable
508             0, // slippage is unavoidable
509             owner,
510             block.timestamp
511         );
512     }
513 
514     
515     function openTrading() external onlyOwner {
516         launchedAt = block.number;
517         tradingOpen = true;
518     }    
519   
520     
521     function setBot(address _address, bool toggle) external onlyOwner {
522         isBot[_address] = toggle;
523         _setIsDividendExempt(_address, toggle);
524     }
525     
526     
527     function _setIsDividendExempt(address holder, bool exempt) internal {
528         require(holder != address(this) && holder != pair);
529         isDividendExempt[holder] = exempt;
530         if(exempt){
531             distributor.setShare(holder, 0);
532         }else{
533             distributor.setShare(holder, _balances[holder]);
534         }
535     }
536 
537     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
538         _setIsDividendExempt(holder, exempt);
539     }
540 
541     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
542         isFeeExempt[holder] = exempt;
543     }
544 
545     function setFee (uint256 _fee) external onlyOwner {
546         require (_fee <= 14, "Fee can't exceed 14%");
547         totalFee = _fee;
548     }
549   
550     function manualSend() external onlyOwner {
551         uint256 contractETHBalance = address(this).balance;
552         payable(marketingWallet).transfer(contractETHBalance);
553     }
554 
555     function claimDividend() external {
556         distributor.claimDividend(msg.sender);
557     }
558     
559     function claimDividend(address holder) external onlyOwner {
560         distributor.claimDividend(holder);
561     }
562     
563     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
564         return distributor.getClaimableDividendOf(shareholder);
565     }
566     
567     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
568         return _basicTransfer(address(this), DEAD, amount);
569     }
570     
571     function getCirculatingSupply() public view returns (uint256) {
572         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
573     }
574 
575     function setMarketingWallet(address _marketingWallet) external onlyOwner {
576         marketingWallet = payable(_marketingWallet);
577     } 
578 
579     function getTotalDividends() external view returns (uint256) {
580         return distributor.totalDividends();
581     }    
582 
583     function getTotalClaimed() external view returns (uint256) {
584         return distributor.totalClaimed();
585     }
586 
587      function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
588         return distributor.getDividendsClaimedOf(shareholder);
589     }
590 
591     function removeBuyLimit() external onlyOwner {
592         buyLimit = false;
593     }
594 
595     function checkBot(address account) public view returns (bool) {
596         return isBot[account];
597     }
598 
599     function setBlacklistEnabled() external onlyOwner {
600         require (blacklistEnabled == false, "can only be called once");
601         blacklistEnabled = true;
602     }
603 
604     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
605         require (amount <= _totalSupply.div(100), "can't exceed 1%");
606         numTokensSellToAddToLiquidity = amount * 10 ** 9;
607     } 
608    
609 }