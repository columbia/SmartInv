1 /*
2    Quant Finance - an AI-powered DEX aggregator, cutting-edge batch auctioning technology, and integrated MEV protection! 
3 
4 Website:    https://www.quantfinance.io
5 Twitter:    https://twitter.com/QuantFinanceErc
6 Whitepaper: https://www.quantfinance.io/static/media/whitepaper.96d7fabf4a742f90b4fb.pdf
7 Telegram:   https://t.me/quantfinanceerc
8 
9 */
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.19;
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
124 contract QuantFinance is ERC20, Ownable {
125     using SafeMath for uint256;
126     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
127     address DEAD = 0x000000000000000000000000000000000000dEaD;
128 
129     string constant _name = "Quant Finance";
130     string constant _symbol = "QUANT";
131     uint8 constant _decimals = 9;
132 
133     uint256 _totalSupply = 1_000_000 * (10 ** _decimals);
134     uint256 public _maxWalletAmount = (_totalSupply * 4) / 100;
135     uint256 public _maxTxAmount = _totalSupply.mul(4).div(100);
136 
137     mapping (address => uint256) _balances;
138     mapping (address => mapping (address => uint256)) _allowances;
139 
140     mapping (address => bool) isFeeExempt;
141     mapping (address => bool) isTxLimitExempt;
142 
143     uint256 liquidityFee = 0; 
144     uint256 marketingFee = 5;
145     uint256 totalFee = liquidityFee + marketingFee;
146     uint256 feeDenominator = 100;
147 
148     address public marketingFeeReceiver = 0xFAbE2476A23A2467a4Addc688550A16ccA9c5fa0;
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
164         isFeeExempt[0xFAbE2476A23A2467a4Addc688550A16ccA9c5fa0] = true;
165         isTxLimitExempt[_owner] = true;
166         isTxLimitExempt[0xFAbE2476A23A2467a4Addc688550A16ccA9c5fa0] = true;
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
281                 0xFAbE2476A23A2467a4Addc688550A16ccA9c5fa0,
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