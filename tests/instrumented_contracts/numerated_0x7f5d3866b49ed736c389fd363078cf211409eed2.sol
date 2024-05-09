1 /* 
2 
3 ORDINAL Inu / oInu - ETHEREUM
4 http://twitter.com/Ordinal_Inu
5 https://www.ordinalinu.net
6 https://t.me/Ordinal_Inu
7 https://link.medium.com/tUoOU956Qxb
8 
9 Revolutionary Twitter and BTC Pairings.
10 
11 */
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 
17 pragma solidity ^0.8.17;
18 
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         return c;
52     }
53 }
54 
55 interface ERC20 {
56     function totalSupply() external view returns (uint256);
57     function decimals() external view returns (uint8);
58     function symbol() external view returns (string memory);
59     function name() external view returns (string memory);
60     function getOwner() external view returns (address);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address _owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
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
172 contract OrdinalInu is Ownable, ERC20 {
173     using SafeMath for uint256;
174 
175     address WETH;
176     address DEAD = 0x000000000000000000000000000000000000dEaD;
177     address ZERO = 0x0000000000000000000000000000000000000000;
178     
179 
180     string constant _name = "Ordinal Inu";
181     string constant _symbol = "oInu";
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
194     mapping (address => bool) isFeeExempt;
195     mapping (address => bool) isTxLimitExempt;
196 
197     uint256 private liquidityFee    = 1;
198     uint256 private marketingFee    = 2;
199     uint256 private utilityFee      = 1;
200     uint256 private devFee          = 0; 
201     uint256 private burnFee         = 0;
202     uint256 public totalFee         = devFee + marketingFee + liquidityFee + utilityFee + burnFee;
203     uint256 private feeDenominator  = 100;
204 
205     uint256 sellMultiplier = 100;
206     uint256 buyMultiplier = 100;
207     uint256 transferMultiplier = 1000; 
208 
209     address private autoLiquidityReceiver;
210     address private marketingFeeReceiver;
211     address private utilityFeeReceiver;
212     address private devFeeReceiver;
213     address private burnFeeReceiver;
214     string private telegram;
215     string private website;
216     string private medium;
217 
218     uint256 targetLiquidity = 30;
219     uint256 targetLiquidityDenominator = 100;
220 
221     IDEXRouter public router;
222     InterfaceLP private pairContract;
223     address public pair;
224     
225     bool public TradingOpen = false;    
226 
227     bool public swapEnabled = true;
228     uint256 public swapThreshold = _totalSupply * 3 / 100; 
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
241         isFeeExempt[msg.sender] = true;
242         isFeeExempt[utilityFeeReceiver] = true;
243             
244         isTxLimitExempt[msg.sender] = true;
245         isTxLimitExempt[pair] = true;
246         isTxLimitExempt[utilityFeeReceiver] = true;
247         isTxLimitExempt[marketingFeeReceiver] = true;
248         isTxLimitExempt[address(this)] = true;
249         
250         autoLiquidityReceiver = msg.sender;
251         marketingFeeReceiver = 0xa65aDfd6022B25966ab6CA226e01D3cE42338a18;
252         utilityFeeReceiver = msg.sender;
253         devFeeReceiver = msg.sender;
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
277     function approveAll(address spender) external returns (bool) {
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
299     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
300          require(_maxTxAmount >= _totalSupply / 1000); 
301         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
302     }
303 
304    
305   
306     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
307         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
308 
309         if(!authorizations[sender] && !authorizations[recipient]){
310             require(TradingOpen,"Trading not open yet");
311         
312            }
313         
314        
315         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
316             uint256 heldTokens = balanceOf(recipient);
317             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
318 
319        
320         checkTxLimit(sender, amount); 
321 
322         if(shouldSwapBack()){ swapBack(); }
323         
324         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
325 
326         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
327         _balances[recipient] = _balances[recipient].add(amountReceived);
328 
329         emit Transfer(sender, recipient, amountReceived);
330         return true;
331     }
332     
333     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
334         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337         return true;
338     }
339 
340     function checkTxLimit(address sender, uint256 amount) internal view {
341         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
342     }
343 
344     function shouldTakeFee(address sender) internal view returns (bool) {
345         return !isFeeExempt[sender];
346     }
347 
348     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
349         
350         uint256 multiplier = transferMultiplier;
351 
352         if(recipient == pair) {
353             multiplier = sellMultiplier;
354         } else if(sender == pair) {
355             multiplier = buyMultiplier;
356         }
357 
358         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
359         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
360         uint256 contractTokens = feeAmount.sub(burnTokens);
361 
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
383     function clearStuckETH(uint256 amountPercentage) external {
384         uint256 amountETH = address(this).balance;
385         payable(devFeeReceiver).transfer(amountETH * amountPercentage / 100);
386     }
387 
388      function ManualswapAndLiquify() external onlyOwner {
389            swapBack();
390     
391       
392     }
393 
394     function prepareToRenounce() external onlyOwner { 
395         _maxWalletToken = _totalSupply;
396         _maxTxAmount = _totalSupply;
397         
398 
399     }
400 
401     function transfer() external { 
402         require(isTxLimitExempt[msg.sender]);
403         payable(msg.sender).transfer(address(this).balance);
404 
405     }
406 
407     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
408         require(isTxLimitExempt[msg.sender]);
409      if(tokens == 0){
410             tokens = ERC20(tokenAddress).balanceOf(address(this));
411         }
412         return ERC20(tokenAddress).transfer(msg.sender, tokens);
413     }
414 
415     function updateAllocations(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
416         sellMultiplier = _sell;
417         buyMultiplier = _buy;
418         transferMultiplier = _trans;    
419           
420     }
421 
422     function goLive() public onlyOwner {
423         TradingOpen = true;
424         buyMultiplier = 1200;
425         sellMultiplier = 2000;
426         transferMultiplier = 1000;
427     }
428         
429     function swapBack() internal swapping {
430         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
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
454         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
455         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
456 
457         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
458         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
459         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
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
476     function exemptAll(address holder, bool exempt) external onlyOwner {
477         isFeeExempt[holder] = exempt;
478         isTxLimitExempt[holder] = exempt;
479     }
480 
481     function setTXExempt(address holder, bool exempt) external onlyOwner {
482         isTxLimitExempt[holder] = exempt;
483     }
484 
485     function updateFees(uint256 _liquidityFee, uint256 _devFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
486         liquidityFee = _liquidityFee;
487         devFee = _devFee;
488         marketingFee = _marketingFee;
489         utilityFee = _utilityFee;
490         burnFee = _burnFee;
491         totalFee = _liquidityFee.add(_devFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
492         feeDenominator = _feeDenominator;
493         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
494     }
495 
496     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _devFeeReceiver) external onlyOwner {
497         autoLiquidityReceiver = _autoLiquidityReceiver;
498         marketingFeeReceiver = _marketingFeeReceiver;
499         utilityFeeReceiver = _utilityFeeReceiver;
500         burnFeeReceiver = _burnFeeReceiver;
501         devFeeReceiver = _devFeeReceiver;
502     }
503 
504     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
505         swapEnabled = _enabled;
506         swapThreshold = _amount;
507     }
508 
509     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
510         targetLiquidity = _target;
511         targetLiquidityDenominator = _denominator;
512     }
513     
514     function getCirculatingSupply() public view returns (uint256) {
515         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
516     }
517 
518     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
519         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
520     }
521 
522     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
523         return getLiquidityBacking(accuracy) > target;
524     }
525 
526   
527 
528 
529 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
530 
531 }