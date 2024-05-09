1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-07-28
7 */
8 // Telegram https://t.me/echobotbinance
9 // Twitter https://twitter.com/EchoBinancebot
10 // Website https://www.echobot.info/
11 
12 
13 //SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.20;
16 
17 interface ERC20 {
18     function totalSupply() external view returns (uint256);
19     function decimals() external view returns (uint8);
20     function symbol() external view returns (string memory);
21     function name() external view returns (string memory);
22     function getOwner() external view returns (address);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address _owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 
33 
34 abstract contract Context {
35     
36     function _msgSender() internal view virtual returns (address payable) {
37         return payable(msg.sender);
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this;
42         return msg.data;
43     }
44 }
45 
46 contract Ownable is Context {
47     address public _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor () {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         authorizations[_owner] = true;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57     mapping (address => bool) internal authorizations;
58 
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 interface IDEXFactory {
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 interface IDEXRouter {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87 
88     function addLiquidity(
89         address tokenA,
90         address tokenB,
91         uint amountADesired,
92         uint amountBDesired,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline
97     ) external returns (uint amountA, uint amountB, uint liquidity);
98 
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107 
108     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115 
116     function swapExactETHForTokensSupportingFeeOnTransferTokens(
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external payable;
122 
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130 }
131 
132 interface InterfaceLP {
133     function sync() external;
134 }
135 
136 
137 library SafeMath {
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         return div(a, b, "SafeMath: division by zero");
165     }
166     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b > 0, errorMessage);
168         uint256 c = a / b;
169         return c;
170     }
171 }
172 
173 contract ECHO is Ownable, ERC20 {
174     using SafeMath for uint256;
175 
176     address WETH;
177     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
178     address constant ZERO = 0x0000000000000000000000000000000000000000;
179     
180 
181     string constant _name = "ECHO BOT";
182     string constant _symbol = "ECHO";
183     uint8 constant _decimals = 18; 
184 
185 
186     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
187     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
188     event user_exemptfromfees(address Wallet, bool Exempt);
189     event user_TxExempt(address Wallet, bool Exempt);
190     event ClearStuck(uint256 amount);
191     event ClearToken(address TokenAddressCleared, uint256 Amount);
192     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
193     event set_MaxWallet(uint256 maxWallet);
194     event set_MaxTX(uint256 maxTX);
195     event set_SwapBack(uint256 Amount, bool Enabled);
196   
197     uint256 _totalSupply = 1000000000 * 10**_decimals; 
198 
199     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
200     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
201 
202     mapping (address => uint256) _balances;
203     mapping (address => mapping (address => uint256)) _allowances;  
204     mapping (address => bool) isexemptfromfees;
205     mapping (address => bool) isexemptfrommaxTX;
206 
207     uint256 private liquidityFee    = 1;
208     uint256 private marketingFee    = 2;
209     uint256 private devFee          = 0;
210     uint256 private buybackFee      = 1; 
211     uint256 private burnFee         = 0;
212     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
213     uint256 private feeDenominator  = 100;
214 
215     uint256 sellpercent = 100;
216     uint256 buypercent = 100;
217     uint256 transferpercent = 100; 
218 
219     address private autoLiquidityReceiver;
220     address private marketingFeeReceiver;
221     address private devFeeReceiver;
222     address private buybackFeeReceiver;
223     address private burnFeeReceiver;
224 
225     uint256 setRatio = 30;
226     uint256 setRatioDenominator = 100;
227     
228 
229     IDEXRouter public router;
230     InterfaceLP private pairContract;
231     address public pair;
232     
233     bool public TradingOpen = false; 
234 
235    
236     bool public swapEnabled = true;
237     uint256 public swapThreshold = _totalSupply * 4 / 1000; 
238     bool inSwap;
239     modifier swapping() { inSwap = true; _; inSwap = false; }
240     
241     constructor () {
242         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
243         WETH = router.WETH();
244         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
245         pairContract = InterfaceLP(pair);
246        
247         
248         _allowances[address(this)][address(router)] = type(uint256).max;
249 
250         isexemptfromfees[msg.sender] = true;            
251         isexemptfrommaxTX[msg.sender] = true;
252         isexemptfrommaxTX[pair] = true;
253         isexemptfrommaxTX[marketingFeeReceiver] = true;
254         isexemptfrommaxTX[address(this)] = true;
255         
256         autoLiquidityReceiver = msg.sender;
257         marketingFeeReceiver = 0x38aC5F9E972e14546126613313fB03618ee1A06f; 
258         devFeeReceiver = msg.sender;
259         buybackFeeReceiver = msg.sender;
260         burnFeeReceiver = DEAD; 
261 
262         _balances[msg.sender] = _totalSupply;
263         emit Transfer(address(0), msg.sender, _totalSupply);
264 
265     }
266 
267     receive() external payable { }
268 
269     function totalSupply() external view override returns (uint256) { return _totalSupply; }
270     function decimals() external pure override returns (uint8) { return _decimals; }
271     function symbol() external pure override returns (string memory) { return _symbol; }
272     function name() external pure override returns (string memory) { return _name; }
273     function getOwner() external view override returns (address) {return owner();}
274     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
275     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
276 
277     function approve(address spender, uint256 amount) public override returns (bool) {
278         _allowances[msg.sender][spender] = amount;
279         emit Approval(msg.sender, spender, amount);
280         return true;
281     }
282 
283     function approveMax(address spender) external returns (bool) {
284         return approve(spender, type(uint256).max);
285     }
286 
287     function transfer(address recipient, uint256 amount) external override returns (bool) {
288         return _transferFrom(msg.sender, recipient, amount);
289     }
290 
291     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
292         if(_allowances[sender][msg.sender] != type(uint256).max){
293             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
294         }
295 
296         return _transferFrom(sender, recipient, amount);
297     }
298 
299         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
300          require(maxWallPercent >= 1); 
301         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
302         emit set_MaxWallet(_maxWalletToken);
303                 
304     }
305 
306       function removeLimits () external onlyOwner {
307             _maxTxAmount = _totalSupply;
308             _maxWalletToken = _totalSupply;
309     }
310 
311       
312     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
313         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
314 
315         if(!authorizations[sender] && !authorizations[recipient]){
316             require(TradingOpen,"Trading not open yet");
317         
318           }
319         
320                
321         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
322             uint256 heldTokens = balanceOf(recipient);
323             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
324 
325         checkTxLimit(sender, amount);  
326 
327         if(shouldSwapBack()){ swapBack(); }
328         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
329 
330         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
331         _balances[recipient] = _balances[recipient].add(amountReceived);
332 
333         emit Transfer(sender, recipient, amountReceived);
334         return true;
335     }
336  
337     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
338         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
339         _balances[recipient] = _balances[recipient].add(amount);
340         emit Transfer(sender, recipient, amount);
341         return true;
342     }
343 
344     function checkTxLimit(address sender, uint256 amount) internal view {
345         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
346     }
347 
348     function shouldTakeFee(address sender) internal view returns (bool) {
349         return !isexemptfromfees[sender];
350     }
351 
352     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
353         
354         uint256 percent = transferpercent;
355         if(recipient == pair) {
356             percent = sellpercent;
357         } else if(sender == pair) {
358             percent = buypercent;
359         }
360 
361         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
362         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
363         uint256 contractTokens = feeAmount.sub(burnTokens);
364         _balances[address(this)] = _balances[address(this)].add(contractTokens);
365         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
366         emit Transfer(sender, address(this), contractTokens);
367         
368         
369         if(burnTokens > 0){
370             _totalSupply = _totalSupply.sub(burnTokens);
371             emit Transfer(sender, ZERO, burnTokens);  
372         
373         }
374 
375         return amount.sub(feeAmount);
376     }
377 
378     function shouldSwapBack() internal view returns (bool) {
379         return msg.sender != pair
380         && !inSwap
381         && swapEnabled
382         && _balances[address(this)] >= swapThreshold;
383     }
384 
385   
386      function manualSend() external { 
387              payable(autoLiquidityReceiver).transfer(address(this).balance);
388             
389     }
390 
391    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
392              if(tokens == 0){
393             tokens = ERC20(tokenAddress).balanceOf(address(this));
394         }
395         emit ClearToken(tokenAddress, tokens);
396         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
397     }
398 
399     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
400         sellpercent = _percentonsell;
401         buypercent = _percentonbuy;
402         transferpercent = _wallettransfer;    
403           
404     }
405        
406     function startTrading() public onlyOwner {
407         TradingOpen = true;
408         buypercent = 800;
409         sellpercent = 1400;
410         transferpercent = 1400;
411                               
412     }
413 
414       function reduceFee() public onlyOwner {
415        
416         buypercent = 100;
417         sellpercent = 100;
418         transferpercent = 100;
419                               
420     }
421 
422              
423     function swapBack() internal swapping {
424         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
425         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
426         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
427 
428         address[] memory path = new address[](2);
429         path[0] = address(this);
430         path[1] = WETH;
431 
432         uint256 balanceBefore = address(this).balance;
433 
434         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
435             amountToSwap,
436             0,
437             path,
438             address(this),
439             block.timestamp
440         );
441 
442         uint256 amountETH = address(this).balance.sub(balanceBefore);
443 
444         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
445         
446         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
447         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
448         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
449         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
450 
451         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
452         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
453         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
454         
455         tmpSuccess = false;
456 
457         if(amountToLiquify > 0){
458             router.addLiquidityETH{value: amountETHLiquidity}(
459                 address(this),
460                 amountToLiquify,
461                 0,
462                 0,
463                 autoLiquidityReceiver,
464                 block.timestamp
465             );
466             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
467         }
468     }
469     
470   
471     function set_fees() internal {
472       
473         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
474             uint8(totalFee.mul(sellpercent).div(100)),
475             uint8(totalFee.mul(transferpercent).div(100))
476             );
477     }
478     
479     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
480         liquidityFee = _liquidityFee;
481         buybackFee = _buybackFee;
482         marketingFee = _marketingFee;
483         devFee = _devFee;
484         burnFee = _burnFee;
485         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
486         feeDenominator = _feeDenominator;
487         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
488         set_fees();
489     }
490 
491    
492     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
493         autoLiquidityReceiver = _autoLiquidityReceiver;
494         marketingFeeReceiver = _marketingFeeReceiver;
495         devFeeReceiver = _devFeeReceiver;
496         burnFeeReceiver = _burnFeeReceiver;
497         buybackFeeReceiver = _buybackFeeReceiver;
498 
499         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
500     }
501 
502     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
503         swapEnabled = _enabled;
504         swapThreshold = _amount;
505         emit set_SwapBack(swapThreshold, swapEnabled);
506     }
507 
508     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
509         return showBacking(accuracy) > ratio;
510     }
511 
512     function showBacking(uint256 accuracy) public view returns (uint256) {
513         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
514     }
515     
516     function showSupply() public view returns (uint256) {
517         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
518     }
519 
520 
521 }