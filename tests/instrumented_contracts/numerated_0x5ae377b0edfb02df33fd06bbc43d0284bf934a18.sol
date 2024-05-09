1 // https://twitter.com/The2ERC
2 
3 // https://t.me/The2Portal
4 
5 // https://www.the2.wtf
6 
7 // SPDX-License-Identifier: MIT
8 
9 
10 pragma solidity 0.8.20;
11 
12 interface ERC20 {
13     function totalSupply() external view returns (uint256);
14     function decimals() external view returns (uint8);
15     function symbol() external view returns (string memory);
16     function name() external view returns (string memory);
17     function getOwner() external view returns (address);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address _owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 
29 abstract contract Context {
30     
31     function _msgSender() internal view virtual returns (address payable) {
32         return payable(msg.sender);
33     }
34 
35     function _msgData() internal view virtual returns (bytes memory) {
36         this;
37         return msg.data;
38     }
39 }
40 
41 contract Ownable is Context {
42     address public _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor () {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         authorizations[_owner] = true;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52     mapping (address => bool) internal authorizations;
53 
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 interface IDEXFactory {
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77 }
78 
79 interface IDEXRouter {
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82 
83     function addLiquidity(
84         address tokenA,
85         address tokenB,
86         uint amountADesired,
87         uint amountBDesired,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline
92     ) external returns (uint amountA, uint amountB, uint liquidity);
93 
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102 
103     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110 
111     function swapExactETHForTokensSupportingFeeOnTransferTokens(
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external payable;
117 
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125 }
126 
127 interface InterfaceLP {
128     function sync() external;
129 }
130 
131 
132 library SafeMath {
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b > 0, errorMessage);
163         uint256 c = a / b;
164         return c;
165     }
166 }
167 
168 contract THE20 is Ownable, ERC20 {
169     using SafeMath for uint256;
170 
171     address WETH;
172     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
173     address constant ZERO = 0x0000000000000000000000000000000000000000;
174     
175 
176     string constant _name = "The 2.0";
177     string constant _symbol = "THE2.0";
178     uint8 constant _decimals = 18; 
179 
180 
181     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
182     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
183     event user_exemptfromfees(address Wallet, bool Exempt);
184     event user_TxExempt(address Wallet, bool Exempt);
185     event ClearStuck(uint256 amount);
186     event ClearToken(address TokenAddressCleared, uint256 Amount);
187     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
188     event set_MaxWallet(uint256 maxWallet);
189     event set_MaxTX(uint256 maxTX);
190     event set_SwapBack(uint256 Amount, bool Enabled);
191   
192     uint256 _totalSupply =  222222222222 * 10**_decimals; 
193 
194     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
195     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
196 
197     mapping (address => uint256) _balances;
198     mapping (address => mapping (address => uint256)) _allowances;  
199     mapping (address => bool) isexemptfromfees;
200     mapping (address => bool) isexemptfrommaxTX;
201 
202     uint256 private liquidityFee    = 1;
203     uint256 private marketingFee    = 2;
204     uint256 private devFee          = 0;
205     uint256 private buybackFee      = 1; 
206     uint256 private burnFee         = 0;
207     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
208     uint256 private feeDenominator  = 100;
209 
210     uint256 sellpercent = 100;
211     uint256 buypercent = 100;
212     uint256 transferpercent = 100; 
213 
214     address private autoLiquidityReceiver;
215     address private marketingFeeReceiver;
216     address private devFeeReceiver;
217     address private buybackFeeReceiver;
218     address private burnFeeReceiver;
219 
220     uint256 setRatio = 30;
221     uint256 setRatioDenominator = 100;
222     
223 
224     IDEXRouter public router;
225     InterfaceLP private pairContract;
226     address public pair;
227     
228     bool public TradingOpen = false; 
229 
230    
231     bool public swapEnabled = true;
232     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
233     bool inSwap;
234     modifier swapping() { inSwap = true; _; inSwap = false; }
235     
236     constructor () {
237         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
238         WETH = router.WETH();
239         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
240         pairContract = InterfaceLP(pair);
241        
242         
243         _allowances[address(this)][address(router)] = type(uint256).max;
244 
245         isexemptfromfees[msg.sender] = true;            
246         isexemptfrommaxTX[msg.sender] = true;
247         isexemptfrommaxTX[pair] = true;
248         isexemptfrommaxTX[marketingFeeReceiver] = true;
249         isexemptfrommaxTX[address(this)] = true;
250         
251         autoLiquidityReceiver = msg.sender;
252         marketingFeeReceiver = 0xdD705bD8187567d8A8613387f1b2dA691C17E464;
253         devFeeReceiver = msg.sender;
254         buybackFeeReceiver = msg.sender;
255         burnFeeReceiver = DEAD; 
256 
257         _balances[msg.sender] = _totalSupply;
258         emit Transfer(address(0), msg.sender, _totalSupply);
259 
260     }
261 
262     receive() external payable { }
263 
264     function totalSupply() external view override returns (uint256) { return _totalSupply; }
265     function decimals() external pure override returns (uint8) { return _decimals; }
266     function symbol() external pure override returns (string memory) { return _symbol; }
267     function name() external pure override returns (string memory) { return _name; }
268     function getOwner() external view override returns (address) {return owner();}
269     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
270     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
271 
272     function approve(address spender, uint256 amount) public override returns (bool) {
273         _allowances[msg.sender][spender] = amount;
274         emit Approval(msg.sender, spender, amount);
275         return true;
276     }
277 
278     function approveMax(address spender) external returns (bool) {
279         return approve(spender, type(uint256).max);
280     }
281 
282     function transfer(address recipient, uint256 amount) external override returns (bool) {
283         return _transferFrom(msg.sender, recipient, amount);
284     }
285 
286     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
287         if(_allowances[sender][msg.sender] != type(uint256).max){
288             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
289         }
290 
291         return _transferFrom(sender, recipient, amount);
292     }
293 
294         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
295          require(maxWallPercent >= 1); 
296         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
297         emit set_MaxWallet(_maxWalletToken);
298                 
299     }
300 
301       function removeLimits () external onlyOwner {
302             _maxTxAmount = _totalSupply;
303             _maxWalletToken = _totalSupply;
304     }
305 
306       
307     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
308         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
309 
310         if(!authorizations[sender] && !authorizations[recipient]){
311             require(TradingOpen,"Trading not open yet");
312         
313           }
314         
315                
316         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
317             uint256 heldTokens = balanceOf(recipient);
318             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
319 
320         checkTxLimit(sender, amount);  
321 
322         if(shouldSwapBack()){ swapBack(); }
323         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
324 
325         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
326         _balances[recipient] = _balances[recipient].add(amountReceived);
327 
328         emit Transfer(sender, recipient, amountReceived);
329         return true;
330     }
331  
332     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
333         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
334         _balances[recipient] = _balances[recipient].add(amount);
335         emit Transfer(sender, recipient, amount);
336         return true;
337     }
338 
339     function checkTxLimit(address sender, uint256 amount) internal view {
340         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
341     }
342 
343     function shouldTakeFee(address sender) internal view returns (bool) {
344         return !isexemptfromfees[sender];
345     }
346 
347     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
348         
349         uint256 percent = transferpercent;
350         if(recipient == pair) {
351             percent = sellpercent;
352         } else if(sender == pair) {
353             percent = buypercent;
354         }
355 
356         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
357         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
358         uint256 contractTokens = feeAmount.sub(burnTokens);
359         _balances[address(this)] = _balances[address(this)].add(contractTokens);
360         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
361         emit Transfer(sender, address(this), contractTokens);
362         
363         
364         if(burnTokens > 0){
365             _totalSupply = _totalSupply.sub(burnTokens);
366             emit Transfer(sender, ZERO, burnTokens);  
367         
368         }
369 
370         return amount.sub(feeAmount);
371     }
372 
373     function shouldSwapBack() internal view returns (bool) {
374         return msg.sender != pair
375         && !inSwap
376         && swapEnabled
377         && _balances[address(this)] >= swapThreshold;
378     }
379 
380   
381      function manualSend() external { 
382              payable(autoLiquidityReceiver).transfer(address(this).balance);
383             
384     }
385 
386    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
387             require(tokenAddress != address(this), "tokenAddress can not be the native token");
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
404         buypercent = 600;
405         sellpercent = 900;
406         transferpercent = 1000;
407                               
408     }
409 
410      
411              
412     function swapBack() internal swapping {
413         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
414         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
415         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
416 
417         address[] memory path = new address[](2);
418         path[0] = address(this);
419         path[1] = WETH;
420 
421         uint256 balanceBefore = address(this).balance;
422 
423         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
424             amountToSwap,
425             0,
426             path,
427             address(this),
428             block.timestamp
429         );
430 
431         uint256 amountETH = address(this).balance.sub(balanceBefore);
432 
433         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
434         
435         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
436         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
437         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
438         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
439 
440         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
441         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
442         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
443         
444         tmpSuccess = false;
445 
446         if(amountToLiquify > 0){
447             router.addLiquidityETH{value: amountETHLiquidity}(
448                 address(this),
449                 amountToLiquify,
450                 0,
451                 0,
452                 autoLiquidityReceiver,
453                 block.timestamp
454             );
455             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
456         }
457     }
458     
459   
460     function set_fees() internal {
461       
462         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
463             uint8(totalFee.mul(sellpercent).div(100)),
464             uint8(totalFee.mul(transferpercent).div(100))
465             );
466     }
467     
468     function setTax(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
469         liquidityFee = _liquidityFee;
470         buybackFee = _buybackFee;
471         marketingFee = _marketingFee;
472         devFee = _devFee;
473         burnFee = _burnFee;
474         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
475         feeDenominator = _feeDenominator;
476         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
477         set_fees();
478     }
479 
480    
481     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
482         autoLiquidityReceiver = _autoLiquidityReceiver;
483         marketingFeeReceiver = _marketingFeeReceiver;
484         devFeeReceiver = _devFeeReceiver;
485         burnFeeReceiver = _burnFeeReceiver;
486         buybackFeeReceiver = _buybackFeeReceiver;
487 
488         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
489     }
490 
491     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
492         swapEnabled = _enabled;
493         swapThreshold = _amount;
494         emit set_SwapBack(swapThreshold, swapEnabled);
495     }
496 
497     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
498         return showBacking(accuracy) > ratio;
499     }
500 
501     function showBacking(uint256 accuracy) public view returns (uint256) {
502         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
503     }
504     
505     function showSupply() public view returns (uint256) {
506         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
507     }
508 
509 
510 }