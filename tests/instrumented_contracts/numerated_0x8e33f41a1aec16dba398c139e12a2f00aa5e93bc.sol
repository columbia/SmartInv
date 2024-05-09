1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.15;
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
57     constructor(address _owner) {
58         owner = _owner;
59         authorizations[_owner] = true;
60     }
61 
62     modifier onlyOwner() {
63         require(isOwner(msg.sender), "!OWNER"); _;
64     }
65 
66     modifier authorized() {
67         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
68     }
69 
70     function authorize(address adr) external onlyOwner {
71         authorizations[adr] = true;
72         emit Authorize_Wallet(adr,true);
73     }
74 
75     function unauthorize(address adr) external onlyOwner {
76         require(adr != owner, "OWNER cant be unauthorized");
77         authorizations[adr] = false;
78         emit Authorize_Wallet(adr,false);
79     }
80 
81     function isOwner(address account) public view returns (bool) {
82         return account == owner;
83     }
84 
85     function isAuthorized(address adr) public view returns (bool) {
86         return authorizations[adr];
87     }
88 
89     function transferOwnership(address payable adr) external onlyOwner {
90         require(adr != owner, "Already the owner");
91         require(adr != address(0), "Can not be zero address.");
92         potentialOwner = adr;
93         emit OwnershipNominated(adr);
94     }
95 
96     function acceptOwnership() external {
97         require(msg.sender == potentialOwner, "You must be nominated as potential owner before you can accept the role.");
98         authorizations[owner] = false;
99         authorizations[potentialOwner] = true;
100 
101         emit Authorize_Wallet(owner,false);
102         emit Authorize_Wallet(potentialOwner,true);
103         
104         owner = potentialOwner;
105         potentialOwner = address(0);
106         emit OwnershipTransferred(owner);
107     }
108 
109     event OwnershipTransferred(address owner);
110     event OwnershipNominated(address potentialOwner);
111     event Authorize_Wallet(address Wallet, bool Status);
112 }
113 
114 interface IDEXFactory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IDEXRouter {
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
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
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
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
145 }
146 
147 contract SPOOKYHALLOWEENFLOKI is BEP20, Auth {
148     using SafeMath for uint256;
149 
150     address immutable WETH;
151     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
152     address constant ZERO = 0x0000000000000000000000000000000000000000;
153 
154     string public constant name = "Spooky Halloween Floki";
155     string public constant symbol = "SHF";
156     uint8 public constant decimals = 9;
157 
158     uint256 public constant totalSupply = 10 * 10**9 * 10**decimals;
159 
160     uint256 public _maxTxAmount = totalSupply / 100;
161     uint256 public _maxWalletToken = totalSupply * 2 / 100;
162 
163     mapping (address => uint256) public balanceOf;
164     mapping (address => mapping (address => uint256)) _allowances;
165 
166     mapping (address => bool) public isFeeExempt;
167     mapping (address => bool) public isTxLimitExempt;
168     mapping (address => bool) public isWalletLimitExempt;
169 
170     uint256 public liquidityFee = 0;
171     uint256 public marketingFee = 60;
172     uint256 public teamFee = 10;
173     uint256 public developmentFee = 0;
174     uint256 public burnFee = 0;
175     uint256 public totalFee = marketingFee + liquidityFee + teamFee + burnFee + developmentFee;
176     uint256 public constant feeDenominator = 1000;
177     
178     uint256 buyMultiplier = 100;
179     uint256 sellMultiplier = 100;
180     uint256 transferMultiplier = 100;
181 
182     address public marketingFeeReceiver;
183     address public teamFeeReceiver;
184     address public developmentFeeReceiver;
185 
186     IDEXRouter public router;
187     address public immutable pair;
188 
189     bool public tradingOpen = false;
190 
191     bool public swapEnabled = false;
192     uint256 public swapThreshold = totalSupply / 5000;
193     bool inSwap;
194     modifier swapping() { inSwap = true; _; inSwap = false; }
195 
196     constructor () Auth(msg.sender) {
197         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
198         WETH = router.WETH();
199 
200         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
201         _allowances[address(this)][address(router)] = type(uint256).max;
202 
203         marketingFeeReceiver = 0xc9550CF5389697c28d04e9A6ed3F0eF2838d749c;
204         developmentFeeReceiver = 0xc9550CF5389697c28d04e9A6ed3F0eF2838d749c;
205         teamFeeReceiver = 0x993Aeb30CB24F4664D0C8872e2dF03f18a07BFbd;
206 
207         isFeeExempt[msg.sender] = true;
208 
209         isTxLimitExempt[msg.sender] = true;
210         isTxLimitExempt[DEAD] = true;
211         isTxLimitExempt[ZERO] = true;
212 
213         isWalletLimitExempt[msg.sender] = true;
214         isWalletLimitExempt[address(this)] = true;
215         isWalletLimitExempt[DEAD] = true;
216 
217         balanceOf[msg.sender] = totalSupply;
218         emit Transfer(address(0), msg.sender, totalSupply);
219     }
220 
221     receive() external payable { }
222 
223     function getOwner() external view override returns (address) { return owner; }
224     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
225 
226     function approve(address spender, uint256 amount) public override returns (bool) {
227         _allowances[msg.sender][spender] = amount;
228         emit Approval(msg.sender, spender, amount);
229         return true;
230     }
231 
232     function approveMax(address spender) external returns (bool) {
233         return approve(spender, type(uint256).max);
234     }
235 
236     function transfer(address recipient, uint256 amount) external override returns (bool) {
237         return _transferFrom(msg.sender, recipient, amount);
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
241         if(_allowances[sender][msg.sender] != type(uint256).max){
242             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
243         }
244 
245         return _transferFrom(sender, recipient, amount);
246     }
247 
248     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
249         require(maxWallPercent_base1000 >= 5,"Cannot set max wallet less than 0.5%");
250         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
251         emit config_MaxWallet(_maxWalletToken);
252     }
253 
254     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
255         require(maxTXPercentage_base1000 >= 5,"Cannot set max transaction less than 0.5%");
256         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
257         emit config_MaxTransaction(_maxTxAmount);
258     }
259 
260     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
261         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
262 
263         if(!authorizations[sender] && !authorizations[recipient]){
264             require(tradingOpen,"Trading not open yet");
265         }
266 
267         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
268             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
269         }
270     
271         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
272 
273         if(shouldSwapBack()){ swapBack(); }
274 
275         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
276 
277         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
278 
279         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
280 
281         emit Transfer(sender, recipient, amountReceived);
282         return true;
283     }
284     
285     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
286         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
287         balanceOf[recipient] = balanceOf[recipient].add(amount);
288         emit Transfer(sender, recipient, amount);
289         return true;
290     }
291 
292     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
293         if(amount == 0 || totalFee == 0){
294             return amount;
295         }
296 
297         uint256 multiplier = transferMultiplier;
298 
299         if(recipient == pair) {
300             multiplier = sellMultiplier;
301         } else if(sender == pair) {
302             multiplier = buyMultiplier;
303         }
304 
305         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
306         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
307         uint256 contractTokens = feeAmount.sub(burnTokens);
308 
309         if(contractTokens > 0){
310             balanceOf[address(this)] = balanceOf[address(this)].add(contractTokens);
311             emit Transfer(sender, address(this), contractTokens);
312         }
313         
314         if(burnTokens > 0){
315             balanceOf[DEAD] = balanceOf[DEAD].add(burnTokens);
316             emit Transfer(sender, DEAD, burnTokens);    
317         }
318 
319         return amount.sub(feeAmount);
320     }
321 
322     function shouldSwapBack() internal view returns (bool) {
323         return msg.sender != pair
324         && !inSwap
325         && swapEnabled
326         && balanceOf[address(this)] >= swapThreshold;
327     }
328 
329     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
330         require(amountPercentage < 101, "Max 100%");
331         uint256 amountETH = address(this).balance;
332         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
333         payable(msg.sender).transfer(amountToClear);
334         emit BalanceClear(amountToClear);
335     }
336 
337     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
338         if(tokens == 0){
339             tokens = BEP20(tokenAddress).balanceOf(address(this));
340         }
341 
342         emit clearToken(tokenAddress, tokens);
343 
344         return BEP20(tokenAddress).transfer(msg.sender, tokens);
345     }
346 
347     function tradingOpem() external onlyOwner {
348         tradingOpen = true;
349         emit config_TradingStatus(tradingOpen);
350     }
351 
352     function swapBack() internal swapping {
353 
354         uint256 totalETHFee = totalFee - burnFee;
355 
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
377         uint256 amountETHTeam = (amountETH * teamFee) / totalETHFee;
378         uint256 amountETHDevelopment = (amountETH * developmentFee) / totalETHFee;
379 
380         payable(marketingFeeReceiver).transfer(amountETHMarketing);
381         payable(teamFeeReceiver).transfer(amountETHTeam);
382         payable(developmentFeeReceiver).transfer(amountETHDevelopment);
383 
384 
385         if(amountToLiquify > 0){
386             router.addLiquidityETH{value: amountETHLiquidity}(
387                 address(this),
388                 amountToLiquify,
389                 0,
390                 0,
391                 address(this),
392                 block.timestamp
393             );
394             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
395         }
396     }
397 
398     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
399         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
400         for (uint256 i=0; i < addresses.length; ++i) {
401             isFeeExempt[addresses[i]] = status;
402             emit Wallet_feeExempt(addresses[i], status);
403         }
404     }
405 
406     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
407         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
408         for (uint256 i=0; i < addresses.length; ++i) {
409             isTxLimitExempt[addresses[i]] = status;
410             emit Wallet_txExempt(addresses[i], status);
411         }
412     }
413 
414     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
415         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
416         for (uint256 i=0; i < addresses.length; ++i) {
417             isWalletLimitExempt[addresses[i]] = status;
418             emit Wallet_holdingExempt(addresses[i], status);
419         }
420     }
421 
422     function update_fees() internal {
423         require(totalFee.mul(buyMultiplier).div(100) <= 120, "Buy tax cannot be more than 12%");
424         require(totalFee.mul(sellMultiplier).div(100) <= 120, "Sell tax cannot be more than 12%");
425         require(totalFee.mul(transferMultiplier).div(100) <= 100, "Transfer Tax cannot be more than 10%");
426 
427         emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
428             uint8(totalFee.mul(sellMultiplier).div(100)),
429             uint8(totalFee.mul(transferMultiplier).div(100))
430             );
431     }
432 
433     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
434         sellMultiplier = _sell;
435         buyMultiplier = _buy;
436         transferMultiplier = _trans;
437 
438         update_fees();
439     }
440 
441     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _teamFee, uint256 _developmentFee, uint256 _burnFee) external onlyOwner {
442         liquidityFee = _liquidityFee;
443         marketingFee = _marketingFee;
444         teamFee = _teamFee;
445         developmentFee = _developmentFee;
446         burnFee = _burnFee;
447         totalFee = _liquidityFee + _marketingFee + _teamFee + _burnFee + _developmentFee;
448         
449         update_fees();
450     }
451 
452     function setFeeReceivers(address _marketingFeeReceiver, address _teamFeeReceiver, address _developmentFeeReceiver ) external onlyOwner {
453         require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
454         require(_teamFeeReceiver != address(0),"Team fee address cannot be zero address");
455         require(_developmentFeeReceiver != address(0),"Development fee address cannot be zero address");
456 
457         marketingFeeReceiver = _marketingFeeReceiver;
458         teamFeeReceiver = _teamFeeReceiver;
459         developmentFeeReceiver = _developmentFeeReceiver;
460 
461         emit Set_Wallets(marketingFeeReceiver, teamFeeReceiver, developmentFeeReceiver);
462     }
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
477     function distribute(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
478         address from = msg.sender;
479 
480         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
481         require(addresses.length == tokens.length,"Mismatch between address and token count");
482 
483         uint256 SCCC = 0;
484 
485         for(uint i=0; i < addresses.length; i++){
486             SCCC = SCCC + tokens[i];
487         }
488 
489         require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");
490 
491         for(uint i=0; i < addresses.length; i++){
492             _basicTransfer(from,addresses[i],tokens[i]);
493         }
494 
495     }
496 
497 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
498 event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
499 event Wallet_feeExempt(address Wallet, bool Status);
500 event Wallet_txExempt(address Wallet, bool Status);
501 event Wallet_holdingExempt(address Wallet, bool Status);
502 
503 event BalanceClear(uint256 amount);
504 event clearToken(address TokenAddressCleared, uint256 Amount);
505 
506 event Set_Wallets(address MarketingWallet, address TeamWallet, address DevelopmentWallet);
507 
508 event config_MaxWallet(uint256 maxWallet);
509 event config_MaxTransaction(uint256 maxWallet);
510 event config_TradingStatus(bool Status);
511 event config_SwapSettings(uint256 Amount, bool Enabled);
512 
513 }