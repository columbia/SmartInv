1 /**
2  
3  Telegram: https://t.me/AIToolsPortal
4  Twitter: https://twitter.com/AIToolsStudio
5  Website: https://ai-tools.studio/
6 
7 */
8 
9 // 
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.5;
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16         return c;
17     }
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24         return c;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32         return c;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40         return c;
41     }
42 }
43 
44 interface ERC20 {
45     function totalSupply() external view returns (uint256);
46     function decimals() external view returns (uint8);
47     function symbol() external view returns (string memory);
48     function name() external view returns (string memory);
49     function getOwner() external view returns (address);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address _owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 abstract contract Ownable {
60     address internal owner;
61     constructor(address _owner) {
62         owner = _owner;
63     }
64     modifier onlyOwner() {
65         require(isOwner(msg.sender), "!OWNER"); _;
66     }
67     function isOwner(address account) public view returns (bool) {
68         return account == owner;
69     }
70     function renounceOwnership() public onlyOwner {
71         owner = address(0);
72         emit OwnershipTransferred(address(0));
73     }  
74     event OwnershipTransferred(address owner);
75 }
76 
77 interface IDEXFactory {
78     function createPair(address tokenA, address tokenB) external returns (address pair);
79 }
80 
81 interface IDEXRouter {
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external payable;
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122 }
123 
124 contract AITools is ERC20, Ownable {
125     using SafeMath for uint256;
126     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
127     address DEAD = 0x000000000000000000000000000000000000dEaD;
128 
129     string constant _name = "AI Tools";
130     string constant _symbol = "AITOOLS";
131     uint8 constant _decimals = 9;
132 
133     uint256 _totalSupply = 1_000_000 * (10 ** _decimals);
134     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
135 
136     mapping (address => uint256) _balances;
137     mapping (address => mapping (address => uint256)) _allowances;
138 
139     mapping (address => bool) isFeeExempt;
140     mapping (address => bool) isTxLimitExempt;
141 
142     uint256 liquidityFee = 0;
143     uint256 marketingFee = 3;
144     uint256 totalFee = liquidityFee + marketingFee;
145     uint256 feeDenominator = 100;
146 
147     address private marketingFeeReceiver = 0xdf70C9eA9907eb3acb7E3EcB5b5FFC28052ddE35;
148 
149     IDEXRouter public router;
150     address public pair;
151 
152     bool public swapEnabled = true;
153     uint256 public swapThreshold = _totalSupply / 1000 * 2; // 
154     bool inSwap;
155     modifier swapping() { inSwap = true; _; inSwap = false; }
156 
157     constructor () Ownable(msg.sender) {
158         router = IDEXRouter(routerAdress);
159         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
160         _allowances[address(this)][address(router)] = type(uint256).max;
161 
162         address _owner = owner;
163         isFeeExempt[0xE0F97717e45b0487157DE1925ca03Ff05b7BDF08] = true;
164         isTxLimitExempt[_owner] = true;
165         isTxLimitExempt[0xE0F97717e45b0487157DE1925ca03Ff05b7BDF08] = true;
166         isTxLimitExempt[DEAD] = true;
167 
168         _balances[_owner] = _totalSupply;
169         emit Transfer(address(0), _owner, _totalSupply);
170     }
171 
172     receive() external payable { }
173 
174     function totalSupply() external view override returns (uint256) { return _totalSupply; }
175     function decimals() external pure override returns (uint8) { return _decimals; }
176     function symbol() external pure override returns (string memory) { return _symbol; }
177     function name() external pure override returns (string memory) { return _name; }
178     function getOwner() external view override returns (address) { return owner; }
179     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
180     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
181 
182     function approve(address spender, uint256 amount) public override returns (bool) {
183         _allowances[msg.sender][spender] = amount;
184         emit Approval(msg.sender, spender, amount);
185         return true;
186     }
187 
188     function approveMax(address spender) external returns (bool) {
189         return approve(spender, type(uint256).max);
190     }
191 
192     function transfer(address recipient, uint256 amount) external override returns (bool) {
193         return _transferFrom(msg.sender, recipient, amount);
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
197         if(_allowances[sender][msg.sender] != type(uint256).max){
198             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
199         }
200 
201         return _transferFrom(sender, recipient, amount);
202     }
203 
204     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
205         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
206         
207         if (recipient != pair && recipient != DEAD) {
208             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
209         }
210         
211         if(shouldSwapBack()){ swapBack(); } 
212 
213         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
214 
215         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
216         _balances[recipient] = _balances[recipient].add(amountReceived);
217 
218         emit Transfer(sender, recipient, amountReceived);
219         return true;
220     }
221     
222     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
223         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
224         _balances[recipient] = _balances[recipient].add(amount);
225         emit Transfer(sender, recipient, amount);
226         return true;
227     }
228 
229     function shouldTakeFee(address sender) internal view returns (bool) {
230         return !isFeeExempt[sender];
231     }
232 
233     function takeFee(address sender, uint256 amount) internal returns (uint256) {
234         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
235         _balances[address(this)] = _balances[address(this)].add(feeAmount);
236         emit Transfer(sender, address(this), feeAmount);
237         return amount.sub(feeAmount);
238     }
239 
240     function shouldSwapBack() internal view returns (bool) {
241         return msg.sender != pair
242         && !inSwap
243         && swapEnabled
244         && _balances[address(this)] >= swapThreshold;
245     }
246 
247     function swapBack() internal swapping {
248         uint256 contractTokenBalance = swapThreshold;
249         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
250         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
251 
252         address[] memory path = new address[](2);
253         path[0] = address(this);
254         path[1] = router.WETH();
255 
256         uint256 balanceBefore = address(this).balance;
257 
258         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
259             amountToSwap,
260             0,
261             path,
262             address(this),
263             block.timestamp
264         );
265         uint256 amountETH = address(this).balance.sub(balanceBefore);
266         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
267         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
268         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
269 
270 
271         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
272         require(MarketingSuccess, "receiver rejected ETH transfer");
273 
274         if(amountToLiquify > 0){
275             router.addLiquidityETH{value: amountETHLiquidity}(
276                 address(this),
277                 amountToLiquify,
278                 0,
279                 0,
280                 0xE0F97717e45b0487157DE1925ca03Ff05b7BDF08,
281                 block.timestamp
282             );
283             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
284         }
285     }
286 
287     function buyTokens(uint256 amount, address to) internal swapping {
288         address[] memory path = new address[](2);
289         path[0] = router.WETH();
290         path[1] = address(this);
291 
292         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
293             0,
294             path,
295             to,
296             block.timestamp
297         );
298     }
299 
300     function clearStuckBalance() external {
301         payable(marketingFeeReceiver).transfer(address(this).balance);
302     }
303 
304     function setWalletLimit(uint256 amountPercent) external onlyOwner {
305         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
306     }
307 
308     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
309          liquidityFee = _liquidityFee; 
310          marketingFee = _marketingFee;
311          totalFee = liquidityFee + marketingFee;
312     }    
313     
314     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
315 }