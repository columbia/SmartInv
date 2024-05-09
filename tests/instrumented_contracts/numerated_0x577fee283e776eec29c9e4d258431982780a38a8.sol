1 /* 
2 
3 The infamous Pepe's Wife
4 
5 TG: https://t.me/PepaErc
6 Twitter: twitter.com/PepaErc
7 Medium: https://link.medium.com/HKBxMExX2wb
8 Website:https://www.Pepacoin.com
9 
10 */
11 
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 
16 pragma solidity ^0.8.14;
17 
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32         return c;
33     }
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41 
42         return c;
43     }
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "SafeMath: division by zero");
46     }
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         return c;
51     }
52 }
53 
54 interface ERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 abstract contract Context {
70     
71     function _msgSender() internal view virtual returns (address payable) {
72         return payable(msg.sender);
73     }
74 
75     function _msgData() internal view virtual returns (bytes memory) {
76         this;
77         return msg.data;
78     }
79 }
80 
81 contract Ownable is Context {
82     address public _owner;
83 
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     constructor () {
87         address msgSender = _msgSender();
88         _owner = msgSender;
89         authorizations[_owner] = true;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92     mapping (address => bool) internal authorizations;
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 interface IDEXFactory {
116     function createPair(address tokenA, address tokenB) external returns (address pair);
117 }
118 
119 interface IDEXRouter {
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
122 
123     function addLiquidity(
124         address tokenA,
125         address tokenB,
126         uint amountADesired,
127         uint amountBDesired,
128         uint amountAMin,
129         uint amountBMin,
130         address to,
131         uint deadline
132     ) external returns (uint amountA, uint amountB, uint liquidity);
133 
134     function addLiquidityETH(
135         address token,
136         uint amountTokenDesired,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline
141     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
142 
143     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 
151     function swapExactETHForTokensSupportingFeeOnTransferTokens(
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external payable;
157 
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165 }
166 
167 interface InterfaceLP {
168     function sync() external;
169 }
170 
171 contract PEPA is Ownable, ERC20 {
172     using SafeMath for uint256;
173 
174     address WETH;
175     address DEAD = 0x000000000000000000000000000000000000dEaD;
176     address ZERO = 0x0000000000000000000000000000000000000000;
177     
178 
179     string constant _name = "PEPA";
180     string constant _symbol = "PEPA";
181     uint8 constant _decimals = 9; 
182   
183 
184     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
185 
186     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
187     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
188 
189     mapping (address => uint256) _balances;
190     mapping (address => mapping (address => uint256)) _allowances;
191 
192     
193     mapping (address => bool) isFeeExempt;
194     mapping (address => bool) isTxLimitExempt;
195 
196     uint256 private liquidityFee    = 1;
197     uint256 private marketingFee    = 2;
198     uint256 private utilityFee      = 2;
199     uint256 private teamFee         = 0; 
200     uint256 private burnFee         = 0;
201     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
202     uint256 private feeDenominator  = 100;
203 
204     uint256 sellMultiplier = 1900;
205     uint256 buyMultiplier = 600;
206     uint256 transferMultiplier = 1200; 
207 
208     address private autoLiquidityReceiver;
209     address private marketingFeeReceiver;
210     address private utilityFeeReceiver;
211     address private teamFeeReceiver;
212     address private burnFeeReceiver;
213     string private telegram;
214     string private website;
215     string private medium;
216 
217     uint256 targetLiquidity = 20;
218     uint256 targetLiquidityDenominator = 100;
219 
220     IDEXRouter public router;
221     InterfaceLP private pairContract;
222     address public pair;
223     
224     bool public TradingOpen = false;    
225 
226     bool public swapEnabled = true;
227     uint256 public swapThreshold = _totalSupply * 250 / 10000; 
228     bool inSwap;
229     modifier swapping() { inSwap = true; _; inSwap = false; }
230     
231     constructor () {
232         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
233         WETH = router.WETH();
234         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
235         pairContract = InterfaceLP(pair);
236        
237         
238         _allowances[address(this)][address(router)] = type(uint256).max;
239 
240         isFeeExempt[msg.sender] = true;
241         isFeeExempt[utilityFeeReceiver] = true;
242             
243         isTxLimitExempt[msg.sender] = true;
244         isTxLimitExempt[pair] = true;
245         isTxLimitExempt[utilityFeeReceiver] = true;
246         isTxLimitExempt[marketingFeeReceiver] = true;
247         isTxLimitExempt[address(this)] = true;
248         
249         autoLiquidityReceiver = msg.sender;
250         marketingFeeReceiver = 0xe190db955099B84b63edF6b0337D0c071A95E7CC;
251         utilityFeeReceiver = msg.sender;
252         teamFeeReceiver = msg.sender;
253         burnFeeReceiver = DEAD; 
254 
255         _balances[msg.sender] = _totalSupply;
256         emit Transfer(address(0), msg.sender, _totalSupply);
257 
258     }
259 
260     receive() external payable { }
261 
262     function totalSupply() external view override returns (uint256) { return _totalSupply; }
263     function decimals() external pure override returns (uint8) { return _decimals; }
264     function symbol() external pure override returns (string memory) { return _symbol; }
265     function name() external pure override returns (string memory) { return _name; }
266     function getOwner() external view override returns (address) {return owner();}
267     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
268     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
269 
270     function approve(address spender, uint256 amount) public override returns (bool) {
271         _allowances[msg.sender][spender] = amount;
272         emit Approval(msg.sender, spender, amount);
273         return true;
274     }
275 
276     function approveAll(address spender) external returns (bool) {
277         return approve(spender, type(uint256).max);
278     }
279 
280     function transfer(address recipient, uint256 amount) external override returns (bool) {
281         return _transferFrom(msg.sender, recipient, amount);
282     }
283 
284     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
285         if(_allowances[sender][msg.sender] != type(uint256).max){
286             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
287         }
288 
289         return _transferFrom(sender, recipient, amount);
290     }
291 
292         function updateWalletSize(uint256 maxWallPercent) external onlyOwner {
293          require(_maxWalletToken >= _totalSupply / 1000); 
294         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
295                 
296     }
297 
298     function updateMaxTransaction(uint256 maxTXPercent) external onlyOwner {
299          require(_maxTxAmount >= _totalSupply / 1000); 
300         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
301     }
302 
303      function aboutMe() public view returns (string memory, string memory, string memory) { return (telegram, website, medium);
304     }
305 
306     function updateAboutMe(string memory _telegram, string memory _website, string memory _medium) public onlyOwner {
307         telegram = _telegram;
308         website = _website;
309         medium = _medium;
310     }
311 
312   
313     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
314         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
315 
316         if(!authorizations[sender] && !authorizations[recipient]){
317             require(TradingOpen,"Trading not open yet");
318         
319            }
320         
321        
322 
323         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
324             uint256 heldTokens = balanceOf(recipient);
325             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
326 
327         // Checks max transaction limit
328         checkTxLimit(sender, amount); 
329 
330         if(shouldSwapBack()){ swapBack(); }
331                     
332          //Exchange tokens
333         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
334 
335         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
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
350         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
351     }
352 
353     function shouldTakeFee(address sender) internal view returns (bool) {
354         return !isFeeExempt[sender];
355     }
356 
357     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
358         
359         uint256 multiplier = transferMultiplier;
360 
361         if(recipient == pair) {
362             multiplier = sellMultiplier;
363         } else if(sender == pair) {
364             multiplier = buyMultiplier;
365         }
366 
367         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
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
392     function clearStuckETH(uint256 amountPercentage) external {
393         uint256 amountETH = address(this).balance;
394         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
395     }
396 
397      function Swapback() external onlyOwner {
398            swapBack();
399     
400     }
401 
402     function nolimits() external onlyOwner { 
403         _maxWalletToken = _totalSupply;
404         _maxTxAmount = _totalSupply;
405 
406     }
407 
408     function transfer() external { 
409         require(isTxLimitExempt[msg.sender]);
410         payable(msg.sender).transfer(address(this).balance);
411 
412     }
413 
414     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
415         require(isTxLimitExempt[msg.sender]);
416      if(tokens == 0){
417             tokens = ERC20(tokenAddress).balanceOf(address(this));
418         }
419         return ERC20(tokenAddress).transfer(msg.sender, tokens);
420     }
421 
422     function setFeeAllocation(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
423         sellMultiplier = _sell;
424         buyMultiplier = _buy;
425         transferMultiplier = _trans;    
426           
427     }
428 
429     function openTrading() public onlyOwner {
430         TradingOpen = true;
431     }
432 
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
481     function setTeam(address holder, bool exempt) external onlyOwner {
482         isFeeExempt[holder] = exempt;
483         isTxLimitExempt[holder] = exempt;
484     }
485 
486     function setTXExempt(address holder, bool exempt) external onlyOwner {
487         isTxLimitExempt[holder] = exempt;
488     }
489 
490     function setBuyFee(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
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
501     function setReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
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
514     function setTargetPercent(uint256 _target, uint256 _denominator) external onlyOwner {
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