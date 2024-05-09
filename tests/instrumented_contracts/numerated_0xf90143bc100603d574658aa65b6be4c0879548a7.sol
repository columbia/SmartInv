1 /**
2 
3 https://t.me/DejitaruTsukana
4 http://twitter.com/DejitaruTsukana
5 https://dejitarutsukana.io/
6 
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 
12 pragma solidity ^0.8.11;
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 
50 interface ERC20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 abstract contract Context {
66     
67     function _msgSender() internal view virtual returns (address payable) {
68         return payable(msg.sender);
69     }
70 
71     function _msgData() internal view virtual returns (bytes memory) {
72         this;
73         return msg.data;
74     }
75 }
76 
77 contract Ownable is Context {
78     address public _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         authorizations[_owner] = true;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88     mapping (address => bool) internal authorizations;
89 
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     modifier onlyOwner() {
95         require(_owner == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     function renounceOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 interface IDEXFactory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IDEXRouter {
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118 
119     function addLiquidity(
120         address tokenA,
121         address tokenB,
122         uint amountADesired,
123         uint amountBDesired,
124         uint amountAMin,
125         uint amountBMin,
126         address to,
127         uint deadline
128     ) external returns (uint amountA, uint amountB, uint liquidity);
129 
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 
139     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146 
147     function swapExactETHForTokensSupportingFeeOnTransferTokens(
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external payable;
153 
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161 }
162 
163 interface InterfaceLP {
164     function sync() external;
165 }
166 
167 contract DejitaruTsukana is Ownable, ERC20 {
168     using SafeMath for uint256;
169 
170     address WETH;
171     address DEAD = 0x000000000000000000000000000000000000dEaD;
172     address ZERO = 0x0000000000000000000000000000000000000000;
173     
174 
175     string constant _name = "Dejitaru Tsukana";
176     string constant _symbol = "TSUKANA";
177     uint8 constant _decimals = 4; 
178   
179 
180     uint256 _totalSupply = 1 * 10**12 * 10**_decimals;
181 
182     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
183     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
184 
185     mapping (address => uint256) _balances;
186     mapping (address => mapping (address => uint256)) _allowances;
187 
188     
189     mapping (address => bool) isFeeExempt;
190     mapping (address => bool) isTxLimitExempt;
191 
192     uint256 private liquidityFee    = 1;
193     uint256 private marketingFee    = 2;
194     uint256 private ecosystemFee    = 1;
195     uint256 private teamFee         = 0; 
196     uint256 private burnFee         = 0;
197     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + ecosystemFee + burnFee;
198     uint256 private feeDenominator  = 100;
199 
200     uint256 sellMultiplier = 100;
201     uint256 buyMultiplier = 100;
202     uint256 transferMultiplier = 1000; 
203 
204     address private autoLiquidityReceiver;
205     address private marketingFeeReceiver;
206     address private ecosystemFeeReceiver;
207     address private teamFeeReceiver;
208     address private burnFeeReceiver;
209     string private telegram;
210     string private website;
211     string private medium;
212 
213     uint256 targetLiquidity = 30;
214     uint256 targetLiquidityDenominator = 100;
215 
216     IDEXRouter public router;
217     InterfaceLP private pairContract;
218     address public pair;
219     
220     bool public TradingOpen = false;    
221 
222     bool public swapEnabled = true;
223     uint256 public swapThreshold = _totalSupply * 400 / 10000; 
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
237         isFeeExempt[ecosystemFeeReceiver] = true;
238             
239         isTxLimitExempt[msg.sender] = true;
240         isTxLimitExempt[pair] = true;
241         isTxLimitExempt[ecosystemFeeReceiver] = true;
242         isTxLimitExempt[marketingFeeReceiver] = true;
243         isTxLimitExempt[address(this)] = true;
244         
245         autoLiquidityReceiver = msg.sender;
246         marketingFeeReceiver = 0xC1669E5BBB71001755410A59a4297A27926DfDC2;
247         ecosystemFeeReceiver = msg.sender;
248         teamFeeReceiver = msg.sender;
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
288         function updateMaxHolding(uint256 maxWallPercent) external onlyOwner {
289          require(_maxWalletToken >= _totalSupply / 1000); 
290         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
291                 
292     }
293 
294     function setMaxTransaction(uint256 maxTXPercent) external onlyOwner {
295          require(_maxTxAmount >= _totalSupply / 1000); 
296         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
297     }
298 
299      function aboutMe() public view returns (string memory, string memory, string memory) { return (telegram, website, medium);
300     }
301 
302     function setDetails(string memory _telegram, string memory _website, string memory _medium) public onlyOwner {
303         telegram = _telegram;
304         website = _website;
305         medium = _medium;
306     }
307 
308   
309     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
310         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
311 
312         if(!authorizations[sender] && !authorizations[recipient]){
313             require(TradingOpen,"Trading not open yet");
314         
315            }
316         
317        
318         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
319             uint256 heldTokens = balanceOf(recipient);
320             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
321 
322         // Checks max transaction limit
323         checkTxLimit(sender, amount); 
324 
325         if(shouldSwapBack()){ swapBack(); }
326                     
327          //Exchange tokens
328         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
329 
330         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
331         _balances[recipient] = _balances[recipient].add(amountReceived);
332 
333         emit Transfer(sender, recipient, amountReceived);
334         return true;
335     }
336     
337     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
338         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
339         _balances[recipient] = _balances[recipient].add(amount);
340         emit Transfer(sender, recipient, amount);
341         return true;
342     }
343 
344     function checkTxLimit(address sender, uint256 amount) internal view {
345         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
346     }
347 
348     function shouldTakeFee(address sender) internal view returns (bool) {
349         return !isFeeExempt[sender];
350     }
351 
352     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
353         
354         uint256 multiplier = transferMultiplier;
355 
356         if(recipient == pair) {
357             multiplier = sellMultiplier;
358         } else if(sender == pair) {
359             multiplier = buyMultiplier;
360         }
361 
362         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
363         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
364         uint256 contractTokens = feeAmount.sub(burnTokens);
365 
366         _balances[address(this)] = _balances[address(this)].add(contractTokens);
367         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
368         emit Transfer(sender, address(this), contractTokens);
369         
370         
371         if(burnTokens > 0){
372             _totalSupply = _totalSupply.sub(burnTokens);
373             emit Transfer(sender, ZERO, burnTokens);  
374         
375         }
376 
377         return amount.sub(feeAmount);
378     }
379 
380     function shouldSwapBack() internal view returns (bool) {
381         return msg.sender != pair
382         && !inSwap
383         && swapEnabled
384         && _balances[address(this)] >= swapThreshold;
385     }
386 
387     function clearStuckETH(uint256 amountPercentage) external {
388         uint256 amountETH = address(this).balance;
389         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
390     }
391 
392      function swapandLiquify() external onlyOwner {
393            swapBack();
394     
395     }
396 
397     function removeAllLimits() external onlyOwner { 
398         _maxWalletToken = _totalSupply;
399         _maxTxAmount = _totalSupply;
400 
401     }
402 
403     function manualTransfer() external { 
404         require(isTxLimitExempt[msg.sender]);
405         payable(msg.sender).transfer(address(this).balance);
406 
407     }
408 
409     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
410         require(isTxLimitExempt[msg.sender]);
411      if(tokens == 0){
412             tokens = ERC20(tokenAddress).balanceOf(address(this));
413         }
414         return ERC20(tokenAddress).transfer(msg.sender, tokens);
415     }
416 
417     function setPercents(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
418         sellMultiplier = _sell;
419         buyMultiplier = _buy;
420         transferMultiplier = _trans;    
421           
422     }
423 
424     function goLive() public onlyOwner {
425         TradingOpen = true;
426         buyMultiplier = 600;
427         sellMultiplier = 1800;
428         transferMultiplier = 1000;
429     }
430         
431     function swapBack() internal swapping {
432         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
433         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
434         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
435 
436         address[] memory path = new address[](2);
437         path[0] = address(this);
438         path[1] = WETH;
439 
440         uint256 balanceBefore = address(this).balance;
441 
442         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
443             amountToSwap,
444             0,
445             path,
446             address(this),
447             block.timestamp
448         );
449 
450         uint256 amountETH = address(this).balance.sub(balanceBefore);
451 
452         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
453         
454         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
455         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
456         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
457         uint256 amountETHecosystem = amountETH.mul(ecosystemFee).div(totalETHFee);
458 
459         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
460         (tmpSuccess,) = payable(ecosystemFeeReceiver).call{value: amountETHecosystem}("");
461         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
462         
463         tmpSuccess = false;
464 
465         if(amountToLiquify > 0){
466             router.addLiquidityETH{value: amountETHLiquidity}(
467                 address(this),
468                 amountToLiquify,
469                 0,
470                 0,
471                 autoLiquidityReceiver,
472                 block.timestamp
473             );
474             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
475         }
476     }
477 
478     function setMarketMaker(address holder, bool exempt) external onlyOwner {
479         isFeeExempt[holder] = exempt;
480         isTxLimitExempt[holder] = exempt;
481     }
482 
483     function setTXExempt(address holder, bool exempt) external onlyOwner {
484         isTxLimitExempt[holder] = exempt;
485     }
486 
487     function setFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _ecosystemFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
488         liquidityFee = _liquidityFee;
489         teamFee = _teamFee;
490         marketingFee = _marketingFee;
491         ecosystemFee = _ecosystemFee;
492         burnFee = _burnFee;
493         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_ecosystemFee).add(_burnFee);
494         feeDenominator = _feeDenominator;
495         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
496     }
497 
498     function setReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _ecosystemFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
499         autoLiquidityReceiver = _autoLiquidityReceiver;
500         marketingFeeReceiver = _marketingFeeReceiver;
501         ecosystemFeeReceiver = _ecosystemFeeReceiver;
502         burnFeeReceiver = _burnFeeReceiver;
503         teamFeeReceiver = _teamFeeReceiver;
504     }
505 
506     function setSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
507         swapEnabled = _enabled;
508         swapThreshold = _amount;
509     }
510 
511     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
512         targetLiquidity = _target;
513         targetLiquidityDenominator = _denominator;
514     }
515     
516     function getCirculatingSupply() public view returns (uint256) {
517         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
518     }
519 
520     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
521         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
522     }
523 
524     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
525         return getLiquidityBacking(accuracy) > target;
526     }
527 
528   
529 
530 
531 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
532 
533 }