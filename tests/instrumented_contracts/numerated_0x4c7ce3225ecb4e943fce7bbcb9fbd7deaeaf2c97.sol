1 /*
2 ＢＥＮＤＥＲ
3 Telegram: BenderERC
4 Twitter: Bender_ERC
5 Website: BenderERC.com
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.5;
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         return sub(a, b, "SafeMath: subtraction overflow");
18     }
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41  
42 interface ERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56  
57 abstract contract Ownable {
58     address internal owner;
59     constructor(address _owner) {
60         owner = _owner;
61     }
62     modifier onlyOwner() {
63         require(isOwner(msg.sender), "!OWNER"); _;
64     }
65     function isOwner(address account) public view returns (bool) {
66         return account == owner;
67     }
68     function renounceOwnership() public onlyOwner {
69         owner = address(0);
70         emit OwnershipTransferred(address(0));
71     }  
72     event OwnershipTransferred(address owner);
73 }
74  
75 interface IDEXFactory {
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77 }
78  
79 interface IDEXRouter {
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82     function addLiquidity(
83         address tokenA,
84         address tokenB,
85         uint amountADesired,
86         uint amountBDesired,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline
91     ) external returns (uint amountA, uint amountB, uint liquidity);
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function swapExactETHForTokensSupportingFeeOnTransferTokens(
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external payable;
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120 }
121  
122 contract BENDER is ERC20, Ownable {
123     using SafeMath for uint256;
124     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
125     address DEAD = 0x000000000000000000000000000000000000dEaD;
126  
127     string constant _name = "BENDER";
128     string constant _symbol = "BENDER";
129     uint8 constant _decimals = 9;
130  
131     uint256 _totalSupply = 10_000_000 * (10 ** _decimals);
132     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
133  
134     mapping (address => uint256) _balances;
135     mapping (address => mapping (address => uint256)) _allowances;
136  
137     mapping (address => bool) isFeeExempt;
138     mapping (address => bool) isTxLimitExempt;
139  
140     uint256 liquidityFee = 0; 
141     uint256 marketingFee = 3;
142     uint256 totalFee = liquidityFee + marketingFee;
143     uint256 feeDenominator = 100;
144  
145     address public marketingFeeReceiver = 0x35491125a19ff25AFdC75F332AC0a69227a7A523;
146  
147     IDEXRouter public router;
148     address public pair;
149  
150     bool public swapEnabled = true;
151     uint256 public swapThreshold = _totalSupply / 1000 * 3; // 0.3%
152     bool inSwap;
153     modifier swapping() { inSwap = true; _; inSwap = false; }
154  
155     constructor () Ownable(msg.sender) {
156         router = IDEXRouter(routerAdress);
157         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
158         _allowances[address(this)][address(router)] = type(uint256).max;
159  
160         address _owner = owner;
161         isFeeExempt[0x35491125a19ff25AFdC75F332AC0a69227a7A523] = true;
162         isTxLimitExempt[_owner] = true;
163         isTxLimitExempt[0x35491125a19ff25AFdC75F332AC0a69227a7A523] = true;
164         isTxLimitExempt[DEAD] = true;
165  
166         _balances[_owner] = _totalSupply;
167         emit Transfer(address(0), _owner, _totalSupply);
168     }
169  
170     receive() external payable { }
171  
172     function totalSupply() external view override returns (uint256) { return _totalSupply; }
173     function decimals() external pure override returns (uint8) { return _decimals; }
174     function symbol() external pure override returns (string memory) { return _symbol; }
175     function name() external pure override returns (string memory) { return _name; }
176     function getOwner() external view override returns (address) { return owner; }
177     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
178     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
179  
180     function approve(address spender, uint256 amount) public override returns (bool) {
181         _allowances[msg.sender][spender] = amount;
182         emit Approval(msg.sender, spender, amount);
183         return true;
184     }
185  
186     function approveMax(address spender) external returns (bool) {
187         return approve(spender, type(uint256).max);
188     }
189  
190     function transfer(address recipient, uint256 amount) external override returns (bool) {
191         return _transferFrom(msg.sender, recipient, amount);
192     }
193  
194     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
195         if(_allowances[sender][msg.sender] != type(uint256).max){
196             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
197         }
198  
199         return _transferFrom(sender, recipient, amount);
200     }
201  
202     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
203         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
204  
205         if (recipient != pair && recipient != DEAD) {
206             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
207         }
208  
209         if(shouldSwapBack()){ swapBack(); } 
210  
211         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
212  
213         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
214         _balances[recipient] = _balances[recipient].add(amountReceived);
215  
216         emit Transfer(sender, recipient, amountReceived);
217         return true;
218     }
219  
220     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
221         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
222         _balances[recipient] = _balances[recipient].add(amount);
223         emit Transfer(sender, recipient, amount);
224         return true;
225     }
226  
227     function shouldTakeFee(address sender) internal view returns (bool) {
228         return !isFeeExempt[sender];
229     }
230  
231     function takeFee(address sender, uint256 amount) internal returns (uint256) {
232         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
233         _balances[address(this)] = _balances[address(this)].add(feeAmount);
234         emit Transfer(sender, address(this), feeAmount);
235         return amount.sub(feeAmount);
236     }
237  
238     function shouldSwapBack() internal view returns (bool) {
239         return msg.sender != pair
240         && !inSwap
241         && swapEnabled
242         && _balances[address(this)] >= swapThreshold;
243     }
244  
245     function swapBack() internal swapping {
246         uint256 contractTokenBalance = swapThreshold;
247         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
248         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
249  
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = router.WETH();
253  
254         uint256 balanceBefore = address(this).balance;
255  
256         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
257             amountToSwap,
258             0,
259             path,
260             address(this),
261             block.timestamp
262         );
263         uint256 amountETH = address(this).balance.sub(balanceBefore);
264         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
265         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
266         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
267  
268  
269         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
270         require(MarketingSuccess, "receiver rejected ETH transfer");
271  
272         if(amountToLiquify > 0){
273             router.addLiquidityETH{value: amountETHLiquidity}(
274                 address(this),
275                 amountToLiquify,
276                 0,
277                 0,
278                 0x35491125a19ff25AFdC75F332AC0a69227a7A523,
279                 block.timestamp
280             );
281             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
282         }
283     }
284  
285     function buyTokens(uint256 amount, address to) internal swapping {
286         address[] memory path = new address[](2);
287         path[0] = router.WETH();
288         path[1] = address(this);
289  
290         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
291             0,
292             path,
293             to,
294             block.timestamp
295         );
296     }
297  
298     function clearStuckBalance() external {
299         payable(marketingFeeReceiver).transfer(address(this).balance);
300     }
301  
302     function setWalletLimit(uint256 amountPercent) external onlyOwner {
303         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
304     }
305  
306     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
307          liquidityFee = _liquidityFee; 
308          marketingFee = _marketingFee;
309          totalFee = liquidityFee + marketingFee;
310     }    
311  
312     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
313 }