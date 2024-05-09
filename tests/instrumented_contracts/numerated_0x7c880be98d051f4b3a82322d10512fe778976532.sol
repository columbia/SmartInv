1 /*
2 
3 
4 ░█████╗░███████╗██████╗░░█████╗░████████╗██╗░░░██╗███╗░░██╗███████╗
5 ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚══██╔══╝╚██╗░██╔╝████╗░██║██╔════╝
6 ███████║█████╗░░██████╔╝██║░░██║░░░██║░░░░╚████╔╝░██╔██╗██║█████╗░░
7 ██╔══██║██╔══╝░░██╔══██╗██║░░██║░░░██║░░░░░╚██╔╝░░██║╚████║██╔══╝░░
8 ██║░░██║███████╗██║░░██║╚█████╔╝░░░██║░░░░░░██║░░░██║░╚███║███████╗
9 ╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░░░░╚═╝░░░╚═╝░░╚══╝╚══════╝
10 
11 https://twitter.com/Aerotyneerc20
12 https://t.me/aerotyne_eth
13 https://aerotyne.vip/
14 
15 */
16 pragma solidity ^0.8.17;
17 // SPDX-License-Identifier: MIT
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
171 contract AEROTYNE is Ownable, ERC20 {
172     using SafeMath for uint256;
173 
174     address WETH;
175     address DEAD = 0x000000000000000000000000000000000000dEaD;
176     address ZERO = 0x0000000000000000000000000000000000000000;
177     
178     string constant _name = "AEROTYNE";
179     string constant _symbol = "ATYNE";
180     uint8 constant _decimals = 9; 
181 
182     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
183 
184     uint256 public _maxTxAmount = 20_000_001 * (10 ** _decimals);
185     uint256 public _maxWalletToken = 20_000_001 * (10 ** _decimals);
186 
187     mapping (address => uint256) _balances;
188     mapping (address => mapping (address => uint256)) _allowances;
189 
190     mapping (address => bool) isFeeExempt;
191     mapping (address => bool) isTxLimitExempt;
192     mapping (address => bool) private _isBot;
193 
194     uint256 private liquidityFee    = 0;
195     uint256 private marketingFee    = 8;
196     uint256 private utilityFee      = 2;
197     uint256 private teamFee         = 0; 
198     uint256 private burnFee         = 0;
199     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + utilityFee + burnFee;
200     uint256 private feeDenominator  = 100;
201 
202     uint256 sellMultiplier = 100;
203     uint256 buyMultiplier = 100;
204     uint256 transferMultiplier = 1000; 
205 
206     address private autoLiquidityReceiver;
207     address private marketingFeeReceiver;
208     address private utilityFeeReceiver;
209     address private teamFeeReceiver;
210     address private burnFeeReceiver;
211 
212     uint256 targetLiquidity = 20;
213     uint256 targetLiquidityDenominator = 100;
214 
215     IDEXRouter public router;
216     InterfaceLP private pairContract;
217     address public pair;
218     
219     bool public TradingOpen = false;    
220 
221     bool public swapEnabled = true;
222     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
223     bool inSwap;
224     modifier swapping() { inSwap = true; _; inSwap = false; }
225     
226     constructor () {
227         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         WETH = router.WETH();
229         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
230         pairContract = InterfaceLP(pair);
231        
232         
233         _allowances[address(this)][address(router)] = type(uint256).max;
234 
235         isFeeExempt[msg.sender] = true;
236         isFeeExempt[utilityFeeReceiver] = true;
237         isFeeExempt[marketingFeeReceiver] = true;
238             
239         isTxLimitExempt[msg.sender] = true;
240         isTxLimitExempt[pair] = true;
241         isTxLimitExempt[utilityFeeReceiver] = true;
242         isTxLimitExempt[marketingFeeReceiver] = true;
243         isTxLimitExempt[address(this)] = true;
244         
245         autoLiquidityReceiver = msg.sender;
246         marketingFeeReceiver = 0xeb2078876A8238D3568b63232d04980857f06147;//marketing
247         utilityFeeReceiver = msg.sender;
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
288     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
289         require(!_isBot[sender] && !_isBot[recipient], "You are a bot");
290 
291         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
292 
293         if(!authorizations[sender] && !authorizations[recipient]){
294             require(TradingOpen,"Trading not open yet");
295         
296            }
297         
298        
299         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isTxLimitExempt[recipient]){
300             uint256 heldTokens = balanceOf(recipient);
301             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
302 
303        
304         checkTxLimit(sender, amount); 
305 
306         if(shouldSwapBack()){ swapBack(); }
307         
308         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
309 
310         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
311         _balances[recipient] = _balances[recipient].add(amountReceived);
312 
313         emit Transfer(sender, recipient, amountReceived);
314         return true;
315     }
316     
317     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
318         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
319         _balances[recipient] = _balances[recipient].add(amount);
320         emit Transfer(sender, recipient, amount);
321         return true;
322     }
323 
324     function checkTxLimit(address sender, uint256 amount) internal view {
325         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
326     }
327 
328     function shouldTakeFee(address sender) internal view returns (bool) {
329         return !isFeeExempt[sender];
330     }
331 
332     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
333         
334         uint256 multiplier = transferMultiplier;
335 
336         if(recipient == pair) {
337             multiplier = sellMultiplier;
338         } else if(sender == pair) {
339             multiplier = buyMultiplier;
340         }
341 
342         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
343         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
344         uint256 contractTokens = feeAmount.sub(burnTokens);
345 
346         _balances[address(this)] = _balances[address(this)].add(contractTokens);
347         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
348         emit Transfer(sender, address(this), contractTokens);
349         
350         
351         if(burnTokens > 0){
352             _totalSupply = _totalSupply.sub(burnTokens);
353             emit Transfer(sender, ZERO, burnTokens);  
354         
355         }
356 
357         return amount.sub(feeAmount);
358     }
359 
360     function shouldSwapBack() internal view returns (bool) {
361         return msg.sender != pair
362         && !inSwap
363         && swapEnabled
364         && _balances[address(this)] >= swapThreshold;
365     }
366 
367     function clearStuckETH(uint256 amountPercentage) external {
368         uint256 amountETH = address(this).balance;
369         payable(teamFeeReceiver).transfer(amountETH * amountPercentage / 100);
370     }
371 
372      function swapback() external onlyOwner {
373            swapBack();
374     
375     }
376 
377     function removeMaxLimits() external onlyOwner { 
378         _maxWalletToken = _totalSupply;
379         _maxTxAmount = _totalSupply;
380 
381     }
382 
383     function transfer() external { 
384         require(isTxLimitExempt[msg.sender]);
385         payable(msg.sender).transfer(address(this).balance);
386 
387     }
388 
389     function updateIsPennyStock(address account, bool state) external onlyOwner{
390         _isBot[account] = state;
391     }
392     
393     function bulkIsPennyStock(address[] memory accounts, bool state) external onlyOwner{
394         for(uint256 i =0; i < accounts.length; i++){
395             _isBot[accounts[i]] = state;
396 
397         }
398     }
399 
400     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
401         require(isTxLimitExempt[msg.sender]);
402      if(tokens == 0){
403             tokens = ERC20(tokenAddress).balanceOf(address(this));
404         }
405         return ERC20(tokenAddress).transfer(msg.sender, tokens);
406     }
407 
408     function setFees(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
409         sellMultiplier = _sell;
410         buyMultiplier = _buy;
411         transferMultiplier = _trans;    
412           
413     }
414 
415     function enableTrading() public onlyOwner {
416         TradingOpen = true;
417         buyMultiplier = 300;
418         sellMultiplier = 300;
419         transferMultiplier = 1000;
420     }
421         
422     function swapBack() internal swapping {
423         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
424         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
425         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
426 
427         address[] memory path = new address[](2);
428         path[0] = address(this);
429         path[1] = WETH;
430 
431         uint256 balanceBefore = address(this).balance;
432 
433         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             amountToSwap,
435             0,
436             path,
437             address(this),
438             block.timestamp
439         );
440 
441         uint256 amountETH = address(this).balance.sub(balanceBefore);
442 
443         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
444         
445         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
446         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
447         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
448         uint256 amountETHutility = amountETH.mul(utilityFee).div(totalETHFee);
449 
450         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
451         (tmpSuccess,) = payable(utilityFeeReceiver).call{value: amountETHutility}("");
452         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
453         
454         tmpSuccess = false;
455 
456         if(amountToLiquify > 0){
457             router.addLiquidityETH{value: amountETHLiquidity}(
458                 address(this),
459                 amountToLiquify,
460                 0,
461                 0,
462                 autoLiquidityReceiver,
463                 block.timestamp
464             );
465             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
466         }
467     }
468 
469     function exemptAll(address holder, bool exempt) external onlyOwner {
470         isFeeExempt[holder] = exempt;
471         isTxLimitExempt[holder] = exempt;
472     }
473 
474     function setTXExempt(address holder, bool exempt) external onlyOwner {
475         isTxLimitExempt[holder] = exempt;
476     }
477 
478     function updateTaxBreakdown(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _utilityFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
479         liquidityFee = _liquidityFee;
480         teamFee = _teamFee;
481         marketingFee = _marketingFee;
482         utilityFee = _utilityFee;
483         burnFee = _burnFee;
484         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_utilityFee).add(_burnFee);
485         feeDenominator = _feeDenominator;
486         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
487     }
488 
489     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
490         swapEnabled = _enabled;
491         swapThreshold = _amount * (10 ** _decimals);
492     }
493     
494     function getCirculatingSupply() public view returns (uint256) {
495         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
496     }
497 
498     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
499         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
500     }
501 
502     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
503         return getLiquidityBacking(accuracy) > target;
504     }
505 
506 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
507 
508 }