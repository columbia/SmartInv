1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-07-25
7 */
8 
9 /**
10  
11 */ 
12 
13 // Rugarium - Shibarium's Killer
14 // https://twitter.com/Rugarium
15 // https://t.me/Rugarium
16 
17 // SPDX-License-Identifier: MIT
18 
19 
20 pragma solidity 0.8.20;
21 
22 interface ERC20 {
23     function totalSupply() external view returns (uint256);
24     function decimals() external view returns (uint8);
25     function symbol() external view returns (string memory);
26     function name() external view returns (string memory);
27     function getOwner() external view returns (address);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address _owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38 
39 abstract contract Context {
40     
41     function _msgSender() internal view virtual returns (address payable) {
42         return payable(msg.sender);
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this;
47         return msg.data;
48     }
49 }
50 
51 contract Ownable is Context {
52     address public _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     constructor () {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         authorizations[_owner] = true;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62     mapping (address => bool) internal authorizations;
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 interface IDEXFactory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IDEXRouter {
90     function factory() external pure returns (address);
91     function WETH() external pure returns (address);
92 
93     function addLiquidity(
94         address tokenA,
95         address tokenB,
96         uint amountADesired,
97         uint amountBDesired,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline
102     ) external returns (uint amountA, uint amountB, uint liquidity);
103 
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 
113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120 
121     function swapExactETHForTokensSupportingFeeOnTransferTokens(
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external payable;
127 
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 }
136 
137 interface InterfaceLP {
138     function sync() external;
139 }
140 
141 
142 library SafeMath {
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         return div(a, b, "SafeMath: division by zero");
170     }
171     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174         return c;
175     }
176 }
177 
178 contract SHIB is Ownable, ERC20 {
179     using SafeMath for uint256;
180 
181     address WETH;
182     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
183     address constant ZERO = 0x0000000000000000000000000000000000000000;
184     
185 
186     string constant _name = "Rugarium";
187     string constant _symbol = "SHIB";
188     uint8 constant _decimals = 18; 
189 
190 
191     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
192     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
193     event user_exemptfromfees(address Wallet, bool Exempt);
194     event user_TxExempt(address Wallet, bool Exempt);
195     event ClearStuck(uint256 amount);
196     event ClearToken(address TokenAddressCleared, uint256 Amount);
197     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
198     event set_MaxWallet(uint256 maxWallet);
199     event set_MaxTX(uint256 maxTX);
200     event set_SwapBack(uint256 Amount, bool Enabled);
201   
202     uint256 _totalSupply =  100000000000000 * 10**_decimals; 
203 
204     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
205     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
206 
207     mapping (address => uint256) _balances;
208     mapping (address => mapping (address => uint256)) _allowances;  
209     mapping (address => bool) isexemptfromfees;
210     mapping (address => bool) isexemptfrommaxTX;
211 
212     uint256 private liquidityFee    = 1;
213     uint256 private marketingFee    = 3;
214     uint256 private devFee          = 0;
215     uint256 private buybackFee      = 1; 
216     uint256 private burnFee         = 0;
217     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
218     uint256 private feeDenominator  = 100;
219 
220     uint256 sellpercent = 100;
221     uint256 buypercent = 100;
222     uint256 transferpercent = 100; 
223 
224     address private autoLiquidityReceiver;
225     address private marketingFeeReceiver;
226     address private devFeeReceiver;
227     address private buybackFeeReceiver;
228     address private burnFeeReceiver;
229 
230     uint256 setRatio = 30;
231     uint256 setRatioDenominator = 100;
232     
233 
234     IDEXRouter public router;
235     InterfaceLP private pairContract;
236     address public pair;
237     
238     bool public TradingOpen = false; 
239 
240    
241     bool public swapEnabled = true;
242     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
243     bool inSwap;
244     modifier swapping() { inSwap = true; _; inSwap = false; }
245     
246     constructor () {
247         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
248         WETH = router.WETH();
249         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
250         pairContract = InterfaceLP(pair);
251        
252         
253         _allowances[address(this)][address(router)] = type(uint256).max;
254 
255         isexemptfromfees[msg.sender] = true;            
256         isexemptfrommaxTX[msg.sender] = true;
257         isexemptfrommaxTX[pair] = true;
258         isexemptfrommaxTX[marketingFeeReceiver] = true;
259         isexemptfrommaxTX[address(this)] = true;
260         
261         autoLiquidityReceiver = msg.sender;
262         marketingFeeReceiver = 0xB0FE6aa747d1614Ed638961612426585f3D752E1;
263         devFeeReceiver = msg.sender;
264         buybackFeeReceiver = msg.sender;
265         burnFeeReceiver = 0xB0FE6aa747d1614Ed638961612426585f3D752E1; 
266 
267         _balances[msg.sender] = _totalSupply;
268         emit Transfer(address(0), msg.sender, _totalSupply);
269 
270     }
271 
272     receive() external payable { }
273 
274     function totalSupply() external view override returns (uint256) { return _totalSupply; }
275     function decimals() external pure override returns (uint8) { return _decimals; }
276     function symbol() external pure override returns (string memory) { return _symbol; }
277     function name() external pure override returns (string memory) { return _name; }
278     function getOwner() external view override returns (address) {return owner();}
279     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
280     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
281 
282     function approve(address spender, uint256 amount) public override returns (bool) {
283         _allowances[msg.sender][spender] = amount;
284         emit Approval(msg.sender, spender, amount);
285         return true;
286     }
287 
288     function approveMax(address spender) external returns (bool) {
289         return approve(spender, type(uint256).max);
290     }
291 
292     function transfer(address recipient, uint256 amount) external override returns (bool) {
293         return _transferFrom(msg.sender, recipient, amount);
294     }
295 
296     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
297         if(_allowances[sender][msg.sender] != type(uint256).max){
298             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
299         }
300 
301         return _transferFrom(sender, recipient, amount);
302     }
303 
304         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
305          require(maxWallPercent >= 1); 
306         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
307         emit set_MaxWallet(_maxWalletToken);
308                 
309     }
310 
311       function removeLimits () external onlyOwner {
312             _maxTxAmount = _totalSupply;
313             _maxWalletToken = _totalSupply;
314     }
315 
316       
317     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
318         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
319 
320         if(!authorizations[sender] && !authorizations[recipient]){
321             require(TradingOpen,"Trading not open yet");
322         
323           }
324         
325                
326         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
327             uint256 heldTokens = balanceOf(recipient);
328             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
329 
330         checkTxLimit(sender, amount);  
331 
332         if(shouldSwapBack()){ swapBack(); }
333         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
334 
335         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
336         _balances[recipient] = _balances[recipient].add(amountReceived);
337 
338         emit Transfer(sender, recipient, amountReceived);
339         return true;
340     }
341  
342     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
343         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
344         _balances[recipient] = _balances[recipient].add(amount);
345         emit Transfer(sender, recipient, amount);
346         return true;
347     }
348 
349     function checkTxLimit(address sender, uint256 amount) internal view {
350         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
351     }
352 
353     function shouldTakeFee(address sender) internal view returns (bool) {
354         return !isexemptfromfees[sender];
355     }
356 
357     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
358         
359         uint256 percent = transferpercent;
360         if(recipient == pair) {
361             percent = sellpercent;
362         } else if(sender == pair) {
363             percent = buypercent;
364         }
365 
366         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
367         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
368         uint256 contractTokens = feeAmount.sub(burnTokens);
369         _balances[address(this)] = _balances[address(this)].add(contractTokens);
370         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
371         emit Transfer(sender, address(this), contractTokens);
372         
373         
374         if(burnTokens > 0){
375             _totalSupply = _totalSupply.sub(burnTokens);
376             emit Transfer(sender, ZERO, burnTokens);  
377         
378         }
379 
380         return amount.sub(feeAmount);
381     }
382 
383     function shouldSwapBack() internal view returns (bool) {
384         return msg.sender != pair
385         && !inSwap
386         && swapEnabled
387         && _balances[address(this)] >= swapThreshold;
388     }
389 
390   
391      function manualSend() external { 
392              payable(autoLiquidityReceiver).transfer(address(this).balance);
393             
394     }
395 
396    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
397              if(tokens == 0){
398             tokens = ERC20(tokenAddress).balanceOf(address(this));
399         }
400         emit ClearToken(tokenAddress, tokens);
401         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
402     }
403 
404     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
405         sellpercent = _percentonsell;
406         buypercent = _percentonbuy;
407         transferpercent = _wallettransfer;    
408           
409     }
410        
411     function startTrading() public onlyOwner {
412         TradingOpen = true;
413         buypercent = 800;
414         sellpercent = 800;
415         transferpercent = 1000;
416                               
417     }
418 
419       function reduceFee() public onlyOwner {
420        
421         buypercent = 400;
422         sellpercent = 700;
423         transferpercent = 500;
424                               
425     }
426 
427              
428     function swapBack() internal swapping {
429         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
430         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
431         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
432 
433         address[] memory path = new address[](2);
434         path[0] = address(this);
435         path[1] = WETH;
436 
437         uint256 balanceBefore = address(this).balance;
438 
439         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
440             amountToSwap,
441             0,
442             path,
443             address(this),
444             block.timestamp
445         );
446 
447         uint256 amountETH = address(this).balance.sub(balanceBefore);
448 
449         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
450         
451         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
452         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
453         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
454         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
455 
456         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
457         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
458         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
459         
460         tmpSuccess = false;
461 
462         if(amountToLiquify > 0){
463             router.addLiquidityETH{value: amountETHLiquidity}(
464                 address(this),
465                 amountToLiquify,
466                 0,
467                 0,
468                 autoLiquidityReceiver,
469                 block.timestamp
470             );
471             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
472         }
473     }
474     
475   
476     function set_fees() internal {
477       
478         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
479             uint8(totalFee.mul(sellpercent).div(100)),
480             uint8(totalFee.mul(transferpercent).div(100))
481             );
482     }
483     
484     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
485         liquidityFee = _liquidityFee;
486         buybackFee = _buybackFee;
487         marketingFee = _marketingFee;
488         devFee = _devFee;
489         burnFee = _burnFee;
490         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
491         feeDenominator = _feeDenominator;
492         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
493         set_fees();
494     }
495 
496    
497     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
498         autoLiquidityReceiver = _autoLiquidityReceiver;
499         marketingFeeReceiver = _marketingFeeReceiver;
500         devFeeReceiver = _devFeeReceiver;
501         burnFeeReceiver = _burnFeeReceiver;
502         buybackFeeReceiver = _buybackFeeReceiver;
503 
504         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
505     }
506 
507     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
508         swapEnabled = _enabled;
509         swapThreshold = _amount;
510         emit set_SwapBack(swapThreshold, swapEnabled);
511     }
512 
513     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
514         return showBacking(accuracy) > ratio;
515     }
516 
517     function showBacking(uint256 accuracy) public view returns (uint256) {
518         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
519     }
520     
521     function showSupply() public view returns (uint256) {
522         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
523     }
524 
525 
526 }