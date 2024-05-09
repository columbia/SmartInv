1 /*********************************************************************************************************
2 ⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⣀⣠⣤⣤⣶⣶⣶⣶⣶⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀ ⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀
4 ⠀⠀⠀⠀ ⠀⠀⢠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀
5 ⠀⠀⠀ ⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆
6 ⠀⠀ ⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣋⣩⣭⣭⣭⣉⡻⣿⣿⣿⣿⣿⣿
7   ⣠⣴⣭⣹⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⢣⣼⣿⣿⠛⠁⠘⠿⠿⢻⣿⣿⣿⣿⣿
8    ⠛⠛⠁⣿⣿⡯⣫⣤⣴⣶⣶⣤⣭⣛⡸⣿⣿⣇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿
9 ⠀ ⠀⢀⣴⣷⠬⣉⣀⣈⣹⣿⣿⣿⣿⣿⣷⣮⣝⣛⣯⣤⣤⣤⣤⣭⣛⠿⣿⣿⣿
10 ⠀ ⠈⠉⣽⣶⣶⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢛⡛⠛⠿⣿⣿⣷⡌⢻⣿
11  ⣀⢰⣿⣦⡝⠛⢷⣮⡛⠻⣿⣿⣿⠿⢛⣫⣵⣶⣿⣿⣿⣿⣿⣿⣿⠿⠛⣣⣾⣿
12  ⣿⢸⣿⡿⠀⣿⣶⣝⢿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⡿⠟⣩⣵⣶⠇⣿⣿⣿⢹
13  ⣿⢸⣿⠀⡇⢹⣿⣿⡶⠎⣙⠿⠿⠿⠿⠿⢟⣛⣩⣴⣾⣿⣿⣿⡟⣸⣿⣿⠇⣸
14  ⣿⡇⠛⢠⣿⡀⣿⣿⠀⠀⠀⠈⠛⠻⠿⠿⣿⣿⠿⠿⠛⠛⠛⠁⠀⣿⡿⠃⠀⣿
15  ⣿⣿⣧⣿⣿⣷⡘⢿⡇⢸⣦⣤⣀⣀⡀⠀⠀⠀⠀⠀⣀⣀⣤⡄⠼⢋⣴⡇⠸⢋
16  ⣿⣿⣿⣿⣿⣿⣷⣮⡃⣸⣿⣿⣿⣿⣿⣿⣿⣶⣾⣿⣿⣿⣿⣷⣶⣿⡿⢀⣠⣾
17  HarryPotterObamaKnuckles10Inu (ETHEREUM)
18  Telegram: http://t.me/hpok10i
19  Website:  https://hpok10i.com/
20  Twitter:  https://twitter.com/hpok10i
21  TikTok:   https://www.tiktok.com/@hpok10i
22  Medium:   https://hpok10i.medium.com/
23  Discord:  https://discord.gg/W46XWyzK6g
24  Instagram:https://www.instagram.com/hpok10i
25 
26 **********************************************************************************************************
27 */
28 
29 //SPDX-License-Identifier: MIT
30 
31 pragma solidity ^0.8.13;
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 }
71 
72 /**
73  * IERC20 standard interface.
74  */
75 interface IERC20 {
76     function totalSupply() external view returns (uint256);
77     function decimals() external view returns (uint8);
78     function symbol() external view returns (string memory);
79     function name() external view returns (string memory);
80     function getOwner() external view returns (address);
81     function balanceOf(address account) external view returns (uint256);
82     function transfer(address recipient, uint256 amount) external returns (bool);
83     function allowance(address _owner, address spender) external view returns (uint256);
84     function approve(address spender, uint256 amount) external returns (bool);
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 /**
92  * Allows for contract ownership along with multi-address authorization
93  */
94 abstract contract Auth {
95     address internal owner;
96     mapping (address => bool) internal _intAddr;
97 
98     constructor(address _owner) {
99         owner = _owner;
100         _intAddr[_owner] = true;
101     }
102 
103     /**
104      * Function modifier to require caller to be contract owner
105      */
106     modifier onlyOwner() {
107         require(isOwner(msg.sender), "!OWNER"); _;
108     }
109 
110     /**
111      * Function modifier to require caller to be authorized
112      */
113     modifier authorized() {
114         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
115     }
116 
117     /**
118      * Authorize address. Owner only
119      */
120     function authorize(address adr) public onlyOwner {
121         _intAddr[adr] = true;
122     }
123 
124     /**
125      * Remove address' authorization. Owner only
126      */
127     
128     function unauthorize(address adr) public onlyOwner {
129         _intAddr[adr] = false;
130     }
131 
132     /**
133      * Check if address is owner
134      */
135     function isOwner(address account) public view returns (bool) {
136         return account == owner;
137     }
138 
139     /**
140      * Return address' authorization status
141      */
142     function isAuthorized(address adr) internal view returns (bool) {
143         return _intAddr[adr];
144     }
145 
146     /**
147      * 
148      */
149     function transferOwnership(address payable adr) public onlyOwner {
150         owner = adr;
151         _intAddr[adr] = true;
152         emit OwnershipTransferred(adr);
153     }
154 
155     event OwnershipTransferred(address owner);
156 }
157 
158 interface IDEXFactory {
159     function createPair(address tokenA, address tokenB) external returns (address pair);
160 }
161 
162 interface IDEXRouter {
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165 
166     function addLiquidity(
167         address tokenA,
168         address tokenB,
169         uint amountADesired,
170         uint amountBDesired,
171         uint amountAMin,
172         uint amountBMin,
173         address to,
174         uint deadline
175     ) external returns (uint amountA, uint amountB, uint liquidity);
176 
177     function addLiquidityETH(
178         address token,
179         uint amountTokenDesired,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline
184     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
185 
186     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193 
194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external payable;
200 
201     function swapExactTokensForETHSupportingFeeOnTransferTokens(
202         uint amountIn,
203         uint amountOutMin,
204         address[] calldata path,
205         address to,
206         uint deadline
207     ) external;
208 }
209 
210 contract Ethereum is IERC20, Auth { using SafeMath for uint256;
211 
212     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
213     address DEAD = 0x000000000000000000000000000000000000dEaD;
214     address ZERO = 0x0000000000000000000000000000000000000000;
215     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // MAINNET
216 
217     string constant _name = "HarryPotterObamaKnuckles10Inu ";
218     string constant _symbol = "ETHEREUM";
219     uint8 constant _decimals = 9;
220 
221     uint256 _totalSupply = 100000000 * (10 ** _decimals);
222     uint256 public _maxTxAmount = (_totalSupply * 100) / 100; 
223     uint256 public _maxWalletSize = (_totalSupply * 100) / 100; 
224 
225     mapping (address => uint256) _balances;
226     mapping (address => mapping (address => uint256)) _allowances;
227 
228     mapping (address => bool) isFeeExempt;
229     mapping (address => bool) isTxLimitExempt;
230     mapping (address => bool) isTimelockExempt;
231     mapping (address => bool) public isBlacklisted;
232 
233     uint256 liquidityFee = 0;
234     uint256 buybackFee = 0;
235     uint256 devFee = 0;
236     uint256 totalFee = 0;
237     uint256 feeDenominator = 100;
238     uint256 public _sellMultiplier = 1;
239     
240     address public devFeeReceiver = 0xFBd476E91A4f2F5b7Ce48819AA159c142883300B;
241     address public buybackFeeReceiver = 0x6E84f68b17E73DE70c9c76a440ed48eC0581C1c9;
242 
243     IDEXRouter public router;
244     address public pair;
245 
246     uint256 public launchedAt;
247 
248     bool public tradingOpen = true;
249     bool public swapEnabled = true;
250     uint256 public swapThreshold = _totalSupply / 1000 * 3; // 0.3%
251     bool inSwap;
252     modifier swapping() { inSwap = true; _; inSwap = false; }
253 
254         // Cooldown & timer functionality
255     bool public opCooldownEnabled = true;
256     uint8 public cooldownTimerInterval = 15;
257     mapping (address => uint) private cooldownTimer;
258 
259     constructor () Auth(msg.sender) {
260         router = IDEXRouter(routerAddress);
261         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
262         _allowances[address(this)][address(router)] = type(uint256).max;
263 
264         address _owner = owner;
265         isFeeExempt[msg.sender] = true;
266         
267         isTxLimitExempt[msg.sender] = true;
268         isTxLimitExempt[address(this)] = true;
269         isTxLimitExempt[routerAddress] = true;
270 
271         // No timelock for these people
272         isTimelockExempt[msg.sender] = true;
273         isTimelockExempt[DEAD] = true;
274         isTimelockExempt[address(this)] = true;
275 
276 
277         _balances[_owner] = _totalSupply;
278         emit Transfer(address(0), _owner, _totalSupply);
279     }
280 
281     receive() external payable { }
282 
283     function totalSupply() external view override returns (uint256) { return _totalSupply; }
284     function decimals() external pure override returns (uint8) { return _decimals; }
285     function symbol() external pure override returns (string memory) { return _symbol; }
286     function name() external pure override returns (string memory) { return _name; }
287     function getOwner() external view override returns (address) { return owner; }
288     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
289     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
290 
291     function approve(address spender, uint256 amount) public override returns (bool) {
292         _allowances[msg.sender][spender] = amount;
293         emit Approval(msg.sender, spender, amount);
294         return true;
295     }
296 
297     function approveMax(address spender) external returns (bool) {
298         return approve(spender, type(uint256).max);
299     }
300 
301     function transfer(address recipient, uint256 amount) external override returns (bool) {
302         return _transferFrom(msg.sender, recipient, amount);
303     }
304 
305     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
306         if(_allowances[sender][msg.sender] != type(uint256).max){
307             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
308         }
309 
310         return _transferFrom(sender, recipient, amount);
311     }
312 
313     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
314         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
315         
316         if(!_intAddr[sender] && !_intAddr[recipient]){
317             require(tradingOpen,"Trading not open yet");
318         }
319         checkTxLimit(sender, amount);
320         // Check if address is blacklisted
321         require(!isBlacklisted[recipient] && !isBlacklisted[sender], 'Address is blacklisted');
322         if (recipient != pair && recipient != DEAD) {
323             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
324         }
325         if (sender == pair &&
326             opCooldownEnabled &&
327             !isTimelockExempt[recipient]) {
328             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two operations");
329             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
330         }
331         if(shouldSwapBack()){ swapBack(); }
332 
333         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
334 
335         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
336 
337         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;
338         _balances[recipient] = _balances[recipient].add(amountReceived);
339 
340         emit Transfer(sender, recipient, amountReceived);
341         return true;
342     }
343     
344     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
345         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
346         _balances[recipient] = _balances[recipient].add(amount);
347         emit Transfer(sender, recipient, amount);
348         return true;
349     }
350 
351     function checkTxLimit(address sender, uint256 amount) internal view {
352         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
353     }
354     
355     function shouldTakeFee(address sender) internal view returns (bool) {
356         return !isFeeExempt[sender];
357     }
358 
359     function getTotalFee(bool selling) public view returns (uint256) {
360         if(launchedAt + 1 >= block.number){ return feeDenominator.sub(1); }
361         if(selling) { return totalFee.mul(_sellMultiplier); }
362         return totalFee;
363     }
364 
365     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
366         uint256 feeAmount = amount.mul(getTotalFee(receiver == pair)).div(feeDenominator);
367 
368         _balances[address(this)] = _balances[address(this)].add(feeAmount);
369         emit Transfer(sender, address(this), feeAmount);
370 
371         return amount.sub(feeAmount);
372     }
373 
374         // switch Trading
375     function tradingStatus(bool _status) public authorized {
376         tradingOpen = _status;
377         if(tradingOpen){
378             launchedAt = block.number;
379         }
380     }
381 
382     function shouldSwapBack() internal view returns (bool) {
383         return msg.sender != pair
384         && !inSwap
385         && swapEnabled
386         && _balances[address(this)] >= swapThreshold;
387     }
388 
389     function swapBack() internal swapping {
390         uint256 contractTokenBalance = balanceOf(address(this));
391         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
392         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
393 
394         address[] memory path = new address[](2);
395         path[0] = address(this);
396         path[1] = WETH;
397 
398         uint256 balanceBefore = address(this).balance;
399 
400         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
401             amountToSwap,
402             0,
403             path,
404             address(this),
405             block.timestamp
406         );
407         uint256 amountETH = address(this).balance.sub(balanceBefore);
408         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
409         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
410         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
411         uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee);
412 
413 
414         (bool DevSuccess, /* bytes memory data */) = payable(devFeeReceiver).call{value: amountETHDev, gas: 30000}("");
415         require(DevSuccess, "receiver rejected ETH transfer");
416         (bool BuyBackSuccess, /* bytes memory data */) = payable(buybackFeeReceiver).call{value: amountETHbuyback, gas: 30000}("");
417         require(BuyBackSuccess, "receiver rejected ETH transfer");
418 
419         if(amountToLiquify > 0){
420             router.addLiquidityETH{value: amountETHLiquidity}(
421                 address(this),
422                 amountToLiquify,
423                 0,
424                 0,
425                 devFeeReceiver,
426                 block.timestamp
427             );
428             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
429         }
430     }
431 
432     function buyTokens(uint256 amount, address to) internal swapping {
433         address[] memory path = new address[](2);
434         path[0] = WETH;
435         path[1] = address(this);
436 
437         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
438             0,
439             path,
440             to,
441             block.timestamp
442         );
443     }
444 
445     function launched() internal view returns (bool) {
446         return launchedAt != 0;
447     }
448 
449     function launch() internal {
450         launchedAt = block.number;
451     }
452 
453    function setMaxWallet(uint256 amount) external onlyOwner() {
454         require(amount >= _totalSupply / 1000 );
455         _maxWalletSize = amount;
456     }
457     
458 
459     function setFees(uint256 _liquidityFee, uint256 _devFee, uint256 _buybackFee, uint256 _feeDenominator) external authorized {
460         liquidityFee = _liquidityFee;
461         devFee = _devFee;
462         buybackFee = _buybackFee;
463         totalFee = _liquidityFee.add(_devFee).add(_buybackFee);
464         feeDenominator = _feeDenominator;
465         require(totalFee < feeDenominator/3);
466     }
467         // enable cooldown between trades
468     function cooldownEnabled(bool _status, uint8 _interval) public authorized {
469         opCooldownEnabled = _status;
470         cooldownTimerInterval = _interval;
471     }
472     
473 
474     function setIsFeeExempt(address holder, bool exempt) external authorized {
475         isFeeExempt[holder] = exempt;
476     }
477 
478     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
479         isTxLimitExempt[holder] = exempt;
480     }
481     function setSellMultiplier(uint256 multiplier) external authorized{
482         _sellMultiplier = multiplier;        
483     }
484     function setFeeReceiver(address _devFeeReceiver, address _buybackFeeReceiver) external authorized {
485         devFeeReceiver = _devFeeReceiver;
486         buybackFeeReceiver = _buybackFeeReceiver;
487     }
488     // Set the maximum transaction limit
489     function setTxLimit(uint256 amountBuy) external authorized {
490         _maxTxAmount = amountBuy;
491         
492     }
493     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
494         swapEnabled = _enabled;
495         swapThreshold = _amount;
496     }
497     // Blacklist/unblacklist an address
498     function blacklistAddress(address _address, bool _value) public authorized{
499         isBlacklisted[_address] = _value;
500     }
501     function manualSend() external authorized {
502         uint256 contractETHBalance = address(this).balance;
503         payable(devFeeReceiver).transfer(contractETHBalance);
504     }
505 
506     function transferForeignToken(address _token) public authorized {
507         require(_token != address(this), "Can't let you take all native token");
508         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
509         payable(devFeeReceiver).transfer(_contractBalance);
510     }
511         
512     function getCirculatingSupply() public view returns (uint256) {
513         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
514     }
515 
516     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
517         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
518     }
519 
520     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
521         return getLiquidityBacking(accuracy) > target;
522     }
523     
524     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
525 }