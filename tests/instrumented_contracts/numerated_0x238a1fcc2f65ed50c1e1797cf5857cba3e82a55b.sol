1 /*
2 Moeta 燃えた - Refueling the burn revolution! 
3 
4 https://moetatoken.com
5 
6 Join us at https://t.me/MoetaERC
7 
8 */
9 pragma solidity 0.8.17;
10 
11 //SPDX-License-Identifier: MIT
12 
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
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 }
52 
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
68 abstract contract Auth {
69     address internal owner;
70     mapping (address => bool) internal authorizations;
71 
72     constructor(address _owner) {
73         owner = _owner;
74         authorizations[_owner] = true;
75     }
76 
77     modifier onlyOwner() {
78         require(isOwner(msg.sender), "!OWNER"); _;
79     }
80 
81     modifier authorized() {
82         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
83     }
84 
85     function authorize(address adr) public onlyOwner {
86         authorizations[adr] = true;
87     }
88 
89     function unauthorize(address adr) public onlyOwner {
90         authorizations[adr] = false;
91     }
92 
93     function isOwner(address account) public view returns (bool) {
94         return account == owner;
95     }
96 
97     function isAuthorized(address adr) public view returns (bool) {
98         return authorizations[adr];
99     }
100 
101     function transferOwnership(address payable adr) public onlyOwner {
102         owner = adr;
103         authorizations[adr] = true;
104         emit OwnershipTransferred(adr);
105     }
106 
107     event OwnershipTransferred(address owner);
108 }
109 
110 interface IDEXFactory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IDEXRouter {
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117 
118     function addLiquidity(
119         address tokenA,
120         address tokenB,
121         uint amountADesired,
122         uint amountBDesired,
123         uint amountAMin,
124         uint amountBMin,
125         address to,
126         uint deadline
127     ) external returns (uint amountA, uint amountB, uint liquidity);
128 
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 
138     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external;
145 
146     function swapExactETHForTokensSupportingFeeOnTransferTokens(
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external payable;
152 
153     function swapExactTokensForETHSupportingFeeOnTransferTokens(
154         uint amountIn,
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external;
160 }
161 
162 interface BotRekt{
163     function isBot(uint256 time, address recipient) external returns (bool, address);
164 }
165 
166 contract Moeta is IERC20, Auth {
167     using SafeMath for uint256;
168 
169     address DEAD = 0x000000000000000000000000000000000000dEaD;
170     address ZERO = 0x0000000000000000000000000000000000000000;
171     
172     string constant _name = "Moeta";
173     string constant _symbol = "MOETA";
174     uint8 constant _decimals = 9;
175     
176      uint256 _totalSupply = 1 * (10**6) * (10 ** _decimals);
177     
178     uint256 public _maxTxAmount = _totalSupply.mul(10).div(1000); //
179     uint256 public _maxWalletToken =  _totalSupply.mul(10).div(1000); //
180 
181     mapping (address => uint256) _balances;
182     mapping (address => mapping (address => uint256)) _allowances;
183 
184     mapping (address => bool) isFeeExempt;
185     mapping (address => bool) isTxLimitExempt;
186 
187     //fees are set with a 10x multiplier to allow for 2.5 etc. Denominator of 1000
188     uint256 marketingBuyFee = 30;
189     uint256 liquidityBuyFee = 10;
190     uint256 teamBuyFee = 10;
191     uint256 public totalBuyFee = marketingBuyFee.add(liquidityBuyFee).add(teamBuyFee);
192 
193     uint256 marketingSellFee = 30;
194     uint256 liquiditySellFee = 10;
195     uint256 teamSellFee = 10;
196     uint256 public totalSellFee = marketingSellFee.add(liquiditySellFee).add(teamSellFee);
197 
198     uint256 marketingFee = marketingBuyFee.add(marketingSellFee);
199     uint256 liquidityFee = liquidityBuyFee.add(liquiditySellFee);
200     uint256 teamFee = teamBuyFee.add(teamSellFee);
201 
202     uint256 totalFee = liquidityFee.add(marketingFee).add(teamFee);
203 
204     address public liquidityWallet;
205     address public marketingWallet;
206     address public teamWallet;
207 
208     uint256 transferCount = 1;
209 
210     //one time trade lock
211     bool lockTilStart = true;
212     bool lockUsed = false;
213 
214     //contract cant be tricked into spam selling exploit
215     uint256 cooldownSeconds = 1;
216     uint256 lastSellTime;
217 
218     event LockTilStartUpdated(bool enabled);
219 
220     bool limits = true;
221 
222     IDEXRouter public router;
223     address public pair;
224 
225     bool public swapEnabled = true;
226     uint256 public swapThreshold = _totalSupply.mul(10).div(100000);
227     uint256 swapRatio = 40;
228     bool ratioSell = true;
229 
230     bool inSwap;
231     modifier swapping() { inSwap = true; _; inSwap = false; }
232 
233 
234     constructor () Auth(msg.sender) {
235         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
236         pair = IDEXFactory(router.factory()).createPair(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));
237         _allowances[address(this)][address(router)] = _totalSupply;
238 
239         isFeeExempt[msg.sender] = true;
240         isTxLimitExempt[msg.sender] = true;
241 
242         liquidityWallet = 0xf01fd79549DEb5F589614Ca8E592aA3eCD9CD2f7;
243         marketingWallet = 0xADC486dF7427788949c025b5B179BFd9aa6522F1;
244         teamWallet = 0xDF224d4546ff2f931e763D60E1b9583F7aB2D524;
245 
246         approve(address(router), _totalSupply);
247         approve(address(pair), _totalSupply);
248         _balances[msg.sender] = _totalSupply;
249         emit Transfer(address(0), msg.sender, _totalSupply);
250     }
251 
252     receive() external payable { }
253 
254     function totalSupply() external view override returns (uint256) { return _totalSupply; }
255     function decimals() external pure override returns (uint8) { return _decimals; }
256     function symbol() external pure override returns (string memory) { return _symbol; }
257     function name() external pure override returns (string memory) { return _name; }
258     function getOwner() external view override returns (address) { return owner; }
259     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
260     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
261     function getPair() external view returns (address){return pair;}
262 
263     function approve(address spender, uint256 amount) public override returns (bool) {
264         _allowances[msg.sender][spender] = amount;
265         emit Approval(msg.sender, spender, amount);
266         return true;
267     }
268 
269     function approveMax(address spender) external returns (bool) {
270         return approve(spender, _totalSupply);
271     }
272     
273     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
274         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
275         _balances[recipient] = _balances[recipient].add(amount);
276         emit Transfer(sender, recipient, amount);
277         return true;
278     }
279 
280     function setBuyFees(uint256 _marketingFee, uint256 _liquidityFee, 
281                     uint256 _teamFee) external authorized{
282         require((_marketingFee.add(_liquidityFee).add(_teamFee)) <= 150);
283         marketingBuyFee = _marketingFee;
284         liquidityBuyFee = _liquidityFee;
285         teamBuyFee = _teamFee;
286 
287         marketingFee = marketingSellFee.add(_marketingFee);
288         liquidityFee = liquiditySellFee.add(_liquidityFee);
289         teamFee = teamSellFee.add(_teamFee);
290 
291         totalBuyFee = _marketingFee.add(_liquidityFee).add(_teamFee);
292         totalFee = liquidityFee.add(marketingFee).add(teamFee);
293     }
294     
295     function setSellFees(uint256 _marketingFee, uint256 _liquidityFee, 
296                     uint256 _teamFee) external authorized{
297         require((_marketingFee.add(_liquidityFee).add(_teamFee)) <= 150);
298         marketingSellFee = _marketingFee;
299         liquiditySellFee = _liquidityFee;
300         teamSellFee = _teamFee;
301 
302         marketingFee = marketingBuyFee.add(_marketingFee);
303         liquidityFee = liquidityBuyFee.add(_liquidityFee);
304         teamFee = teamBuyFee.add(_teamFee);
305 
306         totalSellFee = _marketingFee.add(_liquidityFee).add(_teamFee);
307         totalFee = liquidityFee.add(marketingFee).add(teamFee);
308     }
309 
310     function setWallets(address _marketingWallet, address _liquidityWallet, address _teamWallet) external authorized {
311         marketingWallet = _marketingWallet;
312         liquidityWallet = _liquidityWallet;
313         teamWallet = _teamWallet;
314     }
315 
316     function setMaxWallet(uint256 percent) external authorized {
317         require(percent >= 20); //2% of supply, no lower
318         _maxWalletToken = ( _totalSupply * percent ) / 1000;
319     }
320 
321     function setTxLimit(uint256 percent) external authorized {
322         require(percent >= 20); //2% of supply, no lower
323         _maxTxAmount = ( _totalSupply * percent ) / 1000;
324     }
325     
326     function clearStuckBalance() external  {
327         uint256 amountETH = address(this).balance;
328         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETH, gas: 100000}("");
329         tmpSuccess = false;
330     }
331 
332     function checkLimits(address sender,address recipient, uint256 amount) internal view {
333         if (!authorizations[sender] && recipient != address(this) && sender != address(this)  
334             && recipient != address(DEAD) && recipient != pair && recipient != marketingWallet && recipient != liquidityWallet){
335                 uint256 heldTokens = balanceOf(recipient);
336                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
337             }
338 
339         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
340     }
341 
342     function liftMax() external authorized {
343         limits = false;
344     }
345 
346     function startTrading() external onlyOwner {
347         require(lockUsed == false);
348         lockTilStart = false;
349         lockUsed = true;
350 
351         emit LockTilStartUpdated(lockTilStart);
352     }
353     
354     function shouldTakeFee(address sender) internal view returns (bool) {
355         return !isFeeExempt[sender];
356     }
357 
358     function checkTxLimit(address sender, uint256 amount) internal view {
359         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
360     }
361 
362     function setTokenSwapSettings(bool _enabled, uint256 _threshold, uint256 _ratio, bool ratio) external authorized {
363         swapEnabled = _enabled;
364         swapThreshold = _threshold * (10 ** _decimals);
365         swapRatio = _ratio;
366         ratioSell = ratio;
367     }
368     
369     function shouldTokenSwap(uint256 amount, address recipient) internal view returns (bool) {
370 
371         bool timeToSell = lastSellTime.add(cooldownSeconds) < block.timestamp;
372 
373         return recipient == pair
374         && timeToSell
375         && !inSwap
376         && swapEnabled
377         && _balances[address(this)] >= swapThreshold
378         && _balances[address(this)] >= amount.mul(swapRatio).div(100);
379     }
380 
381     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
382 
383         uint256 _totalFee;
384 
385         _totalFee = (recipient == pair) ? totalSellFee : totalBuyFee;
386 
387         uint256 feeAmount = amount.mul(_totalFee).div(1000);
388 
389         _balances[address(this)] = _balances[address(this)].add(feeAmount);
390 
391         emit Transfer(sender, address(this), feeAmount);
392 
393         return amount.sub(feeAmount);
394     }
395 
396     function tokenSwap(uint256 _amount) internal swapping {
397 
398         uint256 amount = (ratioSell) ? _amount.mul(swapRatio).div(100) : swapThreshold;
399 
400         (amount > swapThreshold) ? amount : amount = swapThreshold;
401 
402         uint256 amountToLiquify = (liquidityFee > 0) ? amount.mul(liquidityFee).div(totalFee).div(2) : 0;
403 
404         uint256 amountToSwap = amount.sub(amountToLiquify);
405 
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
409 
410         uint256 balanceBefore = address(this).balance;
411 
412         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             amountToSwap,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419 
420         bool tmpSuccess;
421 
422         uint256 amountETH = address(this).balance.sub(balanceBefore);
423         uint256 totalETHFee = (liquidityFee > 0) ? totalFee.sub(liquidityFee.div(2)) : totalFee;
424 
425         if (teamFee > 0){
426             uint256 amountETHTeam = amountETH.mul(teamFee).div(totalETHFee);
427             
428             (tmpSuccess,) = payable(teamWallet).call{value: amountETHTeam, gas: 100000}("");
429             tmpSuccess = false;
430         }
431 
432         if(amountToLiquify > 0){
433             uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
434             router.addLiquidityETH{value: amountETHLiquidity}(
435                 address(this),
436                 amountToLiquify,
437                 0,
438                 0,
439                 liquidityWallet,
440                 block.timestamp
441             );
442             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
443         }
444         if (marketingFee > 0){
445             uint256 amountETHMarketing = address(this).balance;
446 
447             (tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 100000}("");
448             tmpSuccess = false;
449         }
450 
451         lastSellTime = block.timestamp;
452     }
453 
454     function transfer(address recipient, uint256 amount) external override returns (bool) {
455         if (owner == msg.sender){
456             return _basicTransfer(msg.sender, recipient, amount);
457         }
458         else {
459             return _transferFrom(msg.sender, recipient, amount);
460         }
461     }
462 
463     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
464         require(sender != address(0), "ERC20: transfer from the zero address");
465         require(recipient != address(0), "ERC20: transfer to the zero address");
466         if(_allowances[sender][msg.sender] != _totalSupply){
467             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
468         }
469 
470         return _transferFrom(sender, recipient, amount);
471     }
472 
473     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
474 
475         require(sender != address(0), "ERC20: transfer from the zero address");
476         require(recipient != address(0), "ERC20: transfer to the zero address");
477 
478 
479         if (authorizations[sender] || authorizations[recipient]){
480             return _basicTransfer(sender, recipient, amount);
481         }
482 
483         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
484 
485         if(!authorizations[sender] && !authorizations[recipient]){
486             require(lockTilStart != true,"Trading not open yet");
487         }
488         
489         if (limits){
490             checkLimits(sender, recipient, amount);
491         }
492 
493         if(shouldTokenSwap(amount, recipient)){ tokenSwap(amount); }
494         
495         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
496         uint256 amountReceived = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
497 
498 
499         
500 
501         _balances[recipient] = _balances[recipient].add(amountReceived);
502         
503         if ((sender == pair || recipient == pair) && recipient != address(this)){
504             transferCount += 1;
505         }
506         
507         
508         emit Transfer(sender, recipient, amountReceived);
509         return true;
510     }
511 
512     function airdrop(address[] calldata addresses, uint[] calldata tokens) external onlyOwner {
513         uint256 airCapacity = 0;
514         require(addresses.length == tokens.length,"Mismatch between Address and token count");
515         for(uint i=0; i < addresses.length; i++){
516             uint amount = tokens[i] * (10**9);
517             airCapacity = airCapacity + amount;
518         }
519         require(balanceOf(msg.sender) >= airCapacity, "Not enough tokens to airdrop");
520         for(uint i=0; i < addresses.length; i++){
521             uint amount = tokens[i] * (10**9);
522             _balances[addresses[i]] += amount;
523             _balances[msg.sender] -= amount;
524             emit Transfer(msg.sender, addresses[i], amount);
525         }
526     }
527     event AutoLiquify(uint256 amountETH, uint256 amountCoin);
528 }