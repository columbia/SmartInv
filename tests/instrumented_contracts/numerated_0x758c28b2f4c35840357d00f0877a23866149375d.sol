1 // https://chpepe.vip/
2 // https://twitter.com/Chinesepepecoin
3 // https://t.me/pepecoineth
4 // https://www.dextools.io/app/en/ether/pair-explorer/0xf09de3be1922aa88283d58d7c5d3d33fbc905fb3
5 
6 // 在加密货币世界中，很少有偶像能像 Pepe Frog 一样俘获爱好者的心。 这种可爱的两栖动物在普通话中被亲切地称为“Chinese Pepe”或“蛙仔”，它已成为中国加密社区希望、幽默和团结的象征。
7 
8 
9 
10 // SPDX-License-Identifier: MIT
11 
12 
13 pragma solidity 0.8.20;
14 
15 interface ERC20 {
16     function totalSupply() external view returns (uint256);
17     function decimals() external view returns (uint8);
18     function symbol() external view returns (string memory);
19     function name() external view returns (string memory);
20     function getOwner() external view returns (address);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address _owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 
32 abstract contract Context {
33     
34     function _msgSender() internal view virtual returns (address payable) {
35         return payable(msg.sender);
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this;
40         return msg.data;
41     }
42 }
43 
44 contract Ownable is Context {
45     address public _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor () {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         authorizations[_owner] = true;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55     mapping (address => bool) internal authorizations;
56 
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70 
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 interface IDEXFactory {
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 }
81 
82 interface IDEXRouter {
83     function factory() external pure returns (address);
84     function WETH() external pure returns (address);
85 
86     function addLiquidity(
87         address tokenA,
88         address tokenB,
89         uint amountADesired,
90         uint amountBDesired,
91         uint amountAMin,
92         uint amountBMin,
93         address to,
94         uint deadline
95     ) external returns (uint amountA, uint amountB, uint liquidity);
96 
97     function addLiquidityETH(
98         address token,
99         uint amountTokenDesired,
100         uint amountTokenMin,
101         uint amountETHMin,
102         address to,
103         uint deadline
104     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
105 
106     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113 
114     function swapExactETHForTokensSupportingFeeOnTransferTokens(
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external payable;
120 
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128 }
129 
130 interface InterfaceLP {
131     function sync() external;
132 }
133 
134 
135 library SafeMath {
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b > 0, errorMessage);
166         uint256 c = a / b;
167         return c;
168     }
169 }
170 
171 contract CHPEPE is Ownable, ERC20 {
172     using SafeMath for uint256;
173 
174     address WETH;
175     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
176     address constant ZERO = 0x0000000000000000000000000000000000000000;
177     
178 
179     string constant _name = "CH Pepe";
180     string constant _symbol = "CHPEPE";
181     uint8 constant _decimals = 18; 
182 
183 
184     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
185     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
186     event user_exemptfromfees(address Wallet, bool Exempt);
187     event user_TxExempt(address Wallet, bool Exempt);
188     event ClearStuck(uint256 amount);
189     event ClearToken(address TokenAddressCleared, uint256 Amount);
190     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
191     event set_MaxWallet(uint256 maxWallet);
192     event set_MaxTX(uint256 maxTX);
193     event set_SwapBack(uint256 Amount, bool Enabled);
194   
195     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
196 
197     uint256 public _maxTxAmount = _totalSupply.mul(5).div(100);
198     uint256 public _maxWalletToken = _totalSupply.mul(5).div(100);
199 
200     mapping (address => uint256) _balances;
201     mapping (address => mapping (address => uint256)) _allowances;  
202     mapping (address => bool) isexemptfromfees;
203     mapping (address => bool) isexemptfrommaxTX;
204 
205     uint256 private liquidityFee    = 0;
206     uint256 private marketingFee    = 999;
207     uint256 private devFee          = 0;
208     uint256 private buybackFee      = 0; 
209     uint256 private burnFee         = 0;
210     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
211     uint256 private feeDenominator  = 1000;
212 
213     // no bots tax
214     uint256 sellpercent = 999;
215     uint256 buypercent = 999;
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
236     uint256 public swapThreshold = _totalSupply / 1000; 
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
256         marketingFeeReceiver = 0x81E6f98ce12E481F96E472421f6cc96Ee629757f;
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
360         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 1000);
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
407     }
408 
409       function reduceFee() public onlyOwner {
410        
411         buypercent = 500;
412         sellpercent = 500;
413         transferpercent = 500;
414                               
415     }
416 
417              
418     function swapBack() internal swapping {
419         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
420         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
421         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
422 
423         address[] memory path = new address[](2);
424         path[0] = address(this);
425         path[1] = WETH;
426 
427         uint256 balanceBefore = address(this).balance;
428 
429         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
430             amountToSwap,
431             0,
432             path,
433             address(this),
434             block.timestamp
435         );
436 
437         uint256 amountETH = address(this).balance.sub(balanceBefore);
438 
439         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
440         
441         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
442         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
443         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
444         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
445 
446         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
447         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
448         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
449         
450         tmpSuccess = false;
451 
452         if(amountToLiquify > 0){
453             router.addLiquidityETH{value: amountETHLiquidity}(
454                 address(this),
455                 amountToLiquify,
456                 0,
457                 0,
458                 autoLiquidityReceiver,
459                 block.timestamp
460             );
461             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
462         }
463     }
464     
465   
466     function set_fees() internal {
467       
468         emit EditTax( uint8(totalFee.mul(buypercent).div(feeDenominator)),
469             uint8(totalFee.mul(sellpercent).div(feeDenominator)),
470             uint8(totalFee.mul(transferpercent).div(feeDenominator))
471             );
472     }
473     
474     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
475         liquidityFee = _liquidityFee;
476         buybackFee = _buybackFee;
477         marketingFee = _marketingFee;
478         devFee = _devFee;
479         burnFee = _burnFee;
480         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
481         feeDenominator = _feeDenominator;
482         set_fees();
483     }
484 
485    
486     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
487         autoLiquidityReceiver = _autoLiquidityReceiver;
488         marketingFeeReceiver = _marketingFeeReceiver;
489         devFeeReceiver = _devFeeReceiver;
490         burnFeeReceiver = _burnFeeReceiver;
491         buybackFeeReceiver = _buybackFeeReceiver;
492 
493         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
494     }
495 
496     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
497         swapEnabled = _enabled;
498         swapThreshold = _amount;
499         emit set_SwapBack(swapThreshold, swapEnabled);
500     }
501 
502     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
503         return showBacking(accuracy) > ratio;
504     }
505 
506     function showBacking(uint256 accuracy) public view returns (uint256) {
507         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
508     }
509     
510     function showSupply() public view returns (uint256) {
511         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
512     }
513 
514 
515 }