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
141 contract FLOKIMARVINPALS is BEP20, Auth {
142     using SafeMath for uint256;
143 
144     address immutable WETH;
145     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
146     address constant ZERO = 0x0000000000000000000000000000000000000000;
147 
148     string public constant name = "FlokiMarvin $Pals";
149     string public constant symbol = "$PALS";
150     uint8 public constant decimals = 8;
151 
152     uint256 public constant totalSupply = 1 * 10**9 * 10**decimals;
153 
154     uint256 public _maxTxAmount = totalSupply / 50;
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
165     uint256 public marketingFee = 30;
166     uint256 public developmentFee = 30;
167     uint256 public devFee = 10;
168 
169     uint256 public totalFee = marketingFee + liquidityFee + developmentFee + devFee;
170     uint256 public constant feeDenominator = 1000;
171 
172     uint256 sellMultiplier = 100;
173     uint256 buyMultiplier = 100;
174     uint256 transferMultiplier = 100;
175 
176     address public marketingFeeReceiver;
177     address public developmentFeeReceiver;
178     address public devFeeReceiver;
179 
180     IDEXRouter public router;
181     address public immutable pair;
182 
183     bool public tradingOpen = false;
184     bool public antibot = true;
185     bool public launchMode = true;
186 
187     bool public swapEnabled = false;
188     uint256 public swapThreshold = totalSupply / 1000;
189     bool inSwap;
190     modifier swapping() { inSwap = true; _; inSwap = false; }
191 
192     constructor () Auth(msg.sender) {
193         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
194         WETH = router.WETH();
195 
196         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
197         _allowances[address(this)][address(router)] = type(uint256).max;
198 
199         marketingFeeReceiver = 0xFE955780A2db445592F315BDF171eD6DAda3B663;
200         developmentFeeReceiver = 0x2Fe4F45EF79641140FB6A2B5d547EC68d9d7bA7d;
201         devFeeReceiver = 0x277BdadF7A82Ab1a9C5Cac664abfdF748aFF3486;
202 
203         isFeeExempt[msg.sender] = true;
204 
205         isTxLimitExempt[msg.sender] = true;
206         isTxLimitExempt[DEAD] = true;
207         isTxLimitExempt[ZERO] = true;
208 
209         isWalletLimitExempt[msg.sender] = true;
210         isWalletLimitExempt[address(this)] = true;
211         isWalletLimitExempt[DEAD] = true;
212         isWalletLimitExempt[ZERO] = true;
213 
214         balanceOf[msg.sender] = totalSupply;
215         emit Transfer(address(0), msg.sender, totalSupply);
216     }
217 
218     receive() external payable { }
219 
220     function getOwner() external view override returns (address) { return owner; }
221     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
222 
223     function approve(address spender, uint256 amount) public override returns (bool) {
224         _allowances[msg.sender][spender] = amount;
225         emit Approval(msg.sender, spender, amount);
226         return true;
227     }
228 
229     function approveMax(address spender) external returns (bool) {
230         return approve(spender, type(uint256).max);
231     }
232 
233     function transfer(address recipient, uint256 amount) external override returns (bool) {
234         return _transferFrom(msg.sender, recipient, amount);
235     }
236 
237     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
238         if(_allowances[sender][msg.sender] != type(uint256).max){
239             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
240         }
241 
242         return _transferFrom(sender, recipient, amount);
243     }
244 
245     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
246         require(maxWallPercent_base1000 >= 1,"Cannot set max wallet less than 0.1%");
247         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
248         emit config_MaxWallet(_maxWalletToken);
249     }
250     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
251         require(maxTXPercentage_base1000 >= 1,"Cannot set max transaction less than 0.1%");
252         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
253         emit config_MaxTransaction(_maxTxAmount);
254     }
255 
256     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
257         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
258 
259         if(!authorizations[sender] && !authorizations[recipient]){
260             require(tradingOpen,"Trading not open yet");
261         }
262 
263         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
264             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
265         }
266     
267         // Checks max transaction limit
268         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
269 
270         if(shouldSwapBack()){ swapBack(); }
271 
272         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
273 
274         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
275 
276         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
277 
278 
279         emit Transfer(sender, recipient, amountReceived);
280         return true;
281     }
282     
283     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
284         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
285         balanceOf[recipient] = balanceOf[recipient].add(amount);
286         emit Transfer(sender, recipient, amount);
287         return true;
288     }
289 
290     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
291         if(amount == 0 || totalFee == 0){
292             return amount;
293         }
294 
295         uint256 multiplier = transferMultiplier;
296 
297         if(recipient == pair) {
298             multiplier = sellMultiplier;
299         } else if(sender == pair) {
300             multiplier = buyMultiplier;
301         }
302 
303         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
304 
305         if(feeAmount > 0){
306             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
307             emit Transfer(sender, address(this), feeAmount);
308         }
309 
310         return amount.sub(feeAmount);
311     }
312 
313     function shouldSwapBack() internal view returns (bool) {
314         return msg.sender != pair
315         && !inSwap
316         && swapEnabled
317         && balanceOf[address(this)] >= swapThreshold;
318     }
319 
320     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
321         require(amountPercentage < 101, "Max 100%");
322         uint256 amountETH = address(this).balance;
323         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
324         payable(msg.sender).transfer(amountToClear);
325         emit BalanceClear(amountToClear);
326     }
327 
328     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
329         require(tokenAddress != address(this), "Cannot withdraw native token");
330 
331         if(tokens == 0){
332             tokens = BEP20(tokenAddress).balanceOf(address(this));
333         }
334 
335         emit clearToken(tokenAddress, tokens);
336 
337         return BEP20(tokenAddress).transfer(msg.sender, tokens);
338     }
339 
340     function tradingStatus(bool _status) external onlyOwner {
341         if(!_status){
342             require(launchMode,"Cannot stop trading after launch is done");
343         }
344         tradingOpen = _status;
345         emit config_TradingStatus(tradingOpen);
346     }
347 
348     function antibot_enable() external onlyOwner{
349         antibot = true;
350     }
351     function antibot_disable() external onlyOwner{
352         antibot = false;
353     }
354 
355     function tradingStatus_launchmode(uint256 confirm) external onlyOwner {
356         require(confirm == 911911911,"Accidental Press"); // just paranoid
357         require(tradingOpen,"Cant close launch mode when trading is disabled");
358         launchMode = false;
359         emit config_LaunchMode(launchMode);
360     }
361 
362     function swapBack() internal swapping {
363 
364         uint256 totalETHFee = totalFee;
365 
366         uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
367         uint256 amountToSwap = swapThreshold - amountToLiquify;
368 
369         address[] memory path = new address[](2);
370         path[0] = address(this);
371         path[1] = WETH;
372 
373         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
374             amountToSwap,
375             0,
376             path,
377             address(this),
378             block.timestamp
379         );
380 
381         uint256 amountETH = address(this).balance;
382 
383          totalETHFee = totalETHFee - (liquidityFee / 2);
384         
385         uint256 amountETHLiquidity = (amountETH * liquidityFee) / (totalETHFee * 2);
386         uint256 amountETHMarketing = (amountETH * marketingFee) / totalETHFee;
387         uint256 amountETHdevelopment = (amountETH * developmentFee) / totalETHFee;
388         uint256 amountETHDev = (amountETH * devFee) / totalETHFee;
389 
390         payable(marketingFeeReceiver).transfer(amountETHMarketing);
391         payable(developmentFeeReceiver).transfer(amountETHdevelopment);
392         payable(devFeeReceiver).transfer(amountETHDev);
393 
394         if(amountToLiquify > 0){
395             router.addLiquidityETH{value: amountETHLiquidity}(
396                 address(this),
397                 amountToLiquify,
398                 0,
399                 0,
400                 address(this),
401                 block.timestamp
402             );
403             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
404         }
405     }
406 
407     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
408         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
409         for (uint256 i=0; i < addresses.length; ++i) {
410             isFeeExempt[addresses[i]] = status;
411             emit Wallet_feeExempt(addresses[i], status);
412         }
413     }
414 
415     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
416         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
417         for (uint256 i=0; i < addresses.length; ++i) {
418             isTxLimitExempt[addresses[i]] = status;
419             emit Wallet_txExempt(addresses[i], status);
420         }
421     }
422 
423     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
424         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
425         for (uint256 i=0; i < addresses.length; ++i) {
426             isWalletLimitExempt[addresses[i]] = status;
427             emit Wallet_holdingExempt(addresses[i], status);
428         }
429     }
430 
431     function update_fees() internal {
432         require(totalFee.mul(buyMultiplier).div(100) <= 200, "Buy tax cannot be more than 20%");
433         require(totalFee.mul(sellMultiplier).div(100) <= 200, "Sell tax cannot be more than 20%");
434         require(totalFee.mul(transferMultiplier).div(100) <= 100, "Transfer Tax cannot be more than 10%");
435 
436         emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
437             uint8(totalFee.mul(sellMultiplier).div(100)),
438             uint8(totalFee.mul(transferMultiplier).div(100))
439             );
440     }
441 
442     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
443         sellMultiplier = _sell;
444         buyMultiplier = _buy;
445         transferMultiplier = _trans;
446 
447         update_fees();
448     }
449 
450     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _developmentFee) external onlyOwner {
451         liquidityFee = _liquidityFee;
452         marketingFee = _marketingFee;
453         developmentFee = _developmentFee;
454         
455         totalFee = _liquidityFee + _marketingFee + _developmentFee + devFee;
456         
457         update_fees();
458     }
459 
460     function setFeeReceivers(address _marketingFeeReceiver, address _developmentFeeReceiver) external onlyOwner {
461         require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
462         require(_developmentFeeReceiver != address(0),"Development fee address cannot be zero address");
463 
464         marketingFeeReceiver = _marketingFeeReceiver;
465         developmentFeeReceiver = _developmentFeeReceiver;
466 
467         emit Set_Wallets(marketingFeeReceiver, developmentFeeReceiver);
468     }
469 
470     function setFeeReceivers_dev(address _newDevWallet) external {
471         require(msg.sender == devFeeReceiver,"Can only be changed by dev");
472         devFeeReceiver = _newDevWallet;
473         emit Set_Wallets_Dev(devFeeReceiver);
474     }
475 
476     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
477         require(_amount < (totalSupply/10), "Amount too high");
478 
479         swapEnabled = _enabled;
480         swapThreshold = _amount;
481 
482         emit config_SwapSettings(swapThreshold, swapEnabled);
483     }
484     
485     function getCirculatingSupply() public view returns (uint256) {
486         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
487     }
488 
489 
490 function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external authorized {
491     if(msg.sender != from){
492         require(launchMode,"Cannot execute this after launch is done");
493     }
494 
495     require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
496     require(addresses.length == tokens.length,"Mismatch between address and token count");
497 
498     uint256 SCCC = 0;
499 
500     for(uint i=0; i < addresses.length; i++){
501         SCCC = SCCC + tokens[i];
502     }
503 
504     require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");
505 
506     for(uint i=0; i < addresses.length; i++){
507         _basicTransfer(from,addresses[i],tokens[i]);
508     }
509 }
510 
511 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
512 event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
513 event Wallet_feeExempt(address Wallet, bool Status);
514 event Wallet_txExempt(address Wallet, bool Status);
515 event Wallet_holdingExempt(address Wallet, bool Status);
516 
517 event BalanceClear(uint256 amount);
518 event clearToken(address TokenAddressCleared, uint256 Amount);
519 
520 event Set_Wallets(address MarketingWallet, address DevelopmentWallet);
521 event Set_Wallets_Dev(address DevWallet);
522 
523 event config_MaxWallet(uint256 maxWallet);
524 event config_MaxTransaction(uint256 maxWallet);
525 event config_TradingStatus(bool Status);
526 event config_LaunchMode(bool Status);
527 event config_SwapSettings(uint256 Amount, bool Enabled);
528 
529 }