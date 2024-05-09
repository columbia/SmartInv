1 // https://twitter.com/Bob2_CoinETH
2 
3 // https://t.me/bob2eth
4 
5 // https://explainthisbob20.com/
6 
7 
8 
9 // SPDX-License-Identifier: MIT
10 
11 
12 pragma solidity 0.8.20;
13 
14 interface ERC20 {
15     function totalSupply() external view returns (uint256);
16     function decimals() external view returns (uint8);
17     function symbol() external view returns (string memory);
18     function name() external view returns (string memory);
19     function getOwner() external view returns (address);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address _owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 
30 
31 abstract contract Context {
32     
33     function _msgSender() internal view virtual returns (address payable) {
34         return payable(msg.sender);
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this;
39         return msg.data;
40     }
41 }
42 
43 contract Ownable is Context {
44     address public _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     constructor () {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         authorizations[_owner] = true;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54     mapping (address => bool) internal authorizations;
55 
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 interface IDEXFactory {
78     function createPair(address tokenA, address tokenB) external returns (address pair);
79 }
80 
81 interface IDEXRouter {
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84 
85     function addLiquidity(
86         address tokenA,
87         address tokenB,
88         uint amountADesired,
89         uint amountBDesired,
90         uint amountAMin,
91         uint amountBMin,
92         address to,
93         uint deadline
94     ) external returns (uint amountA, uint amountB, uint liquidity);
95 
96     function addLiquidityETH(
97         address token,
98         uint amountTokenDesired,
99         uint amountTokenMin,
100         uint amountETHMin,
101         address to,
102         uint deadline
103     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
104 
105     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112 
113     function swapExactETHForTokensSupportingFeeOnTransferTokens(
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external payable;
119 
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127 }
128 
129 interface InterfaceLP {
130     function sync() external;
131 }
132 
133 
134 library SafeMath {
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         return div(a, b, "SafeMath: division by zero");
162     }
163     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b > 0, errorMessage);
165         uint256 c = a / b;
166         return c;
167     }
168 }
169 
170 contract Bob20 is Ownable, ERC20 {
171     using SafeMath for uint256;
172 
173     address WETH;
174     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
175     address constant ZERO = 0x0000000000000000000000000000000000000000;
176     
177 
178     string constant _name = "Bob 2.0";
179     string constant _symbol = "BOB2.0";
180     uint8 constant _decimals = 18; 
181 
182 
183     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
184     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
185     event user_exemptfromfees(address Wallet, bool Exempt);
186     event user_TxExempt(address Wallet, bool Exempt);
187     event ClearStuck(uint256 amount);
188     event ClearToken(address TokenAddressCleared, uint256 Amount);
189     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
190     event set_MaxWallet(uint256 maxWallet);
191     event set_MaxTX(uint256 maxTX);
192     event set_SwapBack(uint256 Amount, bool Enabled);
193   
194     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
195 
196     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
197     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
198 
199     mapping (address => uint256) _balances;
200     mapping (address => mapping (address => uint256)) _allowances;  
201     mapping (address => bool) isexemptfromfees;
202     mapping (address => bool) isexemptfrommaxTX;
203 
204     uint256 private liquidityFee    = 1;
205     uint256 private marketingFee    = 3;
206     uint256 private devFee          = 0;
207     uint256 private buybackFee      = 1; 
208     uint256 private burnFee         = 0;
209     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
210     uint256 private feeDenominator  = 100;
211 
212     uint256 sellpercent = 100;
213     uint256 buypercent = 100;
214     uint256 transferpercent = 100; 
215 
216     address private autoLiquidityReceiver;
217     address private marketingFeeReceiver;
218     address private devFeeReceiver;
219     address private buybackFeeReceiver;
220     address private burnFeeReceiver;
221 
222     uint256 setRatio = 30;
223     uint256 setRatioDenominator = 100;
224     
225 
226     IDEXRouter public router;
227     InterfaceLP private pairContract;
228     address public pair;
229     
230     bool public TradingOpen = false; 
231 
232    
233     bool public swapEnabled = true;
234     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
235     bool inSwap;
236     modifier swapping() { inSwap = true; _; inSwap = false; }
237     
238     constructor () {
239         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
240         WETH = router.WETH();
241         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
242         pairContract = InterfaceLP(pair);
243        
244         
245         _allowances[address(this)][address(router)] = type(uint256).max;
246 
247         isexemptfromfees[msg.sender] = true;            
248         isexemptfrommaxTX[msg.sender] = true;
249         isexemptfrommaxTX[pair] = true;
250         isexemptfrommaxTX[marketingFeeReceiver] = true;
251         isexemptfrommaxTX[address(this)] = true;
252         
253         autoLiquidityReceiver = msg.sender;
254         marketingFeeReceiver = 0x213e9Ee8969e198b878f4dAab225395114FB7060;
255         devFeeReceiver = msg.sender;
256         buybackFeeReceiver = msg.sender;
257         burnFeeReceiver = DEAD; 
258 
259         _balances[msg.sender] = _totalSupply;
260         emit Transfer(address(0), msg.sender, _totalSupply);
261 
262     }
263 
264     receive() external payable { }
265 
266     function totalSupply() external view override returns (uint256) { return _totalSupply; }
267     function decimals() external pure override returns (uint8) { return _decimals; }
268     function symbol() external pure override returns (string memory) { return _symbol; }
269     function name() external pure override returns (string memory) { return _name; }
270     function getOwner() external view override returns (address) {return owner();}
271     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
272     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
273 
274     function approve(address spender, uint256 amount) public override returns (bool) {
275         _allowances[msg.sender][spender] = amount;
276         emit Approval(msg.sender, spender, amount);
277         return true;
278     }
279 
280     function approveMax(address spender) external returns (bool) {
281         return approve(spender, type(uint256).max);
282     }
283 
284     function transfer(address recipient, uint256 amount) external override returns (bool) {
285         return _transferFrom(msg.sender, recipient, amount);
286     }
287 
288     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
289         if(_allowances[sender][msg.sender] != type(uint256).max){
290             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
291         }
292 
293         return _transferFrom(sender, recipient, amount);
294     }
295 
296         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
297          require(maxWallPercent >= 1); 
298         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
299         emit set_MaxWallet(_maxWalletToken);
300                 
301     }
302 
303       function removeLimits () external onlyOwner {
304             _maxTxAmount = _totalSupply;
305             _maxWalletToken = _totalSupply;
306     }
307 
308       
309     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
310         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
311 
312         if(!authorizations[sender] && !authorizations[recipient]){
313             require(TradingOpen,"Trading not open yet");
314         
315           }
316         
317                
318         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
319             uint256 heldTokens = balanceOf(recipient);
320             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
321 
322         checkTxLimit(sender, amount);  
323 
324         if(shouldSwapBack()){ swapBack(); }
325         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
326 
327         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
328         _balances[recipient] = _balances[recipient].add(amountReceived);
329 
330         emit Transfer(sender, recipient, amountReceived);
331         return true;
332     }
333  
334     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
335         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
336         _balances[recipient] = _balances[recipient].add(amount);
337         emit Transfer(sender, recipient, amount);
338         return true;
339     }
340 
341     function checkTxLimit(address sender, uint256 amount) internal view {
342         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
343     }
344 
345     function shouldTakeFee(address sender) internal view returns (bool) {
346         return !isexemptfromfees[sender];
347     }
348 
349     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
350         
351         uint256 percent = transferpercent;
352         if(recipient == pair) {
353             percent = sellpercent;
354         } else if(sender == pair) {
355             percent = buypercent;
356         }
357 
358         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
359         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
360         uint256 contractTokens = feeAmount.sub(burnTokens);
361         _balances[address(this)] = _balances[address(this)].add(contractTokens);
362         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
363         emit Transfer(sender, address(this), contractTokens);
364         
365         
366         if(burnTokens > 0){
367             _totalSupply = _totalSupply.sub(burnTokens);
368             emit Transfer(sender, ZERO, burnTokens);  
369         
370         }
371 
372         return amount.sub(feeAmount);
373     }
374 
375     function shouldSwapBack() internal view returns (bool) {
376         return msg.sender != pair
377         && !inSwap
378         && swapEnabled
379         && _balances[address(this)] >= swapThreshold;
380     }
381 
382   
383      function manualSend() external { 
384              payable(autoLiquidityReceiver).transfer(address(this).balance);
385             
386     }
387 
388    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
389              if(tokens == 0){
390             tokens = ERC20(tokenAddress).balanceOf(address(this));
391         }
392         emit ClearToken(tokenAddress, tokens);
393         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
394     }
395 
396     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
397         sellpercent = _percentonsell;
398         buypercent = _percentonbuy;
399         transferpercent = _wallettransfer;    
400           
401     }
402        
403     function startTrading() public onlyOwner {
404         TradingOpen = true;
405         buypercent = 1400;
406         sellpercent = 800;
407         transferpercent = 1000;
408                               
409     }
410 
411       function reduceFee() public onlyOwner {
412        
413         buypercent = 1400;
414         sellpercent = 700;
415         transferpercent = 500;
416                               
417     }
418 
419     function bobTime() public onlyOwner {
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