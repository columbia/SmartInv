1 // https://kaatoken.vip
2 
3 
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 pragma solidity 0.8.20;
9 
10 interface ERC20 {
11     function totalSupply() external view returns (uint256);
12     function decimals() external view returns (uint8);
13     function symbol() external view returns (string memory);
14     function name() external view returns (string memory);
15     function getOwner() external view returns (address);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address _owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 
27 abstract contract Context {
28     
29     function _msgSender() internal view virtual returns (address payable) {
30         return payable(msg.sender);
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this;
35         return msg.data;
36     }
37 }
38 
39 contract Ownable is Context {
40     address public _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     constructor () {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         authorizations[_owner] = true;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50     mapping (address => bool) internal authorizations;
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 interface IDEXFactory {
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 }
76 
77 interface IDEXRouter {
78     function factory() external pure returns (address);
79     function WETH() external pure returns (address);
80 
81     function addLiquidity(
82         address tokenA,
83         address tokenB,
84         uint amountADesired,
85         uint amountBDesired,
86         uint amountAMin,
87         uint amountBMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountA, uint amountB, uint liquidity);
91 
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100 
101     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108 
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external payable;
115 
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123 }
124 
125 interface InterfaceLP {
126     function sync() external;
127 }
128 
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
166 contract KAAPepePredator is Ownable, ERC20 {
167     using SafeMath for uint256;
168 
169     address WETH;
170     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
171     address constant ZERO = 0x0000000000000000000000000000000000000000;
172     
173 
174     string constant _name = "Pepe Predator";
175     string constant _symbol = "KAA";
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
190     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
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
250         marketingFeeReceiver = 0xd48ab7948c5BA96737d9B27e8b5A4A85aB98aCa6;
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