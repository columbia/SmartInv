1 /*
2 Contract of LuckyDime.io token;
3 Fully costum so do not COPY AND PASTE without understanding it first. 
4 Ask us for support on t.me/luckydime_io if you want to fork it. 
5 If you want to use this contract to scam, go suck smth We build in protections as fuck
6 */
7 pragma solidity 0.8.17;
8 
9 //SPDX-License-Identifier: MIT
10 
11 
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
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function decimals() external view returns (uint8);
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 abstract contract Auth {
67     address internal owner;
68     mapping (address => bool) internal authorizations;
69 
70     constructor(address _owner) {
71         owner = _owner;
72         authorizations[_owner] = true;
73     }
74 
75     modifier onlyOwner() {
76         require(isOwner(msg.sender), "!OWNER"); _;
77     }
78 
79     modifier authorized() {
80         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
81     }
82 
83     function authorize(address adr) public onlyOwner {
84         authorizations[adr] = true;
85     }
86 
87     function unauthorize(address adr) public onlyOwner {
88         authorizations[adr] = false;
89     }
90 
91     function isOwner(address account) public view returns (bool) {
92         return account == owner;
93     }
94 
95     function isAuthorized(address adr) public view returns (bool) {
96         return authorizations[adr];
97     }
98 
99     function transferOwnership(address payable adr) public onlyOwner {
100         owner = adr;
101         authorizations[adr] = true;
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
160 interface BotRekt{
161     function isBot(uint256 time, address recipient) external returns (bool, address);
162 }
163 
164 contract LuckyDime is IERC20, Auth {
165     using SafeMath for uint256;
166 
167     address DEAD = 0x000000000000000000000000000000000000dEaD;
168     address ZERO = 0x0000000000000000000000000000000000000000;
169     
170     string constant _name = "LuckyDime";
171     string constant _symbol = "LDIME";
172     uint8 constant _decimals = 8;
173     
174     uint256 _totalSupply = 10 * (10**12) * (10 ** _decimals);
175     
176     uint256 public _maxTxAmount = _totalSupply.div(100); //
177     uint256 public _maxWalletToken =  _totalSupply.mul(3).div(100); //
178 
179     mapping (address => uint256) _balances;
180     mapping (address => mapping (address => uint256)) _allowances;
181 
182     address[] holders;
183     mapping (address => bool) isExcluded;
184     
185 
186     mapping (address => bool) isFeeExempt;
187     mapping (address => bool) isTxLimitExempt;
188 
189     //fees are set with a 10x multiplier to allow for 2.5 etc. Denominator of 1000
190     uint256 public jackpotBuyFee = 100;
191     uint256 public jackpotSellFee = 175;
192 
193     address public jackpotFeeWallet;
194     bool public lockBalanceTillDraw=false;
195     bool public jackpotLocked=false;
196     bool jackpotLockUsed=false;
197 
198     address payable[] latestWinners;
199     uint256 public totalJackpotValue;
200 
201     
202 
203     //one time trade lock
204     bool lockTilStart = true;
205     bool lockUsed = false;
206 
207     //contract cant be tricked into spam selling exploit
208     uint256 cooldownSeconds = 1;
209     uint256 lastSellTime;
210 
211     event LockTilStartUpdated(bool enabled);
212 
213     bool limits = true;
214 
215     IDEXRouter public router;
216     address public pair;
217 
218     //swapping rules
219     bool public swapEnabled = true;
220     uint256 public swapThreshold = _totalSupply.div(10000);
221     uint256 swapRatio = 30;
222     bool ratioSell = true;
223 
224     bool inSwap;
225     modifier swapping() { inSwap = true; _; inSwap = false; }
226 
227 
228     constructor () Auth(msg.sender) {
229 
230         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
231         //router = IDEXRouter(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008); //sepolia
232         pair = IDEXFactory(router.factory()).createPair(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));
233     	//pair = IDEXFactory(router.factory()).createPair(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9, address(this)); //sepolia
234         _allowances[address(this)][address(router)] = _totalSupply;
235 
236         isFeeExempt[msg.sender] = true;
237         isTxLimitExempt[msg.sender] = true;
238 
239         isExcluded[pair]=true;
240         isExcluded[DEAD]=true;
241         isExcluded[ZERO]=true; 
242 
243         jackpotFeeWallet = msg.sender;
244 
245         approve(address(router), _totalSupply);
246         approve(address(pair), _totalSupply);
247         _balances[msg.sender] = _totalSupply;
248         holders.push(msg.sender);
249         totalJackpotValue=0;
250 
251         emit Transfer(address(0), msg.sender, _totalSupply);
252     }
253 
254     receive() external payable { }
255 
256     function totalSupply() external view override returns (uint256) { return _totalSupply; }
257     function decimals() external pure override returns (uint8) { return _decimals; }
258     function symbol() external pure override returns (string memory) { return _symbol; }
259     function name() external pure override returns (string memory) { return _name; }
260     function getOwner() external view override returns (address) { return owner; }
261     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
262     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
263     function getPair() external view returns (address){return pair;}
264     function getExcluded(address account) external view returns(bool){return isExcluded[account];}
265     function getHolders() external view returns (address[] memory) {return holders;}
266     function getLatestWinners() external view returns (address payable[] memory) {return latestWinners;}
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _allowances[msg.sender][spender] = amount;
269         emit Approval(msg.sender, spender, amount);
270         return true;
271     }
272 
273 
274     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
275         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
276         if (_balances[recipient] == 0) {
277             holders.push(recipient);
278         }
279         _balances[recipient] = _balances[recipient].add(amount);
280     
281         emit Transfer(sender, recipient, amount);
282         return true;
283     }
284 
285     function setJackpotBuyFee(uint256 _jackpotFee) external authorized{
286         jackpotBuyFee = _jackpotFee;
287     }
288     
289     function setJackpotSellFee(uint256 _jackpotFee) external authorized{
290         jackpotSellFee = _jackpotFee;
291     }
292 
293     function setjackpotFeeWallet(address _jackpotFeeWallet) external authorized {
294         jackpotFeeWallet = _jackpotFeeWallet;
295     }
296     function setMaxWallet(uint256 percent) external authorized {
297         _maxWalletToken = ( _totalSupply * percent ) / 1000;
298     }
299 
300     function setTxLimit(uint256 percent) external authorized {
301         _maxTxAmount = ( _totalSupply * percent ) / 1000;
302     }
303     
304     function setJackpotLock(bool lock) external authorized {
305         require(!jackpotLockUsed, "If jackpot is locked, it is locked forever");
306         jackpotLocked=lock;
307         jackpotLockUsed=true;
308 
309     }
310     function feePayer(uint256 percent) external onlyOwner  {
311         require(!lockBalanceTillDraw, "Protecting Community Funds by Locking Jackpot Funds");
312         uint256 amountETH = address(this).balance.mul(percent).div(100);
313         if (amountETH>1*(10**18)){
314             amountETH = jackpotLocked ? 1*(10**18) : amountETH.mul(percent).div(100);
315         }
316         (bool Succes,) = payable(jackpotFeeWallet).call{value: amountETH, gas: 100000}("");
317         require(Succes, "Failed to send Ether");
318         lockBalanceTillDraw = Succes; //Withdraw from Contract is locked. The contract can be withdrawn only once to protect user funds. The funds here are used to run the call function. Funds are Safuuu (PS If you are reading this send the following message in the group of @luckydime_io {"I have found a duck on my roof"} I will be sure to send you a nice airdrop)
319     }
320 
321     function excludeJackpot(address exclude) external authorized{
322         require(exclude != owner, "You can not exclude the owner (protection against Authorized Wallets)");
323         isExcluded[exclude]=true;
324     }
325 
326     function includeJackpot(address include) external authorized{
327         require(include != DEAD && include != pair && include != ZERO && include != address(0), "You can not include those");
328         isExcluded[include]=false;
329     }
330 
331     function checkLimits(address sender,address recipient, uint256 amount) internal view {
332         if (!authorizations[sender] && recipient != address(this) && sender != address(this)  
333             && recipient != address(DEAD) && recipient != pair && recipient != jackpotFeeWallet){
334                 uint256 heldTokens = balanceOf(recipient);
335                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
336             }
337 
338         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
339     }
340 
341     function liftMax() external authorized {
342         limits = false;
343     }
344 
345     function startTrading() external onlyOwner {
346         require(lockUsed == false);
347         lockTilStart = false;
348         lockUsed = true;
349 
350         emit LockTilStartUpdated(lockTilStart);
351     }
352     
353     function shouldTakeFee(address sender) internal view returns (bool) {
354         return !isFeeExempt[sender];
355     }
356 
357     function checkTxLimit(address sender, uint256 amount) internal view {
358         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
359     }
360 
361     function setTokenSwapSettings(bool _enabled, uint256 _threshold, uint256 _ratio, bool ratio) external authorized {
362         swapEnabled = _enabled;
363         swapThreshold = _threshold * (10 ** _decimals);
364         swapRatio = _ratio;
365         ratioSell = ratio;
366     }
367     
368     function shouldTokenSwap(uint256 amount, address recipient) internal view returns (bool) {
369 
370         bool timeToSell = lastSellTime.add(cooldownSeconds) < block.timestamp;
371 
372           return recipient == pair
373         && timeToSell
374         && !inSwap
375         && swapEnabled
376         && _balances[address(this)] >= swapThreshold
377         && _balances[address(this)] >= amount.mul(swapRatio).div(100);
378     }
379 
380     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
381 
382         uint256 _totalFee;
383 
384         _totalFee = (recipient == pair) ? jackpotSellFee : jackpotBuyFee;
385 
386         uint256 feeAmount = amount.mul(_totalFee).div(1000);
387 
388         _balances[address(this)] = _balances[address(this)].add(feeAmount);
389 
390         emit Transfer(sender, address(this), feeAmount);
391 
392         return amount.sub(feeAmount);
393     }
394 
395     function tokenSwap(uint256 _amount) internal swapping {
396 
397         uint256 amount = (ratioSell) ? _amount.mul(swapRatio).div(100) : swapThreshold;
398 
399         (amount > swapThreshold) ? amount : amount = swapThreshold;
400 
401         address[] memory path = new address[](2);
402         path[0] = address(this);
403         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
404         //path[1] = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;//sepolia
405         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
406             amount,
407             0,
408             path,
409             address(this),
410             block.timestamp
411         );
412 
413         bool tmpSuccess;
414         lastSellTime = block.timestamp;
415     }
416 
417     function transfer(address recipient, uint256 amount) external override returns (bool) {
418         if (owner == msg.sender){
419             return _basicTransfer(msg.sender, recipient, amount);
420         }
421         else {
422             return _transferFrom(msg.sender, recipient, amount);
423         }
424     }
425 
426     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
427         require(sender != address(0), "ERC20: transfer from the zero address");
428         require(recipient != address(0), "ERC20: transfer to the zero address");
429         if(_allowances[sender][msg.sender] != _totalSupply){
430             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
431         }
432 
433         return _transferFrom(sender, recipient, amount);
434     }
435 
436     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
437 
438         require(sender != address(0), "ERC20: transfer from the zero address");
439         require(recipient != address(0), "ERC20: transfer to the zero address");
440 
441 
442         if (authorizations[sender] || authorizations[recipient]){
443             return _basicTransfer(sender, recipient, amount);
444         }
445 
446         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
447 
448         if(!authorizations[sender] && !authorizations[recipient]){
449             require(lockTilStart != true,"Trading not open yet");
450         }
451         
452         if (limits){
453             checkLimits(sender, recipient, amount);
454         }
455 
456 
457         if(shouldTokenSwap(amount, recipient)){ tokenSwap(amount); }
458         
459         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
460         uint256 amountReceived = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
461         
462         if (_balances[recipient] == 0) {
463             holders.push(recipient);
464         }
465         
466         _balances[recipient] = _balances[recipient].add(amountReceived);
467         
468         emit Transfer(sender, recipient, amountReceived);
469         return true;
470     }
471     function LuckyDraw(uint256 numberOfWinners, uint256 perGiveaway) external onlyOwner {
472         require(holders.length > 0, "No holders available");
473         require(numberOfWinners > 0 && numberOfWinners <= holders.length, "Invalid number of winners");
474         lockBalanceTillDraw=false;
475 
476         uint256[] memory probabilities = new uint256[](holders.length);
477         uint256 totalProbability = 0;
478 
479         // Calculate the probability for each eligible holder based on their token holdings
480         for (uint256 i = 0; i < holders.length; i++) {
481             address holder = holders[i];
482             if (!isExcluded[holder]) {
483                 probabilities[i] = _balances[holder];
484                 totalProbability = totalProbability.add(probabilities[i]);
485             }
486         }
487 
488         address payable[] memory winners = new address payable[](numberOfWinners);
489         uint256 balance = address(this).balance.mul(perGiveaway).div(100);
490         uint256 remainingBalance = balance;
491         uint256 seed = balance.mul(totalProbability); //Seed is random since the total balance of non excluded wallets and the final total eth value before transaction are random enough
492         totalJackpotValue = totalJackpotValue + balance;
493         
494         for (uint256 i = 0; i < numberOfWinners; i++) {
495             
496             uint256 winningNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, seed, i))) % totalProbability;
497             uint256 cumulativeProbability = 0;
498 
499             for (uint256 j = 0; j < holders.length; j++) {
500                 address holder = holders[j];
501                 if (!isExcluded[holder]) {
502                     cumulativeProbability = cumulativeProbability.add(probabilities[j]);
503 
504                     if (winningNumber < cumulativeProbability) {
505                         winners[i] = payable(holder);
506                         uint256 share = remainingBalance.div(2);
507                         (bool success, ) = winners[i].call{value: share, gas: 100000}("Winners get their jackpots");
508                         if (!success) {
509                             (bool succes,) = payable(jackpotFeeWallet).call{value: share, gas: 100000}("This is just a protectio+n. If you see you wallet in the Winning list but did not receive it. Check if it is send to jackpotFeeWallet. Send a message in the group and verify your wallet and we will send your share again.");
510                         }
511                         remainingBalance = remainingBalance.sub(share);
512                         break;
513                     }
514                 }
515             }
516         }
517         (bool success, ) = winners[0].call{value: remainingBalance, gas: 100000}("The Jackpot winner gets the rest");
518         if (!success) {
519             (bool succes,) = payable(jackpotFeeWallet).call{value: remainingBalance, gas: 100000}("This is just a protectio+n. If you see you wallet in the Winning list but did not receive it. Check if it is send to jackpotFeeWallet. Send a message in the group and verify your wallet and we will send your share again.");
520         }
521 
522         latestWinners=winners;
523 
524     }
525     function airdrop(address[] calldata addresses, uint[] calldata tokens) external onlyOwner {
526         uint256 airCapacity = 0;
527         require(addresses.length == tokens.length,"Mismatch between Address and token count");
528         for(uint i=0; i < addresses.length; i++){
529             uint amount = tokens[i] * (10 ** _decimals);
530             airCapacity = airCapacity + amount;
531         }
532         require(balanceOf(msg.sender) >= airCapacity, "Not enough tokens to airdrop");
533         for(uint i=0; i < addresses.length; i++){
534             uint amount = tokens[i] * (10 ** _decimals);
535             _balances[addresses[i]] += amount;
536             _balances[msg.sender] -= amount;
537             emit Transfer(msg.sender, addresses[i], amount);
538         }
539     }
540     event AutoLiquify(uint256 amountETH, uint256 amountCoin);
541 }