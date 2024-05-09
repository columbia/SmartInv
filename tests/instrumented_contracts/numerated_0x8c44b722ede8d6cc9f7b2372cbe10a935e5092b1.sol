1 // SPDX-License-Identifier: No
2 pragma solidity = 0.8.19;
3 
4 abstract contract Context {
5     constructor() {
6     }
7 
8     function _msgSender() internal view returns (address payable) {
9         return payable(msg.sender);
10     }
11 
12     function _msgData() internal view returns (bytes memory) {
13         this;
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     constructor() {
24         _setOwner(_msgSender());
25     }
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner {
37         _setOwner(address(0));
38     }
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(newOwner != address(0), "Ownable: new owner is the zero address");
42         _setOwner(newOwner);
43     }
44 
45     function _setOwner(address newOwner) private {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 interface IFactoryV2 {
53     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
54     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
55     function createPair(address tokenA, address tokenB) external returns (address lpPair);
56 }
57 
58 interface IRouter01 {
59     function factory() external pure returns (address);
60     function WETH() external pure returns (address);
61     function addLiquidityETH(
62         address token,
63         uint amountTokenDesired,
64         uint amountTokenMin,
65         uint amountETHMin,
66         address to,
67         uint deadline
68     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
69     function addLiquidity(
70         address tokenA,
71         address tokenB,
72         uint amountADesired,
73         uint amountBDesired,
74         uint amountAMin,
75         uint amountBMin,
76         address to,
77         uint deadline
78     ) external returns (uint amountA, uint amountB, uint liquidity);
79     function swapExactETHForTokens(
80         uint amountOutMin, 
81         address[] calldata path, 
82         address to, uint deadline
83     ) external payable returns (uint[] memory amounts);
84     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
85     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
86 }
87 
88 interface IRouter02 is IRouter01 {
89     function swapExactTokensForETHSupportingFeeOnTransferTokens(
90         uint amountIn,
91         uint amountOutMin,
92         address[] calldata path,
93         address to,
94         uint deadline
95     ) external;
96     function swapExactETHForTokensSupportingFeeOnTransferTokens(
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external payable;
102     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function swapExactTokensForTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external returns (uint[] memory amounts);
116 }
117 
118 interface IERC20 {
119     function totalSupply() external view returns (uint256);
120     function decimals() external view returns (uint8);
121     function symbol() external view returns (string memory);
122     function name() external view returns (string memory);
123     function getOwner() external view returns (address);
124     function balanceOf(address account) external view returns (uint256);
125     function transfer(address recipient, uint256 amount) external returns (bool);
126     function allowance(address _owner, address spender) external view returns (uint256);
127     function approve(address spender, uint256 amount) external returns (bool);
128     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
129     event Transfer(address indexed from, address indexed to, uint256 value);
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 contract PepeGains is Context, Ownable, IERC20 {
134 
135     function totalSupply() external pure override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply; }
136     function decimals() external pure override returns (uint8) { if (_totalSupply == 0) { revert(); } return _decimals; }
137     function symbol() external pure override returns (string memory) { return _symbol; }
138     function name() external pure override returns (string memory) { return _name; }
139     function getOwner() external view override returns (address) { return owner(); }
140     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
141     function balanceOf(address account) public view override returns (uint256) {
142         return balance[account];
143     }
144 
145     mapping (address => mapping (address => uint256)) private _allowances;
146     mapping (address => bool) private _noFee;
147     mapping (address => bool) private isLpPair;
148     mapping (address => uint256) private balance;
149 
150     uint256 constant public _totalSupply = 500_000_000 * 10**18;
151     uint256 public swapThreshold = 50_000;
152     uint256 constant public sellfee = 9;
153     uint256 constant public fee_denominator = 100;
154     
155     uint256 constant private burnFee = 2;
156     uint256 constant private burnDenominator = 100;
157     address payable private marketingAddress = payable(0x4060d2e1181C793e353ABFd35B82F4E764c0aA25); //need to change
158 
159     IRouter02 public swapRouter;
160     string constant private _name = "PepeGains";
161     string constant private _symbol = "PepeGains";
162     uint8 constant private _decimals = 18;
163     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
164     address public lpPair;
165     bool private inSwap;
166 
167         modifier inSwapFlag {
168         inSwap = true;
169         _;
170         inSwap = false;
171     }
172 
173     event updateThresold(uint256 amount);
174 
175     constructor () {
176         _noFee[msg.sender] = true;
177         _noFee[address(this)] = true;
178 
179         swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
180         balance[msg.sender] = _totalSupply;
181         emit Transfer(address(0), msg.sender, _totalSupply);
182 
183         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
184         isLpPair[lpPair] = true;
185         _approve(msg.sender, address(swapRouter), type(uint256).max);
186         _approve(address(this), address(swapRouter), type(uint256).max);
187     }
188 
189     receive() external payable {}
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(msg.sender, recipient, amount);
193         return true;
194     }
195 
196     function approve(address spender, uint256 amount) external override returns (bool) {
197         _approve(msg.sender, spender, amount);
198         return true;
199     }
200 
201     function _approve(address sender, address spender, uint256 amount) internal {
202         require(sender != address(0), "ERC20: Zero Address");
203         require(spender != address(0), "ERC20: Zero Address");
204         _allowances[sender][spender] = amount;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
208         if (_allowances[sender][msg.sender] != type(uint256).max) {
209             _allowances[sender][msg.sender] -= amount;
210         }
211 
212         return _transfer(sender, recipient, amount);
213     }
214 
215     function isNoFeeWallet(address account) external view returns(bool) {
216         return _noFee[account];
217     }
218 
219     function is_sell(address ins, address out) internal view returns (bool) { 
220         bool _is_sell = isLpPair[out] && !isLpPair[ins];
221         return _is_sell;
222     }
223 
224     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
225         bool takeFee = true;
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229 
230         if(is_sell(from, to) &&  !inSwap) {
231             uint256 contractTokenBalance = balanceOf(address(this));
232             if(contractTokenBalance >= swapThreshold) { 
233                 internalSwap(contractTokenBalance);
234              }
235         }
236 
237         if (_noFee[from] || _noFee[to]){
238             takeFee = false;
239         }
240         balance[from] -= amount;
241         uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_sell(from, to), amount) : amount;
242         balance[to] += amountAfterFee; 
243         emit Transfer(from, to, amountAfterFee);
244 
245         return true;
246     }
247 
248     function takeTaxes(address from, bool issell, uint256 amount) internal returns (uint256) {
249         uint256 fee = 0;
250         if (issell)  fee = sellfee;
251         if (fee == 0)  return amount; 
252 
253         uint256 feeAmount = amount * fee / fee_denominator;
254         if (feeAmount > 0) {
255             uint256 burnAmount = amount * burnFee / burnDenominator;
256             balance[address(this)] += feeAmount;
257             emit Transfer(from, address(this), feeAmount);
258 
259             if(burnAmount > 0) {
260                 balance[address(this)] -= burnAmount;
261                 balance[address(DEAD)] += burnAmount;
262                 emit Transfer(address(this), DEAD, burnAmount);
263             }
264         }
265         return amount - feeAmount;
266     }
267 
268     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
269         
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = swapRouter.WETH();
273 
274         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
275             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
276         }
277 
278         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             contractTokenBalance,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         ) {} catch {
285             return;
286         }
287         bool success;
288 
289         if(address(this).balance > 0) (success,) = marketingAddress.call{value: address(this).balance}("");
290     }
291 
292     function changeThreshold(uint256 amount) external onlyOwner {
293         require(amount >= 100,"Amount lower not accepted.");
294         swapThreshold = amount;
295         emit updateThresold(swapThreshold);
296     }
297 }