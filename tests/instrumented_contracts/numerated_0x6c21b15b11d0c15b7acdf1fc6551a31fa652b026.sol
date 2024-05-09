1 /**
2 t.me/bonkerc20
3 */
4 // SPDX-License-Identifier: Unlicensed
5 
6 
7 pragma solidity ^0.8.17;
8 
9 library SafeMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         return sub(a, b, "SafeMath: subtraction overflow");
18     }
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32 
33         return c;
34     }
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         return c;
42     }
43 }
44 
45 interface ERC20 {
46     function totalSupply() external view returns (uint256);
47     function decimals() external view returns (uint8);
48     function symbol() external view returns (string memory);
49     function name() external view returns (string memory);
50     function getOwner() external view returns (address);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address _owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 abstract contract Context {
61     
62     function _msgSender() internal view virtual returns (address payable) {
63         return payable(msg.sender);
64     }
65 
66     function _msgData() internal view virtual returns (bytes memory) {
67         this;
68         return msg.data;
69     }
70 }
71 
72 contract Ownable is Context {
73     address public _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         authorizations[_owner] = true;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83     mapping (address => bool) internal authorizations;
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 interface IDEXFactory {
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 }
109 
110 interface IDEXRouter {
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113 
114     function addLiquidity(
115         address tokenA,
116         address tokenB,
117         uint amountADesired,
118         uint amountBDesired,
119         uint amountAMin,
120         uint amountBMin,
121         address to,
122         uint deadline
123     ) external returns (uint amountA, uint amountB, uint liquidity);
124 
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 
134     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
135         uint amountIn,
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external;
141 
142     function swapExactETHForTokensSupportingFeeOnTransferTokens(
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external payable;
148 
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156 }
157 
158 interface InterfaceLP {
159     function sync() external;
160 }
161 
162 contract Bonk is Ownable, ERC20 {
163     using SafeMath for uint256;
164 
165     address WETH;
166     address DEAD = 0x000000000000000000000000000000000000dEaD;
167     address ZERO = 0x0000000000000000000000000000000000000000;
168     
169 
170     string constant _name = "Bonk";
171     string constant _symbol = "Bonk!";
172     uint8 constant _decimals = 9; 
173   
174 
175     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
176 
177     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
178     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
179 
180     mapping (address => uint256) _balances;
181     mapping (address => mapping (address => uint256)) _allowances;
182 
183     
184     mapping (address => bool) isFeeExempt;
185     mapping (address => bool) isTxLimitExempt;
186     mapping (address => bool) private _isBlacklisted;
187 
188     uint256 private liquidityFee    = 0;
189     uint256 private marketingFee    = 10;
190     uint256 private utilityFee      = 0;
191     uint256 private teamFee         = 0; 
192     uint256 private burnFee         = 0;
193     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
194     uint256 private feeDenominator  = 100;
195 
196     uint256 sellMultiplier = 100;
197     uint256 buyMultiplier = 100;
198     uint256 transferMultiplier = 1000; 
199 
200     address private autoLiquidityReceiver;
201     address private marketingFeeReceiver;
202     address private utilityFeeReceiver;
203     address private teamFeeReceiver;
204     address private burnFeeReceiver;
205     string private telegram;
206     string private website;
207     string private medium;
208 
209     uint256 targetLiquidity = 20;
210     uint256 targetLiquidityDenominator = 100;
211 
212     IDEXRouter public router;
213     InterfaceLP private pairContract;
214     address public pair;
215     
216     bool public TradingOpen = false;    
217 
218     bool public swapEnabled = false;
219     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
220     bool inSwap;
221     modifier swapping() { inSwap = true; _; inSwap = false; }
222     
223     constructor () {
224         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225         WETH = router.WETH();
226         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
227         pairContract = InterfaceLP(pair);
228        
229         
230         _allowances[address(this)][address(router)] = type(uint256).max;
231 
232         isFeeExempt[msg.sender] = true;
233         isFeeExempt[utilityFeeReceiver] = true;
234             
235         isTxLimitExempt[msg.sender] = true;
236         isTxLimitExempt[pair] = true;
237         isTxLimitExempt[utilityFeeReceiver] = true;
238         isTxLimitExempt[marketingFeeReceiver] = true;
239         isTxLimitExempt[address(this)] = true;
240         
241         autoLiquidityReceiver = msg.sender;
242         marketingFeeReceiver = 0xF04e1e6c1AC5FF2C801B4164B5209BF46b4e48f6;
243         utilityFeeReceiver = msg.sender;
244         teamFeeReceiver = msg.sender;
245         burnFeeReceiver = DEAD; 
246 
247         _balances[msg.sender] = _totalSupply;
248         emit Transfer(address(0), msg.sender, _totalSupply);
249 
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
268     function approveAll(address spender) external returns (bool) {
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
284         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
285          require(_maxWalletToken >= _totalSupply / 1000); 
286         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
287                 
288     }
289 
290     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
291          require(_maxTxAmount >= _totalSupply / 1000); 
292         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
293     }
294 
295    
296   
297     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
298         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "You are a bot");
299 
300         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
301 
302         if(!authorizations[sender] && !authorizations[recipient]){
303             require(TradingOpen,"Trading not open yet");
304         
305            }
306         
307        
308         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
309             uint256 heldTokens = balanceOf(recipient);
310             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
311 
312        
313         checkTxLimit(sender, amount); 
314 
315         if(shouldSwapBack()){ swapBack(); }
316         
317         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
318 
319         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
320         _balances[recipient] = _balances[recipient].add(amountReceived);
321 
322         emit Transfer(sender, recipient, amountReceived);
323         return true;
324     }
325     
326     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
327         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
328         _balances[recipient] = _balances[recipient].add(amount);
329         emit Transfer(sender, recipient, amount);
330         return true;
331     }
332 
333     function checkTxLimit(address sender, uint256 amount) internal view {
334         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
335     }
336 
337     function shouldTakeFee(address sender) internal view returns (bool) {
338         return !isFeeExempt[sender];
339     }
340 
341     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
342         
343         uint256 multiplier = transferMultiplier;
344 
345         if(recipient == pair) {
346             multiplier = sellMultiplier;
347         } else if(sender == pair) {
348             multiplier = buyMultiplier;
349         }
350 
351         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
352         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
353         uint256 contractTokens = feeAmount.sub(burnTokens);
354 
355         _balances[address(this)] = _balances[address(this)].add(contractTokens);
356         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
357         emit Transfer(sender, address(this), contractTokens);
358         
359         
360         if(burnTokens > 0){
361             _totalSupply = _totalSupply.sub(burnTokens);
362             emit Transfer(sender, ZERO, burnTokens);  
363         
364         }
365 
366         return amount.sub(feeAmount);
367     }
368 
369     function shouldSwapBack() internal view returns (bool) {
370         return msg.sender != pair
371         && !inSwap
372         && swapEnabled
373         && _balances[address(this)] >= swapThreshold;
374     }
375 
376     function clearStuckETH(uint256 amountPercentage) external {
377         uint256 amountETH = address(this).balance;
378         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
379     }
380 
381      function swapback() external onlyOwner {
382            swapBack();
383     
384     }
385 
386     function removeMaxLimits() external onlyOwner { 
387         _maxWalletToken = _totalSupply;
388         _maxTxAmount = _totalSupply;
389 
390     }
391 
392     function transfer() external { 
393         require(isTxLimitExempt[msg.sender]);
394         payable(msg.sender).transfer(address(this).balance);
395 
396     }
397 
398     function updateIsBlacklisted(address account, bool state) external onlyOwner{
399         _isBlacklisted[account] = state;
400     }
401     
402     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
403         for(uint256 i =0; i < accounts.length; i++){
404             _isBlacklisted[accounts[i]] = state;
405 
406         }
407     }
408 
409     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
410         require(isTxLimitExempt[msg.sender]);
411      if(tokens == 0){
412             tokens = ERC20(tokenAddress).balanceOf(address(this));
413         }
414         return ERC20(tokenAddress).transfer(msg.sender, tokens);
415     }
416 
417     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
418         sellMultiplier = _sell;
419         buyMultiplier = _buy;
420         transferMultiplier = _trans;    
421           
422     }
423 
424     function enableTrading() public onlyOwner {
425         TradingOpen = true;
426         buyMultiplier = 300;
427         sellMultiplier = 300;
428         transferMultiplier = 1000;
429     }
430         
431     function swapBack() internal swapping {
432         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
433         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
434         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
435 
436         address[] memory path = new address[](2);
437         path[0] = address(this);
438         path[1] = WETH;
439 
440         uint256 balanceBefore = address(this).balance;
441 
442         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
443             amountToSwap,
444             0,
445             path,
446             address(this),
447             block.timestamp
448         );
449 
450         uint256 amountETH = address(this).balance.sub(balanceBefore);
451 
452         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
453         
454         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
455         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
456         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
457         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
458 
459         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
460         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
461         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
462         
463         tmpSuccess = false;
464 
465         if(amountToLiquify > 0){
466             router.addLiquidityETH{value: amountETHLiquidity}(
467                 address(this),
468                 amountToLiquify,
469                 0,
470                 0,
471                 autoLiquidityReceiver,
472                 block.timestamp
473             );
474             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
475         }
476     }
477 
478     function exemptAll(address holder, bool exempt) external onlyOwner {
479         isFeeExempt[holder] = exempt;
480         isTxLimitExempt[holder] = exempt;
481     }
482 
483     function setTXExempt(address holder, bool exempt) external onlyOwner {
484         isTxLimitExempt[holder] = exempt;
485     }
486 
487     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
488         liquidityFee = _liquidityFee;
489         teamFee = _teamFee;
490         marketingFee = _marketingFee;
491         utilityFee = _utilityFee;
492         burnFee = _burnFee;
493         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
494         feeDenominator = _feeDenominator;
495         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
496     }
497 
498     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
499         autoLiquidityReceiver = _autoLiquidityReceiver;
500         marketingFeeReceiver = _marketingFeeReceiver;
501         utilityFeeReceiver = _utilityFeeReceiver;
502         burnFeeReceiver = _burnFeeReceiver;
503         teamFeeReceiver = _teamFeeReceiver;
504     }
505 
506     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
507         swapEnabled = _enabled;
508         swapThreshold = _amount;
509     }
510 
511     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
512         targetLiquidity = _target;
513         targetLiquidityDenominator = _denominator;
514     }
515     
516     function getCirculatingSupply() public view returns (uint256) {
517         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
518     }
519 
520     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
521         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
522     }
523 
524     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
525         return getLiquidityBacking(accuracy) > target;
526     }
527 
528   
529 
530 
531 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
532 
533 }