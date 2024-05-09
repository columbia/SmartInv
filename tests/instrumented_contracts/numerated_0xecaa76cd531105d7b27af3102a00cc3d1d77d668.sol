1 // Behold, the coin the world never asked for, but was shoved on live pairs anyway! Who made it? Irrelevant. 
2 // All you need to know is we’ve locked up liquidity tighter than a jeets butthole, 
3 // and donated some just for the fuck of it . Tax? Think of the rarest number: zero twice. 
4 // To the daring Telegram Chad and website warrior degen who wins the heart of the community, 
5 // a treasure awaits. All this coin craves is green dildos and mindless apes. As real as it gets, 
6 // with no hidden agendas. Venture if you wish, or fuck off but remember: this coin is as real as they come. 
7 
8 // Lets pump this bitch!
9 
10 // I didn’t make a logo so make one if you want one.
11 
12 // https://x.com/justacoineth
13 
14 
15 
16 // SPDX-License-Identifier: MIT
17 
18 
19 pragma solidity 0.8.20;
20 
21 interface ERC20 {
22     function totalSupply() external view returns (uint256);
23     function decimals() external view returns (uint8);
24     function symbol() external view returns (string memory);
25     function name() external view returns (string memory);
26     function getOwner() external view returns (address);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address _owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 
37 
38 abstract contract Context {
39     
40     function _msgSender() internal view virtual returns (address payable) {
41         return payable(msg.sender);
42     }
43 
44     function _msgData() internal view virtual returns (bytes memory) {
45         this;
46         return msg.data;
47     }
48 }
49 
50 contract Ownable is Context {
51     address public _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     constructor () {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         authorizations[_owner] = true;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61     mapping (address => bool) internal authorizations;
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 }
83 
84 interface IDEXFactory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IDEXRouter {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91 
92     function addLiquidity(
93         address tokenA,
94         address tokenB,
95         uint amountADesired,
96         uint amountBDesired,
97         uint amountAMin,
98         uint amountBMin,
99         address to,
100         uint deadline
101     ) external returns (uint amountA, uint amountB, uint liquidity);
102 
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 
112     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 
120     function swapExactETHForTokensSupportingFeeOnTransferTokens(
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external payable;
126 
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134 }
135 
136 interface InterfaceLP {
137     function sync() external;
138 }
139 
140 
141 library SafeMath {
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b > 0, errorMessage);
172         uint256 c = a / b;
173         return c;
174     }
175 }
176 
177 contract GreenDILDO is Ownable, ERC20 {
178     using SafeMath for uint256;
179 
180     address WETH;
181     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
182     address constant ZERO = 0x0000000000000000000000000000000000000000;
183     
184 
185     string constant _name = "Letspumpthishoefortheculture";
186     string constant _symbol = "DILDO";
187     uint8 constant _decimals = 18; 
188 
189 
190     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
191     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
192     event user_exemptfromfees(address Wallet, bool Exempt);
193     event user_TxExempt(address Wallet, bool Exempt);
194     event ClearStuck(uint256 amount);
195     event ClearToken(address TokenAddressCleared, uint256 Amount);
196     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
197     event set_MaxWallet(uint256 maxWallet);
198     event set_MaxTX(uint256 maxTX);
199     event set_SwapBack(uint256 Amount, bool Enabled);
200   
201     uint256 _totalSupply =  1000000000 * 10**_decimals; 
202 
203     uint256 public _maxTxAmount = _totalSupply.mul(5).div(100);
204     uint256 public _maxWalletToken = _totalSupply.mul(5).div(100);
205 
206     mapping (address => uint256) _balances;
207     mapping (address => mapping (address => uint256)) _allowances;
208     mapping (address => bool) isexemptfromfees;
209     mapping (address => bool) isexemptfrommaxTX;
210 
211     uint256 private liquidityFee    = 0;
212     uint256 private marketingFee    = 990;
213     uint256 private devFee          = 0;
214     uint256 private buybackFee      = 0; 
215     uint256 private burnFee         = 0;
216     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
217     uint256 private feeDenominator  = 1000;
218 
219     uint256 sellpercent = 990;
220     uint256 buypercent = 990;
221     uint256 transferpercent = 990; 
222 
223     address private autoLiquidityReceiver;
224     address private marketingFeeReceiver;
225     address private devFeeReceiver;
226     address private buybackFeeReceiver;
227     address private burnFeeReceiver;
228 
229     uint256 setRatio = 30;
230     uint256 setRatioDenominator = 100;
231     
232 
233     IDEXRouter public router;
234     InterfaceLP private pairContract;
235     address public pair;
236     
237     bool public TradingOpen = false; 
238 
239    
240     bool public swapEnabled = true;
241     uint256 public swapThreshold = _totalSupply / 1000; 
242     bool inSwap;
243     modifier swapping() { inSwap = true; _; inSwap = false; }
244     
245     constructor () {
246         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
247         WETH = router.WETH();
248         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
249         pairContract = InterfaceLP(pair);
250        
251         
252         _allowances[address(this)][address(router)] = type(uint256).max;
253   
254         isexemptfromfees[msg.sender] = true;
255         isexemptfromfees[marketingFeeReceiver] = true;
256         isexemptfromfees[address(this)] = true;
257         isexemptfromfees[DEAD] = true;     
258         
259         isexemptfrommaxTX[msg.sender] = true;
260         isexemptfrommaxTX[pair] = true;
261         isexemptfrommaxTX[marketingFeeReceiver] = true;
262         isexemptfrommaxTX[address(this)] = true;
263         isexemptfrommaxTX[DEAD] = true;
264         
265         autoLiquidityReceiver = 0x5B38700007375Ee282CA3817f07022a50D63C652;
266         marketingFeeReceiver =  0x5B38700007375Ee282CA3817f07022a50D63C652;
267         devFeeReceiver = msg.sender;
268         buybackFeeReceiver = msg.sender;
269         burnFeeReceiver = DEAD; 
270 
271         _balances[msg.sender] = _totalSupply;
272         emit Transfer(address(0), msg.sender, _totalSupply);
273 
274     }
275 
276     receive() external payable { }
277 
278     function totalSupply() external view override returns (uint256) { return _totalSupply; }
279     function decimals() external pure override returns (uint8) { return _decimals; }
280     function symbol() external pure override returns (string memory) { return _symbol; }
281     function name() external pure override returns (string memory) { return _name; }
282     function getOwner() external view override returns (address) {return owner();}
283     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
284     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
285 
286     function approve(address spender, uint256 amount) public override returns (bool) {
287         _allowances[msg.sender][spender] = amount;
288         emit Approval(msg.sender, spender, amount);
289         return true;
290     }
291 
292     function approveMax(address spender) external returns (bool) {
293         return approve(spender, type(uint256).max);
294     }
295 
296     function transfer(address recipient, uint256 amount) external override returns (bool) {
297         return _transferFrom(msg.sender, recipient, amount);
298     }
299 
300     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
301         if(_allowances[sender][msg.sender] != type(uint256).max){
302             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
303         }
304 
305         return _transferFrom(sender, recipient, amount);
306     }
307 
308     function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
309          require(maxWallPercent >= 1); 
310         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
311         emit set_MaxWallet(_maxWalletToken);
312                 
313     }
314 
315       function removeLimits () external onlyOwner {
316             _maxTxAmount = _totalSupply;
317             _maxWalletToken = _totalSupply;
318     }
319 
320       
321     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
322         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
323 
324         if(!authorizations[sender] && !authorizations[recipient]){
325             require(TradingOpen,"Trading not open yet");
326         
327           }
328         
329                
330         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
331             uint256 heldTokens = balanceOf(recipient);
332             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
333 
334         checkTxLimit(sender, amount);  
335 
336         if(shouldSwapBack()){ swapBack(); }
337         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
338 
339         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
340         _balances[recipient] = _balances[recipient].add(amountReceived);
341 
342         emit Transfer(sender, recipient, amountReceived);
343         return true;
344     }
345  
346     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
347         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
348         _balances[recipient] = _balances[recipient].add(amount);
349         emit Transfer(sender, recipient, amount);
350         return true;
351     }
352 
353     function checkTxLimit(address sender, uint256 amount) internal view {
354         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
355     }
356 
357     function shouldTakeFee(address sender) internal view returns (bool) {
358         return !isexemptfromfees[sender];
359     }
360 
361     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
362         
363         uint256 percent = transferpercent;
364         if(recipient == pair) {
365             percent = sellpercent;
366         } else if(sender == pair) {
367             percent = buypercent;
368         }
369 
370         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 1000);
371         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
372         uint256 contractTokens = feeAmount.sub(burnTokens);
373         _balances[address(this)] = _balances[address(this)].add(contractTokens);
374         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
375         emit Transfer(sender, address(this), contractTokens);
376         
377         
378         if(burnTokens > 0){
379             _totalSupply = _totalSupply.sub(burnTokens);
380             emit Transfer(sender, ZERO, burnTokens);  
381         
382         }
383 
384         return amount.sub(feeAmount);
385     }
386 
387     function shouldSwapBack() internal view returns (bool) {
388         return msg.sender != pair
389         && !inSwap
390         && swapEnabled
391         && _balances[address(this)] >= swapThreshold;
392     }
393 
394   
395     function manualSend() external { 
396              payable(autoLiquidityReceiver).transfer(address(this).balance);
397             
398     }
399 
400    function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
401         if(tokens == 0){
402             tokens = ERC20(tokenAddress).balanceOf(address(this));
403         }
404         emit ClearToken(tokenAddress, tokens);
405         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
406     }
407 
408     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
409         sellpercent = _percentonsell;
410         buypercent = _percentonbuy;
411         transferpercent = _wallettransfer;    
412           
413     }
414        
415     function startTrading() public onlyOwner {
416         TradingOpen = true;   
417     }
418 
419     function reduceFee() public onlyOwner {
420         buypercent = 0;
421         sellpercent = 0;
422         transferpercent = 0;
423     }
424 
425              
426     function swapBack() internal swapping {
427         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
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
451         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
452         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
453 
454         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
455         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
456         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
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
474     function set_fees() internal {
475       
476         emit EditTax( uint8(totalFee.mul(buypercent).div(feeDenominator)),
477             uint8(totalFee.mul(sellpercent).div(feeDenominator)),
478             uint8(totalFee.mul(transferpercent).div(feeDenominator))
479             );
480     }
481     
482     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
483         liquidityFee = _liquidityFee;
484         buybackFee = _buybackFee;
485         marketingFee = _marketingFee;
486         devFee = _devFee;
487         burnFee = _burnFee;
488         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
489         feeDenominator = _feeDenominator;
490         set_fees();
491     }
492 
493    
494     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
495         autoLiquidityReceiver = _autoLiquidityReceiver;
496         marketingFeeReceiver = _marketingFeeReceiver;
497         devFeeReceiver = _devFeeReceiver;
498         burnFeeReceiver = _burnFeeReceiver;
499         buybackFeeReceiver = _buybackFeeReceiver;
500 
501         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
502     }
503 
504     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
505         swapEnabled = _enabled;
506         swapThreshold = _amount;
507         emit set_SwapBack(swapThreshold, swapEnabled);
508     }
509 
510     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
511         return showBacking(accuracy) > ratio;
512     }
513 
514     function showBacking(uint256 accuracy) public view returns (uint256) {
515         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
516     }
517     
518     function showSupply() public view returns (uint256) {
519         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
520     }
521 }