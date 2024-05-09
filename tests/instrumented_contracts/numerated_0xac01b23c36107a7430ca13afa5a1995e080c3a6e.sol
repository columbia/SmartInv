1 /* 
2 
3 
4 */
5 
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 
10 pragma solidity 0.8.17;
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25 
26         return c;
27     }
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46 }
47 
48 interface ERC20 {
49     function totalSupply() external view returns (uint256);
50     function decimals() external view returns (uint8);
51     function symbol() external view returns (string memory);
52     function name() external view returns (string memory);
53     function getOwner() external view returns (address);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address _owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 abstract contract Context {
64     
65     function _msgSender() internal view virtual returns (address payable) {
66         return payable(msg.sender);
67     }
68 
69     function _msgData() internal view virtual returns (bytes memory) {
70         this;
71         return msg.data;
72     }
73 }
74 
75 contract Ownable is Context {
76     address public _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         authorizations[_owner] = true;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86     mapping (address => bool) internal authorizations;
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 interface IDEXFactory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IDEXRouter {
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116 
117     function addLiquidity(
118         address tokenA,
119         address tokenB,
120         uint amountADesired,
121         uint amountBDesired,
122         uint amountAMin,
123         uint amountBMin,
124         address to,
125         uint deadline
126     ) external returns (uint amountA, uint amountB, uint liquidity);
127 
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 
137     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 
145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external payable;
151 
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external;
159 }
160 
161 interface InterfaceLP {
162     function sync() external;
163 }
164 
165 contract SkynetAI is Ownable, ERC20 {
166     using SafeMath for uint256;
167 
168     address WETH;
169     address DEAD = 0x000000000000000000000000000000000000dEaD;
170     address ZERO = 0x0000000000000000000000000000000000000000;
171     
172 
173     string constant _name = "Skynet AI";
174     string constant _symbol = "Skynet";
175     uint8 constant _decimals = 9; 
176   
177 
178     uint256 _totalSupply = 1 * 10**15 * 10**_decimals;
179 
180     uint256 public _maxTxAmount = _totalSupply.mul(5).div(1000);
181     uint256 public _maxWalletToken = _totalSupply.mul(5).div(1000);
182 
183     mapping (address => uint256) _balances;
184     mapping (address => mapping (address => uint256)) _allowances;
185 
186     
187     mapping (address => bool) isFeeexcused;
188     mapping (address => bool) isTxLimitexcused;
189 
190     uint256 private liquidityFee    = 1;
191     uint256 private marketingFee    = 2;
192     uint256 private devFee          = 2;
193     uint256 private teamFee         = 1; 
194     uint256 private burnFee         = 0;
195     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + devFee + burnFee;
196     uint256 private feeDenominator  = 100;
197 
198     uint256 sellMultiplier = 100;
199     uint256 buyMultiplier = 100;
200     uint256 transferMultiplier = 100; 
201 
202     address private autoLiquidityReceiver;
203     address private marketingFeeReceiver;
204     address private devFeeReceiver;
205     address private teamFeeReceiver;
206     address private burnFeeReceiver;
207     
208     uint256 targetLiquidity = 30;
209     uint256 targetLiquidityDenominator = 100;
210 
211     IDEXRouter public router;
212     InterfaceLP private pairContract;
213     address public pair;
214     
215     bool public TradingOpen = false; 
216 
217     bool public launchMode = false;
218     mapping (address => bool) public islaunched;   
219 
220     bool public swapEnabled = true;
221     uint256 public swapThreshold = _totalSupply * 20 / 1000; 
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
234         isFeeexcused[msg.sender] = true;
235         isFeeexcused[devFeeReceiver] = true;
236             
237         isTxLimitexcused[msg.sender] = true;
238         isTxLimitexcused[pair] = true;
239         isTxLimitexcused[devFeeReceiver] = true;
240         isTxLimitexcused[marketingFeeReceiver] = true;
241         isTxLimitexcused[address(this)] = true;
242         
243         autoLiquidityReceiver = msg.sender;
244         marketingFeeReceiver = 0x3aC6F8Ec36daA56d52E4C410Bb7C36711de564Ee;
245         devFeeReceiver = 0xe38e5c7F7325891546938040894da2e0aA798Fe1;
246         teamFeeReceiver = msg.sender;
247         burnFeeReceiver = DEAD; 
248 
249         _balances[msg.sender] = _totalSupply;
250         emit Transfer(address(0), msg.sender, _totalSupply);
251 
252     }
253 
254     receive() external payable { }
255 
256     function totalSupply() external view override returns (uint256) { return _totalSupply; }
257     function decimals() external pure override returns (uint8) { return _decimals; }
258     function symbol() external pure override returns (string memory) { return _symbol; }
259     function name() external pure override returns (string memory) { return _name; }
260     function getOwner() external view override returns (address) {return owner();}
261     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
262     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
263 
264     function approve(address spender, uint256 amount) public override returns (bool) {
265         _allowances[msg.sender][spender] = amount;
266         emit Approval(msg.sender, spender, amount);
267         return true;
268     }
269 
270     function approveMax(address spender) external returns (bool) {
271         return approve(spender, type(uint256).max);
272     }
273 
274     function transfer(address recipient, uint256 amount) external override returns (bool) {
275         return _transferFrom(msg.sender, recipient, amount);
276     }
277 
278     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
279         if(_allowances[sender][msg.sender] != type(uint256).max){
280             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
281         }
282 
283         return _transferFrom(sender, recipient, amount);
284     }
285 
286         function setWalletPercent(uint256 maxWallPercent) external onlyOwner {
287          require(_maxWalletToken >= _totalSupply / 1000); 
288         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
289                 
290     }
291 
292     function setTXPercent(uint256 maxTXPercent) external onlyOwner {
293          require(_maxTxAmount >= _totalSupply / 1000); 
294         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
295     }
296 
297       
298     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
299         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
300 
301         if(!authorizations[sender] && !authorizations[recipient]){
302             require(TradingOpen,"Trading not open yet");
303         
304              if(launchMode){
305                 require(islaunched[recipient],"Not launched"); 
306           }
307         }
308                
309         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexcused[recipient]){
310             uint256 heldTokens = balanceOf(recipient);
311             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
312 
313         
314 
315         // Checks max transaction limit
316         checkTxLimit(sender, amount); 
317 
318         if(shouldSwapBack()){ swapBack(); }
319                     
320          //Exchange tokens
321         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
322 
323         uint256 amountReceived = (isFeeexcused[sender] || isFeeexcused[recipient]) ? amount : takeFee(sender, amount, recipient);
324         _balances[recipient] = _balances[recipient].add(amountReceived);
325 
326         emit Transfer(sender, recipient, amountReceived);
327         return true;
328     }
329     
330     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
331         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
332         _balances[recipient] = _balances[recipient].add(amount);
333         emit Transfer(sender, recipient, amount);
334         return true;
335     }
336 
337     function checkTxLimit(address sender, uint256 amount) internal view {
338         require(amount <= _maxTxAmount || isTxLimitexcused[sender], "TX Limit Exceeded");
339     }
340 
341     function shouldTakeFee(address sender) internal view returns (bool) {
342         return !isFeeexcused[sender];
343     }
344 
345     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
346         
347         uint256 multiplier = transferMultiplier;
348 
349         if(recipient == pair) {
350             multiplier = sellMultiplier;
351         } else if(sender == pair) {
352             multiplier = buyMultiplier;
353         }
354 
355         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
356         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
357         uint256 contractTokens = feeAmount.sub(burnTokens);
358 
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
380     function clearStuckETH(uint256 amountPercentage) external {
381         uint256 amountETH = address(this).balance;
382         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
383     }
384 
385      function swapback() external onlyOwner {
386            swapBack();
387     
388     }
389 
390     function removeLimits() external onlyOwner { 
391         _maxWalletToken = _totalSupply;
392         _maxTxAmount = _totalSupply;
393 
394     }
395 
396     function manualSend() external { 
397              payable(autoLiquidityReceiver).transfer(address(this).balance);
398 
399     }
400 
401     function removeForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
402                if(tokens == 0){
403             tokens = ERC20(tokenAddress).balanceOf(address(this));
404         }
405         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
406     }
407 
408     function setTax(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
409         sellMultiplier = _sell;
410         buyMultiplier = _buy;
411         transferMultiplier = _trans;    
412           
413     }
414 
415      function enableLaunch(bool _status) public onlyOwner {
416         launchMode = _status;
417     }
418 
419     function manageLaunch(address[] calldata addresses, bool status) public onlyOwner {
420         for (uint256 i; i < addresses.length; ++i) {
421             islaunched[addresses[i]] = status;
422         }
423     }
424 
425     function allowTrading() public onlyOwner {
426         launchMode = false;
427         buyMultiplier = 500;
428         sellMultiplier = 700;
429         transferMultiplier = 1900;
430     }
431 
432     function stepOne() public onlyOwner {
433         buyMultiplier = 200;
434         sellMultiplier = 400;
435         transferMultiplier = 0;
436     }
437 
438      function stepTwo() public onlyOwner {
439         buyMultiplier = 100;
440         sellMultiplier = 200;
441         transferMultiplier = 0;
442     }
443     
444     function goLive() public onlyOwner {
445         TradingOpen = true;
446         launchMode = true;
447     }
448         
449     function swapBack() internal swapping {
450         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
451         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
452         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
453 
454         address[] memory path = new address[](2);
455         path[0] = address(this);
456         path[1] = WETH;
457 
458         uint256 balanceBefore = address(this).balance;
459 
460         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
461             amountToSwap,
462             0,
463             path,
464             address(this),
465             block.timestamp
466         );
467 
468         uint256 amountETH = address(this).balance.sub(balanceBefore);
469 
470         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
471         
472         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
473         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
474         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
475         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
476 
477         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
478         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
479         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
480         
481         tmpSuccess = false;
482 
483         if(amountToLiquify > 0){
484             router.addLiquidityETH{value: amountETHLiquidity}(
485                 address(this),
486                 amountToLiquify,
487                 0,
488                 0,
489                 autoLiquidityReceiver,
490                 block.timestamp
491             );
492             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
493         }
494     }
495 
496     function setInternalAddress(address holder, bool excused) external onlyOwner {
497         isFeeexcused[holder] = excused;
498         isTxLimitexcused[holder] = excused;
499     }
500 
501     function setNoTxLimit(address holder, bool excused) external onlyOwner {
502         isTxLimitexcused[holder] = excused;
503     }
504 
505     function updateTaxAllocation(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
506         liquidityFee = _liquidityFee;
507         teamFee = _teamFee;
508         marketingFee = _marketingFee;
509         devFee = _devFee;
510         burnFee = _burnFee;
511         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
512         feeDenominator = _feeDenominator;
513         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
514     }
515 
516     function updateTaxWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
517         autoLiquidityReceiver = _autoLiquidityReceiver;
518         marketingFeeReceiver = _marketingFeeReceiver;
519         devFeeReceiver = _devFeeReceiver;
520         burnFeeReceiver = _burnFeeReceiver;
521         teamFeeReceiver = _teamFeeReceiver;
522     }
523 
524     function setSwapAndLiquify(bool _enabled, uint256 _amount) external onlyOwner {
525         swapEnabled = _enabled;
526         swapThreshold = _amount;
527     }
528 
529     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
530         targetLiquidity = _target;
531         targetLiquidityDenominator = _denominator;
532     }
533     
534     function getCirculatingSupply() public view returns (uint256) {
535         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
536     }
537 
538     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
539         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
540     }
541 
542     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
543         return getLiquidityBacking(accuracy) > target;
544     }
545 
546   
547 
548 
549 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
550 
551 }