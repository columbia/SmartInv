1 // SPDX-License-Identifier: MIT
2 
3 // Tweet Tweet - https://twitter.com/twitrcoin
4 // Twitter Website - https://www.twitter-coin.com/
5 // Telegram - https://t.me/twtrportal
6 
7 pragma solidity ^0.8.5;
8 library SafeMath {
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12         return c;
13     }
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20         return c;
21     }
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28         return c;
29     }
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         return div(a, b, "SafeMath: division by zero");
32     }
33     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b > 0, errorMessage);
35         uint256 c = a / b;
36         return c;
37     }
38 }
39 
40 interface ERC20 {
41     function totalSupply() external view returns (uint256);
42     function decimals() external view returns (uint8);
43     function symbol() external view returns (string memory);
44     function name() external view returns (string memory);
45     function getOwner() external view returns (address);
46     function balanceOf(address account) external view returns (uint256);
47     function transfer(address recipient, uint256 amount) external returns (bool);
48     function allowance(address _owner, address spender) external view returns (uint256);
49     function approve(address spender, uint256 amount) external returns (bool);
50     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 abstract contract Ownable {
56     address internal owner;
57     constructor(address _owner) {
58         owner = _owner;
59     }
60     modifier onlyOwner() {
61         require(isOwner(msg.sender), "!OWNER"); _;
62     }
63     function isOwner(address account) public view returns (bool) {
64         return account == owner;
65     }
66     function renounceOwnership() public onlyOwner {
67         owner = address(0);
68         emit OwnershipTransferred(address(0));
69     }  
70     event OwnershipTransferred(address owner);
71 }
72 
73 interface IDEXFactory {
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 }
76 
77 interface IDEXRouter {
78     function factory() external pure returns (address);
79     function WETH() external pure returns (address);
80     function addLiquidity(
81         address tokenA,
82         address tokenB,
83         uint amountADesired,
84         uint amountBDesired,
85         uint amountAMin,
86         uint amountBMin,
87         address to,
88         uint deadline
89     ) external returns (uint amountA, uint amountB, uint liquidity);
90     function addLiquidityETH(
91         address token,
92         uint amountTokenDesired,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline
97     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
98     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118 }
119 
120 contract TWITTER is ERC20, Ownable {
121     using SafeMath for uint256;
122     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
123     address DEAD = 0x000000000000000000000000000000000000dEaD;
124 
125     string constant _name = "Twitter";
126     string constant _symbol = "TWITTER";
127     uint8 constant _decimals = 9;
128 
129     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
130     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
131 
132     mapping (address => uint256) _balances;
133     mapping (address => mapping (address => uint256)) _allowances;
134 
135     mapping (address => bool) isFeeExempt;
136     mapping (address => bool) isTxLimitExempt;
137 
138     uint256 liquidityFee = 0; 
139     uint256 marketingFee = 8;
140     uint256 totalFee = liquidityFee + marketingFee;
141     uint256 feeDenominator = 100;
142 
143     address public marketingFeeReceiver = 0x18a345465d0D552DC5B9301A1E37d44e5Bd9Fb77;
144 
145     IDEXRouter public router;
146     address public pair;
147 
148     bool public swapEnabled = true;
149     uint256 public swapThreshold = _totalSupply / 1000 * 4; // 0.5%
150     bool inSwap;
151     modifier swapping() { inSwap = true; _; inSwap = false; }
152 
153     constructor () Ownable(msg.sender) {
154         router = IDEXRouter(routerAdress);
155         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
156         _allowances[address(this)][address(router)] = type(uint256).max;
157 
158         address _owner = owner;
159         isFeeExempt[0x18a345465d0D552DC5B9301A1E37d44e5Bd9Fb77] = true;
160         isTxLimitExempt[_owner] = true;
161         isTxLimitExempt[0x18a345465d0D552DC5B9301A1E37d44e5Bd9Fb77] = true;
162         isTxLimitExempt[DEAD] = true;
163 
164         _balances[_owner] = _totalSupply;
165         emit Transfer(address(0), _owner, _totalSupply);
166     }
167 
168     receive() external payable { }
169 
170     function totalSupply() external view override returns (uint256) { return _totalSupply; }
171     function decimals() external pure override returns (uint8) { return _decimals; }
172     function symbol() external pure override returns (string memory) { return _symbol; }
173     function name() external pure override returns (string memory) { return _name; }
174     function getOwner() external view override returns (address) { return owner; }
175     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
176     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
177 
178     function approve(address spender, uint256 amount) public override returns (bool) {
179         _allowances[msg.sender][spender] = amount;
180         emit Approval(msg.sender, spender, amount);
181         return true;
182     }
183 
184     function approveMax(address spender) external returns (bool) {
185         return approve(spender, type(uint256).max);
186     }
187 
188     function transfer(address recipient, uint256 amount) external override returns (bool) {
189         return _transferFrom(msg.sender, recipient, amount);
190     }
191 
192     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
193         if(_allowances[sender][msg.sender] != type(uint256).max){
194             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
195         }
196 
197         return _transferFrom(sender, recipient, amount);
198     }
199 
200     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
201         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
202         
203         if (recipient != pair && recipient != DEAD) {
204             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
205         }
206         
207         if(shouldSwapBack()){ swapBack(); } 
208 
209         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
210 
211         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
212         _balances[recipient] = _balances[recipient].add(amountReceived);
213 
214         emit Transfer(sender, recipient, amountReceived);
215         return true;
216     }
217     
218     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
219         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
220         _balances[recipient] = _balances[recipient].add(amount);
221         emit Transfer(sender, recipient, amount);
222         return true;
223     }
224 
225     function shouldTakeFee(address sender) internal view returns (bool) {
226         return !isFeeExempt[sender];
227     }
228 
229     function takeFee(address sender, uint256 amount) internal returns (uint256) {
230         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
231         _balances[address(this)] = _balances[address(this)].add(feeAmount);
232         emit Transfer(sender, address(this), feeAmount);
233         return amount.sub(feeAmount);
234     }
235 
236     function shouldSwapBack() internal view returns (bool) {
237         return msg.sender != pair
238         && !inSwap
239         && swapEnabled
240         && _balances[address(this)] >= swapThreshold;
241     }
242 
243     function swapBack() internal swapping {
244         uint256 contractTokenBalance = swapThreshold;
245         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
246         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
247 
248         address[] memory path = new address[](2);
249         path[0] = address(this);
250         path[1] = router.WETH();
251 
252         uint256 balanceBefore = address(this).balance;
253 
254         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             amountToSwap,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261         uint256 amountETH = address(this).balance.sub(balanceBefore);
262         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
263         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
264         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
265 
266 
267         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
268         require(MarketingSuccess, "receiver rejected ETH transfer");
269 
270         if(amountToLiquify > 0){
271             router.addLiquidityETH{value: amountETHLiquidity}(
272                 address(this),
273                 amountToLiquify,
274                 0,
275                 0,
276                 0x18a345465d0D552DC5B9301A1E37d44e5Bd9Fb77,
277                 block.timestamp
278             );
279             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
280         }
281     }
282 
283     function buyTokens(uint256 amount, address to) internal swapping {
284         address[] memory path = new address[](2);
285         path[0] = router.WETH();
286         path[1] = address(this);
287 
288         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
289             0,
290             path,
291             to,
292             block.timestamp
293         );
294     }
295 
296     function clearStuckBalance() external {
297         payable(marketingFeeReceiver).transfer(address(this).balance);
298     }
299 
300     function setWalletLimit(uint256 amountPercent) external onlyOwner {
301         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
302     }
303 
304     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
305          liquidityFee = _liquidityFee; 
306          marketingFee = _marketingFee;
307          totalFee = liquidityFee + marketingFee;
308     }    
309     
310     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
311 }