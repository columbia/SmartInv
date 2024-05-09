1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 pragma solidity ^0.8.14;
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
159 contract FOMO is Ownable, ERC20 {
160     using SafeMath for uint256;
161 
162     address WETH;
163     address DEAD = 0x000000000000000000000000000000000000dEaD;
164     address ZERO = 0x0000000000000000000000000000000000000000;
165     
166 
167     string constant _name = "FOMO";
168     string constant _symbol = "FOMO";
169     uint8 constant _decimals = 18; 
170 
171     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
172 
173     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
174     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
175 
176     mapping (address => uint256) _balances;
177     mapping (address => mapping (address => uint256)) _allowances;
178 
179     bool public blacklistMode = true;
180     mapping (address => bool) public isblacklisted;
181 
182 
183     mapping (address => bool) isFeeExempt;
184     mapping (address => bool) isTxLimitExempt;
185 
186     uint256 private liquidityFee    = 1;
187     uint256 private marketingFee    = 2;
188     uint256 private devFee          = 0;
189     uint256 private teamFee         = 0; 
190     uint256 private burnFee         = 0;
191     uint256 public totalFee        = teamFee + marketingFee + liquidityFee + devFee + burnFee;
192     uint256 private feeDenominator  = 100;
193 
194     uint256 sellMultiplier = 2000;
195     uint256 buyMultiplier = 2600;
196     uint256 transferMultiplier = 100; 
197 
198     address private autoLiquidityReceiver;
199     address private marketingFeeReceiver;
200     address private devFeeReceiver;
201     address private teamFeeReceiver;
202     address private burnFeeReceiver;
203 
204     uint256 targetLiquidity = 20;
205     uint256 targetLiquidityDenominator = 100;
206 
207     IDEXRouter public router;
208     InterfaceLP private pairContract;
209     address public pair;
210     
211     bool public TradingOpen = false;    
212 
213     bool public swapEnabled = true;
214     uint256 public swapThreshold = _totalSupply * 20 / 1000; 
215     bool inSwap;
216     modifier swapping() { inSwap = true; _; inSwap = false; }
217     
218     constructor () {
219         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
220         WETH = router.WETH();
221         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
222         pairContract = InterfaceLP(pair);
223         
224         _allowances[address(this)][address(router)] = type(uint256).max;
225 
226         isFeeExempt[msg.sender] = true;
227         isFeeExempt[devFeeReceiver] = true;
228             
229         isTxLimitExempt[msg.sender] = true;
230         isTxLimitExempt[pair] = true;
231         isTxLimitExempt[devFeeReceiver] = true;
232         isTxLimitExempt[marketingFeeReceiver] = true;
233         isTxLimitExempt[address(this)] = true;
234         
235         autoLiquidityReceiver = msg.sender;
236         marketingFeeReceiver = 0x946E0f217349F53962b1a19A2B0369E29Ccdd3F9;
237         devFeeReceiver = msg.sender;
238         teamFeeReceiver = msg.sender;
239         burnFeeReceiver = DEAD; 
240 
241         _balances[msg.sender] = _totalSupply;
242         emit Transfer(address(0), msg.sender, _totalSupply);
243     }
244 
245     receive() external payable { }
246 
247     function totalSupply() external view override returns (uint256) { return _totalSupply; }
248     function decimals() external pure override returns (uint8) { return _decimals; }
249     function symbol() external pure override returns (string memory) { return _symbol; }
250     function name() external pure override returns (string memory) { return _name; }
251     function getOwner() external view override returns (address) {return owner();}
252     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
253     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
254 
255     function approve(address spender, uint256 amount) public override returns (bool) {
256         _allowances[msg.sender][spender] = amount;
257         emit Approval(msg.sender, spender, amount);
258         return true;
259     }
260 
261     function approveMax(address spender) external returns (bool) {
262         return approve(spender, type(uint256).max);
263     }
264 
265     function transfer(address recipient, uint256 amount) external override returns (bool) {
266         return _transferFrom(msg.sender, recipient, amount);
267     }
268 
269     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
270         if(_allowances[sender][msg.sender] != type(uint256).max){
271             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
272         }
273 
274         return _transferFrom(sender, recipient, amount);
275     }
276 
277         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
278          require(_maxWalletToken >= _totalSupply / 1000); //no less than .1%
279         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
280                 
281     }
282 
283     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
284          require(_maxTxAmount >= _totalSupply / 1000); //anti honeypot no less than .1%
285         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
286     }
287 
288     function setTxLimitAbsolute(uint256 amount) external onlyOwner {
289         require(amount >= _totalSupply / 1000);
290         _maxTxAmount = amount;
291     
292     }
293 
294     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
295         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
296 
297         if(!authorizations[sender] && !authorizations[recipient]){
298             require(TradingOpen,"Trading not open yet");
299         
300            }
301         
302                       
303         if(blacklistMode){
304             require(!isblacklisted[sender],"blacklisted");    
305         }
306 
307         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
308             uint256 heldTokens = balanceOf(recipient);
309             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
310 
311         // Checks max transaction limit
312         checkTxLimit(sender, amount); 
313 
314         if(shouldSwapBack()){ swapBack(); }
315                     
316          //Exchange tokens
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
359         if(burnTokens > 0){
360             emit Transfer(sender, burnFeeReceiver, burnTokens);    
361         }
362 
363         return amount.sub(feeAmount);
364     }
365 
366     function shouldSwapBack() internal view returns (bool) {
367         return msg.sender != pair
368         && !inSwap
369         && swapEnabled
370         && _balances[address(this)] >= swapThreshold;
371     }
372 
373     function clearStuckBalance(uint256 amountPercentage) external onlyOwner { // to marketing
374         uint256 amountETH = address(this).balance;
375         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
376     }
377 
378      function manualSwap(uint256 amountPercentage) external onlyOwner {
379         uint256 tokensInContract = balanceOf(address(this));
380         uint256 tokenstosell = tokensInContract.mul(amountPercentage).div(100);
381         _basicTransfer(address(this),msg.sender,tokenstosell);
382     
383     }
384 
385     function removeLimits() external onlyOwner { 
386         _maxWalletToken = _totalSupply;
387         _maxTxAmount = _totalSupply;
388 
389     }
390 
391     function manualSend() external onlyOwner { 
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
405     function setPercents(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
406         sellMultiplier = _sell;
407         buyMultiplier = _buy;
408         transferMultiplier = _trans;    
409           
410     }
411 
412     function enableTrading() public onlyOwner {
413         TradingOpen = true;
414     }
415 
416         
417     function swapBack() internal swapping {
418         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
419         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
420         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
421 
422         address[] memory path = new address[](2);
423         path[0] = address(this);
424         path[1] = WETH;
425 
426         uint256 balanceBefore = address(this).balance;
427 
428         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
429             amountToSwap,
430             0,
431             path,
432             address(this),
433             block.timestamp
434         );
435 
436         uint256 amountETH = address(this).balance.sub(balanceBefore);
437 
438         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
439         
440         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
441         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
442         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
443         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
444 
445         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
446         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
447         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
448         
449         tmpSuccess = false;
450 
451         if(amountToLiquify > 0){
452             router.addLiquidityETH{value: amountETHLiquidity}(
453                 address(this),
454                 amountToLiquify,
455                 0,
456                 0,
457                 autoLiquidityReceiver,
458                 block.timestamp
459             );
460             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
461         }
462     }
463 
464     function enable_blacklist(bool _status) public onlyOwner {
465         blacklistMode = _status;
466     }
467 
468    
469     function manage_blacklist(address[] calldata addresses, bool status) public onlyOwner {
470         for (uint256 i; i < addresses.length; ++i) {
471             isblacklisted[addresses[i]] = status;
472         }
473     }
474     
475     function feeExempt(address holder, bool exempt) external onlyOwner {
476         isFeeExempt[holder] = exempt;
477     }
478 
479     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
480         isTxLimitExempt[holder] = exempt;
481     }
482 
483     function setBuyTax(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
484         liquidityFee = _liquidityFee;
485         teamFee = _teamFee;
486         marketingFee = _marketingFee;
487         devFee = _devFee;
488         burnFee = _burnFee;
489         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
490         feeDenominator = _feeDenominator;
491         require(totalFee < feeDenominator/2, "Fees cannot be more than 50%"); //antihoneypot
492     }
493 
494     function setTaxWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
495         autoLiquidityReceiver = _autoLiquidityReceiver;
496         marketingFeeReceiver = _marketingFeeReceiver;
497         devFeeReceiver = _devFeeReceiver;
498         burnFeeReceiver = _burnFeeReceiver;
499         teamFeeReceiver = _teamFeeReceiver;
500     }
501 
502     function setSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
503         swapEnabled = _enabled;
504         swapThreshold = _amount;
505     }
506 
507     function setTarget(uint256 _target, uint256 _denominator) external onlyOwner {
508         targetLiquidity = _target;
509         targetLiquidityDenominator = _denominator;
510     }
511     
512     function getCirculatingSupply() public view returns (uint256) {
513         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
514     }
515 
516     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
517         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
518     }
519 
520     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
521         return getLiquidityBacking(accuracy) > target;
522     }
523 
524 
525 
526 
527 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
528 
529 }