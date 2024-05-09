1 //T.ME/JOINGAO
2 //TRUSTINGAO.COM
3 //THE BROTHERS OF RYOSHI
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.5;
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18         return c;
19     }
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26         return c;
27     }
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         return div(a, b, "SafeMath: division by zero");
30     }
31     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b > 0, errorMessage);
33         uint256 c = a / b;
34         return c;
35     }
36 }
37 
38 interface ERC20 {
39     function totalSupply() external view returns (uint256);
40     function decimals() external view returns (uint8);
41     function symbol() external view returns (string memory);
42     function name() external view returns (string memory);
43     function getOwner() external view returns (address);
44     function balanceOf(address account) external view returns (uint256);
45     function transfer(address recipient, uint256 amount) external returns (bool);
46     function allowance(address _owner, address spender) external view returns (uint256);
47     function approve(address spender, uint256 amount) external returns (bool);
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 abstract contract Ownable {
54     address internal owner;
55     constructor(address _owner) {
56         owner = _owner;
57     }
58     modifier onlyOwner() {
59         require(isOwner(msg.sender), "!OWNER"); _;
60     }
61     function isOwner(address account) public view returns (bool) {
62         return account == owner;
63     }
64     function renounceOwnership() public onlyOwner {
65         owner = address(0);
66         emit OwnershipTransferred(address(0));
67     }  
68     event OwnershipTransferred(address owner);
69 }
70 
71 interface IDEXFactory {
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73 }
74 
75 interface IDEXRouter {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78     function addLiquidity(
79         address tokenA,
80         address tokenB,
81         uint amountADesired,
82         uint amountBDesired,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline
87     ) external returns (uint amountA, uint amountB, uint liquidity);
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function swapExactETHForTokensSupportingFeeOnTransferTokens(
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external payable;
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116 }
117 
118 contract GAO is ERC20, Ownable {
119     using SafeMath for uint256;
120     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
121     address DEAD = 0x000000000000000000000000000000000000dEaD;
122 
123     string constant _name = "The Brothers of Ryoshi";
124     string constant _symbol = "GAO";
125     uint8 constant _decimals = 9;
126 
127     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
128     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
129 
130     mapping (address => uint256) _balances;
131     mapping (address => mapping (address => uint256)) _allowances;
132 
133     mapping (address => bool) isFeeExempt;
134     mapping (address => bool) isTxLimitExempt;
135 
136     uint256 liquidityFee = 0; 
137     uint256 marketingFee = 8;
138     uint256 totalFee = liquidityFee + marketingFee;
139     uint256 feeDenominator = 100;
140 
141     address public marketingFeeReceiver = 0x1230d9025E3740BBafbeE1511702Ce9BFF6c62e7;
142 
143     IDEXRouter public router;
144     address public pair;
145 
146     bool public swapEnabled = true;
147     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
148     bool inSwap;
149     modifier swapping() { inSwap = true; _; inSwap = false; }
150 
151     constructor () Ownable(msg.sender) {
152         router = IDEXRouter(routerAdress);
153         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
154         _allowances[address(this)][address(router)] = type(uint256).max;
155 
156         address _owner = owner;
157         isFeeExempt[0xcE6346d91D1a976e038f1ED0Ab55183dCdCDb5a7] = true;
158         isTxLimitExempt[_owner] = true;
159         isTxLimitExempt[0xcE6346d91D1a976e038f1ED0Ab55183dCdCDb5a7] = true;
160         isTxLimitExempt[DEAD] = true;
161 
162         _balances[_owner] = _totalSupply;
163         emit Transfer(address(0), _owner, _totalSupply);
164     }
165 
166     receive() external payable { }
167 
168     function totalSupply() external view override returns (uint256) { return _totalSupply; }
169     function decimals() external pure override returns (uint8) { return _decimals; }
170     function symbol() external pure override returns (string memory) { return _symbol; }
171     function name() external pure override returns (string memory) { return _name; }
172     function getOwner() external view override returns (address) { return owner; }
173     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
174     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
175 
176     function approve(address spender, uint256 amount) public override returns (bool) {
177         _allowances[msg.sender][spender] = amount;
178         emit Approval(msg.sender, spender, amount);
179         return true;
180     }
181 
182     function approveMax(address spender) external returns (bool) {
183         return approve(spender, type(uint256).max);
184     }
185 
186     function transfer(address recipient, uint256 amount) external override returns (bool) {
187         return _transferFrom(msg.sender, recipient, amount);
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
191         if(_allowances[sender][msg.sender] != type(uint256).max){
192             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
193         }
194 
195         return _transferFrom(sender, recipient, amount);
196     }
197 
198     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
199         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
200         
201         if (recipient != pair && recipient != DEAD) {
202             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
203         }
204         
205         if(shouldSwapBack()){ swapBack(); } 
206 
207         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
208 
209         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
210         _balances[recipient] = _balances[recipient].add(amountReceived);
211 
212         emit Transfer(sender, recipient, amountReceived);
213         return true;
214     }
215     
216     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
217         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
218         _balances[recipient] = _balances[recipient].add(amount);
219         emit Transfer(sender, recipient, amount);
220         return true;
221     }
222 
223     function shouldTakeFee(address sender) internal view returns (bool) {
224         return !isFeeExempt[sender];
225     }
226 
227     function takeFee(address sender, uint256 amount) internal returns (uint256) {
228         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
229         _balances[address(this)] = _balances[address(this)].add(feeAmount);
230         emit Transfer(sender, address(this), feeAmount);
231         return amount.sub(feeAmount);
232     }
233 
234     function shouldSwapBack() internal view returns (bool) {
235         return msg.sender != pair
236         && !inSwap
237         && swapEnabled
238         && _balances[address(this)] >= swapThreshold;
239     }
240 
241     function swapBack() internal swapping {
242         uint256 contractTokenBalance = swapThreshold;
243         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
244         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
245 
246         address[] memory path = new address[](2);
247         path[0] = address(this);
248         path[1] = router.WETH();
249 
250         uint256 balanceBefore = address(this).balance;
251 
252         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
253             amountToSwap,
254             0,
255             path,
256             address(this),
257             block.timestamp
258         );
259         uint256 amountETH = address(this).balance.sub(balanceBefore);
260         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
261         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
262         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
263 
264 
265         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
266         require(MarketingSuccess, "receiver rejected ETH transfer");
267 
268         if(amountToLiquify > 0){
269             router.addLiquidityETH{value: amountETHLiquidity}(
270                 address(this),
271                 amountToLiquify,
272                 0,
273                 0,
274                 0xcE6346d91D1a976e038f1ED0Ab55183dCdCDb5a7,
275                 block.timestamp
276             );
277             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
278         }
279     }
280 
281     function buyTokens(uint256 amount, address to) internal swapping {
282         address[] memory path = new address[](2);
283         path[0] = router.WETH();
284         path[1] = address(this);
285 
286         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
287             0,
288             path,
289             to,
290             block.timestamp
291         );
292     }
293 
294     function clearStuckBalance() external {
295         payable(marketingFeeReceiver).transfer(address(this).balance);
296     }
297 
298     function setWalletLimit(uint256 amountPercent) external onlyOwner {
299         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
300     }
301 
302     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
303          liquidityFee = _liquidityFee; 
304          marketingFee = _marketingFee;
305          totalFee = liquidityFee + marketingFee;
306     }    
307     
308     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
309 }