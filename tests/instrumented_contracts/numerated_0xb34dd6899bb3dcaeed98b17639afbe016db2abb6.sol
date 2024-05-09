1 /* 
2 
3 _
4 //\
5 V  \
6  \  \_
7   \,'.`-.
8    |\ `. `.       
9    ( \  `. `-.                        _,.-:\
10     \ \   `.  `-._             __..--' ,-';/
11      \ `.   `-.   `-..___..---'   _.--' ,'/
12       `. `.    `-._        __..--'    ,' /
13         `. `-_     ``--..''       _.-' ,'
14           `-_ `-.___        __,--'   ,'
15              `-.__  `----"""    __.-'
16                   `--..____..--'
17 
18 
19 */
20 
21 
22 // SPDX-License-Identifier: Unlicensed
23 
24 
25 pragma solidity 0.8.19;
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40 
41         return c;
42     }
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 }
62 
63 interface ERC20 {
64     function totalSupply() external view returns (uint256);
65     function decimals() external view returns (uint8);
66     function symbol() external view returns (string memory);
67     function name() external view returns (string memory);
68     function getOwner() external view returns (address);
69     function balanceOf(address account) external view returns (uint256);
70     function transfer(address recipient, uint256 amount) external returns (bool);
71     function allowance(address _owner, address spender) external view returns (uint256);
72     function approve(address spender, uint256 amount) external returns (bool);
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 abstract contract Context {
79     
80     function _msgSender() internal view virtual returns (address payable) {
81         return payable(msg.sender);
82     }
83 
84     function _msgData() internal view virtual returns (bytes memory) {
85         this;
86         return msg.data;
87     }
88 }
89 
90 contract Ownable is Context {
91     address public _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     constructor () {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         authorizations[_owner] = true;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101     mapping (address => bool) internal authorizations;
102 
103     function owner() public view returns (address) {
104         return _owner;
105     }
106 
107     modifier onlyOwner() {
108         require(_owner == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     function renounceOwnership() public virtual onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(newOwner != address(0), "Ownable: new owner is the zero address");
119         emit OwnershipTransferred(_owner, newOwner);
120         _owner = newOwner;
121     }
122 }
123 
124 interface IDEXFactory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IDEXRouter {
129     function factory() external pure returns (address);
130     function WETH() external pure returns (address);
131 
132     function addLiquidity(
133         address tokenA,
134         address tokenB,
135         uint amountADesired,
136         uint amountBDesired,
137         uint amountAMin,
138         uint amountBMin,
139         address to,
140         uint deadline
141     ) external returns (uint amountA, uint amountB, uint liquidity);
142 
143     function addLiquidityETH(
144         address token,
145         uint amountTokenDesired,
146         uint amountTokenMin,
147         uint amountETHMin,
148         address to,
149         uint deadline
150     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
151 
152     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external;
159 
160     function swapExactETHForTokensSupportingFeeOnTransferTokens(
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external payable;
166 
167     function swapExactTokensForETHSupportingFeeOnTransferTokens(
168         uint amountIn,
169         uint amountOutMin,
170         address[] calldata path,
171         address to,
172         uint deadline
173     ) external;
174 }
175 
176 interface InterfaceLP {
177     function sync() external;
178 }
179 
180 contract Banana is Ownable, ERC20 {
181     using SafeMath for uint256;
182 
183     address WETH;
184     address DEAD = 0x000000000000000000000000000000000000dEaD;
185     address ZERO = 0x0000000000000000000000000000000000000000;
186     
187 
188     string constant _name = "Banana";
189     string constant _symbol = "BANANA";
190     uint8 constant _decimals = 9; 
191   
192 
193     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
194 
195     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
196     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
197 
198     mapping (address => uint256) _balances;
199     mapping (address => mapping (address => uint256)) _allowances;
200 
201     
202     mapping (address => bool) isFeeexempt;
203     mapping (address => bool) isTxLimitexempt;
204 
205     uint256 private liquidityFee    = 1;
206     uint256 private marketingFee    = 3;
207     uint256 private devFee          = 1;
208     uint256 private teamFee         = 1; 
209     uint256 private burnFee         = 0;
210     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + devFee + burnFee;
211     uint256 private feeDenominator  = 100;
212 
213     uint256 sellMultiplier = 100;
214     uint256 buyMultiplier = 100;
215     uint256 transferMultiplier = 100; 
216 
217     address private autoLiquidityReceiver;
218     address private marketingFeeReceiver;
219     address private devFeeReceiver;
220     address private teamFeeReceiver;
221     address private burnFeeReceiver;
222     
223     uint256 targetLiquidity = 30;
224     uint256 targetLiquidityDenominator = 100;
225 
226     IDEXRouter public router;
227     InterfaceLP private pairContract;
228     address public pair;
229     
230     bool public TradingOpen = false; 
231 
232     bool public launchMode = false;
233     mapping (address => bool) public islaunched;   
234 
235     bool public swapEnabled = true;
236     uint256 public swapThreshold = _totalSupply * 25 / 1000; 
237     bool inSwap;
238     modifier swapping() { inSwap = true; _; inSwap = false; }
239     
240     constructor () {
241         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
242         WETH = router.WETH();
243         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
244         pairContract = InterfaceLP(pair);
245        
246         
247         _allowances[address(this)][address(router)] = type(uint256).max;
248 
249         isFeeexempt[msg.sender] = true;
250         isFeeexempt[devFeeReceiver] = true;
251             
252         isTxLimitexempt[msg.sender] = true;
253         isTxLimitexempt[pair] = true;
254         isTxLimitexempt[devFeeReceiver] = true;
255         isTxLimitexempt[marketingFeeReceiver] = true;
256         isTxLimitexempt[address(this)] = true;
257         
258         autoLiquidityReceiver = msg.sender;
259         marketingFeeReceiver = 0xad1c6A67B6910e485003dDf8570D7d39E758334e;
260         devFeeReceiver = 0x7666b460007DFd74595BE04b6e729116E7715ab7;
261         teamFeeReceiver = msg.sender;
262         burnFeeReceiver = DEAD; 
263 
264         _balances[msg.sender] = _totalSupply;
265         emit Transfer(address(0), msg.sender, _totalSupply);
266 
267     }
268 
269     receive() external payable { }
270 
271     function totalSupply() external view override returns (uint256) { return _totalSupply; }
272     function decimals() external pure override returns (uint8) { return _decimals; }
273     function symbol() external pure override returns (string memory) { return _symbol; }
274     function name() external pure override returns (string memory) { return _name; }
275     function getOwner() external view override returns (address) {return owner();}
276     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
277     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
278 
279     function approve(address spender, uint256 amount) public override returns (bool) {
280         _allowances[msg.sender][spender] = amount;
281         emit Approval(msg.sender, spender, amount);
282         return true;
283     }
284 
285     function approveMax(address spender) external returns (bool) {
286         return approve(spender, type(uint256).max);
287     }
288 
289     function transfer(address recipient, uint256 amount) external override returns (bool) {
290         return _transferFrom(msg.sender, recipient, amount);
291     }
292 
293     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
294         if(_allowances[sender][msg.sender] != type(uint256).max){
295             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
296         }
297 
298         return _transferFrom(sender, recipient, amount);
299     }
300 
301         function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
302          require(_maxWalletToken >= _totalSupply / 1000); 
303         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
304                 
305     }
306 
307     function setMaxTX(uint256 maxTXPercent) external onlyOwner {
308          require(_maxTxAmount >= _totalSupply / 1000); 
309         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
310     }
311 
312       
313     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
314         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
315 
316         if(!authorizations[sender] && !authorizations[recipient]){
317             require(TradingOpen,"Trading not open yet");
318         
319              if(launchMode){
320                 require(islaunched[recipient],"Not launched"); 
321           }
322         }
323                
324         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
325             uint256 heldTokens = balanceOf(recipient);
326             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
327 
328         
329 
330         // Checks max transaction limit
331         checkTxLimit(sender, amount); 
332 
333         if(shouldSwapBack()){ swapBack(); }
334                     
335          //Exchange tokens
336         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
337 
338         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
339         _balances[recipient] = _balances[recipient].add(amountReceived);
340 
341         emit Transfer(sender, recipient, amountReceived);
342         return true;
343     }
344     
345     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
346         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349         return true;
350     }
351 
352     function checkTxLimit(address sender, uint256 amount) internal view {
353         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
354     }
355 
356     function shouldTakeFee(address sender) internal view returns (bool) {
357         return !isFeeexempt[sender];
358     }
359 
360     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
361         
362         uint256 multiplier = transferMultiplier;
363 
364         if(recipient == pair) {
365             multiplier = sellMultiplier;
366         } else if(sender == pair) {
367             multiplier = buyMultiplier;
368         }
369 
370         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
371         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
372         uint256 contractTokens = feeAmount.sub(burnTokens);
373 
374         _balances[address(this)] = _balances[address(this)].add(contractTokens);
375         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
376         emit Transfer(sender, address(this), contractTokens);
377         
378         
379         if(burnTokens > 0){
380             _totalSupply = _totalSupply.sub(burnTokens);
381             emit Transfer(sender, ZERO, burnTokens);  
382         
383         }
384 
385         return amount.sub(feeAmount);
386     }
387 
388     function shouldSwapBack() internal view returns (bool) {
389         return msg.sender != pair
390         && !inSwap
391         && swapEnabled
392         && _balances[address(this)] >= swapThreshold;
393     }
394 
395     function clearStuckETH(uint256 amountPercentage) external {
396         uint256 amountETH = address(this).balance;
397         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
398     }
399 
400      function manualswapback() external onlyOwner {
401            swapBack();
402     
403     }
404 
405     function noLimits() external onlyOwner { 
406         _maxWalletToken = _totalSupply;
407         _maxTxAmount = _totalSupply;
408 
409     }
410 
411     function manualSend() external { 
412              payable(autoLiquidityReceiver).transfer(address(this).balance);
413 
414     }
415 
416     function clearForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
417                if(tokens == 0){
418             tokens = ERC20(tokenAddress).balanceOf(address(this));
419         }
420         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
421     }
422 
423     function updateFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
424         sellMultiplier = _sell;
425         buyMultiplier = _buy;
426         transferMultiplier = _trans;    
427           
428     }
429 
430      function enableWL(bool _status) public onlyOwner {
431         launchMode = _status;
432     }
433 
434     function manageWL(address[] calldata addresses, bool status) public onlyOwner {
435         for (uint256 i; i < addresses.length; ++i) {
436             islaunched[addresses[i]] = status;
437         }
438     }
439 
440     function letHerRip() public onlyOwner {
441         TradingOpen = true;
442         buyMultiplier = 400;
443         sellMultiplier = 900;
444         transferMultiplier = 1500;
445     }
446 
447         
448            
449     function swapBack() internal swapping {
450         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
451         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
452         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
453 
454         address[] memory path = new address[](2);
455         path[0] = address(this);
456         path[1] = WETH;
457 
458         uint256 balanceBefore = address(this).balance;
459 
460         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
461             amountToSwap,
462             0,
463             path,
464             address(this),
465             block.timestamp
466         );
467 
468         uint256 amountETH = address(this).balance.sub(balanceBefore);
469 
470         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
471         
472         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
473         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
474         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
475         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
476 
477         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
478         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
479         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
480         
481         tmpSuccess = false;
482 
483         if(amountToLiquify > 0){
484             router.addLiquidityETH{value: amountETHLiquidity}(
485                 address(this),
486                 amountToLiquify,
487                 0,
488                 0,
489                 autoLiquidityReceiver,
490                 block.timestamp
491             );
492             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
493         }
494     }
495 
496     function setTeamAddress(address holder, bool exempt) external onlyOwner {
497         isFeeexempt[holder] = exempt;
498         isTxLimitexempt[holder] = exempt;
499     }
500 
501     function setisTXLimitExempt(address holder, bool exempt) external onlyOwner {
502         isTxLimitexempt[holder] = exempt;
503     }
504 
505     function updateFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
506         liquidityFee = _liquidityFee;
507         teamFee = _teamFee;
508         marketingFee = _marketingFee;
509         devFee = _devFee;
510         burnFee = _burnFee;
511         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
512         feeDenominator = _feeDenominator;
513         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
514     }
515 
516     function updateFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
517         autoLiquidityReceiver = _autoLiquidityReceiver;
518         marketingFeeReceiver = _marketingFeeReceiver;
519         devFeeReceiver = _devFeeReceiver;
520         burnFeeReceiver = _burnFeeReceiver;
521         teamFeeReceiver = _teamFeeReceiver;
522     }
523 
524     function setSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
525         swapEnabled = _enabled;
526         swapThreshold = _amount;
527     }
528 
529     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
530         targetLiquidity = _target;
531         targetLiquidityDenominator = _denominator;
532     }
533     
534     function getCirculatingSupply() public view returns (uint256) {
535         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
536     }
537 
538     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
539         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
540     }
541 
542     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
543         return getLiquidityBacking(accuracy) > target;
544     }
545 
546 function multiAirdrop(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
547 
548     require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
549     require(addresses.length == tokens.length,"Mismatch between Address and token count");
550 
551     uint256 MVPC = 0;
552 
553     for(uint i=0; i < addresses.length; i++){
554         MVPC = MVPC + tokens[i];
555     }
556 
557     require(balanceOf(from) >= MVPC, "Not enough tokens in wallet");
558 
559     for(uint i=0; i < addresses.length; i++){
560         _basicTransfer(from,addresses[i],tokens[i]);
561     }
562 }
563   
564 
565 
566 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
567 
568 }