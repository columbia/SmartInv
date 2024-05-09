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
91         potentialOwner = adr;
92         emit OwnershipNominated(adr);
93     }
94 
95     function renounceOwnership() external onlyOwner {
96         address adr = address(0);
97         potentialOwner = adr;
98         emit OwnershipNominated(adr);
99     }
100 
101     function acceptOwnership() external {
102         require(msg.sender == potentialOwner, "You must be nominated as potential owner before you can accept the role.");
103         authorizations[owner] = false;
104         authorizations[potentialOwner] = true;
105 
106         emit Authorize_Wallet(owner,false);
107         emit Authorize_Wallet(potentialOwner,true);
108         
109         owner = potentialOwner;
110         potentialOwner = address(0);
111         emit OwnershipTransferred(owner);
112     }
113 
114     event OwnershipTransferred(address owner);
115     event OwnershipNominated(address potentialOwner);
116     event Authorize_Wallet(address Wallet, bool Status);
117 }
118 
119 interface IDEXFactory {
120     function createPair(address tokenA, address tokenB) external returns (address pair);
121 }
122 
123 interface IDEXRouter {
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
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
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
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
150 }
151 
152 contract Rabbit2023 is BEP20, Auth {
153     using SafeMath for uint256;
154 
155     address immutable WETH;
156     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
157     address constant ZERO = 0x0000000000000000000000000000000000000000;
158 
159     string public constant name = "Rabbit2023";
160     string public constant symbol = "RABBIT";
161     uint8 public constant decimals = 9;
162 
163     uint256 public constant totalSupply = 10 * 10**9 * 10**decimals;
164 
165     mapping(address => bool) public isBlacklisted;
166 
167     // uint256 public _maxTxAmount = totalSupply / 100;
168     uint256 public _maxTxAmount = totalSupply * 1 / 100;
169     uint256 public _maxWalletToken = totalSupply * 1 / 100;
170 
171     mapping (address => uint256) public balanceOf;
172     mapping (address => mapping (address => uint256)) _allowances;
173 
174     mapping (address => bool) public isFeeExempt;
175     mapping (address => bool) public isTxLimitExempt;
176     mapping (address => bool) public isWalletLimitExempt;
177 
178     uint256 public liquidityFee = 10;
179     uint256 public marketingFee = 20;
180     uint256 public teamFee = 20;
181     uint256 public developmentFee = 0;
182     uint256 public burnFee = 0;
183     uint256 public totalFee = marketingFee + liquidityFee + teamFee + burnFee + developmentFee;
184     uint256 public constant feeDenominator = 1000;
185     
186     uint256 buyMultiplier = 100;
187     uint256 sellMultiplier = 100;
188     uint256 transferMultiplier = 100;
189 
190     address public marketingFeeReceiver;
191     address public teamFeeReceiver;
192     address public developmentFeeReceiver;
193 
194     IDEXRouter public router;
195     address public immutable pair;
196 
197     bool public tradingOpen = false;
198 
199     bool public swapEnabled = false;
200     uint256 public swapThreshold = totalSupply / 5000;
201     bool inSwap;
202     modifier swapping() { inSwap = true; _; inSwap = false; }
203 
204     constructor (address _marketingWallet, address _developmentWallet, address _teamWallet) Auth(msg.sender) {
205         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
206         WETH = router.WETH();
207 
208         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
209         _allowances[address(this)][address(router)] = type(uint256).max;
210 
211         marketingFeeReceiver = _marketingWallet;
212         developmentFeeReceiver = _developmentWallet;
213         teamFeeReceiver = _teamWallet;
214 
215         isFeeExempt[msg.sender] = true;
216 
217         isTxLimitExempt[msg.sender] = true;
218         isTxLimitExempt[DEAD] = true;
219         isTxLimitExempt[ZERO] = true;
220 
221         isWalletLimitExempt[msg.sender] = true;
222         isWalletLimitExempt[address(this)] = true;
223         isWalletLimitExempt[DEAD] = true;
224 
225         balanceOf[msg.sender] = totalSupply;
226         emit Transfer(address(0), msg.sender, totalSupply);
227     }
228 
229     receive() external payable { }
230 
231     function getOwner() external view override returns (address) { return owner; }
232     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
233 
234     function approve(address spender, uint256 amount) public override returns (bool) {
235         _allowances[msg.sender][spender] = amount;
236         emit Approval(msg.sender, spender, amount);
237         return true;
238     }
239 
240     function approveMax(address spender) external returns (bool) {
241         return approve(spender, type(uint256).max);
242     }
243 
244     function transfer(address recipient, uint256 amount) external override returns (bool) {
245         return _transferFrom(msg.sender, recipient, amount);
246     }
247 
248     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
249         if(_allowances[sender][msg.sender] != type(uint256).max){
250             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
251         }
252 
253         return _transferFrom(sender, recipient, amount);
254     }
255 
256     function blacklistAddress(address account, bool value) external onlyOwner{
257         isBlacklisted[account] = value;
258     }
259 
260     function bulkIsBlacklisted(address[] memory accounts, bool value) external onlyOwner{
261         for(uint256 i =0; i < accounts.length; i++){
262             isBlacklisted[accounts[i]] = value;
263 
264         }
265     }
266 
267     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
268         require(maxWallPercent_base1000 >= 5,"Cannot set max wallet less than 0.5%");
269         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
270         emit config_MaxWallet(_maxWalletToken);
271     }
272 
273     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
274         require(maxTXPercentage_base1000 >= 5,"Cannot set max transaction less than 0.5%");
275         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
276         emit config_MaxTransaction(_maxTxAmount);
277     }
278 
279     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
280         require(!isBlacklisted[sender] && !isBlacklisted[recipient], 'Blacklisted address');
281 
282         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
283 
284         if(!authorizations[sender] && !authorizations[recipient]){
285             require(tradingOpen,"Trading not open yet");
286         }
287 
288         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
289             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
290         }
291     
292         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
293 
294         if(shouldSwapBack()){ swapBack(); }
295 
296         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
297 
298         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
299 
300         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
301 
302         emit Transfer(sender, recipient, amountReceived);
303         return true;
304     }
305     
306     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
307         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
308         balanceOf[recipient] = balanceOf[recipient].add(amount);
309         emit Transfer(sender, recipient, amount);
310         return true;
311     }
312 
313     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
314         if(amount == 0 || totalFee == 0){
315             return amount;
316         }
317 
318         uint256 multiplier = transferMultiplier;
319 
320         if(recipient == pair) {
321             multiplier = sellMultiplier;
322         } else if(sender == pair) {
323             multiplier = buyMultiplier;
324         }
325 
326         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
327         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
328         uint256 contractTokens = feeAmount.sub(burnTokens);
329 
330         if(contractTokens > 0){
331             balanceOf[address(this)] = balanceOf[address(this)].add(contractTokens);
332             emit Transfer(sender, address(this), contractTokens);
333         }
334         
335         if(burnTokens > 0){
336             balanceOf[DEAD] = balanceOf[DEAD].add(burnTokens);
337             emit Transfer(sender, DEAD, burnTokens);    
338         }
339 
340         return amount.sub(feeAmount);
341     }
342 
343     function shouldSwapBack() internal view returns (bool) {
344         return msg.sender != pair
345         && !inSwap
346         && swapEnabled
347         && balanceOf[address(this)] >= swapThreshold;
348     }
349 
350     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
351         require(amountPercentage < 101, "Max 100%");
352         uint256 amountETH = address(this).balance;
353         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
354         payable(msg.sender).transfer(amountToClear);
355         emit BalanceClear(amountToClear);
356     }
357 
358     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
359         if(tokens == 0){
360             tokens = BEP20(tokenAddress).balanceOf(address(this));
361         }
362 
363         emit clearToken(tokenAddress, tokens);
364 
365         return BEP20(tokenAddress).transfer(msg.sender, tokens);
366     }
367 
368     function tradingOpenFlag() external onlyOwner {
369         tradingOpen = true;
370         emit config_TradingStatus(tradingOpen);
371     }
372 
373     function swapBack() internal swapping {
374 
375         uint256 totalETHFee = totalFee - burnFee;
376 
377         uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
378         uint256 amountToSwap = swapThreshold - amountToLiquify;
379 
380         address[] memory path = new address[](2);
381         path[0] = address(this);
382         path[1] = WETH;
383 
384         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
385             amountToSwap,
386             0,
387             path,
388             address(this),
389             block.timestamp
390         );
391 
392         uint256 amountETH = address(this).balance;
393 
394         totalETHFee = totalETHFee - (liquidityFee / 2);
395         
396         uint256 amountETHLiquidity = (amountETH * liquidityFee) / (totalETHFee * 2);
397         uint256 amountETHMarketing = (amountETH * marketingFee) / totalETHFee;
398         uint256 amountETHTeam = (amountETH * teamFee) / totalETHFee;
399         uint256 amountETHDevelopment = (amountETH * developmentFee) / totalETHFee;
400 
401         payable(marketingFeeReceiver).transfer(amountETHMarketing);
402         payable(teamFeeReceiver).transfer(amountETHTeam);
403         payable(developmentFeeReceiver).transfer(amountETHDevelopment);
404 
405 
406         if(amountToLiquify > 0){
407             router.addLiquidityETH{value: amountETHLiquidity}(
408                 address(this),
409                 amountToLiquify,
410                 0,
411                 0,
412                 address(this),
413                 block.timestamp
414             );
415             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
416         }
417     }
418 
419     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
420         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
421         for (uint256 i=0; i < addresses.length; ++i) {
422             isFeeExempt[addresses[i]] = status;
423             emit Wallet_feeExempt(addresses[i], status);
424         }
425     }
426 
427     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
428         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
429         for (uint256 i=0; i < addresses.length; ++i) {
430             isTxLimitExempt[addresses[i]] = status;
431             emit Wallet_txExempt(addresses[i], status);
432         }
433     }
434 
435     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
436         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
437         for (uint256 i=0; i < addresses.length; ++i) {
438             isWalletLimitExempt[addresses[i]] = status;
439             emit Wallet_holdingExempt(addresses[i], status);
440         }
441     }
442 
443     function update_fees() internal {
444         // require(totalFee.mul(buyMultiplier).div(100) <= 120, "Buy tax cannot be more than 12%");
445         // require(totalFee.mul(sellMultiplier).div(100) <= 120, "Sell tax cannot be more than 12%");
446         // require(totalFee.mul(transferMultiplier).div(100) <= 100, "Transfer Tax cannot be more than 10%");
447 
448         emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
449             uint8(totalFee.mul(sellMultiplier).div(100)),
450             uint8(totalFee.mul(transferMultiplier).div(100))
451             );
452     }
453 
454     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
455         sellMultiplier = _sell;
456         buyMultiplier = _buy;
457         transferMultiplier = _trans;
458 
459         update_fees();
460     }
461 
462     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _teamFee, uint256 _developmentFee, uint256 _burnFee) external onlyOwner {
463         liquidityFee = _liquidityFee;
464         marketingFee = _marketingFee;
465         teamFee = _teamFee;
466         developmentFee = _developmentFee;
467         burnFee = _burnFee;
468         totalFee = _liquidityFee + _marketingFee + _teamFee + _burnFee + _developmentFee;
469         
470         update_fees();
471     }
472 
473     function setFeeReceivers(address _marketingFeeReceiver, address _teamFeeReceiver, address _developmentFeeReceiver ) external onlyOwner {
474         // require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
475         // require(_teamFeeReceiver != address(0),"Team fee address cannot be zero address");
476         // require(_developmentFeeReceiver != address(0),"Development fee address cannot be zero address");
477 
478         marketingFeeReceiver = _marketingFeeReceiver;
479         teamFeeReceiver = _teamFeeReceiver;
480         developmentFeeReceiver = _developmentFeeReceiver;
481 
482         emit Set_Wallets(marketingFeeReceiver, teamFeeReceiver, developmentFeeReceiver);
483     }
484 
485     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
486         require(_amount < (totalSupply/10), "Amount too high");
487 
488         swapEnabled = _enabled;
489         swapThreshold = _amount;
490 
491         emit config_SwapSettings(swapThreshold, swapEnabled);
492     }
493 
494     function getCirculatingSupply() public view returns (uint256) {
495         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
496     }
497 
498     function distribute(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
499         address from = msg.sender;
500 
501         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
502         require(addresses.length == tokens.length,"Mismatch between address and token count");
503 
504         uint256 SCCC = 0;
505 
506         for(uint i=0; i < addresses.length; i++){
507             SCCC = SCCC + tokens[i];
508         }
509 
510         require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");
511 
512         for(uint i=0; i < addresses.length; i++){
513             _basicTransfer(from,addresses[i],tokens[i]);
514         }
515 
516     }
517 
518 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
519 event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
520 event Wallet_feeExempt(address Wallet, bool Status);
521 event Wallet_txExempt(address Wallet, bool Status);
522 event Wallet_holdingExempt(address Wallet, bool Status);
523 
524 event BalanceClear(uint256 amount);
525 event clearToken(address TokenAddressCleared, uint256 Amount);
526 
527 event Set_Wallets(address MarketingWallet, address TeamWallet, address DevelopmentWallet);
528 
529 event config_MaxWallet(uint256 maxWallet);
530 event config_MaxTransaction(uint256 maxWallet);
531 event config_TradingStatus(bool Status);
532 event config_SwapSettings(uint256 Amount, bool Enabled);
533 
534 }