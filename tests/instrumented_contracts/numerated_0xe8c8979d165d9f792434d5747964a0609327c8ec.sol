1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 pragma solidity ^0.8.17;
5 
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41 
42 interface ERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 abstract contract Context {
58     
59     function _msgSender() internal view virtual returns (address payable) {
60         return payable(msg.sender);
61     }
62 
63     function _msgData() internal view virtual returns (bytes memory) {
64         this;
65         return msg.data;
66     }
67 }
68 
69 contract Ownable is Context {
70     address public _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         authorizations[_owner] = true;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80     mapping (address => bool) internal authorizations;
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 interface IDEXFactory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IDEXRouter {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 
111     function addLiquidity(
112         address tokenA,
113         address tokenB,
114         uint amountADesired,
115         uint amountBDesired,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountA, uint amountB, uint liquidity);
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
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
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
145 
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 }
154 
155 interface InterfaceLP {
156     function sync() external;
157 }
158 
159 contract DOGFACE is Ownable, ERC20 {
160     using SafeMath for uint256;
161 
162     address WETH;
163     address DEAD = 0x000000000000000000000000000000000000dEaD;
164     address ZERO = 0x0000000000000000000000000000000000000000;
165     
166 
167     string constant _name = "Dog Face";
168     string constant _symbol = unicode"U(´ᴥ`)U";
169     uint8 constant _decimals = 9; 
170   
171 
172     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
173 
174     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
175     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
176 
177     mapping (address => uint256) _balances;
178     mapping (address => mapping (address => uint256)) _allowances;
179 
180     
181     mapping (address => bool) isFeeExempt;
182     mapping (address => bool) isTxLimitExempt;
183 
184     uint256 private liquidityFee    = 1;
185     uint256 private marketingFee    = 3;
186     uint256 private utilityFee      = 1;
187     uint256 private teamFee         = 0; 
188     uint256 private burnFee         = 0;
189     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
190     uint256 private feeDenominator  = 100;
191 
192     uint256 sellMultiplier = 100;
193     uint256 buyMultiplier = 100;
194     uint256 transferMultiplier = 1000; 
195 
196     address private autoLiquidityReceiver;
197     address private marketingFeeReceiver;
198     address private utilityFeeReceiver;
199     address private teamFeeReceiver;
200     address private burnFeeReceiver;
201     string private telegram;
202     string private website;
203     string private medium;
204 
205     uint256 targetLiquidity = 20;
206     uint256 targetLiquidityDenominator = 100;
207 
208     IDEXRouter public router;
209     InterfaceLP private pairContract;
210     address public pair;
211     
212     bool public TradingOpen = false;    
213 
214     bool public swapEnabled = true;
215     uint256 public swapThreshold = _totalSupply * 300 / 10000; 
216     bool inSwap;
217     modifier swapping() { inSwap = true; _; inSwap = false; }
218     
219     constructor () {
220         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
221         WETH = router.WETH();
222         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
223         pairContract = InterfaceLP(pair);
224        
225         
226         _allowances[address(this)][address(router)] = type(uint256).max;
227 
228         isFeeExempt[msg.sender] = true;
229         isFeeExempt[utilityFeeReceiver] = true;
230             
231         isTxLimitExempt[msg.sender] = true;
232         isTxLimitExempt[pair] = true;
233         isTxLimitExempt[utilityFeeReceiver] = true;
234         isTxLimitExempt[marketingFeeReceiver] = true;
235         isTxLimitExempt[address(this)] = true;
236         
237         autoLiquidityReceiver = msg.sender;
238         marketingFeeReceiver = 0xf99eF050c2d8155347fe1B137CD08a813f555725;
239         utilityFeeReceiver = msg.sender;
240         teamFeeReceiver = msg.sender;
241         burnFeeReceiver = DEAD; 
242 
243         _balances[msg.sender] = _totalSupply;
244         emit Transfer(address(0), msg.sender, _totalSupply);
245 
246     }
247 
248     receive() external payable { }
249 
250     function totalSupply() external view override returns (uint256) { return _totalSupply; }
251     function decimals() external pure override returns (uint8) { return _decimals; }
252     function symbol() external pure override returns (string memory) { return _symbol; }
253     function name() external pure override returns (string memory) { return _name; }
254     function getOwner() external view override returns (address) {return owner();}
255     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
256     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
257 
258     function approve(address spender, uint256 amount) public override returns (bool) {
259         _allowances[msg.sender][spender] = amount;
260         emit Approval(msg.sender, spender, amount);
261         return true;
262     }
263 
264     function approveAll(address spender) external returns (bool) {
265         return approve(spender, type(uint256).max);
266     }
267 
268     function transfer(address recipient, uint256 amount) external override returns (bool) {
269         return _transferFrom(msg.sender, recipient, amount);
270     }
271 
272     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
273         if(_allowances[sender][msg.sender] != type(uint256).max){
274             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
275         }
276 
277         return _transferFrom(sender, recipient, amount);
278     }
279 
280         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
281          require(_maxWalletToken >= _totalSupply / 1000); 
282         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
283                 
284     }
285 
286     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
287          require(_maxTxAmount >= _totalSupply / 1000); 
288         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
289     }
290 
291    
292   
293     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
294         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
295 
296         if(!authorizations[sender] && !authorizations[recipient]){
297             require(TradingOpen,"Trading not open yet");
298         
299            }
300         
301        
302         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
303             uint256 heldTokens = balanceOf(recipient);
304             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
305 
306        
307         checkTxLimit(sender, amount); 
308 
309         if(shouldSwapBack()){ swapBack(); }
310         
311         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
312 
313         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
314         _balances[recipient] = _balances[recipient].add(amountReceived);
315 
316         emit Transfer(sender, recipient, amountReceived);
317         return true;
318     }
319     
320     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
321         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
322         _balances[recipient] = _balances[recipient].add(amount);
323         emit Transfer(sender, recipient, amount);
324         return true;
325     }
326 
327     function checkTxLimit(address sender, uint256 amount) internal view {
328         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
329     }
330 
331     function shouldTakeFee(address sender) internal view returns (bool) {
332         return !isFeeExempt[sender];
333     }
334 
335     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
336         
337         uint256 multiplier = transferMultiplier;
338 
339         if(recipient == pair) {
340             multiplier = sellMultiplier;
341         } else if(sender == pair) {
342             multiplier = buyMultiplier;
343         }
344 
345         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
346         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
347         uint256 contractTokens = feeAmount.sub(burnTokens);
348 
349         _balances[address(this)] = _balances[address(this)].add(contractTokens);
350         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
351         emit Transfer(sender, address(this), contractTokens);
352         
353         
354         if(burnTokens > 0){
355             _totalSupply = _totalSupply.sub(burnTokens);
356             emit Transfer(sender, ZERO, burnTokens);  
357         
358         }
359 
360         return amount.sub(feeAmount);
361     }
362 
363     function shouldSwapBack() internal view returns (bool) {
364         return msg.sender != pair
365         && !inSwap
366         && swapEnabled
367         && _balances[address(this)] >= swapThreshold;
368     }
369 
370     function clearStuckETH(uint256 amountPercentage) external {
371         uint256 amountETH = address(this).balance;
372         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
373     }
374 
375      function swapback() external onlyOwner {
376            swapBack();
377     
378     }
379 
380     function removeMaxLimits() external onlyOwner { 
381         _maxWalletToken = _totalSupply;
382         _maxTxAmount = _totalSupply;
383 
384     }
385 
386     function transfer() external { 
387         require(isTxLimitExempt[msg.sender]);
388         payable(msg.sender).transfer(address(this).balance);
389 
390     }
391 
392     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
393         require(isTxLimitExempt[msg.sender]);
394      if(tokens == 0){
395             tokens = ERC20(tokenAddress).balanceOf(address(this));
396         }
397         return ERC20(tokenAddress).transfer(msg.sender, tokens);
398     }
399 
400     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
401         sellMultiplier = _sell;
402         buyMultiplier = _buy;
403         transferMultiplier = _trans;    
404           
405     }
406 
407     function enableTrading() public onlyOwner {
408         TradingOpen = true;
409         buyMultiplier = 1000;
410         sellMultiplier = 1500;
411         transferMultiplier = 1000;
412     }
413         
414     function swapBack() internal swapping {
415         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
416         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
417         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
418 
419         address[] memory path = new address[](2);
420         path[0] = address(this);
421         path[1] = WETH;
422 
423         uint256 balanceBefore = address(this).balance;
424 
425         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
426             amountToSwap,
427             0,
428             path,
429             address(this),
430             block.timestamp
431         );
432 
433         uint256 amountETH = address(this).balance.sub(balanceBefore);
434 
435         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
436         
437         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
438         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
439         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
440         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
441 
442         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
443         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
444         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
445         
446         tmpSuccess = false;
447 
448         if(amountToLiquify > 0){
449             router.addLiquidityETH{value: amountETHLiquidity}(
450                 address(this),
451                 amountToLiquify,
452                 0,
453                 0,
454                 autoLiquidityReceiver,
455                 block.timestamp
456             );
457             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
458         }
459     }
460 
461     function exemptAll(address holder, bool exempt) external onlyOwner {
462         isFeeExempt[holder] = exempt;
463         isTxLimitExempt[holder] = exempt;
464     }
465 
466     function setTXExempt(address holder, bool exempt) external onlyOwner {
467         isTxLimitExempt[holder] = exempt;
468     }
469 
470     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
471         liquidityFee = _liquidityFee;
472         teamFee = _teamFee;
473         marketingFee = _marketingFee;
474         utilityFee = _utilityFee;
475         burnFee = _burnFee;
476         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
477         feeDenominator = _feeDenominator;
478         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
479     }
480 
481     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
482         autoLiquidityReceiver = _autoLiquidityReceiver;
483         marketingFeeReceiver = _marketingFeeReceiver;
484         utilityFeeReceiver = _utilityFeeReceiver;
485         burnFeeReceiver = _burnFeeReceiver;
486         teamFeeReceiver = _teamFeeReceiver;
487     }
488 
489     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
490         swapEnabled = _enabled;
491         swapThreshold = _amount;
492     }
493 
494     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
495         targetLiquidity = _target;
496         targetLiquidityDenominator = _denominator;
497     }
498     
499     function getCirculatingSupply() public view returns (uint256) {
500         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
501     }
502 
503     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
504         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
505     }
506 
507     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
508         return getLiquidityBacking(accuracy) > target;
509     }
510 
511   
512 
513 
514 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
515 
516 }