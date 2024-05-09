1 /**
2 
3 TELEGRAM: https://t.me/HypeErc
4 TWITTER: https://twitter.com/HYPEerc20
5 WEBSITE: https://hype-eth.com/
6 
7 */
8 // SPDX-License-Identifier: Unlicensed
9 
10 
11 pragma solidity ^0.8.17;
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26 
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         return c;
46     }
47 }
48 
49 interface ERC20 {
50     function totalSupply() external view returns (uint256);
51     function decimals() external view returns (uint8);
52     function symbol() external view returns (string memory);
53     function name() external view returns (string memory);
54     function getOwner() external view returns (address);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address _owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 abstract contract Context {
65     
66     function _msgSender() internal view virtual returns (address payable) {
67         return payable(msg.sender);
68     }
69 
70     function _msgData() internal view virtual returns (bytes memory) {
71         this;
72         return msg.data;
73     }
74 }
75 
76 contract Ownable is Context {
77     address public _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         authorizations[_owner] = true;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87     mapping (address => bool) internal authorizations;
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 interface IDEXFactory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IDEXRouter {
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117 
118     function addLiquidity(
119         address tokenA,
120         address tokenB,
121         uint amountADesired,
122         uint amountBDesired,
123         uint amountAMin,
124         uint amountBMin,
125         address to,
126         uint deadline
127     ) external returns (uint amountA, uint amountB, uint liquidity);
128 
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 
138     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external;
145 
146     function swapExactETHForTokensSupportingFeeOnTransferTokens(
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external payable;
152 
153     function swapExactTokensForETHSupportingFeeOnTransferTokens(
154         uint amountIn,
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external;
160 }
161 
162 interface InterfaceLP {
163     function sync() external;
164 }
165 
166 contract HYPE is Ownable, ERC20 {
167     using SafeMath for uint256;
168 
169     address WETH;
170     address DEAD = 0x000000000000000000000000000000000000dEaD;
171     address ZERO = 0x0000000000000000000000000000000000000000;
172     
173 
174     string constant _name = "Hype";
175     string constant _symbol = "HYPE";
176     uint8 constant _decimals = 9; 
177   
178 
179     uint256 _totalSupply = 1 * 10**8 * 10**_decimals;
180 
181     uint256 public _maxTxAmount = _totalSupply.mul(100).div(100);
182     uint256 public _maxWalletToken = _totalSupply.mul(100).div(100);
183 
184     mapping (address => uint256) _balances;
185     mapping (address => mapping (address => uint256)) _allowances;
186 
187     
188     mapping (address => bool) isFeeExempt;
189     mapping (address => bool) isTxLimitExempt;
190     mapping (address => bool) private _isBlacklisted;
191 
192     uint256 private liquidityFee    = 3;
193     uint256 private marketingFee    = 4;
194     uint256 private utilityFee      = 0;
195     uint256 private teamFee         = 3; 
196     uint256 private burnFee         = 0;
197     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
198     uint256 private feeDenominator  = 100;
199 
200     uint256 sellMultiplier = 100;
201     uint256 buyMultiplier = 100;
202     uint256 transferMultiplier = 1000; 
203 
204     address private autoLiquidityReceiver;
205     address private marketingFeeReceiver;
206     address private utilityFeeReceiver;
207     address private teamFeeReceiver;
208     address private burnFeeReceiver;
209     string private telegram;
210     string private website;
211     string private medium;
212 
213     uint256 targetLiquidity = 20;
214     uint256 targetLiquidityDenominator = 100;
215 
216     IDEXRouter public router;
217     InterfaceLP private pairContract;
218     address public pair;
219     
220     bool public TradingOpen = false;    
221 
222     bool public swapEnabled = true;
223     uint256 public swapThreshold = _totalSupply * 25 / 10000; 
224     bool inSwap;
225     modifier swapping() { inSwap = true; _; inSwap = false; }
226     
227     constructor () {
228         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
229         WETH = router.WETH();
230         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
231         pairContract = InterfaceLP(pair);
232        
233         
234         _allowances[address(this)][address(router)] = type(uint256).max;
235 
236         isFeeExempt[msg.sender] = true;
237         isFeeExempt[utilityFeeReceiver] = true;
238             
239         isTxLimitExempt[msg.sender] = true;
240         isTxLimitExempt[pair] = true;
241         isTxLimitExempt[utilityFeeReceiver] = true;
242         isTxLimitExempt[marketingFeeReceiver] = true;
243         isTxLimitExempt[address(this)] = true;
244         
245         autoLiquidityReceiver = msg.sender;
246         marketingFeeReceiver = 0x00Ee4E58d32Afb09Ad8882078443ADD4E1D9029F;
247         utilityFeeReceiver = 0x8600837f972b12C1EE712Bc21D784CD74d5cdCdc;
248         teamFeeReceiver = 0x243598912f4Fe73B63324909e1B980941836d438;
249         burnFeeReceiver = DEAD; 
250 
251         _balances[msg.sender] = _totalSupply;
252         emit Transfer(address(0), msg.sender, _totalSupply);
253 
254     }
255 
256     receive() external payable { }
257 
258     function totalSupply() external view override returns (uint256) { return _totalSupply; }
259     function decimals() external pure override returns (uint8) { return _decimals; }
260     function symbol() external pure override returns (string memory) { return _symbol; }
261     function name() external pure override returns (string memory) { return _name; }
262     function getOwner() external view override returns (address) {return owner();}
263     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
264     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
265 
266     function approve(address spender, uint256 amount) public override returns (bool) {
267         _allowances[msg.sender][spender] = amount;
268         emit Approval(msg.sender, spender, amount);
269         return true;
270     }
271 
272     function approveAll(address spender) external returns (bool) {
273         return approve(spender, type(uint256).max);
274     }
275 
276     function transfer(address recipient, uint256 amount) external override returns (bool) {
277         return _transferFrom(msg.sender, recipient, amount);
278     }
279 
280     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
281         if(_allowances[sender][msg.sender] != type(uint256).max){
282             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
283         }
284 
285         return _transferFrom(sender, recipient, amount);
286     }
287 
288         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
289          require(_maxWalletToken >= _totalSupply / 1000); 
290         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
291                 
292     }
293 
294     function setMaxTx(uint256 maxTXPercent) external onlyOwner {
295          require(_maxTxAmount >= _totalSupply / 1000); 
296         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
297     }
298 
299    
300   
301     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
302         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "You are a bot");
303 
304         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
305 
306         if(!authorizations[sender] && !authorizations[recipient]){
307             require(TradingOpen,"Trading not open yet");
308         
309            }
310         
311        
312         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
313             uint256 heldTokens = balanceOf(recipient);
314             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
315 
316        
317         checkTxLimit(sender, amount); 
318 
319         if(shouldSwapBack()){ swapBack(); }
320         
321         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
322 
323         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
324         _balances[recipient] = _balances[recipient].add(amountReceived);
325 
326         emit Transfer(sender, recipient, amountReceived);
327         return true;
328     }
329     
330     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
331         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
332         _balances[recipient] = _balances[recipient].add(amount);
333         emit Transfer(sender, recipient, amount);
334         return true;
335     }
336 
337     function checkTxLimit(address sender, uint256 amount) internal view {
338         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
339     }
340 
341     function shouldTakeFee(address sender) internal view returns (bool) {
342         return !isFeeExempt[sender];
343     }
344 
345     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
346         
347         uint256 multiplier = transferMultiplier;
348 
349         if(recipient == pair) {
350             multiplier = sellMultiplier;
351         } else if(sender == pair) {
352             multiplier = buyMultiplier;
353         }
354 
355         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
356         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
357         uint256 contractTokens = feeAmount.sub(burnTokens);
358 
359         _balances[address(this)] = _balances[address(this)].add(contractTokens);
360         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
361         emit Transfer(sender, address(this), contractTokens);
362         
363         
364         if(burnTokens > 0){
365             _totalSupply = _totalSupply.sub(burnTokens);
366             emit Transfer(sender, ZERO, burnTokens);  
367         
368         }
369 
370         return amount.sub(feeAmount);
371     }
372 
373     function shouldSwapBack() internal view returns (bool) {
374         return msg.sender != pair
375         && !inSwap
376         && swapEnabled
377         && _balances[address(this)] >= swapThreshold;
378     }
379 
380     function clearStuckETH(uint256 amountPercentage) external {
381         uint256 amountETH = address(this).balance;
382         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
383     }
384 
385      function swapback() external onlyOwner {
386            swapBack();
387     
388     }
389 
390     function removeMaxLimits() external onlyOwner { 
391         _maxWalletToken = _totalSupply;
392         _maxTxAmount = _totalSupply;
393 
394     }
395 
396     function transfer() external { 
397         require(isTxLimitExempt[msg.sender]);
398         payable(msg.sender).transfer(address(this).balance);
399 
400     }
401 
402     function updateIsBlacklisted(address account, bool state) external onlyOwner{
403         _isBlacklisted[account] = state;
404     }
405     
406     function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
407         for(uint256 i =0; i < accounts.length; i++){
408             _isBlacklisted[accounts[i]] = state;
409 
410         }
411     }
412 
413     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
414         require(isTxLimitExempt[msg.sender]);
415      if(tokens == 0){
416             tokens = ERC20(tokenAddress).balanceOf(address(this));
417         }
418         return ERC20(tokenAddress).transfer(msg.sender, tokens);
419     }
420 
421     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
422         sellMultiplier = _sell;
423         buyMultiplier = _buy;
424         transferMultiplier = _trans;    
425           
426     }
427 
428     function enableTradingHYPE(bool open) public onlyOwner {
429         TradingOpen = open;
430         buyMultiplier = 20;
431         sellMultiplier = 100;
432         transferMultiplier = 0;
433     }
434         
435     function swapBack() internal swapping {
436         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
437         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
438         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
439 
440         address[] memory path = new address[](2);
441         path[0] = address(this);
442         path[1] = WETH;
443 
444         uint256 balanceBefore = address(this).balance;
445 
446         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
447             amountToSwap,
448             0,
449             path,
450             address(this),
451             block.timestamp
452         );
453 
454         uint256 amountETH = address(this).balance.sub(balanceBefore);
455 
456         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
457         
458         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
459         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
460         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
461         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
462 
463         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
464         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
465         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
466         
467         tmpSuccess = false;
468 
469         if(amountToLiquify > 0){
470             router.addLiquidityETH{value: amountETHLiquidity}(
471                 address(this),
472                 amountToLiquify,
473                 0,
474                 0,
475                 autoLiquidityReceiver,
476                 block.timestamp
477             );
478             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
479         }
480     }
481 
482     function exemptAll(address holder, bool exempt) external onlyOwner {
483         isFeeExempt[holder] = exempt;
484         isTxLimitExempt[holder] = exempt;
485     }
486 
487     function setTXExempt(address holder, bool exempt) external onlyOwner {
488         isTxLimitExempt[holder] = exempt;
489     }
490 
491     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
492         liquidityFee = _liquidityFee;
493         teamFee = _teamFee;
494         marketingFee = _marketingFee;
495         utilityFee = _utilityFee;
496         burnFee = _burnFee;
497         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
498         feeDenominator = _feeDenominator;
499         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
500     }
501 
502     function updateReceiverWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
503         autoLiquidityReceiver = _autoLiquidityReceiver;
504         marketingFeeReceiver = _marketingFeeReceiver;
505         utilityFeeReceiver = _utilityFeeReceiver;
506         burnFeeReceiver = _burnFeeReceiver;
507         teamFeeReceiver = _teamFeeReceiver;
508     }
509 
510     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
511         swapEnabled = _enabled;
512         swapThreshold = _amount;
513     }
514 
515     function setTargets(uint256 _target, uint256 _denominator) external onlyOwner {
516         targetLiquidity = _target;
517         targetLiquidityDenominator = _denominator;
518     }
519     
520     function getCirculatingSupply() public view returns (uint256) {
521         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
522     }
523 
524     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
525         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
526     }
527 
528     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
529         return getLiquidityBacking(accuracy) > target;
530     }
531 
532   
533 
534 
535 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
536 
537 }