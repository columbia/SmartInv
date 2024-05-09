1 /**
2 Welcome to ethdice.net - the first ever online casino where revenue is shared between token holders.
3 
4 https://t.me/ETHDICEOfficial
5 
6 https://ethdice.net/
7 */
8 
9 
10 
11 // SPDX-License-Identifier: MIT
12 
13 
14 pragma solidity 0.8.20;
15 
16 interface ERC20 {
17     function totalSupply() external view returns (uint256);
18     function decimals() external view returns (uint8);
19     function symbol() external view returns (string memory);
20     function name() external view returns (string memory);
21     function getOwner() external view returns (address);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address _owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 
32 
33 abstract contract Context {
34     
35     function _msgSender() internal view virtual returns (address payable) {
36         return payable(msg.sender);
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this;
41         return msg.data;
42     }
43 }
44 
45 contract Ownable is Context {
46     address public _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     constructor () {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         authorizations[_owner] = true;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56     mapping (address => bool) internal authorizations;
57 
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 interface IDEXFactory {
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 }
82 
83 interface IDEXRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86 
87     function addLiquidity(
88         address tokenA,
89         address tokenB,
90         uint amountADesired,
91         uint amountBDesired,
92         uint amountAMin,
93         uint amountBMin,
94         address to,
95         uint deadline
96     ) external returns (uint amountA, uint amountB, uint liquidity);
97 
98     function addLiquidityETH(
99         address token,
100         uint amountTokenDesired,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
106 
107     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114 
115     function swapExactETHForTokensSupportingFeeOnTransferTokens(
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external payable;
121 
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129 }
130 
131 interface InterfaceLP {
132     function sync() external;
133 }
134 
135 
136 library SafeMath {
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b > 0, errorMessage);
167         uint256 c = a / b;
168         return c;
169     }
170 }
171 
172 contract ETHDICE is Ownable, ERC20 {
173     using SafeMath for uint256;
174 
175     address WETH;
176     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
177     address constant ZERO = 0x0000000000000000000000000000000000000000;
178     
179 
180     string constant _name = "ETHDICE";
181     string constant _symbol = "ETHDICE";
182     uint8 constant _decimals = 18; 
183 
184 
185     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
186     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
187     event user_exemptfromfees(address Wallet, bool Exempt);
188     event user_TxExempt(address Wallet, bool Exempt);
189     event ClearStuck(uint256 amount);
190     event ClearToken(address TokenAddressCleared, uint256 Amount);
191     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
192     event set_MaxWallet(uint256 maxWallet);
193     event set_MaxTX(uint256 maxTX);
194     event set_SwapBack(uint256 Amount, bool Enabled);
195   
196     uint256 _totalSupply =  100000000000000 * 10**_decimals; 
197 
198     uint256 public _maxTxAmount = _totalSupply.mul(3).div(100);
199     uint256 public _maxWalletToken = _totalSupply.mul(3).div(100);
200 
201     mapping (address => uint256) _balances;
202     mapping (address => mapping (address => uint256)) _allowances;  
203     mapping (address => bool) isexemptfromfees;
204     mapping (address => bool) isexemptfrommaxTX;
205 
206     uint256 private liquidityFee    = 0;
207     uint256 private marketingFee    = 1;
208     uint256 private devFee          = 4;
209     uint256 private buybackFee      = 0; 
210     uint256 private burnFee         = 0;
211     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
212     uint256 private feeDenominator  = 100;
213 
214     uint256 sellpercent = 100;
215     uint256 buypercent = 100;
216     uint256 transferpercent = 100; 
217 
218     address private autoLiquidityReceiver;
219     address private marketingFeeReceiver;
220     address private devFeeReceiver;
221     address private buybackFeeReceiver;
222     address private burnFeeReceiver;
223 
224     uint256 setRatio = 30;
225     uint256 setRatioDenominator = 100;
226     
227 
228     IDEXRouter public router;
229     InterfaceLP private pairContract;
230     address public pair;
231     
232     bool public TradingOpen = false; 
233 
234    
235     bool public swapEnabled = true;
236     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
237     bool inSwap;
238     modifier swapping() { inSwap = true; _; inSwap = false; }
239     
240     constructor () {
241         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
242         WETH = router.WETH();
243         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
244         pairContract = InterfaceLP(pair);
245        
246         
247         _allowances[address(this)][address(router)] = type(uint256).max;
248 
249         isexemptfromfees[msg.sender] = true;            
250         isexemptfrommaxTX[msg.sender] = true;
251         isexemptfrommaxTX[pair] = true;
252         isexemptfrommaxTX[marketingFeeReceiver] = true;
253         isexemptfrommaxTX[address(this)] = true;
254         
255         autoLiquidityReceiver = msg.sender;
256         marketingFeeReceiver = 0xE0A7371c1F8A08795EBe978D2F83b3B56268f650;
257         devFeeReceiver = msg.sender;
258         buybackFeeReceiver = msg.sender;
259         burnFeeReceiver = DEAD; 
260 
261         _balances[msg.sender] = _totalSupply;
262         emit Transfer(address(0), msg.sender, _totalSupply);
263 
264     }
265 
266     receive() external payable { }
267 
268     function totalSupply() external view override returns (uint256) { return _totalSupply; }
269     function decimals() external pure override returns (uint8) { return _decimals; }
270     function symbol() external pure override returns (string memory) { return _symbol; }
271     function name() external pure override returns (string memory) { return _name; }
272     function getOwner() external view override returns (address) {return owner();}
273     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
274     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
275 
276     function approve(address spender, uint256 amount) public override returns (bool) {
277         _allowances[msg.sender][spender] = amount;
278         emit Approval(msg.sender, spender, amount);
279         return true;
280     }
281 
282     function approveMax(address spender) external returns (bool) {
283         return approve(spender, type(uint256).max);
284     }
285 
286     function transfer(address recipient, uint256 amount) external override returns (bool) {
287         return _transferFrom(msg.sender, recipient, amount);
288     }
289 
290     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
291         if(_allowances[sender][msg.sender] != type(uint256).max){
292             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
293         }
294 
295         return _transferFrom(sender, recipient, amount);
296     }
297 
298         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
299          require(maxWallPercent >= 1); 
300         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
301         emit set_MaxWallet(_maxWalletToken);
302                 
303     }
304 
305       function removeLimits () external onlyOwner {
306             _maxTxAmount = _totalSupply;
307             _maxWalletToken = _totalSupply;
308     }
309 
310       
311     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
312         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
313 
314         if(!authorizations[sender] && !authorizations[recipient]){
315             require(TradingOpen,"Trading not open yet");
316         
317           }
318         
319                
320         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
321             uint256 heldTokens = balanceOf(recipient);
322             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
323 
324         checkTxLimit(sender, amount);  
325 
326         if(shouldSwapBack()){ swapBack(); }
327         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
328 
329         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
330         _balances[recipient] = _balances[recipient].add(amountReceived);
331 
332         emit Transfer(sender, recipient, amountReceived);
333         return true;
334     }
335  
336     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
337         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
338         _balances[recipient] = _balances[recipient].add(amount);
339         emit Transfer(sender, recipient, amount);
340         return true;
341     }
342 
343     function checkTxLimit(address sender, uint256 amount) internal view {
344         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
345     }
346 
347     function shouldTakeFee(address sender) internal view returns (bool) {
348         return !isexemptfromfees[sender];
349     }
350 
351     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
352         
353         uint256 percent = transferpercent;
354         if(recipient == pair) {
355             percent = sellpercent;
356         } else if(sender == pair) {
357             percent = buypercent;
358         }
359 
360         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
361         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
362         uint256 contractTokens = feeAmount.sub(burnTokens);
363         _balances[address(this)] = _balances[address(this)].add(contractTokens);
364         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
365         emit Transfer(sender, address(this), contractTokens);
366         
367         
368         if(burnTokens > 0){
369             _totalSupply = _totalSupply.sub(burnTokens);
370             emit Transfer(sender, ZERO, burnTokens);  
371         
372         }
373 
374         return amount.sub(feeAmount);
375     }
376 
377     function shouldSwapBack() internal view returns (bool) {
378         return msg.sender != pair
379         && !inSwap
380         && swapEnabled
381         && _balances[address(this)] >= swapThreshold;
382     }
383 
384   
385      function manualSend() external { 
386              payable(autoLiquidityReceiver).transfer(address(this).balance);
387             
388     }
389 
390    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
391              if(tokens == 0){
392             tokens = ERC20(tokenAddress).balanceOf(address(this));
393         }
394         emit ClearToken(tokenAddress, tokens);
395         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
396     }
397 
398     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
399         sellpercent = _percentonsell;
400         buypercent = _percentonbuy;
401         transferpercent = _wallettransfer;    
402           
403     }
404        
405     function startTrading() public onlyOwner {
406         TradingOpen = true;
407         buypercent = 1400;
408         sellpercent = 800;
409         transferpercent = 1000;
410                               
411     }
412 
413       function reduceFee() public onlyOwner {
414        
415         buypercent = 400;
416         sellpercent = 700;
417         transferpercent = 500;
418                               
419     }
420 
421              
422     function swapBack() internal swapping {
423         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
424         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
425         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
426 
427         address[] memory path = new address[](2);
428         path[0] = address(this);
429         path[1] = WETH;
430 
431         uint256 balanceBefore = address(this).balance;
432 
433         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             amountToSwap,
435             0,
436             path,
437             address(this),
438             block.timestamp
439         );
440 
441         uint256 amountETH = address(this).balance.sub(balanceBefore);
442 
443         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
444         
445         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
446         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
447         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
448         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
449 
450         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
451         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
452         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
453         
454         tmpSuccess = false;
455 
456         if(amountToLiquify > 0){
457             router.addLiquidityETH{value: amountETHLiquidity}(
458                 address(this),
459                 amountToLiquify,
460                 0,
461                 0,
462                 autoLiquidityReceiver,
463                 block.timestamp
464             );
465             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
466         }
467     }
468     
469   
470     function set_fees() internal {
471       
472         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
473             uint8(totalFee.mul(sellpercent).div(100)),
474             uint8(totalFee.mul(transferpercent).div(100))
475             );
476     }
477     
478     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
479         liquidityFee = _liquidityFee;
480         buybackFee = _buybackFee;
481         marketingFee = _marketingFee;
482         devFee = _devFee;
483         burnFee = _burnFee;
484         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
485         feeDenominator = _feeDenominator;
486         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
487         set_fees();
488     }
489 
490    
491     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
492         autoLiquidityReceiver = _autoLiquidityReceiver;
493         marketingFeeReceiver = _marketingFeeReceiver;
494         devFeeReceiver = _devFeeReceiver;
495         burnFeeReceiver = _burnFeeReceiver;
496         buybackFeeReceiver = _buybackFeeReceiver;
497 
498         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
499     }
500 
501     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
502         swapEnabled = _enabled;
503         swapThreshold = _amount;
504         emit set_SwapBack(swapThreshold, swapEnabled);
505     }
506 
507     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
508         return showBacking(accuracy) > ratio;
509     }
510 
511     function showBacking(uint256 accuracy) public view returns (uint256) {
512         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
513     }
514     
515     function showSupply() public view returns (uint256) {
516         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
517     }
518 
519 
520 }