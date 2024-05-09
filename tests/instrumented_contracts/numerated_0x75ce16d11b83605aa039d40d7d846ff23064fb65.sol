1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 pragma solidity 0.8.0;
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
166 contract DUBX is Ownable, ERC20 {
167     using SafeMath for uint256;
168 
169     address WETH;
170     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
171     address constant ZERO = 0x0000000000000000000000000000000000000000;
172     
173 
174     string constant _name = "DUBX";
175     string constant _symbol = "DUB";
176     uint8 constant _decimals = 9; 
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
190     uint256 _totalSupply =  1000000000000000 * 10 **_decimals; 
191 
192     uint256 public _maxTxAmount = _totalSupply;
193     uint256 public _maxWalletToken = _totalSupply;
194 
195     mapping (address => uint256) _balances;
196     mapping (address => mapping (address => uint256)) _allowances;  
197     mapping (address => bool) isexemptfromfees;
198     mapping (address => bool) isexemptfrommaxTX;
199 
200     uint256 private liquidityFee    = 0;
201     uint256 private marketingFee    = 2;
202     uint256 private devFee          = 0;
203     uint256 private buybackFee      = 0; 
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
226    
227     bool public swapEnabled = true;
228     uint256 public swapThreshold = _totalSupply * 70 / 1000; 
229     bool inSwap;
230     modifier swapping() { inSwap = true; _; inSwap = false; }
231     
232     constructor () {
233         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234         WETH = router.WETH();
235         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
236         pairContract = InterfaceLP(pair);
237        
238         
239         _allowances[address(this)][address(router)] = type(uint256).max;
240 
241         isexemptfromfees[msg.sender] = true;            
242         isexemptfrommaxTX[msg.sender] = true;
243         isexemptfrommaxTX[pair] = true;
244         isexemptfrommaxTX[marketingFeeReceiver] = true;
245         isexemptfrommaxTX[address(this)] = true;
246         
247         autoLiquidityReceiver = msg.sender;
248         marketingFeeReceiver = 0x18a4486C2E8a27B726F8af24e2e77858D454e556;
249         devFeeReceiver = msg.sender;
250         buybackFeeReceiver = msg.sender;
251         burnFeeReceiver = DEAD; 
252 
253         _balances[msg.sender] = _totalSupply;
254         emit Transfer(address(0), msg.sender, _totalSupply);
255 
256     }
257 
258     receive() external payable { }
259 
260     function totalSupply() external view override returns (uint256) { return _totalSupply; }
261     function decimals() external pure override returns (uint8) { return _decimals; }
262     function symbol() external pure override returns (string memory) { return _symbol; }
263     function name() external pure override returns (string memory) { return _name; }
264     function getOwner() external view override returns (address) {return owner();}
265     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
266     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
267 
268     function approve(address spender, uint256 amount) public override returns (bool) {
269         _allowances[msg.sender][spender] = amount;
270         emit Approval(msg.sender, spender, amount);
271         return true;
272     }
273 
274     function approveMax(address spender) external returns (bool) {
275         return approve(spender, type(uint256).max);
276     }
277 
278     function transfer(address recipient, uint256 amount) external override returns (bool) {
279         return _transferFrom(msg.sender, recipient, amount);
280     }
281 
282     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
283         if(_allowances[sender][msg.sender] != type(uint256).max){
284             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
285         }
286 
287         return _transferFrom(sender, recipient, amount);
288     }
289 
290         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
291          require(maxWallPercent >= 1); 
292         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
293         emit set_MaxWallet(_maxWalletToken);
294                 
295     }
296 
297       function removeLimits () external onlyOwner {
298             _maxTxAmount = _totalSupply;
299             _maxWalletToken = _totalSupply;
300     }
301 
302       
303     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
304         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
305 
306         if(!authorizations[sender] && !authorizations[recipient]){
307         
308           }
309         
310                
311         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
312             uint256 heldTokens = balanceOf(recipient);
313             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
314 
315         checkTxLimit(sender, amount);  
316 
317         if(shouldSwapBack()){ swapBack(); }
318         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
319 
320         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
321         _balances[recipient] = _balances[recipient].add(amountReceived);
322 
323         emit Transfer(sender, recipient, amountReceived);
324         return true;
325     }
326  
327     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
328         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
329         _balances[recipient] = _balances[recipient].add(amount);
330         emit Transfer(sender, recipient, amount);
331         return true;
332     }
333 
334     function checkTxLimit(address sender, uint256 amount) internal view {
335         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
336     }
337 
338     function shouldTakeFee(address sender) internal view returns (bool) {
339         return !isexemptfromfees[sender];
340     }
341 
342     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
343         
344         uint256 percent = transferpercent;
345         if(recipient == pair) {
346             percent = sellpercent;
347         } else if(sender == pair) {
348             percent = buypercent;
349         }
350 
351         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
352         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
353         uint256 contractTokens = feeAmount.sub(burnTokens);
354         _balances[address(this)] = _balances[address(this)].add(contractTokens);
355         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
356         emit Transfer(sender, address(this), contractTokens);
357         
358         
359         if(burnTokens > 0){
360             _totalSupply = _totalSupply.sub(burnTokens);
361             emit Transfer(sender, ZERO, burnTokens);  
362         
363         }
364 
365         return amount.sub(feeAmount);
366     }
367 
368     function shouldSwapBack() internal view returns (bool) {
369         return msg.sender != pair
370         && !inSwap
371         && swapEnabled
372         && _balances[address(this)] >= swapThreshold;
373     }
374 
375   
376      function manualSend() external { 
377              payable(autoLiquidityReceiver).transfer(address(this).balance);
378             
379     }
380 
381    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
382              if(tokens == 0){
383             tokens = ERC20(tokenAddress).balanceOf(address(this));
384         }
385         emit ClearToken(tokenAddress, tokens);
386         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
387     }
388 
389     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
390         sellpercent = _percentonsell;
391         buypercent = _percentonbuy;
392         transferpercent = _wallettransfer;    
393           
394     }
395 
396              
397     function swapBack() internal swapping {
398         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
399         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
400         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
401 
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = WETH;
405 
406         uint256 balanceBefore = address(this).balance;
407 
408         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
409             amountToSwap,
410             0,
411             path,
412             address(this),
413             block.timestamp
414         );
415 
416         uint256 amountETH = address(this).balance.sub(balanceBefore);
417 
418         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
419         
420         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
421         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
422         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
423         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
424 
425         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
426         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
427         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
428         
429         tmpSuccess = false;
430 
431         if(amountToLiquify > 0){
432             router.addLiquidityETH{value: amountETHLiquidity}(
433                 address(this),
434                 amountToLiquify,
435                 0,
436                 0,
437                 autoLiquidityReceiver,
438                 block.timestamp
439             );
440             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
441         }
442     }
443     
444   
445     function set_fees() internal {
446       
447         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
448             uint8(totalFee.mul(sellpercent).div(100)),
449             uint8(totalFee.mul(transferpercent).div(100))
450             );
451     }
452     
453     function setParameters() external onlyOwner {
454     
455         set_fees();
456     }
457 
458    
459     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
460         autoLiquidityReceiver = _autoLiquidityReceiver;
461         marketingFeeReceiver = _marketingFeeReceiver;
462         devFeeReceiver = _devFeeReceiver;
463         burnFeeReceiver = _burnFeeReceiver;
464         buybackFeeReceiver = _buybackFeeReceiver;
465 
466         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
467     }
468 
469     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
470         swapEnabled = _enabled;
471         swapThreshold = _amount * 10 ** _decimals;
472         emit set_SwapBack(swapThreshold, swapEnabled);
473     }
474 
475     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
476         return showBacking(accuracy) > ratio;
477     }
478 
479     function showBacking(uint256 accuracy) public view returns (uint256) {
480         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
481     }
482     
483     function showSupply() public view returns (uint256) {
484         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
485     }
486 
487 
488 }