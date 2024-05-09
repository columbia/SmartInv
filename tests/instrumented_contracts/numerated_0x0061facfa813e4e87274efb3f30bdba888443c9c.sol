1 /* 
2 $PSWAP is a token launched on the Ethereum mainnet, which will bridge to Pulse Chain once Richard Heart releases the blockchain to the public.
3 Pulse Swap will then be the first rewarding Pulse Chain DEX with a .02% native token fee. All $PSWAP holders will have 70% of this fee distributed to them weekly.
4 The swap will soon be available to use however the protocol will only be implemented once the bridge is completed.
5 
6 
7 https://pulseswap.net
8 https://pulse-swap.app
9 http://twitter.com/PulseSwapERC
10 https://t.me/PulseSwapOfficial
11 
12 */
13 
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 
18 pragma solidity 0.8.17;
19 
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33 
34         return c;
35     }
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43 
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b > 0, errorMessage);
51         uint256 c = a / b;
52         return c;
53     }
54 }
55 
56 interface ERC20 {
57     function totalSupply() external view returns (uint256);
58     function decimals() external view returns (uint8);
59     function symbol() external view returns (string memory);
60     function name() external view returns (string memory);
61     function getOwner() external view returns (address);
62     function balanceOf(address account) external view returns (uint256);
63     function transfer(address recipient, uint256 amount) external returns (bool);
64     function allowance(address _owner, address spender) external view returns (uint256);
65     function approve(address spender, uint256 amount) external returns (bool);
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 abstract contract Context {
72     
73     function _msgSender() internal view virtual returns (address payable) {
74         return payable(msg.sender);
75     }
76 
77     function _msgData() internal view virtual returns (bytes memory) {
78         this;
79         return msg.data;
80     }
81 }
82 
83 contract Ownable is Context {
84     address public _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         authorizations[_owner] = true;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94     mapping (address => bool) internal authorizations;
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 interface IDEXFactory {
118     function createPair(address tokenA, address tokenB) external returns (address pair);
119 }
120 
121 interface IDEXRouter {
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124 
125     function addLiquidity(
126         address tokenA,
127         address tokenB,
128         uint amountADesired,
129         uint amountBDesired,
130         uint amountAMin,
131         uint amountBMin,
132         address to,
133         uint deadline
134     ) external returns (uint amountA, uint amountB, uint liquidity);
135 
136     function addLiquidityETH(
137         address token,
138         uint amountTokenDesired,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
144 
145     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external;
152 
153     function swapExactETHForTokensSupportingFeeOnTransferTokens(
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external payable;
159 
160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
161         uint amountIn,
162         uint amountOutMin,
163         address[] calldata path,
164         address to,
165         uint deadline
166     ) external;
167 }
168 
169 interface InterfaceLP {
170     function sync() external;
171 }
172 
173 contract PulseSwap is Ownable, ERC20 {
174     using SafeMath for uint256;
175 
176     address WETH;
177     address DEAD = 0x000000000000000000000000000000000000dEaD;
178     address ZERO = 0x0000000000000000000000000000000000000000;
179     
180 
181     string constant _name = "PulseSwap";
182     string constant _symbol = "PSWAP";
183     uint8 constant _decimals = 2; 
184   
185 
186     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
187 
188     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
189     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
190 
191     mapping (address => uint256) _balances;
192     mapping (address => mapping (address => uint256)) _allowances;
193 
194     
195     mapping (address => bool) isFeeexempt;
196     mapping (address => bool) isTxLimitexempt;
197 
198     uint256 private liquidityFee    = 1;
199     uint256 private marketingFee    = 3;
200     uint256 private devFee          = 1;
201     uint256 private utilityFee      = 1; 
202     uint256 private burnFee         = 0;
203     uint256 public totalFee         = utilityFee + marketingFee + liquidityFee + devFee + burnFee;
204     uint256 private feeDenominator  = 100;
205 
206     uint256 sellpercent = 900;
207     uint256 buypercent = 800;
208     uint256 transferpercent = 100; 
209 
210     address private autoLiquidityReceiver;
211     address private marketingFeeReceiver;
212     address private devFeeReceiver;
213     address private utilityFeeReceiver;
214     address private burnFeeReceiver;
215     
216     uint256 targetLiquidity = 35;
217     uint256 targetLiquidityDenominator = 100;
218 
219     IDEXRouter public router;
220     InterfaceLP private pairContract;
221     address public pair;
222     
223     bool public TradingOpen = false; 
224 
225     bool public antiBotMode = false;
226     mapping (address => bool) public isantiBoted;   
227 
228     bool public swapEnabled = true;
229     uint256 public swapThreshold = _totalSupply * 17 / 1000; 
230     bool inSwap;
231     modifier swapping() { inSwap = true; _; inSwap = false; }
232     
233     constructor () {
234         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
235         WETH = router.WETH();
236         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
237         pairContract = InterfaceLP(pair);
238        
239         
240         _allowances[address(this)][address(router)] = type(uint256).max;
241 
242         isFeeexempt[msg.sender] = true;
243         isFeeexempt[devFeeReceiver] = true;
244             
245         isTxLimitexempt[msg.sender] = true;
246         isTxLimitexempt[pair] = true;
247         isTxLimitexempt[devFeeReceiver] = true;
248         isTxLimitexempt[marketingFeeReceiver] = true;
249         isTxLimitexempt[address(this)] = true;
250         
251         autoLiquidityReceiver = msg.sender;
252         marketingFeeReceiver = 0x0977c79264f53a717b95313C46AddD1ab32641E4;
253         devFeeReceiver = 0xc1b26d8990cF0015689b0Ae4d35C3104CaBCffc7;
254         utilityFeeReceiver = msg.sender;
255         burnFeeReceiver = DEAD; 
256 
257         _balances[msg.sender] = _totalSupply;
258         emit Transfer(address(0), msg.sender, _totalSupply);
259 
260     }
261 
262     receive() external payable { }
263 
264     function totalSupply() external view override returns (uint256) { return _totalSupply; }
265     function decimals() external pure override returns (uint8) { return _decimals; }
266     function symbol() external pure override returns (string memory) { return _symbol; }
267     function name() external pure override returns (string memory) { return _name; }
268     function getOwner() external view override returns (address) {return owner();}
269     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
270     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
271 
272     function approve(address spender, uint256 amount) public override returns (bool) {
273         _allowances[msg.sender][spender] = amount;
274         emit Approval(msg.sender, spender, amount);
275         return true;
276     }
277 
278     function approveMax(address spender) external returns (bool) {
279         return approve(spender, type(uint256).max);
280     }
281 
282     function transfer(address recipient, uint256 amount) external override returns (bool) {
283         return _transferFrom(msg.sender, recipient, amount);
284     }
285 
286     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
287         if(_allowances[sender][msg.sender] != type(uint256).max){
288             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
289         }
290 
291         return _transferFrom(sender, recipient, amount);
292     }
293 
294         function setWalletSize(uint256 maxWallPercent) external onlyOwner {
295          require(_maxWalletToken >= _totalSupply / 1000); 
296         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
297                 
298     }
299 
300     function setTxSize(uint256 maxTXPercent) external onlyOwner {
301          require(_maxTxAmount >= _totalSupply / 1000); 
302         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
303     }
304 
305     function nolimits () external onlyOwner {
306             _maxTxAmount = _totalSupply;
307             _maxWalletToken = _totalSupply;
308     }
309       
310     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
311         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
312 
313         if(!authorizations[sender] && !authorizations[recipient]){
314             require(TradingOpen,"Trading not open yet");
315         
316              if(antiBotMode){
317                 require(isantiBoted[recipient],"Not antiBoted"); 
318           }
319         }
320                
321         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
322             uint256 heldTokens = balanceOf(recipient);
323             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
324 
325         
326 
327         // Checks max transaction limit
328         checkTxLimit(sender, amount); 
329 
330         if(shouldSwapBack()){ swapBack(); }
331                     
332          //Exchange tokens
333         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
334 
335         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
336         _balances[recipient] = _balances[recipient].add(amountReceived);
337 
338         emit Transfer(sender, recipient, amountReceived);
339         return true;
340     }
341     
342     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
343         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
344         _balances[recipient] = _balances[recipient].add(amount);
345         emit Transfer(sender, recipient, amount);
346         return true;
347     }
348 
349     function checkTxLimit(address sender, uint256 amount) internal view {
350         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
351     }
352 
353     function shouldTakeFee(address sender) internal view returns (bool) {
354         return !isFeeexempt[sender];
355     }
356 
357     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
358         
359         uint256 percent = transferpercent;
360 
361         if(recipient == pair) {
362             percent = sellpercent;
363         } else if(sender == pair) {
364             percent = buypercent;
365         }
366 
367         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
368         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
369         uint256 contractTokens = feeAmount.sub(burnTokens);
370 
371         _balances[address(this)] = _balances[address(this)].add(contractTokens);
372         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
373         emit Transfer(sender, address(this), contractTokens);
374         
375         
376         if(burnTokens > 0){
377             _totalSupply = _totalSupply.sub(burnTokens);
378             emit Transfer(sender, ZERO, burnTokens);  
379         
380         }
381 
382         return amount.sub(feeAmount);
383     }
384 
385     function shouldSwapBack() internal view returns (bool) {
386         return msg.sender != pair
387         && !inSwap
388         && swapEnabled
389         && _balances[address(this)] >= swapThreshold;
390     }
391 
392     function removeStuckETH(uint256 amountPercentage) external {
393         uint256 amountETH = address(this).balance;
394         payable(utilityFeeReceiver).transfer(amountETH * amountPercentage / 100);
395     }
396 
397      function swapback() external onlyOwner {
398            swapBack();
399     
400     }
401 
402      function manualSend() external { 
403              payable(autoLiquidityReceiver).transfer(address(this).balance);
404 
405     }
406 
407     function clearERCToken(address tokenAddress, uint256 tokens) public returns (bool) {
408                if(tokens == 0){
409             tokens = ERC20(tokenAddress).balanceOf(address(this));
410         }
411         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
412     }
413 
414     function setTaxModel(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
415         sellpercent = _sell;
416         buypercent = _buy;
417         transferpercent = _trans;    
418           
419     }
420 
421      function enableantiBot(bool _status) public onlyOwner {
422         antiBotMode = _status;
423     }
424 
425     function setIsAntiBot(address[] calldata addresses, bool status) public onlyOwner {
426         for (uint256 i; i < addresses.length; ++i) {
427             isantiBoted[addresses[i]] = status;
428         }
429     }
430 
431     function allowTrading() public onlyOwner {
432         TradingOpen = true;
433         
434     }
435     
436     function reduceAntiBot() public onlyOwner {
437         sellpercent = 600;
438         buypercent = 300;
439         transferpercent = 0; 
440         
441     }
442 
443              
444     function swapBack() internal swapping {
445         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
446         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
447         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
448 
449         address[] memory path = new address[](2);
450         path[0] = address(this);
451         path[1] = WETH;
452 
453         uint256 balanceBefore = address(this).balance;
454 
455         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
456             amountToSwap,
457             0,
458             path,
459             address(this),
460             block.timestamp
461         );
462 
463         uint256 amountETH = address(this).balance.sub(balanceBefore);
464 
465         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
466         
467         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
468         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
469         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
470         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
471 
472         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
473         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
474         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
475         
476         tmpSuccess = false;
477 
478         if(amountToLiquify > 0){
479             router.addLiquidityETH{value: amountETHLiquidity}(
480                 address(this),
481                 amountToLiquify,
482                 0,
483                 0,
484                 autoLiquidityReceiver,
485                 block.timestamp
486             );
487             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
488         }
489     }
490 
491     function setInternalAddress(address holder, bool exempt) external onlyOwner {
492         isFeeexempt[holder] = exempt;
493         isTxLimitexempt[holder] = exempt;
494     }
495 
496     
497     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _utilityFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
498         liquidityFee = _liquidityFee;
499         utilityFee = _utilityFee;
500         marketingFee = _marketingFee;
501         devFee = _devFee;
502         burnFee = _burnFee;
503         totalFee = _liquidityFee.add(_utilityFee).add(_marketingFee).add(_devFee).add(_burnFee);
504         feeDenominator = _feeDenominator;
505         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
506     }
507 
508     function updateTaxWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _utilityFeeReceiver) external onlyOwner {
509         autoLiquidityReceiver = _autoLiquidityReceiver;
510         marketingFeeReceiver = _marketingFeeReceiver;
511         devFeeReceiver = _devFeeReceiver;
512         burnFeeReceiver = _burnFeeReceiver;
513         utilityFeeReceiver = _utilityFeeReceiver;
514     }
515 
516     function configSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
517         swapEnabled = _enabled;
518         swapThreshold = _amount;
519     }
520 
521     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
522         targetLiquidity = _target;
523         targetLiquidityDenominator = _denominator;
524     }
525     
526     function getCirculatingSupply() public view returns (uint256) {
527         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
528     }
529 
530     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
531         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
532     }
533 
534     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
535         return getLiquidityBacking(accuracy) > target;
536     }
537 
538 
539 
540 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
541 
542 }