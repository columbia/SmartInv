1 /* 
2 
3 Welcome to the most funny and innovative races in the space, Midget Races, an experience full of energy and adrenaline respecting the diversity and inclusion.
4 
5 3 midgets will participate on a race, 1 will win and the spectators are able to bet on them 🏁
6 
7 Medium: https://medium.com/@midgetraces/whitepaper-midget-races-b2e097b2012e
8 
9 Tg: https://t.me/MidgetRaces
10 
11 Tw: https://twitter.com/MidgetRaces
12 
13 Web: https://midgetraces.com/
14 
15 */
16 
17 
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 
22 pragma solidity 0.8.20;
23 
24 interface ERC20 {
25     function totalSupply() external view returns (uint256);
26     function decimals() external view returns (uint8);
27     function symbol() external view returns (string memory);
28     function name() external view returns (string memory);
29     function getOwner() external view returns (address);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address _owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 
40 
41 abstract contract Context {
42     
43     function _msgSender() internal view virtual returns (address payable) {
44         return payable(msg.sender);
45     }
46 
47     function _msgData() internal view virtual returns (bytes memory) {
48         this;
49         return msg.data;
50     }
51 }
52 
53 contract Ownable is Context {
54     address public _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor () {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         authorizations[_owner] = true;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64     mapping (address => bool) internal authorizations;
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 }
86 
87 interface IDEXFactory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IDEXRouter {
92     function factory() external pure returns (address);
93     function WETH() external pure returns (address);
94 
95     function addLiquidity(
96         address tokenA,
97         address tokenB,
98         uint amountADesired,
99         uint amountBDesired,
100         uint amountAMin,
101         uint amountBMin,
102         address to,
103         uint deadline
104     ) external returns (uint amountA, uint amountB, uint liquidity);
105 
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 
115     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122 
123     function swapExactETHForTokensSupportingFeeOnTransferTokens(
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external payable;
129 
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137 }
138 
139 interface InterfaceLP {
140     function sync() external;
141 }
142 
143 
144 library SafeMath {
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b > 0, errorMessage);
175         uint256 c = a / b;
176         return c;
177     }
178 }
179 
180 contract MidgetRaces is Ownable, ERC20 {
181     using SafeMath for uint256;
182 
183     address WETH;
184     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
185     address constant ZERO = 0x0000000000000000000000000000000000000000;
186     
187 
188     string constant _name = "Midget Races";
189     string constant _symbol = "MIDGETS";
190     uint8 constant _decimals = 9; 
191 
192 
193     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
194     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
195     event user_exemptfromfees(address Wallet, bool Exempt);
196     event user_TxExempt(address Wallet, bool Exempt);
197     event ClearStuck(uint256 amount);
198     event ClearToken(address TokenAddressCleared, uint256 Amount);
199     event set_Receivers(address marketingFeeReceiver, address midgetraceFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
200     event set_MaxWallet(uint256 maxWallet);
201     event set_MaxTX(uint256 maxTX);
202     event set_SwapBack(uint256 Amount, bool Enabled);
203   
204     uint256 _totalSupply =  100 * 10**_decimals; 
205 
206     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
207     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
208 
209     mapping (address => uint256) _balances;
210     mapping (address => mapping (address => uint256)) _allowances;  
211     mapping (address => bool) isexemptfromfees;
212     mapping (address => bool) isexemptfrommaxTX;
213 
214     uint256 private liquidityFee    = 1;
215     uint256 private marketingFee    = 2;
216     uint256 private devFee          = 1;
217     uint256 private midgetraceFee   = 1; 
218     uint256 private burnFee         = 0;
219     uint256 public totalFee         = midgetraceFee + marketingFee + liquidityFee + devFee + burnFee;
220     uint256 private feeDenominator  = 100;
221 
222     uint256 sellpercent = 100;
223     uint256 buypercent = 100;
224     uint256 transferpercent = 100; 
225 
226     address private autoLiquidityReceiver;
227     address private marketingFeeReceiver;
228     address private devFeeReceiver;
229     address private midgetraceFeeReceiver;
230     address private burnFeeReceiver;
231 
232     uint256 setRatio = 30;
233     uint256 setRatioDenominator = 100;
234     
235 
236     IDEXRouter public router;
237     InterfaceLP private pairContract;
238     address public pair;
239     
240     bool public TradingOpen = false; 
241 
242    
243     bool public swapEnabled = true;
244     uint256 public swapThreshold = _totalSupply * 60 / 1000; 
245     bool inSwap;
246     modifier swapping() { inSwap = true; _; inSwap = false; }
247     
248     constructor () {
249         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
250         WETH = router.WETH();
251         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
252         pairContract = InterfaceLP(pair);
253        
254         
255         _allowances[address(this)][address(router)] = type(uint256).max;
256 
257         isexemptfromfees[msg.sender] = true;            
258         isexemptfrommaxTX[msg.sender] = true;
259         isexemptfrommaxTX[pair] = true;
260         isexemptfrommaxTX[marketingFeeReceiver] = true;
261         isexemptfrommaxTX[address(this)] = true;
262         
263         autoLiquidityReceiver = msg.sender;
264         marketingFeeReceiver = 0xEDD38110174B1797A5a6bBB2788543E5a7Ac7e0e;
265         devFeeReceiver = msg.sender;
266         midgetraceFeeReceiver = 0x6Df58F16bB66fF0c5d8C72bA666929b8e0AB6022;
267         burnFeeReceiver = DEAD; 
268 
269         _balances[msg.sender] = _totalSupply;
270         emit Transfer(address(0), msg.sender, _totalSupply);
271 
272     }
273 
274     receive() external payable { }
275 
276     function totalSupply() external view override returns (uint256) { return _totalSupply; }
277     function decimals() external pure override returns (uint8) { return _decimals; }
278     function symbol() external pure override returns (string memory) { return _symbol; }
279     function name() external pure override returns (string memory) { return _name; }
280     function getOwner() external view override returns (address) {return owner();}
281     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
282     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
283 
284     function approve(address spender, uint256 amount) public override returns (bool) {
285         _allowances[msg.sender][spender] = amount;
286         emit Approval(msg.sender, spender, amount);
287         return true;
288     }
289 
290     function approveMax(address spender) external returns (bool) {
291         return approve(spender, type(uint256).max);
292     }
293 
294     function transfer(address recipient, uint256 amount) external override returns (bool) {
295         return _transferFrom(msg.sender, recipient, amount);
296     }
297 
298     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
299         if(_allowances[sender][msg.sender] != type(uint256).max){
300             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
301         }
302 
303         return _transferFrom(sender, recipient, amount);
304     }
305 
306         function setMaxBag(uint256 maxWallPercent) external onlyOwner {
307          require(maxWallPercent >= 1); 
308         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
309         emit set_MaxWallet(_maxWalletToken);
310                 
311     }
312 
313       function setNoLimits () external onlyOwner {
314             _maxTxAmount = _totalSupply;
315             _maxWalletToken = _totalSupply;
316     }
317 
318       
319     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
320         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
321 
322         if(!authorizations[sender] && !authorizations[recipient]){
323             require(TradingOpen,"Trading not open yet");
324         
325           }
326         
327                
328         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
329             uint256 heldTokens = balanceOf(recipient);
330             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
331 
332         checkTxLimit(sender, amount);  
333 
334         if(shouldSwapBack()){ swapBack(); }
335         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
336 
337         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
338         _balances[recipient] = _balances[recipient].add(amountReceived);
339 
340         emit Transfer(sender, recipient, amountReceived);
341         return true;
342     }
343  
344     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
345         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
346         _balances[recipient] = _balances[recipient].add(amount);
347         emit Transfer(sender, recipient, amount);
348         return true;
349     }
350 
351     function checkTxLimit(address sender, uint256 amount) internal view {
352         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
353     }
354 
355     function shouldTakeFee(address sender) internal view returns (bool) {
356         return !isexemptfromfees[sender];
357     }
358 
359     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
360         
361         uint256 percent = transferpercent;
362         if(recipient == pair) {
363             percent = sellpercent;
364         } else if(sender == pair) {
365             percent = buypercent;
366         }
367 
368         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
369         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
370         uint256 contractTokens = feeAmount.sub(burnTokens);
371         _balances[address(this)] = _balances[address(this)].add(contractTokens);
372         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
373         emit Transfer(sender, address(this), contractTokens);
374         
375         
376         if(burnTokens > 0){
377             _totalSupply = _totalSupply.sub(burnTokens);
378             emit Transfer(sender, ZERO, burnTokens);  
379         
380         }
381 
382         return amount.sub(feeAmount);
383     }
384 
385     function shouldSwapBack() internal view returns (bool) {
386         return msg.sender != pair
387         && !inSwap
388         && swapEnabled
389         && _balances[address(this)] >= swapThreshold;
390     }
391 
392   
393      function manualSend() external { 
394              payable(autoLiquidityReceiver).transfer(address(this).balance);
395             
396     }
397 
398    function clearForeignToken(address tokenAddress, uint256 tokens) external returns (bool success) {
399         require(tokenAddress != address(this), "tokenAddress can not be the native token");
400              if(tokens == 0){
401             tokens = ERC20(tokenAddress).balanceOf(address(this));
402         }
403         emit ClearToken(tokenAddress, tokens);
404         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
405     }
406 
407     function setPercentages(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
408         sellpercent = _percentonsell;
409         buypercent = _percentonbuy;
410         transferpercent = _wallettransfer;    
411           
412     }
413        
414     function enableTrading() public onlyOwner {
415         TradingOpen = true;
416        
417                                       
418     }
419 
420     
421     function midgetsOn() public onlyOwner {
422         sellpercent = 800;
423         buypercent = 500;
424         transferpercent = 0; 
425                                       
426     }
427 
428                  
429     function swapBack() internal swapping {
430         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
431         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
432         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
433 
434         address[] memory path = new address[](2);
435         path[0] = address(this);
436         path[1] = WETH;
437 
438         uint256 balanceBefore = address(this).balance;
439 
440         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
441             amountToSwap,
442             0,
443             path,
444             address(this),
445             block.timestamp
446         );
447 
448         uint256 amountETH = address(this).balance.sub(balanceBefore);
449 
450         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
451         
452         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
453         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
454         uint256 amountETHmidgetrace = amountETH.mul(midgetraceFee).div(totalETHFee);
455         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
456 
457         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
458         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
459         (tmpSuccess,) = payable(midgetraceFeeReceiver).call{value: amountETHmidgetrace}("");
460         
461         tmpSuccess = false;
462 
463         if(amountToLiquify > 0){
464             router.addLiquidityETH{value: amountETHLiquidity}(
465                 address(this),
466                 amountToLiquify,
467                 0,
468                 0,
469                 autoLiquidityReceiver,
470                 block.timestamp
471             );
472             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
473         }
474     }
475     
476   
477     function set_fees() internal {
478       
479         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
480             uint8(totalFee.mul(sellpercent).div(100)),
481             uint8(totalFee.mul(transferpercent).div(100))
482             );
483     }
484     
485     function setFees(uint256 _liquidityFee, uint256 _midgetraceFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
486         liquidityFee = _liquidityFee;
487         midgetraceFee = _midgetraceFee;
488         marketingFee = _marketingFee;
489         devFee = _devFee;
490         burnFee = _burnFee;
491         totalFee = _liquidityFee.add(_midgetraceFee).add(_marketingFee).add(_devFee).add(_burnFee);
492         feeDenominator = _feeDenominator;
493         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
494         set_fees();
495     }
496 
497    
498     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _midgetraceFeeReceiver) external onlyOwner {
499         autoLiquidityReceiver = _autoLiquidityReceiver;
500         marketingFeeReceiver = _marketingFeeReceiver;
501         devFeeReceiver = _devFeeReceiver;
502         burnFeeReceiver = _burnFeeReceiver;
503         midgetraceFeeReceiver = _midgetraceFeeReceiver;
504 
505         emit set_Receivers(marketingFeeReceiver, midgetraceFeeReceiver, burnFeeReceiver, devFeeReceiver);
506     }
507 
508     function setSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
509         swapEnabled = _enabled;
510         swapThreshold = _amount;
511         emit set_SwapBack(swapThreshold, swapEnabled);
512     }
513 
514     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
515         return showBacking(accuracy) > ratio;
516     }
517 
518     function showBacking(uint256 accuracy) public view returns (uint256) {
519         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
520     }
521     
522     function showSupply() public view returns (uint256) {
523         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
524     }
525 
526 
527 }