1 //SPDX-License-Identifier: MIT
2 
3 
4 /*
5 
6 Twitter : https://twitter.com/GoatETHER
7 Telegram : https://t.me/gooatportal
8 
9 */
10 
11 pragma solidity ^0.8.0;
12 
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
60 abstract contract OwnableL {
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
123     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
124     external
125     payable
126     returns (uint[] memory amounts);
127 }
128 
129 contract GOAT is ERC20, OwnableL {
130     using SafeMath for uint256;
131     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
132     address DEAD = 0x000000000000000000000000000000000000dEaD;
133 
134     string constant _name = "GOAT";
135     string constant _symbol = "GOAT";
136     uint8 constant _decimals = 18;
137 
138     uint256 public _totalSupply = 1000000 * (10 ** _decimals);
139     uint256 public _maxWalletAmount = (_totalSupply * 5) / 100; // 5%
140     uint256 public _maxTxAmount = _totalSupply.mul(100).div(100); //100%
141 
142     mapping (address => uint256) _balances;
143     mapping (address => mapping (address => uint256)) _allowances;
144     mapping (address => bool) _auth;
145 
146     mapping (address => bool) isFeeExempt;
147     mapping (address => bool) isTxLimitExempt;
148 
149     uint256 marketingFee = 1;
150     uint256 devFee = 1;
151     uint256 liquidityFee = 1;
152     uint256 totalFee = devFee + marketingFee + liquidityFee;
153     uint256 feeDenominator = 100;
154 
155     address public marketingFeeReceiver = 0xc95a0Bf330Cd40c96815A535FAA8276e99e66327;
156     address public devFeeReceiver = 0xd955D20A2D6e00023F57fBa95291FF39589fC78B;
157 
158     IDEXRouter public router;
159     address public pair;
160 
161     bool public swapEnabled = true;
162     uint256 public swapThreshold = (_totalSupply * 2) / 600; // 0.33%
163     bool inSwap;
164     modifier swapping() { inSwap = true; _; inSwap = false; }
165     modifier onlyAuth() {
166         require(_auth[msg.sender], "not auth minter"); _;
167     }
168 
169     constructor () OwnableL(msg.sender) {
170         router = IDEXRouter(routerAdress);
171         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
172         _allowances[address(this)][address(router)] = type(uint256).max;
173 
174         address _owner = owner;
175 
176         _auth[msg.sender] = true;
177 
178         isFeeExempt[_owner] = true;
179         isFeeExempt[marketingFeeReceiver] = true;
180         isTxLimitExempt[_owner] = true;
181         isTxLimitExempt[marketingFeeReceiver] = true;
182         isTxLimitExempt[DEAD] = true;
183 
184         _balances[_owner] = _totalSupply;
185         emit Transfer(address(0), _owner, _totalSupply);
186     }
187 
188     receive() external payable { }
189 
190     function totalSupply() external view override returns (uint256) { return _totalSupply; }
191     function decimals() external pure override returns (uint8) { return _decimals; }
192     function symbol() external pure override returns (string memory) { return _symbol; }
193     function name() external pure override returns (string memory) { return _name; }
194     function getOwner() external view override returns (address) { return owner; }
195     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
196     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _allowances[msg.sender][spender] = amount;
200         emit Approval(msg.sender, spender, amount);
201         return true;
202     }
203 
204     function approveMax(address spender) external returns (bool) {
205         return approve(spender, type(uint256).max);
206     }
207 
208     function transfer(address recipient, uint256 amount) external override returns (bool) {
209         return _transferFrom(msg.sender, recipient, amount);
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
213         if(_allowances[sender][msg.sender] != type(uint256).max){
214             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
215         }
216 
217         return _transferFrom(sender, recipient, amount);
218     }
219 
220     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
221         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
222 
223         if (recipient != pair && recipient != DEAD) {
224             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
225         }
226  
227         if(shouldSwapBack()){ swapBack(); }
228 
229         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
230 
231         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
232         _balances[recipient] = _balances[recipient].add(amountReceived);
233 
234         emit Transfer(sender, recipient, amountReceived);
235 
236         return true;
237     }
238 
239     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
240         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
241         _balances[recipient] = _balances[recipient].add(amount);
242         emit Transfer(sender, recipient, amount);
243         return true;
244     }
245 
246     function shouldTakeFee(address sender) internal view returns (bool) {
247         return !isFeeExempt[sender];
248     }
249 
250     function takeFee(address sender, uint256 amount) internal returns (uint256) {
251         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
252         _balances[address(this)] = _balances[address(this)].add(feeAmount);
253         emit Transfer(sender, address(this), feeAmount);
254         return amount.sub(feeAmount);
255     }
256 
257     function shouldSwapBack() internal view returns (bool) {
258         return msg.sender != pair
259         && !inSwap
260         && swapEnabled
261         && _balances[address(this)] >= swapThreshold;
262     }
263 
264     function swapBack() internal swapping {
265         uint256 contractTokenBalance = swapThreshold;
266         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
267         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
268 
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = router.WETH();
272 
273         address[] memory path2 = new address[](2);
274         path2[1] = address(this);
275         path2[0] = router.WETH();
276 
277         uint256 balanceBefore = address(this).balance;
278 
279         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             amountToSwap,
281             0,
282             path,
283             address(this),
284             block.timestamp
285         );
286         uint256 amountETH = address(this).balance.sub(balanceBefore); 
287         uint256 amountETHDev = amountETH.mul(devFee).div(totalFee);
288         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalFee);
289         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalFee);
290 
291 
292         (bool DevSuccess, ) = payable(devFeeReceiver).call{value: amountETHDev, gas: 30000}("");
293         require(DevSuccess, "receiver rejected ETH transfer");
294         (bool MarketingSuccess, ) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
295         require(MarketingSuccess, "receiver rejected ETH transfer");
296 
297         uint[] memory amounts = router.swapExactETHForTokens{value: amountETHLiquidity}(
298             0,
299             path2,
300             pair,
301             block.timestamp
302          );
303 
304          _balances[address(this)] = _balances[address(this)].add(amounts[1]);
305     }
306 
307     function buyTokens(uint256 amount, address to) internal swapping {
308         address[] memory path = new address[](2);
309         path[0] = router.WETH();
310         path[1] = address(this);
311 
312         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
313             0,
314             path,
315             to,
316             block.timestamp
317         );
318     }
319 
320     function clearStuckBalance() external {
321         payable(devFeeReceiver).transfer(address(this).balance);
322     }
323 
324     function setWalletLimit(uint256 amountPercent) external onlyOwner {
325         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
326     }
327 
328     function setFee(uint256 _devFee, uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
329         devFee = _devFee;
330         marketingFee = _marketingFee;
331         liquidityFee = _liquidityFee;
332         totalFee = devFee + marketingFee + liquidityFee;
333     }
334 
335     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
336 }