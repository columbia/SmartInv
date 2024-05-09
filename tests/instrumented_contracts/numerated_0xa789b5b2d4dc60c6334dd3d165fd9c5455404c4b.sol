1 /*
2 
3 Website: waifucoin.io
4 Telegram: t.me/waifuerc
5 Twitter: twitter.com/waifueth
6 
7 
8                             ██████                          
9                               ██                            
10                               ██                            
11                               ██                            
12                               ██                            
13                             ██████                          
14                                                             
15                                                             
16                 ▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓                
17                 ▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓▓▓▓▓▓▓▓▓                
18             ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓            
19             ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓            
20         ▒▒▓▓▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓        
21         ▓▓▓▓▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓        
22         ▓▓▓▓▒▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓        
23         ▓▓▓▓▒▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓        
24         ▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓        
25             ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒░░          
26             ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓            
27                 ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                
28                 ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                
29                     ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓                  
30                     ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓░░                  
31                         ▓▓▓▓▒▒▒▒▒▒▓▓▓▓                      
32                         ▓▓▓▓▒▒▒▒▒▒▓▓▓▓                      
33                           ░░▓▓▓▓▓▓                          
34                             ▓▓▓▓▓▓                          
35                                                             
36                                                             
37   ██████                      ██                            
38 ██      ██                                                  
39 ██      ██  ██████████      ████      ████████      ██████  
40 ██████████  ██        ██      ██      ██  ██  ██  ██      ██
41 ██      ██  ██        ██      ██      ██  ██  ██  ██████████
42 ██      ██  ██        ██      ██      ██  ██  ██  ██        
43 ██      ██  ██        ██    ██████    ██  ██  ██    ██████  
44 
45 
46 */
47 
48 
49 // SPDX-License-Identifier: MIT
50 pragma solidity ^0.8.5;
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55         return c;
56     }
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 }
82 
83 interface ERC20 {
84     function totalSupply() external view returns (uint256);
85     function decimals() external view returns (uint8);
86     function symbol() external view returns (string memory);
87     function name() external view returns (string memory);
88     function getOwner() external view returns (address);
89     function balanceOf(address account) external view returns (uint256);
90     function transfer(address recipient, uint256 amount) external returns (bool);
91     function allowance(address _owner, address spender) external view returns (uint256);
92     function approve(address spender, uint256 amount) external returns (bool);
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 abstract contract Ownable {
99     address internal owner;
100     constructor(address _owner) {
101         owner = _owner;
102     }
103     modifier onlyOwner() {
104         require(isOwner(msg.sender), "!OWNER"); _;
105     }
106     function isOwner(address account) public view returns (bool) {
107         return account == owner;
108     }
109     function renounceOwnership() public onlyOwner {
110         owner = address(0);
111         emit OwnershipTransferred(address(0));
112     }  
113     event OwnershipTransferred(address owner);
114 }
115 
116 interface IDEXFactory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IDEXRouter {
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
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
133     function addLiquidityETH(
134         address token,
135         uint amountTokenDesired,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external payable;
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161 }
162 
163 contract WaifuAI is ERC20, Ownable {
164     using SafeMath for uint256;
165     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
166     address DEAD = 0x000000000000000000000000000000000000dEaD;
167 
168     string constant _name = "WAIFU AI";
169     string constant _symbol = "WAIFU";
170     uint8 constant _decimals = 9;
171 
172     uint256 _totalSupply = 1000000 * (10 ** _decimals);
173     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
174 
175     mapping (address => uint256) _balances;
176     mapping (address => mapping (address => uint256)) _allowances;
177 
178     mapping (address => bool) isFeeExempt;
179     mapping (address => bool) isTxLimitExempt;
180 
181     uint256 liquidityFee = 0; 
182     uint256 marketingFee = 4;
183     uint256 totalFee = liquidityFee + marketingFee;
184     uint256 feeDenominator = 100;
185 
186     address internal marketingFeeReceiver = 0xa7a61c4F1A9977DE63e3A3449BB103111c408435;
187 
188     IDEXRouter public router;
189     address public pair;
190 
191     bool public swapEnabled = true;
192     uint256 public swapThreshold = _totalSupply / 1000 * 2; // 0.5%
193     bool inSwap;
194     modifier swapping() { inSwap = true; _; inSwap = false; }
195 
196     constructor () Ownable(msg.sender) {
197         router = IDEXRouter(routerAdress);
198         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
199         _allowances[address(this)][address(router)] = type(uint256).max;
200 
201         address _owner = owner;
202         isFeeExempt[0xa7a61c4F1A9977DE63e3A3449BB103111c408435] = true;
203         isTxLimitExempt[_owner] = true;
204         isTxLimitExempt[0xa7a61c4F1A9977DE63e3A3449BB103111c408435] = true;
205         isTxLimitExempt[DEAD] = true;
206 
207         _balances[_owner] = _totalSupply;
208         emit Transfer(address(0), _owner, _totalSupply);
209     }
210 
211     receive() external payable { }
212 
213     function totalSupply() external view override returns (uint256) { return _totalSupply; }
214     function decimals() external pure override returns (uint8) { return _decimals; }
215     function symbol() external pure override returns (string memory) { return _symbol; }
216     function name() external pure override returns (string memory) { return _name; }
217     function getOwner() external view override returns (address) { return owner; }
218     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
219     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
220 
221     function approve(address spender, uint256 amount) public override returns (bool) {
222         _allowances[msg.sender][spender] = amount;
223         emit Approval(msg.sender, spender, amount);
224         return true;
225     }
226 
227     function approveMax(address spender) external returns (bool) {
228         return approve(spender, type(uint256).max);
229     }
230 
231     function transfer(address recipient, uint256 amount) external override returns (bool) {
232         return _transferFrom(msg.sender, recipient, amount);
233     }
234 
235     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
236         if(_allowances[sender][msg.sender] != type(uint256).max){
237             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
238         }
239 
240         return _transferFrom(sender, recipient, amount);
241     }
242 
243     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
244         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
245         
246         if (recipient != pair && recipient != DEAD) {
247             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
248         }
249         
250         if(shouldSwapBack()){ swapBack(); } 
251 
252         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
253 
254         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
255         _balances[recipient] = _balances[recipient].add(amountReceived);
256 
257         emit Transfer(sender, recipient, amountReceived);
258         return true;
259     }
260     
261     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
262         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
263         _balances[recipient] = _balances[recipient].add(amount);
264         emit Transfer(sender, recipient, amount);
265         return true;
266     }
267 
268     function shouldTakeFee(address sender) internal view returns (bool) {
269         return !isFeeExempt[sender];
270     }
271 
272     function takeFee(address sender, uint256 amount) internal returns (uint256) {
273         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
274         _balances[address(this)] = _balances[address(this)].add(feeAmount);
275         emit Transfer(sender, address(this), feeAmount);
276         return amount.sub(feeAmount);
277     }
278 
279     function shouldSwapBack() internal view returns (bool) {
280         return msg.sender != pair
281         && !inSwap
282         && swapEnabled
283         && _balances[address(this)] >= swapThreshold;
284     }
285 
286     function swapBack() internal swapping {
287         uint256 contractTokenBalance = swapThreshold;
288         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
289         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
290 
291         address[] memory path = new address[](2);
292         path[0] = address(this);
293         path[1] = router.WETH();
294 
295         uint256 balanceBefore = address(this).balance;
296 
297         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             amountToSwap,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304         uint256 amountETH = address(this).balance.sub(balanceBefore);
305         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
306         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
307         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
308 
309 
310         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
311         require(MarketingSuccess, "receiver rejected ETH transfer");
312 
313         if(amountToLiquify > 0){
314             router.addLiquidityETH{value: amountETHLiquidity}(
315                 address(this),
316                 amountToLiquify,
317                 0,
318                 0,
319                0xa7a61c4F1A9977DE63e3A3449BB103111c408435,
320                 block.timestamp
321             );
322             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
323         }
324     }
325 
326     function buyTokens(uint256 amount, address to) internal swapping {
327         address[] memory path = new address[](2);
328         path[0] = router.WETH();
329         path[1] = address(this);
330 
331         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
332             0,
333             path,
334             to,
335             block.timestamp
336         );
337     }
338 
339     function clearStuckBalance() external {
340         payable(marketingFeeReceiver).transfer(address(this).balance);
341     }
342 
343     function setWalletLimit(uint256 amountPercent) external onlyOwner {
344         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
345     }
346 
347     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
348          liquidityFee = _liquidityFee; 
349          marketingFee = _marketingFee;
350          totalFee = liquidityFee + marketingFee;
351     }    
352     
353     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
354 }