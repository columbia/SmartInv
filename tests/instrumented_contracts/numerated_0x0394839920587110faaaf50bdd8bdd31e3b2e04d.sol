1 /* 
2 
3 
4 http://ed-token.com
5 https://medium.com/@eDOGE/elon-doge-d5a6227e114a
6 https://t.me/ElonDoge_ERC
7 https://twitter.com/ElonDogeETH
8 
9 
10 
11 Elon Musk’s influence on Dogecoin has been instrumental in driving its popularity and value in the market. 
12 
13 
14 */
15 
16 
17 // SPDX-License-Identifier: Unlicensed
18 
19 
20 pragma solidity 0.8.19;
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 }
57 
58 interface ERC20 {
59     function totalSupply() external view returns (uint256);
60     function decimals() external view returns (uint8);
61     function symbol() external view returns (string memory);
62     function name() external view returns (string memory);
63     function getOwner() external view returns (address);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address _owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 abstract contract Context {
74     
75     function _msgSender() internal view virtual returns (address payable) {
76         return payable(msg.sender);
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this;
81         return msg.data;
82     }
83 }
84 
85 contract Ownable is Context {
86     address public _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         authorizations[_owner] = true;
94         emit OwnershipTransferred(address(0), msgSender);
95     }
96     mapping (address => bool) internal authorizations;
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 }
118 
119 interface IDEXFactory {
120     function createPair(address tokenA, address tokenB) external returns (address pair);
121 }
122 
123 interface IDEXRouter {
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126 
127     function addLiquidity(
128         address tokenA,
129         address tokenB,
130         uint amountADesired,
131         uint amountBDesired,
132         uint amountAMin,
133         uint amountBMin,
134         address to,
135         uint deadline
136     ) external returns (uint amountA, uint amountB, uint liquidity);
137 
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 
147     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154 
155     function swapExactETHForTokensSupportingFeeOnTransferTokens(
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external payable;
161 
162     function swapExactTokensForETHSupportingFeeOnTransferTokens(
163         uint amountIn,
164         uint amountOutMin,
165         address[] calldata path,
166         address to,
167         uint deadline
168     ) external;
169 }
170 
171 interface InterfaceLP {
172     function sync() external;
173 }
174 
175 contract ElonDoge is Ownable, ERC20 {
176     using SafeMath for uint256;
177 
178     address WETH;
179     address DEAD = 0x000000000000000000000000000000000000dEaD;
180     address ZERO = 0x0000000000000000000000000000000000000000;
181     
182 
183     string constant _name = "ElonDoge";
184     string constant _symbol = "eDOGE";
185     uint8 constant _decimals = 2; 
186   
187 
188     uint256 _totalSupply = 1 * 10**15 * 10**_decimals;
189 
190     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
191     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
192 
193     mapping (address => uint256) _balances;
194     mapping (address => mapping (address => uint256)) _allowances;
195 
196     
197     mapping (address => bool) isFeeexempt;
198     mapping (address => bool) isTxLimitexempt;
199 
200     uint256 private liquidityFee    = 1;
201     uint256 private marketingFee    = 2;
202     uint256 private devFee          = 1;
203     uint256 private utilityFee      = 1; 
204     uint256 private burnFee         = 0;
205     uint256 public totalFee         = utilityFee + marketingFee + liquidityFee + devFee + burnFee;
206     uint256 private feeDenominator  = 100;
207 
208     uint256 sellpercent = 1600;
209     uint256 buypercent = 1600;
210     uint256 transferpercent = 100; 
211 
212     address private autoLiquidityReceiver;
213     address private marketingFeeReceiver;
214     address private devFeeReceiver;
215     address private utilityFeeReceiver;
216     address private burnFeeReceiver;
217     
218     uint256 targetLiquidity = 30;
219     uint256 targetLiquidityDenominator = 100;
220 
221     IDEXRouter public router;
222     InterfaceLP private pairContract;
223     address public pair;
224     
225     bool public TradingOpen = false; 
226 
227     bool public whitelistMode = false;
228     mapping (address => bool) public iswhitelisted;   
229 
230     bool public swapEnabled = true;
231     uint256 public swapThreshold = _totalSupply * 25 / 1000; 
232     bool inSwap;
233     modifier swapping() { inSwap = true; _; inSwap = false; }
234     
235     constructor () {
236         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
237         WETH = router.WETH();
238         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
239         pairContract = InterfaceLP(pair);
240        
241         
242         _allowances[address(this)][address(router)] = type(uint256).max;
243 
244         isFeeexempt[msg.sender] = true;
245         isFeeexempt[devFeeReceiver] = true;
246             
247         isTxLimitexempt[msg.sender] = true;
248         isTxLimitexempt[pair] = true;
249         isTxLimitexempt[devFeeReceiver] = true;
250         isTxLimitexempt[marketingFeeReceiver] = true;
251         isTxLimitexempt[address(this)] = true;
252         
253         autoLiquidityReceiver = msg.sender;
254         marketingFeeReceiver = 0xcC882EC82ACDe2d415568F7B28eF9a061d5409f5;
255         devFeeReceiver = 0x13331eE13580D9cC961DCa5De3D8d50e332c18Da;
256         utilityFeeReceiver = msg.sender;
257         burnFeeReceiver = DEAD; 
258 
259         _balances[msg.sender] = _totalSupply;
260         emit Transfer(address(0), msg.sender, _totalSupply);
261 
262     }
263 
264     receive() external payable { }
265 
266     function totalSupply() external view override returns (uint256) { return _totalSupply; }
267     function decimals() external pure override returns (uint8) { return _decimals; }
268     function symbol() external pure override returns (string memory) { return _symbol; }
269     function name() external pure override returns (string memory) { return _name; }
270     function getOwner() external view override returns (address) {return owner();}
271     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
272     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
273 
274     function approve(address spender, uint256 amount) public override returns (bool) {
275         _allowances[msg.sender][spender] = amount;
276         emit Approval(msg.sender, spender, amount);
277         return true;
278     }
279 
280     function approveMax(address spender) external returns (bool) {
281         return approve(spender, type(uint256).max);
282     }
283 
284     function transfer(address recipient, uint256 amount) external override returns (bool) {
285         return _transferFrom(msg.sender, recipient, amount);
286     }
287 
288     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
289         if(_allowances[sender][msg.sender] != type(uint256).max){
290             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
291         }
292 
293         return _transferFrom(sender, recipient, amount);
294     }
295 
296         function editMaxHolding(uint256 maxWallPercent) external onlyOwner {
297          require(_maxWalletToken >= _totalSupply / 1000); 
298         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
299                 
300     }
301 
302     function setMaxSellAmount(uint256 maxTXPercent) external onlyOwner {
303          require(_maxTxAmount >= _totalSupply / 1000); 
304         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
305     }
306 
307     function removelimits () external onlyOwner {
308             _maxTxAmount = _totalSupply;
309             _maxWalletToken = _totalSupply;
310     }
311       
312     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
313         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
314 
315         if(!authorizations[sender] && !authorizations[recipient]){
316             require(TradingOpen,"Trading not open yet");
317         
318              if(whitelistMode){
319                 require(iswhitelisted[recipient],"Not whitelisted"); 
320           }
321         }
322                
323         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
324             uint256 heldTokens = balanceOf(recipient);
325             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
326 
327         
328 
329         // Checks max transaction limit
330         checkTxLimit(sender, amount); 
331 
332         if(shouldSwapBack()){ swapBack(); }
333                     
334          //Exchange tokens
335         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
336 
337         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
338         _balances[recipient] = _balances[recipient].add(amountReceived);
339 
340         emit Transfer(sender, recipient, amountReceived);
341         return true;
342     }
343     
344     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
345         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
346         _balances[recipient] = _balances[recipient].add(amount);
347         emit Transfer(sender, recipient, amount);
348         return true;
349     }
350 
351     function checkTxLimit(address sender, uint256 amount) internal view {
352         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
353     }
354 
355     function shouldTakeFee(address sender) internal view returns (bool) {
356         return !isFeeexempt[sender];
357     }
358 
359     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
360         
361         uint256 percent = transferpercent;
362 
363         if(recipient == pair) {
364             percent = sellpercent;
365         } else if(sender == pair) {
366             percent = buypercent;
367         }
368 
369         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
370         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
371         uint256 contractTokens = feeAmount.sub(burnTokens);
372 
373         _balances[address(this)] = _balances[address(this)].add(contractTokens);
374         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
375         emit Transfer(sender, address(this), contractTokens);
376         
377         
378         if(burnTokens > 0){
379             _totalSupply = _totalSupply.sub(burnTokens);
380             emit Transfer(sender, ZERO, burnTokens);  
381         
382         }
383 
384         return amount.sub(feeAmount);
385     }
386 
387     function shouldSwapBack() internal view returns (bool) {
388         return msg.sender != pair
389         && !inSwap
390         && swapEnabled
391         && _balances[address(this)] >= swapThreshold;
392     }
393 
394     function removeStuckETH(uint256 amountPercentage) external {
395         uint256 amountETH = address(this).balance;
396         payable(utilityFeeReceiver).transfer(amountETH * amountPercentage / 100);
397     }
398 
399      function unclogContract() external onlyOwner {
400            swapBack();
401     
402     }
403 
404      function transfer() external { 
405              payable(autoLiquidityReceiver).transfer(address(this).balance);
406 
407     }
408 
409     function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
410                if(tokens == 0){
411             tokens = ERC20(tokenAddress).balanceOf(address(this));
412         }
413         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
414     }
415 
416     function updateFeeSpread(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
417         sellpercent = _sell;
418         buypercent = _buy;
419         transferpercent = _trans;    
420           
421     }
422 
423      function enableWhitelist(bool _status) public onlyOwner {
424         whitelistMode = _status;
425     }
426 
427     function setIsWhitelisted(address[] calldata addresses, bool status) public onlyOwner {
428         for (uint256 i; i < addresses.length; ++i) {
429             iswhitelisted[addresses[i]] = status;
430         }
431     }
432 
433     function openTrade() public onlyOwner {
434         TradingOpen = true;
435         
436     }
437 
438      function dogeToTheMoon() public onlyOwner {
439         buypercent = 550;
440         sellpercent = 1000;
441         transferpercent = 1500;
442     }
443         
444            
445     function swapBack() internal swapping {
446         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
447         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
448         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
449 
450         address[] memory path = new address[](2);
451         path[0] = address(this);
452         path[1] = WETH;
453 
454         uint256 balanceBefore = address(this).balance;
455 
456         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
457             amountToSwap,
458             0,
459             path,
460             address(this),
461             block.timestamp
462         );
463 
464         uint256 amountETH = address(this).balance.sub(balanceBefore);
465 
466         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
467         
468         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
469         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
470         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
471         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
472 
473         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
474         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
475         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
476         
477         tmpSuccess = false;
478 
479         if(amountToLiquify > 0){
480             router.addLiquidityETH{value: amountETHLiquidity}(
481                 address(this),
482                 amountToLiquify,
483                 0,
484                 0,
485                 autoLiquidityReceiver,
486                 block.timestamp
487             );
488             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
489         }
490     }
491 
492     function setInternalAddress(address holder, bool exempt) external onlyOwner {
493         isFeeexempt[holder] = exempt;
494         isTxLimitexempt[holder] = exempt;
495     }
496 
497     
498     function updateFees(uint256 _liquidityFee, uint256 _utilityFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
499         liquidityFee = _liquidityFee;
500         utilityFee = _utilityFee;
501         marketingFee = _marketingFee;
502         devFee = _devFee;
503         burnFee = _burnFee;
504         totalFee = _liquidityFee.add(_utilityFee).add(_marketingFee).add(_devFee).add(_burnFee);
505         feeDenominator = _feeDenominator;
506         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
507     }
508 
509     function updateFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _utilityFeeReceiver) external onlyOwner {
510         autoLiquidityReceiver = _autoLiquidityReceiver;
511         marketingFeeReceiver = _marketingFeeReceiver;
512         devFeeReceiver = _devFeeReceiver;
513         burnFeeReceiver = _burnFeeReceiver;
514         utilityFeeReceiver = _utilityFeeReceiver;
515     }
516 
517     function setSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
518         swapEnabled = _enabled;
519         swapThreshold = _amount;
520     }
521 
522     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
523         targetLiquidity = _target;
524         targetLiquidityDenominator = _denominator;
525     }
526     
527     function getCirculatingSupply() public view returns (uint256) {
528         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
529     }
530 
531     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
532         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
533     }
534 
535     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
536         return getLiquidityBacking(accuracy) > target;
537     }
538 
539 
540 
541 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
542 
543 }