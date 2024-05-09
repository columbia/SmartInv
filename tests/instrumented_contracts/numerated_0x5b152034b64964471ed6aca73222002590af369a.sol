1 // Join telegram here: https://t.me/YUMMYPORTAL
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 pragma solidity 0.8.20;
7 
8 interface ERC20 {
9     function totalSupply() external view returns (uint256);
10     function decimals() external view returns (uint8);
11     function symbol() external view returns (string memory);
12     function name() external view returns (string memory);
13     function getOwner() external view returns (address);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address _owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 
24 
25 abstract contract Context {
26     
27     function _msgSender() internal view virtual returns (address payable) {
28         return payable(msg.sender);
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this;
33         return msg.data;
34     }
35 }
36 
37 contract Ownable is Context {
38     address public _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor () {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45         authorizations[_owner] = true;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48     mapping (address => bool) internal authorizations;
49 
50     function owner() public view returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 }
70 
71 interface IDEXFactory {
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73 }
74 
75 interface IDEXRouter {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78 
79     function addLiquidity(
80         address tokenA,
81         address tokenB,
82         uint amountADesired,
83         uint amountBDesired,
84         uint amountAMin,
85         uint amountBMin,
86         address to,
87         uint deadline
88     ) external returns (uint amountA, uint amountB, uint liquidity);
89 
90     function addLiquidityETH(
91         address token,
92         uint amountTokenDesired,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline
97     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
98 
99     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106 
107     function swapExactETHForTokensSupportingFeeOnTransferTokens(
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external payable;
113 
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121 }
122 
123 interface InterfaceLP {
124     function sync() external;
125 }
126 
127 
128 library SafeMath {
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151 
152         return c;
153     }
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         return c;
161     }
162 }
163 
164 contract YUMMY is Ownable, ERC20 {
165     using SafeMath for uint256;
166 
167     address WETH;
168     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
169     address constant ZERO = 0x0000000000000000000000000000000000000000;
170     
171 
172     string constant _name = "YUMMY";
173     string constant _symbol = "YUMMY";
174     uint8 constant _decimals = 18; 
175 
176 
177     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
178     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
179     event user_exemptfromfees(address Wallet, bool Exempt);
180     event user_TxExempt(address Wallet, bool Exempt);
181     event ClearStuck(uint256 amount);
182     event ClearToken(address TokenAddressCleared, uint256 Amount);
183     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
184     event set_MaxWallet(uint256 maxWallet);
185     event set_MaxTX(uint256 maxTX);
186     event set_SwapBack(uint256 Amount, bool Enabled);
187   
188     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
189 
190     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
191     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
192 
193     mapping (address => uint256) _balances;
194     mapping (address => mapping (address => uint256)) _allowances;  
195     mapping (address => bool) isexemptfromfees;
196     mapping (address => bool) isexemptfrommaxTX;
197 
198     uint256 private liquidityFee    = 1;
199     uint256 private marketingFee    = 3;
200     uint256 private devFee          = 0;
201     uint256 private buybackFee      = 1; 
202     uint256 private burnFee         = 0;
203     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
204     uint256 private feeDenominator  = 100;
205 
206     uint256 sellpercent = 100;
207     uint256 buypercent = 100;
208     uint256 transferpercent = 100; 
209 
210     address private autoLiquidityReceiver;
211     address private marketingFeeReceiver;
212     address private devFeeReceiver;
213     address private buybackFeeReceiver;
214     address private burnFeeReceiver;
215 
216     uint256 setRatio = 30;
217     uint256 setRatioDenominator = 100;
218     
219 
220     IDEXRouter public router;
221     InterfaceLP private pairContract;
222     address public pair;
223     
224     bool public TradingOpen = false; 
225 
226    
227     bool public swapEnabled = true;
228     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
229     bool inSwap;
230     modifier swapping() { inSwap = true; _; inSwap = false; }
231     
232     constructor () {
233         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234         WETH = router.WETH();
235         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
236         pairContract = InterfaceLP(pair);
237        
238         
239         _allowances[address(this)][address(router)] = type(uint256).max;
240 
241         isexemptfromfees[msg.sender] = true;            
242         isexemptfrommaxTX[msg.sender] = true;
243         isexemptfrommaxTX[pair] = true;
244         isexemptfrommaxTX[marketingFeeReceiver] = true;
245         isexemptfrommaxTX[address(this)] = true;
246         
247         autoLiquidityReceiver = msg.sender;
248         marketingFeeReceiver = 0xa3530A3D5Dd97455e860c97e523eFd19eD522235;
249         devFeeReceiver = msg.sender;
250         buybackFeeReceiver = msg.sender;
251         burnFeeReceiver = DEAD; 
252 
253         _balances[msg.sender] = _totalSupply;
254         emit Transfer(address(0), msg.sender, _totalSupply);
255 
256     }
257 
258     receive() external payable { }
259 
260     function totalSupply() external view override returns (uint256) { return _totalSupply; }
261     function decimals() external pure override returns (uint8) { return _decimals; }
262     function symbol() external pure override returns (string memory) { return _symbol; }
263     function name() external pure override returns (string memory) { return _name; }
264     function getOwner() external view override returns (address) {return owner();}
265     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
266     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
267 
268     function approve(address spender, uint256 amount) public override returns (bool) {
269         _allowances[msg.sender][spender] = amount;
270         emit Approval(msg.sender, spender, amount);
271         return true;
272     }
273 
274     function approveMax(address spender) external returns (bool) {
275         return approve(spender, type(uint256).max);
276     }
277 
278     function transfer(address recipient, uint256 amount) external override returns (bool) {
279         return _transferFrom(msg.sender, recipient, amount);
280     }
281 
282     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
283         if(_allowances[sender][msg.sender] != type(uint256).max){
284             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
285         }
286 
287         return _transferFrom(sender, recipient, amount);
288     }
289 
290         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
291          require(maxWallPercent >= 1); 
292         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
293         emit set_MaxWallet(_maxWalletToken);
294                 
295     }
296 
297       function removeLimits () external onlyOwner {
298             _maxTxAmount = _totalSupply;
299             _maxWalletToken = _totalSupply;
300     }
301 
302       
303     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
304         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
305 
306         if(!authorizations[sender] && !authorizations[recipient]){
307             require(TradingOpen,"Trading not open yet");
308         
309           }
310         
311                
312         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
313             uint256 heldTokens = balanceOf(recipient);
314             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
315 
316         checkTxLimit(sender, amount);  
317 
318         if(shouldSwapBack()){ swapBack(); }
319         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
320 
321         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
322         _balances[recipient] = _balances[recipient].add(amountReceived);
323 
324         emit Transfer(sender, recipient, amountReceived);
325         return true;
326     }
327  
328     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
329         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
330         _balances[recipient] = _balances[recipient].add(amount);
331         emit Transfer(sender, recipient, amount);
332         return true;
333     }
334 
335     function checkTxLimit(address sender, uint256 amount) internal view {
336         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
337     }
338 
339     function shouldTakeFee(address sender) internal view returns (bool) {
340         return !isexemptfromfees[sender];
341     }
342 
343     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
344         
345         uint256 percent = transferpercent;
346         if(recipient == pair) {
347             percent = sellpercent;
348         } else if(sender == pair) {
349             percent = buypercent;
350         }
351 
352         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
353         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
354         uint256 contractTokens = feeAmount.sub(burnTokens);
355         _balances[address(this)] = _balances[address(this)].add(contractTokens);
356         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
357         emit Transfer(sender, address(this), contractTokens);
358         
359         
360         if(burnTokens > 0){
361             _totalSupply = _totalSupply.sub(burnTokens);
362             emit Transfer(sender, ZERO, burnTokens);  
363         
364         }
365 
366         return amount.sub(feeAmount);
367     }
368 
369     function shouldSwapBack() internal view returns (bool) {
370         return msg.sender != pair
371         && !inSwap
372         && swapEnabled
373         && _balances[address(this)] >= swapThreshold;
374     }
375 
376   
377      function manualSend() external { 
378              payable(autoLiquidityReceiver).transfer(address(this).balance);
379             
380     }
381 
382    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
383              if(tokens == 0){
384             tokens = ERC20(tokenAddress).balanceOf(address(this));
385         }
386         emit ClearToken(tokenAddress, tokens);
387         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
388     }
389 
390     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
391         sellpercent = _percentonsell;
392         buypercent = _percentonbuy;
393         transferpercent = _wallettransfer;    
394           
395     }
396        
397     function startTrading() public onlyOwner {
398         TradingOpen = true;
399         buypercent = 1400;
400         sellpercent = 800;
401         transferpercent = 1000;
402                               
403     }
404 
405       function reduceFee() public onlyOwner {
406        
407         buypercent = 400;
408         sellpercent = 700;
409         transferpercent = 500;
410                               
411     }
412 
413              
414     function swapBack() internal swapping {
415         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
416         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
417         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
418 
419         address[] memory path = new address[](2);
420         path[0] = address(this);
421         path[1] = WETH;
422 
423         uint256 balanceBefore = address(this).balance;
424 
425         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
426             amountToSwap,
427             0,
428             path,
429             address(this),
430             block.timestamp
431         );
432 
433         uint256 amountETH = address(this).balance.sub(balanceBefore);
434 
435         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
436         
437         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
438         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
439         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
440         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
441 
442         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
443         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
444         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
445         
446         tmpSuccess = false;
447 
448         if(amountToLiquify > 0){
449             router.addLiquidityETH{value: amountETHLiquidity}(
450                 address(this),
451                 amountToLiquify,
452                 0,
453                 0,
454                 autoLiquidityReceiver,
455                 block.timestamp
456             );
457             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
458         }
459     }
460     
461   
462     function set_fees() internal {
463       
464         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
465             uint8(totalFee.mul(sellpercent).div(100)),
466             uint8(totalFee.mul(transferpercent).div(100))
467             );
468     }
469     
470     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
471         liquidityFee = _liquidityFee;
472         buybackFee = _buybackFee;
473         marketingFee = _marketingFee;
474         devFee = _devFee;
475         burnFee = _burnFee;
476         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
477         feeDenominator = _feeDenominator;
478         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
479         set_fees();
480     }
481 
482    
483     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
484         autoLiquidityReceiver = _autoLiquidityReceiver;
485         marketingFeeReceiver = _marketingFeeReceiver;
486         devFeeReceiver = _devFeeReceiver;
487         burnFeeReceiver = _burnFeeReceiver;
488         buybackFeeReceiver = _buybackFeeReceiver;
489 
490         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
491     }
492 
493     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
494         swapEnabled = _enabled;
495         swapThreshold = _amount;
496         emit set_SwapBack(swapThreshold, swapEnabled);
497     }
498 
499     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
500         return showBacking(accuracy) > ratio;
501     }
502 
503     function showBacking(uint256 accuracy) public view returns (uint256) {
504         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
505     }
506     
507     function showSupply() public view returns (uint256) {
508         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
509     }
510 
511 
512 }