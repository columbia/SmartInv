1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-29
3 */
4 
5 // https://twitter.com/pepe4coineth
6 
7 // https://t.me/Pepe4Portal
8 
9 // https://pepe40.vip
10 
11 
12 
13 // SPDX-License-Identifier: MIT
14 
15 
16 pragma solidity 0.8.20;
17 
18 interface ERC20 {
19     function totalSupply() external view returns (uint256);
20     function decimals() external view returns (uint8);
21     function symbol() external view returns (string memory);
22     function name() external view returns (string memory);
23     function getOwner() external view returns (address);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address _owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 
35 abstract contract Context {
36     
37     function _msgSender() internal view virtual returns (address payable) {
38         return payable(msg.sender);
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this;
43         return msg.data;
44     }
45 }
46 
47 contract Ownable is Context {
48     address public _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     constructor () {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         authorizations[_owner] = true;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58     mapping (address => bool) internal authorizations;
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 interface IDEXFactory {
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83 }
84 
85 interface IDEXRouter {
86     function factory() external pure returns (address);
87     function WETH() external pure returns (address);
88 
89     function addLiquidity(
90         address tokenA,
91         address tokenB,
92         uint amountADesired,
93         uint amountBDesired,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline
98     ) external returns (uint amountA, uint amountB, uint liquidity);
99 
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 
109     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116 
117     function swapExactETHForTokensSupportingFeeOnTransferTokens(
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external payable;
123 
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131 }
132 
133 interface InterfaceLP {
134     function sync() external;
135 }
136 
137 
138 library SafeMath {
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return div(a, b, "SafeMath: division by zero");
166     }
167     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b > 0, errorMessage);
169         uint256 c = a / b;
170         return c;
171     }
172 }
173 
174 contract PEPE40 is Ownable, ERC20 {
175     using SafeMath for uint256;
176 
177     address WETH;
178     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
179     address constant ZERO = 0x0000000000000000000000000000000000000000;
180     
181 
182     string constant _name = "Pepe 4.0";
183     string constant _symbol = "PEPE4.0";
184     uint8 constant _decimals = 18; 
185 
186 
187     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
188     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
189     event user_exemptfromfees(address Wallet, bool Exempt);
190     event user_TxExempt(address Wallet, bool Exempt);
191     event ClearStuck(uint256 amount);
192     event ClearToken(address TokenAddressCleared, uint256 Amount);
193     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
194     event set_MaxWallet(uint256 maxWallet);
195     event set_MaxTX(uint256 maxTX);
196     event set_SwapBack(uint256 Amount, bool Enabled);
197   
198     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
199 
200     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
201     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
202 
203     mapping (address => uint256) _balances;
204     mapping (address => mapping (address => uint256)) _allowances;  
205     mapping (address => bool) isexemptfromfees;
206     mapping (address => bool) isexemptfrommaxTX;
207 
208     uint256 private liquidityFee    = 0;
209     uint256 private marketingFee    = 1;
210     uint256 private devFee          = 0;
211     uint256 private buybackFee      = 0; 
212     uint256 private burnFee         = 0;
213     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
214     uint256 private feeDenominator  = 100;
215 
216     uint256 sellpercent = 100;
217     uint256 buypercent = 100;
218     uint256 transferpercent = 100; 
219 
220     address private autoLiquidityReceiver;
221     address private marketingFeeReceiver;
222     address private devFeeReceiver;
223     address private buybackFeeReceiver;
224     address private burnFeeReceiver;
225 
226     uint256 setRatio = 30;
227     uint256 setRatioDenominator = 100;
228     
229 
230     IDEXRouter public router;
231     InterfaceLP private pairContract;
232     address public pair;
233     
234     bool public TradingOpen = false; 
235 
236    
237     bool public swapEnabled = true;
238     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
239     bool inSwap;
240     modifier swapping() { inSwap = true; _; inSwap = false; }
241     
242     constructor () {
243         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
244         WETH = router.WETH();
245         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
246         pairContract = InterfaceLP(pair);
247        
248         
249         _allowances[address(this)][address(router)] = type(uint256).max;
250 
251         isexemptfromfees[msg.sender] = true;            
252         isexemptfrommaxTX[msg.sender] = true;
253         isexemptfrommaxTX[pair] = true;
254         isexemptfrommaxTX[marketingFeeReceiver] = true;
255         isexemptfrommaxTX[address(this)] = true;
256         
257         autoLiquidityReceiver = msg.sender;
258         marketingFeeReceiver = 0x35c17Bd9E35280c3b5058E95C5aB563254f08DD8;
259         devFeeReceiver = msg.sender;
260         buybackFeeReceiver = msg.sender;
261         burnFeeReceiver = DEAD; 
262 
263         _balances[msg.sender] = _totalSupply;
264         emit Transfer(address(0), msg.sender, _totalSupply);
265 
266     }
267 
268     receive() external payable { }
269 
270     function totalSupply() external view override returns (uint256) { return _totalSupply; }
271     function decimals() external pure override returns (uint8) { return _decimals; }
272     function symbol() external pure override returns (string memory) { return _symbol; }
273     function name() external pure override returns (string memory) { return _name; }
274     function getOwner() external view override returns (address) {return owner();}
275     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
276     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
277 
278     function approve(address spender, uint256 amount) public override returns (bool) {
279         _allowances[msg.sender][spender] = amount;
280         emit Approval(msg.sender, spender, amount);
281         return true;
282     }
283 
284     function approveMax(address spender) external returns (bool) {
285         return approve(spender, type(uint256).max);
286     }
287 
288     function transfer(address recipient, uint256 amount) external override returns (bool) {
289         return _transferFrom(msg.sender, recipient, amount);
290     }
291 
292     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
293         if(_allowances[sender][msg.sender] != type(uint256).max){
294             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
295         }
296 
297         return _transferFrom(sender, recipient, amount);
298     }
299 
300         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
301          require(maxWallPercent >= 1); 
302         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
303         emit set_MaxWallet(_maxWalletToken);
304                 
305     }
306 
307       function removeLimits () external onlyOwner {
308             _maxTxAmount = _totalSupply;
309             _maxWalletToken = _totalSupply;
310     }
311 
312       
313     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
314         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
315 
316         if(!authorizations[sender] && !authorizations[recipient]){
317             require(TradingOpen,"Trading not open yet");
318         
319           }
320         
321                
322         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
323             uint256 heldTokens = balanceOf(recipient);
324             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
325 
326         checkTxLimit(sender, amount);  
327 
328         if(shouldSwapBack()){ swapBack(); }
329         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
330 
331         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
332         _balances[recipient] = _balances[recipient].add(amountReceived);
333 
334         emit Transfer(sender, recipient, amountReceived);
335         return true;
336     }
337  
338     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
339         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
340         _balances[recipient] = _balances[recipient].add(amount);
341         emit Transfer(sender, recipient, amount);
342         return true;
343     }
344 
345     function checkTxLimit(address sender, uint256 amount) internal view {
346         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
347     }
348 
349     function shouldTakeFee(address sender) internal view returns (bool) {
350         return !isexemptfromfees[sender];
351     }
352 
353     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
354         
355         uint256 percent = transferpercent;
356         if(recipient == pair) {
357             percent = sellpercent;
358         } else if(sender == pair) {
359             percent = buypercent;
360         }
361 
362         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
363         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
364         uint256 contractTokens = feeAmount.sub(burnTokens);
365         _balances[address(this)] = _balances[address(this)].add(contractTokens);
366         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
367         emit Transfer(sender, address(this), contractTokens);
368         
369         
370         if(burnTokens > 0){
371             _totalSupply = _totalSupply.sub(burnTokens);
372             emit Transfer(sender, ZERO, burnTokens);  
373         
374         }
375 
376         return amount.sub(feeAmount);
377     }
378 
379     function shouldSwapBack() internal view returns (bool) {
380         return msg.sender != pair
381         && !inSwap
382         && swapEnabled
383         && _balances[address(this)] >= swapThreshold;
384     }
385 
386   
387      function manualSend() external { 
388              payable(autoLiquidityReceiver).transfer(address(this).balance);
389             
390     }
391 
392    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
393              if(tokens == 0){
394             tokens = ERC20(tokenAddress).balanceOf(address(this));
395         }
396         emit ClearToken(tokenAddress, tokens);
397         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
398     }
399 
400     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
401         sellpercent = _percentonsell;
402         buypercent = _percentonbuy;
403         transferpercent = _wallettransfer;    
404           
405     }
406        
407     function startTrading() public onlyOwner {
408         TradingOpen = true;
409         buypercent = 1400;
410         sellpercent = 800;
411         transferpercent = 1000;
412                               
413     }
414 
415       function reduceFee() public onlyOwner {
416        
417         buypercent = 400;
418         sellpercent = 700;
419         transferpercent = 500;
420                               
421     }
422 
423              
424     function swapBack() internal swapping {
425         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
426         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
427         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
428 
429         address[] memory path = new address[](2);
430         path[0] = address(this);
431         path[1] = WETH;
432 
433         uint256 balanceBefore = address(this).balance;
434 
435         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
436             amountToSwap,
437             0,
438             path,
439             address(this),
440             block.timestamp
441         );
442 
443         uint256 amountETH = address(this).balance.sub(balanceBefore);
444 
445         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
446         
447         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
448         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
449         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
450         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
451 
452         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
453         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
454         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
455         
456         tmpSuccess = false;
457 
458         if(amountToLiquify > 0){
459             router.addLiquidityETH{value: amountETHLiquidity}(
460                 address(this),
461                 amountToLiquify,
462                 0,
463                 0,
464                 autoLiquidityReceiver,
465                 block.timestamp
466             );
467             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
468         }
469     }
470     
471   
472     function set_fees() internal {
473       
474         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
475             uint8(totalFee.mul(sellpercent).div(100)),
476             uint8(totalFee.mul(transferpercent).div(100))
477             );
478     }
479     
480     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
481         liquidityFee = _liquidityFee;
482         buybackFee = _buybackFee;
483         marketingFee = _marketingFee;
484         devFee = _devFee;
485         burnFee = _burnFee;
486         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
487         feeDenominator = _feeDenominator;
488         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
489         set_fees();
490     }
491 
492    
493     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
494         autoLiquidityReceiver = _autoLiquidityReceiver;
495         marketingFeeReceiver = _marketingFeeReceiver;
496         devFeeReceiver = _devFeeReceiver;
497         burnFeeReceiver = _burnFeeReceiver;
498         buybackFeeReceiver = _buybackFeeReceiver;
499 
500         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
501     }
502 
503     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
504         swapEnabled = _enabled;
505         swapThreshold = _amount;
506         emit set_SwapBack(swapThreshold, swapEnabled);
507     }
508 
509     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
510         return showBacking(accuracy) > ratio;
511     }
512 
513     function showBacking(uint256 accuracy) public view returns (uint256) {
514         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
515     }
516     
517     function showSupply() public view returns (uint256) {
518         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
519     }
520 
521 
522 }