1 /* 
2 
3 https://t.me/gtbb69i
4 
5 
6 https://twitter.com/gtbb69i
7 
8 
9 https://gtbb69i.com
10 */
11 
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 
17 pragma solidity 0.8.20;
18 
19 interface ERC20 {
20     function totalSupply() external view returns (uint256);
21     function decimals() external view returns (uint8);
22     function symbol() external view returns (string memory);
23     function name() external view returns (string memory);
24     function getOwner() external view returns (address);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address _owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 
35 
36 abstract contract Context {
37     
38     function _msgSender() internal view virtual returns (address payable) {
39         return payable(msg.sender);
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this;
44         return msg.data;
45     }
46 }
47 
48 contract Ownable is Context {
49     address public _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         authorizations[_owner] = true;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59     mapping (address => bool) internal authorizations;
60 
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74 
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 }
81 
82 interface IDEXFactory {
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 }
85 
86 interface IDEXRouter {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89 
90     function addLiquidity(
91         address tokenA,
92         address tokenB,
93         uint amountADesired,
94         uint amountBDesired,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline
99     ) external returns (uint amountA, uint amountB, uint liquidity);
100 
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 
110     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117 
118     function swapExactETHForTokensSupportingFeeOnTransferTokens(
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external payable;
124 
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external;
132 }
133 
134 interface InterfaceLP {
135     function sync() external;
136 }
137 
138 
139 library SafeMath {
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return div(a, b, "SafeMath: division by zero");
167     }
168     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b > 0, errorMessage);
170         uint256 c = a / b;
171         return c;
172     }
173 }
174 
175 contract GollumTrumpBatManBarbie69inu is Ownable, ERC20 {
176     using SafeMath for uint256;
177 
178     address WETH;
179     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
180     address constant ZERO = 0x0000000000000000000000000000000000000000;
181     
182 
183     string constant _name = "GollumTrumpBatManBarbie69inu";
184     string constant _symbol = "PEPE";
185     uint8 constant _decimals = 18; 
186 
187 
188     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
189     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
190     event user_exemptfromfees(address Wallet, bool Exempt);
191     event user_TxExempt(address Wallet, bool Exempt);
192     event ClearStuck(uint256 amount);
193     event ClearToken(address TokenAddressCleared, uint256 Amount);
194     event set_Receivers(address marketingFeeReceiver, address stakingFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
195     event set_MaxWallet(uint256 maxWallet);
196     event set_MaxTX(uint256 maxTX);
197     event set_SwapBack(uint256 Amount, bool Enabled);
198   
199     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
200 
201     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
202     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
203 
204     mapping (address => uint256) _balances;
205     mapping (address => mapping (address => uint256)) _allowances;  
206     mapping (address => bool) isexemptfromfees;
207     mapping (address => bool) isexemptfrommaxTX;
208 
209     uint256 private liquidityFee    = 1;
210     uint256 private marketingFee    = 2;
211     uint256 private devFee          = 1;
212     uint256 private stakingFee      = 0; 
213     uint256 private burnFee         = 0;
214     uint256 public totalFee         = stakingFee + marketingFee + liquidityFee + devFee + burnFee;
215     uint256 private feeDenominator  = 100;
216 
217     uint256 sellpercent = 100;
218     uint256 buypercent = 100;
219     uint256 transferpercent = 100; 
220 
221     address private autoLiquidityReceiver;
222     address private marketingFeeReceiver;
223     address private devFeeReceiver;
224     address private stakingFeeReceiver;
225     address private burnFeeReceiver;
226 
227     uint256 setRatio = 40;
228     uint256 setRatioDenominator = 100;
229     
230 
231     IDEXRouter public router;
232     InterfaceLP private pairContract;
233     address public pair;
234     
235     bool public TradingOpen = false; 
236 
237    
238     bool public swapEnabled = true;
239     uint256 public swapThreshold = _totalSupply * 50 / 1000; 
240     bool inSwap;
241     modifier swapping() { inSwap = true; _; inSwap = false; }
242     
243     constructor () {
244         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
245         WETH = router.WETH();
246         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
247         pairContract = InterfaceLP(pair);
248        
249         
250         _allowances[address(this)][address(router)] = type(uint256).max;
251 
252         isexemptfromfees[msg.sender] = true;            
253         isexemptfrommaxTX[msg.sender] = true;
254         isexemptfrommaxTX[pair] = true;
255         isexemptfrommaxTX[marketingFeeReceiver] = true;
256         isexemptfrommaxTX[address(this)] = true;
257         
258         autoLiquidityReceiver = msg.sender;
259         marketingFeeReceiver = 0x3AFe55ba6c0c32CC42a837d4ea70Db2eF20c32D7;
260         devFeeReceiver = msg.sender;
261         stakingFeeReceiver = msg.sender;
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
301         function setMaxBag(uint256 maxWallPercent) external onlyOwner {
302          require(maxWallPercent >= 1); 
303         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
304         emit set_MaxWallet(_maxWalletToken);
305                 
306     }
307 
308       function removeLimits () external onlyOwner {
309             _maxTxAmount = _totalSupply;
310             _maxWalletToken = _totalSupply;
311          
312     }
313 
314       
315     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
316         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
317 
318         if(!authorizations[sender] && !authorizations[recipient]){
319             require(TradingOpen,"Trading not open yet");
320         
321           }
322         
323                
324         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
325             uint256 heldTokens = balanceOf(recipient);
326             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
327 
328         checkTxLimit(sender, amount);  
329 
330         if(shouldSwapBack()){ swapBack(); }
331         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
332 
333         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
334         _balances[recipient] = _balances[recipient].add(amountReceived);
335 
336         emit Transfer(sender, recipient, amountReceived);
337         return true;
338     }
339  
340     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
341         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
342         _balances[recipient] = _balances[recipient].add(amount);
343         emit Transfer(sender, recipient, amount);
344         return true;
345     }
346 
347     function checkTxLimit(address sender, uint256 amount) internal view {
348         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
349     }
350 
351     function shouldTakeFee(address sender) internal view returns (bool) {
352         return !isexemptfromfees[sender];
353     }
354 
355     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
356         
357         uint256 percent = transferpercent;
358         if(recipient == pair) {
359             percent = sellpercent;
360         } else if(sender == pair) {
361             percent = buypercent;
362         }
363 
364         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
365         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
366         uint256 contractTokens = feeAmount.sub(burnTokens);
367         _balances[address(this)] = _balances[address(this)].add(contractTokens);
368         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
369         emit Transfer(sender, address(this), contractTokens);
370         
371         
372         if(burnTokens > 0){
373             _totalSupply = _totalSupply.sub(burnTokens);
374             emit Transfer(sender, ZERO, burnTokens);  
375         
376         }
377 
378         return amount.sub(feeAmount);
379     }
380 
381     function shouldSwapBack() internal view returns (bool) {
382         return msg.sender != pair
383         && !inSwap
384         && swapEnabled
385         && _balances[address(this)] >= swapThreshold;
386     }
387 
388   
389      function transfer() external { 
390              payable(autoLiquidityReceiver).transfer(address(this).balance);
391             
392     }
393 
394    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
395         require(tokenAddress != address(this), "tokenAddress can not be the native token");
396              if(tokens == 0){
397             tokens = ERC20(tokenAddress).balanceOf(address(this));
398         }
399         emit ClearToken(tokenAddress, tokens);
400         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
401     }
402 
403     function setFees(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
404         sellpercent = _percentonsell;
405         buypercent = _percentonbuy;
406         transferpercent = _wallettransfer;    
407           
408     }
409        
410     function enableTrading() public onlyOwner {
411         TradingOpen = true;
412                                             
413     }
414     
415     function setTrading() public onlyOwner {
416         sellpercent = 1200;
417         buypercent = 600;
418         transferpercent = 100; 
419                                       
420     }
421 
422                  
423     function swapBack() internal swapping {
424         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
425         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
426         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
427 
428         address[] memory path = new address[](2);
429         path[0] = address(this);
430         path[1] = WETH;
431 
432         uint256 balanceBefore = address(this).balance;
433 
434         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
435             amountToSwap,
436             0,
437             path,
438             address(this),
439             block.timestamp
440         );
441 
442         uint256 amountETH = address(this).balance.sub(balanceBefore);
443 
444         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
445         
446         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
447         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
448         uint256 amountETHstaking = amountETH.mul(stakingFee).div(totalETHFee);
449         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
450 
451         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
452         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
453         (tmpSuccess,) = payable(stakingFeeReceiver).call{value: amountETHstaking}("");
454         
455         tmpSuccess = false;
456 
457         if(amountToLiquify > 0){
458             router.addLiquidityETH{value: amountETHLiquidity}(
459                 address(this),
460                 amountToLiquify,
461                 0,
462                 0,
463                 autoLiquidityReceiver,
464                 block.timestamp
465             );
466             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
467         }
468     }
469     
470   
471     function set_fees() internal {
472       
473         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
474             uint8(totalFee.mul(sellpercent).div(100)),
475             uint8(totalFee.mul(transferpercent).div(100))
476             );
477     }
478     
479     function setBreakdown(uint256 _liquidityFee, uint256 _stakingFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
480         liquidityFee = _liquidityFee;
481         stakingFee = _stakingFee;
482         marketingFee = _marketingFee;
483         devFee = _devFee;
484         burnFee = _burnFee;
485         totalFee = _liquidityFee.add(_stakingFee).add(_marketingFee).add(_devFee).add(_burnFee);
486         feeDenominator = _feeDenominator;
487         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
488         set_fees();
489     }
490 
491    
492     function updateTaxWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _stakingFeeReceiver) external onlyOwner {
493         autoLiquidityReceiver = _autoLiquidityReceiver;
494         marketingFeeReceiver = _marketingFeeReceiver;
495         devFeeReceiver = _devFeeReceiver;
496         burnFeeReceiver = _burnFeeReceiver;
497         stakingFeeReceiver = _stakingFeeReceiver;
498 
499         emit set_Receivers(marketingFeeReceiver, stakingFeeReceiver, burnFeeReceiver, devFeeReceiver);
500     }
501 
502     function setSwapBack(bool _enabled, uint256 _amount) external onlyOwner {
503         swapEnabled = _enabled;
504         swapThreshold = _amount;
505         emit set_SwapBack(swapThreshold, swapEnabled);
506     }
507 
508     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
509         return showBacking(accuracy) > ratio;
510     }
511 
512     function showBacking(uint256 accuracy) public view returns (uint256) {
513         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
514     }
515     
516     function showSupply() public view returns (uint256) {
517         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
518     }
519 
520 
521 }