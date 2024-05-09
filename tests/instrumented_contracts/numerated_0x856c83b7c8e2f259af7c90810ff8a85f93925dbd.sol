1 /**
2 https://twitter.com/ForeverFlokiERC
3 https://forever-floki.com
4 https://t.me/ForeverFlokiERC
5 */
6 
7 
8 // SPDX-License-Identifier: MIT
9 
10 
11 pragma solidity 0.8.20;
12 
13 interface ERC20 {
14     function totalSupply() external view returns (uint256);
15     function decimals() external view returns (uint8);
16     function symbol() external view returns (string memory);
17     function name() external view returns (string memory);
18     function getOwner() external view returns (address);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address _owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 abstract contract Context {
31     
32     function _msgSender() internal view virtual returns (address payable) {
33         return payable(msg.sender);
34     }
35 
36     function _msgData() internal view virtual returns (bytes memory) {
37         this;
38         return msg.data;
39     }
40 }
41 
42 contract Ownable is Context {
43     address public _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     constructor () {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         authorizations[_owner] = true;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53     mapping (address => bool) internal authorizations;
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 interface IDEXFactory {
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 }
79 
80 interface IDEXRouter {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83 
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94 
95     function addLiquidityETH(
96         address token,
97         uint amountTokenDesired,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline
102     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
103 
104     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111 
112     function swapExactETHForTokensSupportingFeeOnTransferTokens(
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external payable;
118 
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126 }
127 
128 interface InterfaceLP {
129     function sync() external;
130 }
131 
132 
133 library SafeMath {
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return div(a, b, "SafeMath: division by zero");
161     }
162     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         return c;
166     }
167 }
168 
169 contract ForeverFloki is Ownable, ERC20 {
170     using SafeMath for uint256;
171 
172     address WETH;
173     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
174     address constant ZERO = 0x0000000000000000000000000000000000000000;
175     
176 
177     string constant _name = "Forever Floki";
178     string constant _symbol = "FFLOKI";
179     uint8 constant _decimals = 18; 
180 
181 
182     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
183     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
184     event user_exemptfromfees(address Wallet, bool Exempt);
185     event user_TxExempt(address Wallet, bool Exempt);
186     event ClearStuck(uint256 amount);
187     event ClearToken(address TokenAddressCleared, uint256 Amount);
188     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
189     event set_MaxWallet(uint256 maxWallet);
190     event set_MaxTX(uint256 maxTX);
191     event set_SwapBack(uint256 Amount, bool Enabled);
192   
193     uint256 _totalSupply =  1000000000000 * 10**_decimals; 
194 
195     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
196     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
197 
198     mapping (address => uint256) _balances;
199     mapping (address => mapping (address => uint256)) _allowances;  
200     mapping (address => bool) isexemptfromfees;
201     mapping (address => bool) isexemptfrommaxTX;
202 
203     uint256 private liquidityFee    = 1;
204     uint256 private marketingFee    = 3;
205     uint256 private devFee          = 0;
206     uint256 private buybackFee      = 1; 
207     uint256 private burnFee         = 0;
208     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
209     uint256 private feeDenominator  = 100;
210 
211     uint256 sellpercent = 100;
212     uint256 buypercent = 100;
213     uint256 transferpercent = 100; 
214 
215     address private autoLiquidityReceiver;
216     address private marketingFeeReceiver;
217     address private devFeeReceiver;
218     address private buybackFeeReceiver;
219     address private burnFeeReceiver;
220 
221     uint256 setRatio = 30;
222     uint256 setRatioDenominator = 100;
223     
224 
225     IDEXRouter public router;
226     InterfaceLP private pairContract;
227     address public pair;
228     
229     bool public TradingOpen = false; 
230 
231    
232     bool public swapEnabled = true;
233     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
234     bool inSwap;
235     modifier swapping() { inSwap = true; _; inSwap = false; }
236     
237     constructor () {
238         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
239         WETH = router.WETH();
240         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
241         pairContract = InterfaceLP(pair);
242        
243         
244         _allowances[address(this)][address(router)] = type(uint256).max;
245 
246         isexemptfromfees[msg.sender] = true;            
247         isexemptfrommaxTX[msg.sender] = true;
248         isexemptfrommaxTX[pair] = true;
249         isexemptfrommaxTX[marketingFeeReceiver] = true;
250         isexemptfrommaxTX[address(this)] = true;
251         
252         autoLiquidityReceiver = msg.sender;
253         marketingFeeReceiver = 0x31060b21Ca1567ace52CaCAdb4d628a2e4603353;
254         devFeeReceiver = msg.sender;
255         buybackFeeReceiver = msg.sender;
256         burnFeeReceiver = DEAD; 
257 
258         _balances[msg.sender] = _totalSupply;
259         emit Transfer(address(0), msg.sender, _totalSupply);
260 
261     }
262 
263     receive() external payable { }
264 
265     function totalSupply() external view override returns (uint256) { return _totalSupply; }
266     function decimals() external pure override returns (uint8) { return _decimals; }
267     function symbol() external pure override returns (string memory) { return _symbol; }
268     function name() external pure override returns (string memory) { return _name; }
269     function getOwner() external view override returns (address) {return owner();}
270     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
271     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
272 
273     function approve(address spender, uint256 amount) public override returns (bool) {
274         _allowances[msg.sender][spender] = amount;
275         emit Approval(msg.sender, spender, amount);
276         return true;
277     }
278 
279     function approveMax(address spender) external returns (bool) {
280         return approve(spender, type(uint256).max);
281     }
282 
283     function transfer(address recipient, uint256 amount) external override returns (bool) {
284         return _transferFrom(msg.sender, recipient, amount);
285     }
286 
287     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
288         if(_allowances[sender][msg.sender] != type(uint256).max){
289             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
290         }
291 
292         return _transferFrom(sender, recipient, amount);
293     }
294 
295         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
296          require(maxWallPercent >= 1); 
297         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
298         emit set_MaxWallet(_maxWalletToken);
299                 
300     }
301 
302       function removeLimits () external onlyOwner {
303             _maxTxAmount = _totalSupply;
304             _maxWalletToken = _totalSupply;
305     }
306 
307       
308     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
309         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
310 
311         if(!authorizations[sender] && !authorizations[recipient]){
312             require(TradingOpen,"Trading not open yet");
313         
314           }
315         
316                
317         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
318             uint256 heldTokens = balanceOf(recipient);
319             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
320 
321         checkTxLimit(sender, amount);  
322 
323         if(shouldSwapBack()){ swapBack(); }
324         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
325 
326         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
327         _balances[recipient] = _balances[recipient].add(amountReceived);
328 
329         emit Transfer(sender, recipient, amountReceived);
330         return true;
331     }
332  
333     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
334         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337         return true;
338     }
339 
340     function checkTxLimit(address sender, uint256 amount) internal view {
341         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
342     }
343 
344     function shouldTakeFee(address sender) internal view returns (bool) {
345         return !isexemptfromfees[sender];
346     }
347 
348     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
349         
350         uint256 percent = transferpercent;
351         if(recipient == pair) {
352             percent = sellpercent;
353         } else if(sender == pair) {
354             percent = buypercent;
355         }
356 
357         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
358         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
359         uint256 contractTokens = feeAmount.sub(burnTokens);
360         _balances[address(this)] = _balances[address(this)].add(contractTokens);
361         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
362         emit Transfer(sender, address(this), contractTokens);
363         
364         
365         if(burnTokens > 0){
366             _totalSupply = _totalSupply.sub(burnTokens);
367             emit Transfer(sender, ZERO, burnTokens);  
368         
369         }
370 
371         return amount.sub(feeAmount);
372     }
373 
374     function shouldSwapBack() internal view returns (bool) {
375         return msg.sender != pair
376         && !inSwap
377         && swapEnabled
378         && _balances[address(this)] >= swapThreshold;
379     }
380 
381   
382      function manualSend() external { 
383              payable(autoLiquidityReceiver).transfer(address(this).balance);
384             
385     }
386 
387    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
388              if(tokens == 0){
389             tokens = ERC20(tokenAddress).balanceOf(address(this));
390         }
391         emit ClearToken(tokenAddress, tokens);
392         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
393     }
394 
395     function setPercents(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
396         sellpercent = _percentonsell;
397         buypercent = _percentonbuy;
398         transferpercent = _wallettransfer;    
399           
400     }
401        
402     function startTrading() public onlyOwner {
403         TradingOpen = true;
404         buypercent = 1200;
405         sellpercent = 800;
406         transferpercent = 1000;
407                               
408     }
409 
410       function reduceFee() public onlyOwner {
411        
412         buypercent = 400;
413         sellpercent = 700;
414         transferpercent = 500;
415                               
416     }
417 
418              
419     function swapBack() internal swapping {
420         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
421         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
422         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
423 
424         address[] memory path = new address[](2);
425         path[0] = address(this);
426         path[1] = WETH;
427 
428         uint256 balanceBefore = address(this).balance;
429 
430         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
431             amountToSwap,
432             0,
433             path,
434             address(this),
435             block.timestamp
436         );
437 
438         uint256 amountETH = address(this).balance.sub(balanceBefore);
439 
440         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
441         
442         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
443         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
444         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
445         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
446 
447         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
448         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
449         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
450         
451         tmpSuccess = false;
452 
453         if(amountToLiquify > 0){
454             router.addLiquidityETH{value: amountETHLiquidity}(
455                 address(this),
456                 amountToLiquify,
457                 0,
458                 0,
459                 autoLiquidityReceiver,
460                 block.timestamp
461             );
462             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
463         }
464     }
465     
466   
467     function set_fees() internal {
468       
469         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
470             uint8(totalFee.mul(sellpercent).div(100)),
471             uint8(totalFee.mul(transferpercent).div(100))
472             );
473     }
474     
475     function setTax(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
476         liquidityFee = _liquidityFee;
477         buybackFee = _buybackFee;
478         marketingFee = _marketingFee;
479         devFee = _devFee;
480         burnFee = _burnFee;
481         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
482         feeDenominator = _feeDenominator;
483         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
484         set_fees();
485     }
486 
487    
488     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
489         autoLiquidityReceiver = _autoLiquidityReceiver;
490         marketingFeeReceiver = _marketingFeeReceiver;
491         devFeeReceiver = _devFeeReceiver;
492         burnFeeReceiver = _burnFeeReceiver;
493         buybackFeeReceiver = _buybackFeeReceiver;
494 
495         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
496     }
497 
498     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
499         swapEnabled = _enabled;
500         swapThreshold = _amount;
501         emit set_SwapBack(swapThreshold, swapEnabled);
502     }
503 
504     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
505         return showBacking(accuracy) > ratio;
506     }
507 
508     function showBacking(uint256 accuracy) public view returns (uint256) {
509         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
510     }
511     
512     function showSupply() public view returns (uint256) {
513         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
514     }
515 
516 
517 }