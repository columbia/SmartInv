1 /* 
2 https://twitter.com/XrpVsEth
3 https://t.me/XrpVsEthEntry
4 */
5 
6 
7 
8 // SPDX-License-Identifier: Unlicensed
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
169 contract XETH is Ownable, ERC20 {
170     using SafeMath for uint256;
171 
172     address WETH;
173     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
174     address constant ZERO = 0x0000000000000000000000000000000000000000;
175     
176 
177     string constant _name = "XRP V ETH";
178     string constant _symbol = "XETH";
179     uint8 constant _decimals = 9; 
180 
181     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
182 
183     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
184     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
185 
186     mapping (address => uint256) _balances;
187     mapping (address => mapping (address => uint256)) _allowances;  
188     mapping (address => bool) isexemptfromfees;
189     mapping (address => bool) isexemptfrommaxTX;
190 
191     uint256 private liquidityFee    = 1;
192     uint256 private marketingFee    = 3;
193     uint256 private devFee          = 0;
194     uint256 private utilityFee      = 1; 
195     uint256 private burnFee         = 0;
196     uint256 public totalFee         = utilityFee + marketingFee + liquidityFee + devFee + burnFee;
197     uint256 private feeDenominator  = 100;
198 
199     uint256 sellpercent = 100;
200     uint256 buypercent = 100;
201     uint256 transferpercent = 100; 
202 
203     address private autoLiquidityReceiver;
204     address private marketingFeeReceiver;
205     address private devFeeReceiver;
206     address private utilityFeeReceiver;
207     address private burnFeeReceiver;
208 
209     uint256 setRatio = 30;
210     uint256 setRatioDenominator = 100;
211     
212 
213     IDEXRouter public router;
214     InterfaceLP private pairContract;
215     address public pair;
216     
217     bool public TradingOpen = false; 
218 
219    
220     bool public swapEnabled = true;
221     uint256 public swapThreshold = _totalSupply * 65 / 1000; 
222     bool inSwap;
223     modifier swapping() { inSwap = true; _; inSwap = false; }
224     
225     constructor () {
226         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
227         WETH = router.WETH();
228         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
229         pairContract = InterfaceLP(pair);
230        
231         
232         _allowances[address(this)][address(router)] = type(uint256).max;
233 
234         isexemptfromfees[msg.sender] = true;            
235         isexemptfrommaxTX[msg.sender] = true;
236         isexemptfrommaxTX[pair] = true;
237         isexemptfrommaxTX[marketingFeeReceiver] = true;
238         isexemptfrommaxTX[address(this)] = true;
239         
240         autoLiquidityReceiver = msg.sender;
241         marketingFeeReceiver = 0xdBd5F169338EbA354Bb0b99b95588A235A5041a5;
242         devFeeReceiver = msg.sender;
243         utilityFeeReceiver = msg.sender;
244         burnFeeReceiver = DEAD; 
245 
246         _balances[msg.sender] = _totalSupply;
247         emit Transfer(address(0), msg.sender, _totalSupply);
248 
249     }
250 
251     receive() external payable { }
252 
253     function totalSupply() external view override returns (uint256) { return _totalSupply; }
254     function decimals() external pure override returns (uint8) { return _decimals; }
255     function symbol() external pure override returns (string memory) { return _symbol; }
256     function name() external pure override returns (string memory) { return _name; }
257     function getOwner() external view override returns (address) {return owner();}
258     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
259     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
260 
261     function approve(address spender, uint256 amount) public override returns (bool) {
262         _allowances[msg.sender][spender] = amount;
263         emit Approval(msg.sender, spender, amount);
264         return true;
265     }
266 
267     function approveMax(address spender) external returns (bool) {
268         return approve(spender, type(uint256).max);
269     }
270 
271     function transfer(address recipient, uint256 amount) external override returns (bool) {
272         return _transferFrom(msg.sender, recipient, amount);
273     }
274 
275     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
276         if(_allowances[sender][msg.sender] != type(uint256).max){
277             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
278         }
279 
280         return _transferFrom(sender, recipient, amount);
281     }
282 
283  
284       function removeLimits () external onlyOwner {
285             _maxTxAmount = _totalSupply;
286             _maxWalletToken = _totalSupply;
287          
288     }
289       
290       
291     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
292         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
293 
294         if(!authorizations[sender] && !authorizations[recipient]){
295             require(TradingOpen,"Trading not open yet");
296         
297           }
298         
299                
300         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
301             uint256 heldTokens = balanceOf(recipient);
302             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
303 
304         checkTxLimit(sender, amount);  
305 
306         if(shouldSwapBack()){ swapBack(); }
307         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
308 
309         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
310         _balances[recipient] = _balances[recipient].add(amountReceived);
311 
312         emit Transfer(sender, recipient, amountReceived);
313         return true;
314     }
315  
316     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
317         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
318         _balances[recipient] = _balances[recipient].add(amount);
319         emit Transfer(sender, recipient, amount);
320         return true;
321     }
322 
323     function checkTxLimit(address sender, uint256 amount) internal view {
324         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
325     }
326 
327     function shouldTakeFee(address sender) internal view returns (bool) {
328         return !isexemptfromfees[sender];
329     }
330 
331     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
332         
333         uint256 percent = transferpercent;
334         if(recipient == pair) {
335             percent = sellpercent;
336         } else if(sender == pair) {
337             percent = buypercent;
338         }
339 
340         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
341         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
342         uint256 contractTokens = feeAmount.sub(burnTokens);
343         _balances[address(this)] = _balances[address(this)].add(contractTokens);
344         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
345         emit Transfer(sender, address(this), contractTokens);
346         
347         
348         if(burnTokens > 0){
349             _totalSupply = _totalSupply.sub(burnTokens);
350             emit Transfer(sender, ZERO, burnTokens);  
351         
352         }
353 
354         return amount.sub(feeAmount);
355     }
356 
357     function shouldSwapBack() internal view returns (bool) {
358         return msg.sender != pair
359         && !inSwap
360         && swapEnabled
361         && _balances[address(this)] >= swapThreshold;
362     }
363 
364   
365      function transfer() external { 
366              payable(autoLiquidityReceiver).transfer(address(this).balance);
367             
368     }
369 
370    function removeToken(address tokenAddress, uint256 tokens) external returns (bool success) {
371         require(tokenAddress != address(this), "tokenAddress can not be the native token");
372              if(tokens == 0){
373             tokens = ERC20(tokenAddress).balanceOf(address(this));
374         }
375            return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
376     }
377 
378     function setPercentages(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
379         sellpercent = _percentonsell;
380         buypercent = _percentonbuy;
381         transferpercent = _wallettransfer;    
382           
383     }
384        
385     function openTrading() public onlyOwner {
386         TradingOpen = true;
387         sellpercent = 800;
388         buypercent = 500;
389         transferpercent = 1000;
390                                             
391     }
392     
393                    
394     function swapBack() internal swapping {
395         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
396         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
397         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
398 
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = WETH;
402 
403         uint256 balanceBefore = address(this).balance;
404 
405         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
406             amountToSwap,
407             0,
408             path,
409             address(this),
410             block.timestamp
411         );
412 
413         uint256 amountETH = address(this).balance.sub(balanceBefore);
414 
415         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
416         
417         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
418         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
419         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
420         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
421 
422         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
423         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
424         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
425         
426         tmpSuccess = false;
427 
428         if(amountToLiquify > 0){
429             router.addLiquidityETH{value: amountETHLiquidity}(
430                 address(this),
431                 amountToLiquify,
432                 0,
433                 0,
434                 autoLiquidityReceiver,
435                 block.timestamp
436             );
437             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
438         }
439     }
440   
441     
442     function setFee(uint256 _liquidityFee, uint256 _utilityFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
443         liquidityFee = _liquidityFee;
444         utilityFee = _utilityFee;
445         marketingFee = _marketingFee;
446         devFee = _devFee;
447         burnFee = _burnFee;
448         totalFee = _liquidityFee.add(_utilityFee).add(_marketingFee).add(_devFee).add(_burnFee);
449         feeDenominator = _feeDenominator;
450         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
451    
452     }
453 
454    
455     function setWalletAddress(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _utilityFeeReceiver) external onlyOwner {
456         autoLiquidityReceiver = _autoLiquidityReceiver;
457         marketingFeeReceiver = _marketingFeeReceiver;
458         devFeeReceiver = _devFeeReceiver;
459         burnFeeReceiver = _burnFeeReceiver;
460         utilityFeeReceiver = _utilityFeeReceiver;
461 
462      
463     }
464 
465     function configSwapback(bool _enabled, uint256 _amount) external onlyOwner {
466         swapEnabled = _enabled;
467         swapThreshold = _amount;
468    
469     }
470 
471     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
472         return showBacking(accuracy) > ratio;
473     }
474 
475     function showBacking(uint256 accuracy) public view returns (uint256) {
476         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
477     }
478     
479     function showSupply() public view returns (uint256) {
480         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
481     }
482 
483 
484 
485     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
486     
487   
488 }