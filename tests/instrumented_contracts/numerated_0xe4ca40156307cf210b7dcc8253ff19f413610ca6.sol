1 //https://shinarium.org
2 
3 // SPDX-License-Identifier: None
4 
5 pragma solidity = 0.8.19;
6 
7 //--- Context ---//
8 abstract contract Context {
9     constructor() {
10     }
11 
12     function _msgSender() internal view returns (address payable) {
13         return payable(msg.sender);
14     }
15 
16     function _msgData() internal view returns (bytes memory) {
17         this;
18         return msg.data;
19     }
20 }
21 
22 //--- Ownable ---//
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _setOwner(_msgSender());
30     }
31 
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     function renounceOwnership() public virtual onlyOwner {
42         _setOwner(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         _setOwner(newOwner);
48     }
49 
50     function _setOwner(address newOwner) private {
51         address oldOwner = _owner;
52         _owner = newOwner;
53         emit OwnershipTransferred(oldOwner, newOwner);
54     }
55 }
56 
57 interface IFactoryV2 {
58     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
59     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
60     function createPair(address tokenA, address tokenB) external returns (address lpPair);
61 }
62 
63 interface IV2Pair {
64     function factory() external view returns (address);
65     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
66     function sync() external;
67 }
68 
69 interface IRouter01 {
70     function factory() external pure returns (address);
71     function WETH() external pure returns (address);
72     function addLiquidityETH(
73         address token,
74         uint amountTokenDesired,
75         uint amountTokenMin,
76         uint amountETHMin,
77         address to,
78         uint deadline
79     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
80     function addLiquidity(
81         address tokenA,
82         address tokenB,
83         uint amountADesired,
84         uint amountBDesired,
85         uint amountAMin,
86         uint amountBMin,
87         address to,
88         uint deadline
89     ) external returns (uint amountA, uint amountB, uint liquidity);
90     function swapExactETHForTokens(
91         uint amountOutMin, 
92         address[] calldata path, 
93         address to, uint deadline
94     ) external payable returns (uint[] memory amounts);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 interface IRouter02 is IRouter01 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
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
113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function swapExactTokensForTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external returns (uint[] memory amounts);
127 }
128 
129 
130 
131 //--- Interface for ERC20 ---//
132 interface IERC20 {
133     function totalSupply() external view returns (uint256);
134     function decimals() external view returns (uint8);
135     function symbol() external view returns (string memory);
136     function name() external view returns (string memory);
137     function getOwner() external view returns (address);
138     function balanceOf(address account) external view returns (uint256);
139     function transfer(address recipient, uint256 amount) external returns (bool);
140     function allowance(address _owner, address spender) external view returns (uint256);
141     function approve(address spender, uint256 amount) external returns (bool);
142     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
143     event Transfer(address indexed from, address indexed to, uint256 value);
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 //--- Contract v2 ---//
148 contract shinarium is Context, Ownable, IERC20 {
149 
150     function totalSupply() external pure override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply; }
151     function decimals() external pure override returns (uint8) { if (_totalSupply == 0) { revert(); } return _decimals; }
152     function symbol() external pure override returns (string memory) { return _symbol; }
153     function name() external pure override returns (string memory) { return _name; }
154     function getOwner() external view override returns (address) { return owner(); }
155     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
156     function balanceOf(address account) public view override returns (uint256) {
157         return balance[account];
158     }
159 
160 
161     mapping (address => mapping (address => uint256)) private _allowances;
162     mapping (address => bool) private _noFee;
163     mapping (address => bool) private liquidityAdd;
164     mapping (address => bool) private isLpPair;
165     mapping (address => uint256) private balance;
166 
167 
168     uint256 constant public _totalSupply = 20_000_000_000_000 * 10**18;
169     uint256 constant public swapThreshold = _totalSupply / 5_000;
170     uint256 constant public buyfee = 1;
171     uint256 constant public sellfee = 1;
172     uint256 constant public transferfee = 0;
173     uint256 constant public fee_denominator = 1_00;
174     bool private canSwapFees = true;
175     address payable private marketingAddress = payable(0xe66F20b40d67c36379d8d10A9bf2c8c94bcA2b13);
176 
177 
178     IRouter02 public swapRouter;
179     string constant private _name = "SHINARIUM";
180     string constant private _symbol = "SHINARIUM";
181     uint8 constant private _decimals = 18;
182     address public lpPair;
183     bool public isTradingEnabled = false;
184     bool private inSwap;
185 
186         modifier inSwapFlag {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192 
193     event _enableTrading();
194 
195 
196     constructor () {
197         _noFee[msg.sender] = true;
198 
199         if (block.chainid == 1 || block.chainid == 5) {
200             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
201         }
202         liquidityAdd[msg.sender] = true;
203         balance[msg.sender] = _totalSupply;
204         emit Transfer(address(0), msg.sender, _totalSupply);
205 
206         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
207         isLpPair[lpPair] = true;
208         _approve(msg.sender, address(swapRouter), type(uint256).max);
209         _approve(address(this), address(swapRouter), type(uint256).max);
210     }
211     
212     receive() external payable {}
213 
214         function transfer(address recipient, uint256 amount) public override returns (bool) {
215         _transfer(msg.sender, recipient, amount);
216         return true;
217     }
218 
219         function approve(address spender, uint256 amount) external override returns (bool) {
220         _approve(msg.sender, spender, amount);
221         return true;
222     }
223 
224         function _approve(address sender, address spender, uint256 amount) internal {
225         require(sender != address(0), "ERC20: Zero Address");
226         require(spender != address(0), "ERC20: Zero Address");
227 
228         _allowances[sender][spender] = amount;
229     }
230 
231         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
232         if (_allowances[sender][msg.sender] != type(uint256).max) {
233             _allowances[sender][msg.sender] -= amount;
234         }
235 
236         return _transfer(sender, recipient, amount);
237     }
238     function isExemptWallet(address account) external view returns(bool) {
239         return _noFee[account];
240     }
241 
242     function setExemptWallet(address account, bool enabled) public onlyOwner {
243         _noFee[account] = enabled;
244     }
245 
246     function isLimitedAddress(address ins, address out) internal view returns (bool) {
247 
248         bool isLimited = ins != owner()
249             && out != owner() && msg.sender != owner()
250             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != address(0) && out != address(this);
251             return isLimited;
252     }
253 
254     function is_buy(address ins, address out) internal view returns (bool) {
255         bool _is_buy = !isLpPair[out] && isLpPair[ins];
256         return _is_buy;
257     }
258 
259     function is_sell(address ins, address out) internal view returns (bool) { 
260         bool _is_sell = isLpPair[out] && !isLpPair[ins];
261         return _is_sell;
262     } 
263 
264     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
265         bool takeFee = true;
266         require(to != address(0), "ERC20: transfer to the zero address");
267         require(from != address(0), "ERC20: transfer from the zero address");
268         require(amount > 0, "Transfer amount must be greater than zero");
269 
270         if (isLimitedAddress(from,to)) {
271             require(isTradingEnabled,"Trading is not enabled");
272         }
273 
274 
275         if(is_sell(from, to) &&  !inSwap) {
276             uint256 contractTokenBalance = balanceOf(address(this));
277             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
278         }
279 
280         if (_noFee[from] || _noFee[to]){
281             takeFee = false;
282         }
283 
284         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
285         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
286 
287         return true;
288 
289     }
290 
291 
292     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
293         uint256 fee;
294         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
295         if (fee == 0)  return amount;
296         uint256 feeAmount = amount * fee / fee_denominator;
297         if (feeAmount > 0) {
298 
299             balance[address(this)] += feeAmount;
300             emit Transfer(from, address(this), feeAmount);
301             
302         }
303         return amount - feeAmount;
304     }
305 
306     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
307         
308         address[] memory path = new address[](2);
309         path[0] = address(this);
310         path[1] = swapRouter.WETH();
311 
312         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
313             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
314         }
315 
316         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
317             contractTokenBalance,
318             0,
319             path,
320             address(this),
321             block.timestamp
322         ) {} catch {
323             return;
324         }
325         bool success;
326 
327         if(address(this).balance > 0) {(success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");}
328 
329     }
330         function enableTrading() external onlyOwner {
331             require(!isTradingEnabled, "Trading already enabled");
332             isTradingEnabled = true;
333             emit _enableTrading();
334         }
335     
336 }