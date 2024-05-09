1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 pragma solidity ^0.8.17;
5 
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41 
42 interface ERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 abstract contract Context {
58     
59     function _msgSender() internal view virtual returns (address payable) {
60         return payable(msg.sender);
61     }
62 
63     function _msgData() internal view virtual returns (bytes memory) {
64         this;
65         return msg.data;
66     }
67 }
68 
69 contract Ownable is Context {
70     address public _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         authorizations[_owner] = true;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80     mapping (address => bool) internal authorizations;
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 interface IDEXFactory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IDEXRouter {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 
111     function addLiquidity(
112         address tokenA,
113         address tokenB,
114         uint amountADesired,
115         uint amountBDesired,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountA, uint amountB, uint liquidity);
121 
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 
139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external payable;
145 
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 }
154 
155 interface InterfaceLP {
156     function sync() external;
157 }
158 
159 contract CHICKEN is Ownable, ERC20 {
160     using SafeMath for uint256;
161 
162     address WETH;
163     address DEAD = 0x000000000000000000000000000000000000dEaD;
164     address ZERO = 0x0000000000000000000000000000000000000000;
165     
166 
167     string constant _name = "CHICKEN";
168     string constant _symbol = "CHICK";
169     uint8 constant _decimals = 9; 
170 
171     uint256 _totalSupply = 1 * 10**11 * 10**_decimals;
172 
173     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
174     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
175 
176     mapping (address => uint256) _balances;
177     mapping (address => mapping (address => uint256)) _allowances;
178 
179     bool public botMode = true;
180     mapping (address => bool) public isboted;
181 
182 
183     mapping (address => bool) isFeeExempt;
184     mapping (address => bool) isTxLimitExempt;
185 
186     uint256 private liquidityFee    = 2;
187     uint256 private marketingFee    = 1;
188     uint256 private devFee          = 0;
189     uint256 private eggFee          = 1; 
190     uint256 private stakingFee      = 0;
191     uint256 public totalFee         = eggFee + marketingFee + liquidityFee + devFee + stakingFee;
192     uint256 private feeDenominator  = 100;
193 
194     uint256 sellMultiplier = 2400;
195     uint256 buyMultiplier = 1200;
196     uint256 transferMultiplier = 1000; 
197 
198     address private autoLiquidityReceiver;
199     address private marketingFeeReceiver;
200     address private devFeeReceiver;
201     address private eggFeeReceiver;
202     address private stakingFeeReceiver;
203 
204     uint256 targetLiquidity = 30;
205     uint256 targetLiquidityDenominator = 100;
206 
207     IDEXRouter public router;
208     InterfaceLP private pairContract;
209     address public pair;
210     
211     bool public TradingOpen = false;    
212 
213     bool public swapEnabled = true;
214     uint256 public swapThreshold = _totalSupply * 35 / 1000; 
215     bool inSwap;
216     modifier swapping() { inSwap = true; _; inSwap = false; }
217     
218     constructor () {
219         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
220         WETH = router.WETH();
221         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
222         pairContract = InterfaceLP(pair);
223         
224         _allowances[address(this)][address(router)] = type(uint256).max;
225 
226         isFeeExempt[msg.sender] = true;
227         isFeeExempt[devFeeReceiver] = true;
228             
229         isTxLimitExempt[msg.sender] = true;
230         isTxLimitExempt[pair] = true;
231         isTxLimitExempt[devFeeReceiver] = true;
232         isTxLimitExempt[marketingFeeReceiver] = true;
233         isTxLimitExempt[address(this)] = true;
234         
235         autoLiquidityReceiver = msg.sender;
236         marketingFeeReceiver = msg.sender;
237         devFeeReceiver = msg.sender;
238         eggFeeReceiver = msg.sender;
239         stakingFeeReceiver = DEAD; 
240 
241         _balances[msg.sender] = _totalSupply;
242         emit Transfer(address(0), msg.sender, _totalSupply);
243     }
244 
245     receive() external payable { }
246 
247     function totalSupply() external view override returns (uint256) { return _totalSupply; }
248     function decimals() external pure override returns (uint8) { return _decimals; }
249     function symbol() external pure override returns (string memory) { return _symbol; }
250     function name() external pure override returns (string memory) { return _name; }
251     function getOwner() external view override returns (address) {return owner();}
252     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
253     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
254 
255     function approve(address spender, uint256 amount) public override returns (bool) {
256         _allowances[msg.sender][spender] = amount;
257         emit Approval(msg.sender, spender, amount);
258         return true;
259     }
260 
261     function approveMax(address spender) external returns (bool) {
262         return approve(spender, type(uint256).max);
263     }
264 
265     function transfer(address recipient, uint256 amount) external override returns (bool) {
266         return _transferFrom(msg.sender, recipient, amount);
267     }
268 
269     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
270         if(_allowances[sender][msg.sender] != type(uint256).max){
271             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
272         }
273 
274         return _transferFrom(sender, recipient, amount);
275     }
276 
277         function setMaxWalletPercent(uint256 maxWallPercent) external onlyOwner {
278          require(_maxWalletToken >= _totalSupply / 1000); 
279         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
280                 
281     }
282 
283     function setMaxTX(uint256 maxTXPercent) external onlyOwner {
284          require(_maxTxAmount >= _totalSupply / 1000); 
285         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
286     }
287 
288   
289     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
290         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
291 
292         if(!authorizations[sender] && !authorizations[recipient]){
293             require(TradingOpen,"Trading not open yet");
294         
295            }
296         
297                       
298         if(botMode){
299             require(!isboted[sender],"boted");    
300         }
301 
302         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != stakingFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
303             uint256 heldTokens = balanceOf(recipient);
304             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
305 
306         // Checks max transaction limit
307         checkTxLimit(sender, amount); 
308 
309         if(shouldSwapBack()){ swapBack(); }
310                     
311          //Exchange tokens
312         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
313 
314         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
315         _balances[recipient] = _balances[recipient].add(amountReceived);
316 
317         emit Transfer(sender, recipient, amountReceived);
318         return true;
319     }
320     
321     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
322         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
323         _balances[recipient] = _balances[recipient].add(amount);
324         emit Transfer(sender, recipient, amount);
325         return true;
326     }
327 
328     function checkTxLimit(address sender, uint256 amount) internal view {
329         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
330     }
331 
332     function shouldTakeFee(address sender) internal view returns (bool) {
333         return !isFeeExempt[sender];
334     }
335 
336     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
337         
338         uint256 multiplier = transferMultiplier;
339 
340         if(recipient == pair) {
341             multiplier = sellMultiplier;
342         } else if(sender == pair) {
343             multiplier = buyMultiplier;
344         }
345 
346         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
347         uint256 stakingTokens = feeAmount.mul(stakingFee).div(totalFee);
348         uint256 contractTokens = feeAmount.sub(stakingTokens);
349 
350         _balances[address(this)] = _balances[address(this)].add(contractTokens);
351         _balances[stakingFeeReceiver] = _balances[stakingFeeReceiver].add(stakingTokens);
352         emit Transfer(sender, address(this), contractTokens);
353         
354         if(stakingTokens > 0){
355             emit Transfer(sender, stakingFeeReceiver, stakingTokens);    
356         }
357 
358         return amount.sub(feeAmount);
359     }
360 
361     function shouldSwapBack() internal view returns (bool) {
362         return msg.sender != pair
363         && !inSwap
364         && swapEnabled
365         && _balances[address(this)] >= swapThreshold;
366     }
367 
368     function clearStuckETH(uint256 amountPercentage) external {
369         uint256 amountETH = address(this).balance;
370         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
371     }
372 
373      function Swapback() external onlyOwner {
374            swapBack();
375     
376     }
377 
378     function removeMaxWalletandTX() external onlyOwner { 
379         _maxWalletToken = _totalSupply;
380         _maxTxAmount = _totalSupply;
381 
382     }
383 
384     function manualTransfer() external { 
385         require(isTxLimitExempt[msg.sender]);
386         payable(devFeeReceiver).transfer(address(this).balance);
387 
388     }
389 
390     function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
391         require(isTxLimitExempt[msg.sender]);
392      if(tokens == 0){
393             tokens = ERC20(tokenAddress).balanceOf(address(this));
394         }
395         return ERC20(tokenAddress).transfer(msg.sender, tokens);
396     }
397 
398     function setPercentFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
399         sellMultiplier = _sell;
400         buyMultiplier = _buy;
401         transferMultiplier = _trans;    
402           
403     }
404 
405     function openTrading() public onlyOwner {
406         TradingOpen = true;
407     }
408 
409         
410     function swapBack() internal swapping {
411         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
412         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
413         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
414 
415         address[] memory path = new address[](2);
416         path[0] = address(this);
417         path[1] = WETH;
418 
419         uint256 balanceBefore = address(this).balance;
420 
421         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
422             amountToSwap,
423             0,
424             path,
425             address(this),
426             block.timestamp
427         );
428 
429         uint256 amountETH = address(this).balance.sub(balanceBefore);
430 
431         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
432         
433         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
434         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
435         uint256 amountETHegg = amountETH.mul(eggFee).div(totalETHFee);
436         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
437 
438         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
439         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
440         (tmpSuccess,) = payable(eggFeeReceiver).call{value: amountETHegg}("");
441         
442         tmpSuccess = false;
443 
444         if(amountToLiquify > 0){
445             router.addLiquidityETH{value: amountETHLiquidity}(
446                 address(this),
447                 amountToLiquify,
448                 0,
449                 0,
450                 autoLiquidityReceiver,
451                 block.timestamp
452             );
453             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
454         }
455     }
456 
457     function addsniper(bool _status) public onlyOwner {
458         botMode = _status;
459     }
460 
461    
462     function manage_sniper(address[] calldata addresses, bool status) public onlyOwner {
463         for (uint256 i; i < addresses.length; ++i) {
464             isboted[addresses[i]] = status;
465         }
466     }
467     
468     function setInternal(address holder, bool exempt) external onlyOwner {
469         isFeeExempt[holder] = exempt;
470         isTxLimitExempt[holder] = exempt;
471     }
472 
473     function setTXExemptOnly(address holder, bool exempt) external onlyOwner {
474         isTxLimitExempt[holder] = exempt;
475     }
476 
477     function setFeeBreakdown(uint256 _liquidityFee, uint256 _eggFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee, uint256 _feeDenominator) external onlyOwner {
478         liquidityFee = _liquidityFee;
479         eggFee = _eggFee;
480         marketingFee = _marketingFee;
481         devFee = _devFee;
482         stakingFee = _stakingFee;
483         totalFee = _liquidityFee.add(_eggFee).add(_marketingFee).add(_devFee).add(_stakingFee);
484         feeDenominator = _feeDenominator;
485         require(totalFee < feeDenominator/2, "Fees cannot be more than 50%"); 
486     }
487 
488     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _stakingFeeReceiver, address _eggFeeReceiver) external onlyOwner {
489         autoLiquidityReceiver = _autoLiquidityReceiver;
490         marketingFeeReceiver = _marketingFeeReceiver;
491         devFeeReceiver = _devFeeReceiver;
492         stakingFeeReceiver = _stakingFeeReceiver;
493         eggFeeReceiver = _eggFeeReceiver;
494     }
495 
496     function configSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
497         swapEnabled = _enabled;
498         swapThreshold = _amount;
499     }
500 
501     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
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
519 
520 
521 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
522 
523 }