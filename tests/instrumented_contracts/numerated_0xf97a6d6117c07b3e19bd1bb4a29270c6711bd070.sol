1 /*
2 
3 //https://depositcoineth.com/
4 //https://t.me/DepositPortal
5 //https://twitter.com/DepositERC
6 
7 */
8 
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 
13 pragma solidity 0.8.20;
14 
15 interface ERC20 {
16     function totalSupply() external view returns (uint256);
17     function decimals() external view returns (uint8);
18     function symbol() external view returns (string memory);
19     function name() external view returns (string memory);
20     function getOwner() external view returns (address);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address _owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43 
44         return c;
45     }
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53 
54         return c;
55     }
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 }
65 
66 
67 
68 abstract contract Context {
69     
70     function _msgSender() internal view virtual returns (address payable) {
71         return payable(msg.sender);
72     }
73 
74     function _msgData() internal view virtual returns (bytes memory) {
75         this;
76         return msg.data;
77     }
78 }
79 
80 contract Ownable is Context {
81     address public _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         authorizations[_owner] = true;
89         emit OwnershipTransferred(address(0), msgSender);
90     }
91     mapping (address => bool) internal authorizations;
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     modifier onlyOwner() {
98         require(_owner == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     function renounceOwnership() public virtual onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         emit OwnershipTransferred(_owner, newOwner);
110         _owner = newOwner;
111     }
112 }
113 
114 interface IDEXFactory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IDEXRouter {
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121 
122     function addLiquidity(
123         address tokenA,
124         address tokenB,
125         uint amountADesired,
126         uint amountBDesired,
127         uint amountAMin,
128         uint amountBMin,
129         address to,
130         uint deadline
131     ) external returns (uint amountA, uint amountB, uint liquidity);
132 
133     function addLiquidityETH(
134         address token,
135         uint amountTokenDesired,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
141 
142     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external;
149 
150     function swapExactETHForTokensSupportingFeeOnTransferTokens(
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable;
156 
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164 }
165 
166 interface InterfaceLP {
167     function sync() external;
168 }
169 
170 contract Deposit is Ownable, ERC20 {
171     using SafeMath for uint256;
172 
173     address WETH;
174     address DEAD = 0x000000000000000000000000000000000000dEaD;
175     address ZERO = 0x0000000000000000000000000000000000000000;
176     
177 
178     string constant _name = "Deposit";
179     string constant _symbol = "DEP";
180     uint8 constant _decimals = 9; 
181   
182 
183     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
184 
185     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
186     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
187 
188     mapping (address => uint256) _balances;
189     mapping (address => mapping (address => uint256)) _allowances;
190 
191     
192     mapping (address => bool) isFeeexempt;
193     mapping (address => bool) isTxLimitexempt;
194 
195     uint256 private liquidityFee    = 1;
196     uint256 private marketingFee    = 3;
197     uint256 private devFee          = 0;
198     uint256 private buybackFee      = 1; 
199     uint256 private burnFee         = 0;
200     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
201     uint256 private feeDenominator  = 100;
202 
203     uint256 sellmultiplier = 800;
204     uint256 buymultiplier = 500;
205     uint256 transfertax = 1000; 
206 
207     address private autoLiquidityReceiver;
208     address private marketingFeeReceiver;
209     address private devFeeReceiver;
210     address private buybackFeeReceiver;
211     address private burnFeeReceiver;
212     
213     uint256 targetLiquidity = 30;
214     uint256 targetLiquidityDenominator = 100;
215 
216     IDEXRouter public router;
217     InterfaceLP private pairContract;
218     address public pair;
219     
220     bool public TradingOpen = false; 
221 
222 
223     bool public swapEnabled = true;
224     uint256 public swapThreshold = _totalSupply * 35 / 1000; 
225     bool inSwap;
226     modifier swapping() { inSwap = true; _; inSwap = false; }
227     
228     constructor () {
229         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
230         WETH = router.WETH();
231         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
232         pairContract = InterfaceLP(pair);
233        
234         
235         _allowances[address(this)][address(router)] = type(uint256).max;
236 
237         isFeeexempt[msg.sender] = true;
238         isFeeexempt[devFeeReceiver] = true;
239             
240         isTxLimitexempt[msg.sender] = true;
241         isTxLimitexempt[pair] = true;
242         isTxLimitexempt[devFeeReceiver] = true;
243         isTxLimitexempt[marketingFeeReceiver] = true;
244         isTxLimitexempt[address(this)] = true;
245         
246         autoLiquidityReceiver = msg.sender;
247         marketingFeeReceiver = 0x33a6d822482dE7A24845A4255bdF989C875595EF;
248         devFeeReceiver = msg.sender;
249         buybackFeeReceiver = msg.sender;
250         burnFeeReceiver = DEAD; 
251 
252         _balances[msg.sender] = _totalSupply;
253         emit Transfer(address(0), msg.sender, _totalSupply);
254 
255     }
256 
257     receive() external payable { }
258 
259     function totalSupply() external view override returns (uint256) { return _totalSupply; }
260     function decimals() external pure override returns (uint8) { return _decimals; }
261     function symbol() external pure override returns (string memory) { return _symbol; }
262     function name() external pure override returns (string memory) { return _name; }
263     function getOwner() external view override returns (address) {return owner();}
264     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
265     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
266 
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _allowances[msg.sender][spender] = amount;
269         emit Approval(msg.sender, spender, amount);
270         return true;
271     }
272 
273     function approveMax(address spender) external returns (bool) {
274         return approve(spender, type(uint256).max);
275     }
276 
277     function transfer(address recipient, uint256 amount) external override returns (bool) {
278         return _transferFrom(msg.sender, recipient, amount);
279     }
280 
281     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
282         if(_allowances[sender][msg.sender] != type(uint256).max){
283             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
284         }
285 
286         return _transferFrom(sender, recipient, amount);
287     }
288 
289   
290     function removelimits () external onlyOwner {
291             _maxTxAmount = _totalSupply;
292             _maxWalletToken = _totalSupply;
293     }
294       
295     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
296         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
297 
298         if(!authorizations[sender] && !authorizations[recipient]){
299             require(TradingOpen,"Trading not open yet");
300         
301           }
302         
303                
304         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
305             uint256 heldTokens = balanceOf(recipient);
306             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
307 
308         
309         checkTxLimit(sender, amount); 
310 
311         if(shouldSwapBack()){ swapBack(); }
312       
313         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
314 
315         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
316         _balances[recipient] = _balances[recipient].add(amountReceived);
317 
318         emit Transfer(sender, recipient, amountReceived);
319         return true;
320     }
321     
322     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
323         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
324         _balances[recipient] = _balances[recipient].add(amount);
325         emit Transfer(sender, recipient, amount);
326         return true;
327     }
328 
329     function checkTxLimit(address sender, uint256 amount) internal view {
330         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
331     }
332 
333     function shouldTakeFee(address sender) internal view returns (bool) {
334         return !isFeeexempt[sender];
335     }
336 
337     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
338         
339         uint256 percent = transfertax;
340 
341         if(recipient == pair) {
342             percent = sellmultiplier;
343         } else if(sender == pair) {
344             percent = buymultiplier;
345         }
346 
347         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
348         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
349         uint256 contractTokens = feeAmount.sub(burnTokens);
350 
351         _balances[address(this)] = _balances[address(this)].add(contractTokens);
352         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
353         emit Transfer(sender, address(this), contractTokens);
354         
355         
356         if(burnTokens > 0){
357             _totalSupply = _totalSupply.sub(burnTokens);
358             emit Transfer(sender, ZERO, burnTokens);  
359         
360         }
361 
362         return amount.sub(feeAmount);
363     }
364 
365     function shouldSwapBack() internal view returns (bool) {
366         return msg.sender != pair
367         && !inSwap
368         && swapEnabled
369         && _balances[address(this)] >= swapThreshold;
370     }
371 
372     function clearStuckETH(uint256 amountPercentage) external onlyOwner {
373         uint256 amountETH = address(this).balance;
374         payable(buybackFeeReceiver).transfer(amountETH * amountPercentage / 100);
375     }
376 
377     function manualSend() external { 
378     payable(autoLiquidityReceiver).transfer(address(this).balance);
379         
380     }
381 
382   
383     function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
384                if(tokens == 0){
385             tokens = ERC20(tokenAddress).balanceOf(address(this));
386         }
387         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
388     }
389 
390     function setMultipliers(uint256 _issell, uint256 _isbuy, uint256 _wallet) external onlyOwner {
391         sellmultiplier = _issell;
392         buymultiplier = _isbuy;
393         transfertax = _wallet;    
394           
395     }
396 
397      function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
398          require(maxWallPercent >= 1); 
399         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
400                 
401     }
402 
403     function setMaxTransaction(uint256 maxTXPercent) external onlyOwner {
404          require(maxTXPercent >= 1); 
405         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
406     }
407 
408   
409     function openTrading() public onlyOwner {
410         TradingOpen = true;     
411         
412     }
413 
414      function setTarget(uint256 _target, uint256 _denominator) external onlyOwner {
415         targetLiquidity = _target;
416         targetLiquidityDenominator = _denominator;
417     }
418     
419     
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
446         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
447         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
448 
449         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
450         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
451         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
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
468     
469     function setFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
470         liquidityFee = _liquidityFee;
471         buybackFee = _buybackFee;
472         marketingFee = _marketingFee;
473         devFee = _devFee;
474         burnFee = _burnFee;
475         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
476         feeDenominator = _feeDenominator;
477         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
478     }
479 
480     function updateReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
481         autoLiquidityReceiver = _autoLiquidityReceiver;
482         marketingFeeReceiver = _marketingFeeReceiver;
483         devFeeReceiver = _devFeeReceiver;
484         burnFeeReceiver = _burnFeeReceiver;
485         buybackFeeReceiver = _buybackFeeReceiver;
486     }
487 
488     function configSwapback(bool _enabled, uint256 _amount) external onlyOwner {
489         swapEnabled = _enabled;
490         swapThreshold = _amount;
491     }
492        
493     function getCirculatingSupply() public view returns (uint256) {
494         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
495     }
496 
497     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
498         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
499     }
500 
501     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
502         return getLiquidityBacking(accuracy) > target;
503     }
504 
505 
506 
507 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
508 event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
509 event user_FeeExempt(address Wallet, bool Exempt);
510 event user_TxExempt(address Wallet, bool Exempt);
511 event ClearStuck(uint256 amount);
512 event ClearToken(address TokenAddressCleared, uint256 Amount);
513 event set_Receivers(address marketingFeeReceiver, address teamFeeReceiver,address stakingFeeReceiver,address devFeeReceiver);
514 event set_MaxWallet(uint256 maxWallet);
515 event set_MaxTX(uint256 maxTX);
516 event set_SwapBack(uint256 Amount, bool Enabled);
517 
518 }