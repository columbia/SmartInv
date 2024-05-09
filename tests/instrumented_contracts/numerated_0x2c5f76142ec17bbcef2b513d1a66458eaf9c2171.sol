1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.20;
5 
6 interface ERC20 {
7     function totalSupply() external view returns (uint256);
8     function decimals() external view returns (uint8);
9     function symbol() external view returns (string memory);
10     function name() external view returns (string memory);
11     function getOwner() external view returns (address);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address _owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 
22 
23 abstract contract Context {
24     
25     function _msgSender() internal view virtual returns (address payable) {
26         return payable(msg.sender);
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this;
31         return msg.data;
32     }
33 }
34 
35 contract Ownable is Context {
36     address public _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor () {
41         address msgSender = _msgSender();
42         _owner = msgSender;
43         authorizations[_owner] = true;
44         emit OwnershipTransferred(address(0), msgSender);
45     }
46     mapping (address => bool) internal authorizations;
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface IDEXFactory {
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 }
72 
73 interface IDEXRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87 
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96 
97     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104 
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111 
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 }
120 
121 interface InterfaceLP {
122     function sync() external;
123 }
124 
125 
126 library SafeMath {
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         return div(a, b, "SafeMath: division by zero");
154     }
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         return c;
159     }
160 }
161 
162 contract PAGMI is Ownable, ERC20 {
163     using SafeMath for uint256;
164 
165     address WETH;
166     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
167     address constant ZERO = 0x0000000000000000000000000000000000000000;
168     
169 
170     string constant _name = "PAGMI";
171     string constant _symbol = "PAGMI";
172     uint8 constant _decimals = 18; 
173 
174 
175     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
176     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
177     event user_exemptfromfees(address Wallet, bool Exempt);
178     event user_TxExempt(address Wallet, bool Exempt);
179     event ClearStuck(uint256 amount);
180     event ClearToken(address TokenAddressCleared, uint256 Amount);
181     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
182     event set_MaxWallet(uint256 maxWallet);
183     event set_MaxTX(uint256 maxTX);
184     event set_SwapBack(uint256 Amount, bool Enabled);
185   
186     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
187 
188     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
189     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
190 
191     mapping (address => uint256) _balances;
192     mapping (address => mapping (address => uint256)) _allowances;  
193     mapping (address => bool) isexemptfromfees;
194     mapping (address => bool) isexemptfrommaxTX;
195 
196     uint256 private liquidityFee    = 1;
197     uint256 private marketingFee    = 3;
198     uint256 private devFee          = 0;
199     uint256 private buybackFee      = 1; 
200     uint256 private burnFee         = 0;
201     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
202     uint256 private feeDenominator  = 100;
203 
204     uint256 sellpercent = 100;
205     uint256 buypercent = 100;
206     uint256 transferpercent = 100; 
207 
208     address private autoLiquidityReceiver;
209     address private marketingFeeReceiver;
210     address private devFeeReceiver;
211     address private buybackFeeReceiver;
212     address private burnFeeReceiver;
213 
214     uint256 setRatio = 30;
215     uint256 setRatioDenominator = 100;
216     
217 
218     IDEXRouter public router;
219     InterfaceLP private pairContract;
220     address public pair;
221     
222     bool public TradingOpen = false; 
223 
224    
225     bool public swapEnabled = true;
226     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
227     bool inSwap;
228     modifier swapping() { inSwap = true; _; inSwap = false; }
229     
230     constructor () {
231         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
232         WETH = router.WETH();
233         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
234         pairContract = InterfaceLP(pair);
235        
236         
237         _allowances[address(this)][address(router)] = type(uint256).max;
238 
239         isexemptfromfees[msg.sender] = true;            
240         isexemptfrommaxTX[msg.sender] = true;
241         isexemptfrommaxTX[pair] = true;
242         isexemptfrommaxTX[marketingFeeReceiver] = true;
243         isexemptfrommaxTX[address(this)] = true;
244         
245         autoLiquidityReceiver = msg.sender;
246         marketingFeeReceiver = 0x90c4D13F999E9027855bBBf1448781862237eC65;
247         devFeeReceiver = msg.sender;
248         buybackFeeReceiver = msg.sender;
249         burnFeeReceiver = DEAD; 
250 
251         _balances[msg.sender] = _totalSupply;
252         emit Transfer(address(0), msg.sender, _totalSupply);
253 
254     }
255 
256     receive() external payable { }
257 
258     function totalSupply() external view override returns (uint256) { return _totalSupply; }
259     function decimals() external pure override returns (uint8) { return _decimals; }
260     function symbol() external pure override returns (string memory) { return _symbol; }
261     function name() external pure override returns (string memory) { return _name; }
262     function getOwner() external view override returns (address) {return owner();}
263     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
264     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
265 
266     function approve(address spender, uint256 amount) public override returns (bool) {
267         _allowances[msg.sender][spender] = amount;
268         emit Approval(msg.sender, spender, amount);
269         return true;
270     }
271 
272     function approveMax(address spender) external returns (bool) {
273         return approve(spender, type(uint256).max);
274     }
275 
276     function transfer(address recipient, uint256 amount) external override returns (bool) {
277         return _transferFrom(msg.sender, recipient, amount);
278     }
279 
280     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
281         if(_allowances[sender][msg.sender] != type(uint256).max){
282             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
283         }
284 
285         return _transferFrom(sender, recipient, amount);
286     }
287 
288         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
289          require(maxWallPercent >= 1); 
290         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
291         emit set_MaxWallet(_maxWalletToken);
292                 
293     }
294 
295       function removeLimits () external onlyOwner {
296             _maxTxAmount = _totalSupply;
297             _maxWalletToken = _totalSupply;
298     }
299 
300       
301     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
302         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
303 
304         if(!authorizations[sender] && !authorizations[recipient]){
305             require(TradingOpen,"Trading not open yet");
306         
307           }
308         
309                
310         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
311             uint256 heldTokens = balanceOf(recipient);
312             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
313 
314         checkTxLimit(sender, amount);  
315 
316         if(shouldSwapBack()){ swapBack(); }
317         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
318 
319         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
320         _balances[recipient] = _balances[recipient].add(amountReceived);
321 
322         emit Transfer(sender, recipient, amountReceived);
323         return true;
324     }
325  
326     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
327         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
328         _balances[recipient] = _balances[recipient].add(amount);
329         emit Transfer(sender, recipient, amount);
330         return true;
331     }
332 
333     function checkTxLimit(address sender, uint256 amount) internal view {
334         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
335     }
336 
337     function shouldTakeFee(address sender) internal view returns (bool) {
338         return !isexemptfromfees[sender];
339     }
340 
341     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
342         
343         uint256 percent = transferpercent;
344         if(recipient == pair) {
345             percent = sellpercent;
346         } else if(sender == pair) {
347             percent = buypercent;
348         }
349 
350         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
351         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
352         uint256 contractTokens = feeAmount.sub(burnTokens);
353         _balances[address(this)] = _balances[address(this)].add(contractTokens);
354         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
355         emit Transfer(sender, address(this), contractTokens);
356         
357         
358         if(burnTokens > 0){
359             _totalSupply = _totalSupply.sub(burnTokens);
360             emit Transfer(sender, ZERO, burnTokens);  
361         
362         }
363 
364         return amount.sub(feeAmount);
365     }
366 
367     function shouldSwapBack() internal view returns (bool) {
368         return msg.sender != pair
369         && !inSwap
370         && swapEnabled
371         && _balances[address(this)] >= swapThreshold;
372     }
373 
374   
375      function manualSend() external { 
376              payable(autoLiquidityReceiver).transfer(address(this).balance);
377             
378     }
379 
380    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
381              if(tokens == 0){
382             tokens = ERC20(tokenAddress).balanceOf(address(this));
383         }
384         emit ClearToken(tokenAddress, tokens);
385         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
386     }
387 
388     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
389         sellpercent = _percentonsell;
390         buypercent = _percentonbuy;
391         transferpercent = _wallettransfer;    
392           
393     }
394        
395     function startTrading() public onlyOwner {
396         TradingOpen = true;
397         buypercent = 1400;
398         sellpercent = 800;
399         transferpercent = 1000;
400                               
401     }
402 
403       function reduceFee() public onlyOwner {
404        
405         buypercent = 400;
406         sellpercent = 700;
407         transferpercent = 500;
408                               
409     }
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
468     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
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