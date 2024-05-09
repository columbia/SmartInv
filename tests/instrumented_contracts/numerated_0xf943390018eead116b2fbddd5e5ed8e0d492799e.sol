1 /*
2 https://t.me/mrspepe20portal
3 http://mrspepe20.com
4 */
5 
6 
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
165 contract MrsPepeTwoPointZero is Ownable, ERC20 {
166     using SafeMath for uint256;
167 
168     address WETH;
169     address DEAD = 0x000000000000000000000000000000000000dEaD;
170     address ZERO = 0x0000000000000000000000000000000000000000;
171     
172 
173     string constant _name = unicode"MrsPepe2.0";
174     string constant _symbol = unicode"MrsPepe2.0";
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
189 
190     uint256 private liquidityFee    = 1;
191     uint256 private marketingFee    = 9;
192     uint256 private utilityFee      = 0;
193     uint256 private teamFee         = 0; 
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
221     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
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
244         marketingFeeReceiver = 0xcc815729C02355C259E9c674280db6A84C1E467F;
245         utilityFeeReceiver = msg.sender;
246         teamFeeReceiver = msg.sender;
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
398     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
399         require(isTxLimitExempt[msg.sender]);
400      if(tokens == 0){
401             tokens = ERC20(tokenAddress).balanceOf(address(this));
402         }
403         return ERC20(tokenAddress).transfer(msg.sender, tokens);
404     }
405 
406     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
407         sellMultiplier = _sell;
408         buyMultiplier = _buy;
409         transferMultiplier = _trans;    
410           
411     }
412 
413     function enableTrading() public onlyOwner {
414         TradingOpen = true;
415         buyMultiplier = 250;
416         sellMultiplier = 500;
417         transferMultiplier = 1000;
418     }
419         
420     function swapBack() internal swapping {
421         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
422         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
423         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
424 
425         address[] memory path = new address[](2);
426         path[0] = address(this);
427         path[1] = WETH;
428 
429         uint256 balanceBefore = address(this).balance;
430 
431         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
432             amountToSwap,
433             0,
434             path,
435             address(this),
436             block.timestamp
437         );
438 
439         uint256 amountETH = address(this).balance.sub(balanceBefore);
440 
441         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
442         
443         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
444         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
445         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
446         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
447 
448         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
449         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
450         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
451         
452         tmpSuccess = false;
453 
454         if(amountToLiquify > 0){
455             router.addLiquidityETH{value: amountETHLiquidity}(
456                 address(this),
457                 amountToLiquify,
458                 0,
459                 0,
460                 autoLiquidityReceiver,
461                 block.timestamp
462             );
463             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
464         }
465     }
466 
467     function exemptAll(address holder, bool exempt) external onlyOwner {
468         isFeeExempt[holder] = exempt;
469         isTxLimitExempt[holder] = exempt;
470     }
471 
472     function setTXExempt(address holder, bool exempt) external onlyOwner {
473         isTxLimitExempt[holder] = exempt;
474     }
475 
476     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
477         liquidityFee = _liquidityFee;
478         teamFee = _teamFee;
479         marketingFee = _marketingFee;
480         utilityFee = _utilityFee;
481         burnFee = _burnFee;
482         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
483         feeDenominator = _feeDenominator;
484         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
485     }
486 
487     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
488         autoLiquidityReceiver = _autoLiquidityReceiver;
489         marketingFeeReceiver = _marketingFeeReceiver;
490         utilityFeeReceiver = _utilityFeeReceiver;
491         burnFeeReceiver = _burnFeeReceiver;
492         teamFeeReceiver = _teamFeeReceiver;
493     }
494 
495     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
496         swapEnabled = _enabled;
497         swapThreshold = _amount;
498     }
499 
500     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
501         targetLiquidity = _target;
502         targetLiquidityDenominator = _denominator;
503     }
504     
505     function getCirculatingSupply() public view returns (uint256) {
506         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
507     }
508 
509     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
510         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
511     }
512 
513     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
514         return getLiquidityBacking(accuracy) > target;
515     }
516 
517   
518 
519 
520 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
521 
522 }