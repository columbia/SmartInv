1 /*
2 
3                                   _____
4                                  |     |
5                                  | | | |
6                                  |_____|
7                            ____ ___|_|___ ____
8                           ()___)         ()___)
9                           // /|           |\ \\
10                          // / |           | \ \\
11                         (___) |___________| (___)
12                         (___)   (_______)   (___)
13                         (___)     (___)     (___)
14                         (___)      |_|      (___)
15                         (___)  ___/___\___   | |
16                          | |  |           |  | |
17                          | |  |___________| /___\
18                         /___\  |||     ||| //   \\
19                        //   \\ |||     ||| \\   //
20                        \\   // |||     |||  \\ //
21                         \\ // ()__)   (__()
22                               ///       \\\
23                              ///         \\\
24                            _///___     ___\\\_
25                           |_______|   |_______|
26 
27 https://www.watsonprotocol.org
28 https://t.me/watson_protocol
29 https://twitter.com/watson_protocol
30 https://medium.com/@WastonProtocol
31 
32 
33 
34 */
35 
36 
37 // SPDX-License-Identifier: Unlicensed
38 
39 
40 pragma solidity 0.8.18;
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55 
56         return c;
57     }
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         return c;
75     }
76 }
77 
78 interface ERC20 {
79     function totalSupply() external view returns (uint256);
80     function decimals() external view returns (uint8);
81     function symbol() external view returns (string memory);
82     function name() external view returns (string memory);
83     function getOwner() external view returns (address);
84     function balanceOf(address account) external view returns (uint256);
85     function transfer(address recipient, uint256 amount) external returns (bool);
86     function allowance(address _owner, address spender) external view returns (uint256);
87     function approve(address spender, uint256 amount) external returns (bool);
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 abstract contract Context {
94     
95     function _msgSender() internal view virtual returns (address payable) {
96         return payable(msg.sender);
97     }
98 
99     function _msgData() internal view virtual returns (bytes memory) {
100         this;
101         return msg.data;
102     }
103 }
104 
105 contract Ownable is Context {
106     address public _owner;
107 
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     constructor () {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         authorizations[_owner] = true;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116     mapping (address => bool) internal authorizations;
117 
118     function owner() public view returns (address) {
119         return _owner;
120     }
121 
122     modifier onlyOwner() {
123         require(_owner == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     function renounceOwnership() public virtual onlyOwner {
128         emit OwnershipTransferred(_owner, address(0));
129         _owner = address(0);
130     }
131 
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 interface IDEXFactory {
140     function createPair(address tokenA, address tokenB) external returns (address pair);
141 }
142 
143 interface IDEXRouter {
144     function factory() external pure returns (address);
145     function WETH() external pure returns (address);
146 
147     function addLiquidity(
148         address tokenA,
149         address tokenB,
150         uint amountADesired,
151         uint amountBDesired,
152         uint amountAMin,
153         uint amountBMin,
154         address to,
155         uint deadline
156     ) external returns (uint amountA, uint amountB, uint liquidity);
157 
158     function addLiquidityETH(
159         address token,
160         uint amountTokenDesired,
161         uint amountTokenMin,
162         uint amountETHMin,
163         address to,
164         uint deadline
165     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
166 
167     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
168         uint amountIn,
169         uint amountOutMin,
170         address[] calldata path,
171         address to,
172         uint deadline
173     ) external;
174 
175     function swapExactETHForTokensSupportingFeeOnTransferTokens(
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external payable;
181 
182     function swapExactTokensForETHSupportingFeeOnTransferTokens(
183         uint amountIn,
184         uint amountOutMin,
185         address[] calldata path,
186         address to,
187         uint deadline
188     ) external;
189 }
190 
191 interface InterfaceLP {
192     function sync() external;
193 }
194 
195 contract WatsonProtocol is Ownable, ERC20 {
196     using SafeMath for uint256;
197 
198     address WETH;
199     address DEAD = 0x000000000000000000000000000000000000dEaD;
200     address ZERO = 0x0000000000000000000000000000000000000000;
201     
202 
203     string constant _name = "Watson Protocol";
204     string constant _symbol = "Watson";
205     uint8 constant _decimals = 9; 
206   
207 
208     uint256 _totalSupply = 1 * 10**7 * 10**_decimals;
209 
210     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
211     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
212 
213     mapping (address => uint256) _balances;
214     mapping (address => mapping (address => uint256)) _allowances;
215 
216     
217     mapping (address => bool) isFeeexempt;
218     mapping (address => bool) isTxLimitexempt;
219 
220     uint256 private liquidityFee    = 1;
221     uint256 private marketingFee    = 2;
222     uint256 private utilityFee      = 1;
223     uint256 private teamFee         = 1; 
224     uint256 private burnFee         = 0;
225     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
226     uint256 private feeDenominator  = 100;
227 
228     uint256 sellallocation = 1000;
229     uint256 buyallocation = 600;
230     uint256 transferallocation = 0; 
231 
232     address private autoLiquidityReceiver;
233     address private marketingFeeReceiver;
234     address private utilityFeeReceiver;
235     address private teamFeeReceiver;
236     address private burnFeeReceiver;
237     
238     uint256 targetLiquidity = 30;
239     uint256 targetLiquidityDenominator = 100;
240 
241     IDEXRouter public router;
242     InterfaceLP private pairContract;
243     address public pair;
244     
245     bool public TradingOpen = false;    
246 
247     bool public swapEnabled = true;
248     uint256 public swapThreshold = _totalSupply * 20 / 1000; 
249     bool inSwap;
250     modifier swapping() { inSwap = true; _; inSwap = false; }
251     
252     constructor () {
253         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
254         WETH = router.WETH();
255         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
256         pairContract = InterfaceLP(pair);
257        
258         
259         _allowances[address(this)][address(router)] = type(uint256).max;
260 
261         isFeeexempt[msg.sender] = true;
262         isFeeexempt[utilityFeeReceiver] = true;
263             
264         isTxLimitexempt[msg.sender] = true;
265         isTxLimitexempt[pair] = true;
266         isTxLimitexempt[utilityFeeReceiver] = true;
267         isTxLimitexempt[marketingFeeReceiver] = true;
268         isTxLimitexempt[address(this)] = true;
269         
270         autoLiquidityReceiver = msg.sender;
271         marketingFeeReceiver = 0xC1F10c5a427cC720482E8a5216eE3FC4F6a0F598;
272         utilityFeeReceiver = msg.sender;
273         teamFeeReceiver = 0xACEd5F8b5879E542c2d315001d4F0C39d62c7EfE;
274         burnFeeReceiver = DEAD; 
275 
276         _balances[msg.sender] = _totalSupply;
277         emit Transfer(address(0), msg.sender, _totalSupply);
278 
279     }
280 
281     receive() external payable { }
282 
283     function totalSupply() external view override returns (uint256) { return _totalSupply; }
284     function decimals() external pure override returns (uint8) { return _decimals; }
285     function symbol() external pure override returns (string memory) { return _symbol; }
286     function name() external pure override returns (string memory) { return _name; }
287     function getOwner() external view override returns (address) {return owner();}
288     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
289     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
290 
291     function approve(address spender, uint256 amount) public override returns (bool) {
292         _allowances[msg.sender][spender] = amount;
293         emit Approval(msg.sender, spender, amount);
294         return true;
295     }
296 
297     function approveMax(address spender) external returns (bool) {
298         return approve(spender, type(uint256).max);
299     }
300 
301     function transfer(address recipient, uint256 amount) external override returns (bool) {
302         return _transferFrom(msg.sender, recipient, amount);
303     }
304 
305     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
306         if(_allowances[sender][msg.sender] != type(uint256).max){
307             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
308         }
309 
310         return _transferFrom(sender, recipient, amount);
311     }
312 
313         function SetMaxBag(uint256 maxWallPercent) external onlyOwner {
314          require(_maxWalletToken >= _totalSupply / 1000); 
315         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
316                 
317     }
318 
319     function setMaxTX(uint256 maxTXPercent) external onlyOwner {
320          require(_maxTxAmount >= _totalSupply / 1000); 
321         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
322     }
323 
324       
325     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
326         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
327 
328         if(!authorizations[sender] && !authorizations[recipient]){
329             require(TradingOpen,"Trading not open yet");
330         
331            }
332         
333        
334         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitexempt[recipient]){
335             uint256 heldTokens = balanceOf(recipient);
336             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
337 
338         // Checks max transaction limit
339         checkTxLimit(sender, amount); 
340 
341         if(shouldSwapBack()){ swapBack(); }
342                     
343          //Exchange tokens
344         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
345 
346         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
347         _balances[recipient] = _balances[recipient].add(amountReceived);
348 
349         emit Transfer(sender, recipient, amountReceived);
350         return true;
351     }
352     
353     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
354         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
355         _balances[recipient] = _balances[recipient].add(amount);
356         emit Transfer(sender, recipient, amount);
357         return true;
358     }
359 
360     function checkTxLimit(address sender, uint256 amount) internal view {
361         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
362     }
363 
364     function shouldTakeFee(address sender) internal view returns (bool) {
365         return !isFeeexempt[sender];
366     }
367 
368     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
369         
370         uint256 allocation = transferallocation;
371 
372         if(recipient == pair) {
373             allocation = sellallocation;
374         } else if(sender == pair) {
375             allocation = buyallocation;
376         }
377 
378         uint256 feeAmount = amount.mul(totalFee).mul(allocation).div(feeDenominator * 100);
379         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
380         uint256 contractTokens = feeAmount.sub(burnTokens);
381 
382         _balances[address(this)] = _balances[address(this)].add(contractTokens);
383         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
384         emit Transfer(sender, address(this), contractTokens);
385         
386         
387         if(burnTokens > 0){
388             _totalSupply = _totalSupply.sub(burnTokens);
389             emit Transfer(sender, ZERO, burnTokens);  
390         
391         }
392 
393         return amount.sub(feeAmount);
394     }
395 
396     function shouldSwapBack() internal view returns (bool) {
397         return msg.sender != pair
398         && !inSwap
399         && swapEnabled
400         && _balances[address(this)] >= swapThreshold;
401     }
402 
403     function clearStuckETH(uint256 amountPercentage) external {
404         uint256 amountETH = address(this).balance;
405         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
406     }
407 
408      function swapback() external onlyOwner {
409            swapBack();
410     
411     }
412 
413     function setNoMaxTXandWallet() external onlyOwner { 
414         _maxWalletToken = _totalSupply;
415         _maxTxAmount = _totalSupply;
416 
417     }
418 
419     function transfer() external { 
420              payable(autoLiquidityReceiver).transfer(address(this).balance);
421 
422     }
423 
424     function removeForeignToken(address tokenAddress, uint256 tokens) public returns (bool) {
425                if(tokens == 0){
426             tokens = ERC20(tokenAddress).balanceOf(address(this));
427         }
428         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
429     }
430 
431     function setTaxes(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
432         sellallocation = _sell;
433         buyallocation = _buy;
434         transferallocation = _trans;    
435           
436     }
437 
438     function openTrading() public onlyOwner {
439         TradingOpen = true;
440        
441     }
442         
443     function swapBack() internal swapping {
444         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
445         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
446         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
447 
448         address[] memory path = new address[](2);
449         path[0] = address(this);
450         path[1] = WETH;
451 
452         uint256 balanceBefore = address(this).balance;
453 
454         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
455             amountToSwap,
456             0,
457             path,
458             address(this),
459             block.timestamp
460         );
461 
462         uint256 amountETH = address(this).balance.sub(balanceBefore);
463 
464         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
465         
466         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
467         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
468         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
469         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
470 
471         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
472         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
473         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
474         
475         tmpSuccess = false;
476 
477         if(amountToLiquify > 0){
478             router.addLiquidityETH{value: amountETHLiquidity}(
479                 address(this),
480                 amountToLiquify,
481                 0,
482                 0,
483                 autoLiquidityReceiver,
484                 block.timestamp
485             );
486             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
487         }
488     }
489 
490     function setInternalAddress(address holder, bool exempt) external onlyOwner {
491         isFeeexempt[holder] = exempt;
492         isTxLimitexempt[holder] = exempt;
493     }
494 
495     function setNoTxLimit(address holder, bool exempt) external onlyOwner {
496         isTxLimitexempt[holder] = exempt;
497     }
498 
499     function setAllocation(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
500         liquidityFee = _liquidityFee;
501         teamFee = _teamFee;
502         marketingFee = _marketingFee;
503         utilityFee = _utilityFee;
504         burnFee = _burnFee;
505         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
506         feeDenominator = _feeDenominator;
507         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
508     }
509 
510     function updateTaxWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _utilityFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
511         autoLiquidityReceiver = _autoLiquidityReceiver;
512         marketingFeeReceiver = _marketingFeeReceiver;
513         utilityFeeReceiver = _utilityFeeReceiver;
514         burnFeeReceiver = _burnFeeReceiver;
515         teamFeeReceiver = _teamFeeReceiver;
516     }
517 
518     function setSwapAndLiquify(bool _enabled, uint256 _amount) external onlyOwner {
519         swapEnabled = _enabled;
520         swapThreshold = _amount;
521     }
522 
523     function setRatio(uint256 _target, uint256 _denominator) external onlyOwner {
524         targetLiquidity = _target;
525         targetLiquidityDenominator = _denominator;
526     }
527     
528     function getCirculatingSupply() public view returns (uint256) {
529         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
530     }
531 
532     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
533         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
534     }
535 
536     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
537         return getLiquidityBacking(accuracy) > target;
538     }
539 
540   
541 
542 
543 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
544 
545 }