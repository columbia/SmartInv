1 // SPDX-License-Identifier: MIT
2 // Website: https://benis.lol
3 
4 pragma solidity 0.8.20;
5 
6 interface ERC20 {
7     function totalSupply() external view returns (uint256);
8     function decimals() external view returns (uint8);
9     function symbol() external view returns (string memory);
10     function name() external view returns (string memory);
11     function getOwner() external view returns (address);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address _owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 
22 
23 abstract contract Context {
24     
25     function _msgSender() internal view virtual returns (address payable) {
26         return payable(msg.sender);
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this;
31         return msg.data;
32     }
33 }
34 
35 contract Ownable is Context {
36     address public _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor () {
41         address msgSender = _msgSender();
42         _owner = msgSender;
43         authorizations[_owner] = true;
44         emit OwnershipTransferred(address(0), msgSender);
45     }
46     mapping (address => bool) internal authorizations;
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface IDEXFactory {
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 }
72 
73 interface IDEXRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87 
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96 
97     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104 
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111 
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 }
120 
121 interface InterfaceLP {
122     function sync() external;
123 }
124 
125 
126 library SafeMath {
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         return div(a, b, "SafeMath: division by zero");
154     }
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         return c;
159     }
160 }
161 
162 contract BENIS is Ownable, ERC20 {
163     using SafeMath for uint256;
164 
165     address WETH;
166     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
167     address constant ZERO = 0x0000000000000000000000000000000000000000;
168     
169 
170     string constant _name = "BenisAintFree23Cents";
171     string constant _symbol = "BENIS";
172     uint8 constant _decimals = 18; 
173 
174 
175     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
176     event ClearStuck(uint256 amount);
177     event ClearToken(address TokenAddressCleared, uint256 Amount);
178     event set_SwapBack(uint256 Amount, bool Enabled);
179   
180     uint256 _totalSupply =  230000000000 * 10**_decimals; 
181 
182     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
183     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
184 
185     mapping (address => uint256) _balances;
186     mapping (address => mapping (address => uint256)) _allowances;  
187     mapping (address => bool) isexemptfromfees;
188     mapping (address => bool) isexemptfrommaxTX;
189 
190     uint256 private liquidityFee    = 10;
191     uint256 private marketingFee    = 27;
192     uint256 private devFee          = 63;
193     uint256 public totalFee         = marketingFee + liquidityFee + devFee;
194     uint256 private feeDenominator  = 1000;
195 
196     uint256 sellpercent = 100;
197     uint256 buypercent = 100;
198     uint256 transferpercent = 100; 
199 
200     address private autoLiquidityReceiver;
201     address private marketingFeeReceiver;
202     address private devFeeReceiver;
203 
204     uint256 setRatio = 12;
205     uint256 setRatioDenominator = 100;
206     
207 
208     IDEXRouter public router;
209     InterfaceLP private pairContract;
210     address public pair;
211     
212     bool public TradingOpen = false; 
213 
214    
215     bool public swapEnabled = true;
216     uint256 public swapThreshold = _totalSupply * 1 / 1000; 
217     bool inSwap;
218     modifier swapping() { inSwap = true; _; inSwap = false; }
219     
220     constructor () {
221         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
222         WETH = router.WETH();
223         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
224         pairContract = InterfaceLP(pair);
225        
226         
227         _allowances[address(this)][address(router)] = type(uint256).max;
228 
229         autoLiquidityReceiver = msg.sender;
230         marketingFeeReceiver = 0xA5708cdBb4e61A4B91428BF67e42D139b4274eFD;
231         devFeeReceiver = 0xd0316bA676df43871CDde89B38Fc496959EB5905;
232 
233         isexemptfromfees[msg.sender] = true;            
234         isexemptfrommaxTX[msg.sender] = true;
235         isexemptfrommaxTX[pair] = true;
236         isexemptfrommaxTX[marketingFeeReceiver] = true;
237         isexemptfrommaxTX[devFeeReceiver] = true;
238         isexemptfrommaxTX[address(this)] = true;
239         
240 
241         _balances[msg.sender] = _totalSupply;
242         emit Transfer(address(0), msg.sender, _totalSupply);
243 
244     }
245 
246     receive() external payable { }
247 
248     function totalSupply() external view override returns (uint256) { return _totalSupply; }
249     function decimals() external pure override returns (uint8) { return _decimals; }
250     function symbol() external pure override returns (string memory) { return _symbol; }
251     function name() external pure override returns (string memory) { return _name; }
252     function getOwner() external view override returns (address) {return owner();}
253     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
254     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
255 
256     function approve(address spender, uint256 amount) public override returns (bool) {
257         _allowances[msg.sender][spender] = amount;
258         emit Approval(msg.sender, spender, amount);
259         return true;
260     }
261 
262     function approveMax(address spender) external returns (bool) {
263         return approve(spender, type(uint256).max);
264     }
265 
266     function transfer(address recipient, uint256 amount) external override returns (bool) {
267         return _transferFrom(msg.sender, recipient, amount);
268     }
269 
270     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
271         if(_allowances[sender][msg.sender] != type(uint256).max){
272             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
273         }
274 
275         return _transferFrom(sender, recipient, amount);
276     }
277 
278     function removeLimits () external onlyOwner {
279             _maxTxAmount = _totalSupply;
280             _maxWalletToken = _totalSupply;
281     }
282 
283       
284     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
285         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
286 
287         if(!authorizations[sender] && !authorizations[recipient]){
288             require(TradingOpen,"Trading not open yet");
289         
290           }
291         
292                
293         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != marketingFeeReceiver && recipient != devFeeReceiver && !isexemptfrommaxTX[recipient]){
294             uint256 heldTokens = balanceOf(recipient);
295             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
296 
297         checkTxLimit(sender, amount);  
298 
299         if(shouldSwapBack()){ swapBack(); }
300         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
301 
302         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
303         _balances[recipient] = _balances[recipient].add(amountReceived);
304 
305         emit Transfer(sender, recipient, amountReceived);
306         return true;
307     }
308  
309     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
310         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
311         _balances[recipient] = _balances[recipient].add(amount);
312         emit Transfer(sender, recipient, amount);
313         return true;
314     }
315 
316     function checkTxLimit(address sender, uint256 amount) internal view {
317         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
318     }
319 
320     function shouldTakeFee(address sender) internal view returns (bool) {
321         return !isexemptfromfees[sender];
322     }
323 
324     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
325         
326         uint256 percent = transferpercent;
327         if(recipient == pair) {
328             percent = sellpercent;
329         } else if(sender == pair) {
330             percent = buypercent;
331         }
332 
333         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
334         _balances[address(this)] = _balances[address(this)].add(feeAmount);
335         emit Transfer(sender, address(this), feeAmount);
336 
337         return amount.sub(feeAmount);
338     }
339 
340     function shouldSwapBack() internal view returns (bool) {
341         return msg.sender != pair
342         && !inSwap
343         && swapEnabled
344         && _balances[address(this)] >= swapThreshold;
345     }
346 
347   
348      function manualSend() external { 
349              payable(autoLiquidityReceiver).transfer(address(this).balance);
350             
351     }
352 
353    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
354         if(tokens == 0){
355             tokens = ERC20(tokenAddress).balanceOf(address(this));
356         }
357         emit ClearToken(tokenAddress, tokens);
358         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
359     }
360        
361     function startTrading() public onlyOwner {
362         require(!TradingOpen, "Trading already opened!");
363         TradingOpen = true;
364         buypercent = 50;
365         sellpercent = 50;
366         transferpercent = 50;
367                               
368     }
369 
370     function reduceFee() public onlyOwner {
371        
372         buypercent = 20;
373         sellpercent = 20;
374         transferpercent = 0;
375     }
376 
377              
378     function swapBack() internal swapping {
379         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
380         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
381         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
382 
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = WETH;
386 
387         uint256 balanceBefore = address(this).balance;
388 
389         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
390             amountToSwap,
391             0,
392             path,
393             address(this),
394             block.timestamp
395         );
396 
397         uint256 amountETH = address(this).balance.sub(balanceBefore);
398 
399         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
400         
401         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
402         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
403         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
404 
405         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
406         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
407         
408         tmpSuccess = false;
409 
410         if(amountToLiquify > 0){
411             router.addLiquidityETH{value: amountETHLiquidity}(
412                 address(this),
413                 amountToLiquify,
414                 0,
415                 0,
416                 autoLiquidityReceiver,
417                 block.timestamp
418             );
419             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
420         }
421     }
422 
423     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
424         swapEnabled = _enabled;
425         swapThreshold = _amount;
426         emit set_SwapBack(swapThreshold, swapEnabled);
427     }
428 
429     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
430         return showBacking(accuracy) > ratio;
431     }
432 
433     function showBacking(uint256 accuracy) public view returns (uint256) {
434         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
435     }
436     
437     function showSupply() public view returns (uint256) {
438         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
439     }
440 
441 
442 }