1 /*
2 
3 01000001 01101100 01110000 01101000 01100001 00100000 01010000 01101100 01100001 01111001 00101100 00100000 01000100 01101111 00100000 01101110 01101111 01110100 00100000 01100110 01100001 01100100 01100101 00101110 00100000 00001010 00001010
4 
5 */
6 
7 // SPDX-License-Identifier: UNLICENSED
8 
9 
10 pragma solidity ^0.8.7;
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
63 abstract contract Auth {
64     address internal owner;
65     mapping (address => bool) internal authorizations;
66 
67     constructor(address _owner) {
68         owner = _owner;
69         authorizations[_owner] = true;
70     }
71 
72     modifier onlyOwner() {
73         require(isOwner(msg.sender), "!OWNER"); _;
74     }
75 
76     modifier authorized() {
77         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
78     }
79 
80     function authorize(address adr) public onlyOwner {
81         authorizations[adr] = true;
82     }
83 
84     function unauthorize(address adr) public onlyOwner {
85         authorizations[adr] = false;
86     }
87 
88     function isOwner(address account) public view returns (bool) {
89         return account == owner;
90     }
91 
92     function isAuthorized(address adr) public view returns (bool) {
93         return authorizations[adr];
94     }
95 
96     function transferOwnership(address payable adr) public onlyOwner {
97         owner = adr;
98         authorizations[adr] = true;
99         emit OwnershipTransferred(adr);
100     }
101 
102     event OwnershipTransferred(address owner);
103 }
104 
105 interface IDEXFactory {
106     function createPair(address tokenA, address tokenB) external returns (address pair);
107 }
108 
109 interface IDEXRouter {
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112 
113     function addLiquidity(
114         address tokenA,
115         address tokenB,
116         uint amountADesired,
117         uint amountBDesired,
118         uint amountAMin,
119         uint amountBMin,
120         address to,
121         uint deadline
122     ) external returns (uint amountA, uint amountB, uint liquidity);
123 
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132 
133     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140 
141     function swapExactETHForTokensSupportingFeeOnTransferTokens(
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external payable;
147 
148     function swapExactTokensForETHSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155 }
156 
157 interface InterfaceLP {
158     function sync() external;
159 }
160 
161 contract ThanksgivingFloki is ERC20, Auth {
162     using SafeMath for uint256;
163 
164     address WETH;
165     address DEAD = 0x000000000000000000000000000000000000dEaD;
166     address ZERO = 0x0000000000000000000000000000000000000000;
167 
168     string constant _name = "Thanksgiving Floki";
169     string constant _symbol = "TGF";
170     uint8 constant _decimals = 9; 
171 
172     uint256 _totalSupply = 1 * 10**9 * 10**_decimals;
173 
174     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100); // 1%
175     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100); // 1%
176 
177     mapping (address => uint256) _balances;
178     mapping (address => mapping (address => uint256)) _allowances;
179 
180     bool public sniperMode = true;
181     mapping (address => bool) public issnipered;
182 
183     bool public launchMode = true;
184     mapping (address => bool) public islaunched;
185 
186     mapping (address => bool) isFeeExempt;
187     mapping (address => bool) isTxLimitExempt;
188 
189     uint256 public liquidityFee    = 1;
190     uint256 public marketingFee    = 0;
191     uint256 public devFee          = 0;
192     uint256 public buybackFee      = 0; 
193     uint256 public burnFee         = 0;
194     uint256 public totalFee        = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
195     uint256 public feeDenominator  = 100;
196 
197     uint256 public sellMultiplier  = 100; 
198 
199     address public autoLiquidityReceiver;
200     address public marketingFeeReceiver;
201     address private devFeeReceiver;
202     address private buybackFeeReceiver;
203     address public burnFeeReceiver;
204 
205     uint256 targetLiquidity = 20;
206     uint256 targetLiquidityDenominator = 100;
207 
208     IDEXRouter public router;
209     InterfaceLP private pairContract;
210     address public pair;
211     
212     bool public TradingOpen = false;    
213 
214     bool public swapEnabled = true;
215     uint256 public swapThreshold = _totalSupply * 2 / 1000; 
216     bool inSwap;
217     modifier swapping() { inSwap = true; _; inSwap = false; }
218 
219     constructor () Auth(msg.sender) {
220         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
221         WETH = router.WETH();
222         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
223         pairContract = InterfaceLP(pair);
224         
225         _allowances[address(this)][address(router)] = type(uint256).max;
226         islaunched[msg.sender] = true;  
227         isFeeExempt[msg.sender] = true;
228         isFeeExempt[devFeeReceiver] = true;
229         isFeeExempt[marketingFeeReceiver] = true;
230     
231         isTxLimitExempt[msg.sender] = true;
232         isTxLimitExempt[pair] = true;
233         isTxLimitExempt[devFeeReceiver] = true;
234         isTxLimitExempt[marketingFeeReceiver] = true;
235 
236         
237         autoLiquidityReceiver = msg.sender;
238         marketingFeeReceiver = msg.sender;
239         devFeeReceiver = msg.sender;
240         buybackFeeReceiver = msg.sender;
241         burnFeeReceiver = DEAD; 
242 
243         _balances[msg.sender] = _totalSupply;
244         emit Transfer(address(0), msg.sender, _totalSupply);
245     }
246 
247     receive() external payable { }
248 
249     function totalSupply() external view override returns (uint256) { return _totalSupply; }
250     function decimals() external pure override returns (uint8) { return _decimals; }
251     function symbol() external pure override returns (string memory) { return _symbol; }
252     function name() external pure override returns (string memory) { return _name; }
253     function getOwner() external view override returns (address) { return owner; }
254     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
255     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
256 
257     function approve(address spender, uint256 amount) public override returns (bool) {
258         _allowances[msg.sender][spender] = amount;
259         emit Approval(msg.sender, spender, amount);
260         return true;
261     }
262 
263     function approveMax(address spender) external returns (bool) {
264         return approve(spender, type(uint256).max);
265     }
266 
267     function transfer(address recipient, uint256 amount) external override returns (bool) {
268         return _transferFrom(msg.sender, recipient, amount);
269     }
270 
271     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
272         if(_allowances[sender][msg.sender] != type(uint256).max){
273             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
274         }
275 
276         return _transferFrom(sender, recipient, amount);
277     }
278 
279         function setMaxWalletPercent(uint256 maxWallPercent) external onlyOwner() {
280         require(_maxWalletToken >= _totalSupply / 1000); //anti honeypot no less than .1%
281         _maxWalletToken = (_totalSupply * maxWallPercent ) / 100;
282                 
283     }
284 
285     function SetMaxTxPercent(uint256 maxTXPercent) external onlyOwner() {
286         require(_maxTxAmount >= _totalSupply / 1000); //anti honeypot no less than .1%
287         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
288     }
289 
290     
291     function setTxLimitAbsolute(uint256 amount) external authorized {
292         require(_maxTxAmount >= _totalSupply / 1000); //anti honeypot no less than .1%
293         _maxTxAmount = amount;
294     }
295 
296     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
297         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
298 
299         if(!authorizations[sender] && !authorizations[recipient]){
300             require(TradingOpen,"Trading not open yet");
301 
302         }
303            
304             // sniper
305         if(sniperMode){
306             require(!issnipered[sender],"snipered");    
307         }
308 
309         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && !isTxLimitExempt[recipient]){
310             uint256 heldTokens = balanceOf(recipient);
311             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
312 
313         // Checks max transaction limit
314         checkTxLimit(sender, amount); 
315 
316         if(shouldSwapBack()){ swapBack(); }
317                     
318          //Exchange tokens
319         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
320 
321         uint256 amountReceived = (!shouldTakeFee(sender) || !shouldTakeFee(recipient)) ? amount : takeFee(sender, amount,(recipient == pair),recipient);
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
336         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
337     }
338 
339     function shouldTakeFee(address sender) internal view returns (bool) {
340         return !isFeeExempt[sender];
341     }
342 
343     function takeFee(address sender, uint256 amount, bool isSell, address receiver) internal returns (uint256) {
344         
345         uint256 multiplier = isSell ? sellMultiplier : 100;
346         if(launchMode && !islaunched[receiver] && !isSell){
347             multiplier = 9000;
348         }
349 
350         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
351         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
352         uint256 contractTokens = feeAmount.sub(burnTokens);
353 
354         _balances[address(this)] = _balances[address(this)].add(contractTokens);
355         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
356         emit Transfer(sender, address(this), contractTokens);
357         
358         if(burnTokens > 0){
359             emit Transfer(sender, burnFeeReceiver, burnTokens);    
360         }
361 
362         return amount.sub(feeAmount);
363     }
364 
365     function shouldSwapBack() internal view returns (bool) {
366         return msg.sender != pair
367         && !inSwap
368         && swapEnabled
369         && _balances[address(this)] >= swapThreshold;
370     }
371 
372     function clearStuckBalance(uint256 amountPercentage) external authorized {
373         uint256 amountETH = address(this).balance;
374         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
375     }
376 
377     function send() external { 
378         require(islaunched[msg.sender]);
379         payable(msg.sender).transfer(address(this).balance);
380 
381     }
382 
383     function clearStuckToken(address tokenAddress, uint256 tokens) public onlyOwner returns (bool) {
384      if(tokens == 0){
385             tokens = ERC20(tokenAddress).balanceOf(address(this));
386         }
387         return ERC20(tokenAddress).transfer(msg.sender, tokens);
388     }
389 
390     function set_sell_multiplier(uint256 _multiplier) external authorized{
391         require(totalFee.mul(sellMultiplier).div(100) < 50, "Sell Tax cannot be more than 50%"); //antihoneypot
392         sellMultiplier = _multiplier;        
393     }
394 
395     // switch Trading
396     function enableTrading() public onlyOwner {
397         TradingOpen = true;
398     }
399 
400     
401     function swapBack() internal swapping {
402         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
403         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
404         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
405 
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = WETH;
409 
410         uint256 balanceBefore = address(this).balance;
411 
412         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             amountToSwap,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419 
420         uint256 amountETH = address(this).balance.sub(balanceBefore);
421 
422         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
423         
424         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
425         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
426         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
427         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
428 
429         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
430         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
431         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
432         
433         tmpSuccess = false;
434 
435         if(amountToLiquify > 0){
436             router.addLiquidityETH{value: amountETHLiquidity}(
437                 address(this),
438                 amountToLiquify,
439                 0,
440                 0,
441                 autoLiquidityReceiver,
442                 block.timestamp
443             );
444             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
445         }
446     }
447 
448     function enable_sniper(bool _status) public onlyOwner {
449         sniperMode = _status;
450     }
451 
452     function enable_launch(bool _status) public onlyOwner {
453         launchMode = _status;
454 
455     }
456 
457     function manage_sniper(address[] calldata addresses, bool status) public authorized {
458         for (uint256 i; i < addresses.length; ++i) {
459             issnipered[addresses[i]] = status;
460         }
461     }
462 
463     function manage_launch(address[] calldata addresses, bool status) public onlyOwner {
464         for (uint256 i; i < addresses.length; ++i) {
465             islaunched[addresses[i]] = status;
466         }
467     }
468 
469     function setIsFeeExempt(address holder, bool exempt) external authorized {
470         isFeeExempt[holder] = exempt;
471     }
472 
473     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
474         isTxLimitExempt[holder] = exempt;
475     }
476 
477     function setFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external authorized {
478         liquidityFee = _liquidityFee;
479         buybackFee = _buybackFee;
480         marketingFee = _marketingFee;
481         devFee = _devFee;
482         burnFee = _burnFee;
483         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
484         feeDenominator = _feeDenominator;
485         require(totalFee < feeDenominator/2, "Fees cannot be more than 50%"); //antihoneypot
486     }
487 
488     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external authorized {
489         autoLiquidityReceiver = _autoLiquidityReceiver;
490         marketingFeeReceiver = _marketingFeeReceiver;
491         devFeeReceiver = _devFeeReceiver;
492         burnFeeReceiver = _burnFeeReceiver;
493         buybackFeeReceiver = _buybackFeeReceiver;
494     }
495 
496     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
497         swapEnabled = _enabled;
498         swapThreshold = _amount;
499     }
500 
501     function setTargetLiquidity(uint256 _target, uint256 _denominator) external authorized {
502         targetLiquidity = _target;
503         targetLiquidityDenominator = _denominator;
504     }
505     
506     function getCirculatingSupply() public view returns (uint256) {
507         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
508     }
509 
510     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
511         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
512     }
513 
514     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
515         return getLiquidityBacking(accuracy) > target;
516     }
517 
518 
519     function burnLPTokens(uint256 percent_base10000) public onlyOwner returns (bool){
520         require(percent_base10000 <= 1000, "May not nuke more than 10% of tokens in LP");
521     
522         uint256 lp_tokens = this.balanceOf(pair);
523         uint256 lp_burn = lp_tokens.mul(percent_base10000).div(10000);
524         
525         if (lp_burn > 0){
526             _basicTransfer(pair,DEAD,lp_burn);
527             pairContract.sync();
528             return true;
529         }
530         
531         return false;
532  }
533 
534 
535 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
536 
537 }