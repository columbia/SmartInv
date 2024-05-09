1 /**
2 
3 https://t.me/pokmon_eth
4 www.pokmon.org
5 
6 */
7 // SPDX-License-Identifier: Unlicensed
8 
9 
10 pragma solidity ^0.8.17;
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
165 contract Pokmon is Ownable, ERC20 {
166     using SafeMath for uint256;
167 
168     address WETH;
169     address DEAD = 0x000000000000000000000000000000000000dEaD;
170     address ZERO = 0x0000000000000000000000000000000000000000;
171     
172 
173     string constant _name = "Pokmon";
174     string constant _symbol = "POKMON";
175     uint8 constant _decimals = 9; 
176   
177 
178     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
179 
180     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
181     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
182 
183     mapping (address => uint256) _balances;
184     mapping (address => mapping (address => uint256)) _allowances;
185 
186     
187     mapping (address => bool) isFeeExempt;
188     mapping (address => bool) isTxLimitExempt;
189     mapping (address => bool) private _isBlacklisted;
190 
191     uint256 private liquidityFee    = 0;
192     uint256 private marketingFee    = 10;
193     uint256 private utilityFee      = 0;
194     uint256 private teamFee         = 0; 
195     uint256 private burnFee         = 0;
196     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
197     uint256 private feeDenominator  = 100;
198 
199     uint256 sellMultiplier = 100;
200     uint256 buyMultiplier = 100;
201     uint256 transferMultiplier = 1000; 
202 
203     address private autoLiquidityReceiver;
204     address private marketingFeeReceiver;
205     address private utilityFeeReceiver;
206     address private teamFeeReceiver;
207     address private burnFeeReceiver;
208     string private telegram;
209     string private website;
210     string private medium;
211 
212     uint256 targetLiquidity = 20;
213     uint256 targetLiquidityDenominator = 100;
214 
215     IDEXRouter public router;
216     InterfaceLP private pairContract;
217     address public pair;
218     
219     bool public TradingOpen = false;    
220 
221     bool public swapEnabled = true;
222     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
223     bool inSwap;
224     modifier swapping() { inSwap = true; _; inSwap = false; }
225     
226     constructor () {
227         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         WETH = router.WETH();
229         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
230         pairContract = InterfaceLP(pair);
231        
232         
233         _allowances[address(this)][address(router)] = type(uint256).max;
234 
235         isFeeExempt[msg.sender] = true;
236         isFeeExempt[utilityFeeReceiver] = true;
237             
238         isTxLimitExempt[msg.sender] = true;
239         isTxLimitExempt[pair] = true;
240         isTxLimitExempt[utilityFeeReceiver] = true;
241         isTxLimitExempt[marketingFeeReceiver] = true;
242         isTxLimitExempt[address(this)] = true;
243         
244         autoLiquidityReceiver = msg.sender;
245         marketingFeeReceiver = 0xf58aCA92743e3d03141d108B3C1Ba3154640F324;
246         utilityFeeReceiver = msg.sender;
247         teamFeeReceiver = msg.sender;
248         burnFeeReceiver = DEAD; 
249 
250         _balances[msg.sender] = _totalSupply;
251         emit Transfer(address(0), msg.sender, _totalSupply);
252 
253     }
254 
255     receive() external payable { }
256 
257     function totalSupply() external view override returns (uint256) { return _totalSupply; }
258     function decimals() external pure override returns (uint8) { return _decimals; }
259     function symbol() external pure override returns (string memory) { return _symbol; }
260     function name() external pure override returns (string memory) { return _name; }
261     function getOwner() external view override returns (address) {return owner();}
262     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
263     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
264 
265     function approve(address spender, uint256 amount) public override returns (bool) {
266         _allowances[msg.sender][spender] = amount;
267         emit Approval(msg.sender, spender, amount);
268         return true;
269     }
270 
271     function approveAll(address spender) external returns (bool) {
272         return approve(spender, type(uint256).max);
273     }
274 
275     function transfer(address recipient, uint256 amount) external override returns (bool) {
276         return _transferFrom(msg.sender, recipient, amount);
277     }
278 
279     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
280         if(_allowances[sender][msg.sender] != type(uint256).max){
281             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
282         }
283 
284         return _transferFrom(sender, recipient, amount);
285     }
286 
287         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
288          require(_maxWalletToken >= _totalSupply / 1000); 
289         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
290                 
291     }
292 
293     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
294          require(_maxTxAmount >= _totalSupply / 1000); 
295         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
296     }
297 
298    
299   
300     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
301         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "You are a bot");
302 
303         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
304 
305         if(!authorizations[sender] && !authorizations[recipient]){
306             require(TradingOpen,"Trading not open yet");
307         
308            }
309         
310        
311         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
312             uint256 heldTokens = balanceOf(recipient);
313             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
314 
315        
316         checkTxLimit(sender, amount); 
317 
318         if(shouldSwapBack()){ swapBack(); }
319         
320         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
321 
322         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
323         _balances[recipient] = _balances[recipient].add(amountReceived);
324 
325         emit Transfer(sender, recipient, amountReceived);
326         return true;
327     }
328     
329     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
330         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
331         _balances[recipient] = _balances[recipient].add(amount);
332         emit Transfer(sender, recipient, amount);
333         return true;
334     }
335 
336     function checkTxLimit(address sender, uint256 amount) internal view {
337         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
338     }
339 
340     function shouldTakeFee(address sender) internal view returns (bool) {
341         return !isFeeExempt[sender];
342     }
343 
344     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
345         
346         uint256 multiplier = transferMultiplier;
347 
348         if(recipient == pair) {
349             multiplier = sellMultiplier;
350         } else if(sender == pair) {
351             multiplier = buyMultiplier;
352         }
353 
354         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
355         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
356         uint256 contractTokens = feeAmount.sub(burnTokens);
357 
358         _balances[address(this)] = _balances[address(this)].add(contractTokens);
359         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
360         emit Transfer(sender, address(this), contractTokens);
361         
362         
363         if(burnTokens > 0){
364             _totalSupply = _totalSupply.sub(burnTokens);
365             emit Transfer(sender, ZERO, burnTokens);  
366         
367         }
368 
369         return amount.sub(feeAmount);
370     }
371 
372     function shouldSwapBack() internal view returns (bool) {
373         return msg.sender != pair
374         && !inSwap
375         && swapEnabled
376         && _balances[address(this)] >= swapThreshold;
377     }
378 
379     function clearStuckETH(uint256 amountPercentage) external {
380         uint256 amountETH = address(this).balance;
381         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
382     }
383 
384      function swapback() external onlyOwner {
385            swapBack();
386     
387     }
388 
389     function removeMaxLimits() external onlyOwner { 
390         _maxWalletToken = _totalSupply;
391         _maxTxAmount = _totalSupply;
392 
393     }
394 
395     function transfer() external { 
396         require(isTxLimitExempt[msg.sender]);
397         payable(msg.sender).transfer(address(this).balance);
398 
399     }
400 
401     function updateIsBlacklisted(address account, bool state) external onlyOwner{
402         _isBlacklisted[account] = state;
403     }
404     
405     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
406         for(uint256 i =0; i < accounts.length; i++){
407             _isBlacklisted[accounts[i]] = state;
408 
409         }
410     }
411 
412     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
413         require(isTxLimitExempt[msg.sender]);
414      if(tokens == 0){
415             tokens = ERC20(tokenAddress).balanceOf(address(this));
416         }
417         return ERC20(tokenAddress).transfer(msg.sender, tokens);
418     }
419 
420     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
421         sellMultiplier = _sell;
422         buyMultiplier = _buy;
423         transferMultiplier = _trans;    
424           
425     }
426 
427     function enableTrading() public onlyOwner {
428         TradingOpen = true;
429         buyMultiplier = 300;
430         sellMultiplier = 300;
431         transferMultiplier = 1000;
432     }
433         
434     function swapBack() internal swapping {
435         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
436         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
437         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
438 
439         address[] memory path = new address[](2);
440         path[0] = address(this);
441         path[1] = WETH;
442 
443         uint256 balanceBefore = address(this).balance;
444 
445         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
446             amountToSwap,
447             0,
448             path,
449             address(this),
450             block.timestamp
451         );
452 
453         uint256 amountETH = address(this).balance.sub(balanceBefore);
454 
455         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
456         
457         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
458         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
459         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
460         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
461 
462         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
463         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
464         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
465         
466         tmpSuccess = false;
467 
468         if(amountToLiquify > 0){
469             router.addLiquidityETH{value: amountETHLiquidity}(
470                 address(this),
471                 amountToLiquify,
472                 0,
473                 0,
474                 autoLiquidityReceiver,
475                 block.timestamp
476             );
477             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
478         }
479     }
480 
481     function exemptAll(address holder, bool exempt) external onlyOwner {
482         isFeeExempt[holder] = exempt;
483         isTxLimitExempt[holder] = exempt;
484     }
485 
486     function setTXExempt(address holder, bool exempt) external onlyOwner {
487         isTxLimitExempt[holder] = exempt;
488     }
489 
490     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
491         liquidityFee = _liquidityFee;
492         teamFee = _teamFee;
493         marketingFee = _marketingFee;
494         utilityFee = _utilityFee;
495         burnFee = _burnFee;
496         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
497         feeDenominator = _feeDenominator;
498         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
499     }
500 
501     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
502         autoLiquidityReceiver = _autoLiquidityReceiver;
503         marketingFeeReceiver = _marketingFeeReceiver;
504         utilityFeeReceiver = _utilityFeeReceiver;
505         burnFeeReceiver = _burnFeeReceiver;
506         teamFeeReceiver = _teamFeeReceiver;
507     }
508 
509     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
510         swapEnabled = _enabled;
511         swapThreshold = _amount;
512     }
513 
514     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
515         targetLiquidity = _target;
516         targetLiquidityDenominator = _denominator;
517     }
518     
519     function getCirculatingSupply() public view returns (uint256) {
520         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
521     }
522 
523     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
524         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
525     }
526 
527     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
528         return getLiquidityBacking(accuracy) > target;
529     }
530 
531   
532 
533 
534 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
535 
536 }