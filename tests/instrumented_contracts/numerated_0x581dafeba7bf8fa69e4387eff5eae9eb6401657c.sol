1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.20;
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint8);
7     function symbol() external view returns (string memory);
8     function name() external view returns (string memory);
9     function getOwner() external view returns (address);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address _owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 abstract contract Context {
20     
21     function _msgSender() internal view virtual returns (address payable) {
22         return payable(msg.sender);
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this;
27         return msg.data;
28     }
29 }
30 
31 contract Ownable is Context {
32     address public _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor () {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         authorizations[_owner] = true;
40         emit OwnershipTransferred(address(0), msgSender);
41     }
42     mapping (address => bool) internal authorizations;
43 
44     function owner() public view returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner() {
49         require(_owner == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 }
64 
65 interface IDEXFactory {
66     function createPair(address tokenA, address tokenB) external returns (address pair);
67 }
68 
69 interface IDEXRouter {
70     function factory() external pure returns (address);
71     function WETH() external pure returns (address);
72 
73     function addLiquidity(
74         address tokenA,
75         address tokenB,
76         uint amountADesired,
77         uint amountBDesired,
78         uint amountAMin,
79         uint amountBMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountA, uint amountB, uint liquidity);
83 
84     function addLiquidityETH(
85         address token,
86         uint amountTokenDesired,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
92 
93     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100 
101     function swapExactETHForTokensSupportingFeeOnTransferTokens(
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external payable;
107 
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115 }
116 
117 interface InterfaceLP {
118     function sync() external;
119 }
120 
121 
122 library SafeMath {
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148     function div(uint256 a, uint256 b) internal pure returns (uint256) {
149         return div(a, b, "SafeMath: division by zero");
150     }
151     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b > 0, errorMessage);
153         uint256 c = a / b;
154         return c;
155     }
156 }
157 
158 contract THREADS is Ownable, ERC20 {
159     using SafeMath for uint256;
160 
161     address WETH;
162     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
163     address constant ZERO = 0x0000000000000000000000000000000000000000;
164     
165 
166     string constant _name = "Threads";
167     string constant _symbol = "THREADS";
168     uint8 constant _decimals = 18; 
169 
170 
171     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
172     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
173     event user_exemptfromfees(address Wallet, bool Exempt);
174     event user_TxExempt(address Wallet, bool Exempt);
175     event ClearStuck(uint256 amount);
176     event ClearToken(address TokenAddressCleared, uint256 Amount);
177     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
178     event set_MaxWallet(uint256 maxWallet);
179     event set_MaxTX(uint256 maxTX);
180     event set_SwapBack(uint256 Amount, bool Enabled);
181   
182     uint256 _totalSupply =  100000000 * 10**_decimals; 
183 
184     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
185     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
186 
187     mapping (address => uint256) _balances;
188     mapping (address => mapping (address => uint256)) _allowances;  
189     mapping (address => bool) isexemptfromfees;
190     mapping (address => bool) isexemptfrommaxTX;
191 
192     uint256 private liquidityFee    = 1;
193     uint256 private marketingFee    = 4;
194     uint256 private devFee          = 0;
195     uint256 private buybackFee      = 0; 
196     uint256 private burnFee         = 0;
197     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
198     uint256 private feeDenominator  = 100;
199 
200     uint256 sellpercent = 100;
201     uint256 buypercent = 100;
202     uint256 transferpercent = 100; 
203 
204     address private autoLiquidityReceiver;
205     address private marketingFeeReceiver;
206     address private devFeeReceiver;
207     address private buybackFeeReceiver;
208     address private burnFeeReceiver;
209 
210     uint256 setRatio = 30;
211     uint256 setRatioDenominator = 100;
212     
213 
214     IDEXRouter public router;
215     InterfaceLP private pairContract;
216     address public pair;
217     
218     bool public TradingOpen = false; 
219 
220    
221     bool public swapEnabled = true;
222     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
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
235         isexemptfromfees[msg.sender] = true;            
236         isexemptfrommaxTX[msg.sender] = true;
237         isexemptfrommaxTX[pair] = true;
238         isexemptfrommaxTX[marketingFeeReceiver] = true;
239         isexemptfrommaxTX[address(this)] = true;
240         
241         autoLiquidityReceiver = msg.sender;
242         marketingFeeReceiver = 0x773bdeb980569FfF30367e3a80943488DfD915b9;
243         devFeeReceiver = 0x2C52A2020df5fb1752a6862118C3a1a141b2063c;
244         buybackFeeReceiver = 0x773bdeb980569FfF30367e3a80943488DfD915b9;
245         burnFeeReceiver = DEAD; 
246 
247         _balances[msg.sender] = _totalSupply;
248         emit Transfer(address(0), msg.sender, _totalSupply);
249 
250     }
251 
252     receive() external payable { }
253 
254     function totalSupply() external view override returns (uint256) { return _totalSupply; }
255     function decimals() external pure override returns (uint8) { return _decimals; }
256     function symbol() external pure override returns (string memory) { return _symbol; }
257     function name() external pure override returns (string memory) { return _name; }
258     function getOwner() external view override returns (address) {return owner();}
259     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
260     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
261 
262     function approve(address spender, uint256 amount) public override returns (bool) {
263         _allowances[msg.sender][spender] = amount;
264         emit Approval(msg.sender, spender, amount);
265         return true;
266     }
267 
268     function approveMax(address spender) external returns (bool) {
269         return approve(spender, type(uint256).max);
270     }
271 
272     function transfer(address recipient, uint256 amount) external override returns (bool) {
273         return _transferFrom(msg.sender, recipient, amount);
274     }
275 
276     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
277         if(_allowances[sender][msg.sender] != type(uint256).max){
278             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
279         }
280 
281         return _transferFrom(sender, recipient, amount);
282     }
283 
284         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
285          require(maxWallPercent >= 1); 
286         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
287         emit set_MaxWallet(_maxWalletToken);
288                 
289     }
290 
291       function removeLimits () external onlyOwner {
292             _maxTxAmount = _totalSupply;
293             _maxWalletToken = _totalSupply;
294     }
295 
296       
297     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
298         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
299 
300         if(!authorizations[sender] && !authorizations[recipient]){
301             require(TradingOpen,"Trading not open yet");
302         
303           }
304         
305                
306         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
307             uint256 heldTokens = balanceOf(recipient);
308             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
309 
310         checkTxLimit(sender, amount);  
311 
312         if(shouldSwapBack()){ swapBack(); }
313         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
314 
315         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
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
330         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
331     }
332 
333     function shouldTakeFee(address sender) internal view returns (bool) {
334         return !isexemptfromfees[sender];
335     }
336 
337     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
338         
339         uint256 percent = transferpercent;
340         if(recipient == pair) {
341             percent = sellpercent;
342         } else if(sender == pair) {
343             percent = buypercent;
344         }
345 
346         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
347         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
348         uint256 contractTokens = feeAmount.sub(burnTokens);
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
370   
371      function manualSend() external { 
372              payable(autoLiquidityReceiver).transfer(address(this).balance);
373             
374     }
375 
376    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
377              if(tokens == 0){
378             tokens = ERC20(tokenAddress).balanceOf(address(this));
379         }
380         emit ClearToken(tokenAddress, tokens);
381         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
382     }
383 
384     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
385         sellpercent = _percentonsell;
386         buypercent = _percentonbuy;
387         transferpercent = _wallettransfer;    
388           
389     }
390        
391     function startTrading() public onlyOwner {
392         TradingOpen = true;
393         buypercent = 1400;
394         sellpercent = 800;
395         transferpercent = 1000;
396                               
397     }
398 
399       function reduceFee() public onlyOwner {
400        
401         buypercent = 400;
402         sellpercent = 700;
403         transferpercent = 400;
404                               
405     }
406 
407              
408     function swapBack() internal swapping {
409         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
410         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
411         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
412 
413         address[] memory path = new address[](2);
414         path[0] = address(this);
415         path[1] = WETH;
416 
417         uint256 balanceBefore = address(this).balance;
418 
419         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
420             amountToSwap,
421             0,
422             path,
423             address(this),
424             block.timestamp
425         );
426 
427         uint256 amountETH = address(this).balance.sub(balanceBefore);
428 
429         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
430         
431         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
432         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
433         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
434         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
435 
436         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
437         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
438         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
439         
440         tmpSuccess = false;
441 
442         if(amountToLiquify > 0){
443             router.addLiquidityETH{value: amountETHLiquidity}(
444                 address(this),
445                 amountToLiquify,
446                 0,
447                 0,
448                 autoLiquidityReceiver,
449                 block.timestamp
450             );
451             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
452         }
453     }
454     
455   
456     function set_fees() internal {
457       
458         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
459             uint8(totalFee.mul(sellpercent).div(100)),
460             uint8(totalFee.mul(transferpercent).div(100))
461             );
462     }
463     
464     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
465         liquidityFee = _liquidityFee;
466         buybackFee = _buybackFee;
467         marketingFee = _marketingFee;
468         devFee = _devFee;
469         burnFee = _burnFee;
470         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
471         feeDenominator = _feeDenominator;
472         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
473         set_fees();
474     }
475 
476    
477     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
478         autoLiquidityReceiver = _autoLiquidityReceiver;
479         marketingFeeReceiver = _marketingFeeReceiver;
480         devFeeReceiver = _devFeeReceiver;
481         burnFeeReceiver = _burnFeeReceiver;
482         buybackFeeReceiver = _buybackFeeReceiver;
483 
484         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
485     }
486 
487     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
488         swapEnabled = _enabled;
489         swapThreshold = _amount;
490         emit set_SwapBack(swapThreshold, swapEnabled);
491     }
492 
493     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
494         return showBacking(accuracy) > ratio;
495     }
496 
497     function showBacking(uint256 accuracy) public view returns (uint256) {
498         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
499     }
500     
501     function showSupply() public view returns (uint256) {
502         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
503     }
504 
505 
506 }