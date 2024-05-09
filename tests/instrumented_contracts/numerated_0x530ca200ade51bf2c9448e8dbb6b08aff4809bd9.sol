1 /**
2  
3 */
4 
5 /**
6 
7 My master Plato has failed to spread his wisdom and message.
8 
9 The student becomes the master.
10 
11 Aristotle will succeed in spreading the message to the unguided.
12 
13 At 50k LP will be locked for 200 years.
14 
15 Make a TG, if you all work together and I see I will come in.
16 
17 Make Aristotle do what Plato failed to do.
18 
19 Tax will be 2/2. 
20 
21 80% of supply will be burnt.
22 
23 
24 */
25 
26 // 
27 // SPDX-License-Identifier: MIT
28 pragma solidity ^0.8.5;
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 }
60 
61 interface ERC20 {
62     function totalSupply() external view returns (uint256);
63     function decimals() external view returns (uint8);
64     function symbol() external view returns (string memory);
65     function name() external view returns (string memory);
66     function getOwner() external view returns (address);
67     function balanceOf(address account) external view returns (uint256);
68     function transfer(address recipient, uint256 amount) external returns (bool);
69     function allowance(address _owner, address spender) external view returns (uint256);
70     function approve(address spender, uint256 amount) external returns (bool);
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 abstract contract Ownable {
77     address internal owner;
78     constructor(address _owner) {
79         owner = _owner;
80     }
81     modifier onlyOwner() {
82         require(isOwner(msg.sender), "!OWNER"); _;
83     }
84     function isOwner(address account) public view returns (bool) {
85         return account == owner;
86     }
87     function renounceOwnership() public onlyOwner {
88         owner = address(0);
89         emit OwnershipTransferred(address(0));
90     }  
91     event OwnershipTransferred(address owner);
92 }
93 
94 interface IDEXFactory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IDEXRouter {
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidity(
102         address tokenA,
103         address tokenB,
104         uint amountADesired,
105         uint amountBDesired,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline
110     ) external returns (uint amountA, uint amountB, uint liquidity);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function swapExactETHForTokensSupportingFeeOnTransferTokens(
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external payable;
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 }
140 
141 contract Aristotle  is ERC20, Ownable {
142     using SafeMath for uint256;
143     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
144     address DEAD = 0x000000000000000000000000000000000000dEaD;
145 
146     string constant _name = "Aristotle";
147     string constant _symbol = "$ARISTO";
148     uint8 constant _decimals = 9;
149 
150     uint256 _totalSupply = 1000000000 * (10 ** _decimals);
151     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
152 
153     mapping (address => uint256) _balances;
154     mapping (address => mapping (address => uint256)) _allowances;
155 
156     mapping (address => bool) isFeeExempt;
157     mapping (address => bool) isTxLimitExempt;
158 
159     uint256 liquidityFee = 0; // Auto liquidity added and burned
160     uint256 marketingFee = 2;
161     uint256 totalFee = liquidityFee + marketingFee;
162     uint256 feeDenominator = 100;
163 
164     address public marketingFeeReceiver = 0xD1707F16e3E42ecA0430895E72E768278234fa0d;
165 
166     IDEXRouter public router;
167     address public pair;
168 
169     bool public swapEnabled = true;
170     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
171     bool inSwap;
172     modifier swapping() { inSwap = true; _; inSwap = false; }
173 
174     constructor () Ownable(msg.sender) {
175         router = IDEXRouter(routerAdress);
176         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
177         _allowances[address(this)][address(router)] = type(uint256).max;
178 
179         address _owner = owner;
180         isFeeExempt[0xd0B7EBd720F8B8bE4F556cbB128A266032Bb7932] = true;
181         isTxLimitExempt[_owner] = true;
182         isTxLimitExempt[0xd0B7EBd720F8B8bE4F556cbB128A266032Bb7932] = true;
183         isTxLimitExempt[DEAD] = true;
184 
185         _balances[_owner] = _totalSupply;
186         emit Transfer(address(0), _owner, _totalSupply);
187     }
188 
189     receive() external payable { }
190 
191     function totalSupply() external view override returns (uint256) { return _totalSupply; }
192     function decimals() external pure override returns (uint8) { return _decimals; }
193     function symbol() external pure override returns (string memory) { return _symbol; }
194     function name() external pure override returns (string memory) { return _name; }
195     function getOwner() external view override returns (address) { return owner; }
196     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
197     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _allowances[msg.sender][spender] = amount;
201         emit Approval(msg.sender, spender, amount);
202         return true;
203     }
204 
205     function approveMax(address spender) external returns (bool) {
206         return approve(spender, type(uint256).max);
207     }
208 
209     function transfer(address recipient, uint256 amount) external override returns (bool) {
210         return _transferFrom(msg.sender, recipient, amount);
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
214         if(_allowances[sender][msg.sender] != type(uint256).max){
215             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
216         }
217 
218         return _transferFrom(sender, recipient, amount);
219     }
220 
221     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
222         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
223         
224         if (recipient != pair && recipient != DEAD) {
225             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
226         }
227         
228         if(shouldSwapBack()){ swapBack(); } 
229 
230         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
231 
232         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
233         _balances[recipient] = _balances[recipient].add(amountReceived);
234 
235         emit Transfer(sender, recipient, amountReceived);
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
273         uint256 balanceBefore = address(this).balance;
274 
275         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             amountToSwap,
277             0,
278             path,
279             address(this),
280             block.timestamp
281         );
282         uint256 amountETH = address(this).balance.sub(balanceBefore);
283         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
284         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
285         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
286 
287 
288         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
289         require(MarketingSuccess, "receiver rejected ETH transfer");
290 
291         if(amountToLiquify > 0){
292             router.addLiquidityETH{value: amountETHLiquidity}(
293                 address(this),
294                 amountToLiquify,
295                 0,
296                 0,
297                 DEAD,
298                 block.timestamp
299             );
300             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
301         }
302     }
303 
304     function buyTokens(uint256 amount, address to) internal swapping {
305         address[] memory path = new address[](2);
306         path[0] = router.WETH();
307         path[1] = address(this);
308 
309         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
310             0,
311             path,
312             to,
313             block.timestamp
314         );
315     }
316 
317     function clearStuckBalance() external {
318         payable(marketingFeeReceiver).transfer(address(this).balance);
319     }
320 
321     function setWalletLimit(uint256 amountPercent) external onlyOwner {
322         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
323     }  
324     
325     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
326 }