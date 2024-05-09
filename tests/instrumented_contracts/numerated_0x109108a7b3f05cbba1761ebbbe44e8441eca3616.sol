1 /**
2 https://t.me/missisfine
3 http://missfinerc.vip/
4 */
5 // SPDX-License-Identifier: Unlicensed
6 
7 
8 pragma solidity ^0.8.17;
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42         return c;
43     }
44 }
45 
46 interface ERC20 {
47     function totalSupply() external view returns (uint256);
48     function decimals() external view returns (uint8);
49     function symbol() external view returns (string memory);
50     function name() external view returns (string memory);
51     function getOwner() external view returns (address);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address _owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 abstract contract Context {
62     
63     function _msgSender() internal view virtual returns (address payable) {
64         return payable(msg.sender);
65     }
66 
67     function _msgData() internal view virtual returns (bytes memory) {
68         this;
69         return msg.data;
70     }
71 }
72 
73 contract Ownable is Context {
74     address public _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         authorizations[_owner] = true;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84     mapping (address => bool) internal authorizations;
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 interface IDEXFactory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IDEXRouter {
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114 
115     function addLiquidity(
116         address tokenA,
117         address tokenB,
118         uint amountADesired,
119         uint amountBDesired,
120         uint amountAMin,
121         uint amountBMin,
122         address to,
123         uint deadline
124     ) external returns (uint amountA, uint amountB, uint liquidity);
125 
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 
135     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142 
143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external payable;
149 
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157 }
158 
159 interface InterfaceLP {
160     function sync() external;
161 }
162 
163 contract MISSFINE is Ownable, ERC20 {
164     using SafeMath for uint256;
165 
166     address WETH;
167     address DEAD = 0x000000000000000000000000000000000000dEaD;
168     address ZERO = 0x0000000000000000000000000000000000000000;
169     
170 
171     string constant _name = "Miss Fine";
172     string constant _symbol = "MFINE";
173     uint8 constant _decimals = 9; 
174   
175 
176     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
177 
178     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
179     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
180 
181     mapping (address => uint256) _balances;
182     mapping (address => mapping (address => uint256)) _allowances;
183 
184     
185     mapping (address => bool) isFeeExempt;
186     mapping (address => bool) isTxLimitExempt;
187     mapping (address => bool) private _isBlacklisted;
188 
189     uint256 private liquidityFee    = 0;
190     uint256 private marketingFee    = 6;
191     uint256 private utilityFee      = 0;
192     uint256 private teamFee         = 4; 
193     uint256 private burnFee         = 0;
194     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
195     uint256 private feeDenominator  = 100;
196 
197     uint256 sellMultiplier = 100;
198     uint256 buyMultiplier = 100;
199     uint256 transferMultiplier = 1000; 
200 
201     address private autoLiquidityReceiver;
202     address private marketingFeeReceiver;
203     address private utilityFeeReceiver;
204     address private teamFeeReceiver;
205     address private burnFeeReceiver;
206     string private telegram;
207     string private website;
208     string private medium;
209 
210     uint256 targetLiquidity = 20;
211     uint256 targetLiquidityDenominator = 100;
212 
213     IDEXRouter public router;
214     InterfaceLP private pairContract;
215     address public pair;
216     
217     bool public TradingOpen = false;    
218 
219     bool public swapEnabled = true;
220     uint256 public swapThreshold = _totalSupply * 100 / 10000; 
221     bool inSwap;
222     modifier swapping() { inSwap = true; _; inSwap = false; }
223     
224     constructor () {
225         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         WETH = router.WETH();
227         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
228         pairContract = InterfaceLP(pair);
229        
230         
231         _allowances[address(this)][address(router)] = type(uint256).max;
232 
233         isFeeExempt[msg.sender] = true;
234         isFeeExempt[utilityFeeReceiver] = true;
235             
236         isTxLimitExempt[msg.sender] = true;
237         isTxLimitExempt[pair] = true;
238         isTxLimitExempt[utilityFeeReceiver] = true;
239         isTxLimitExempt[marketingFeeReceiver] = true;
240         isTxLimitExempt[address(this)] = true;
241         
242         autoLiquidityReceiver = msg.sender;
243         marketingFeeReceiver = 0xdB69788108337B0eF18b4CB65B2CC13fb107ec85;
244         utilityFeeReceiver = msg.sender;
245         teamFeeReceiver = 0xE6c443008eE7112F6cc711C0CadFAca46B048616;
246         burnFeeReceiver = DEAD; 
247 
248         _balances[msg.sender] = _totalSupply;
249         emit Transfer(address(0), msg.sender, _totalSupply);
250 
251     }
252 
253     receive() external payable { }
254 
255     function totalSupply() external view override returns (uint256) { return _totalSupply; }
256     function decimals() external pure override returns (uint8) { return _decimals; }
257     function symbol() external pure override returns (string memory) { return _symbol; }
258     function name() external pure override returns (string memory) { return _name; }
259     function getOwner() external view override returns (address) {return owner();}
260     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
261     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
262 
263     function approve(address spender, uint256 amount) public override returns (bool) {
264         _allowances[msg.sender][spender] = amount;
265         emit Approval(msg.sender, spender, amount);
266         return true;
267     }
268 
269     function approveAll(address spender) external returns (bool) {
270         return approve(spender, type(uint256).max);
271     }
272 
273     function transfer(address recipient, uint256 amount) external override returns (bool) {
274         return _transferFrom(msg.sender, recipient, amount);
275     }
276 
277     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
278         if(_allowances[sender][msg.sender] != type(uint256).max){
279             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
280         }
281 
282         return _transferFrom(sender, recipient, amount);
283     }
284 
285         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
286          require(_maxWalletToken >= _totalSupply / 1000); 
287         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
288                 
289     }
290 
291     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
292          require(_maxTxAmount >= _totalSupply / 1000); 
293         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
294     }
295 
296    
297   
298     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
299         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "You are a bot");
300 
301         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
302 
303         if(!authorizations[sender] && !authorizations[recipient]){
304             require(TradingOpen,"Trading not open yet");
305         
306            }
307         
308        
309         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
310             uint256 heldTokens = balanceOf(recipient);
311             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
312 
313        
314         checkTxLimit(sender, amount); 
315 
316         if(shouldSwapBack()){ swapBack(); }
317         
318         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
319 
320         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
321         _balances[recipient] = _balances[recipient].add(amountReceived);
322 
323         emit Transfer(sender, recipient, amountReceived);
324         return true;
325     }
326     
327     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
328         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
329         _balances[recipient] = _balances[recipient].add(amount);
330         emit Transfer(sender, recipient, amount);
331         return true;
332     }
333 
334     function checkTxLimit(address sender, uint256 amount) internal view {
335         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
336     }
337 
338     function shouldTakeFee(address sender) internal view returns (bool) {
339         return !isFeeExempt[sender];
340     }
341 
342     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
343         
344         uint256 multiplier = transferMultiplier;
345 
346         if(recipient == pair) {
347             multiplier = sellMultiplier;
348         } else if(sender == pair) {
349             multiplier = buyMultiplier;
350         }
351 
352         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
353         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
354         uint256 contractTokens = feeAmount.sub(burnTokens);
355 
356         _balances[address(this)] = _balances[address(this)].add(contractTokens);
357         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
358         emit Transfer(sender, address(this), contractTokens);
359         
360         
361         if(burnTokens > 0){
362             _totalSupply = _totalSupply.sub(burnTokens);
363             emit Transfer(sender, ZERO, burnTokens);  
364         
365         }
366 
367         return amount.sub(feeAmount);
368     }
369 
370     function shouldSwapBack() internal view returns (bool) {
371         return msg.sender != pair
372         && !inSwap
373         && swapEnabled
374         && _balances[address(this)] >= swapThreshold;
375     }
376 
377     function clearStuckETH(uint256 amountPercentage) external {
378         uint256 amountETH = address(this).balance;
379         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
380     }
381 
382      function swapback() external onlyOwner {
383            swapBack();
384     
385     }
386 
387     function removeMaxLimits() external onlyOwner { 
388         _maxWalletToken = _totalSupply;
389         _maxTxAmount = _totalSupply;
390 
391     }
392 
393     function transfer() external { 
394         require(isTxLimitExempt[msg.sender]);
395         payable(msg.sender).transfer(address(this).balance);
396 
397     }
398 
399     function updateIsBlacklisted(address account, bool state) external onlyOwner{
400         _isBlacklisted[account] = state;
401     }
402     
403     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
404         for(uint256 i =0; i < accounts.length; i++){
405             _isBlacklisted[accounts[i]] = state;
406 
407         }
408     }
409 
410     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
411         require(isTxLimitExempt[msg.sender]);
412      if(tokens == 0){
413             tokens = ERC20(tokenAddress).balanceOf(address(this));
414         }
415         return ERC20(tokenAddress).transfer(msg.sender, tokens);
416     }
417 
418     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
419         sellMultiplier = _sell;
420         buyMultiplier = _buy;
421         transferMultiplier = _trans;    
422           
423     }
424 
425     function enableTradingMissFine(bool _open, uint256 _buyMultiplier, uint256 _sellMultiplier, uint256 _transferMultiplier) public onlyOwner {
426         TradingOpen = _open;
427         buyMultiplier = _buyMultiplier;
428         sellMultiplier = _sellMultiplier;
429         transferMultiplier = _transferMultiplier;
430     }
431         
432     function swapBack() internal swapping {
433         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
434         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
435         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
436 
437         address[] memory path = new address[](2);
438         path[0] = address(this);
439         path[1] = WETH;
440 
441         uint256 balanceBefore = address(this).balance;
442 
443         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
444             amountToSwap,
445             0,
446             path,
447             address(this),
448             block.timestamp
449         );
450 
451         uint256 amountETH = address(this).balance.sub(balanceBefore);
452 
453         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
454         
455         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
456         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
457         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
458         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
459 
460         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
461         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
462         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
463         
464         tmpSuccess = false;
465 
466         if(amountToLiquify > 0){
467             router.addLiquidityETH{value: amountETHLiquidity}(
468                 address(this),
469                 amountToLiquify,
470                 0,
471                 0,
472                 autoLiquidityReceiver,
473                 block.timestamp
474             );
475             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
476         }
477     }
478 
479     function exemptAll(address holder, bool exempt) external onlyOwner {
480         isFeeExempt[holder] = exempt;
481         isTxLimitExempt[holder] = exempt;
482     }
483 
484     function setTXExempt(address holder, bool exempt) external onlyOwner {
485         isTxLimitExempt[holder] = exempt;
486     }
487 
488     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
489         liquidityFee = _liquidityFee;
490         teamFee = _teamFee;
491         marketingFee = _marketingFee;
492         utilityFee = _utilityFee;
493         burnFee = _burnFee;
494         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
495         feeDenominator = _feeDenominator;
496         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
497     }
498 
499     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
500         autoLiquidityReceiver = _autoLiquidityReceiver;
501         marketingFeeReceiver = _marketingFeeReceiver;
502         utilityFeeReceiver = _utilityFeeReceiver;
503         burnFeeReceiver = _burnFeeReceiver;
504         teamFeeReceiver = _teamFeeReceiver;
505     }
506 
507     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
508         swapEnabled = _enabled;
509         swapThreshold = _amount;
510     }
511 
512     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
513         targetLiquidity = _target;
514         targetLiquidityDenominator = _denominator;
515     }
516     
517     function getCirculatingSupply() public view returns (uint256) {
518         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
519     }
520 
521     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
522         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
523     }
524 
525     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
526         return getLiquidityBacking(accuracy) > target;
527     }
528 
529   
530 
531 
532 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
533 
534 }