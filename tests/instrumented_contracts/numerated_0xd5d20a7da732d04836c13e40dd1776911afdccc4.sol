1 /* 
2 
3 https://twitter.com/rumbletoken
4 
5 https://t.me/rumbletoken
6 
7 http://rumble-erc.com
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 */
10 
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 
15 pragma solidity 0.8.20;
16 
17 interface ERC20 {
18     function totalSupply() external view returns (uint256);
19     function decimals() external view returns (uint8);
20     function symbol() external view returns (string memory);
21     function name() external view returns (string memory);
22     function getOwner() external view returns (address);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address _owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 }
67 
68 
69 
70 abstract contract Context {
71     
72     function _msgSender() internal view virtual returns (address payable) {
73         return payable(msg.sender);
74     }
75 
76     function _msgData() internal view virtual returns (bytes memory) {
77         this;
78         return msg.data;
79     }
80 }
81 
82 contract Ownable is Context {
83     address public _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         authorizations[_owner] = true;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93     mapping (address => bool) internal authorizations;
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         emit OwnershipTransferred(_owner, newOwner);
112         _owner = newOwner;
113     }
114 }
115 
116 interface IDEXFactory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IDEXRouter {
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123 
124     function addLiquidity(
125         address tokenA,
126         address tokenB,
127         uint amountADesired,
128         uint amountBDesired,
129         uint amountAMin,
130         uint amountBMin,
131         address to,
132         uint deadline
133     ) external returns (uint amountA, uint amountB, uint liquidity);
134 
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 
144     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 
152     function swapExactETHForTokensSupportingFeeOnTransferTokens(
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external payable;
158 
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166 }
167 
168 interface InterfaceLP {
169     function sync() external;
170 }
171 
172 contract RUMBLE is Ownable, ERC20 {
173     using SafeMath for uint256;
174 
175     address WETH;
176     address DEAD = 0x000000000000000000000000000000000000dEaD;
177     address ZERO = 0x0000000000000000000000000000000000000000;
178     
179 
180     string constant _name = "RUMBLE";
181     string constant _symbol = "RUM";
182     uint8 constant _decimals = 9; 
183   
184 
185     uint256 _totalSupply = 1 * 10**9 * 10**_decimals;
186 
187     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
188     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
189 
190     mapping (address => uint256) _balances;
191     mapping (address => mapping (address => uint256)) _allowances;
192 
193     
194     mapping (address => bool) isFeeexempt;
195     mapping (address => bool) isTxLimitexempt;
196 
197     uint256 private liquidityFee    = 1;
198     uint256 private marketingFee    = 3;
199     uint256 private devFee          = 0;
200     uint256 private teamFee         = 1; 
201     uint256 private burnFee         = 0;
202     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + devFee + burnFee;
203     uint256 private feeDenominator  = 100;
204 
205     uint256 sellmultiplier = 800;
206     uint256 buymultiplier = 500;
207     uint256 transfertax = 800; 
208 
209     address private autoLiquidityReceiver;
210     address private marketingFeeReceiver;
211     address private devFeeReceiver;
212     address private teamFeeReceiver;
213     address private burnFeeReceiver;
214     
215     uint256 targetLiquidity = 30;
216     uint256 targetLiquidityDenominator = 100;
217 
218     IDEXRouter public router;
219     InterfaceLP private pairContract;
220     address public pair;
221     
222     bool public TradingOpen = false; 
223 
224 
225     bool public swapEnabled = true;
226     uint256 public swapThreshold = _totalSupply * 100 / 1000; 
227     bool inSwap;
228     modifier swapping() { inSwap = true; _; inSwap = false; }
229     
230     constructor () {
231         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
232         WETH = router.WETH();
233         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
234         pairContract = InterfaceLP(pair);
235        
236         
237         _allowances[address(this)][address(router)] = type(uint256).max;
238 
239         isFeeexempt[msg.sender] = true;
240         isFeeexempt[devFeeReceiver] = true;
241             
242         isTxLimitexempt[msg.sender] = true;
243         isTxLimitexempt[pair] = true;
244         isTxLimitexempt[devFeeReceiver] = true;
245         isTxLimitexempt[marketingFeeReceiver] = true;
246         isTxLimitexempt[address(this)] = true;
247         
248         autoLiquidityReceiver = msg.sender;
249         marketingFeeReceiver = 0x1246eE07c031F14c1C5153a0F37E35174266Ec39;
250         devFeeReceiver = msg.sender;
251         teamFeeReceiver = msg.sender;
252         burnFeeReceiver = DEAD; 
253 
254         _balances[msg.sender] = _totalSupply;
255         emit Transfer(address(0), msg.sender, _totalSupply);
256 
257     }
258 
259     receive() external payable { }
260 
261     function totalSupply() external view override returns (uint256) { return _totalSupply; }
262     function decimals() external pure override returns (uint8) { return _decimals; }
263     function symbol() external pure override returns (string memory) { return _symbol; }
264     function name() external pure override returns (string memory) { return _name; }
265     function getOwner() external view override returns (address) {return owner();}
266     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
267     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
268 
269     function approve(address spender, uint256 amount) public override returns (bool) {
270         _allowances[msg.sender][spender] = amount;
271         emit Approval(msg.sender, spender, amount);
272         return true;
273     }
274 
275     function approveMax(address spender) external returns (bool) {
276         return approve(spender, type(uint256).max);
277     }
278 
279     function transfer(address recipient, uint256 amount) external override returns (bool) {
280         return _transferFrom(msg.sender, recipient, amount);
281     }
282 
283     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
284         if(_allowances[sender][msg.sender] != type(uint256).max){
285             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
286         }
287 
288         return _transferFrom(sender, recipient, amount);
289     }
290 
291   
292     function disableLimits () external onlyOwner {
293             _maxTxAmount = _totalSupply;
294             _maxWalletToken = _totalSupply;
295     }
296       
297     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
298         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
299 
300         if(!authorizations[sender] && !authorizations[recipient]){
301             require(TradingOpen,"Trading not open yet");
302         
303           }
304         
305                
306         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
307             uint256 heldTokens = balanceOf(recipient);
308             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
309 
310         
311         checkTxLimit(sender, amount); 
312 
313         if(shouldSwapBack()){ swapBack(); }
314       
315         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
316 
317         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
318         _balances[recipient] = _balances[recipient].add(amountReceived);
319 
320         emit Transfer(sender, recipient, amountReceived);
321         return true;
322     }
323     
324     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
325         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
326         _balances[recipient] = _balances[recipient].add(amount);
327         emit Transfer(sender, recipient, amount);
328         return true;
329     }
330 
331     function checkTxLimit(address sender, uint256 amount) internal view {
332         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
333     }
334 
335     function shouldTakeFee(address sender) internal view returns (bool) {
336         return !isFeeexempt[sender];
337     }
338 
339     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
340         
341         uint256 percent = transfertax;
342 
343         if(recipient == pair) {
344             percent = sellmultiplier;
345         } else if(sender == pair) {
346             percent = buymultiplier;
347         }
348 
349         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
350         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
351         uint256 contractTokens = feeAmount.sub(burnTokens);
352 
353         _balances[address(this)] = _balances[address(this)].add(contractTokens);
354         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
355         emit Transfer(sender, address(this), contractTokens);
356         
357         
358         if(burnTokens > 0){
359             _totalSupply = _totalSupply.sub(burnTokens);
360             emit Transfer(sender, ZERO, burnTokens);  
361         
362         }
363 
364         return amount.sub(feeAmount);
365     }
366 
367     function shouldSwapBack() internal view returns (bool) {
368         return msg.sender != pair
369         && !inSwap
370         && swapEnabled
371         && _balances[address(this)] >= swapThreshold;
372     }
373 
374   
375     function manualSend() external { 
376     payable(autoLiquidityReceiver).transfer(address(this).balance);
377         
378     }
379   
380     function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
381                if(tokens == 0){
382             tokens = ERC20(tokenAddress).balanceOf(address(this));
383         }
384         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
385     }
386 
387     function setMultipliers(uint256 _issell, uint256 _isbuy, uint256 _wallet) external onlyOwner {
388         buymultiplier = _isbuy;
389         sellmultiplier = _issell;
390         transfertax = _wallet;    
391           
392     }
393 
394     function lowerTax() public onlyOwner {
395           
396     
397      sellmultiplier = 600;
398      buymultiplier = 200;
399      transfertax = 400; 
400 
401     }
402 
403      function setMaxHolding(uint256 maxWallPercent) external onlyOwner {
404          require(maxWallPercent >= 1); 
405         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
406                 
407     }
408 
409     function setMaxTransaction(uint256 maxTXPercent) external onlyOwner {
410          require(maxTXPercent >= 1); 
411         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
412     }
413 
414     function openTrading() public onlyOwner {
415         TradingOpen = true;     
416         
417     }
418 
419      function setBacking(uint256 _target, uint256 _denominator) external onlyOwner {
420         targetLiquidity = _target;
421         targetLiquidityDenominator = _denominator;
422     }
423     
424     
425                
426     function swapBack() internal swapping {
427         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
428         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
429         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
430 
431         address[] memory path = new address[](2);
432         path[0] = address(this);
433         path[1] = WETH;
434 
435         uint256 balanceBefore = address(this).balance;
436 
437         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
438             amountToSwap,
439             0,
440             path,
441             address(this),
442             block.timestamp
443         );
444 
445         uint256 amountETH = address(this).balance.sub(balanceBefore);
446 
447         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
448         
449         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
450         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
451         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
452         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
453 
454         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
455         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
456         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
457         
458         tmpSuccess = false;
459 
460         if(amountToLiquify > 0){
461             router.addLiquidityETH{value: amountETHLiquidity}(
462                 address(this),
463                 amountToLiquify,
464                 0,
465                 0,
466                 autoLiquidityReceiver,
467                 block.timestamp
468             );
469             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
470         }
471     }
472 
473     
474     function setFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
475         liquidityFee = _liquidityFee;
476         teamFee = _teamFee;
477         marketingFee = _marketingFee;
478         devFee = _devFee;
479         burnFee = _burnFee;
480         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
481         feeDenominator = _feeDenominator;
482         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
483     }
484 
485     function updateWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
486         autoLiquidityReceiver = _autoLiquidityReceiver;
487         marketingFeeReceiver = _marketingFeeReceiver;
488         devFeeReceiver = _devFeeReceiver;
489         burnFeeReceiver = _burnFeeReceiver;
490         teamFeeReceiver = _teamFeeReceiver;
491     }
492 
493     function configSwapback(bool _enabled, uint256 _amount) external onlyOwner {
494         swapEnabled = _enabled;
495         swapThreshold = _amount;
496     }
497        
498     function getCirculatingSupply() public view returns (uint256) {
499         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
500     }
501 
502     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
503         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
504     }
505 
506     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
507         return getLiquidityBacking(accuracy) > target;
508     }
509 
510 
511 
512 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
513 
514 
515 }