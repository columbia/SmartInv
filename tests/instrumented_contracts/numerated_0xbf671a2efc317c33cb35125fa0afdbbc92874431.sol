1 /*
2 
3 https://twitter.com/Shib2ERC
4 
5 
6 https://t.me/SHIB20ERC
7 
8 
9 */
10  
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.5;
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33         return c;
34     }
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         return c;
42     }
43 }
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
60 abstract contract Ownable {
61     address internal owner;
62     constructor(address _owner) {
63         owner = _owner;
64     }
65     modifier onlyOwner() {
66         require(isOwner(msg.sender), "!OWNER"); _;
67     }
68     function isOwner(address account) public view returns (bool) {
69         return account == owner;
70     }
71     function renounceOwnership() public onlyOwner {
72         owner = address(0);
73         emit OwnershipTransferred(address(0));
74     }  
75     event OwnershipTransferred(address owner);
76 }
77 
78 interface IDEXFactory {
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 }
81 
82 interface IDEXRouter {
83     function factory() external pure returns (address);
84     function WETH() external pure returns (address);
85     function addLiquidity(
86         address tokenA,
87         address tokenB,
88         uint amountADesired,
89         uint amountBDesired,
90         uint amountAMin,
91         uint amountBMin,
92         address to,
93         uint deadline
94     ) external returns (uint amountA, uint amountB, uint liquidity);
95     function addLiquidityETH(
96         address token,
97         uint amountTokenDesired,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline
102     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
103     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function swapExactETHForTokensSupportingFeeOnTransferTokens(
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external payable;
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123 }
124 
125 contract Shib2 is ERC20, Ownable {
126     using SafeMath for uint256;
127     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
128     address DEAD = 0x000000000000000000000000000000000000dEaD;
129 
130     string constant _name = "SHIB2.0";
131     string constant _symbol = "SHIB2";
132     uint8 constant _decimals = 9;
133 
134     uint256 _totalSupply = 100_000_000 * (10 ** _decimals);
135     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
136 
137     mapping (address => uint256) _balances;
138     mapping (address => mapping (address => uint256)) _allowances;
139 
140     mapping (address => bool) isFeeExempt;
141     mapping (address => bool) isTxLimitExempt;
142 
143     uint256 liquidityFee = 0; 
144     uint256 marketingFee = 25;
145     uint256 totalFee = liquidityFee + marketingFee;
146     uint256 feeDenominator = 100;
147 
148     address public marketingFeeReceiver = 0xA489E8646D601E38f280507e8748a58c8B43D8ae;
149 
150     IDEXRouter public router;
151     address public pair;
152 
153     bool public swapEnabled = true;
154     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
155     bool inSwap;
156     modifier swapping() { inSwap = true; _; inSwap = false; }
157 
158     constructor () Ownable(msg.sender) {
159         router = IDEXRouter(routerAdress);
160         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
161         _allowances[address(this)][address(router)] = type(uint256).max;
162 
163         address _owner = owner;
164         isFeeExempt[0xA489E8646D601E38f280507e8748a58c8B43D8ae] = true;
165         isTxLimitExempt[_owner] = true;
166         isTxLimitExempt[0xA489E8646D601E38f280507e8748a58c8B43D8ae] = true;
167         isTxLimitExempt[DEAD] = true;
168 
169         _balances[_owner] = _totalSupply;
170         emit Transfer(address(0), _owner, _totalSupply);
171     }
172 
173     receive() external payable { }
174 
175     function totalSupply() external view override returns (uint256) { return _totalSupply; }
176     function decimals() external pure override returns (uint8) { return _decimals; }
177     function symbol() external pure override returns (string memory) { return _symbol; }
178     function name() external pure override returns (string memory) { return _name; }
179     function getOwner() external view override returns (address) { return owner; }
180     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
181     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
182 
183     function approve(address spender, uint256 amount) public override returns (bool) {
184         _allowances[msg.sender][spender] = amount;
185         emit Approval(msg.sender, spender, amount);
186         return true;
187     }
188 
189     function approveMax(address spender) external returns (bool) {
190         return approve(spender, type(uint256).max);
191     }
192 
193     function transfer(address recipient, uint256 amount) external override returns (bool) {
194         return _transferFrom(msg.sender, recipient, amount);
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
198         if(_allowances[sender][msg.sender] != type(uint256).max){
199             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
200         }
201 
202         return _transferFrom(sender, recipient, amount);
203     }
204 
205     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
206         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
207         
208         if (recipient != pair && recipient != DEAD) {
209             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
210         }
211         
212         if(shouldSwapBack()){ swapBack(); } 
213 
214         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
215 
216         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
217         _balances[recipient] = _balances[recipient].add(amountReceived);
218 
219         emit Transfer(sender, recipient, amountReceived);
220         return true;
221     }
222     
223     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
224         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
225         _balances[recipient] = _balances[recipient].add(amount);
226         emit Transfer(sender, recipient, amount);
227         return true;
228     }
229 
230     function shouldTakeFee(address sender) internal view returns (bool) {
231         return !isFeeExempt[sender];
232     }
233 
234     function takeFee(address sender, uint256 amount) internal returns (uint256) {
235         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
236         _balances[address(this)] = _balances[address(this)].add(feeAmount);
237         emit Transfer(sender, address(this), feeAmount);
238         return amount.sub(feeAmount);
239     }
240 
241     function shouldSwapBack() internal view returns (bool) {
242         return msg.sender != pair
243         && !inSwap
244         && swapEnabled
245         && _balances[address(this)] >= swapThreshold;
246     }
247 
248     function swapBack() internal swapping {
249         uint256 contractTokenBalance = swapThreshold;
250         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
251         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
252 
253         address[] memory path = new address[](2);
254         path[0] = address(this);
255         path[1] = router.WETH();
256 
257         uint256 balanceBefore = address(this).balance;
258 
259         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
260             amountToSwap,
261             0,
262             path,
263             address(this),
264             block.timestamp
265         );
266         uint256 amountETH = address(this).balance.sub(balanceBefore);
267         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
268         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
269         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
270 
271 
272         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
273         require(MarketingSuccess, "receiver rejected ETH transfer");
274 
275         if(amountToLiquify > 0){
276             router.addLiquidityETH{value: amountETHLiquidity}(
277                 address(this),
278                 amountToLiquify,
279                 0,
280                 0,
281                 0xA489E8646D601E38f280507e8748a58c8B43D8ae,
282                 block.timestamp
283             );
284             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
285         }
286     }
287 
288     function buyTokens(uint256 amount, address to) internal swapping {
289         address[] memory path = new address[](2);
290         path[0] = router.WETH();
291         path[1] = address(this);
292 
293         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
294             0,
295             path,
296             to,
297             block.timestamp
298         );
299     }
300 
301     function clearStuckBalance() external {
302         payable(marketingFeeReceiver).transfer(address(this).balance);
303     }
304 
305     function setWalletLimit(uint256 amountPercent) external onlyOwner {
306         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
307     }
308 
309     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
310          liquidityFee = _liquidityFee; 
311          marketingFee = _marketingFee;
312          totalFee = liquidityFee + marketingFee;
313     }    
314     
315     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
316 }