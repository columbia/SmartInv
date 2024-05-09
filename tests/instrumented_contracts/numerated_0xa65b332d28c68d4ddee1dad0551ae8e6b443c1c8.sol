1 // SPDX-License-Identifier: MIT
2 // $FOE is a meme
3 // https://twitter.com/foetech
4 // https://foe.tech
5 // https://t.me/foetech
6 
7 pragma solidity 0.8.18;
8 
9 interface ERC20 {
10     function totalSupply() external view returns (uint256);
11     function decimals() external view returns (uint8);
12     function symbol() external view returns (string memory);
13     function name() external view returns (string memory);
14     function getOwner() external view returns (address);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address _owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 
26 abstract contract Context {
27     
28     function _msgSender() internal view virtual returns (address payable) {
29         return payable(msg.sender);
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this;
34         return msg.data;
35     }
36 }
37 
38 contract Ownable is Context {
39     address public _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor () {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         authorizations[_owner] = true;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49     mapping (address => bool) internal authorizations;
50 
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70 }
71 
72 interface IDEXFactory {
73     function createPair(address tokenA, address tokenB) external returns (address pair);
74 }
75 
76 interface IDEXRouter {
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79 
80     function addLiquidity(
81         address tokenA,
82         address tokenB,
83         uint amountADesired,
84         uint amountBDesired,
85         uint amountAMin,
86         uint amountBMin,
87         address to,
88         uint deadline
89     ) external returns (uint amountA, uint amountB, uint liquidity);
90 
91     function addLiquidityETH(
92         address token,
93         uint amountTokenDesired,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
99 
100     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107 
108     function swapExactETHForTokensSupportingFeeOnTransferTokens(
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external payable;
114 
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122 }
123 
124 interface InterfaceLP {
125     function sync() external;
126 }
127 
128 
129 library SafeMath {
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         return div(a, b, "SafeMath: division by zero");
157     }
158     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         return c;
162     }
163 }
164 
165 contract FOE is Ownable, ERC20 {
166     using SafeMath for uint256;
167 
168     address WETH;
169     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
170     address constant ZERO = 0x0000000000000000000000000000000000000000;
171     
172 
173     string constant _name = "foe.tech";
174     string constant _symbol = "FOE";
175     uint8 constant _decimals = 18; 
176 
177 
178     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
179     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
180     event user_exemptfromfees(address Wallet, bool Exempt);
181     event user_TxExempt(address Wallet, bool Exempt);
182     event ClearStuck(uint256 amount);
183     event ClearToken(address TokenAddressCleared, uint256 Amount);
184     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
185     event set_MaxWallet(uint256 maxWallet);
186     event set_MaxTX(uint256 maxTX);
187     event set_SwapBack(uint256 Amount, bool Enabled);
188   
189     uint256 _totalSupply =  666666666666666 * 10**_decimals; 
190 
191     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
192     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
193 
194     mapping (address => uint256) _balances;
195     mapping (address => mapping (address => uint256)) _allowances;  
196     mapping (address => bool) isexemptfromfees;
197     mapping (address => bool) isexemptfrommaxTX;
198 
199     uint256 private liquidityFee    = 1;
200     uint256 private marketingFee    = 0;
201     uint256 private devFee          = 3;
202     uint256 private buybackFee      = 0; 
203     uint256 private burnFee         = 0;
204     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
205     uint256 private feeDenominator  = 100;
206 
207     uint256 sellpercent = 100;
208     uint256 buypercent = 100;
209     uint256 transferpercent = 100;
210 
211     address private autoLiquidityReceiver;
212     address private marketingFeeReceiver;
213     address private devFeeReceiver;
214     address private buybackFeeReceiver;
215     address private burnFeeReceiver;
216 
217     uint256 setRatio = 30;
218     uint256 setRatioDenominator = 100;
219     
220 
221     IDEXRouter public router;
222     InterfaceLP private pairContract;
223     address public pair;
224     
225     bool public TradingOpen = false; 
226 
227    
228     bool public swapEnabled = true;
229     uint256 public swapThreshold = _totalSupply * 7 / 1000; 
230     bool inSwap;
231     modifier swapping() { inSwap = true; _; inSwap = false; }
232     
233     constructor () {
234         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
235         WETH = router.WETH();
236         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
237         pairContract = InterfaceLP(pair);
238        
239         
240         _allowances[address(this)][address(router)] = type(uint256).max;
241 
242         isexemptfromfees[msg.sender] = true;            
243         isexemptfrommaxTX[msg.sender] = true;
244         isexemptfrommaxTX[pair] = true;
245         isexemptfrommaxTX[marketingFeeReceiver] = true;
246         isexemptfrommaxTX[address(this)] = true;
247         
248         autoLiquidityReceiver = msg.sender;
249         marketingFeeReceiver = msg.sender;
250         devFeeReceiver = msg.sender;
251         buybackFeeReceiver = msg.sender;
252         burnFeeReceiver = DEAD; 
253 
254         _balances[msg.sender] = _totalSupply;
255         emit Transfer(address(0), msg.sender, _totalSupply);
256 
257     }
258 
259     receive() external payable { }
260 
261     function totalSupply() external view override returns (uint256) { return _totalSupply; }
262     function decimals() external pure override returns (uint8) { return _decimals; }
263     function symbol() external pure override returns (string memory) { return _symbol; }
264     function name() external pure override returns (string memory) { return _name; }
265     function getOwner() external view override returns (address) {return owner();}
266     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
267     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
268 
269     function approve(address spender, uint256 amount) public override returns (bool) {
270         _allowances[msg.sender][spender] = amount;
271         emit Approval(msg.sender, spender, amount);
272         return true;
273     }
274 
275     function approveMax(address spender) external returns (bool) {
276         return approve(spender, type(uint256).max);
277     }
278 
279     function transfer(address recipient, uint256 amount) external override returns (bool) {
280         return _transferFrom(msg.sender, recipient, amount);
281     }
282 
283     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
284         if(_allowances[sender][msg.sender] != type(uint256).max){
285             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
286         }
287 
288         return _transferFrom(sender, recipient, amount);
289     }
290 
291         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
292          require(maxWallPercent >= 1); 
293         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
294         emit set_MaxWallet(_maxWalletToken);
295                 
296     }
297 
298       function removeLimits () external onlyOwner {
299             _maxTxAmount = _totalSupply;
300             _maxWalletToken = _totalSupply;
301     }
302 
303       
304     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
305         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
306 
307         if(!authorizations[sender] && !authorizations[recipient]){
308             require(TradingOpen,"Trading not open yet");
309         
310           }
311         
312                
313         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
314             uint256 heldTokens = balanceOf(recipient);
315             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
316 
317         checkTxLimit(sender, amount);  
318 
319         if(shouldSwapBack()){ swapBack(); }
320         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
321 
322         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
323         _balances[recipient] = _balances[recipient].add(amountReceived);
324 
325         emit Transfer(sender, recipient, amountReceived);
326         return true;
327     }
328  
329     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
330         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
331         _balances[recipient] = _balances[recipient].add(amount);
332         emit Transfer(sender, recipient, amount);
333         return true;
334     }
335 
336     function checkTxLimit(address sender, uint256 amount) internal view {
337         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
338     }
339 
340     function shouldTakeFee(address sender) internal view returns (bool) {
341         return !isexemptfromfees[sender];
342     }
343 
344     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
345         
346         uint256 percent = transferpercent;
347         if(recipient == pair) {
348             percent = sellpercent;
349         } else if(sender == pair) {
350             percent = buypercent;
351         }
352 
353         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
354         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
355         uint256 contractTokens = feeAmount.sub(burnTokens);
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
377   
378      function manualSend() external { 
379              payable(autoLiquidityReceiver).transfer(address(this).balance);
380             
381     }
382 
383    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
384              if(tokens == 0){
385             tokens = ERC20(tokenAddress).balanceOf(address(this));
386         }
387         emit ClearToken(tokenAddress, tokens);
388         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
389     }
390 
391     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
392         sellpercent = _percentonsell;
393         buypercent = _percentonbuy;
394         transferpercent = _wallettransfer;    
395           
396     }
397        
398     function startTrading() public onlyOwner {
399         TradingOpen = true;
400         buypercent = 1400;
401         sellpercent = 800;
402         transferpercent = 1000;
403                               
404     }
405 
406       function reduceFee() public onlyOwner {
407        
408         buypercent = 100;
409         sellpercent = 100;
410         transferpercent = 100;
411                               
412     }
413 
414              
415     function swapBack() internal swapping {
416         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
417         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
418         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
419 
420         address[] memory path = new address[](2);
421         path[0] = address(this);
422         path[1] = WETH;
423 
424         uint256 balanceBefore = address(this).balance;
425 
426         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
427             amountToSwap,
428             0,
429             path,
430             address(this),
431             block.timestamp
432         );
433 
434         uint256 amountETH = address(this).balance.sub(balanceBefore);
435 
436         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
437         
438         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
439         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
440         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
441         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
442 
443         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
444         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
445         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
446         
447         tmpSuccess = false;
448 
449         if(amountToLiquify > 0){
450             router.addLiquidityETH{value: amountETHLiquidity}(
451                 address(this),
452                 amountToLiquify,
453                 0,
454                 0,
455                 autoLiquidityReceiver,
456                 block.timestamp
457             );
458             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
459         }
460     }
461     
462   
463     function set_fees() internal {
464       
465         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
466             uint8(totalFee.mul(sellpercent).div(100)),
467             uint8(totalFee.mul(transferpercent).div(100))
468             );
469     }
470     
471     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
472         liquidityFee = _liquidityFee;
473         buybackFee = _buybackFee;
474         marketingFee = _marketingFee;
475         devFee = _devFee;
476         burnFee = _burnFee;
477         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
478         feeDenominator = _feeDenominator;
479         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
480         set_fees();
481     }
482 
483    
484     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
485         autoLiquidityReceiver = _autoLiquidityReceiver;
486         marketingFeeReceiver = _marketingFeeReceiver;
487         devFeeReceiver = _devFeeReceiver;
488         burnFeeReceiver = _burnFeeReceiver;
489         buybackFeeReceiver = _buybackFeeReceiver;
490 
491         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
492     }
493 
494     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
495         swapEnabled = _enabled;
496         swapThreshold = _amount;
497         emit set_SwapBack(swapThreshold, swapEnabled);
498     }
499 
500     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
501         return showBacking(accuracy) > ratio;
502     }
503 
504     function showBacking(uint256 accuracy) public view returns (uint256) {
505         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
506     }
507     
508     function showSupply() public view returns (uint256) {
509         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
510     }
511 
512 
513 }