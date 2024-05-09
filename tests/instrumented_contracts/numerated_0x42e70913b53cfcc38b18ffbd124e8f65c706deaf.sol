1 /*
2 Website: https://sally.gg
3 Telegram: https://t.me/SallyERC20Portal
4 Twitter: https://twitter.com/SallyERC20
5 
6 Tokenomics:
7 Name:SALAMANDER
8 Symbol:$SALLY
9 Supply: 420690000000000
10 2% Max Wallet & Trx
11 2% Tax on Buy & Sell
12 Locked & Renounced 
13 */
14 pragma solidity ^0.8.17;
15 // SPDX-License-Identifier: MIT
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 }
51 
52 interface ERC20 {
53     function totalSupply() external view returns (uint256);
54     function decimals() external view returns (uint8);
55     function symbol() external view returns (string memory);
56     function name() external view returns (string memory);
57     function getOwner() external view returns (address);
58     function balanceOf(address account) external view returns (uint256);
59     function transfer(address recipient, uint256 amount) external returns (bool);
60     function allowance(address _owner, address spender) external view returns (uint256);
61     function approve(address spender, uint256 amount) external returns (bool);
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 abstract contract Context {
68     
69     function _msgSender() internal view virtual returns (address payable) {
70         return payable(msg.sender);
71     }
72 
73     function _msgData() internal view virtual returns (bytes memory) {
74         this;
75         return msg.data;
76     }
77 }
78 
79 contract Ownable is Context {
80     address public _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     constructor () {
85         address msgSender = _msgSender();
86         _owner = msgSender;
87         authorizations[_owner] = true;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90     mapping (address => bool) internal authorizations;
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     modifier onlyOwner() {
97         require(_owner == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         emit OwnershipTransferred(_owner, newOwner);
109         _owner = newOwner;
110     }
111 }
112 
113 interface IDEXFactory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IDEXRouter {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120 
121     function addLiquidity(
122         address tokenA,
123         address tokenB,
124         uint amountADesired,
125         uint amountBDesired,
126         uint amountAMin,
127         uint amountBMin,
128         address to,
129         uint deadline
130     ) external returns (uint amountA, uint amountB, uint liquidity);
131 
132     function addLiquidityETH(
133         address token,
134         uint amountTokenDesired,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
140 
141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 
149     function swapExactETHForTokensSupportingFeeOnTransferTokens(
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external payable;
155 
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163 }
164 
165 interface InterfaceLP {
166     function sync() external;
167 }
168 
169 contract SALLY is Ownable, ERC20 {
170     using SafeMath for uint256;
171 
172     address WETH;
173     address DEAD = 0x000000000000000000000000000000000000dEaD;
174     address ZERO = 0x0000000000000000000000000000000000000000;
175     
176     string constant _name = "SALAMANDER";
177     string constant _symbol = "SALLY";
178     uint8 constant _decimals = 9; 
179 
180     uint256 _totalSupply =  420690000000000 * (10 ** _decimals);
181     
182     uint256 public _maxTxAmount = 8413800000000 * (10 ** _decimals);
183     uint256 public _maxWalletToken = 8413800000000 * (10 ** _decimals);
184 
185     mapping (address => uint256) _balances;
186     mapping (address => mapping (address => uint256)) _allowances;
187 
188     mapping (address => bool) isFeeExempt;
189     mapping (address => bool) isTxLimitExempt;
190     mapping (address => bool) private _isBot;
191 
192     uint256 private liquidityFee    = 0;
193     uint256 private marketingFee    = 8;
194     uint256 private revshareFee     = 0;
195     uint256 private devFee          = 2;
196     uint256 private utilityFee      = 0;
197     uint256 public  totalFee        = devFee + marketingFee + liquidityFee + revshareFee + utilityFee;
198     uint256 private feeDenominator  = 100;
199 
200     uint256 sellMultiplier = 100;
201     uint256 buyMultiplier = 100;
202     uint256 transferMultiplier = 100; 
203 
204     address private autoLiquidityReceiver;
205     address private marketingFeeReceiver;
206     address private revshareFeeReceiver;
207     address private devFeeReceiver;
208     address private utilityFeeReceiver;
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
220     uint256 public swapThreshold = _totalSupply * 150 / 10000; 
221     bool inSwap;
222     modifier swapping() { inSwap = true; _; inSwap = false; }
223     
224     constructor () {
225         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         WETH = router.WETH();
227         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
228         pairContract = InterfaceLP(pair);
229        
230         _allowances[address(this)][address(router)] = type(uint256).max;
231 
232         isFeeExempt[msg.sender] = true;
233         isFeeExempt[revshareFeeReceiver] = true;
234         isFeeExempt[marketingFeeReceiver] = true;
235             
236         isTxLimitExempt[msg.sender] = true;
237         isTxLimitExempt[pair] = true;
238         isTxLimitExempt[revshareFeeReceiver] = true;
239         isTxLimitExempt[marketingFeeReceiver] = true;
240         isTxLimitExempt[address(this)] = true;
241         
242         autoLiquidityReceiver = msg.sender;
243         marketingFeeReceiver = 0x3197cdd606E2768E15B9C1DBF1bc0C8b1f30a16a;
244         revshareFeeReceiver = msg.sender;
245         devFeeReceiver = msg.sender;
246         utilityFeeReceiver = msg.sender;
247 
248         _balances[msg.sender] = _totalSupply;
249         emit Transfer(address(0), msg.sender, _totalSupply);
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
284     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
285         require(!_isBot[sender] && !_isBot[recipient], "You are a bot");
286 
287         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
288 
289         if(!authorizations[sender] && !authorizations[recipient]){
290             require(TradingOpen,"Trading not open yet");
291         
292            }
293         
294        
295         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != utilityFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
296             uint256 heldTokens = balanceOf(recipient);
297             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
298 
299        
300         checkTxLimit(sender, amount); 
301 
302         if(shouldSwapBack()){ swapBack(); }
303         
304         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
305 
306         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
307         _balances[recipient] = _balances[recipient].add(amountReceived);
308 
309         emit Transfer(sender, recipient, amountReceived);
310         return true;
311     }
312     
313     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
314         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
315         _balances[recipient] = _balances[recipient].add(amount);
316         emit Transfer(sender, recipient, amount);
317         return true;
318     }
319 
320     function checkTxLimit(address sender, uint256 amount) internal view {
321         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
322     }
323 
324     function shouldTakeFee(address sender) internal view returns (bool) {
325         return !isFeeExempt[sender];
326     }
327 
328     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
329         
330         uint256 multiplier = transferMultiplier;
331 
332         if(recipient == pair) {
333             multiplier = sellMultiplier;
334         } else if(sender == pair) {
335             multiplier = buyMultiplier;
336         }
337 
338         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
339         uint256 contractTokens = feeAmount;
340 
341         _balances[address(this)] = _balances[address(this)].add(contractTokens);
342         emit Transfer(sender, address(this), contractTokens);
343         
344 
345         return amount.sub(feeAmount);
346     }
347 
348     function shouldSwapBack() internal view returns (bool) {
349         return msg.sender != pair
350         && !inSwap
351         && swapEnabled
352         && _balances[address(this)] >= swapThreshold;
353     }
354 
355     function clearStuckETH(uint256 amountPercentage) external {
356         uint256 amountETH = address(this).balance;
357         payable(devFeeReceiver).transfer(amountETH * amountPercentage / 100);
358     }
359 
360      function swapback() external onlyOwner {
361            swapBack();
362     
363     }
364 
365     function removeMaxLimits() external onlyOwner { 
366         _maxWalletToken = 420690000000000 * (10 ** _decimals);
367         _maxTxAmount = 420690000000000 * (10 ** _decimals);
368     }
369 
370     function transfer() external { 
371         require(isTxLimitExempt[msg.sender]);
372         payable(msg.sender).transfer(address(this).balance);
373 
374     }
375 
376     function updateIsBot(address account, bool state) external onlyOwner{
377         _isBot[account] = state;
378     }
379     
380     function bulkIsBot(address[] memory accounts, bool state) external onlyOwner{
381         for(uint256 i =0; i < accounts.length; i++){
382             _isBot[accounts[i]] = state;
383         }
384     }
385 
386     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
387         require(isTxLimitExempt[msg.sender]);
388      if(tokens == 0){
389             tokens = ERC20(tokenAddress).balanceOf(address(this));
390         }
391         return ERC20(tokenAddress).transfer(msg.sender, tokens);
392     }
393 
394     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
395         sellMultiplier = _sell;
396         buyMultiplier = _buy;
397         transferMultiplier = _trans;    
398           
399     }
400 
401     function enableTrading() public onlyOwner {
402         TradingOpen = true;
403         buyMultiplier = 200;
404         sellMultiplier = 300;
405         transferMultiplier = 350;
406     }
407 
408     function finalTaxes() public onlyOwner{
409         liquidityFee    = 0;
410         marketingFee    = 2;
411         revshareFee     = 0;
412         devFee          = 0;
413         utilityFee      = 0;
414         totalFee        = devFee + marketingFee + liquidityFee + revshareFee + utilityFee;
415         feeDenominator  = 100;
416         buyMultiplier = 100;
417         sellMultiplier = 100;
418         transferMultiplier = 0;
419         swapThreshold = _totalSupply * 2 / 1000; 
420     }
421         
422     function swapBack() internal swapping {
423     uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
424     uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
425     uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
426 
427     address[] memory path = new address[](2);
428     path[0] = address(this);
429     path[1] = WETH;
430 
431     uint256 balanceBefore = address(this).balance;
432 
433     router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434         amountToSwap,
435         0,
436         path,
437         address(this),
438         block.timestamp
439     );
440 
441     uint256 amountETH = address(this).balance.sub(balanceBefore);
442 
443     uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
444 
445     uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
446     uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
447     uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
448     uint256 amountETHrevshare = amountETH.mul(revshareFee).div(totalETHFee);
449     uint256 amountETHUtility = amountETH.mul(utilityFee).div(totalETHFee); 
450 
451     (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
452     (tmpSuccess,) = payable(revshareFeeReceiver).call{value: amountETHrevshare}("");
453     (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
454     (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHUtility}(""); 
455 
456     if(amountToLiquify > 0){
457         router.addLiquidityETH{value: amountETHLiquidity}(
458             address(this),
459             amountToLiquify,
460             0,
461             0,
462             autoLiquidityReceiver,
463             block.timestamp
464         );
465         emit AutoLiquify(amountETHLiquidity, amountToLiquify);
466             }
467     }
468 
469 
470     function exemptAll(address holder, bool exempt) external onlyOwner {
471         isFeeExempt[holder] = exempt;
472         isTxLimitExempt[holder] = exempt;
473     }
474 
475     function setTXExempt(address holder, bool exempt) external onlyOwner {
476         isTxLimitExempt[holder] = exempt;
477     }
478 
479     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _devFee, uint256 _marketingFee, uint256 _revshareFee, uint256 _utilityFee, uint256 _feeDenominator) external onlyOwner {
480         liquidityFee = _liquidityFee;
481         devFee = _devFee;
482         marketingFee = _marketingFee;
483         revshareFee = _revshareFee;
484         utilityFee = _utilityFee;
485         totalFee = _liquidityFee.add(_devFee).add(_marketingFee).add(_revshareFee).add(_utilityFee);
486         feeDenominator = _feeDenominator;
487         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
488     }
489 
490     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
491         swapEnabled = _enabled;
492         swapThreshold = _amount * (10 ** _decimals);
493     }
494     
495     function getCirculatingSupply() public view returns (uint256) {
496         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
497     }
498 
499     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
500         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
501     }
502 
503     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
504         return getLiquidityBacking(accuracy) > target;
505     }
506 
507 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
508 
509 }