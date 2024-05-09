1 // SPDX-License-Identifier: MIT
2 
3 //http://t.me/WellPlayedERC20
4 //https://twitter.com/WellPlayedERC20
5 
6 
7 pragma solidity 0.8.19;
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
165 contract WellPlayed is Ownable, ERC20 {
166     using SafeMath for uint256;
167 
168     address WETH;
169     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
170     address constant ZERO = 0x0000000000000000000000000000000000000000;
171     
172 
173     string constant _name = "Well Played";
174     string constant _symbol = "WP";
175     uint8 constant _decimals = 9; 
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
216     uint256 setRatio = 35;
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
228     uint256 public swapThreshold = _totalSupply * 40 / 1000; 
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
248         marketingFeeReceiver = 0x3debBE50b59ce9bDa35AccF7ace7b10Ae46b7E95;
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
290         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
291          require(maxWallPercent >= 1); 
292         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
293         emit set_MaxWallet(_maxWalletToken);
294                 
295     }
296 
297       function setNoLimits () external onlyOwner {
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
390     function setFees(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
391         sellpercent = _percentonsell;
392         buypercent = _percentonbuy;
393         transferpercent = _wallettransfer;    
394           
395     }
396        
397     function enableTrading() public onlyOwner {
398         TradingOpen = true;
399         buypercent = 500;
400         sellpercent = 800;
401         transferpercent = 1000;
402                               
403     }
404 
405              
406     function swapBack() internal swapping {
407         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
408         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
409         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
410 
411         address[] memory path = new address[](2);
412         path[0] = address(this);
413         path[1] = WETH;
414 
415         uint256 balanceBefore = address(this).balance;
416 
417         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
418             amountToSwap,
419             0,
420             path,
421             address(this),
422             block.timestamp
423         );
424 
425         uint256 amountETH = address(this).balance.sub(balanceBefore);
426 
427         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
428         
429         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
430         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
431         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
432         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
433 
434         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
435         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
436         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
437         
438         tmpSuccess = false;
439 
440         if(amountToLiquify > 0){
441             router.addLiquidityETH{value: amountETHLiquidity}(
442                 address(this),
443                 amountToLiquify,
444                 0,
445                 0,
446                 autoLiquidityReceiver,
447                 block.timestamp
448             );
449             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
450         }
451     }
452     
453   
454     function set_fees() internal {
455       
456         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
457             uint8(totalFee.mul(sellpercent).div(100)),
458             uint8(totalFee.mul(transferpercent).div(100))
459             );
460     }
461     
462     function setAllocation(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
463         liquidityFee = _liquidityFee;
464         buybackFee = _buybackFee;
465         marketingFee = _marketingFee;
466         devFee = _devFee;
467         burnFee = _burnFee;
468         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
469         feeDenominator = _feeDenominator;
470         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
471         set_fees();
472     }
473 
474 
475 
476     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
477         autoLiquidityReceiver = _autoLiquidityReceiver;
478         marketingFeeReceiver = _marketingFeeReceiver;
479         devFeeReceiver = _devFeeReceiver;
480         burnFeeReceiver = _burnFeeReceiver;
481         buybackFeeReceiver = _buybackFeeReceiver;
482 
483         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
484     }
485 
486     function setSwapback(bool _enabled, uint256 _amount) external onlyOwner {
487         swapEnabled = _enabled;
488         swapThreshold = _amount;
489         emit set_SwapBack(swapThreshold, swapEnabled);
490     }
491 
492     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
493         return showBacking(accuracy) > ratio;
494     }
495 
496     function showBacking(uint256 accuracy) public view returns (uint256) {
497         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
498     }
499     
500     function showSupply() public view returns (uint256) {
501         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
502     }
503 
504 
505 }