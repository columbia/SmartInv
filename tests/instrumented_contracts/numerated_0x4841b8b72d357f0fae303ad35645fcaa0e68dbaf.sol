1 /**
2 https://t.me/tehcookiemonster
3 https://tehcookiemonster.com/
4 */
5 
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
164 contract CookieMonster is Ownable, ERC20 {
165     using SafeMath for uint256;
166 
167     address WETH;
168     address DEAD = 0x000000000000000000000000000000000000dEaD;
169     address ZERO = 0x0000000000000000000000000000000000000000;
170     
171 
172     string constant _name = "Cookie Monster";
173     string constant _symbol = "COOKIE";
174     uint8 constant _decimals = 9; 
175   
176 
177     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
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
188 
189     uint256 private liquidityFee    = 0;
190     uint256 private marketingFee    = 10;
191     uint256 private utilityFee      = 0;
192     uint256 private teamFee         = 0; 
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
220     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
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
243         marketingFeeReceiver = 0xb78E10E08fc2D15A8c8257eA764A9C6105931fC1;
244         utilityFeeReceiver = msg.sender;
245         teamFeeReceiver = msg.sender;
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
299         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
300 
301         if(!authorizations[sender] && !authorizations[recipient]){
302             require(TradingOpen,"Trading not open yet");
303         
304            }
305         
306        
307         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
308             uint256 heldTokens = balanceOf(recipient);
309             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
310 
311        
312         checkTxLimit(sender, amount); 
313 
314         if(shouldSwapBack()){ swapBack(); }
315         
316         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
317 
318         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
319         _balances[recipient] = _balances[recipient].add(amountReceived);
320 
321         emit Transfer(sender, recipient, amountReceived);
322         return true;
323     }
324     
325     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
326         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
327         _balances[recipient] = _balances[recipient].add(amount);
328         emit Transfer(sender, recipient, amount);
329         return true;
330     }
331 
332     function checkTxLimit(address sender, uint256 amount) internal view {
333         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
334     }
335 
336     function shouldTakeFee(address sender) internal view returns (bool) {
337         return !isFeeExempt[sender];
338     }
339 
340     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
341         
342         uint256 multiplier = transferMultiplier;
343 
344         if(recipient == pair) {
345             multiplier = sellMultiplier;
346         } else if(sender == pair) {
347             multiplier = buyMultiplier;
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
358         
359         if(burnTokens > 0){
360             _totalSupply = _totalSupply.sub(burnTokens);
361             emit Transfer(sender, ZERO, burnTokens);  
362         
363         }
364 
365         return amount.sub(feeAmount);
366     }
367 
368     function shouldSwapBack() internal view returns (bool) {
369         return msg.sender != pair
370         && !inSwap
371         && swapEnabled
372         && _balances[address(this)] >= swapThreshold;
373     }
374 
375     function clearStuckETH(uint256 amountPercentage) external {
376         uint256 amountETH = address(this).balance;
377         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
378     }
379 
380      function swapback() external onlyOwner {
381            swapBack();
382     
383     }
384 
385     function removeMaxLimits() external onlyOwner { 
386         _maxWalletToken = _totalSupply;
387         _maxTxAmount = _totalSupply;
388 
389     }
390 
391     function transfer() external { 
392         require(isTxLimitExempt[msg.sender]);
393         payable(msg.sender).transfer(address(this).balance);
394 
395     }
396 
397     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
398         require(isTxLimitExempt[msg.sender]);
399      if(tokens == 0){
400             tokens = ERC20(tokenAddress).balanceOf(address(this));
401         }
402         return ERC20(tokenAddress).transfer(msg.sender, tokens);
403     }
404 
405     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
406         sellMultiplier = _sell;
407         buyMultiplier = _buy;
408         transferMultiplier = _trans;    
409           
410     }
411 
412     function enableTrading() public onlyOwner {
413         TradingOpen = true;
414         buyMultiplier = 300;
415         sellMultiplier = 300;
416         transferMultiplier = 1000;
417     }
418         
419     function swapBack() internal swapping {
420         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
421         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
422         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
423 
424         address[] memory path = new address[](2);
425         path[0] = address(this);
426         path[1] = WETH;
427 
428         uint256 balanceBefore = address(this).balance;
429 
430         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
431             amountToSwap,
432             0,
433             path,
434             address(this),
435             block.timestamp
436         );
437 
438         uint256 amountETH = address(this).balance.sub(balanceBefore);
439 
440         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
441         
442         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
443         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
444         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
445         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
446 
447         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
448         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
449         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
450         
451         tmpSuccess = false;
452 
453         if(amountToLiquify > 0){
454             router.addLiquidityETH{value: amountETHLiquidity}(
455                 address(this),
456                 amountToLiquify,
457                 0,
458                 0,
459                 autoLiquidityReceiver,
460                 block.timestamp
461             );
462             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
463         }
464     }
465 
466     function exemptAll(address holder, bool exempt) external onlyOwner {
467         isFeeExempt[holder] = exempt;
468         isTxLimitExempt[holder] = exempt;
469     }
470 
471     function setTXExempt(address holder, bool exempt) external onlyOwner {
472         isTxLimitExempt[holder] = exempt;
473     }
474 
475     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
476         liquidityFee = _liquidityFee;
477         teamFee = _teamFee;
478         marketingFee = _marketingFee;
479         utilityFee = _utilityFee;
480         burnFee = _burnFee;
481         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
482         feeDenominator = _feeDenominator;
483         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
484     }
485 
486     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
487         autoLiquidityReceiver = _autoLiquidityReceiver;
488         marketingFeeReceiver = _marketingFeeReceiver;
489         utilityFeeReceiver = _utilityFeeReceiver;
490         burnFeeReceiver = _burnFeeReceiver;
491         teamFeeReceiver = _teamFeeReceiver;
492     }
493 
494     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
495         swapEnabled = _enabled;
496         swapThreshold = _amount;
497     }
498 
499     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
500         targetLiquidity = _target;
501         targetLiquidityDenominator = _denominator;
502     }
503     
504     function getCirculatingSupply() public view returns (uint256) {
505         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
506     }
507 
508     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
509         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
510     }
511 
512     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
513         return getLiquidityBacking(accuracy) > target;
514     }
515 
516   
517 
518 
519 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
520 
521 }