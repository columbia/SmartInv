1 /*
2 https://twitter.com/erc20shibcoin
3 https://t.me/erc20shibcoin
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠛⠳⢿⡀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣖⠤⣀⠀⠀⠀⠀⠀⠀⣀⣀⣼⡇⢼⣾⡮⢇⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⣞⣷⡨⣗⣤⣶⢶⣻⡿⣽⡿⣿⣧⣽⣿⢇⠼⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠸⡏⢻⣿⡆⣽⣿⣟⡯⣟⣿⡷⣯⡝⣟⣯⠻⣯⣿⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⣾⡟⣿⣿⢻⡞⢻⡟⣿⣿⠁⠚⢻⣮⠙⡎⠛⡄⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⡿⠳⡙⡾⠿⡌⠹⡽⣏⡇⢸⣯⣼⠧⢀⡤⠜⡄⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⢀⢉⢉⠶⢶⣾⣦⣫⠴⣞⣾⡟⠁⡠⠈⠉⠉⠱⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⢡⠊⠉⠁⠉⠦⠍⣽⣏⣟⡳⢾⡹⡌⠀⠀⠀⠀⡱⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡌⠀⠀⠀⠀⠀⠀⡗⡚⣺⣿⣾⣍⠻⠀⠄⠀⢠⡇⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣞⢄⡀⠀⠀⠀⢀⡉⠀⢻⣿⣿⣟⠀⠀⠀⡦⠋⡄⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⢎⠳⠤⣀⠀⠀⠑⠠⠜⠛⠟⠋⠀⠀⠈⠢⠀⣧⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠧⣊⠿⡤⣀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢁⣿⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⠂⠹⠛⠀⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠍⠂⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢳⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⣰⢫⠘⣄⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡗⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⢰⢺⣻⢠⠞⠚⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⡀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⡇⢀⣿⡀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀
22 ⠀⠀⠀⠀⠀⠀⢰⢽⢸⡟⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀
23 ⠀⠀⠀⠀⠀⠀⣞⣾⢙⣙⣳⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀
24 ⠀⠀⠀⠀⠀⠀⡿⣜⡄⢶⡹⣻⢆⠀⠀⠀⠀⠀⠀⠉⠀⡀⠀⠀⠀⠀⠀⠀⣰⣫⠃⠀
25 ⠀⠀⠀⠀⠀⠀⡧⡇⡎⣞⢷⡹⣯⣆⠀⠀⠀⠀⠀⠀⠐⠁⠀⢨⠀⠀⠀⢀⢳⡇⠀⠀
26 ⠀⠀⠀⠀⠀⢠⣗⢣⠟⡸⢛⢷⠧⠁⡆⠀⣰⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠧⠍⡇⠀⠀
27 ⠀⠀⠀⠀⠀⣼⣾⣿⣾⡥⠸⠊⠔⠀⠇⢸⠁⠂⠀⠀⠀⢀⠀⣸⠀⡆⠀⠈⢣⡇⠀⠀
28 ⠀⠀⠀⠀⢰⣟⡿⢿⡿⣿⡀⠀⠀⠀⠆⣸⡀⠠⡆⠀⡘⠈⠠⡇⠀⠀⠀⠀⢸⠁⠀⠀
29 ⠀⠀⠀⢠⡞⣴⣾⣷⡳⠉⢁⠀⢠⠔⠀⣿⠇⢇⠃⡜⡇⢀⣼⣿⠀⠀⠀⠀⡞⠀⠀⠀
30 ⠀⠀⠀⣮⢷⡹⣿⣿⠅⠀⢘⡄⡲⡀⠀⣧⣾⣎⣾⣴⣴⣶⡿⠃⡆⠀⠀⠀⡇⠀⠀⠀
31 ⠀⠀⠘⣯⢷⡹⣞⡱⠈⠠⠈⣇⠀⠱⠈⡻⡚⡏⣙⣿⡿⠁⠀⠀⢸⠀⡐⠀⡇⠀⠀⠀
32 ⠀⠀⡴⣯⢧⣳⡍⢤⠃⠀⠀⢯⢀⠇⢠⣹⢶⣿⣿⡟⠃⠀⠀⠀⠀⣷⠣⠀⢗⠀⠀⠀
33 ⠀⣼⣿⣼⣿⣧⡛⡼⠀⡠⠃⣸⢼⠛⡀⣟⣸⣿⣿⠇⠠⠘⠀⠀⠀⡟⡀⡇⢸⠀⠀⠀
34 ⢸⣾⡿⠿⡿⠷⠟⠁⢁⢀⢠⡇⢌⡢⢅⡷⣿⣟⠃⠀⠀⠀⠀⠀⣠⣗⠸⢛⢸⡄⠀⠀
35 ⠈⣼⣿⣋⣷⣶⡾⣿⣧⡈⡇⠷⢎⡜⡣⢹⡹⡒⣂⣔⠥⣀⡀⢀⢿⣇⣆⠈⠀⣿⣦⠀
36 ⠀⠻⠿⣿⣿⢻⢉⡇⢹⡿⠤⢸⣇⣕⣡⣽⠓⠛⠋⠉⠉⠀⠀⠀⠀⠈⢯⡶⡿⠿⡥⡀
37 ⠀⠀⠀⠀⠉⠉⠛⠷⠾⠃⠀⢨⣼⠁⣇⣹⡗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⣿⣄⣽⡼
38 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢛⠒⠛⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
39 */
40 
41 //SPDX-License-Identifier: MIT
42 
43 pragma solidity 0.8.20;
44 
45 interface ERC20 {
46     function totalSupply() external view returns (uint256);
47     function decimals() external view returns (uint8);
48     function symbol() external view returns (string memory);
49     function name() external view returns (string memory);
50     function getOwner() external view returns (address);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address _owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 
61 
62 abstract contract Context {
63     
64     function _msgSender() internal view virtual returns (address payable) {
65         return payable(msg.sender);
66     }
67 
68     function _msgData() internal view virtual returns (bytes memory) {
69         this;
70         return msg.data;
71     }
72 }
73 
74 contract Ownable is Context {
75     address public _owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         authorizations[_owner] = true;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85     mapping (address => bool) internal authorizations;
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 interface IDEXFactory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IDEXRouter {
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115 
116     function addLiquidity(
117         address tokenA,
118         address tokenB,
119         uint amountADesired,
120         uint amountBDesired,
121         uint amountAMin,
122         uint amountBMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountA, uint amountB, uint liquidity);
126 
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 
136     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 
144     function swapExactETHForTokensSupportingFeeOnTransferTokens(
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external payable;
150 
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158 }
159 
160 interface InterfaceLP {
161     function sync() external;
162 }
163 
164 
165 library SafeMath {
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b <= a, errorMessage);
177         uint256 c = a - b;
178 
179         return c;
180     }
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         return c;
198     }
199 }
200 
201 contract erc20SHIB is Ownable, ERC20 {
202     using SafeMath for uint256;
203 
204     address WETH;
205     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
206     address constant ZERO = 0x0000000000000000000000000000000000000000;
207     
208 
209     string constant _name = "2.0 SHIBA INU";
210     string constant _symbol = "2.0SHIB";
211     uint8 constant _decimals = 18; 
212 
213 
214     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
215     event EditTax(uint8 Buy, uint8 Sell, uint8 Transfer);
216     event user_exemptfromfees(address Wallet, bool Exempt);
217     event user_TxExempt(address Wallet, bool Exempt);
218     event ClearStuck(uint256 amount);
219     event ClearToken(address TokenAddressCleared, uint256 Amount);
220     event set_Receivers(address marketingFeeReceiver, address buybackFeeReceiver,address burnFeeReceiver,address devFeeReceiver);
221     event set_MaxWallet(uint256 maxWallet);
222     event set_MaxTX(uint256 maxTX);
223     event set_SwapBack(uint256 Amount, bool Enabled);
224   
225     uint256 _totalSupply =  420690000000000 * 10**_decimals; 
226 
227     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100);
228     uint256 public _maxWalletToken = _totalSupply.mul(2).div(100);
229 
230     mapping (address => uint256) _balances;
231     mapping (address => mapping (address => uint256)) _allowances;  
232     mapping (address => bool) isexemptfromfees;
233     mapping (address => bool) isexemptfrommaxTX;
234 
235     uint256 private liquidityFee    = 1;
236     uint256 private marketingFee    = 2;
237     uint256 private devFee          = 0;
238     uint256 private buybackFee      = 1; 
239     uint256 private burnFee         = 0;
240     uint256 public totalFee         = buybackFee + marketingFee + liquidityFee + devFee + burnFee;
241     uint256 private feeDenominator  = 100;
242 
243     uint256 sellpercent = 100;
244     uint256 buypercent = 100;
245     uint256 transferpercent = 100; 
246 
247     address private autoLiquidityReceiver;
248     address private marketingFeeReceiver;
249     address private devFeeReceiver;
250     address private buybackFeeReceiver;
251     address private burnFeeReceiver;
252 
253     uint256 setRatio = 30;
254     uint256 setRatioDenominator = 100;
255     
256 
257     IDEXRouter public router;
258     InterfaceLP private pairContract;
259     address public pair;
260     
261     bool public TradingOpen = false; 
262 
263    
264     bool public swapEnabled = true;
265     uint256 public swapThreshold = _totalSupply * 4 / 1000; 
266     bool inSwap;
267     modifier swapping() { inSwap = true; _; inSwap = false; }
268     
269     constructor () {
270         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
271         WETH = router.WETH();
272         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
273         pairContract = InterfaceLP(pair);
274        
275         
276         _allowances[address(this)][address(router)] = type(uint256).max;
277 
278         isexemptfromfees[msg.sender] = true;            
279         isexemptfrommaxTX[msg.sender] = true;
280         isexemptfrommaxTX[pair] = true;
281         isexemptfrommaxTX[marketingFeeReceiver] = true;
282         isexemptfrommaxTX[address(this)] = true;
283         
284         autoLiquidityReceiver = msg.sender;
285         marketingFeeReceiver = 0x21ffcEf98a884217C30bBE73bb350AE23261308e; 
286         devFeeReceiver = msg.sender;
287         buybackFeeReceiver = msg.sender;
288         burnFeeReceiver = DEAD; 
289 
290         _balances[msg.sender] = _totalSupply;
291         emit Transfer(address(0), msg.sender, _totalSupply);
292 
293     }
294 
295     receive() external payable { }
296 
297     function totalSupply() external view override returns (uint256) { return _totalSupply; }
298     function decimals() external pure override returns (uint8) { return _decimals; }
299     function symbol() external pure override returns (string memory) { return _symbol; }
300     function name() external pure override returns (string memory) { return _name; }
301     function getOwner() external view override returns (address) {return owner();}
302     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
303     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
304 
305     function approve(address spender, uint256 amount) public override returns (bool) {
306         _allowances[msg.sender][spender] = amount;
307         emit Approval(msg.sender, spender, amount);
308         return true;
309     }
310 
311     function approveMax(address spender) external returns (bool) {
312         return approve(spender, type(uint256).max);
313     }
314 
315     function transfer(address recipient, uint256 amount) external override returns (bool) {
316         return _transferFrom(msg.sender, recipient, amount);
317     }
318 
319     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
320         if(_allowances[sender][msg.sender] != type(uint256).max){
321             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
322         }
323 
324         return _transferFrom(sender, recipient, amount);
325     }
326 
327         function maxWalletRule(uint256 maxWallPercent) external onlyOwner {
328          require(maxWallPercent >= 1); 
329         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
330         emit set_MaxWallet(_maxWalletToken);
331                 
332     }
333 
334       function removeLimits () external onlyOwner {
335             _maxTxAmount = _totalSupply;
336             _maxWalletToken = _totalSupply;
337     }
338 
339       
340     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
341         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
342 
343         if(!authorizations[sender] && !authorizations[recipient]){
344             require(TradingOpen,"Trading not open yet");
345         
346           }
347         
348                
349         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != marketingFeeReceiver && !isexemptfrommaxTX[recipient]){
350             uint256 heldTokens = balanceOf(recipient);
351             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
352 
353         checkTxLimit(sender, amount);  
354 
355         if(shouldSwapBack()){ swapBack(); }
356         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
357 
358         uint256 amountReceived = (isexemptfromfees[sender] || isexemptfromfees[recipient]) ? amount : takeFee(sender, amount, recipient);
359         _balances[recipient] = _balances[recipient].add(amountReceived);
360 
361         emit Transfer(sender, recipient, amountReceived);
362         return true;
363     }
364  
365     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
366         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
367         _balances[recipient] = _balances[recipient].add(amount);
368         emit Transfer(sender, recipient, amount);
369         return true;
370     }
371 
372     function checkTxLimit(address sender, uint256 amount) internal view {
373         require(amount <= _maxTxAmount || isexemptfrommaxTX[sender], "TX Limit Exceeded");
374     }
375 
376     function shouldTakeFee(address sender) internal view returns (bool) {
377         return !isexemptfromfees[sender];
378     }
379 
380     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
381         
382         uint256 percent = transferpercent;
383         if(recipient == pair) {
384             percent = sellpercent;
385         } else if(sender == pair) {
386             percent = buypercent;
387         }
388 
389         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
390         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
391         uint256 contractTokens = feeAmount.sub(burnTokens);
392         _balances[address(this)] = _balances[address(this)].add(contractTokens);
393         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
394         emit Transfer(sender, address(this), contractTokens);
395         
396         
397         if(burnTokens > 0){
398             _totalSupply = _totalSupply.sub(burnTokens);
399             emit Transfer(sender, ZERO, burnTokens);  
400         
401         }
402 
403         return amount.sub(feeAmount);
404     }
405 
406     function shouldSwapBack() internal view returns (bool) {
407         return msg.sender != pair
408         && !inSwap
409         && swapEnabled
410         && _balances[address(this)] >= swapThreshold;
411     }
412 
413   
414      function manualSend() external { 
415              payable(autoLiquidityReceiver).transfer(address(this).balance);
416             
417     }
418 
419    function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
420              if(tokens == 0){
421             tokens = ERC20(tokenAddress).balanceOf(address(this));
422         }
423         emit ClearToken(tokenAddress, tokens);
424         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
425     }
426 
427     function setStructure(uint256 _percentonbuy, uint256 _percentonsell, uint256 _wallettransfer) external onlyOwner {
428         sellpercent = _percentonsell;
429         buypercent = _percentonbuy;
430         transferpercent = _wallettransfer;    
431           
432     }
433        
434     function startTrading() public onlyOwner {
435         TradingOpen = true;
436         buypercent = 700;
437         sellpercent = 1000;
438         transferpercent = 1000;
439                               
440     }
441 
442       function reduceFee() public onlyOwner {
443        
444         buypercent = 100;
445         sellpercent = 100;
446         transferpercent = 0;
447                               
448     }
449 
450              
451     function swapBack() internal swapping {
452         uint256 dynamicLiquidityFee = checkRatio(setRatio, setRatioDenominator) ? 0 : liquidityFee;
453         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
454         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
455 
456         address[] memory path = new address[](2);
457         path[0] = address(this);
458         path[1] = WETH;
459 
460         uint256 balanceBefore = address(this).balance;
461 
462         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
463             amountToSwap,
464             0,
465             path,
466             address(this),
467             block.timestamp
468         );
469 
470         uint256 amountETH = address(this).balance.sub(balanceBefore);
471 
472         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
473         
474         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
475         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
476         uint256 amountETHbuyback = amountETH.mul(buybackFee).div(totalETHFee);
477         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
478 
479         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETHMarketing}("");
480         (tmpSuccess,) = payable(devFeeReceiver).call{value: amountETHdev}("");
481         (tmpSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback}("");
482         
483         tmpSuccess = false;
484 
485         if(amountToLiquify > 0){
486             router.addLiquidityETH{value: amountETHLiquidity}(
487                 address(this),
488                 amountToLiquify,
489                 0,
490                 0,
491                 autoLiquidityReceiver,
492                 block.timestamp
493             );
494             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
495         }
496     }
497     
498   
499     function set_fees() internal {
500       
501         emit EditTax( uint8(totalFee.mul(buypercent).div(100)),
502             uint8(totalFee.mul(sellpercent).div(100)),
503             uint8(totalFee.mul(transferpercent).div(100))
504             );
505     }
506     
507     function setParameters(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee, uint256 _devFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
508         liquidityFee = _liquidityFee;
509         buybackFee = _buybackFee;
510         marketingFee = _marketingFee;
511         devFee = _devFee;
512         burnFee = _burnFee;
513         totalFee = _liquidityFee.add(_buybackFee).add(_marketingFee).add(_devFee).add(_burnFee);
514         feeDenominator = _feeDenominator;
515         require(totalFee < feeDenominator / 2, "Fees can not be more than 50%"); 
516         set_fees();
517     }
518 
519    
520     function setWallets(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver, address _burnFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
521         autoLiquidityReceiver = _autoLiquidityReceiver;
522         marketingFeeReceiver = _marketingFeeReceiver;
523         devFeeReceiver = _devFeeReceiver;
524         burnFeeReceiver = _burnFeeReceiver;
525         buybackFeeReceiver = _buybackFeeReceiver;
526 
527         emit set_Receivers(marketingFeeReceiver, buybackFeeReceiver, burnFeeReceiver, devFeeReceiver);
528     }
529 
530     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
531         swapEnabled = _enabled;
532         swapThreshold = _amount;
533         emit set_SwapBack(swapThreshold, swapEnabled);
534     }
535 
536     function checkRatio(uint256 ratio, uint256 accuracy) public view returns (bool) {
537         return showBacking(accuracy) > ratio;
538     }
539 
540     function showBacking(uint256 accuracy) public view returns (uint256) {
541         return accuracy.mul(balanceOf(pair).mul(2)).div(showSupply());
542     }
543     
544     function showSupply() public view returns (uint256) {
545         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
546     }
547 
548 
549 }