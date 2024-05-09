1 /**
2 
3 📌Join Us !!
4 
5 ✅https://t.me/GPT4Chain
6 🚀https://twitter.com/GPT4Chain
7 🌐https://www.gpt4chain.com/
8 
9 */
10 
11 // 
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.5;
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26         return c;
27     }
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34         return c;
35     }
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42         return c;
43     }
44 }
45 
46 interface ERC20 {
47     function totalSupply() external view returns (uint256);
48     function decimals() external view returns (uint8);
49     function symbol() external view returns (string memory);
50     function name() external view returns (string memory);
51     function getOwner() external view returns (address);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address _owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 abstract contract Ownable {
62     address internal owner;
63     constructor(address _owner) {
64         owner = _owner;
65     }
66     modifier onlyOwner() {
67         require(isOwner(msg.sender), "!OWNER"); _;
68     }
69     function isOwner(address account) public view returns (bool) {
70         return account == owner;
71     }
72     function renounceOwnership() public onlyOwner {
73         owner = address(0);
74         emit OwnershipTransferred(address(0));
75     }  
76     event OwnershipTransferred(address owner);
77 }
78 
79 interface IDEXFactory {
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 }
82 
83 interface IDEXRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86     function addLiquidity(
87         address tokenA,
88         address tokenB,
89         uint amountADesired,
90         uint amountBDesired,
91         uint amountAMin,
92         uint amountBMin,
93         address to,
94         uint deadline
95     ) external returns (uint amountA, uint amountB, uint liquidity);
96     function addLiquidityETH(
97         address token,
98         uint amountTokenDesired,
99         uint amountTokenMin,
100         uint amountETHMin,
101         address to,
102         uint deadline
103     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
104     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function swapExactETHForTokensSupportingFeeOnTransferTokens(
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external payable;
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124 }
125 
126 contract GPT4Chain is ERC20, Ownable {
127     using SafeMath for uint256;
128     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
129     address DEAD = 0x000000000000000000000000000000000000dEaD;
130 
131     string constant _name = "GPT-4 Chain";
132     string constant _symbol = unicode"GPT4C";
133     uint8 constant _decimals = 9;
134 
135     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
136     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
137 
138     mapping (address => uint256) _balances;
139     mapping (address => mapping (address => uint256)) _allowances;
140 
141     mapping (address => bool) isFeeExempt;
142     mapping (address => bool) isTxLimitExempt;
143 
144     uint256 liquidityFee = 0;
145     uint256 marketingFee = 3;
146     uint256 totalFee = liquidityFee + marketingFee;
147     uint256 feeDenominator = 100;
148 
149     address public marketingFeeReceiver = 0x9Ad18e9b01a4b624A815D047d01C8E3c591eC802;
150 
151     IDEXRouter public router;
152     address public pair;
153 
154     bool public swapEnabled = true;
155     uint256 public swapThreshold = _totalSupply / 1000 * 1; // 
156     bool inSwap;
157     modifier swapping() { inSwap = true; _; inSwap = false; }
158 
159     constructor () Ownable(msg.sender) {
160         router = IDEXRouter(routerAdress);
161         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
162         _allowances[address(this)][address(router)] = type(uint256).max;
163 
164         address _owner = owner;
165         isFeeExempt[0xde700693a6CD4F5dfC0543d9f11A907C5ab23e85] = true;
166         isTxLimitExempt[_owner] = true;
167         isTxLimitExempt[0xde700693a6CD4F5dfC0543d9f11A907C5ab23e85] = true;
168         isTxLimitExempt[DEAD] = true;
169 
170         _balances[_owner] = _totalSupply;
171         emit Transfer(address(0), _owner, _totalSupply);
172     }
173 
174     receive() external payable { }
175 
176     function totalSupply() external view override returns (uint256) { return _totalSupply; }
177     function decimals() external pure override returns (uint8) { return _decimals; }
178     function symbol() external pure override returns (string memory) { return _symbol; }
179     function name() external pure override returns (string memory) { return _name; }
180     function getOwner() external view override returns (address) { return owner; }
181     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
182     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
183 
184     function approve(address spender, uint256 amount) public override returns (bool) {
185         _allowances[msg.sender][spender] = amount;
186         emit Approval(msg.sender, spender, amount);
187         return true;
188     }
189 
190     function approveMax(address spender) external returns (bool) {
191         return approve(spender, type(uint256).max);
192     }
193 
194     function transfer(address recipient, uint256 amount) external override returns (bool) {
195         return _transferFrom(msg.sender, recipient, amount);
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
199         if(_allowances[sender][msg.sender] != type(uint256).max){
200             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
201         }
202 
203         return _transferFrom(sender, recipient, amount);
204     }
205 
206     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
207         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
208         
209         if (recipient != pair && recipient != DEAD) {
210             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
211         }
212         
213         if(shouldSwapBack()){ swapBack(); } 
214 
215         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
216 
217         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
218         _balances[recipient] = _balances[recipient].add(amountReceived);
219 
220         emit Transfer(sender, recipient, amountReceived);
221         return true;
222     }
223     
224     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
225         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
226         _balances[recipient] = _balances[recipient].add(amount);
227         emit Transfer(sender, recipient, amount);
228         return true;
229     }
230 
231     function shouldTakeFee(address sender) internal view returns (bool) {
232         return !isFeeExempt[sender];
233     }
234 
235     function takeFee(address sender, uint256 amount) internal returns (uint256) {
236         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
237         _balances[address(this)] = _balances[address(this)].add(feeAmount);
238         emit Transfer(sender, address(this), feeAmount);
239         return amount.sub(feeAmount);
240     }
241 
242     function shouldSwapBack() internal view returns (bool) {
243         return msg.sender != pair
244         && !inSwap
245         && swapEnabled
246         && _balances[address(this)] >= swapThreshold;
247     }
248 
249     function swapBack() internal swapping {
250         uint256 contractTokenBalance = swapThreshold;
251         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
252         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
253 
254         address[] memory path = new address[](2);
255         path[0] = address(this);
256         path[1] = router.WETH();
257 
258         uint256 balanceBefore = address(this).balance;
259 
260         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             amountToSwap,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267         uint256 amountETH = address(this).balance.sub(balanceBefore);
268         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
269         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
270         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
271 
272 
273         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
274         require(MarketingSuccess, "receiver rejected ETH transfer");
275 
276         if(amountToLiquify > 0){
277             router.addLiquidityETH{value: amountETHLiquidity}(
278                 address(this),
279                 amountToLiquify,
280                 0,
281                 0,
282                 0xde700693a6CD4F5dfC0543d9f11A907C5ab23e85,
283                 block.timestamp
284             );
285             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
286         }
287     }
288 
289     function buyTokens(uint256 amount, address to) internal swapping {
290         address[] memory path = new address[](2);
291         path[0] = router.WETH();
292         path[1] = address(this);
293 
294         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
295             0,
296             path,
297             to,
298             block.timestamp
299         );
300     }
301 
302     function clearStuckBalance() external {
303         payable(marketingFeeReceiver).transfer(address(this).balance);
304     }
305 
306     function setWalletLimit(uint256 amountPercent) external onlyOwner {
307         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
308     }
309 
310     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
311          liquidityFee = _liquidityFee; 
312          marketingFee = _marketingFee;
313          totalFee = liquidityFee + marketingFee;
314     }    
315     
316     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
317 }