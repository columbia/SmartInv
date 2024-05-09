1 // Website: https://printdollars.gg/
2 // Twitter: https://twitter.com/fed_erc20
3 // Telegram: https://t.me/FED_erc20
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity 0.8.13;
8 
9 /**
10  * Standard SafeMath, stripped down to just add/sub/mul/div
11  */
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25 
26         return c;
27     }
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 }
50 
51 /**
52  * ERC20 standard interface.
53  */
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
69 /**
70  * Allows for contract ownership along with multi-address authorization
71  */
72 abstract contract Auth {
73     address internal owner;
74 
75     constructor(address _owner) {
76         owner = _owner;
77     }
78 
79     /**
80      * Function modifier to require caller to be contract deployer
81      */
82     modifier onlyOwner() {
83         require(isOwner(msg.sender), "!Owner"); _;
84     }
85 
86     /**
87      * Check if address is owner
88      */
89     function isOwner(address account) public view returns (bool) {
90         return account == owner;
91     }
92 
93     /**
94      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
95      */
96     function transferOwnership(address payable adr) public onlyOwner {
97         owner = adr;
98         emit OwnershipTransferred(adr);
99     }
100 
101     event OwnershipTransferred(address owner);
102 }
103 
104 interface IDEXFactory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IDEXRouter {
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111 
112     function addLiquidity(
113         address tokenA,
114         address tokenB,
115         uint amountADesired,
116         uint amountBDesired,
117         uint amountAMin,
118         uint amountBMin,
119         address to,
120         uint deadline
121     ) external returns (uint amountA, uint amountB, uint liquidity);
122 
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 
132     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 
140     function swapExactETHForTokensSupportingFeeOnTransferTokens(
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external payable;
146 
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154 }
155 
156 interface IDividendDistributor {
157     function setShare(address shareholder, uint256 amount) external;
158     function deposit(uint256 amount) external;
159     function claimDividend(address shareholder) external;
160     function getDividendsClaimedOf (address shareholder) external returns (uint256);
161 }
162 
163 contract DividendDistributor is IDividendDistributor {
164     using SafeMath for uint256;
165 
166     address public _token;
167     address public _owner;
168 
169     address public immutable USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7); //UNI
170 
171 
172     struct Share {
173         uint256 amount;
174         uint256 totalExcluded;
175         uint256 totalClaimed;
176     }
177 
178     address[] private shareholders;
179     mapping (address => uint256) private shareholderIndexes;
180 
181     mapping (address => Share) public shares;
182 
183     uint256 public totalShares;
184     uint256 public totalDividends;
185     uint256 public totalClaimed;
186     uint256 public dividendsPerShare;
187     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
188 
189     modifier onlyToken() {
190         require(msg.sender == _token); _;
191     }
192     
193     modifier onlyOwner() {
194         require(msg.sender == _owner); _;
195     }
196 
197     constructor (address owner) {
198         _token = msg.sender;
199         _owner = owner;
200     }
201 
202     receive() external payable { }
203 
204     function setShare(address shareholder, uint256 amount) external override onlyToken {
205         if(shares[shareholder].amount > 0){
206             distributeDividend(shareholder);
207         }
208 
209         if(amount > 0 && shares[shareholder].amount == 0){
210             addShareholder(shareholder);
211         }else if(amount == 0 && shares[shareholder].amount > 0){
212             removeShareholder(shareholder);
213         }
214 
215         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
216         shares[shareholder].amount = amount;
217         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
218     }
219 
220     function deposit(uint256 amount) external override onlyToken {
221         
222         if (amount > 0) {        
223             totalDividends = totalDividends.add(amount);
224             dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
225         }
226     }
227 
228     function distributeDividend(address shareholder) internal {
229         if(shares[shareholder].amount == 0){ return; }
230 
231         uint256 amount = getClaimableDividendOf(shareholder);
232         if(amount > 0){
233             totalClaimed = totalClaimed.add(amount);
234             shares[shareholder].totalClaimed = shares[shareholder].totalClaimed.add(amount);
235             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
236             IERC20(USDT).transfer(shareholder, amount);
237         }
238     }
239 
240     function claimDividend(address shareholder) external override onlyToken {
241         distributeDividend(shareholder);
242     }
243 
244     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
245         if(shares[shareholder].amount == 0){ return 0; }
246 
247         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
248         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
249 
250         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
251 
252         return shareholderTotalDividends.sub(shareholderTotalExcluded);
253     }
254 
255     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
256         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
257     }
258 
259     function addShareholder(address shareholder) internal {
260         shareholderIndexes[shareholder] = shareholders.length;
261         shareholders.push(shareholder);
262     }
263 
264     function removeShareholder(address shareholder) internal {
265         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
266         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
267         shareholders.pop();
268     }
269     
270     function manualSend(uint256 amount, address holder) external onlyOwner {
271         uint256 contractETHBalance = address(this).balance;
272         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
273     }
274 
275 
276     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
277         require (shares[shareholder].amount > 0, "You're not a PRINTER shareholder!");
278         return shares[shareholder].totalClaimed;
279     }
280 
281     }
282 
283 contract TheFederalReserve is IERC20, Auth {
284     using SafeMath for uint256;
285 
286     address private WETH;
287     address private DEAD = 0x000000000000000000000000000000000000dEaD;
288     address private ZERO = 0x0000000000000000000000000000000000000000;
289 
290     address public immutable USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7); //UNI
291 
292     string private constant  _name = "The Federal Reserve";
293     string private constant _symbol = "FED";
294     uint8 private constant _decimals = 9;
295 
296     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
297     uint256 private _maxTxAmountBuy = _totalSupply;
298     
299 
300     mapping (address => uint256) private _balances;
301     mapping (address => mapping (address => uint256)) private _allowances;
302     mapping (address => uint256) private cooldown;
303 
304     mapping (address => bool) private isFeeExempt;
305     mapping (address => bool) private isDividendExempt;
306     mapping (address => bool) private isBot;
307             
308     uint256 private totalFee = 9;
309     uint256 private feeDenominator = 100;
310 
311     address payable public marketingWallet = payable(0x77ece67AE192820c12797F8220af8c579079e857);
312 
313     IDEXRouter public router;
314     address public pair;
315 
316     uint256 public launchedAt;
317     bool private tradingOpen;
318     bool private buyLimit = true;
319     uint256 private maxBuy = 250000 * (10 ** _decimals);
320     uint256 public numTokensSellToAddToLiquidity = 250000 * 10**9;
321 
322     DividendDistributor private distributor;    
323     
324     bool public blacklistEnabled = false;
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
339         distributor = new DividendDistributor(_owner);
340 
341         isFeeExempt[_owner] = true;
342         isFeeExempt[marketingWallet] = true;             
343               
344         isDividendExempt[pair] = true;
345         isDividendExempt[address(this)] = true;
346         isDividendExempt[DEAD] = true;        
347 
348         _balances[_owner] = _totalSupply;
349     
350         emit Transfer(address(0), _owner, _totalSupply);
351     }
352 
353     receive() external payable { }
354 
355     function totalSupply() external view override returns (uint256) { return _totalSupply; }
356     function decimals() external pure override returns (uint8) { return _decimals; }
357     function symbol() external pure override returns (string memory) { return _symbol; }
358     function name() external pure override returns (string memory) { return _name; }
359     function getOwner() external view override returns (address) { return owner; }
360     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
361     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
362 
363     function approve(address spender, uint256 amount) public override returns (bool) {
364         _allowances[msg.sender][spender] = amount;
365         emit Approval(msg.sender, spender, amount);
366         return true;
367     }
368 
369     function approveMax(address spender) external returns (bool) {
370         return approve(spender, type(uint256).max);
371     }
372 
373     function transfer(address recipient, uint256 amount) external override returns (bool) {
374         return _transferFrom(msg.sender, recipient, amount);
375     }
376 
377     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
378         if(_allowances[sender][msg.sender] != type(uint256).max){
379             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
380         }
381 
382         return _transferFrom(sender, recipient, amount);
383     }
384 
385     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
386         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
387         if (blacklistEnabled) {
388             require (!isBot[sender] && !isBot[recipient], "Bot!");
389         }
390         if (buyLimit) { 
391             if (sender!=owner && recipient!= owner) require (amount<=maxBuy, "Too much sir");        
392         }
393 
394         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
395             require (cooldown[recipient] < block.timestamp);
396             cooldown[recipient] = block.timestamp + 60 seconds; 
397         }
398        
399         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
400 
401         uint256 contractTokenBalance = balanceOf(address(this));
402 
403         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
404     
405         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
406         if(shouldSwapBack){ swapBack(); }
407 
408         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
409 
410         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
411         
412         _balances[recipient] = _balances[recipient].add(amountReceived);
413 
414         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
415         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
416 
417         emit Transfer(sender, recipient, amountReceived);
418         return true;
419     }
420     
421     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
422         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
423         _balances[recipient] = _balances[recipient].add(amount);
424         emit Transfer(sender, recipient, amount);
425         return true;
426     }
427 
428  
429     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
430         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
431    }
432 
433     function takeFee(address sender, uint256 amount) internal returns (uint256) {
434         uint256 feeAmount;
435         feeAmount = amount.mul(totalFee).div(feeDenominator);
436         _balances[address(this)] = _balances[address(this)].add(feeAmount);
437         emit Transfer(sender, address(this), feeAmount);   
438 
439         return amount.sub(feeAmount);
440     }
441 
442    
443     function swapBack() internal swapping {
444 
445         uint256 amountToSwap = balanceOf(address(this));        
446 
447         swapTokensForEth(amountToSwap.div(2));
448         swapTokensForUSDT(amountToSwap.div(2));
449 
450         uint256 dividends = IERC20(USDT).balanceOf(address(this));
451 
452         bool success = IERC20(USDT).transfer(address(distributor), dividends);
453 
454         if (success) {
455             distributor.deposit(dividends);            
456         }
457              
458         payable(marketingWallet).transfer(address(this).balance);        
459     }
460     
461 
462     function swapTokensForUSDT(uint256 tokenAmount) private {
463 
464         address[] memory path = new address[](3);
465         path[0] = address(this);
466         path[1] = WETH;
467         path[2] = USDT;
468 
469         // make the swap
470         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
471             tokenAmount,
472             0,
473             path,
474             address(this),
475             block.timestamp
476         );
477     }
478 
479     function swapTokensForEth(uint256 tokenAmount) private {
480 
481         // generate the uniswap pair path of token -> weth
482         address[] memory path = new address[](2);
483         path[0] = address(this);
484         path[1] = WETH;
485 
486         // make the swap
487         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
488             tokenAmount,
489             0, // accept any amount of ETH
490             path,
491             address(this),
492             block.timestamp
493         );
494     }
495 
496     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
497         
498         // add the liquidity
499         router.addLiquidityETH{value: ethAmount}(
500             address(this),
501             tokenAmount,
502             0, // slippage is unavoidable
503             0, // slippage is unavoidable
504             owner,
505             block.timestamp
506         );
507     }
508 
509     
510     function openTrading() external onlyOwner {
511         launchedAt = block.number;
512         tradingOpen = true;
513     }    
514   
515     
516     function setBot(address _address, bool toggle) external onlyOwner {
517         isBot[_address] = toggle;
518         _setIsDividendExempt(_address, toggle);
519     }
520     
521     
522     function _setIsDividendExempt(address holder, bool exempt) internal {
523         require(holder != address(this) && holder != pair);
524         isDividendExempt[holder] = exempt;
525         if(exempt){
526             distributor.setShare(holder, 0);
527         }else{
528             distributor.setShare(holder, _balances[holder]);
529         }
530     }
531 
532     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
533         _setIsDividendExempt(holder, exempt);
534     }
535 
536     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
537         isFeeExempt[holder] = exempt;
538     }
539 
540     function setFee (uint256 _fee) external onlyOwner {
541         require (_fee <= 9, "Fee can't exceed 9%");
542         totalFee = _fee;
543     }
544   
545     function manualSend() external onlyOwner {
546         uint256 contractETHBalance = address(this).balance;
547         payable(marketingWallet).transfer(contractETHBalance);
548     }
549 
550     function claimDividend() external {
551         distributor.claimDividend(msg.sender);
552     }
553     
554     function claimDividend(address holder) external onlyOwner {
555         distributor.claimDividend(holder);
556     }
557     
558     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
559         return distributor.getClaimableDividendOf(shareholder);
560     }
561     
562     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
563         return _basicTransfer(address(this), DEAD, amount);
564     }
565     
566     function getCirculatingSupply() public view returns (uint256) {
567         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
568     }
569 
570     function setMarketingWallet(address _marketingWallet) external onlyOwner {
571         marketingWallet = payable(_marketingWallet);
572     } 
573 
574     function getTotalDividends() external view returns (uint256) {
575         return distributor.totalDividends();
576     }    
577 
578     function getTotalClaimed() external view returns (uint256) {
579         return distributor.totalClaimed();
580     }
581 
582      function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
583         return distributor.getDividendsClaimedOf(shareholder);
584     }
585 
586     function removeBuyLimit() external onlyOwner {
587         buyLimit = false;
588     }
589 
590     function checkBot(address account) public view returns (bool) {
591         return isBot[account];
592     }
593 
594     function setBlacklistEnabled() external onlyOwner {
595         require (blacklistEnabled == false, "can only be called once");
596         blacklistEnabled = true;
597     }
598 
599     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
600         require (amount <= _totalSupply.div(100), "can't exceed 1%");
601         numTokensSellToAddToLiquidity = amount * 10 ** 9;
602     } 
603    
604 }