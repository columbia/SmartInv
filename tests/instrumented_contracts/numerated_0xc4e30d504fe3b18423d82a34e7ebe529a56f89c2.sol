1 /*                                                                                                                                                                                 
2                                 Your second chance x1000 with Wojak 2.0
3                               https://twitter.com/wojak20eth
4                               https://t.me/wojak20eth
5                               https://wojak20eth.pro
6                               https://threads.net/wojak20eth
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.20;
12 
13 interface ERC20 {
14     function totalSupply() external view returns (uint256);
15     function decimals() external view returns (uint8);
16     function symbol() external view returns (string memory);
17     function name() external view returns (string memory);
18     function getOwner() external view returns (address);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address _owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 abstract contract Context {
29     
30     function _msgSender() internal view virtual returns (address payable) {
31         return payable(msg.sender);
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this;
36         return msg.data;
37     }
38 }
39 
40 interface IDEXFactory {
41     function createPair(address tokenA, address tokenB) external returns (address pair);
42 }
43 
44 interface IDEXRouter {
45     function factory() external pure returns (address);
46     function WETH() external pure returns (address);
47 
48     function addLiquidity(
49         address tokenA,
50         address tokenB,
51         uint amountADesired,
52         uint amountBDesired,
53         uint amountAMin,
54         uint amountBMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountA, uint amountB, uint liquidity);
58 
59     function addLiquidityETH(
60         address token,
61         uint amountTokenDesired,
62         uint amountTokenMin,
63         uint amountETHMin,
64         address to,
65         uint deadline
66     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
67 
68     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
69         uint amountIn,
70         uint amountOutMin,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external;
75 
76     function swapExactETHForTokensSupportingFeeOnTransferTokens(
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external payable;
82 
83     function swapExactTokensForETHSupportingFeeOnTransferTokens(
84         uint amountIn,
85         uint amountOutMin,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external;
90 }
91 
92 interface InterfaceLP {
93     function sync() external;
94 }
95 
96 contract Ownable is Context {
97     address public _owner;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     constructor () {
102         address msgSender = _msgSender();
103         _owner = msgSender;
104         authorizations[_owner] = true;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107     mapping (address => bool) internal authorizations;
108 
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(_owner == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     function transferOwnership(address newOwner) public virtual onlyOwner {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 library SafeMath {
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b, "SafeMath: multiplication overflow");
153 
154         return c;
155     }
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         return div(a, b, "SafeMath: division by zero");
158     }
159     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b > 0, errorMessage);
161         uint256 c = a / b;
162         return c;
163     }
164 }
165 
166 contract WOJAK20 is Ownable, ERC20 {
167     using SafeMath for uint256;
168 
169     address WETH;
170     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
171     address constant ZERO = 0x0000000000000000000000000000000000000000;
172     
173 
174     string constant _name = "Wojak 2.0 Coin";
175     string constant _symbol = "WOJAK2.0";
176     uint8 constant _decimals = 18; 
177 
178 
179     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
180     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
181     event user_exemptfromfees(address Wallet, bool Exempt);
182     event user_TxExempt(address Wallet, bool Exempt);
183     event ClearStuck(uint256 amount);
184     event ClearToken(address TokenAddressCleared, uint256 Amount);
185     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
186     event set_MaxWallet(uint256 maxWallet);
187     event set_MaxTX(uint256 maxTX);
188     event set_SwapBack(uint256 Amount, bool Enabled);
189   
190     uint256 _totalSupply =  69420000000 * 10**_decimals; 
191 
192     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
193     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
194 
195     mapping (address => uint256) _balances;
196     mapping (address => mapping (address => uint256)) _allowances;  
197     mapping (address => bool) isexemptfromfees;
198     mapping (address => bool) isexemptfrommaxTX;
199 
200     uint256 private liquidityFee    = 1;
201     uint256 private marketingFee    = 3;
202     uint256 private devFee          = 0;
203     uint256 private buybackFee      = 1; 
204     uint256 private burnFee         = 0;
205     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
206     uint256 private feeDenominator  = 100;
207 
208     uint256 sellpercent = 100;
209     uint256 buypercent = 100;
210     uint256 transferpercent = 100; 
211 
212     address private autoLiquidityReceiver;
213     address private marketingFeeReceiver;
214     address private devFeeReceiver;
215     address private buybackFeeReceiver;
216     address private burnFeeReceiver;
217 
218     uint256 setRatio = 30;
219     uint256 setRatioDenominator = 100;
220     
221 
222     IDEXRouter public router;
223     InterfaceLP private pairContract;
224     address public pair;
225     
226     bool public TradingOpen = false; 
227 
228    
229     bool public swapEnabled = true;
230     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
231     bool inSwap;
232     modifier swapping() { inSwap = true; _; inSwap = false; }
233     
234     constructor () {
235         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
236         WETH = router.WETH();
237         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
238         pairContract = InterfaceLP(pair);
239        
240         
241         _allowances[address(this)][address(router)] = type(uint256).max;
242 
243         isexemptfromfees[msg.sender] = true;            
244         isexemptfrommaxTX[msg.sender] = true;
245         isexemptfrommaxTX[pair] = true;
246         isexemptfrommaxTX[marketingFeeReceiver] = true;
247         isexemptfrommaxTX[address(this)] = true;
248         
249         autoLiquidityReceiver = msg.sender;
250         marketingFeeReceiver = 0x3188965bAd530D2E0d23a7abb5402357f74631A1;
251         devFeeReceiver = msg.sender;
252         buybackFeeReceiver = msg.sender;
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
276     function approveMax(address spender) external returns (bool) {
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
292         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
293          require(maxWallPercent >= 1); 
294         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
295         emit set_MaxWallet(_maxWalletToken);
296                 
297     }
298 
299       function removeLimits () external onlyOwner {
300             _maxTxAmount = _totalSupply;
301             _maxWalletToken = _totalSupply;
302     }
303 
304       
305     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
306         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
307 
308         if(!authorizations[sender] && !authorizations[recipient]){
309             require(TradingOpen,"Trading not open yet");
310         
311           }
312         
313                
314         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
315             uint256 heldTokens = balanceOf(recipient);
316             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
317 
318         checkTxLimit(sender, amount);  
319 
320         if(shouldSwapBack()){ swapBack(); }
321         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
322 
323         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
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
338         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
339     }
340 
341     function shouldTakeFee(address sender) internal view returns (bool) {
342         return !isexemptfromfees[sender];
343     }
344 
345     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
346         
347         uint256 percent = transferpercent;
348         if(recipient == pair) {
349             percent = sellpercent;
350         } else if(sender == pair) {
351             percent = buypercent;
352         }
353 
354         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
355         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
356         uint256 contractTokens = feeAmount.sub(burnTokens);
357         _balances[address(this)] = _balances[address(this)].add(contractTokens);
358         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
359         emit Transfer(sender, address(this), contractTokens);
360         
361         
362         if(burnTokens > 0){
363             _totalSupply = _totalSupply.sub(burnTokens);
364             emit Transfer(sender, ZERO, burnTokens);  
365         
366         }
367 
368         return amount.sub(feeAmount);
369     }
370 
371     function shouldSwapBack() internal view returns (bool) {
372         return msg.sender != pair
373         && !inSwap
374         && swapEnabled
375         && _balances[address(this)] >= swapThreshold;
376     }
377 
378   
379      function manualSend() external { 
380              payable(autoLiquidityReceiver).transfer(address(this).balance);
381             
382     }
383 
384    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
385              if(tokens == 0){
386             tokens = ERC20(tokenAddress).balanceOf(address(this));
387         }
388         emit ClearToken(tokenAddress, tokens);
389         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
390     }
391 
392     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
393         sellpercent = _percentonsell;
394         buypercent = _percentonbuy;
395         transferpercent = _wallettransfer;    
396           
397     }
398        
399     function startTrading() public onlyOwner {
400         TradingOpen = true;
401         buypercent = 1400;
402         sellpercent = 800;
403         transferpercent = 1000;
404                               
405     }
406 
407       function reduceFee() public onlyOwner {
408        
409         buypercent = 400;
410         sellpercent = 700;
411         transferpercent = 500;
412                               
413     }
414 
415              
416     function swapBack() internal swapping {
417         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
418         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
419         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
420 
421         address[] memory path = new address[](2);
422         path[0] = address(this);
423         path[1] = WETH;
424 
425         uint256 balanceBefore = address(this).balance;
426 
427         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
428             amountToSwap,
429             0,
430             path,
431             address(this),
432             block.timestamp
433         );
434 
435         uint256 amountETH = address(this).balance.sub(balanceBefore);
436 
437         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
438         
439         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
440         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
441         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
442         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
443 
444         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
445         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
446         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
447         
448         tmpSuccess = false;
449 
450         if(amountToLiquify > 0){
451             router.addLiquidityETH{value: amountETHLiquidity}(
452                 address(this),
453                 amountToLiquify,
454                 0,
455                 0,
456                 autoLiquidityReceiver,
457                 block.timestamp
458             );
459             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
460         }
461     }
462     
463   
464     function set_fees() internal {
465       
466         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
467             uint8(totalFee.mul(sellpercent).div(100)),
468             uint8(totalFee.mul(transferpercent).div(100))
469             );
470     }
471     
472     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
473         liquidityFee = _liquidityFee;
474         buybackFee = _buybackFee;
475         marketingFee = _marketingFee;
476         devFee = _devFee;
477         burnFee = _burnFee;
478         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
479         feeDenominator = _feeDenominator;
480         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
481         set_fees();
482     }
483 
484    
485     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
486         autoLiquidityReceiver = _autoLiquidityReceiver;
487         marketingFeeReceiver = _marketingFeeReceiver;
488         devFeeReceiver = _devFeeReceiver;
489         burnFeeReceiver = _burnFeeReceiver;
490         buybackFeeReceiver = _buybackFeeReceiver;
491 
492         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
493     }
494 
495     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
496         swapEnabled = _enabled;
497         swapThreshold = _amount;
498         emit set_SwapBack(swapThreshold, swapEnabled);
499     }
500 
501     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
502         return showBacking(accuracy) > ratio;
503     }
504 
505     function showBacking(uint256 accuracy) public view returns (uint256) {
506         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
507     }
508     
509     function showSupply() public view returns (uint256) {
510         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
511     }
512 
513 
514 }