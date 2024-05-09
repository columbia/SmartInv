1 //
2 // ██████╗ ███████╗██████╗ ███████╗ ██████╗ ███████╗
3 // ██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝ ██╔════╝
4 // ██████╔╝█████╗  ██████╔╝█████╗  ██║  ███╗█████╗  
5 // ██╔═══╝ ██╔══╝  ██╔═══╝ ██╔══╝  ██║   ██║██╔══╝  
6 // ██║     ███████╗██║     ███████╗╚██████╔╝██║     
7 // ╚═╝     ╚══════╝╚═╝     ╚══════╝ ╚═════╝ ╚═╝                                                         
8 //                                                         
9 // pepe iz no longr lonely, pepe haz girlfren?? her neme iz pipi
10 // feels good man
11 //
12 // https://t.me/PepeGfEntry
13 // https://www.pepegf.co/
14 // 
15 //
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.5;
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22         return c;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 
50 interface ERC20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 abstract contract Ownable {
66     address internal owner;
67     constructor(address _owner) {
68         owner = _owner;
69     }
70     modifier onlyOwner() {
71         require(isOwner(msg.sender), "!OWNER"); _;
72     }
73     function isOwner(address account) public view returns (bool) {
74         return account == owner;
75     }
76     function renounceOwnership() public onlyOwner {
77         owner = address(0);
78         emit OwnershipTransferred(address(0));
79     }  
80     event OwnershipTransferred(address owner);
81 }
82 
83 interface IDEXFactory {
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85 }
86 
87 interface IDEXRouter {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90     function addLiquidity(
91         address tokenA,
92         address tokenB,
93         uint amountADesired,
94         uint amountBDesired,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline
99     ) external returns (uint amountA, uint amountB, uint liquidity);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function swapExactETHForTokensSupportingFeeOnTransferTokens(
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external payable;
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128 }
129 
130 contract PEPEGF is ERC20, Ownable {
131     using SafeMath for uint256;
132     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
133     address DEAD = 0x000000000000000000000000000000000000dEaD;
134 
135     string constant _name = "PEPEGF";
136     string constant _symbol = "PEPEGF";
137     uint8 constant _decimals = 9;
138 
139     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
140     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
141 
142     mapping (address => uint256) _balances;
143     mapping (address => mapping (address => uint256)) _allowances;
144 
145     mapping (address => bool) isFeeExempt;
146     mapping (address => bool) isTxLimitExempt;
147 
148     uint256 liquidityFee = 0; 
149     uint256 marketingFee = 8;
150     uint256 totalFee = liquidityFee + marketingFee;
151     uint256 feeDenominator = 100;
152 
153     address public marketingFeeReceiver = 0x092209156BfA699e50EfCDBd692F3477390190d2;
154 
155     IDEXRouter public router;
156     address public pair;
157 
158     bool public swapEnabled = true;
159     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
160     bool inSwap;
161     modifier swapping() { inSwap = true; _; inSwap = false; }
162 
163     constructor () Ownable(msg.sender) {
164         router = IDEXRouter(routerAdress);
165         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
166         _allowances[address(this)][address(router)] = type(uint256).max;
167 
168         address _owner = owner;
169         isFeeExempt[0x092209156BfA699e50EfCDBd692F3477390190d2] = true;
170         isTxLimitExempt[_owner] = true;
171         isTxLimitExempt[0x092209156BfA699e50EfCDBd692F3477390190d2] = true;
172         isTxLimitExempt[DEAD] = true;
173 
174         _balances[_owner] = _totalSupply;
175         emit Transfer(address(0), _owner, _totalSupply);
176     }
177 
178     receive() external payable { }
179 
180     function totalSupply() external view override returns (uint256) { return _totalSupply; }
181     function decimals() external pure override returns (uint8) { return _decimals; }
182     function symbol() external pure override returns (string memory) { return _symbol; }
183     function name() external pure override returns (string memory) { return _name; }
184     function getOwner() external view override returns (address) { return owner; }
185     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
186     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _allowances[msg.sender][spender] = amount;
190         emit Approval(msg.sender, spender, amount);
191         return true;
192     }
193 
194     function approveMax(address spender) external returns (bool) {
195         return approve(spender, type(uint256).max);
196     }
197 
198     function transfer(address recipient, uint256 amount) external override returns (bool) {
199         return _transferFrom(msg.sender, recipient, amount);
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
203         if(_allowances[sender][msg.sender] != type(uint256).max){
204             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
205         }
206 
207         return _transferFrom(sender, recipient, amount);
208     }
209 
210     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
211         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
212         
213         if (recipient != pair && recipient != DEAD) {
214             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
215         }
216         
217         if(shouldSwapBack()){ swapBack(); } 
218 
219         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
220 
221         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
222         _balances[recipient] = _balances[recipient].add(amountReceived);
223 
224         emit Transfer(sender, recipient, amountReceived);
225         return true;
226     }
227     
228     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
229         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
230         _balances[recipient] = _balances[recipient].add(amount);
231         emit Transfer(sender, recipient, amount);
232         return true;
233     }
234 
235     function shouldTakeFee(address sender) internal view returns (bool) {
236         return !isFeeExempt[sender];
237     }
238 
239     function takeFee(address sender, uint256 amount) internal returns (uint256) {
240         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
241         _balances[address(this)] = _balances[address(this)].add(feeAmount);
242         emit Transfer(sender, address(this), feeAmount);
243         return amount.sub(feeAmount);
244     }
245 
246     function shouldSwapBack() internal view returns (bool) {
247         return msg.sender != pair
248         && !inSwap
249         && swapEnabled
250         && _balances[address(this)] >= swapThreshold;
251     }
252 
253     function swapBack() internal swapping {
254         uint256 contractTokenBalance = swapThreshold;
255         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
256         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
257 
258         address[] memory path = new address[](2);
259         path[0] = address(this);
260         path[1] = router.WETH();
261 
262         uint256 balanceBefore = address(this).balance;
263 
264         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
265             amountToSwap,
266             0,
267             path,
268             address(this),
269             block.timestamp
270         );
271         uint256 amountETH = address(this).balance.sub(balanceBefore);
272         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
273         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
274         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
275 
276 
277         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
278         require(MarketingSuccess, "receiver rejected ETH transfer");
279 
280         if(amountToLiquify > 0){
281             router.addLiquidityETH{value: amountETHLiquidity}(
282                 address(this),
283                 amountToLiquify,
284                 0,
285                 0,
286                 0x092209156BfA699e50EfCDBd692F3477390190d2,
287                 block.timestamp
288             );
289             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
290         }
291     }
292 
293     function buyTokens(uint256 amount, address to) internal swapping {
294         address[] memory path = new address[](2);
295         path[0] = router.WETH();
296         path[1] = address(this);
297 
298         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
299             0,
300             path,
301             to,
302             block.timestamp
303         );
304     }
305 
306     function clearStuckBalance() external {
307         payable(marketingFeeReceiver).transfer(address(this).balance);
308     }
309 
310     function setWalletLimit(uint256 amountPercent) external onlyOwner {
311         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
312     }
313 
314     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
315          liquidityFee = _liquidityFee; 
316          marketingFee = _marketingFee;
317          totalFee = liquidityFee + marketingFee;
318     }    
319     
320     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
321 }