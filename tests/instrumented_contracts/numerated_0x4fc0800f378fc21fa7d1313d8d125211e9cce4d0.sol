1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5             __________
6            |  __  __  |
7            | |  ||  | |
8            | |  ||  | |
9            | |__||__| |
10            |  __  __()|
11            | |  ||  | |
12            | |  ||  | |
13            | |  ||  | |
14            | |  ||  | |
15            | |__||__| |
16            |__________|
17 
18 Can you "ESCAPE" your faith? 
19 
20 Escape your fate to join our Telegram Group @ https://escapeth.io/
21 
22 
23 */
24 
25 
26 
27 
28 
29 pragma solidity ^0.8.5;
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 }
61 
62 interface ERC20 {
63     function totalSupply() external view returns (uint256);
64     function decimals() external view returns (uint8);
65     function symbol() external view returns (string memory);
66     function name() external view returns (string memory);
67     function getOwner() external view returns (address);
68     function balanceOf(address account) external view returns (uint256);
69     function transfer(address recipient, uint256 amount) external returns (bool);
70     function allowance(address _owner, address spender) external view returns (uint256);
71     function approve(address spender, uint256 amount) external returns (bool);
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 abstract contract Ownable {
78     address internal owner;
79     constructor(address _owner) {
80         owner = _owner;
81     }
82     modifier onlyOwner() {
83         require(isOwner(msg.sender), "!OWNER"); _;
84     }
85     function isOwner(address account) public view returns (bool) {
86         return account == owner;
87     }
88     function renounceOwnership() public onlyOwner {
89         owner = address(0);
90         emit OwnershipTransferred(address(0));
91     }  
92     event OwnershipTransferred(address owner);
93 }
94 
95 interface IDEXFactory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IDEXRouter {
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidity(
103         address tokenA,
104         address tokenB,
105         uint amountADesired,
106         uint amountBDesired,
107         uint amountAMin,
108         uint amountBMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountA, uint amountB, uint liquidity);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127     function swapExactETHForTokensSupportingFeeOnTransferTokens(
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external payable;
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140 }
141 
142 contract Escape is ERC20, Ownable {
143     using SafeMath for uint256;
144     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
145     address DEAD = 0x000000000000000000000000000000000000dEaD;
146 
147     string constant _name = "Escape";
148     string constant _symbol = "ESC";
149     uint8 constant _decimals = 9;
150 
151     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
152     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
153 
154     mapping (address => uint256) _balances;
155     mapping (address => mapping (address => uint256)) _allowances;
156 
157     mapping (address => bool) isFeeExempt;
158     mapping (address => bool) isTxLimitExempt;
159 
160     uint256 liquidityFee = 0; 
161     uint256 marketingFee = 4;
162     uint256 totalFee = liquidityFee + marketingFee;
163     uint256 feeDenominator = 100;
164 
165     address public marketingFeeReceiver = 0xA7Fab255F8d2510C2a97F913c504521Bf763FE16;
166 
167     IDEXRouter public router;
168     address public pair;
169 
170     bool public swapEnabled = true;
171     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
172     bool inSwap;
173     modifier swapping() { inSwap = true; _; inSwap = false; }
174 
175     constructor () Ownable(msg.sender) {
176         router = IDEXRouter(routerAdress);
177         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
178         _allowances[address(this)][address(router)] = type(uint256).max;
179 
180         address _owner = owner;
181         isFeeExempt[0xA7Fab255F8d2510C2a97F913c504521Bf763FE16] = true;
182         isTxLimitExempt[_owner] = true;
183         isTxLimitExempt[0xA7Fab255F8d2510C2a97F913c504521Bf763FE16] = true;
184         isTxLimitExempt[DEAD] = true;
185 
186         _balances[_owner] = _totalSupply;
187         emit Transfer(address(0), _owner, _totalSupply);
188     }
189 
190     receive() external payable { }
191 
192     function totalSupply() external view override returns (uint256) { return _totalSupply; }
193     function decimals() external pure override returns (uint8) { return _decimals; }
194     function symbol() external pure override returns (string memory) { return _symbol; }
195     function name() external pure override returns (string memory) { return _name; }
196     function getOwner() external view override returns (address) { return owner; }
197     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
198     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _allowances[msg.sender][spender] = amount;
202         emit Approval(msg.sender, spender, amount);
203         return true;
204     }
205 
206     function approveMax(address spender) external returns (bool) {
207         return approve(spender, type(uint256).max);
208     }
209 
210     function transfer(address recipient, uint256 amount) external override returns (bool) {
211         return _transferFrom(msg.sender, recipient, amount);
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
215         if(_allowances[sender][msg.sender] != type(uint256).max){
216             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
217         }
218 
219         return _transferFrom(sender, recipient, amount);
220     }
221 
222     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
223         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
224         
225         if (recipient != pair && recipient != DEAD) {
226             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
227         }
228         
229         if(shouldSwapBack()){ swapBack(); } 
230 
231         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
232 
233         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
234         _balances[recipient] = _balances[recipient].add(amountReceived);
235 
236         emit Transfer(sender, recipient, amountReceived);
237         return true;
238     }
239     
240     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
241         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
242         _balances[recipient] = _balances[recipient].add(amount);
243         emit Transfer(sender, recipient, amount);
244         return true;
245     }
246 
247     function shouldTakeFee(address sender) internal view returns (bool) {
248         return !isFeeExempt[sender];
249     }
250 
251     function takeFee(address sender, uint256 amount) internal returns (uint256) {
252         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
253         _balances[address(this)] = _balances[address(this)].add(feeAmount);
254         emit Transfer(sender, address(this), feeAmount);
255         return amount.sub(feeAmount);
256     }
257 
258     function shouldSwapBack() internal view returns (bool) {
259         return msg.sender != pair
260         && !inSwap
261         && swapEnabled
262         && _balances[address(this)] >= swapThreshold;
263     }
264 
265     function swapBack() internal swapping {
266         uint256 contractTokenBalance = swapThreshold;
267         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
268         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
269 
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = router.WETH();
273 
274         uint256 balanceBefore = address(this).balance;
275 
276         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             amountToSwap,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283         uint256 amountETH = address(this).balance.sub(balanceBefore);
284         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
285         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
286         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
287 
288 
289         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
290         require(MarketingSuccess, "receiver rejected ETH transfer");
291 
292         if(amountToLiquify > 0){
293             router.addLiquidityETH{value: amountETHLiquidity}(
294                 address(this),
295                 amountToLiquify,
296                 0,
297                 0,
298                 0xA7Fab255F8d2510C2a97F913c504521Bf763FE16,
299                 block.timestamp
300             );
301             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
302         }
303     }
304 
305     function buyTokens(uint256 amount, address to) internal swapping {
306         address[] memory path = new address[](2);
307         path[0] = router.WETH();
308         path[1] = address(this);
309 
310         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
311             0,
312             path,
313             to,
314             block.timestamp
315         );
316     }
317 
318     function clearStuckBalance() external {
319         payable(marketingFeeReceiver).transfer(address(this).balance);
320     }
321 
322     function setWalletLimit(uint256 amountPercent) external onlyOwner {
323         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
324     }
325 
326     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
327          liquidityFee = _liquidityFee; 
328          marketingFee = _marketingFee;
329          totalFee = liquidityFee + marketingFee;
330     }    
331     
332     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
333 }