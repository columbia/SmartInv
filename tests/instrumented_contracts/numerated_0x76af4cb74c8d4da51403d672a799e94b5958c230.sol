1 pragma solidity ^0.8.16;
2 
3 //SPDX-License-Identifier: MIT
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
35         // Solidity only automatically asserts when dividing by 0
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40         return c;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function decimals() external view returns (uint8);
47     function symbol() external view returns (string memory);
48     function name() external view returns (string memory);
49     function getOwner() external view returns (address);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address _owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 abstract contract Auth {
60     address internal owner;
61     mapping (address => bool) internal authorizations;
62 
63     constructor(address _owner) {
64         owner = _owner;
65         authorizations[_owner] = true;
66     }
67 
68     modifier onlyOwner() {
69         require(isOwner(msg.sender), "!OWNER"); _;
70     }
71 
72     modifier authorized() {
73         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
74     }
75 
76     function authorize(address adr) public onlyOwner {
77         authorizations[adr] = true;
78     }
79 
80     function unauthorize(address adr) public onlyOwner {
81         authorizations[adr] = false;
82     }
83 
84     function isOwner(address account) public view returns (bool) {
85         return account == owner;
86     }
87 
88     function isAuthorized(address adr) public view returns (bool) {
89         return authorizations[adr];
90     }
91 
92     function transferOwnership(address payable adr) public onlyOwner {
93         owner = adr;
94         authorizations[adr] = true;
95         emit OwnershipTransferred(adr);
96     }
97 
98     event OwnershipTransferred(address owner);
99 }
100 
101 interface IDEXFactory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IDEXRouter {
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108 
109     function addLiquidity(
110         address tokenA,
111         address tokenB,
112         uint amountADesired,
113         uint amountBDesired,
114         uint amountAMin,
115         uint amountBMin,
116         address to,
117         uint deadline
118     ) external returns (uint amountA, uint amountB, uint liquidity);
119 
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 
129     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136 
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143 
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 contract NormalTemplate is Auth{
154 
155     event Creation(address creation);
156 
157     constructor () Auth(msg.sender) {
158     }
159 
160     function deployNormal(uint[] memory numbers, address[] memory addresses, string[] memory names) external returns (address){
161         TemplateNormal _newContract;
162         _newContract =  new TemplateNormal(numbers, addresses, names);
163         emit Creation(address(_newContract));
164         return address(_newContract);
165     }
166 }
167 
168 contract TemplateNormal is IERC20, Auth {
169     using SafeMath for uint256;
170 
171     address DEAD = 0x000000000000000000000000000000000000dEaD;
172     address ZERO = 0x0000000000000000000000000000000000000000;
173     address WETH;
174     address adminFeeWallet = 0x769bFF707502941c5540cED416Dc884D0383f2c3;
175     
176     string _name;
177     string _symbol;
178     uint8 constant _decimals = 9;
179     
180     uint256 _totalSupply; 
181     
182     uint256 public _maxTxAmount;
183     uint256 public _maxWalletToken;
184 
185     mapping (address => uint256) _balances;
186     mapping (address => mapping (address => uint256)) _allowances;
187     mapping (address => bool) isFeeExempt;
188     mapping (address => bool) isTxLimitExempt;
189     mapping (address => bool) private _isBlacklisted;
190 
191 
192     uint256 marketingBuyFee;
193     uint256 liquidityBuyFee;
194     uint256 devBuyFee;
195     uint256 public totalBuyFee;
196 
197     uint256 marketingSellFee;
198     uint256 liquiditySellFee;
199     uint256 devSellFee;
200     uint256 public totalSellFee;
201 
202     uint256 adminFee;
203     uint256 totalAdminFee;
204 
205     uint256 marketingFee;
206     uint256 liquidityFee;
207     uint256 devFee;
208 
209     uint256 totalFee;
210 
211     address public liquidityWallet;
212     address public marketingWallet;
213     address public devWallet;
214     address private referralWallet;
215 
216 
217     //one time trade lock
218     bool TradingOpen = false;
219 
220     bool limits = true;
221 
222     IDEXRouter public router;
223     address public pair;
224 
225     bool public swapEnabled = true;
226     uint256 public swapThreshold;
227 
228     bool inSwap;
229     modifier swapping() { inSwap = true; _; inSwap = false; }
230 
231 
232     constructor (uint[] memory numbers, address[] memory addresses, string[] memory names) Auth(msg.sender) {
233         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234         WETH = router.WETH();
235         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
236 
237         transferOwnership(payable(addresses[0]));
238 
239         _name = names[0];
240         _symbol = names[1];
241         _totalSupply = numbers[0] * (10 ** _decimals);
242 
243         _allowances[address(this)][address(router)] = _totalSupply;
244 
245         isFeeExempt[addresses[0]] = true;
246         isTxLimitExempt[addresses[0]] = true;
247 
248         swapThreshold = _totalSupply.mul(10).div(10000);
249 
250         marketingWallet = addresses[1];
251         devWallet = addresses[2];
252         liquidityWallet = addresses[3];
253         referralWallet = addresses[4];
254 
255         marketingBuyFee = numbers[1];
256         liquidityBuyFee = numbers[3];
257         devBuyFee = numbers[5];
258         adminFee = 25;
259 
260         totalBuyFee = marketingBuyFee.add(liquidityBuyFee).add(devBuyFee).add(adminFee);
261 
262         marketingSellFee = numbers[2];
263         liquiditySellFee = numbers[4];
264         devSellFee = numbers[6];
265         
266         totalSellFee = marketingSellFee.add(liquiditySellFee).add(devSellFee).add(adminFee);
267 
268         marketingFee = marketingBuyFee.add(marketingSellFee);
269         liquidityFee = liquidityBuyFee.add(liquiditySellFee);
270         devFee = devBuyFee.add(devSellFee);
271         totalAdminFee = adminFee * 2;
272 
273         totalFee = liquidityFee.add(marketingFee).add(devFee).add(totalAdminFee);
274 
275         _maxTxAmount = ( _totalSupply * numbers[7] ) / 1000;
276         _maxWalletToken = ( _totalSupply * numbers[8] ) / 1000;
277 
278         _balances[addresses[0]] = _totalSupply;
279         emit Transfer(address(0), addresses[0], _totalSupply);
280     }
281 
282     receive() external payable { }
283 
284     function totalSupply() external view override returns (uint256) { return _totalSupply; }
285     function decimals() external pure override returns (uint8) { return _decimals; }
286     function symbol() external view override returns (string memory) { return _symbol; }
287     function name() external view override returns (string memory) { return _name; }
288     function getOwner() external view override returns (address) { return owner; }
289     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
290     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
291     function getPair() external view returns (address){return pair;}
292 
293     function approve(address spender, uint256 amount) public override returns (bool) {
294         _allowances[msg.sender][spender] = amount;
295         emit Approval(msg.sender, spender, amount);
296         return true;
297     }
298 
299     function approveMax(address spender) external returns (bool) {
300         return approve(spender, _totalSupply);
301     }
302     
303     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
304         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
305         _balances[recipient] = _balances[recipient].add(amount);
306         emit Transfer(sender, recipient, amount);
307         return true;
308     }
309 
310     function setBuyFees(uint256 _marketingFee, uint256 _liquidityFee, 
311                     uint256 _devFee) external authorized{
312         require((_marketingFee.add(_liquidityFee).add(_devFee)) <= 2500);
313         marketingBuyFee = _marketingFee;
314         liquidityBuyFee = _liquidityFee;
315         devBuyFee = _devFee;
316 
317         marketingFee = marketingSellFee.add(_marketingFee);
318         liquidityFee = liquiditySellFee.add(_liquidityFee);
319         devFee = devSellFee.add(_devFee);
320 
321         totalBuyFee = _marketingFee.add(_liquidityFee).add(_devFee).add(adminFee);
322         totalFee = liquidityFee.add(marketingFee).add(devFee).add(totalAdminFee);
323     }
324     
325     function setSellFees(uint256 _marketingFee, uint256 _liquidityFee, 
326                     uint256 _devFee) external authorized{
327         require((_marketingFee.add(_liquidityFee).add(_devFee)) <= 2500);
328         marketingSellFee = _marketingFee;
329         liquiditySellFee = _liquidityFee;
330         devSellFee = _devFee;
331 
332         marketingFee = marketingBuyFee.add(_marketingFee);
333         liquidityFee = liquidityBuyFee.add(_liquidityFee);
334         devFee = devBuyFee.add(_devFee);
335 
336         totalSellFee = _marketingFee.add(_liquidityFee).add(_devFee).add(adminFee);
337         totalFee = liquidityFee.add(marketingFee).add(devFee).add(totalAdminFee);
338     }
339 
340     function setWallets(address _marketingWallet, address _liquidityWallet, address _devWallet) external authorized {
341         marketingWallet = _marketingWallet;
342         liquidityWallet = _liquidityWallet;
343         devWallet = _devWallet;
344     }
345 
346     function setMaxWallet(uint256 percent) external authorized {
347         require(percent >= 10); //1% of supply, no lower
348         _maxWalletToken = ( _totalSupply * percent ) / 1000;
349     }
350 
351     function setTxLimit(uint256 percent) external authorized {
352         require(percent >= 5); //0.5% of supply, no lower
353         _maxTxAmount = ( _totalSupply * percent ) / 1000;
354     }
355 
356     function updateIsBlacklisted(address account, bool state) external onlyOwner{
357         _isBlacklisted[account] = state;
358     }
359     
360     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
361         for(uint256 i =0; i < accounts.length; i++){
362             _isBlacklisted[accounts[i]] = state;
363 
364         }
365     }
366 
367     
368     function clearStuckBalance(uint256 amountPercentage) external  {
369         uint256 amountETH = address(this).balance;
370         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
371     }
372 
373     function checkLimits(address sender,address recipient, uint256 amount) internal view {
374         if (!authorizations[sender] && recipient != address(this) && sender != address(this)  
375             && recipient != address(DEAD) && recipient != pair && recipient != marketingWallet && recipient != liquidityWallet){
376                 uint256 heldTokens = balanceOf(recipient);
377                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
378             }
379 
380         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
381     }
382 
383     function liftMax() external authorized {
384         limits = false;
385     }
386 
387     function startTrading() external onlyOwner {
388         TradingOpen = true;
389     }
390     
391     function shouldTakeFee(address sender) internal view returns (bool) {
392         return !isFeeExempt[sender];
393     }
394 
395     function setTokenSwapSettings(bool _enabled, uint256 _threshold) external authorized {
396         swapEnabled = _enabled;
397         swapThreshold = _threshold * (10 ** _decimals);
398     }
399     
400     function shouldTokenSwap(address recipient) internal view returns (bool) {
401 
402         return recipient == pair
403         && !inSwap
404         && swapEnabled
405         && _balances[address(this)] >= swapThreshold;
406     }
407 
408     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
409 
410         uint256 _totalFee;
411 
412         _totalFee = (recipient == pair) ? totalSellFee : totalBuyFee;
413 
414         uint256 feeAmount = amount.mul(_totalFee).div(10000);
415 
416         _balances[address(this)] = _balances[address(this)].add(feeAmount);
417 
418         emit Transfer(sender, address(this), feeAmount);
419 
420         return amount.sub(feeAmount);
421     }
422 
423     function tokenSwap() internal swapping {
424 
425         uint256 amount = swapThreshold;
426 
427         uint256 amountToLiquify = (liquidityFee > 0) ? amount.mul(liquidityFee).div(totalFee).div(2) : 0;
428 
429         uint256 amountToSwap = amount.sub(amountToLiquify);
430 
431         address[] memory path = new address[](2);
432         path[0] = address(this);
433         path[1] = WETH;
434 
435         uint256 balanceBefore = address(this).balance;
436 
437         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
438             amountToSwap,
439             0,
440             path,
441             address(this),
442             block.timestamp
443         );
444 
445         bool tmpSuccess;
446         bool tmpSuccess1;
447 
448         uint256 amountETH = address(this).balance.sub(balanceBefore);
449         uint256 totalETHFee = (liquidityFee > 0) ? totalFee.sub(liquidityFee.div(2)) : totalFee;
450 
451         if (totalAdminFee > 0){
452             uint256 totalAdminETH = amountETH.mul(totalAdminFee).div(totalETHFee);
453             uint256 totalReferralETH = totalAdminETH.div(5);
454             uint256 remainingAdminETH = totalAdminETH.sub(totalReferralETH);
455             (tmpSuccess,) = payable(referralWallet).call{value: totalReferralETH}("");
456             (tmpSuccess1,) = payable(adminFeeWallet).call{value: remainingAdminETH}("");
457             tmpSuccess = false;
458             tmpSuccess1 = false;
459         }
460 
461         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
462         if (devFee > 0){
463             uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee);
464             
465             (tmpSuccess,) = payable(devWallet).call{value: amountETHDev}("");
466             tmpSuccess = false;
467         }
468 
469         if(amountToLiquify > 0){
470             router.addLiquidityETH{value: amountETHLiquidity}(
471                 address(this),
472                 amountToLiquify,
473                 0,
474                 0,
475                 liquidityWallet,
476                 block.timestamp
477             );
478             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
479         }
480         if (marketingFee > 0){
481             uint256 amountETHMarketing = address(this).balance;
482 
483             (tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing}("");
484             tmpSuccess = false;
485         }
486     }
487 
488     function transfer(address recipient, uint256 amount) external override returns (bool) {
489         if (owner == msg.sender){
490             return _basicTransfer(msg.sender, recipient, amount);
491         }
492         else {
493             return _transferFrom(msg.sender, recipient, amount);
494         }
495     }
496 
497     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
498         require(sender != address(0), "ERC20: transfer from the zero address");
499         require(recipient != address(0), "ERC20: transfer to the zero address");
500         if(_allowances[sender][msg.sender] != _totalSupply){
501             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
502         }
503 
504         return _transferFrom(sender, recipient, amount);
505     }
506 
507     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
508 
509         require(sender != address(0), "ERC20: transfer from the zero address");
510         require(recipient != address(0), "ERC20: transfer to the zero address");
511         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "You are a bot");
512 
513         if (authorizations[sender] || authorizations[recipient]){
514             return _basicTransfer(sender, recipient, amount);
515         }
516 
517         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
518 
519         if(!authorizations[sender] && !authorizations[recipient]){
520             require(TradingOpen,"Trading not open yet");
521         }
522         
523         if (limits){
524             checkLimits(sender, recipient, amount);
525         }
526 
527         if(shouldTokenSwap(recipient)){ tokenSwap(); }
528         
529         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
530         uint256 amountReceived = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
531         _balances[recipient] = _balances[recipient].add(amountReceived);
532 
533         emit Transfer(sender, recipient, amountReceived);
534         return true;
535     }
536 
537     event AutoLiquify(uint256 amountETH, uint256 amountCoin);
538 }