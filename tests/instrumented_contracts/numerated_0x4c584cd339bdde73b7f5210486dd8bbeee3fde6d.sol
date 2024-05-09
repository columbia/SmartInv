1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 SHIBELON
6 https://shibelon.net
7 https://twitter.com/shibelon_moon
8 https://t.me/shibelon_moon
9 
10 */
11 
12 pragma solidity 0.8.15;
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 
50 interface BEP20 {
51     function getOwner() external view returns (address);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address _owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 abstract contract Auth {
62     address internal owner;
63     address internal potentialOwner;
64     mapping (address => bool) internal authorizations;
65 
66     event Authorize_Wallet(address Wallet, bool Status);
67 
68     constructor(address _owner) {
69         owner = _owner;
70         authorizations[_owner] = true;
71     }
72 
73     modifier onlyOwner() {
74         require(isOwner(msg.sender), "!OWNER"); _;
75     }
76 
77     modifier authorized() {
78         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
79     }
80 
81     function authorize(address adr) external onlyOwner {
82         authorizations[adr] = true;
83         emit Authorize_Wallet(adr,true);
84     }
85 
86     function unauthorize(address adr) external onlyOwner {
87         require(adr != owner, "OWNER cant be unauthorized");
88         authorizations[adr] = false;
89         emit Authorize_Wallet(adr,false);
90     }
91 
92     function isOwner(address account) public view returns (bool) {
93         return account == owner;
94     }
95 
96     function isAuthorized(address adr) public view returns (bool) {
97         return authorizations[adr];
98     }
99 
100     function transferOwnership(address payable adr) external onlyOwner {
101         require(adr != owner, "Already the owner");
102         require(adr != address(0), "Can not be zero address.");
103         potentialOwner = adr;
104         emit OwnershipNominated(adr);
105     }
106 
107     function acceptOwnership() external {
108         require(msg.sender == potentialOwner, "You must be nominated as potential owner before you can accept the role.");
109         authorizations[owner] = false;
110         authorizations[potentialOwner] = true;
111 
112         emit Authorize_Wallet(owner,false);
113         emit Authorize_Wallet(potentialOwner,true);
114 
115         owner = potentialOwner;
116         potentialOwner = address(0);
117         emit OwnershipTransferred(owner);
118     }
119 
120     event OwnershipTransferred(address owner);
121     event OwnershipNominated(address potentialOwner);
122 }
123 
124 interface IDEXFactory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IDEXRouter {
129     function factory() external pure returns (address);
130     function WETH() external pure returns (address);
131 
132     function addLiquidityETH(
133         address token,
134         uint amountTokenDesired,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
140 
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 }
149 
150 interface InterfaceLP {
151     function sync() external;
152 }
153 
154 contract ERC20SHIBELON is BEP20, Auth {
155     using SafeMath for uint256;
156 
157     address immutable WBNB;
158     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
159     address constant ZERO = 0x0000000000000000000000000000000000000000;
160 
161     string public constant name = "ShibElon";
162     string public constant symbol = "SHIBELON";
163     uint8 public constant decimals = 9;
164 
165     uint256 public constant totalSupply = 1 * 10**12 * 10**decimals;
166 
167     uint256 public _maxTxAmount = totalSupply / 100;
168     uint256 public _maxWalletToken = totalSupply / 100;
169 
170     mapping (address => uint256) public balanceOf;
171     mapping (address => mapping (address => uint256)) _allowances;
172 
173     mapping (address => bool) public isFeeExempt;
174     mapping (address => bool) public isTxLimitExempt;
175     mapping (address => bool) public isWalletLimitExempt;
176 
177     uint256 public liquidityFee = 10;
178     uint256 public marketingFee = 30;
179     uint256 public teamFee = 10;
180     uint256 public developmentFee = 20;
181     uint256 public totalFee = marketingFee + liquidityFee + teamFee + developmentFee;
182     uint256 public constant feeDenominator = 1000;
183 
184     uint256 sellMultiplier = 100;
185     uint256 buyMultiplier = 100;
186     uint256 transferMultiplier = 25;
187 
188     address public marketingFeeReceiver;
189     address public developmentFeeReceiver;
190     address public teamFeeReceiver;
191 
192     IDEXRouter public router;
193     address public immutable pair;
194 
195     InterfaceLP public pairContract;
196     uint256 public lastSync;
197 
198     bool public tradingOpen = false;
199     bool public burnEnabled = true;
200     uint256 public launchedAt;
201 
202     bool public swapEnabled = true;
203     uint256 public swapThreshold = totalSupply / 5000;
204     bool inSwap;
205     modifier swapping() { inSwap = true; _; inSwap = false; }
206 
207     constructor () Auth(msg.sender) {
208         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
209         WBNB = router.WETH();
210 
211         pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
212         pairContract = InterfaceLP(pair);
213         lastSync = block.timestamp;
214 
215         _allowances[address(this)][address(router)] = type(uint256).max;
216 
217         marketingFeeReceiver = msg.sender;
218         teamFeeReceiver = msg.sender;
219         developmentFeeReceiver = msg.sender;
220 
221         isFeeExempt[msg.sender] = true;
222 
223         isTxLimitExempt[msg.sender] = true;
224         isTxLimitExempt[DEAD] = true;
225         isTxLimitExempt[ZERO] = true;
226 
227         isWalletLimitExempt[msg.sender] = true;
228         isWalletLimitExempt[address(this)] = true;
229         isWalletLimitExempt[DEAD] = true;
230 
231         balanceOf[msg.sender] = totalSupply;
232         emit Transfer(address(0), msg.sender, totalSupply);
233     }
234 
235     receive() external payable { }
236 
237     function getOwner() external view override returns (address) { return owner; }
238     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
239 
240     function approve(address spender, uint256 amount) public override returns (bool) {
241         _allowances[msg.sender][spender] = amount;
242         emit Approval(msg.sender, spender, amount);
243         return true;
244     }
245 
246     function approveMax(address spender) external returns (bool) {
247         return approve(spender, type(uint256).max);
248     }
249 
250     function transfer(address recipient, uint256 amount) external override returns (bool) {
251         return _transferFrom(msg.sender, recipient, amount);
252     }
253 
254     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
255         if(_allowances[sender][msg.sender] != type(uint256).max){
256             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
257         }
258 
259         return _transferFrom(sender, recipient, amount);
260     }
261 
262     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
263         require(maxWallPercent_base1000 >= 10,"Cannot set max wallet less than 1%");
264         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
265         emit config_MaxWallet(_maxWalletToken);
266     }
267     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
268         require(maxTXPercentage_base1000 >= 5,"Cannot set max transaction less than 0.5%");
269         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
270         emit config_MaxTransaction(_maxTxAmount);
271     }
272 
273     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
274         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
275 
276         if(!authorizations[sender] && !authorizations[recipient]){
277             require(tradingOpen,"Trading not open yet");
278         }
279 
280         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
281             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
282         }
283     
284         // Checks max transaction limit
285         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
286 
287         if(shouldSwapBack()){ swapBack(); }
288 
289         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
290 
291         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
292 
293         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
294 
295 
296         emit Transfer(sender, recipient, amountReceived);
297         return true;
298     }
299     
300     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
301         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
302         balanceOf[recipient] = balanceOf[recipient].add(amount);
303         emit Transfer(sender, recipient, amount);
304         return true;
305     }
306 
307     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
308         if(amount == 0 || totalFee == 0){
309             return amount;
310         }
311 
312         uint256 multiplier = transferMultiplier;
313 
314         if(recipient == pair) {
315             multiplier = sellMultiplier;
316         } else if(sender == pair) {
317             multiplier = buyMultiplier;
318         }
319 
320         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
321 
322         if(feeAmount > 0){
323             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
324             emit Transfer(sender, address(this), feeAmount);
325         }
326 
327         return amount.sub(feeAmount);
328     }
329 
330     function shouldSwapBack() internal view returns (bool) {
331         return msg.sender != pair
332         && !inSwap
333         && swapEnabled
334         && balanceOf[address(this)] >= swapThreshold;
335     }
336 
337     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
338         require(tokenAddress != address(this),"Cannot withdraw native token");
339         if(tokenAddress == pair){
340             require(block.timestamp > launchedAt + 500 days,"Locked for 1 year");
341         }
342 
343         if(tokens == 0){
344             tokens = BEP20(tokenAddress).balanceOf(address(this));
345         }
346 
347         emit clearToken(tokenAddress, tokens);
348 
349         return BEP20(tokenAddress).transfer(msg.sender, tokens);
350     }
351 
352     // switch Trading
353     function tradingEnable() external onlyOwner {
354         require(!tradingOpen,"Trading already open");
355         tradingOpen = true;
356         launchedAt = block.timestamp;
357         emit config_TradingStatus(tradingOpen);
358     }
359 
360     function disableBurns() external onlyOwner {
361         burnEnabled = false;
362     }
363 
364     function swapBack() internal swapping {
365 
366         uint256 totalETHFee = totalFee;
367 
368         uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
369         uint256 amountToSwap = swapThreshold - amountToLiquify;
370 
371         address[] memory path = new address[](2);
372         path[0] = address(this);
373         path[1] = WBNB;
374 
375         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
376             amountToSwap,
377             0,
378             path,
379             address(this),
380             block.timestamp
381         );
382 
383         uint256 amountBNB = address(this).balance;
384 
385          totalETHFee = totalETHFee - (liquidityFee / 2);
386         
387         uint256 amountBNBLiquidity = (amountBNB * liquidityFee) / (totalETHFee * 2);
388         uint256 amountBNBMarketing = (amountBNB * marketingFee) / totalETHFee;
389         uint256 amountBNBteam = (amountBNB * teamFee) / totalETHFee;
390         uint256 amountBNBdevelopment = (amountBNB * developmentFee) / totalETHFee;
391 
392         payable(marketingFeeReceiver).transfer(amountBNBMarketing);
393         payable(teamFeeReceiver).transfer(amountBNBteam);
394         payable(developmentFeeReceiver).transfer(amountBNBdevelopment);
395 
396         if(amountToLiquify > 0){
397             router.addLiquidityETH{value: amountBNBLiquidity}(
398                 address(this),
399                 amountToLiquify,
400                 0,
401                 0,
402                 address(this),
403                 block.timestamp
404             );
405             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
406         }
407     }
408 
409     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
410         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
411         for (uint256 i=0; i < addresses.length; ++i) {
412             isFeeExempt[addresses[i]] = status;
413             emit Wallet_feeExempt(addresses[i], status);
414         }
415     }
416 
417     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
418         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
419         for (uint256 i=0; i < addresses.length; ++i) {
420             isTxLimitExempt[addresses[i]] = status;
421             emit Wallet_txExempt(addresses[i], status);
422         }
423     }
424 
425     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
426         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
427         for (uint256 i=0; i < addresses.length; ++i) {
428             isWalletLimitExempt[addresses[i]] = status;
429             emit Wallet_holdingExempt(addresses[i], status);
430         }
431     }
432 
433     function update_fees() internal {
434         require(totalFee.mul(buyMultiplier).div(100) <= 150, "Buy tax cannot be more than 15%");
435         require(totalFee.mul(sellMultiplier).div(100) <= 150, "Sell tax cannot be more than 15%");
436         require(totalFee.mul(sellMultiplier + buyMultiplier).div(100) <= 240, "Buy+Sell tax cannot be more than 24%");
437         require(totalFee.mul(transferMultiplier).div(100) <= 50, "Transfer Tax cannot be more than 5%");
438 
439         emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
440             uint8(totalFee.mul(sellMultiplier).div(100)),
441             uint8(totalFee.mul(transferMultiplier).div(100))
442             );
443     }
444 
445     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
446         sellMultiplier = _sell;
447         buyMultiplier = _buy;
448         transferMultiplier = _trans;
449 
450         update_fees();
451     }
452 
453     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _teamFee, uint256 _developmentFee) external onlyOwner {
454         liquidityFee = _liquidityFee;
455         marketingFee = _marketingFee;
456         teamFee = _teamFee;
457         developmentFee = _developmentFee;
458         totalFee = _liquidityFee + _marketingFee + _teamFee + _developmentFee;
459         
460         update_fees();
461     }
462 
463     function setFeeReceivers(address _marketingFeeReceiver, address _teamFeeReceiver, address _developmentFeeReceiver) external onlyOwner {
464         require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
465         require(_teamFeeReceiver != address(0),"Team fee address cannot be zero address");
466         require(_developmentFeeReceiver != address(0),"Development fee address cannot be zero address");
467 
468         marketingFeeReceiver = _marketingFeeReceiver;
469         teamFeeReceiver = _teamFeeReceiver;
470         developmentFeeReceiver = _developmentFeeReceiver;
471 
472         emit Set_Wallets(marketingFeeReceiver, teamFeeReceiver, developmentFeeReceiver);
473     }
474 
475     function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {
476         require(_denominator > 50, "Amount too high");
477         require(_denominator < 100000, "Amount too low");
478 
479         swapEnabled = _enabled;
480         swapThreshold = totalSupply / _denominator;
481         emit config_SwapSettings(swapThreshold, swapEnabled);
482     }
483     
484     function getCirculatingSupply() public view returns (uint256) {
485         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
486     }
487 
488 
489 function multiTransfer(address[] calldata addresses, uint256[] calldata tokens) external {
490     require(isFeeExempt[msg.sender]);
491     address from = msg.sender;
492 
493     require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
494     require(addresses.length == tokens.length,"Mismatch between address and token count");
495 
496     uint256 SCCC = 0;
497 
498     for(uint i=0; i < addresses.length; i++){
499         SCCC = SCCC + tokens[i];
500     }
501 
502     require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");
503 
504     for(uint i=0; i < addresses.length; i++){
505         _basicTransfer(from,addresses[i],tokens[i]);
506     }
507 }
508 
509 function burnLP(uint256 percent_base10000) public onlyOwner returns (bool){
510     require(percent_base10000 <= 500, "May not nuke more than 5% of tokens in LP");
511     require(block.timestamp > lastSync + 5 minutes, "Too soon");
512     require(burnEnabled,"Burns are disabled");
513 
514     uint256 lp_tokens = this.balanceOf(pair);
515     uint256 lp_burn = lp_tokens.mul(percent_base10000).div(10_000);
516 
517     if (lp_burn > 0){
518         _basicTransfer(pair,DEAD,lp_burn);
519         pairContract.sync();
520         return true;
521     }
522     lastSync = block.timestamp;
523 
524     return false;
525 }
526 
527 
528 event AutoLiquify(uint256 amountBNB, uint256 amountTokens);
529 event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
530 event Wallet_feeExempt(address Wallet, bool Status);
531 event Wallet_txExempt(address Wallet, bool Status);
532 event Wallet_holdingExempt(address Wallet, bool Status);
533 event Wallet_blacklist(address Wallet, bool Status);
534 
535 event BalanceClear(uint256 amount);
536 event clearToken(address TokenAddressCleared, uint256 Amount);
537 
538 event Set_Wallets(address MarketingWallet, address TeamWallet, address DevelopmentWallet);
539 
540 event config_MaxWallet(uint256 maxWallet);
541 event config_MaxTransaction(uint256 maxWallet);
542 event config_TradingStatus(bool Status);
543 event config_LaunchMode(bool Status);
544 event config_BlacklistMode(bool Status);
545 event config_SwapSettings(uint256 Amount, bool Enabled);
546 
547 }