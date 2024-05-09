1 /**
2   _______      ________  ________  _______   ________  _______      
3  /  ___  \    |\   __  \|\   __  \|\  ___ \ |\   __  \|\  ___ \     
4 /__/|_/  /|   \ \  \|\  \ \  \|\  \ \   __/|\ \  \|\  \ \   __/|    
5 |__|//  / /    \ \  \\\  \ \   ____\ \  \_|/_\ \   ____\ \  \_|/__  
6     /  /_/__  __\ \  \\\  \ \  \___|\ \  \_|\ \ \  \___|\ \  \_|\ \ 
7    |\________\\__\ \_______\ \__\    \ \_______\ \__\    \ \_______\
8     \|_______\|__|\|_______|\|__|     \|_______|\|__|     \|_______|
9                                                                     
10                                                                     
11 */                                                                  
12                                                     
13 // https://twitter.com/erc20pepecoin
14 
15 // https://t.me/erc20pepe
16 
17 // https://20pepe.com/
18 
19 
20 
21 // SPDX-License-Identifier: MIT
22 
23 
24 pragma solidity 0.8.20;
25 
26 interface ERC20 {
27     function totalSupply() external view returns (uint256);
28     function decimals() external view returns (uint8);
29     function symbol() external view returns (string memory);
30     function name() external view returns (string memory);
31     function getOwner() external view returns (address);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address _owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 
42 
43 abstract contract Context {
44     
45     function _msgSender() internal view virtual returns (address payable) {
46         return payable(msg.sender);
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this;
51         return msg.data;
52     }
53 }
54 
55 contract Ownable is Context {
56     address public _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     constructor () {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         authorizations[_owner] = true;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66     mapping (address => bool) internal authorizations;
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 interface IDEXFactory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IDEXRouter {
94     function factory() external pure returns (address);
95     function WETH() external pure returns (address);
96 
97     function addLiquidity(
98         address tokenA,
99         address tokenB,
100         uint amountADesired,
101         uint amountBDesired,
102         uint amountAMin,
103         uint amountBMin,
104         address to,
105         uint deadline
106     ) external returns (uint amountA, uint amountB, uint liquidity);
107 
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 
117     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124 
125     function swapExactETHForTokensSupportingFeeOnTransferTokens(
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external payable;
131 
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 }
140 
141 interface InterfaceLP {
142     function sync() external;
143 }
144 
145 
146 library SafeMath {
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b > 0, errorMessage);
177         uint256 c = a / b;
178         return c;
179     }
180 }
181 
182 contract erc20PEPE is Ownable, ERC20 {
183     using SafeMath for uint256;
184 
185     address WETH;
186     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
187     address constant ZERO = 0x0000000000000000000000000000000000000000;
188     
189 
190     string constant _name = "2.0 Pepe";
191     string constant _symbol = "2.0PEPE";
192     uint8 constant _decimals = 18; 
193 
194 
195     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
196     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
197     event user_exemptfromfees(address Wallet, bool Exempt);
198     event user_TxExempt(address Wallet, bool Exempt);
199     event ClearStuck(uint256 amount);
200     event ClearToken(address TokenAddressCleared, uint256 Amount);
201     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
202     event set_MaxWallet(uint256 maxWallet);
203     event set_MaxTX(uint256 maxTX);
204     event set_SwapBack(uint256 Amount, bool Enabled);
205   
206     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
207 
208     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
209     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
210 
211     mapping (address => uint256) _balances;
212     mapping (address => mapping (address => uint256)) _allowances;  
213     mapping (address => bool) isexemptfromfees;
214     mapping (address => bool) isexemptfrommaxTX;
215 
216     uint256 private liquidityFee    = 1;
217     uint256 private marketingFee    = 3;
218     uint256 private devFee          = 0;
219     uint256 private buybackFee      = 1; 
220     uint256 private burnFee         = 0;
221     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
222     uint256 private feeDenominator  = 100;
223 
224     uint256 sellpercent = 100;
225     uint256 buypercent = 100;
226     uint256 transferpercent = 100; 
227 
228     address private autoLiquidityReceiver;
229     address private marketingFeeReceiver;
230     address private devFeeReceiver;
231     address private buybackFeeReceiver;
232     address private burnFeeReceiver;
233 
234     uint256 setRatio = 30;
235     uint256 setRatioDenominator = 100;
236     
237 
238     IDEXRouter public router;
239     InterfaceLP private pairContract;
240     address public pair;
241     
242     bool public TradingOpen = false; 
243 
244    
245     bool public swapEnabled = true;
246     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
247     bool inSwap;
248     modifier swapping() { inSwap = true; _; inSwap = false; }
249     
250     constructor () {
251         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
252         WETH = router.WETH();
253         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
254         pairContract = InterfaceLP(pair);
255        
256         
257         _allowances[address(this)][address(router)] = type(uint256).max;
258 
259         isexemptfromfees[msg.sender] = true;            
260         isexemptfrommaxTX[msg.sender] = true;
261         isexemptfrommaxTX[pair] = true;
262         isexemptfrommaxTX[marketingFeeReceiver] = true;
263         isexemptfrommaxTX[address(this)] = true;
264         
265         autoLiquidityReceiver = msg.sender;
266         marketingFeeReceiver = 0xea72fF8705F521e555fF7Ee2A6d3924Be760019C;
267         devFeeReceiver = msg.sender;
268         buybackFeeReceiver = msg.sender;
269         burnFeeReceiver = DEAD; 
270 
271         _balances[msg.sender] = _totalSupply;
272         emit Transfer(address(0), msg.sender, _totalSupply);
273 
274     }
275 
276     receive() external payable { }
277 
278     function totalSupply() external view override returns (uint256) { return _totalSupply; }
279     function decimals() external pure override returns (uint8) { return _decimals; }
280     function symbol() external pure override returns (string memory) { return _symbol; }
281     function name() external pure override returns (string memory) { return _name; }
282     function getOwner() external view override returns (address) {return owner();}
283     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
284     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
285 
286     function approve(address spender, uint256 amount) public override returns (bool) {
287         _allowances[msg.sender][spender] = amount;
288         emit Approval(msg.sender, spender, amount);
289         return true;
290     }
291 
292     function approveMax(address spender) external returns (bool) {
293         return approve(spender, type(uint256).max);
294     }
295 
296     function transfer(address recipient, uint256 amount) external override returns (bool) {
297         return _transferFrom(msg.sender, recipient, amount);
298     }
299 
300     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
301         if(_allowances[sender][msg.sender] != type(uint256).max){
302             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
303         }
304 
305         return _transferFrom(sender, recipient, amount);
306     }
307 
308         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
309          require(maxWallPercent >= 1); 
310         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
311         emit set_MaxWallet(_maxWalletToken);
312                 
313     }
314 
315       function removeLimits () external onlyOwner {
316             _maxTxAmount = _totalSupply;
317             _maxWalletToken = _totalSupply;
318     }
319 
320       
321     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
322         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
323 
324         if(!authorizations[sender] && !authorizations[recipient]){
325             require(TradingOpen,"Trading not open yet");
326         
327           }
328         
329                
330         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
331             uint256 heldTokens = balanceOf(recipient);
332             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
333 
334         checkTxLimit(sender, amount);  
335 
336         if(shouldSwapBack()){ swapBack(); }
337         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
338 
339         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
340         _balances[recipient] = _balances[recipient].add(amountReceived);
341 
342         emit Transfer(sender, recipient, amountReceived);
343         return true;
344     }
345  
346     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
347         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
348         _balances[recipient] = _balances[recipient].add(amount);
349         emit Transfer(sender, recipient, amount);
350         return true;
351     }
352 
353     function checkTxLimit(address sender, uint256 amount) internal view {
354         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
355     }
356 
357     function shouldTakeFee(address sender) internal view returns (bool) {
358         return !isexemptfromfees[sender];
359     }
360 
361     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
362         
363         uint256 percent = transferpercent;
364         if(recipient == pair) {
365             percent = sellpercent;
366         } else if(sender == pair) {
367             percent = buypercent;
368         }
369 
370         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
371         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
372         uint256 contractTokens = feeAmount.sub(burnTokens);
373         _balances[address(this)] = _balances[address(this)].add(contractTokens);
374         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
375         emit Transfer(sender, address(this), contractTokens);
376         
377         
378         if(burnTokens > 0){
379             _totalSupply = _totalSupply.sub(burnTokens);
380             emit Transfer(sender, ZERO, burnTokens);  
381         
382         }
383 
384         return amount.sub(feeAmount);
385     }
386 
387     function shouldSwapBack() internal view returns (bool) {
388         return msg.sender != pair
389         && !inSwap
390         && swapEnabled
391         && _balances[address(this)] >= swapThreshold;
392     }
393 
394   
395      function manualSend() external { 
396              payable(autoLiquidityReceiver).transfer(address(this).balance);
397             
398     }
399 
400    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
401              if(tokens == 0){
402             tokens = ERC20(tokenAddress).balanceOf(address(this));
403         }
404         emit ClearToken(tokenAddress, tokens);
405         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
406     }
407 
408     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
409         sellpercent = _percentonsell;
410         buypercent = _percentonbuy;
411         transferpercent = _wallettransfer;    
412           
413     }
414        
415     function startTrading() public onlyOwner {
416         TradingOpen = true;
417         buypercent = 1400;
418         sellpercent = 800;
419         transferpercent = 1000;
420                               
421     }
422 
423       function reduceFee() public onlyOwner {
424        
425         buypercent = 400;
426         sellpercent = 700;
427         transferpercent = 500;
428                               
429     }
430 
431              
432     function swapBack() internal swapping {
433         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
434         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
435         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
436 
437         address[] memory path = new address[](2);
438         path[0] = address(this);
439         path[1] = WETH;
440 
441         uint256 balanceBefore = address(this).balance;
442 
443         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
444             amountToSwap,
445             0,
446             path,
447             address(this),
448             block.timestamp
449         );
450 
451         uint256 amountETH = address(this).balance.sub(balanceBefore);
452 
453         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
454         
455         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
456         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
457         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
458         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
459 
460         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
461         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
462         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
463         
464         tmpSuccess = false;
465 
466         if(amountToLiquify > 0){
467             router.addLiquidityETH{value: amountETHLiquidity}(
468                 address(this),
469                 amountToLiquify,
470                 0,
471                 0,
472                 autoLiquidityReceiver,
473                 block.timestamp
474             );
475             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
476         }
477     }
478     
479   
480     function set_fees() internal {
481       
482         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
483             uint8(totalFee.mul(sellpercent).div(100)),
484             uint8(totalFee.mul(transferpercent).div(100))
485             );
486     }
487     
488     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
489         liquidityFee = _liquidityFee;
490         buybackFee = _buybackFee;
491         marketingFee = _marketingFee;
492         devFee = _devFee;
493         burnFee = _burnFee;
494         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
495         feeDenominator = _feeDenominator;
496         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
497         set_fees();
498     }
499 
500    
501     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
502         autoLiquidityReceiver = _autoLiquidityReceiver;
503         marketingFeeReceiver = _marketingFeeReceiver;
504         devFeeReceiver = _devFeeReceiver;
505         burnFeeReceiver = _burnFeeReceiver;
506         buybackFeeReceiver = _buybackFeeReceiver;
507 
508         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
509     }
510 
511     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
512         swapEnabled = _enabled;
513         swapThreshold = _amount;
514         emit set_SwapBack(swapThreshold, swapEnabled);
515     }
516 
517     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
518         return showBacking(accuracy) > ratio;
519     }
520 
521     function showBacking(uint256 accuracy) public view returns (uint256) {
522         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
523     }
524     
525     function showSupply() public view returns (uint256) {
526         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
527     }
528 
529 
530 }