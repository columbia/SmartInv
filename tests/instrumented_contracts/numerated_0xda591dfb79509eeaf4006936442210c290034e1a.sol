1 // Twitter: https://twitter.com/printthemong
2 // Telegram: https://t.me/PrintTheMong
3 
4 // SPDX-License-Identifier: Unlicensed
5 
6 pragma solidity 0.8.13;
7 
8 /**
9  * Standard SafeMath, stripped down to just add/sub/mul/div
10  */
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         // Solidity only automatically asserts when dividing by 0
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46         return c;
47     }
48 }
49 
50 /**
51  * ERC20 standard interface.
52  */
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function decimals() external view returns (uint8);
56     function symbol() external view returns (string memory);
57     function name() external view returns (string memory);
58     function getOwner() external view returns (address);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address _owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * Allows for contract ownership along with multi-address authorization
70  */
71 abstract contract Auth {
72     address internal owner;
73 
74     constructor(address _owner) {
75         owner = _owner;
76     }
77 
78     /**
79      * Function modifier to require caller to be contract deployer
80      */
81     modifier onlyOwner() {
82         require(isOwner(msg.sender), "!Owner"); _;
83     }
84 
85     /**
86      * Check if address is owner
87      */
88     function isOwner(address account) public view returns (bool) {
89         return account == owner;
90     }
91 
92     /**
93      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
94      */
95     function transferOwnership(address payable adr) public onlyOwner {
96         owner = adr;
97         emit OwnershipTransferred(adr);
98     }
99 
100     event OwnershipTransferred(address owner);
101 }
102 
103 interface IDEXFactory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IDEXRouter {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 
111     function addLiquidity(
112         address tokenA,
113         address tokenB,
114         uint amountADesired,
115         uint amountBDesired,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountA, uint amountB, uint liquidity);
121 
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 
139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external payable;
145 
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 }
154 
155 interface IDividendDistributor {
156     function setShare(address shareholder, uint256 amount) external;
157     function deposit(uint256 amount) external;
158     function claimDividend(address shareholder) external;
159     function getDividendsClaimedOf (address shareholder) external returns (uint256);
160 }
161 
162 contract DividendDistributor is IDividendDistributor {
163     using SafeMath for uint256;
164 
165     address public _token;
166     address public _owner;
167 
168     address public immutable MONG = address(0x1ce270557C1f68Cfb577b856766310Bf8B47FD9C); //UNI
169 
170 
171     struct Share {
172         uint256 amount;
173         uint256 totalExcluded;
174         uint256 totalClaimed;
175     }
176 
177     address[] private shareholders;
178     mapping (address => uint256) private shareholderIndexes;
179 
180     mapping (address => Share) public shares;
181 
182     uint256 public totalShares;
183     uint256 public totalDividends;
184     uint256 public totalClaimed;
185     uint256 public dividendsPerShare;
186     uint256 private dividendsPerShareAccuracyFactor = 10 ** 36;
187 
188     modifier onlyToken() {
189         require(msg.sender == _token); _;
190     }
191     
192     modifier onlyOwner() {
193         require(msg.sender == _owner); _;
194     }
195 
196     constructor (address owner) {
197         _token = msg.sender;
198         _owner = owner;
199     }
200 
201     receive() external payable { }
202 
203     function setShare(address shareholder, uint256 amount) external override onlyToken {
204         if(shares[shareholder].amount > 0){
205             distributeDividend(shareholder);
206         }
207 
208         if(amount > 0 && shares[shareholder].amount == 0){
209             addShareholder(shareholder);
210         }else if(amount == 0 && shares[shareholder].amount > 0){
211             removeShareholder(shareholder);
212         }
213 
214         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
215         shares[shareholder].amount = amount;
216         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
217     }
218 
219     function deposit(uint256 amount) external override onlyToken {
220         
221         if (amount > 0) {        
222             totalDividends = totalDividends.add(amount);
223             dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
224         }
225     }
226 
227     function distributeDividend(address shareholder) internal {
228         if(shares[shareholder].amount == 0){ return; }
229 
230         uint256 amount = getClaimableDividendOf(shareholder);
231         if(amount > 0){
232             totalClaimed = totalClaimed.add(amount);
233             shares[shareholder].totalClaimed = shares[shareholder].totalClaimed.add(amount);
234             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
235             IERC20(MONG).transfer(shareholder, amount);
236         }
237     }
238 
239     function claimDividend(address shareholder) external override onlyToken {
240         distributeDividend(shareholder);
241     }
242 
243     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
244         if(shares[shareholder].amount == 0){ return 0; }
245 
246         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
247         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
248 
249         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
250 
251         return shareholderTotalDividends.sub(shareholderTotalExcluded);
252     }
253 
254     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
255         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
256     }
257 
258     function addShareholder(address shareholder) internal {
259         shareholderIndexes[shareholder] = shareholders.length;
260         shareholders.push(shareholder);
261     }
262 
263     function removeShareholder(address shareholder) internal {
264         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
265         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
266         shareholders.pop();
267     }
268     
269     function manualSend(uint256 amount, address holder) external onlyOwner {
270         uint256 contractETHBalance = address(this).balance;
271         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
272     }
273 
274 
275     function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
276         require (shares[shareholder].amount > 0, "You're not a PRINTER shareholder!");
277         return shares[shareholder].totalClaimed;
278     }
279 
280     }
281 
282 contract PrintTheMONG is IERC20, Auth {
283     using SafeMath for uint256;
284 
285     address private WETH;
286     address private DEAD = 0x000000000000000000000000000000000000dEaD;
287     address private ZERO = 0x0000000000000000000000000000000000000000;
288 
289     address public immutable MONG = address(0x1ce270557C1f68Cfb577b856766310Bf8B47FD9C); //UNI
290 
291     string private constant  _name = "Print The Mong";
292     string private constant _symbol = "PM";
293     uint8 private constant _decimals = 9;
294 
295     uint256 private _totalSupply = 69696969 * (10 ** _decimals);
296     uint256 private _maxTxAmountBuy = _totalSupply;
297     
298 
299     mapping (address => uint256) private _balances;
300     mapping (address => mapping (address => uint256)) private _allowances;
301     mapping (address => uint256) private cooldown;
302 
303     mapping (address => bool) private isFeeExempt;
304     mapping (address => bool) private isDividendExempt;
305     mapping (address => bool) private isBot;
306             
307     uint256 private totalFee = 9;
308     uint256 private feeDenominator = 100;
309 
310     address payable public marketingWallet = payable(0xa74041fC0681FD1B00F24D2F1c89B3e346Ca561F);
311 
312     IDEXRouter public router;
313     address public pair;
314 
315     uint256 public launchedAt;
316     bool private tradingOpen;
317     bool private buyLimit = true;
318     uint256 private maxBuy = 1393939 * (10 ** _decimals);
319     uint256 public numTokensSellToAddToLiquidity = 139393 * 10**9;
320 
321     DividendDistributor private distributor;    
322     
323     bool public blacklistEnabled = false;
324     bool private inSwap;
325     modifier swapping() { inSwap = true; _; inSwap = false; }
326 
327     constructor (
328         address _owner        
329     ) Auth(_owner) {
330         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
331             
332         WETH = router.WETH();
333         
334         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
335         
336         _allowances[address(this)][address(router)] = type(uint256).max;
337 
338         distributor = new DividendDistributor(_owner);
339 
340         isFeeExempt[_owner] = true;
341         isFeeExempt[marketingWallet] = true;             
342               
343         isDividendExempt[pair] = true;
344         isDividendExempt[address(this)] = true;
345         isDividendExempt[DEAD] = true;        
346 
347         _balances[_owner] = _totalSupply;
348     
349         emit Transfer(address(0), _owner, _totalSupply);
350     }
351 
352     receive() external payable { }
353 
354     function totalSupply() external view override returns (uint256) { return _totalSupply; }
355     function decimals() external pure override returns (uint8) { return _decimals; }
356     function symbol() external pure override returns (string memory) { return _symbol; }
357     function name() external pure override returns (string memory) { return _name; }
358     function getOwner() external view override returns (address) { return owner; }
359     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
360     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
361 
362     function approve(address spender, uint256 amount) public override returns (bool) {
363         _allowances[msg.sender][spender] = amount;
364         emit Approval(msg.sender, spender, amount);
365         return true;
366     }
367 
368     function approveMax(address spender) external returns (bool) {
369         return approve(spender, type(uint256).max);
370     }
371 
372     function transfer(address recipient, uint256 amount) external override returns (bool) {
373         return _transferFrom(msg.sender, recipient, amount);
374     }
375 
376     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
377         if(_allowances[sender][msg.sender] != type(uint256).max){
378             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
379         }
380 
381         return _transferFrom(sender, recipient, amount);
382     }
383 
384     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
385         if (sender!= owner && recipient!= owner) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
386         if (blacklistEnabled) {
387             require (!isBot[sender] && !isBot[recipient], "Bot!");
388         }
389         if (buyLimit) { 
390             if (sender!=owner && recipient!= owner) require (amount<=maxBuy, "Too much sir");        
391         }
392 
393         if (sender == pair && recipient != address(router) && !isFeeExempt[recipient]) {
394             require (cooldown[recipient] < block.timestamp);
395             cooldown[recipient] = block.timestamp + 60 seconds; 
396         }
397        
398         if(inSwap){ return _basicTransfer(sender, recipient, amount); }      
399 
400         uint256 contractTokenBalance = balanceOf(address(this));
401 
402         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
403     
404         bool shouldSwapBack = (overMinTokenBalance && recipient==pair && balanceOf(address(this)) > 0);
405         if(shouldSwapBack){ swapBack(); }
406 
407         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
408 
409         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
410         
411         _balances[recipient] = _balances[recipient].add(amountReceived);
412 
413         if(sender != pair && !isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
414         if(recipient != pair && !isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
415 
416         emit Transfer(sender, recipient, amountReceived);
417         return true;
418     }
419     
420     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
421         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
422         _balances[recipient] = _balances[recipient].add(amount);
423         emit Transfer(sender, recipient, amount);
424         return true;
425     }
426 
427  
428     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
429         return ( !(isFeeExempt[sender] || isFeeExempt[recipient]) &&  (sender == pair || recipient == pair) );
430    }
431 
432     function takeFee(address sender, uint256 amount) internal returns (uint256) {
433         uint256 feeAmount;
434         feeAmount = amount.mul(totalFee).div(feeDenominator);
435         _balances[address(this)] = _balances[address(this)].add(feeAmount);
436         emit Transfer(sender, address(this), feeAmount);   
437 
438         return amount.sub(feeAmount);
439     }
440 
441    
442     function swapBack() internal swapping {
443 
444         uint256 amountToSwap = balanceOf(address(this));        
445 
446         swapTokensForEth(amountToSwap.div(2));
447         swapTokensForMONG(amountToSwap.div(2));
448 
449         uint256 dividends = IERC20(MONG).balanceOf(address(this));
450 
451         bool success = IERC20(MONG).transfer(address(distributor), dividends);
452 
453         if (success) {
454             distributor.deposit(dividends);            
455         }
456              
457         payable(marketingWallet).transfer(address(this).balance);        
458     }
459     
460 
461     function swapTokensForMONG(uint256 tokenAmount) private {
462 
463         address[] memory path = new address[](3);
464         path[0] = address(this);
465         path[1] = WETH;
466         path[2] = MONG;
467 
468         // make the swap
469         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
470             tokenAmount,
471             0,
472             path,
473             address(this),
474             block.timestamp
475         );
476     }
477 
478     function swapTokensForEth(uint256 tokenAmount) private {
479 
480         // generate the uniswap pair path of token -> weth
481         address[] memory path = new address[](2);
482         path[0] = address(this);
483         path[1] = WETH;
484 
485         // make the swap
486         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
487             tokenAmount,
488             0, // accept any amount of ETH
489             path,
490             address(this),
491             block.timestamp
492         );
493     }
494 
495     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
496         
497         // add the liquidity
498         router.addLiquidityETH{value: ethAmount}(
499             address(this),
500             tokenAmount,
501             0, // slippage is unavoidable
502             0, // slippage is unavoidable
503             owner,
504             block.timestamp
505         );
506     }
507 
508     
509     function openTrading() external onlyOwner {
510         launchedAt = block.number;
511         tradingOpen = true;
512     }    
513   
514     
515     function setBot(address _address, bool toggle) external onlyOwner {
516         isBot[_address] = toggle;
517         _setIsDividendExempt(_address, toggle);
518     }
519     
520     
521     function _setIsDividendExempt(address holder, bool exempt) internal {
522         require(holder != address(this) && holder != pair);
523         isDividendExempt[holder] = exempt;
524         if(exempt){
525             distributor.setShare(holder, 0);
526         }else{
527             distributor.setShare(holder, _balances[holder]);
528         }
529     }
530 
531     function setIsDividendExempt(address holder, bool exempt) external onlyOwner {
532         _setIsDividendExempt(holder, exempt);
533     }
534 
535     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
536         isFeeExempt[holder] = exempt;
537     }
538 
539     function setFee (uint256 _fee) external onlyOwner {
540         require (_fee <= 9, "Fee can't exceed 9%");
541         totalFee = _fee;
542     }
543   
544     function manualSend() external onlyOwner {
545         uint256 contractETHBalance = address(this).balance;
546         payable(marketingWallet).transfer(contractETHBalance);
547     }
548 
549     function claimDividend() external {
550         distributor.claimDividend(msg.sender);
551     }
552     
553     function claimDividend(address holder) external onlyOwner {
554         distributor.claimDividend(holder);
555     }
556     
557     function getClaimableDividendOf(address shareholder) public view returns (uint256) {
558         return distributor.getClaimableDividendOf(shareholder);
559     }
560     
561     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
562         return _basicTransfer(address(this), DEAD, amount);
563     }
564     
565     function getCirculatingSupply() public view returns (uint256) {
566         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
567     }
568 
569     function setMarketingWallet(address _marketingWallet) external onlyOwner {
570         marketingWallet = payable(_marketingWallet);
571     } 
572 
573     function getTotalDividends() external view returns (uint256) {
574         return distributor.totalDividends();
575     }    
576 
577     function getTotalClaimed() external view returns (uint256) {
578         return distributor.totalClaimed();
579     }
580 
581      function getDividendsClaimedOf (address shareholder) external view returns (uint256) {
582         return distributor.getDividendsClaimedOf(shareholder);
583     }
584 
585     function removeBuyLimit() external onlyOwner {
586         buyLimit = false;
587     }
588 
589     function checkBot(address account) public view returns (bool) {
590         return isBot[account];
591     }
592 
593     function setBlacklistEnabled() external onlyOwner {
594         require (blacklistEnabled == false, "can only be called once");
595         blacklistEnabled = true;
596     }
597 
598     function setSwapThresholdAmount (uint256 amount) external onlyOwner {
599         require (amount <= _totalSupply.div(100), "can't exceed 1%");
600         numTokensSellToAddToLiquidity = amount * 10 ** 9;
601     } 
602    
603 }