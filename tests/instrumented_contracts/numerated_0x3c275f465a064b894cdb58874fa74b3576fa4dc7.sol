1 /**
2 
3    ____ _  __ ________  ______
4   / __ \ |/ //  _/ __ \/ ____/
5  / / / /   / / // / / / __/   
6 / /_/ /   |_/ // /_/ / /___   
7 \____/_/|_/___/_____/_____/   
8 
9 https://www.oxide.land/ 
10 
11 https://t.me/OxidePortal                         
12 
13 */
14  
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.5;
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29         return c;
30     }
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         return c;
46     }
47 }
48 
49 interface ERC20 {
50     function totalSupply() external view returns (uint256);
51     function decimals() external view returns (uint8);
52     function symbol() external view returns (string memory);
53     function name() external view returns (string memory);
54     function getOwner() external view returns (address);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address _owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 abstract contract Ownable {
65     address internal owner;
66     constructor(address _owner) {
67         owner = _owner;
68     }
69     modifier onlyOwner() {
70         require(isOwner(msg.sender), "!OWNER"); _;
71     }
72     function isOwner(address account) public view returns (bool) {
73         return account == owner;
74     }
75     function renounceOwnership() public onlyOwner {
76         owner = address(0);
77         emit OwnershipTransferred(address(0));
78     }  
79     event OwnershipTransferred(address owner);
80 }
81 
82 interface IDEXFactory {
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 }
85 
86 interface IDEXRouter {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89     function addLiquidity(
90         address tokenA,
91         address tokenB,
92         uint amountADesired,
93         uint amountBDesired,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline
98     ) external returns (uint amountA, uint amountB, uint liquidity);
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function swapExactETHForTokensSupportingFeeOnTransferTokens(
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external payable;
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127 }
128 
129 contract OXIDE is ERC20, Ownable {
130     using SafeMath for uint256;
131     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
132     address DEAD = 0x000000000000000000000000000000000000dEaD;
133 
134     string constant _name = "OXIDE";
135     string constant _symbol = "OXIDE";
136     uint8 constant _decimals = 9;
137 
138     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
139     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
140 
141     mapping (address => uint256) _balances;
142     mapping (address => mapping (address => uint256)) _allowances;
143 
144     mapping (address => bool) isFeeExempt;
145     mapping (address => bool) isTxLimitExempt;
146 
147     uint256 liquidityFee = 0; 
148     uint256 marketingFee = 5;
149     uint256 totalFee = liquidityFee + marketingFee;
150     uint256 feeDenominator = 100;
151 
152     address public marketingFeeReceiver = 0x71d7C3eF9D1453B06Fa5038aB50FEa95b1031e62;
153 
154     IDEXRouter public router;
155     address public pair;
156 
157     bool public swapEnabled = true;
158     uint256 public swapThreshold = _totalSupply / 1000 * 3; // 0.5%
159     bool inSwap;
160     modifier swapping() { inSwap = true; _; inSwap = false; }
161 
162     constructor () Ownable(msg.sender) {
163         router = IDEXRouter(routerAdress);
164         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
165         _allowances[address(this)][address(router)] = type(uint256).max;
166 
167         address _owner = owner;
168         isFeeExempt[0x71d7C3eF9D1453B06Fa5038aB50FEa95b1031e62] = true;
169         isTxLimitExempt[_owner] = true;
170         isTxLimitExempt[0x71d7C3eF9D1453B06Fa5038aB50FEa95b1031e62] = true;
171         isTxLimitExempt[DEAD] = true;
172 
173         _balances[_owner] = _totalSupply;
174         emit Transfer(address(0), _owner, _totalSupply);
175     }
176 
177     receive() external payable { }
178 
179     function totalSupply() external view override returns (uint256) { return _totalSupply; }
180     function decimals() external pure override returns (uint8) { return _decimals; }
181     function symbol() external pure override returns (string memory) { return _symbol; }
182     function name() external pure override returns (string memory) { return _name; }
183     function getOwner() external view override returns (address) { return owner; }
184     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
185     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
186 
187     function approve(address spender, uint256 amount) public override returns (bool) {
188         _allowances[msg.sender][spender] = amount;
189         emit Approval(msg.sender, spender, amount);
190         return true;
191     }
192 
193     function approveMax(address spender) external returns (bool) {
194         return approve(spender, type(uint256).max);
195     }
196 
197     function transfer(address recipient, uint256 amount) external override returns (bool) {
198         return _transferFrom(msg.sender, recipient, amount);
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
202         if(_allowances[sender][msg.sender] != type(uint256).max){
203             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
204         }
205 
206         return _transferFrom(sender, recipient, amount);
207     }
208 
209     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
210         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
211         
212         if (recipient != pair && recipient != DEAD) {
213             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
214         }
215         
216         if(shouldSwapBack()){ swapBack(); } 
217 
218         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
219 
220         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
221         _balances[recipient] = _balances[recipient].add(amountReceived);
222 
223         emit Transfer(sender, recipient, amountReceived);
224         return true;
225     }
226     
227     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
228         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
229         _balances[recipient] = _balances[recipient].add(amount);
230         emit Transfer(sender, recipient, amount);
231         return true;
232     }
233 
234     function shouldTakeFee(address sender) internal view returns (bool) {
235         return !isFeeExempt[sender];
236     }
237 
238     function takeFee(address sender, uint256 amount) internal returns (uint256) {
239         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
240         _balances[address(this)] = _balances[address(this)].add(feeAmount);
241         emit Transfer(sender, address(this), feeAmount);
242         return amount.sub(feeAmount);
243     }
244 
245     function shouldSwapBack() internal view returns (bool) {
246         return msg.sender != pair
247         && !inSwap
248         && swapEnabled
249         && _balances[address(this)] >= swapThreshold;
250     }
251 
252     function swapBack() internal swapping {
253         uint256 contractTokenBalance = swapThreshold;
254         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
255         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
256 
257         address[] memory path = new address[](2);
258         path[0] = address(this);
259         path[1] = router.WETH();
260 
261         uint256 balanceBefore = address(this).balance;
262 
263         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
264             amountToSwap,
265             0,
266             path,
267             address(this),
268             block.timestamp
269         );
270         uint256 amountETH = address(this).balance.sub(balanceBefore);
271         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
272         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
273         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
274 
275 
276         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
277         require(MarketingSuccess, "receiver rejected ETH transfer");
278 
279         if(amountToLiquify > 0){
280             router.addLiquidityETH{value: amountETHLiquidity}(
281                 address(this),
282                 amountToLiquify,
283                 0,
284                 0,
285                 0x71d7C3eF9D1453B06Fa5038aB50FEa95b1031e62,
286                 block.timestamp
287             );
288             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
289         }
290     }
291 
292     function buyTokens(uint256 amount, address to) internal swapping {
293         address[] memory path = new address[](2);
294         path[0] = router.WETH();
295         path[1] = address(this);
296 
297         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
298             0,
299             path,
300             to,
301             block.timestamp
302         );
303     }
304 
305     function clearStuckBalance() external {
306         payable(marketingFeeReceiver).transfer(address(this).balance);
307     }
308 
309     function setWalletLimit(uint256 amountPercent) external onlyOwner {
310         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
311     }
312 
313     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
314          liquidityFee = _liquidityFee; 
315          marketingFee = _marketingFee;
316          totalFee = liquidityFee + marketingFee;
317     }    
318     
319     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
320 }