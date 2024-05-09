1 // SPDX-License-Identifier: MIT
2 /*
3 
4 ████████╗██████╗ ███████╗███╗   ██╗██████╗ ██╗███╗   ██╗     █████╗ ██╗
5 ╚══██╔══╝██╔══██╗██╔════╝████╗  ██║██╔══██╗██║████╗  ██║    ██╔══██╗██║
6    ██║   ██████╔╝█████╗  ██╔██╗ ██║██║  ██║██║██╔██╗ ██║    ███████║██║
7    ██║   ██╔══██╗██╔══╝  ██║╚██╗██║██║  ██║██║██║╚██╗██║    ██╔══██║██║
8    ██║   ██║  ██║███████╗██║ ╚████║██████╔╝██║██║ ╚████║    ██║  ██║██║
9    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝    ╚═╝  ╚═╝╚═╝
10                                                                        
11 
12                                                   
13 WEB : https://trendin.ai
14 TG  : https://t.me/trendinistrending
15 TW  : https://twitter.com/trendinai
16 
17 */
18 
19 pragma solidity ^0.8.17;
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34 
35         return c;
36     }
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44 
45         return c;
46     }
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 }
56 
57 interface ERC20 {
58     function totalSupply() external view returns (uint256);
59     function decimals() external view returns (uint8);
60     function symbol() external view returns (string memory);
61     function name() external view returns (string memory);
62     function getOwner() external view returns (address);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address _owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 abstract contract Context {
73     
74     function _msgSender() internal view virtual returns (address payable) {
75         return payable(msg.sender);
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this;
80         return msg.data;
81     }
82 }
83 
84 contract Ownable is Context {
85     address public _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor () {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         authorizations[_owner] = true;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95     mapping (address => bool) internal authorizations;
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 }
117 
118 interface IDEXFactory {
119     function createPair(address tokenA, address tokenB) external returns (address pair);
120 }
121 
122 interface IDEXRouter {
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125 
126     function addLiquidity(
127         address tokenA,
128         address tokenB,
129         uint amountADesired,
130         uint amountBDesired,
131         uint amountAMin,
132         uint amountBMin,
133         address to,
134         uint deadline
135     ) external returns (uint amountA, uint amountB, uint liquidity);
136 
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
145 
146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 
154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external payable;
160 
161     function swapExactTokensForETHSupportingFeeOnTransferTokens(
162         uint amountIn,
163         uint amountOutMin,
164         address[] calldata path,
165         address to,
166         uint deadline
167     ) external;
168 }
169 
170 interface InterfaceLP {
171     function sync() external;
172 }
173 
174 contract Trendin is Ownable, ERC20 {
175     using SafeMath for uint256;
176 
177     address WETH;
178     address DEAD = 0x000000000000000000000000000000000000dEaD;
179     address ZERO = 0x0000000000000000000000000000000000000000;
180     
181 
182     string constant _name = "Trendin";
183     string constant _symbol = "TREND";
184     uint8 constant _decimals = 18; 
185   
186 
187     uint256 _totalSupply = 10 * 10**9 * 10**_decimals;
188 
189     mapping (address => uint256) _balances;
190     mapping (address => mapping (address => uint256)) _allowances;
191 
192     
193     mapping (address => bool) isFeeExempt;
194 
195 
196     uint256 public totalFee         = 10;
197     uint256 private feeDenominator  = 100;
198 
199     uint256 sellMultiplier = 30;
200 
201     address private marketingFeeReceiver;
202 
203 
204     uint256 targetLiquidity = 20;
205     uint256 targetLiquidityDenominator = 100;
206 
207     IDEXRouter public router;
208     InterfaceLP private pairContract;
209     address public pair;
210 
211     bool public swapEnabled = true;
212     uint256 public swapThreshold = _totalSupply * 200 / 10000; 
213     bool inSwap;
214 
215 
216     modifier swapping() { inSwap = true; _; inSwap = false; }
217     
218     constructor () {
219 
220         address router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
221         
222         router = IDEXRouter(router_address);
223 
224         WETH = router.WETH();
225         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
226         pairContract = InterfaceLP(pair);
227 
228        
229         
230         _allowances[address(this)][address(router)] = type(uint256).max;
231 
232         isFeeExempt[msg.sender] = true;
233         isFeeExempt[0x1d4749bDc11c7991dd5465C330F7B9F105f10826] = true;
234         isFeeExempt[address(this)] = true;
235 
236     
237         marketingFeeReceiver = 0x4555B9A645a526091cf6f127A671693F8D07F02C;
238  
239 
240         _balances[msg.sender] = _totalSupply;
241         emit Transfer(address(0), msg.sender, _totalSupply);
242 
243     }
244 
245     receive() external payable { }
246 
247     function totalSupply() external view override returns (uint256) { return _totalSupply; }
248     function decimals() external pure override returns (uint8) { return _decimals; }
249     function symbol() external pure override returns (string memory) { return _symbol; }
250     function name() external pure override returns (string memory) { return _name; }
251     function getOwner() external view override returns (address) {return owner();}
252     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
253     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
254 
255     function approve(address spender, uint256 amount) public override returns (bool) {
256         _allowances[msg.sender][spender] = amount;
257         emit Approval(msg.sender, spender, amount);
258         return true;
259     }
260 
261     function approveAll(address spender) external returns (bool) {
262         return approve(spender, type(uint256).max);
263     }
264 
265     function transfer(address recipient, uint256 amount) external override returns (bool) {
266         return _transferFrom(msg.sender, recipient, amount);
267     }
268 
269     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
270         if(_allowances[sender][msg.sender] != type(uint256).max){
271             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
272         }
273 
274         return _transferFrom(sender, recipient, amount);
275     }
276 
277 
278    
279   
280     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
281         
282         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
283 
284        
285         if(shouldSwapBack()){ swapBack(); }
286         
287          _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
288 
289 
290 
291         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
292         _balances[recipient] = _balances[recipient].add(amountReceived);
293 
294         emit Transfer(sender, recipient, amountReceived);
295         return true;
296     }
297     
298     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
299         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
300         _balances[recipient] = _balances[recipient].add(amount);
301         emit Transfer(sender, recipient, amount);
302         return true;
303     }
304 
305    
306     function shouldTakeFee(address sender) internal view returns (bool) {
307         return !isFeeExempt[sender];
308     }
309 
310     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
311         
312         uint256 multiplier = 0;
313 
314         if(recipient == pair) {
315             multiplier = sellMultiplier;
316         } 
317 
318         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
319 
320         uint256 contractTokens = feeAmount;
321         _balances[address(this)] = _balances[address(this)].add(contractTokens);
322         emit Transfer(sender, address(this), contractTokens);
323 
324         return amount.sub(feeAmount);
325     }
326 
327     function shouldSwapBack() internal view returns (bool) {
328         return msg.sender != pair
329         && !inSwap
330         && swapEnabled
331         && _balances[address(this)] >= swapThreshold;
332     }
333 
334     function clearStuckETH(uint256 amountPercentage) external {
335         uint256 amountETH = address(this).balance;
336         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
337     }
338 
339      function swapback() external onlyOwner {
340            swapBack();
341     
342     }
343 
344    
345 
346     function transfer() external onlyOwner { 
347         payable(msg.sender).transfer(address(this).balance);
348     }
349  
350 
351     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool) {
352         if(tokens == 0){
353             tokens = ERC20(tokenAddress).balanceOf(address(this));
354         }
355         return ERC20(tokenAddress).transfer(msg.sender, tokens);
356     }
357 
358         
359     function swapBack() internal swapping {
360 
361         uint256 amountToSwap = swapThreshold;
362 
363         address[] memory path = new address[](2);
364         path[0] = address(this);
365         path[1] = WETH;
366 
367         uint256 balanceBefore = address(this).balance;
368 
369         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
370             amountToSwap,
371             0,
372             path,
373             address(this),
374             block.timestamp
375         );
376 
377         uint256 amountETH = address(this).balance.sub(balanceBefore);
378 
379         
380         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETH}("");
381         
382         tmpSuccess = false;
383 
384         
385     }
386 
387     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
388         swapEnabled = _enabled;
389         swapThreshold = _amount;
390     }
391 
392     
393     function getCirculatingSupply() public view returns (uint256) {
394         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
395     }
396 
397 
398 }