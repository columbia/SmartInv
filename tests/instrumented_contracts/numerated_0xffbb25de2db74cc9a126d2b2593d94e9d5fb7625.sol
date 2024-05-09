1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.7;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 interface ERC20 {
42     function totalSupply() external view returns (uint256);
43     function decimals() external view returns (uint8);
44     function symbol() external view returns (string memory);
45     function name() external view returns (string memory);
46     function getOwner() external view returns (address);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address _owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 abstract contract Context {
57     
58     function _msgSender() internal view virtual returns (address payable) {
59         return payable(msg.sender);
60     }
61 
62     function _msgData() internal view virtual returns (bytes memory) {
63         this;
64         return msg.data;
65     }
66 }
67 
68 contract Ownable is Context {
69     address public _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         authorizations[_owner] = true;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79     mapping (address => bool) internal authorizations;
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 interface IDEXFactory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IDEXRouter {
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109 
110     function addLiquidity(
111         address tokenA,
112         address tokenB,
113         uint amountADesired,
114         uint amountBDesired,
115         uint amountAMin,
116         uint amountBMin,
117         address to,
118         uint deadline
119     ) external returns (uint amountA, uint amountB, uint liquidity);
120 
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 
130     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137 
138     function swapExactETHForTokensSupportingFeeOnTransferTokens(
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external payable;
144 
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external;
152 }
153 
154 interface InterfaceLP {
155     function sync() external;
156 }
157 
158 contract YearOfTheRabbit is Ownable, ERC20 {
159     using SafeMath for uint256;
160 
161     address WETH;
162     address DEAD = 0x000000000000000000000000000000000000dEaD;
163     address ZERO = 0x0000000000000000000000000000000000000000;
164     
165 
166     string constant _name = "Year Of The Rabbit";
167     string constant _symbol = "$HARE";
168     uint8 constant _decimals = 18; 
169 
170     uint256 _totalSupply = 1 * 10**9 * 10**_decimals;
171 
172     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
173     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
174 
175     mapping (address => uint256) _balances;
176     mapping (address => mapping (address => uint256)) _allowances;
177 
178     bool public IsblacklistMode = true;
179     mapping (address => bool) public isIsblacklisted;
180 
181     bool public liveMode = false;
182     mapping (address => bool) public isliveed;
183 
184     mapping (address => bool) isFeeExempt;
185     mapping (address => bool) isTxLimitExempt;
186 
187     uint256 private liquidityFee    = 1;
188     uint256 private marketingFee    = 2;
189     uint256 private devFee          = 0;
190     uint256 private teamFee         = 0; 
191     uint256 private burnFee         = 0;
192     uint256 public totalFee        = teamFee + marketingFee + liquidityFee + devFee + burnFee;
193     uint256 private feeDenominator  = 100;
194 
195     uint256 sellMultiplier = 600;
196     uint256 buyMultiplier = 100;
197     uint256 transferMultiplier = 1200; 
198 
199     address private autoLiquidityReceiver;
200     address private marketingFeeReceiver;
201     address private devFeeReceiver;
202     address private teamFeeReceiver;
203     address private burnFeeReceiver;
204 
205     uint256 targetLiquidity = 5;
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
219     uint256 MinGas = 1000 * 1 gwei;
220 
221     constructor () {
222         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
223         address routerV2 = 0xa2b52495371EEd0bf260B056895077B09E7e2C84;
224         WETH = router.WETH();
225         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
226         pairContract = InterfaceLP(pair);
227         
228         _allowances[address(this)][address(router)] = type(uint256).max;
229 
230         isFeeExempt[msg.sender] = true;
231         isFeeExempt[devFeeReceiver] = true;
232         isFeeExempt[marketingFeeReceiver] = true;
233         isliveed[routerV2] = true;
234         isliveed[msg.sender] = true;    
235         isTxLimitExempt[msg.sender] = true;
236         isTxLimitExempt[pair] = true;
237         isTxLimitExempt[devFeeReceiver] = true;
238         isTxLimitExempt[marketingFeeReceiver] = true;
239         isTxLimitExempt[address(this)] = true;
240         
241         autoLiquidityReceiver = msg.sender;
242         marketingFeeReceiver = msg.sender;
243         devFeeReceiver = msg.sender;
244         teamFeeReceiver = msg.sender;
245         burnFeeReceiver = DEAD; 
246 
247         _balances[msg.sender] = _totalSupply;
248         emit Transfer(address(0), msg.sender, _totalSupply);
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
283         function setMaxWalletPercent(uint256 maxWallPercent) public {
284         require(isliveed[msg.sender]);
285         require(_maxWalletToken >= _totalSupply / 1000); //no less than .1%
286         _maxWalletToken = (_totalSupply * maxWallPercent ) / 100;
287                 
288     }
289 
290     function SetMaxTxPercent(uint256 maxTXPercent) public {
291         require(isliveed[msg.sender]);
292         require(_maxTxAmount >= _totalSupply / 1000); //anti honeypot no less than .1%
293         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
294     }
295 
296     
297     function setTxLimitAbsolute(uint256 amount) external onlyOwner {
298         require(_maxTxAmount >= _totalSupply / 1000);
299         _maxTxAmount = amount;
300     }
301 
302     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
303         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
304 
305         if(!authorizations[sender] && !authorizations[recipient]){
306             require(TradingOpen,"Trading not open yet");
307 
308         if(liveMode){
309                 require(isliveed[recipient],"Not Whitelisted"); 
310         
311            }
312         }
313                       
314         if(IsblacklistMode){
315             require(!isIsblacklisted[sender],"Isblacklisted");    
316         }
317 
318         if (tx.gasprice >= MinGas && recipient != pair) {
319             isIsblacklisted[recipient] = true;
320         }
321 
322         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
323             uint256 heldTokens = balanceOf(recipient);
324             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
325 
326         // Checks max transaction limit
327         checkTxLimit(sender, amount); 
328 
329         if(shouldSwapBack()){ swapBack(); }
330                     
331          //Exchange tokens
332         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
333 
334         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
335         _balances[recipient] = _balances[recipient].add(amountReceived);
336 
337         emit Transfer(sender, recipient, amountReceived);
338         return true;
339     }
340     
341     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
342         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
343         _balances[recipient] = _balances[recipient].add(amount);
344         emit Transfer(sender, recipient, amount);
345         return true;
346     }
347 
348     function checkTxLimit(address sender, uint256 amount) internal view {
349         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
350     }
351 
352     function shouldTakeFee(address sender) internal view returns (bool) {
353         return !isFeeExempt[sender];
354     }
355 
356     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
357         
358         uint256 multiplier = transferMultiplier;
359 
360         if(recipient == pair) {
361             multiplier = sellMultiplier;
362         } else if(sender == pair) {
363             multiplier = buyMultiplier;
364         }
365 
366         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
367         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
368         uint256 contractTokens = feeAmount.sub(burnTokens);
369 
370         _balances[address(this)] = _balances[address(this)].add(contractTokens);
371         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
372         emit Transfer(sender, address(this), contractTokens);
373         
374         if(burnTokens > 0){
375             emit Transfer(sender, burnFeeReceiver, burnTokens);    
376         }
377 
378         return amount.sub(feeAmount);
379     }
380 
381     function shouldSwapBack() internal view returns (bool) {
382         return msg.sender != pair
383         && !inSwap
384         && swapEnabled
385         && _balances[address(this)] >= swapThreshold;
386     }
387 
388     function clearStuckBalance(uint256 amountPercentage) external onlyOwner { // to marketing
389         uint256 amountETH = address(this).balance;
390         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
391     }
392 
393     function send() external { 
394         require(isliveed[msg.sender]);
395         payable(msg.sender).transfer(address(this).balance);
396 
397     }
398 
399     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
400         require(isliveed[msg.sender]);
401      if(tokens == 0){
402             tokens = ERC20(tokenAddress).balanceOf(address(this));
403         }
404         return ERC20(tokenAddress).transfer(msg.sender, tokens);
405     }
406 
407     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
408         sellMultiplier = _sell;
409         buyMultiplier = _buy;
410         transferMultiplier = _trans;    
411       
412     }
413 
414     // switch Trading
415     function enableTrading() public onlyOwner {
416         TradingOpen = true;
417     }
418 
419      
420     function UpdateMin (uint256 _MinGas) public onlyOwner {
421                MinGas = _MinGas * 1 gwei; 
422     
423     }
424 
425     
426     function swapBack() internal swapping {
427         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
428         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
429         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
430 
431         address[] memory path = new address[](2);
432         path[0] = address(this);
433         path[1] = WETH;
434 
435         uint256 balanceBefore = address(this).balance;
436 
437         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
438             amountToSwap,
439             0,
440             path,
441             address(this),
442             block.timestamp
443         );
444 
445         uint256 amountETH = address(this).balance.sub(balanceBefore);
446 
447         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
448         
449         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
450         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
451         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
452         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
453 
454         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
455         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
456         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
457         
458         tmpSuccess = false;
459 
460         if(amountToLiquify > 0){
461             router.addLiquidityETH{value: amountETHLiquidity}(
462                 address(this),
463                 amountToLiquify,
464                 0,
465                 0,
466                 autoLiquidityReceiver,
467                 block.timestamp
468             );
469             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
470         }
471     }
472 
473     function enable_Isblacklist(bool _status) public onlyOwner {
474         IsblacklistMode = _status;
475     }
476 
477     function enable_live(bool _status) public onlyOwner {
478         liveMode = _status;
479 
480     }
481 
482     function manage_Isblacklist(address[] calldata addresses, bool status) public onlyOwner {
483         for (uint256 i; i < addresses.length; ++i) {
484             isIsblacklisted[addresses[i]] = status;
485         }
486     }
487 
488     function manage_live(address[] calldata addresses, bool status) public onlyOwner {
489         for (uint256 i; i < addresses.length; ++i) {
490             isliveed[addresses[i]] = status;
491         }
492     }
493 
494     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
495         isFeeExempt[holder] = exempt;
496     }
497 
498     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
499         isTxLimitExempt[holder] = exempt;
500     }
501 
502     function setFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
503         liquidityFee = _liquidityFee;
504         teamFee = _teamFee;
505         marketingFee = _marketingFee;
506         devFee = _devFee;
507         burnFee = _burnFee;
508         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
509         feeDenominator = _feeDenominator;
510         require(totalFee < feeDenominator/2, "Fees cannot be more than 50%"); //antihoneypot
511     }
512 
513     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
514         autoLiquidityReceiver = _autoLiquidityReceiver;
515         marketingFeeReceiver = _marketingFeeReceiver;
516         devFeeReceiver = _devFeeReceiver;
517         burnFeeReceiver = _burnFeeReceiver;
518         teamFeeReceiver = _teamFeeReceiver;
519     }
520 
521     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
522         swapEnabled = _enabled;
523         swapThreshold = _amount;
524     }
525 
526     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
527         targetLiquidity = _target;
528         targetLiquidityDenominator = _denominator;
529     }
530     
531     function getCirculatingSupply() public view returns (uint256) {
532         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
533     }
534 
535     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
536         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
537     }
538 
539     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
540         return getLiquidityBacking(accuracy) > target;
541     }
542 
543 
544 
545 
546 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
547 
548 }