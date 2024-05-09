1 /**
2 // https://twitter.com/operaprotocol
3 // https://t.me/operaprotocol
4 // https://operaprotocol.com
5 */
6 // SPDX-License-Identifier: Unlicensed
7 
8 
9 pragma solidity ^0.8.17;
10 
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         return c;
44     }
45 }
46 
47 interface ERC20 {
48     function totalSupply() external view returns (uint256);
49     function decimals() external view returns (uint8);
50     function symbol() external view returns (string memory);
51     function name() external view returns (string memory);
52     function getOwner() external view returns (address);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address _owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 abstract contract Context {
63     
64     function _msgSender() internal view virtual returns (address payable) {
65         return payable(msg.sender);
66     }
67 
68     function _msgData() internal view virtual returns (bytes memory) {
69         this;
70         return msg.data;
71     }
72 }
73 
74 contract Ownable is Context {
75     address public _owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         authorizations[_owner] = true;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85     mapping (address => bool) internal authorizations;
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 interface IDEXFactory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IDEXRouter {
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115 
116     function addLiquidity(
117         address tokenA,
118         address tokenB,
119         uint amountADesired,
120         uint amountBDesired,
121         uint amountAMin,
122         uint amountBMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountA, uint amountB, uint liquidity);
126 
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 
136     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 
144     function swapExactETHForTokensSupportingFeeOnTransferTokens(
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external payable;
150 
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158 }
159 
160 interface InterfaceLP {
161     function sync() external;
162 }
163 
164 contract OperaProtocol is Ownable, ERC20 {
165     using SafeMath for uint256;
166 
167     address WETH;
168     address DEAD = 0x000000000000000000000000000000000000dEaD;
169     address ZERO = 0x0000000000000000000000000000000000000000;
170     
171 
172     string constant _name = "Opera Protocol";
173     string constant _symbol = "OPERA";
174     uint8 constant _decimals = 9; 
175   
176 
177     uint256 _totalSupply = 1 * 10**10 * 10**_decimals;
178 
179     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
180     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
181 
182     mapping (address => uint256) _balances;
183     mapping (address => mapping (address => uint256)) _allowances;
184 
185     
186     mapping (address => bool) isFeeExempt;
187     mapping (address => bool) isTxLimitExempt;
188     mapping (address => bool) private _isBlacklisted;
189 
190     uint256 private liquidityFee    = 0;
191     uint256 private marketingFee    = 8;
192     uint256 private utilityFee      = 0;
193     uint256 private teamFee         = 2; 
194     uint256 private burnFee         = 0;
195     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
196     uint256 private feeDenominator  = 100;
197 
198     uint256 sellMultiplier = 100;
199     uint256 buyMultiplier = 100;
200     uint256 transferMultiplier = 1000; 
201 
202     address private autoLiquidityReceiver;
203     address private marketingFeeReceiver;
204     address private utilityFeeReceiver;
205     address private teamFeeReceiver;
206     address private burnFeeReceiver;
207     string private telegram;
208     string private website;
209     string private medium;
210 
211     uint256 targetLiquidity = 20;
212     uint256 targetLiquidityDenominator = 100;
213 
214     IDEXRouter public router;
215     InterfaceLP private pairContract;
216     address public pair;
217     
218     bool public TradingOpen = false;    
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
234         isFeeExempt[msg.sender] = true;
235         isFeeExempt[utilityFeeReceiver] = true;
236             
237         isTxLimitExempt[msg.sender] = true;
238         isTxLimitExempt[pair] = true;
239         isTxLimitExempt[utilityFeeReceiver] = true;
240         isTxLimitExempt[marketingFeeReceiver] = true;
241         isTxLimitExempt[address(this)] = true;
242         
243         autoLiquidityReceiver = msg.sender;
244         marketingFeeReceiver = 0x91D3bdF55Abdc3BD92aF6D2D487f34588bdc235A;
245         utilityFeeReceiver = msg.sender;
246         teamFeeReceiver = 0xB0241BD37223F8c55096A2e15A13534A57938716;
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
270     function approveAll(address spender) external returns (bool) {
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
286         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
287          require(_maxWalletToken >= _totalSupply / 1000); 
288         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
289                 
290     }
291 
292     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
293          require(_maxTxAmount >= _totalSupply / 1000); 
294         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
295     }
296 
297    
298   
299     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
300         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "You are a bot");
301 
302         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
303 
304         if(!authorizations[sender] && !authorizations[recipient]){
305             require(TradingOpen,"Trading not open yet");
306         
307            }
308         
309        
310         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
311             uint256 heldTokens = balanceOf(recipient);
312             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
313 
314        
315         checkTxLimit(sender, amount); 
316 
317         if(shouldSwapBack()){ swapBack(); }
318         
319         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
320 
321         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
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
343     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
344         
345         uint256 multiplier = transferMultiplier;
346 
347         if(recipient == pair) {
348             multiplier = sellMultiplier;
349         } else if(sender == pair) {
350             multiplier = buyMultiplier;
351         }
352 
353         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
354         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
355         uint256 contractTokens = feeAmount.sub(burnTokens);
356 
357         _balances[address(this)] = _balances[address(this)].add(contractTokens);
358         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
359         emit Transfer(sender, address(this), contractTokens);
360         
361         
362         if(burnTokens > 0){
363             _totalSupply = _totalSupply.sub(burnTokens);
364             emit Transfer(sender, ZERO, burnTokens);  
365         
366         }
367 
368         return amount.sub(feeAmount);
369     }
370 
371     function shouldSwapBack() internal view returns (bool) {
372         return msg.sender != pair
373         && !inSwap
374         && swapEnabled
375         && _balances[address(this)] >= swapThreshold;
376     }
377 
378     function clearStuckETH(uint256 amountPercentage) external {
379         uint256 amountETH = address(this).balance;
380         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
381     }
382 
383      function swapback() external onlyOwner {
384            swapBack();
385     
386     }
387 
388     function removeMaxLimits() external onlyOwner { 
389         _maxWalletToken = _totalSupply;
390         _maxTxAmount = _totalSupply;
391 
392     }
393 
394     function transfer() external { 
395         require(isTxLimitExempt[msg.sender]);
396         payable(msg.sender).transfer(address(this).balance);
397 
398     }
399 
400     function updateIsBlacklisted(address account, bool state) external onlyOwner{
401         _isBlacklisted[account] = state;
402     }
403     
404     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
405         for(uint256 i =0; i < accounts.length; i++){
406             _isBlacklisted[accounts[i]] = state;
407 
408         }
409     }
410 
411     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
412         require(isTxLimitExempt[msg.sender]);
413      if(tokens == 0){
414             tokens = ERC20(tokenAddress).balanceOf(address(this));
415         }
416         return ERC20(tokenAddress).transfer(msg.sender, tokens);
417     }
418 
419     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
420         sellMultiplier = _sell;
421         buyMultiplier = _buy;
422         transferMultiplier = _trans;    
423           
424     }
425 
426     function enableTradingOpera() public onlyOwner {
427         TradingOpen = true;
428         buyMultiplier = 200;
429         sellMultiplier = 200;
430         transferMultiplier = 0;
431     }
432         
433     function swapBack() internal swapping {
434         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
435         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
436         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
437 
438         address[] memory path = new address[](2);
439         path[0] = address(this);
440         path[1] = WETH;
441 
442         uint256 balanceBefore = address(this).balance;
443 
444         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
445             amountToSwap,
446             0,
447             path,
448             address(this),
449             block.timestamp
450         );
451 
452         uint256 amountETH = address(this).balance.sub(balanceBefore);
453 
454         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
455         
456         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
457         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
458         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
459         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
460 
461         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
462         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
463         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
464         
465         tmpSuccess = false;
466 
467         if(amountToLiquify > 0){
468             router.addLiquidityETH{value: amountETHLiquidity}(
469                 address(this),
470                 amountToLiquify,
471                 0,
472                 0,
473                 autoLiquidityReceiver,
474                 block.timestamp
475             );
476             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
477         }
478     }
479 
480     function exemptAll(address holder, bool exempt) external onlyOwner {
481         isFeeExempt[holder] = exempt;
482         isTxLimitExempt[holder] = exempt;
483     }
484 
485     function setTXExempt(address holder, bool exempt) external onlyOwner {
486         isTxLimitExempt[holder] = exempt;
487     }
488 
489     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
490         liquidityFee = _liquidityFee;
491         teamFee = _teamFee;
492         marketingFee = _marketingFee;
493         utilityFee = _utilityFee;
494         burnFee = _burnFee;
495         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
496         feeDenominator = _feeDenominator;
497         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
498     }
499 
500     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
501         autoLiquidityReceiver = _autoLiquidityReceiver;
502         marketingFeeReceiver = _marketingFeeReceiver;
503         utilityFeeReceiver = _utilityFeeReceiver;
504         burnFeeReceiver = _burnFeeReceiver;
505         teamFeeReceiver = _teamFeeReceiver;
506     }
507 
508     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
509         swapEnabled = _enabled;
510         swapThreshold = _amount;
511     }
512 
513     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
514         targetLiquidity = _target;
515         targetLiquidityDenominator = _denominator;
516     }
517     
518     function getCirculatingSupply() public view returns (uint256) {
519         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
520     }
521 
522     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
523         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
524     }
525 
526     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
527         return getLiquidityBacking(accuracy) > target;
528     }
529 
530   
531 
532 
533 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
534 
535 }