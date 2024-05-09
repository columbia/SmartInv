1 // The XDoge https://t.me/xdogecoin_eth
2 // SPDX-License-Identifier: MIT
3 
4 
5 pragma solidity 0.8.20;
6 
7 interface ERC20 {
8     function totalSupply() external view returns (uint256);
9     function decimals() external view returns (uint8);
10     function symbol() external view returns (string memory);
11     function name() external view returns (string memory);
12     function getOwner() external view returns (address);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address _owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 
24 abstract contract Context {
25     
26     function _msgSender() internal view virtual returns (address payable) {
27         return payable(msg.sender);
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this;
32         return msg.data;
33     }
34 }
35 
36 contract Ownable is Context {
37     address public _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor () {
42         address msgSender = _msgSender();
43         _owner = msgSender;
44         authorizations[_owner] = true;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47     mapping (address => bool) internal authorizations;
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 
70 interface IDEXFactory {
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72 }
73 
74 interface IDEXRouter {
75     function factory() external pure returns (address);
76     function WETH() external pure returns (address);
77 
78     function addLiquidity(
79         address tokenA,
80         address tokenB,
81         uint amountADesired,
82         uint amountBDesired,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline
87     ) external returns (uint amountA, uint amountB, uint liquidity);
88 
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97 
98     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105 
106     function swapExactETHForTokensSupportingFeeOnTransferTokens(
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external payable;
112 
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120 }
121 
122 interface InterfaceLP {
123     function sync() external;
124 }
125 
126 
127 library SafeMath {
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero");
155     }
156     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159         return c;
160     }
161 }
162 
163 contract XDOGE is Ownable, ERC20 {
164     using SafeMath for uint256;
165 
166     address WETH;
167     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
168     address constant ZERO = 0x0000000000000000000000000000000000000000;
169     
170 
171     string constant _name = "XDoge";
172     string constant _symbol = "XD";
173     uint8 constant _decimals = 18; 
174 
175 
176     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
177     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
178     event user_exemptfromfees(address Wallet, bool Exempt);
179     event user_TxExempt(address Wallet, bool Exempt);
180     event ClearStuck(uint256 amount);
181     event ClearToken(address TokenAddressCleared, uint256 Amount);
182     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
183     event set_MaxWallet(uint256 maxWallet);
184     event set_MaxTX(uint256 maxTX);
185     event set_SwapBack(uint256 Amount, bool Enabled);
186   
187     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
188 
189     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
190     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
191 
192     mapping (address => uint256) _balances;
193     mapping (address => mapping (address => uint256)) _allowances;  
194     mapping (address => bool) isexemptfromfees;
195     mapping (address => bool) isexemptfrommaxTX;
196 
197     uint256 private liquidityFee    = 1;
198     uint256 private marketingFee    = 4;
199     uint256 private devFee          = 0;
200     uint256 private buybackFee      = 0; 
201     uint256 private burnFee         = 0;
202     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
203     uint256 private feeDenominator  = 100;
204 
205     uint256 sellpercent = 100;
206     uint256 buypercent = 100;
207     uint256 transferpercent = 100; 
208 
209     address private autoLiquidityReceiver;
210     address private marketingFeeReceiver;
211     address private devFeeReceiver;
212     address private buybackFeeReceiver;
213     address private burnFeeReceiver;
214 
215     uint256 setRatio = 30;
216     uint256 setRatioDenominator = 100;
217     
218 
219     IDEXRouter public router;
220     InterfaceLP private pairContract;
221     address public pair;
222     
223     bool public TradingOpen = false; 
224 
225    
226     bool public swapEnabled = true;
227     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
228     bool inSwap;
229     modifier swapping() { inSwap = true; _; inSwap = false; }
230     
231     constructor () {
232         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
233         WETH = router.WETH();
234         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
235         pairContract = InterfaceLP(pair);
236        
237         
238         _allowances[address(this)][address(router)] = type(uint256).max;
239 
240         isexemptfromfees[msg.sender] = true;            
241         isexemptfrommaxTX[msg.sender] = true;
242         isexemptfrommaxTX[pair] = true;
243         isexemptfrommaxTX[marketingFeeReceiver] = true;
244         isexemptfrommaxTX[address(this)] = true;
245         
246         autoLiquidityReceiver = msg.sender;
247         marketingFeeReceiver = 0xc2731E4F14200A46f64339eB453Df68140341Fa1;
248         devFeeReceiver = msg.sender;
249         buybackFeeReceiver = msg.sender;
250         burnFeeReceiver = DEAD; 
251 
252         _balances[msg.sender] = _totalSupply;
253         emit Transfer(address(0), msg.sender, _totalSupply);
254 
255     }
256 
257     receive() external payable { }
258 
259     function totalSupply() external view override returns (uint256) { return _totalSupply; }
260     function decimals() external pure override returns (uint8) { return _decimals; }
261     function symbol() external pure override returns (string memory) { return _symbol; }
262     function name() external pure override returns (string memory) { return _name; }
263     function getOwner() external view override returns (address) {return owner();}
264     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
265     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
266 
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _allowances[msg.sender][spender] = amount;
269         emit Approval(msg.sender, spender, amount);
270         return true;
271     }
272 
273     function approveMax(address spender) external returns (bool) {
274         return approve(spender, type(uint256).max);
275     }
276 
277     function transfer(address recipient, uint256 amount) external override returns (bool) {
278         return _transferFrom(msg.sender, recipient, amount);
279     }
280 
281     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
282         if(_allowances[sender][msg.sender] != type(uint256).max){
283             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
284         }
285 
286         return _transferFrom(sender, recipient, amount);
287     }
288 
289         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
290          require(maxWallPercent >= 1); 
291         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
292         emit set_MaxWallet(_maxWalletToken);
293                 
294     }
295 
296       function removeLimits () external onlyOwner {
297             _maxTxAmount = _totalSupply;
298             _maxWalletToken = _totalSupply;
299     }
300 
301       
302     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
303         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
304 
305         if(!authorizations[sender] && !authorizations[recipient]){
306             require(TradingOpen,"Trading not open yet");
307         
308           }
309         
310                
311         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
312             uint256 heldTokens = balanceOf(recipient);
313             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
314 
315         checkTxLimit(sender, amount);  
316 
317         if(shouldSwapBack()){ swapBack(); }
318         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
319 
320         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
321         _balances[recipient] = _balances[recipient].add(amountReceived);
322 
323         emit Transfer(sender, recipient, amountReceived);
324         return true;
325     }
326  
327     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
328         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
329         _balances[recipient] = _balances[recipient].add(amount);
330         emit Transfer(sender, recipient, amount);
331         return true;
332     }
333 
334     function checkTxLimit(address sender, uint256 amount) internal view {
335         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
336     }
337 
338     function shouldTakeFee(address sender) internal view returns (bool) {
339         return !isexemptfromfees[sender];
340     }
341 
342     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
343         
344         uint256 percent = transferpercent;
345         if(recipient == pair) {
346             percent = sellpercent;
347         } else if(sender == pair) {
348             percent = buypercent;
349         }
350 
351         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
352         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
353         uint256 contractTokens = feeAmount.sub(burnTokens);
354         _balances[address(this)] = _balances[address(this)].add(contractTokens);
355         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
356         emit Transfer(sender, address(this), contractTokens);
357         
358         
359         if(burnTokens > 0){
360             _totalSupply = _totalSupply.sub(burnTokens);
361             emit Transfer(sender, ZERO, burnTokens);  
362         
363         }
364 
365         return amount.sub(feeAmount);
366     }
367 
368     function shouldSwapBack() internal view returns (bool) {
369         return msg.sender != pair
370         && !inSwap
371         && swapEnabled
372         && _balances[address(this)] >= swapThreshold;
373     }
374 
375   
376      function manualSend() external { 
377              payable(autoLiquidityReceiver).transfer(address(this).balance);
378             
379     }
380 
381    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
382              if(tokens == 0){
383             tokens = ERC20(tokenAddress).balanceOf(address(this));
384         }
385         emit ClearToken(tokenAddress, tokens);
386         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
387     }
388 
389     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
390         sellpercent = _percentonsell;
391         buypercent = _percentonbuy;
392         transferpercent = _wallettransfer;    
393           
394     }
395        
396     function startTrading() public onlyOwner {
397         TradingOpen = true;
398         buypercent = 1400;
399         sellpercent = 800;
400         transferpercent = 1000;
401                               
402     }
403 
404       function reduceFee() public onlyOwner {
405        
406         buypercent = 600;
407         sellpercent = 600;
408         transferpercent = 200;
409                               
410     }
411 
412              
413     function swapBack() internal swapping {
414         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
415         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
416         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
417 
418         address[] memory path = new address[](2);
419         path[0] = address(this);
420         path[1] = WETH;
421 
422         uint256 balanceBefore = address(this).balance;
423 
424         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
425             amountToSwap,
426             0,
427             path,
428             address(this),
429             block.timestamp
430         );
431 
432         uint256 amountETH = address(this).balance.sub(balanceBefore);
433 
434         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
435         
436         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
437         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
438         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
439         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
440 
441         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
442         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
443         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
444         
445         tmpSuccess = false;
446 
447         if(amountToLiquify > 0){
448             router.addLiquidityETH{value: amountETHLiquidity}(
449                 address(this),
450                 amountToLiquify,
451                 0,
452                 0,
453                 autoLiquidityReceiver,
454                 block.timestamp
455             );
456             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
457         }
458     }
459     
460   
461     function set_fees() internal {
462       
463         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
464             uint8(totalFee.mul(sellpercent).div(100)),
465             uint8(totalFee.mul(transferpercent).div(100))
466             );
467     }
468     
469     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
470         liquidityFee = _liquidityFee;
471         buybackFee = _buybackFee;
472         marketingFee = _marketingFee;
473         devFee = _devFee;
474         burnFee = _burnFee;
475         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
476         feeDenominator = _feeDenominator;
477         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
478         set_fees();
479     }
480 
481    
482     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
483         autoLiquidityReceiver = _autoLiquidityReceiver;
484         marketingFeeReceiver = _marketingFeeReceiver;
485         devFeeReceiver = _devFeeReceiver;
486         burnFeeReceiver = _burnFeeReceiver;
487         buybackFeeReceiver = _buybackFeeReceiver;
488 
489         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
490     }
491 
492     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
493         swapEnabled = _enabled;
494         swapThreshold = _amount;
495         emit set_SwapBack(swapThreshold, swapEnabled);
496     }
497 
498     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
499         return showBacking(accuracy) > ratio;
500     }
501 
502     function showBacking(uint256 accuracy) public view returns (uint256) {
503         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
504     }
505     
506     function showSupply() public view returns (uint256) {
507         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
508     }
509 
510 
511 }