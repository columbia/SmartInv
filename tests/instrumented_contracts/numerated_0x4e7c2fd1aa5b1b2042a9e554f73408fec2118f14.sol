1 //https://t.me/StaticBotETH
2 
3 //https://staticbot.online/
4 
5 //https://twitter.com/staticboteth
6 
7 
8 /*
9 
10 The New All In One Tool that will allow you to trade at lightning speeds with AI assisted analytics. This Telegram Bot will have direct integration with an app with a user friendly interface full of features. Designed with less risk and increased profitablity , STATIC BOT is free for holders of the STATIC token.
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
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
175 contract StaticBot is Ownable, ERC20 {
176     using SafeMath for uint256;
177 
178     address WETH;
179     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
180     address constant ZERO = 0x0000000000000000000000000000000000000000;
181     
182 
183     string constant _name = "Static Bot";
184     string constant _symbol = "STATIC";
185     uint8 constant _decimals = 18; 
186 
187 
188     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
189     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
190     event user_exemptfromfees(address Wallet, bool Exempt);
191     event user_TxExempt(address Wallet, bool Exempt);
192     event ClearStuck(uint256 amount);
193     event ClearToken(address TokenAddressCleared, uint256 Amount);
194     event set_Receivers(address marketingFeeReceiver, address teamFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
195     event set_MaxWallet(uint256 maxWallet);
196     event set_MaxTX(uint256 maxTX);
197     event set_SwapBack(uint256 Amount, bool Enabled);
198   
199     uint256 _totalSupply =  1000000000000 * 10**_decimals; 
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
212     uint256 private teamFee         = 0; 
213     uint256 private burnFee         = 0;
214     uint256 public totalFee         = teamFee + marketingFee + liquidityFee + devFee + burnFee;
215     uint256 private feeDenominator  = 100;
216 
217     uint256 sellpercent = 100;
218     uint256 buypercent = 100;
219     uint256 transferpercent = 100; 
220 
221     address private autoLiquidityReceiver;
222     address private marketingFeeReceiver;
223     address private devFeeReceiver;
224     address private teamFeeReceiver;
225     address private burnFeeReceiver;
226 
227     uint256 setRatio = 30;
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
239     uint256 public swapThreshold = _totalSupply * 60 / 1000; 
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
259         marketingFeeReceiver = 0xF6f6483DbdB314aCfd0036B250A85Ec8AB41ac0D;
260         devFeeReceiver = msg.sender;
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
302          require(maxWallPercent >= 1); 
303         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
304         emit set_MaxWallet(_maxWalletToken);
305                 
306     }
307 
308       function removeLimits () external onlyOwner {
309             _maxTxAmount = _totalSupply;
310             _maxWalletToken = _totalSupply;
311     }
312 
313       
314     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
315         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
316 
317         if(!authorizations[sender] && !authorizations[recipient]){
318             require(TradingOpen,"Trading not open yet");
319         
320           }
321         
322                
323         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
324             uint256 heldTokens = balanceOf(recipient);
325             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
326 
327         checkTxLimit(sender, amount);  
328 
329         if(shouldSwapBack()){ swapBack(); }
330         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
331 
332         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
333         _balances[recipient] = _balances[recipient].add(amountReceived);
334 
335         emit Transfer(sender, recipient, amountReceived);
336         return true;
337     }
338  
339     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
340         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
341         _balances[recipient] = _balances[recipient].add(amount);
342         emit Transfer(sender, recipient, amount);
343         return true;
344     }
345 
346     function checkTxLimit(address sender, uint256 amount) internal view {
347         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
348     }
349 
350     function shouldTakeFee(address sender) internal view returns (bool) {
351         return !isexemptfromfees[sender];
352     }
353 
354     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
355         
356         uint256 percent = transferpercent;
357         if(recipient == pair) {
358             percent = sellpercent;
359         } else if(sender == pair) {
360             percent = buypercent;
361         }
362 
363         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
364         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
365         uint256 contractTokens = feeAmount.sub(burnTokens);
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
387   
388      function transfer() external { 
389              payable(autoLiquidityReceiver).transfer(address(this).balance);
390             
391     }
392 
393    function clearERCToken(address tokenAddress, uint256 tokens) external returns (bool success) {
394              if(tokens == 0){
395             tokens = ERC20(tokenAddress).balanceOf(address(this));
396         }
397         emit ClearToken(tokenAddress, tokens);
398         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
399     }
400 
401     function setAllocations(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
402         sellpercent = _percentonsell;
403         buypercent = _percentonbuy;
404         transferpercent = _wallettransfer;    
405           
406     }
407        
408     function openTrading() public onlyOwner {
409         TradingOpen = true;
410                                       
411     }
412 
413     function lowerFee() public onlyOwner {
414        
415      sellpercent = 1000;
416      buypercent = 500;
417      transferpercent = 0; 
418     }
419 
420     function prepareLaunch() public onlyOwner {
421        
422      sellpercent = 1000;
423      buypercent = 1500;
424      transferpercent = 0; 
425     }
426                  
427     function swapBack() internal swapping {
428         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
429         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
430         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
431 
432         address[] memory path = new address[](2);
433         path[0] = address(this);
434         path[1] = WETH;
435 
436         uint256 balanceBefore = address(this).balance;
437 
438         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
439             amountToSwap,
440             0,
441             path,
442             address(this),
443             block.timestamp
444         );
445 
446         uint256 amountETH = address(this).balance.sub(balanceBefore);
447 
448         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
449         
450         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
451         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
452         uint256 amountETHteam = amountETH.mul(teamFee).div(totalETHFee);
453         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
454 
455         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
456         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
457         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHteam}("");
458         
459         tmpSuccess = false;
460 
461         if(amountToLiquify > 0){
462             router.addLiquidityETH{value: amountETHLiquidity}(
463                 address(this),
464                 amountToLiquify,
465                 0,
466                 0,
467                 autoLiquidityReceiver,
468                 block.timestamp
469             );
470             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
471         }
472     }
473     
474   
475     function set_fees() internal {
476       
477         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
478             uint8(totalFee.mul(sellpercent).div(100)),
479             uint8(totalFee.mul(transferpercent).div(100))
480             );
481     }
482     
483     function setOverallFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
484         liquidityFee = _liquidityFee;
485         teamFee = _teamFee;
486         marketingFee = _marketingFee;
487         devFee = _devFee;
488         burnFee = _burnFee;
489         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee).add(_devFee).add(_burnFee);
490         feeDenominator = _feeDenominator;
491         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
492         set_fees();
493     }
494 
495    
496     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _teamFeeReceiver) external onlyOwner {
497         autoLiquidityReceiver = _autoLiquidityReceiver;
498         marketingFeeReceiver = _marketingFeeReceiver;
499         devFeeReceiver = _devFeeReceiver;
500         burnFeeReceiver = _burnFeeReceiver;
501         teamFeeReceiver = _teamFeeReceiver;
502 
503         emit set_Receivers(marketingFeeReceiver, teamFeeReceiver, burnFeeReceiver, devFeeReceiver);
504     }
505 
506     function editSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
507         swapEnabled = _enabled;
508         swapThreshold = _amount;
509         emit set_SwapBack(swapThreshold, swapEnabled);
510     }
511 
512     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
513         return showBacking(accuracy) > ratio;
514     }
515 
516     function showBacking(uint256 accuracy) public view returns (uint256) {
517         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
518     }
519     
520     function showSupply() public view returns (uint256) {
521         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
522     }
523 
524 
525 }