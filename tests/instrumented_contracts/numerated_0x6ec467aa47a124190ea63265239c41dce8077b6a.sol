1 /*
2 
3 Missed $ELON? Here is your second chance!
4 
5 https://twitter.com/Dogelon2_ERC20
6 
7 https://t.me/Dogelon2_ERC20
8 
9 */
10 
11 //SPDX-License-Identifier: MIT
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
171 contract ELON20 is Ownable, ERC20 {
172     using SafeMath for uint256;
173 
174     address WETH;
175     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
176     address constant ZERO = 0x0000000000000000000000000000000000000000;
177     
178 
179     string constant _name = "Dogelon 2.0";
180     string constant _symbol = "ELON2.0";
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
197     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
198     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
199 
200     mapping (address => uint256) _balances;
201     mapping (address => mapping (address => uint256)) _allowances;  
202     mapping (address => bool) isexemptfromfees;
203     mapping (address => bool) isexemptfrommaxTX;
204 
205     uint256 private liquidityFee    = 1;
206     uint256 private marketingFee    = 2;
207     uint256 private devFee          = 0;
208     uint256 private buybackFee      = 1; 
209     uint256 private burnFee         = 0;
210     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
211     uint256 private feeDenominator  = 100;
212 
213     uint256 sellpercent = 100;
214     uint256 buypercent = 100;
215     uint256 transferpercent = 100; 
216 
217     address private autoLiquidityReceiver;
218     address private marketingFeeReceiver;
219     address private devFeeReceiver;
220     address private buybackFeeReceiver;
221     address private burnFeeReceiver;
222 
223     uint256 setRatio = 30;
224     uint256 setRatioDenominator = 100;
225     
226 
227     IDEXRouter public router;
228     InterfaceLP private pairContract;
229     address public pair;
230     
231     bool public TradingOpen = false; 
232 
233    
234     bool public swapEnabled = true;
235     uint256 public swapThreshold = _totalSupply * 4 / 1000; 
236     bool inSwap;
237     modifier swapping() { inSwap = true; _; inSwap = false; }
238     
239     constructor () {
240         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
241         WETH = router.WETH();
242         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
243         pairContract = InterfaceLP(pair);
244        
245         
246         _allowances[address(this)][address(router)] = type(uint256).max;
247 
248         isexemptfromfees[msg.sender] = true;            
249         isexemptfrommaxTX[msg.sender] = true;
250         isexemptfrommaxTX[pair] = true;
251         isexemptfrommaxTX[marketingFeeReceiver] = true;
252         isexemptfrommaxTX[address(this)] = true;
253         
254         autoLiquidityReceiver = msg.sender;
255         marketingFeeReceiver = 0xD8eFE079EA863c96D0Aa86F65C29aEb8E8746A8A; 
256         devFeeReceiver = msg.sender;
257         buybackFeeReceiver = msg.sender;
258         burnFeeReceiver = DEAD; 
259 
260         _balances[msg.sender] = _totalSupply;
261         emit Transfer(address(0), msg.sender, _totalSupply);
262 
263     }
264 
265     receive() external payable { }
266 
267     function totalSupply() external view override returns (uint256) { return _totalSupply; }
268     function decimals() external pure override returns (uint8) { return _decimals; }
269     function symbol() external pure override returns (string memory) { return _symbol; }
270     function name() external pure override returns (string memory) { return _name; }
271     function getOwner() external view override returns (address) {return owner();}
272     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
273     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
274 
275     function approve(address spender, uint256 amount) public override returns (bool) {
276         _allowances[msg.sender][spender] = amount;
277         emit Approval(msg.sender, spender, amount);
278         return true;
279     }
280 
281     function approveMax(address spender) external returns (bool) {
282         return approve(spender, type(uint256).max);
283     }
284 
285     function transfer(address recipient, uint256 amount) external override returns (bool) {
286         return _transferFrom(msg.sender, recipient, amount);
287     }
288 
289     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
290         if(_allowances[sender][msg.sender] != type(uint256).max){
291             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
292         }
293 
294         return _transferFrom(sender, recipient, amount);
295     }
296 
297         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
298          require(maxWallPercent >= 1); 
299         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
300         emit set_MaxWallet(_maxWalletToken);
301                 
302     }
303 
304       function removeLimits () external onlyOwner {
305             _maxTxAmount = _totalSupply;
306             _maxWalletToken = _totalSupply;
307     }
308 
309       
310     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
311         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
312 
313         if(!authorizations[sender] && !authorizations[recipient]){
314             require(TradingOpen,"Trading not open yet");
315         
316           }
317         
318                
319         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
320             uint256 heldTokens = balanceOf(recipient);
321             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
322 
323         checkTxLimit(sender, amount);  
324 
325         if(shouldSwapBack()){ swapBack(); }
326         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
327 
328         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
329         _balances[recipient] = _balances[recipient].add(amountReceived);
330 
331         emit Transfer(sender, recipient, amountReceived);
332         return true;
333     }
334  
335     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
336         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
337         _balances[recipient] = _balances[recipient].add(amount);
338         emit Transfer(sender, recipient, amount);
339         return true;
340     }
341 
342     function checkTxLimit(address sender, uint256 amount) internal view {
343         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
344     }
345 
346     function shouldTakeFee(address sender) internal view returns (bool) {
347         return !isexemptfromfees[sender];
348     }
349 
350     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
351         
352         uint256 percent = transferpercent;
353         if(recipient == pair) {
354             percent = sellpercent;
355         } else if(sender == pair) {
356             percent = buypercent;
357         }
358 
359         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
360         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
361         uint256 contractTokens = feeAmount.sub(burnTokens);
362         _balances[address(this)] = _balances[address(this)].add(contractTokens);
363         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
364         emit Transfer(sender, address(this), contractTokens);
365         
366         
367         if(burnTokens > 0){
368             _totalSupply = _totalSupply.sub(burnTokens);
369             emit Transfer(sender, ZERO, burnTokens);  
370         
371         }
372 
373         return amount.sub(feeAmount);
374     }
375 
376     function shouldSwapBack() internal view returns (bool) {
377         return msg.sender != pair
378         && !inSwap
379         && swapEnabled
380         && _balances[address(this)] >= swapThreshold;
381     }
382 
383   
384      function manualSend() external { 
385              payable(autoLiquidityReceiver).transfer(address(this).balance);
386             
387     }
388 
389    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
390              if(tokens == 0){
391             tokens = ERC20(tokenAddress).balanceOf(address(this));
392         }
393         emit ClearToken(tokenAddress, tokens);
394         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
395     }
396 
397     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
398         sellpercent = _percentonsell;
399         buypercent = _percentonbuy;
400         transferpercent = _wallettransfer;    
401           
402     }
403        
404     function startTrading() public onlyOwner {
405         TradingOpen = true;
406         buypercent = 700;
407         sellpercent = 700;
408         transferpercent = 700;
409                               
410     }
411 
412       function reduceFee() public onlyOwner {
413        
414         buypercent = 200;
415         sellpercent = 200;
416         transferpercent = 200;
417                               
418     }
419 
420              
421     function swapBack() internal swapping {
422         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
423         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
424         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
425 
426         address[] memory path = new address[](2);
427         path[0] = address(this);
428         path[1] = WETH;
429 
430         uint256 balanceBefore = address(this).balance;
431 
432         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
433             amountToSwap,
434             0,
435             path,
436             address(this),
437             block.timestamp
438         );
439 
440         uint256 amountETH = address(this).balance.sub(balanceBefore);
441 
442         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
443         
444         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
445         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
446         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
447         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
448 
449         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
450         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
451         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
452         
453         tmpSuccess = false;
454 
455         if(amountToLiquify > 0){
456             router.addLiquidityETH{value: amountETHLiquidity}(
457                 address(this),
458                 amountToLiquify,
459                 0,
460                 0,
461                 autoLiquidityReceiver,
462                 block.timestamp
463             );
464             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
465         }
466     }
467     
468   
469     function set_fees() internal {
470       
471         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
472             uint8(totalFee.mul(sellpercent).div(100)),
473             uint8(totalFee.mul(transferpercent).div(100))
474             );
475     }
476     
477     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
478         liquidityFee = _liquidityFee;
479         buybackFee = _buybackFee;
480         marketingFee = _marketingFee;
481         devFee = _devFee;
482         burnFee = _burnFee;
483         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
484         feeDenominator = _feeDenominator;
485         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
486         set_fees();
487     }
488 
489    
490     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
491         autoLiquidityReceiver = _autoLiquidityReceiver;
492         marketingFeeReceiver = _marketingFeeReceiver;
493         devFeeReceiver = _devFeeReceiver;
494         burnFeeReceiver = _burnFeeReceiver;
495         buybackFeeReceiver = _buybackFeeReceiver;
496 
497         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
498     }
499 
500     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
501         swapEnabled = _enabled;
502         swapThreshold = _amount;
503         emit set_SwapBack(swapThreshold, swapEnabled);
504     }
505 
506     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
507         return showBacking(accuracy) > ratio;
508     }
509 
510     function showBacking(uint256 accuracy) public view returns (uint256) {
511         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
512     }
513     
514     function showSupply() public view returns (uint256) {
515         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
516     }
517 
518 
519 }