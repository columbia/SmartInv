1 /*
2 From Pibull 
3 Made Chicky to became the biggest community bird meme 2023 
4 hope chicky get in hands to same community like pitbull which pushed us to a billion mc
5 */
6 pragma solidity 0.8.17;
7 
8 //SPDX-License-Identifier: MIT
9 
10 
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         // Solidity only automatically asserts when dividing by 0
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45 
46         return c;
47     }
48 }
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 abstract contract Auth {
66     address internal owner;
67     mapping (address => bool) internal authorizations;
68 
69     constructor(address _owner) {
70         owner = _owner;
71         authorizations[_owner] = true;
72     }
73 
74     modifier onlyOwner() {
75         require(isOwner(msg.sender), "!OWNER"); _;
76     }
77 
78     modifier authorized() {
79         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
80     }
81 
82     function authorize(address adr) public onlyOwner {
83         authorizations[adr] = true;
84     }
85 
86     function unauthorize(address adr) public onlyOwner {
87         authorizations[adr] = false;
88     }
89 
90     function isOwner(address account) public view returns (bool) {
91         return account == owner;
92     }
93 
94     function isAuthorized(address adr) public view returns (bool) {
95         return authorizations[adr];
96     }
97 
98     function transferOwnership(address payable adr) public onlyOwner {
99         owner = adr;
100         authorizations[adr] = true;
101         emit OwnershipTransferred(adr);
102     }
103 
104     event OwnershipTransferred(address owner);
105 }
106 
107 interface IDEXFactory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IDEXRouter {
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114 
115     function addLiquidity(
116         address tokenA,
117         address tokenB,
118         uint amountADesired,
119         uint amountBDesired,
120         uint amountAMin,
121         uint amountBMin,
122         address to,
123         uint deadline
124     ) external returns (uint amountA, uint amountB, uint liquidity);
125 
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 
135     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142 
143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external payable;
149 
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157 }
158 
159 contract Chickyinu is IERC20 , Auth {
160     using SafeMath for uint256;
161 
162     address DEAD = 0x000000000000000000000000000000000000dEaD;
163     address ZERO = 0x0000000000000000000000000000000000000000;
164     
165     string constant _name = "ChickyInu";
166     string constant _symbol = "CHICKY";
167     uint8 constant _decimals = 9;
168     
169     uint256 _totalSupply = 1 * (10**6) * (10 ** _decimals);
170     
171     uint256 public _maxTxAmount = _totalSupply.mul(10).div(1000); //
172     uint256 public _maxWalletToken =  _totalSupply.mul(10).div(1000); //
173 
174     mapping (address => uint256) _balances;
175     mapping (address => mapping (address => uint256)) _allowances;
176 
177     mapping (address => bool) isFeeExempt;
178     mapping (address => bool) isTxLimitExempt;
179 
180     //fees are set with a 10x multiplier to allow for 2.5 etc. Denominator of 1000
181     uint256 marketingBuyFee = 70;
182     uint256 liquidityBuyFee = 30;
183     uint256 devBuyFee = 20;
184     uint256 public totalBuyFee = marketingBuyFee.add(liquidityBuyFee).add(devBuyFee);
185 
186     uint256 marketingSellFee = 70;
187     uint256 liquiditySellFee = 30;
188     uint256 devSellFee = 20;
189     uint256 public totalSellFee = marketingSellFee.add(liquiditySellFee).add(devSellFee);
190 
191     uint256 marketingFee = marketingBuyFee.add(marketingSellFee);
192     uint256 liquidityFee = liquidityBuyFee.add(liquiditySellFee);
193     uint256 devFee = devBuyFee.add(devSellFee);
194 
195     uint256 totalFee = liquidityFee.add(marketingFee).add(devFee);
196 
197     address public liquidityWallet;
198     address public marketingWallet;
199     address public devWallet;
200 
201     //one time trade lock
202     bool lockTilStart = true;
203     bool lockUsed = false;
204 
205     //contract cant be tricked into spam selling exploit
206     uint256 cooldownSeconds = 1;
207     uint256 lastSellTime;
208 
209     event LockTilStartUpdated(bool enabled);
210 
211     IDEXRouter public router;
212     address public pair;
213 
214     bool public swapEnabled = true;
215     uint256 public swapThreshold = _totalSupply.mul(10).div(100000);
216     uint256 swapRatio = 40;
217     bool ratioSell = true;
218 
219     bool inSwap;
220     modifier swapping() { inSwap = true; _; inSwap = false; }
221 
222 
223     constructor () Auth(msg.sender) {
224         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225         pair = IDEXFactory(router.factory()).createPair(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));
226         _allowances[address(this)][address(router)] = _totalSupply;
227 
228         isFeeExempt[msg.sender] = true;
229         isTxLimitExempt[msg.sender] = true;
230 
231     liquidityWallet = 0x3695a987428522157E6884Eaf085fD6EA3a0Ca3F;
232     marketingWallet = 0x50C31E1a422f620B18F12EFF6Dd22424FD5b0f74;
233     devWallet = 0xC1B96367D84C7747D76Fec8ff8Ecabc2EBC7e22b;
234 
235         approve(address(router), _totalSupply);
236         approve(address(pair), _totalSupply);
237         _balances[msg.sender] = _totalSupply;
238         emit Transfer(address(0), msg.sender, _totalSupply);
239     }
240 
241     receive() external payable { }
242 
243     function totalSupply() external view override returns (uint256) { return _totalSupply; }
244     function decimals() external pure override returns (uint8) { return _decimals; }
245     function symbol() external pure override returns (string memory) { return _symbol; }
246     function name() external pure override returns (string memory) { return _name; }
247     function getOwner() external view override returns (address) { return owner; }
248     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
249     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
250     function getPair() external view returns (address){return pair;}
251 
252     function approve(address spender, uint256 amount) public override returns (bool) {
253         _allowances[msg.sender][spender] = amount;
254         emit Approval(msg.sender, spender, amount);
255         return true;
256     }
257 
258     function approveMax(address spender) external returns (bool) {
259         return approve(spender, _totalSupply);
260     }
261     
262     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
263         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
264         _balances[recipient] = _balances[recipient].add(amount);
265         emit Transfer(sender, recipient, amount);
266         return true;
267     }
268 
269     function setBuyFees(uint256 _marketingFee, uint256 _liquidityFee, 
270                     uint256 _devFee) external authorized{
271         require((_marketingFee.add(_liquidityFee).add(_devFee)) <= 150);
272         marketingBuyFee = _marketingFee;
273         liquidityBuyFee = _liquidityFee;
274         devBuyFee = _devFee;
275 
276         marketingFee = marketingSellFee.add(_marketingFee);
277         liquidityFee = liquiditySellFee.add(_liquidityFee);
278         devFee = devSellFee.add(_devFee);
279 
280         totalBuyFee = _marketingFee.add(_liquidityFee).add(_devFee);
281         totalFee = liquidityFee.add(marketingFee).add(devFee);
282     }
283     
284     function setSellFees(uint256 _marketingFee, uint256 _liquidityFee, 
285                     uint256 _devFee) external authorized{
286         require((_marketingFee.add(_liquidityFee).add(_devFee)) <= 150);
287         marketingSellFee = _marketingFee;
288         liquiditySellFee = _liquidityFee;
289         devSellFee = _devFee;
290 
291         marketingFee = marketingBuyFee.add(_marketingFee);
292         liquidityFee = liquidityBuyFee.add(_liquidityFee);
293         devFee = devBuyFee.add(_devFee);
294 
295         totalSellFee = _marketingFee.add(_liquidityFee).add(_devFee);
296         totalFee = liquidityFee.add(marketingFee).add(devFee);
297     }
298 
299     function setWallets(address _marketingWallet, address _liquidityWallet, address _devWallet) external authorized {
300         marketingWallet = _marketingWallet;
301         liquidityWallet = _liquidityWallet;
302         devWallet = _devWallet;
303     }
304 
305     function setMaxWallet(uint256 percent) external authorized {
306         require(percent >= 5); //0.5% of supply, no lower
307         _maxWalletToken = ( _totalSupply * percent ) / 1000;
308     }
309 
310     function setTxLimit(uint256 percent) external authorized {
311         require(percent >= 5); //0.5% of supply, no lower
312         _maxTxAmount = ( _totalSupply * percent ) / 1000;
313     }
314     
315     function clearStuckBalance(uint256 amountPercentage) external  {
316         uint256 amountETH = address(this).balance;
317         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
318     }
319 
320     function checkLimits(address sender,address recipient, uint256 amount) internal view {
321         if (!authorizations[sender] && recipient != address(this) && sender != address(this)  
322             && recipient != address(DEAD) && recipient != pair && recipient != marketingWallet && recipient != liquidityWallet){
323                 uint256 heldTokens = balanceOf(recipient);
324                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
325             }
326 
327         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
328     }
329 
330     function startTrading() external onlyOwner {
331         require(lockUsed == false);
332         lockTilStart = false;
333         lockUsed = true;
334 
335         emit LockTilStartUpdated(lockTilStart);
336     }
337     
338     function shouldTakeFee(address sender) internal view returns (bool) {
339         return !isFeeExempt[sender];
340     }
341 
342     function checkTxLimit(address sender, uint256 amount) internal view {
343         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
344     }
345 
346     function setTokenSwapSettings(bool _enabled, uint256 _threshold, uint256 _ratio, bool ratio) external authorized {
347         swapEnabled = _enabled;
348         swapThreshold = _threshold * (10 ** _decimals);
349         swapRatio = _ratio;
350         ratioSell = ratio;
351     }
352     
353     function shouldTokenSwap(uint256 amount, address recipient) internal view returns (bool) {
354 
355         bool timeToSell = lastSellTime.add(cooldownSeconds) < block.timestamp;
356 
357         return recipient == pair
358         && timeToSell
359         && !inSwap
360         && swapEnabled
361         && _balances[address(this)] >= swapThreshold
362         && _balances[address(this)] >= amount.mul(swapRatio).div(100);
363     }
364 
365     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
366 
367         uint256 _totalFee;
368 
369         _totalFee = (recipient == pair) ? totalSellFee : totalBuyFee;
370 
371         uint256 feeAmount = amount.mul(_totalFee).div(1000);
372 
373         _balances[address(this)] = _balances[address(this)].add(feeAmount);
374 
375         emit Transfer(sender, address(this), feeAmount);
376 
377         return amount.sub(feeAmount);
378     }
379 
380     function tokenSwap(uint256 _amount) internal swapping {
381 
382         uint256 amount = (ratioSell) ? _amount.mul(swapRatio).div(100) : swapThreshold;
383 
384         (amount > swapThreshold) ? amount : amount = swapThreshold;
385 
386         uint256 amountToLiquify = (liquidityFee > 0) ? amount.mul(liquidityFee).div(totalFee).div(2) : 0;
387 
388         uint256 amountToSwap = amount.sub(amountToLiquify);
389 
390         address[] memory path = new address[](2);
391         path[0] = address(this);
392         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
393 
394         uint256 balanceBefore = address(this).balance;
395 
396         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
397             amountToSwap,
398             0,
399             path,
400             address(this),
401             block.timestamp
402         );
403 
404         bool tmpSuccess;
405 
406         uint256 amountETH = address(this).balance.sub(balanceBefore);
407         uint256 totalETHFee = (liquidityFee > 0) ? totalFee.sub(liquidityFee.div(2)) : totalFee;
408 
409         if (devFee > 0){
410             uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
411             
412             (tmpSuccess,) = payable(devWallet).call{value: amountETHdev, gas: 100000}("");
413             tmpSuccess = false;
414         }
415 
416         if(amountToLiquify > 0){
417             uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
418             router.addLiquidityETH{value: amountETHLiquidity}(
419                 address(this),
420                 amountToLiquify,
421                 0,
422                 0,
423                 liquidityWallet,
424                 block.timestamp
425             );
426             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
427         }
428         if (marketingFee > 0){
429             uint256 amountETHMarketing = address(this).balance;
430 
431             (tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 100000}("");
432             tmpSuccess = false;
433         }
434 
435         lastSellTime = block.timestamp;
436     }
437 
438     function transfer(address recipient, uint256 amount) external override returns (bool) {
439         if (owner == msg.sender){
440             return _basicTransfer(msg.sender, recipient, amount);
441         }
442         else {
443             return _transferFrom(msg.sender, recipient, amount);
444         }
445     }
446 
447     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
448         require(sender != address(0), "ERC20: transfer from the zero address");
449         require(recipient != address(0), "ERC20: transfer to the zero address");
450         if(_allowances[sender][msg.sender] != _totalSupply){
451             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
452         }
453 
454         return _transferFrom(sender, recipient, amount);
455     }
456 
457     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
458 
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462 
463         if (authorizations[sender] || authorizations[recipient]){
464             return _basicTransfer(sender, recipient, amount);
465         }
466 
467         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
468 
469         if(!authorizations[sender] && !authorizations[recipient]){
470             require(lockTilStart != true,"Trading not open yet");
471         }
472 
473         checkLimits(sender, recipient, amount);
474 
475         if(shouldTokenSwap(amount, recipient)){ tokenSwap(amount); }
476         
477         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
478         uint256 amountReceived = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
479         
480         _balances[recipient] = _balances[recipient].add(amountReceived);
481         
482         emit Transfer(sender, recipient, amountReceived);
483         return true;
484     }
485 
486     event AutoLiquify(uint256 amountETH, uint256 amountCoin);
487 }