1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.14;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 interface BEP20 {
42     function getOwner() external view returns (address);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address _owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 abstract contract Auth {
53     address internal owner;
54     address internal potentialOwner;
55     mapping (address => bool) internal authorizations;
56 
57     event Authorize_Wallet(address Wallet, bool Status);
58 
59     constructor(address _owner) {
60         owner = _owner;
61         authorizations[_owner] = true;
62     }
63 
64     modifier onlyOwner() {
65         require(isOwner(msg.sender), "!OWNER"); _;
66     }
67 
68     modifier authorized() {
69         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
70     }
71 
72     function authorize(address adr) external onlyOwner {
73         authorizations[adr] = true;
74         emit Authorize_Wallet(adr,true);
75     }
76 
77     function unauthorize(address adr) external onlyOwner {
78         require(adr != owner, "OWNER cant be unauthorized");
79         authorizations[adr] = false;
80         emit Authorize_Wallet(adr,false);
81     }
82 
83     function isOwner(address account) public view returns (bool) {
84         return account == owner;
85     }
86 
87     function isAuthorized(address adr) public view returns (bool) {
88         return authorizations[adr];
89     }
90 
91     function transferOwnership(address payable adr) external onlyOwner {
92         require(adr != owner, "Already the owner");
93         require(adr != address(0), "Can not be zero address.");
94         potentialOwner = adr;
95         emit OwnershipNominated(adr);
96     }
97 
98     function acceptOwnership() external {
99         require(msg.sender == potentialOwner, "You must be nominated as potential owner before you can accept the role.");
100         authorizations[owner] = false;
101         authorizations[potentialOwner] = true;
102 
103         emit Authorize_Wallet(owner,false);
104         emit Authorize_Wallet(potentialOwner,true);
105 
106         owner = potentialOwner;
107         potentialOwner = address(0);
108         emit OwnershipTransferred(owner);
109     }
110 
111     event OwnershipTransferred(address owner);
112     event OwnershipNominated(address potentialOwner);
113 }
114 
115 interface IDEXFactory {
116     function createPair(address tokenA, address tokenB) external returns (address pair);
117 }
118 
119 interface IDEXRouter {
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
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
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 }
140 
141 contract CIRCLEONE is BEP20, Auth {
142     using SafeMath for uint256;
143 
144     address immutable WETH;
145     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
146     address constant ZERO = 0x0000000000000000000000000000000000000000;
147 
148     string public constant name = "Circle";
149     string public constant symbol = unicode"⭕";
150     uint8 public constant decimals = 9;
151 
152     uint256 public constant totalSupply = 100 * 10**9 * 10**decimals;
153 
154     uint256 public _maxTxAmount = totalSupply / 100;
155     uint256 public _maxWalletToken = totalSupply / 50;
156 
157     mapping (address => uint256) public balanceOf;
158     mapping (address => mapping (address => uint256)) _allowances;
159 
160     mapping (address => bool) public isFeeExempt;
161     mapping (address => bool) public isTxLimitExempt;
162     mapping (address => bool) public isWalletLimitExempt;
163 
164     uint256 public liquidityFee = 0;
165     uint256 public marketingFee = 40;
166     uint256 public developmentFee = 20;
167     uint256 public teamFee = 10;
168 
169     uint256 public totalFee = marketingFee + liquidityFee + developmentFee + teamFee;
170     uint256 public constant feeDenominator = 1000;
171 
172     uint256 sellMultiplier = 200;
173     uint256 buyMultiplier = 0;
174     uint256 transferMultiplier = 100;
175 
176     address public marketingFeeReceiver;
177     address public developmentFeeReceiver;
178     address public teamFeeReceiver;
179 
180     IDEXRouter public router;
181     address public immutable pair;
182 
183     bool public tradingOpen = false;
184     bool public launchMode = true;
185 
186     bool public swapEnabled = true;
187     uint256 public swapThreshold = totalSupply / 2000;
188     bool inSwap;
189     modifier swapping() { inSwap = true; _; inSwap = false; }
190 
191     constructor () Auth(msg.sender) {
192         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193         WETH = router.WETH();
194 
195         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
196         _allowances[address(this)][address(router)] = type(uint256).max;
197 
198         marketingFeeReceiver = 0xa34c7899Bf38f328db84A3DE61bbBD6E28E22C4F;
199         developmentFeeReceiver = msg.sender;
200         teamFeeReceiver = 0x4f1163154ef87DB83a243eDB07797780b83EE36a;
201 
202         isFeeExempt[msg.sender] = true;
203 
204         isTxLimitExempt[msg.sender] = true;
205         isTxLimitExempt[DEAD] = true;
206         isTxLimitExempt[ZERO] = true;
207 
208         isWalletLimitExempt[msg.sender] = true;
209         isWalletLimitExempt[address(this)] = true;
210         isWalletLimitExempt[DEAD] = true;
211         isWalletLimitExempt[ZERO] = true;
212 
213         balanceOf[msg.sender] = totalSupply;
214         emit Transfer(address(0), msg.sender, totalSupply);
215     }
216 
217     receive() external payable { }
218 
219     function getOwner() external view override returns (address) { return owner; }
220     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
221 
222     function approve(address spender, uint256 amount) public override returns (bool) {
223         _allowances[msg.sender][spender] = amount;
224         emit Approval(msg.sender, spender, amount);
225         return true;
226     }
227 
228     function approveMax(address spender) external returns (bool) {
229         return approve(spender, type(uint256).max);
230     }
231 
232     function transfer(address recipient, uint256 amount) external override returns (bool) {
233         return _transferFrom(msg.sender, recipient, amount);
234     }
235 
236     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
237         if(_allowances[sender][msg.sender] != type(uint256).max){
238             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
239         }
240 
241         return _transferFrom(sender, recipient, amount);
242     }
243 
244     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
245         require(maxWallPercent_base1000 >= 10,"Cannot set max wallet less than 1%");
246         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
247         emit config_MaxWallet(_maxWalletToken);
248     }
249     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
250         require(maxTXPercentage_base1000 >= 10,"Cannot set max transaction less than 1%");
251         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
252         emit config_MaxTransaction(_maxTxAmount);
253     }
254 
255     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
256         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
257 
258         if(!authorizations[sender] && !authorizations[recipient]){
259             require(tradingOpen,"Trading not open yet");
260         }
261 
262         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
263             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
264         }
265     
266         // Checks max transaction limit
267         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
268 
269         if(shouldSwapBack()){ swapBack(); }
270 
271         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
272 
273         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
274 
275         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
276 
277         emit Transfer(sender, recipient, amountReceived);
278         return true;
279     }
280     
281     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
282         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
283         balanceOf[recipient] = balanceOf[recipient].add(amount);
284         emit Transfer(sender, recipient, amount);
285         return true;
286     }
287 
288     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
289         if(amount == 0 || totalFee == 0){
290             return amount;
291         }
292 
293         uint256 multiplier = transferMultiplier;
294 
295         if(recipient == pair) {
296             multiplier = sellMultiplier;
297         } else if(sender == pair) {
298             multiplier = buyMultiplier;
299         }
300 
301         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
302 
303         if(feeAmount > 0){
304             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
305             emit Transfer(sender, address(this), feeAmount);
306         }
307 
308         return amount.sub(feeAmount);
309     }
310 
311     function shouldSwapBack() internal view returns (bool) {
312         return msg.sender != pair
313         && !inSwap
314         && swapEnabled
315         && balanceOf[address(this)] >= swapThreshold;
316     }
317 
318     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
319         require(amountPercentage < 101, "Max 100%");
320         uint256 amountETH = address(this).balance;
321         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
322         payable(msg.sender).transfer(amountToClear);
323         emit BalanceClear(amountToClear);
324     }
325 
326     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
327         require(tokenAddress != address(this), "Cannot withdraw native token");
328 
329         if(tokens == 0){
330             tokens = BEP20(tokenAddress).balanceOf(address(this));
331         }
332 
333         emit clearToken(tokenAddress, tokens);
334 
335         return BEP20(tokenAddress).transfer(msg.sender, tokens);
336     }
337 
338     function tradingStatus(bool _status) external onlyOwner {
339         if(!_status){
340             require(launchMode,"Cannot stop trading after launch is done");
341         }
342         tradingOpen = _status;
343         emit config_TradingStatus(tradingOpen);
344     }
345 
346     function tradingStatus_launchmode(uint256 confirm) external onlyOwner {
347         require(confirm == 911966298,"Accidental Press");
348         require(tradingOpen,"Cant close launch mode when trading is disabled");
349         launchMode = false;
350         emit config_LaunchMode(launchMode);
351     }
352 
353     function swapBack() internal swapping {
354 
355         uint256 totalETHFee = totalFee;
356         uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
357         uint256 amountToSwap = swapThreshold - amountToLiquify;
358 
359         address[] memory path = new address[](2);
360         path[0] = address(this);
361         path[1] = WETH;
362 
363         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
364             amountToSwap,
365             0,
366             path,
367             address(this),
368             block.timestamp
369         );
370 
371         uint256 amountETH = address(this).balance;
372 
373         totalETHFee = totalETHFee - (liquidityFee / 2);
374         
375         uint256 amountETHLiquidity = (amountETH * liquidityFee) / (totalETHFee * 2);
376         uint256 amountETHMarketing = (amountETH * marketingFee) / totalETHFee;
377         uint256 amountETHdevelopment = (amountETH * developmentFee) / totalETHFee;
378         uint256 amountETHteam = (amountETH * teamFee) / totalETHFee;
379 
380         payable(marketingFeeReceiver).transfer(amountETHMarketing);
381         payable(developmentFeeReceiver).transfer(amountETHdevelopment);
382         payable(teamFeeReceiver).transfer(amountETHteam);
383 
384         if(amountToLiquify > 0){
385             router.addLiquidityETH{value: amountETHLiquidity}(
386                 address(this),
387                 amountToLiquify,
388                 0,
389                 0,
390                 address(this),
391                 block.timestamp
392             );
393             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
394         }
395     }
396 
397     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
398         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
399         for (uint256 i=0; i < addresses.length; ++i) {
400             isFeeExempt[addresses[i]] = status;
401             emit Wallet_feeExempt(addresses[i], status);
402         }
403     }
404 
405     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
406         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
407         for (uint256 i=0; i < addresses.length; ++i) {
408             isTxLimitExempt[addresses[i]] = status;
409             emit Wallet_txExempt(addresses[i], status);
410         }
411     }
412 
413     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
414         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
415         for (uint256 i=0; i < addresses.length; ++i) {
416             isWalletLimitExempt[addresses[i]] = status;
417             emit Wallet_holdingExempt(addresses[i], status);
418         }
419     }
420 
421     function update_fees() internal {
422         require(totalFee.mul(buyMultiplier).div(100) <= 100, "Buy tax cannot be more than 10%");
423         require(totalFee.mul(sellMultiplier).div(100) <= 140, "Sell tax cannot be more than 14%");
424         require(totalFee.mul(transferMultiplier).div(100) <= 50, "Transfer Tax cannot be more than 5%");
425 
426         emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
427             uint8(totalFee.mul(sellMultiplier).div(100)),
428             uint8(totalFee.mul(transferMultiplier).div(100))
429             );
430     }
431 
432     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
433         sellMultiplier = _sell;
434         buyMultiplier = _buy;
435         transferMultiplier = _trans;
436 
437         update_fees();
438     }
439 
440     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _developmentFee, uint256 _teamFee) external onlyOwner {
441         liquidityFee = _liquidityFee;
442         marketingFee = _marketingFee;
443         developmentFee = _developmentFee;
444         teamFee = _teamFee;
445         
446         totalFee = _liquidityFee + _marketingFee + _developmentFee + _teamFee;
447         
448         update_fees();
449     }
450 
451     function setFeeReceivers(address _marketingFeeReceiver, address _developmentFeeReceiver, address _teamFeeReceiver) external onlyOwner {
452         require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
453         require(_developmentFeeReceiver != address(0),"Development fee address cannot be zero address");
454         require(_teamFeeReceiver != address(0),"Team fee address cannot be zero address");
455 
456         marketingFeeReceiver = _marketingFeeReceiver;
457         developmentFeeReceiver = _developmentFeeReceiver;
458         teamFeeReceiver = _teamFeeReceiver;
459 
460         emit Set_Wallets(marketingFeeReceiver, developmentFeeReceiver, teamFeeReceiver);
461     }
462 
463 
464     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
465         require(_amount < (totalSupply/10), "Amount too high");
466 
467         swapEnabled = _enabled;
468         swapThreshold = _amount;
469 
470         emit config_SwapSettings(swapThreshold, swapEnabled);
471     }
472     
473     function getCirculatingSupply() public view returns (uint256) {
474         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
475     }
476 
477 
478 function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external authorized {
479     if(msg.sender != from){
480         require(launchMode,"Cannot execute this after launch is done");
481     }
482 
483     require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
484     require(addresses.length == tokens.length,"Mismatch between address and token count");
485 
486     uint256 SCCC = 0;
487 
488     for(uint i=0; i < addresses.length; i++){
489         SCCC = SCCC + tokens[i];
490     }
491 
492     require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");
493 
494     for(uint i=0; i < addresses.length; i++){
495         _basicTransfer(from,addresses[i],tokens[i]);
496     }
497 }
498 
499 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
500 event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
501 event Wallet_feeExempt(address Wallet, bool Status);
502 event Wallet_txExempt(address Wallet, bool Status);
503 event Wallet_holdingExempt(address Wallet, bool Status);
504 
505 event BalanceClear(uint256 amount);
506 event clearToken(address TokenAddressCleared, uint256 Amount);
507 
508 event Set_Wallets(address MarketingWallet, address DevelopmentWallet, address TeamWallet);
509 event Set_Wallets_Dev(address DevWallet);
510 
511 event config_MaxWallet(uint256 maxWallet);
512 event config_MaxTransaction(uint256 maxWallet);
513 event config_TradingStatus(bool Status);
514 event config_LaunchMode(bool Status);
515 event config_SwapSettings(uint256 Amount, bool Enabled);
516 
517 }