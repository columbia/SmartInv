1 /* 
2 
3 504550452046414345202D2049594B594B
4 
5 https://t.me/PepeFacePortal
6 https://twitter.com/PepeFaceETH
7 https://PepeFace.vip  
8 
9 */
10 
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 
15 pragma solidity 0.8.18;
16 
17 interface ERC20 {
18     function totalSupply() external view returns (uint256);
19     function decimals() external view returns (uint8);
20     function symbol() external view returns (string memory);
21     function name() external view returns (string memory);
22     function getOwner() external view returns (address);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address _owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 }
67 
68 
69 
70 abstract contract Context {
71     
72     function _msgSender() internal view virtual returns (address payable) {
73         return payable(msg.sender);
74     }
75 
76     function _msgData() internal view virtual returns (bytes memory) {
77         this;
78         return msg.data;
79     }
80 }
81 
82 contract Ownable is Context {
83     address public _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         authorizations[_owner] = true;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93     mapping (address => bool) internal authorizations;
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         emit OwnershipTransferred(_owner, newOwner);
112         _owner = newOwner;
113     }
114 }
115 
116 interface IDEXFactory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IDEXRouter {
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123 
124     function addLiquidity(
125         address tokenA,
126         address tokenB,
127         uint amountADesired,
128         uint amountBDesired,
129         uint amountAMin,
130         uint amountBMin,
131         address to,
132         uint deadline
133     ) external returns (uint amountA, uint amountB, uint liquidity);
134 
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 
144     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 
152     function swapExactETHForTokensSupportingFeeOnTransferTokens(
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external payable;
158 
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166 }
167 
168 interface InterfaceLP {
169     function sync() external;
170 }
171 
172 contract PepeFace is Ownable, ERC20 {
173     using SafeMath for uint256;
174 
175     address WETH;
176     address DEAD = 0x000000000000000000000000000000000000dEaD;
177     address ZERO = 0x0000000000000000000000000000000000000000;
178     
179 
180     string constant _name = "Pepe Face";
181     string constant _symbol = unicode"₍° ̮ °₎";
182     uint8 constant _decimals = 9; 
183   
184 
185     uint256 _totalSupply = 1 * 10**15 * 10**_decimals;
186 
187     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
188     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
189 
190     mapping (address => uint256) _balances;
191     mapping (address => mapping (address => uint256)) _allowances;
192 
193     
194     mapping (address => bool) isFeeexempt;
195     mapping (address => bool) isTxLimitexempt;
196 
197     uint256 private liquidityFee    = 1;
198     uint256 private marketingFee    = 3;
199     uint256 private devFee          = 0;
200     uint256 private utilityFee      = 1; 
201     uint256 private burnFee         = 0;
202     uint256 public totalFee         = utilityFee + marketingFee + liquidityFee + devFee + burnFee;
203     uint256 private feeDenominator  = 100;
204 
205     uint256 sellpercent = 100;
206     uint256 buypercent = 100;
207     uint256 transferpercent = 100; 
208 
209     address private autoLiquidityReceiver;
210     address private marketingFeeReceiver;
211     address private devFeeReceiver;
212     address private utilityFeeReceiver;
213     address private burnFeeReceiver;
214     
215     uint256 targetLiquidity = 35;
216     uint256 targetLiquidityDenominator = 100;
217 
218     IDEXRouter public router;
219     InterfaceLP private pairContract;
220     address public pair;
221     
222     bool public TradingOpen = false; 
223 
224     bool public antiBotMode = false;
225     mapping (address => bool) public isantiBoted;   
226 
227     bool public swapEnabled = true;
228     uint256 public swapThreshold = _totalSupply * 30 / 1000; 
229     bool inSwap;
230     modifier swapping() { inSwap = true; _; inSwap = false; }
231     
232     constructor () {
233         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234         WETH = router.WETH();
235         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
236         pairContract = InterfaceLP(pair);
237        
238         
239         _allowances[address(this)][address(router)] = type(uint256).max;
240 
241         isFeeexempt[msg.sender] = true;
242         isFeeexempt[devFeeReceiver] = true;
243             
244         isTxLimitexempt[msg.sender] = true;
245         isTxLimitexempt[pair] = true;
246         isTxLimitexempt[devFeeReceiver] = true;
247         isTxLimitexempt[marketingFeeReceiver] = true;
248         isTxLimitexempt[address(this)] = true;
249         
250         autoLiquidityReceiver = msg.sender;
251         marketingFeeReceiver = 0x8b9Ae7061fBb6E26ed1ee5c2cBa386339aE06d04;
252         devFeeReceiver = msg.sender;
253         utilityFeeReceiver = msg.sender;
254         burnFeeReceiver = DEAD; 
255 
256         _balances[msg.sender] = _totalSupply;
257         emit Transfer(address(0), msg.sender, _totalSupply);
258 
259     }
260 
261     receive() external payable { }
262 
263     function totalSupply() external view override returns (uint256) { return _totalSupply; }
264     function decimals() external pure override returns (uint8) { return _decimals; }
265     function symbol() external pure override returns (string memory) { return _symbol; }
266     function name() external pure override returns (string memory) { return _name; }
267     function getOwner() external view override returns (address) {return owner();}
268     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
269     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
270 
271     function approve(address spender, uint256 amount) public override returns (bool) {
272         _allowances[msg.sender][spender] = amount;
273         emit Approval(msg.sender, spender, amount);
274         return true;
275     }
276 
277     function approveMax(address spender) external returns (bool) {
278         return approve(spender, type(uint256).max);
279     }
280 
281     function transfer(address recipient, uint256 amount) external override returns (bool) {
282         return _transferFrom(msg.sender, recipient, amount);
283     }
284 
285     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
286         if(_allowances[sender][msg.sender] != type(uint256).max){
287             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
288         }
289 
290         return _transferFrom(sender, recipient, amount);
291     }
292 
293         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
294          require(_maxWalletToken >= _totalSupply / 1000); 
295         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
296                 
297     }
298 
299     function setMaxTX(uint256 maxTXPercent) external onlyOwner {
300          require(_maxTxAmount >= _totalSupply / 1000); 
301         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
302     }
303 
304     function nolimits () external onlyOwner {
305             _maxTxAmount = _totalSupply;
306             _maxWalletToken = _totalSupply;
307     }
308       
309     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
310         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
311 
312         if(!authorizations[sender] && !authorizations[recipient]){
313             require(TradingOpen,"Trading not open yet");
314         
315              if(antiBotMode){
316                 require(isantiBoted[recipient],"Not antiBoted"); 
317           }
318         }
319                
320         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
321             uint256 heldTokens = balanceOf(recipient);
322             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
323 
324         
325 
326         // Checks max transaction limit
327         checkTxLimit(sender, amount); 
328 
329         if(shouldSwapBack()){ swapBack(); }
330                     
331          //Exchange tokens
332         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
333 
334         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
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
349         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
350     }
351 
352     function shouldTakeFee(address sender) internal view returns (bool) {
353         return !isFeeexempt[sender];
354     }
355 
356     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
357         
358         uint256 percent = transferpercent;
359 
360         if(recipient == pair) {
361             percent = sellpercent;
362         } else if(sender == pair) {
363             percent = buypercent;
364         }
365 
366         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
367         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
368         uint256 contractTokens = feeAmount.sub(burnTokens);
369 
370         _balances[address(this)] = _balances[address(this)].add(contractTokens);
371         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
372         emit Transfer(sender, address(this), contractTokens);
373         
374         
375         if(burnTokens > 0){
376             _totalSupply = _totalSupply.sub(burnTokens);
377             emit Transfer(sender, ZERO, burnTokens);  
378         
379         }
380 
381         return amount.sub(feeAmount);
382     }
383 
384     function shouldSwapBack() internal view returns (bool) {
385         return msg.sender != pair
386         && !inSwap
387         && swapEnabled
388         && _balances[address(this)] >= swapThreshold;
389     }
390 
391     function removeStuckETH(uint256 amountPercentage) external {
392         uint256 amountETH = address(this).balance;
393         payable(utilityFeeReceiver).transfer(amountETH * amountPercentage / 100);
394     }
395 
396      function swapback() external onlyOwner {
397            swapBack();
398     
399     }
400 
401      function manualSend() external { 
402              payable(autoLiquidityReceiver).transfer(address(this).balance);
403 
404     }
405 
406     function clearERCToken(address tokenAddress, uint256 tokens) public returns (bool) {
407                if(tokens == 0){
408             tokens = ERC20(tokenAddress).balanceOf(address(this));
409         }
410         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
411     }
412 
413     function setTaxAllocation(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
414         sellpercent = _sell;
415         buypercent = _buy;
416         transferpercent = _trans;    
417           
418     }
419 
420      function setMode(bool _status) public onlyOwner {
421         antiBotMode = _status;
422     }
423 
424     function addToMode(address[] calldata addresses, bool status) public onlyOwner {
425         for (uint256 i; i < addresses.length; ++i) {
426             isantiBoted[addresses[i]] = status;
427         }
428     }
429 
430     function enableTrading() public onlyOwner {
431         TradingOpen = true;
432         sellpercent = 1300;
433         buypercent = 700;
434         transferpercent = 0; 
435         
436     }
437     
438     function lower() public onlyOwner {
439         sellpercent = 700;
440         buypercent = 300;
441         transferpercent = 0; 
442         
443     }
444 
445              
446     function swapBack() internal swapping {
447         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
448         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
449         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
450 
451         address[] memory path = new address[](2);
452         path[0] = address(this);
453         path[1] = WETH;
454 
455         uint256 balanceBefore = address(this).balance;
456 
457         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
458             amountToSwap,
459             0,
460             path,
461             address(this),
462             block.timestamp
463         );
464 
465         uint256 amountETH = address(this).balance.sub(balanceBefore);
466 
467         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
468         
469         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
470         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
471         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
472         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
473 
474         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
475         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
476         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
477         
478         tmpSuccess = false;
479 
480         if(amountToLiquify > 0){
481             router.addLiquidityETH{value: amountETHLiquidity}(
482                 address(this),
483                 amountToLiquify,
484                 0,
485                 0,
486                 autoLiquidityReceiver,
487                 block.timestamp
488             );
489             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
490         }
491     }
492 
493     function setInternalAddress(address holder, bool exempt) external onlyOwner {
494         isFeeexempt[holder] = exempt;
495         isTxLimitexempt[holder] = exempt;
496     }
497 
498     
499     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _utilityFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
500         liquidityFee = _liquidityFee;
501         utilityFee = _utilityFee;
502         marketingFee = _marketingFee;
503         devFee = _devFee;
504         burnFee = _burnFee;
505         totalFee = _liquidityFee.add(_utilityFee).add(_marketingFee).add(_devFee).add(_burnFee);
506         feeDenominator = _feeDenominator;
507         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
508     }
509 
510     function updateTaxWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _utilityFeeReceiver) external onlyOwner {
511         autoLiquidityReceiver = _autoLiquidityReceiver;
512         marketingFeeReceiver = _marketingFeeReceiver;
513         devFeeReceiver = _devFeeReceiver;
514         burnFeeReceiver = _burnFeeReceiver;
515         utilityFeeReceiver = _utilityFeeReceiver;
516     }
517 
518     function setNumTokensToSell(bool _enabled, uint256 _amount) external onlyOwner {
519         swapEnabled = _enabled;
520         swapThreshold = _amount;
521     }
522 
523     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
524         targetLiquidity = _target;
525         targetLiquidityDenominator = _denominator;
526     }
527     
528     function getCirculatingSupply() public view returns (uint256) {
529         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
530     }
531 
532     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
533         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
534     }
535 
536     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
537         return getLiquidityBacking(accuracy) > target;
538     }
539 
540 
541 
542 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
543 event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
544 event user_FeeExempt(address Wallet, bool Exempt);
545 event user_TxExempt(address Wallet, bool Exempt);
546 event ClearStuck(uint256 amount);
547 event ClearToken(address TokenAddressCleared, uint256 Amount);
548 event set_Receivers(address marketingFeeReceiver, address teamFeeReceiver,address stakingFeeReceiver,address devFeeReceiver);
549 event set_MaxWallet(uint256 maxWallet);
550 event set_MaxTX(uint256 maxTX);
551 event set_SwapBack(uint256 Amount, bool Enabled);
552 
553 }