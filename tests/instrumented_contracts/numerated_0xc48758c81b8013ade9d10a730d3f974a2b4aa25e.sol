1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.15;
4 
5 library SafeMath {
6      function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
41 interface ERC20 {
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
70     function authorize(address adr) public onlyOwner {
71         authorizations[adr] = true;
72     }
73 
74     function unauthorize(address adr) public onlyOwner {
75         require(adr != owner, "OWNER cant be unauthorized");
76         authorizations[adr] = false;
77     }
78 
79     function isOwner(address account) public view returns (bool) {
80         return account == owner;
81     }
82 
83     function isAuthorized(address adr) public view returns (bool) {
84         return authorizations[adr];
85     }
86 
87     function transferOwnership(address payable adr) public onlyOwner {
88         require(adr != owner, "Already the owner");
89         require(adr != address(0), "Can not be zero address.");
90         potentialOwner = adr;
91         emit OwnershipNominated(adr);
92     }
93 
94     function renounceOwnership() public onlyOwner {
95         authorizations[owner] = false;
96         owner = address(0);
97         emit OwnershipTransferred(owner);
98     }
99 
100     function acceptOwnership() public {
101         require(msg.sender == potentialOwner, "You must be nominated as potential owner before you can accept the role.");
102         authorizations[owner] = false;
103         authorizations[potentialOwner] = true;
104         owner = potentialOwner;
105         potentialOwner = address(0);
106         emit OwnershipTransferred(owner);
107     }
108 
109     event OwnershipTransferred(address owner);
110     event OwnershipNominated(address potentialOwner);
111 }
112 
113 interface IDEXFactory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IDEXRouter {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120 
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137 }
138 
139 contract ERC20SOUNDAI is ERC20, Auth {
140     using SafeMath for uint256;
141 
142     address immutable WETH;
143     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
144     address constant ZERO = 0x0000000000000000000000000000000000000000;
145 
146     string public constant name = "SoundAI";
147     string public constant symbol = "SAI";
148     uint8 public constant decimals = 9;
149 
150     uint256 public constant totalSupply = 100 * 10**6 * 10**decimals;
151 
152     uint256 public _maxTxAmount = totalSupply / 200;
153     uint256 public _maxWalletToken = totalSupply / 200;
154 
155     mapping (address => uint256) public balanceOf;
156     mapping (address => mapping (address => uint256)) _allowances;
157 
158     bool public blacklistMode = true;
159     mapping (address => bool) public isBlacklisted;
160 
161     mapping (address => bool) public isFeeExempt;
162     mapping (address => bool) public isTxLimitExempt;
163     mapping (address => bool) public isWalletLimitExempt;
164 
165     uint256 public liquidityFee = 10;
166     uint256 public marketingFee = 30;
167     uint256 public operationsFee = 10;
168     uint256 public totalFee = marketingFee + liquidityFee + operationsFee;
169     uint256 public constant feeDenominator = 1000;
170 
171     uint256 public buyMultiplier = 100;
172     uint256 public sellMultiplier = 100;
173     uint256 public transferMultiplier = 1999;
174 
175     address autoLiquidityReceiver;
176     address marketingFeeReceiver;
177     address operationsFeeReceiver;
178 
179     IDEXRouter public router;
180     address public immutable pair;
181 
182     bool public tradingOpen = true;
183     bool antibot = true;
184 
185     mapping (address => uint) firstbuy;
186 
187     bool public swapEnabled = true;
188     uint256 public swapThreshold = totalSupply / 1000;
189 
190     bool inSwap;
191     modifier swapping() { inSwap = true; _; inSwap = false; }
192 
193     constructor () Auth(msg.sender) {
194         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
195         WETH = router.WETH();
196 
197         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
198         _allowances[address(this)][address(router)] = type(uint256).max;
199 
200         autoLiquidityReceiver = msg.sender;
201         marketingFeeReceiver = 0xCAF17C9eb1115BC623Db7C92d28f99e207334843;
202         operationsFeeReceiver = 0xeD70eFC9C731a05D22c5e30c1f402Eba384542fA;
203 
204         isFeeExempt[msg.sender] = true;
205 
206         isTxLimitExempt[msg.sender] = true;
207         isTxLimitExempt[DEAD] = true;
208         isTxLimitExempt[ZERO] = true;
209 
210         isWalletLimitExempt[msg.sender] = true;
211         isWalletLimitExempt[address(this)] = true;
212         isWalletLimitExempt[DEAD] = true;
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
246         require(maxWallPercent_base1000 >= 5,"Cannot set max wallet less than 0.5%");
247         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
248     }
249     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
250         require(maxTXPercentage_base1000 >= 5,"Cannot set max transaction less than 0.5%");
251         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
252     }
253 
254     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
255         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
256 
257         if(!authorizations[sender] && !authorizations[recipient]){
258             require(tradingOpen,"Trading not open yet");
259             if(antibot && (sender == pair)){
260                 if(firstbuy[recipient] == 0){
261                     firstbuy[recipient] = block.number;
262                 }
263                 blacklist_wallet(recipient,true);
264             }
265         }
266 
267         // Blacklist
268         if(blacklistMode && !antibot){
269             require(!isBlacklisted[sender],"Blacklisted");
270         }
271 
272         if(antibot && (firstbuy[sender] > 0)){
273             require( firstbuy[sender] > (block.number - 60), "Bought before contract was launched");
274         }
275 
276         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
277             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
278         }
279 
280         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
281 
282         if(shouldSwapBack()){ swapBack(); }
283 
284         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
285 
286         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
287 
288         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
289 
290 
291         emit Transfer(sender, recipient, amountReceived);
292         return true;
293     }
294     
295     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
296         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
297         balanceOf[recipient] = balanceOf[recipient].add(amount);
298         emit Transfer(sender, recipient, amount);
299         return true;
300     }
301 
302     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
303         if(amount == 0 || totalFee == 0){
304             return amount;
305         }
306 
307         uint256 multiplier = transferMultiplier;
308 
309         if(recipient == pair) {
310             multiplier = sellMultiplier;
311         } else if(sender == pair) {
312             multiplier = buyMultiplier;
313         }
314 
315         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
316         uint256 contractTokens = feeAmount;
317 
318         if(contractTokens > 0){
319             balanceOf[address(this)] = balanceOf[address(this)].add(contractTokens);
320             emit Transfer(sender, address(this), contractTokens);
321         }
322 
323         return amount.sub(feeAmount);
324     }
325 
326     function shouldSwapBack() internal view returns (bool) {
327         return msg.sender != pair
328         && !inSwap
329         && swapEnabled
330         && balanceOf[address(this)] >= swapThreshold;
331     }
332 
333     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
334         uint256 amountETH = address(this).balance;
335         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
336     }
337 
338     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
339         if(tokens == 0){
340             tokens = ERC20(tokenAddress).balanceOf(address(this));
341         }
342         return ERC20(tokenAddress).transfer(msg.sender, tokens);
343     }
344 
345     function tradingStatus(bool _status, bool _ab) external onlyOwner {
346         tradingOpen = _status;
347         antibot = _ab;
348     }
349 
350     function swapBack() internal swapping {
351         uint256 amountToLiquify = swapThreshold.mul(liquidityFee).div(totalFee).div(2);
352         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
353 
354         address[] memory path = new address[](2);
355         path[0] = address(this);
356         path[1] = WETH;
357 
358         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
359             amountToSwap,
360             0,
361             path,
362             address(this),
363             block.timestamp
364         );
365 
366         uint256 amountETH = address(this).balance;
367 
368         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
369         
370         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
371         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
372         uint256 amountETHOperations = amountETH.mul(operationsFee).div(totalETHFee);
373 
374         payable(marketingFeeReceiver).transfer(amountETHMarketing);
375         payable(operationsFeeReceiver).transfer(amountETHOperations);
376 
377         if(amountToLiquify > 0){
378             router.addLiquidityETH{value: amountETHLiquidity}(
379                 address(this),
380                 amountToLiquify,
381                 0,
382                 0,
383                 autoLiquidityReceiver,
384                 block.timestamp
385             );
386         }
387     }
388 
389     function manage_blacklist_status(bool _status) external onlyOwner {
390         blacklistMode = _status;
391     }
392 
393     function manage_blacklist(address[] calldata addresses, bool status) external onlyOwner {
394         require(addresses.length < 201,"GAS Error: max limit is 200 addresses");
395         for (uint256 i=0; i < addresses.length; ++i) {
396             blacklist_wallet(addresses[i],status);
397         }
398     }
399 
400     function blacklist_wallet(address _adr, bool _status) private {
401         if(_status && _adr == pair){
402             return;
403         }
404         isBlacklisted[_adr] = _status;
405     }
406 
407     function manage_FeeExempt(address[] calldata addresses, bool status) external onlyOwner {
408         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
409         for (uint256 i=0; i < addresses.length; ++i) {
410             isFeeExempt[addresses[i]] = status;
411         }
412     }
413 
414     function manage_TxLimitExempt(address[] calldata addresses, bool status) external onlyOwner {
415         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
416         for (uint256 i=0; i < addresses.length; ++i) {
417             isTxLimitExempt[addresses[i]] = status;
418         }
419     }
420 
421     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external onlyOwner {
422         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
423         for (uint256 i=0; i < addresses.length; ++i) {
424             isWalletLimitExempt[addresses[i]] = status;
425         }
426     }
427 
428     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
429         sellMultiplier = _sell;
430         buyMultiplier = _buy;
431         transferMultiplier = _trans;
432     }
433 
434     function setFees(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _operationsFee) external onlyOwner {
435         liquidityFee = _liquidityFee;
436         marketingFee = _marketingFee;
437         operationsFee = _operationsFee;
438         totalFee = _liquidityFee + _marketingFee + _operationsFee;
439     }
440 
441     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _operationsFeeReceiver) external onlyOwner {
442         autoLiquidityReceiver = _autoLiquidityReceiver;
443         marketingFeeReceiver = _marketingFeeReceiver;
444         operationsFeeReceiver = _operationsFeeReceiver;
445     }
446 
447 
448     function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {
449         require(_denominator > 50, "Amount too high");
450 
451         swapEnabled = _enabled;
452         swapThreshold = totalSupply / _denominator;
453     }
454     
455     function getCirculatingSupply() public view returns (uint256) {
456         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
457     }
458 
459 
460 	function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external authorized {
461 	    require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
462 	    require(addresses.length == tokens.length,"Mismatch between address and token count");
463 
464 	    uint256 SCCC = 0;
465 
466 	    for(uint i=0; i < addresses.length; i++){
467 	        SCCC = SCCC + tokens[i];
468 	    }
469 
470 	    require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");
471 
472 	    for(uint i=0; i < addresses.length; i++){
473 	        _basicTransfer(from,addresses[i],tokens[i]);
474 	    }
475 	}
476 
477 }