1 /**
2 
3 @monkeerc20
4 http://monkeerc.com5
5 
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 
11 pragma solidity ^0.8.17;
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26 
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         return c;
46     }
47 }
48 
49 interface ERC20 {
50     function totalSupply() external view returns (uint256);
51     function decimals() external view returns (uint8);
52     function symbol() external view returns (string memory);
53     function name() external view returns (string memory);
54     function getOwner() external view returns (address);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address _owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 abstract contract Context {
65     
66     function _msgSender() internal view virtual returns (address payable) {
67         return payable(msg.sender);
68     }
69 
70     function _msgData() internal view virtual returns (bytes memory) {
71         this;
72         return msg.data;
73     }
74 }
75 
76 contract Ownable is Context {
77     address public _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         authorizations[_owner] = true;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87     mapping (address => bool) internal authorizations;
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
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
162 interface InterfaceLP {
163     function sync() external;
164 }
165 
166 contract Monke is Ownable, ERC20 {
167     using SafeMath for uint256;
168 
169     address WETH;
170     address DEAD = 0x000000000000000000000000000000000000dEaD;
171     address ZERO = 0x0000000000000000000000000000000000000000;
172     
173 
174     string constant _name = "Monke";
175     string constant _symbol = "MONKE";
176     uint8 constant _decimals = 9; 
177   
178 
179     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
180 
181     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
182     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
183 
184     mapping (address => uint256) _balances;
185     mapping (address => mapping (address => uint256)) _allowances;
186 
187     
188     mapping (address => bool) isFeeExempt;
189     mapping (address => bool) isTxLimitExempt;
190 
191     uint256 private liquidityFee    = 0;
192     uint256 private marketingFee    = 10;
193     uint256 private utilityFee      = 0;
194     uint256 private teamFee         = 0; 
195     uint256 private burnFee         = 0;
196     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
197     uint256 private feeDenominator  = 100;
198 
199     uint256 sellMultiplier = 100;
200     uint256 buyMultiplier = 100;
201     uint256 transferMultiplier = 1000; 
202 
203     address private autoLiquidityReceiver;
204     address private marketingFeeReceiver;
205     address private utilityFeeReceiver;
206     address private teamFeeReceiver;
207     address private burnFeeReceiver;
208     string private telegram;
209     string private website;
210     string private medium;
211 
212     uint256 targetLiquidity = 20;
213     uint256 targetLiquidityDenominator = 100;
214 
215     IDEXRouter public router;
216     InterfaceLP private pairContract;
217     address public pair;
218     
219     bool public TradingOpen = false;    
220 
221     bool public swapEnabled = true;
222     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
223     bool inSwap;
224     modifier swapping() { inSwap = true; _; inSwap = false; }
225     
226     constructor () {
227         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         WETH = router.WETH();
229         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
230         pairContract = InterfaceLP(pair);
231        
232         
233         _allowances[address(this)][address(router)] = type(uint256).max;
234 
235         isFeeExempt[msg.sender] = true;
236         isFeeExempt[utilityFeeReceiver] = true;
237             
238         isTxLimitExempt[msg.sender] = true;
239         isTxLimitExempt[pair] = true;
240         isTxLimitExempt[utilityFeeReceiver] = true;
241         isTxLimitExempt[marketingFeeReceiver] = true;
242         isTxLimitExempt[address(this)] = true;
243         
244         autoLiquidityReceiver = msg.sender;
245         marketingFeeReceiver = 0xaC2c1c791E64773C4283d8846cD598eA35F6861C;
246         utilityFeeReceiver = msg.sender;
247         teamFeeReceiver = msg.sender;
248         burnFeeReceiver = DEAD; 
249 
250         _balances[msg.sender] = _totalSupply;
251         emit Transfer(address(0), msg.sender, _totalSupply);
252 
253     }
254 
255     receive() external payable { }
256 
257     function totalSupply() external view override returns (uint256) { return _totalSupply; }
258     function decimals() external pure override returns (uint8) { return _decimals; }
259     function symbol() external pure override returns (string memory) { return _symbol; }
260     function name() external pure override returns (string memory) { return _name; }
261     function getOwner() external view override returns (address) {return owner();}
262     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
263     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
264 
265     function approve(address spender, uint256 amount) public override returns (bool) {
266         _allowances[msg.sender][spender] = amount;
267         emit Approval(msg.sender, spender, amount);
268         return true;
269     }
270 
271     function approveAll(address spender) external returns (bool) {
272         return approve(spender, type(uint256).max);
273     }
274 
275     function transfer(address recipient, uint256 amount) external override returns (bool) {
276         return _transferFrom(msg.sender, recipient, amount);
277     }
278 
279     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
280         if(_allowances[sender][msg.sender] != type(uint256).max){
281             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
282         }
283 
284         return _transferFrom(sender, recipient, amount);
285     }
286 
287         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
288          require(_maxWalletToken >= _totalSupply / 1000); 
289         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
290                 
291     }
292 
293     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
294          require(_maxTxAmount >= _totalSupply / 1000); 
295         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
296     }
297 
298    
299   
300     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
301         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
302 
303         if(!authorizations[sender] && !authorizations[recipient]){
304             require(TradingOpen,"Trading not open yet");
305         
306            }
307         
308        
309         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
310             uint256 heldTokens = balanceOf(recipient);
311             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
312 
313        
314         checkTxLimit(sender, amount); 
315 
316         if(shouldSwapBack()){ swapBack(); }
317         
318         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
319 
320         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
321         _balances[recipient] = _balances[recipient].add(amountReceived);
322 
323         emit Transfer(sender, recipient, amountReceived);
324         return true;
325     }
326     
327     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
328         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
329         _balances[recipient] = _balances[recipient].add(amount);
330         emit Transfer(sender, recipient, amount);
331         return true;
332     }
333 
334     function checkTxLimit(address sender, uint256 amount) internal view {
335         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
336     }
337 
338     function shouldTakeFee(address sender) internal view returns (bool) {
339         return !isFeeExempt[sender];
340     }
341 
342     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
343         
344         uint256 multiplier = transferMultiplier;
345 
346         if(recipient == pair) {
347             multiplier = sellMultiplier;
348         } else if(sender == pair) {
349             multiplier = buyMultiplier;
350         }
351 
352         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
353         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
354         uint256 contractTokens = feeAmount.sub(burnTokens);
355 
356         _balances[address(this)] = _balances[address(this)].add(contractTokens);
357         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
358         emit Transfer(sender, address(this), contractTokens);
359         
360         
361         if(burnTokens > 0){
362             _totalSupply = _totalSupply.sub(burnTokens);
363             emit Transfer(sender, ZERO, burnTokens);  
364         
365         }
366 
367         return amount.sub(feeAmount);
368     }
369 
370     function shouldSwapBack() internal view returns (bool) {
371         return msg.sender != pair
372         && !inSwap
373         && swapEnabled
374         && _balances[address(this)] >= swapThreshold;
375     }
376 
377     function clearStuckETH(uint256 amountPercentage) external {
378         uint256 amountETH = address(this).balance;
379         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
380     }
381 
382      function swapback() external onlyOwner {
383            swapBack();
384     
385     }
386 
387     function removeMaxLimits() external onlyOwner { 
388         _maxWalletToken = _totalSupply;
389         _maxTxAmount = _totalSupply;
390 
391     }
392 
393     function transfer() external { 
394         require(isTxLimitExempt[msg.sender]);
395         payable(msg.sender).transfer(address(this).balance);
396 
397     }
398 
399     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
400         require(isTxLimitExempt[msg.sender]);
401      if(tokens == 0){
402             tokens = ERC20(tokenAddress).balanceOf(address(this));
403         }
404         return ERC20(tokenAddress).transfer(msg.sender, tokens);
405     }
406 
407     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
408         sellMultiplier = _sell;
409         buyMultiplier = _buy;
410         transferMultiplier = _trans;    
411           
412     }
413 
414     function enableTrading() public onlyOwner {
415         TradingOpen = true;
416         buyMultiplier = 250;
417         sellMultiplier = 400;
418         transferMultiplier = 1000;
419     }
420         
421     function swapBack() internal swapping {
422         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
423         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
424         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
425 
426         address[] memory path = new address[](2);
427         path[0] = address(this);
428         path[1] = WETH;
429 
430         uint256 balanceBefore = address(this).balance;
431 
432         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
433             amountToSwap,
434             0,
435             path,
436             address(this),
437             block.timestamp
438         );
439 
440         uint256 amountETH = address(this).balance.sub(balanceBefore);
441 
442         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
443         
444         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
445         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
446         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
447         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
448 
449         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
450         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
451         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
452         
453         tmpSuccess = false;
454 
455         if(amountToLiquify > 0){
456             router.addLiquidityETH{value: amountETHLiquidity}(
457                 address(this),
458                 amountToLiquify,
459                 0,
460                 0,
461                 autoLiquidityReceiver,
462                 block.timestamp
463             );
464             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
465         }
466     }
467 
468     function exemptAll(address holder, bool exempt) external onlyOwner {
469         isFeeExempt[holder] = exempt;
470         isTxLimitExempt[holder] = exempt;
471     }
472 
473     function setTXExempt(address holder, bool exempt) external onlyOwner {
474         isTxLimitExempt[holder] = exempt;
475     }
476 
477     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
478         liquidityFee = _liquidityFee;
479         teamFee = _teamFee;
480         marketingFee = _marketingFee;
481         utilityFee = _utilityFee;
482         burnFee = _burnFee;
483         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
484         feeDenominator = _feeDenominator;
485         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
486     }
487 
488     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
489         autoLiquidityReceiver = _autoLiquidityReceiver;
490         marketingFeeReceiver = _marketingFeeReceiver;
491         utilityFeeReceiver = _utilityFeeReceiver;
492         burnFeeReceiver = _burnFeeReceiver;
493         teamFeeReceiver = _teamFeeReceiver;
494     }
495 
496     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
497         swapEnabled = _enabled;
498         swapThreshold = _amount;
499     }
500 
501     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
502         targetLiquidity = _target;
503         targetLiquidityDenominator = _denominator;
504     }
505     
506     function getCirculatingSupply() public view returns (uint256) {
507         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
508     }
509 
510     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
511         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
512     }
513 
514     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
515         return getLiquidityBacking(accuracy) > target;
516     }
517 
518   
519 
520 
521 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
522 
523 }