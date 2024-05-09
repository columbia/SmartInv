1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Website: https://babytrumpeth.com/
6 Telegram: https://t.me/BabyTrumpOfficial
7 Twitter: https://twitter.com/BabyTrumpToken
8 
9 */
10 
11 pragma solidity = 0.8.19;
12 
13 //--- Context ---//
14 abstract contract Context {
15     constructor() {
16     }
17 
18     function _msgSender() internal view returns (address payable) {
19         return payable(msg.sender);
20     }
21 
22     function _msgData() internal view returns (bytes memory) {
23         this;
24         return msg.data;
25     }
26 }
27 
28 //--- Ownable ---//
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() {
35         _setOwner(_msgSender());
36     }
37 
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     modifier onlyOwner() {
43         require(owner() == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         _setOwner(address(0));
49     }
50 
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         _setOwner(newOwner);
54     }
55 
56     function _setOwner(address newOwner) private {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 interface IFactoryV2 {
64     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
65     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
66     function createPair(address tokenA, address tokenB) external returns (address lpPair);
67 }
68 
69 interface IV2Pair {
70     function factory() external view returns (address);
71     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
72     function sync() external;
73 }
74 
75 interface IRouter01 {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78     function addLiquidityETH(
79         address token,
80         uint amountTokenDesired,
81         uint amountTokenMin,
82         uint amountETHMin,
83         address to,
84         uint deadline
85     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
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
96     function swapExactETHForTokens(
97         uint amountOutMin, 
98         address[] calldata path, 
99         address to, uint deadline
100     ) external payable returns (uint[] memory amounts);
101     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
102     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
103 }
104 
105 interface IRouter02 is IRouter01 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function swapExactETHForTokensSupportingFeeOnTransferTokens(
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external payable;
119     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function swapExactTokensForTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external returns (uint[] memory amounts);
133 }
134 
135 
136 
137 //--- Interface for ERC20 ---//
138 interface IERC20 {
139     function totalSupply() external view returns (uint256);
140     function decimals() external view returns (uint8);
141     function symbol() external view returns (string memory);
142     function name() external view returns (string memory);
143     function getOwner() external view returns (address);
144     function balanceOf(address account) external view returns (uint256);
145     function transfer(address recipient, uint256 amount) external returns (bool);
146     function allowance(address _owner, address spender) external view returns (uint256);
147     function approve(address spender, uint256 amount) external returns (bool);
148     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
149     event Transfer(address indexed from, address indexed to, uint256 value);
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 //--- Contract v2 ---//
154 contract BABYTRUMP is Context, Ownable, IERC20 {
155 
156     function totalSupply() external pure override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply; }
157     function decimals() external pure override returns (uint8) { if (_totalSupply == 0) { revert(); } return _decimals; }
158     function symbol() external pure override returns (string memory) { return _symbol; }
159     function name() external pure override returns (string memory) { return _name; }
160     function getOwner() external view override returns (address) { return owner(); }
161     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
162     function balanceOf(address account) public view override returns (uint256) {
163         return balance[account];
164     }
165 
166 
167     mapping (address => mapping (address => uint256)) private _allowances;
168     mapping (address => bool) private _noFee;
169     mapping (address => bool) private liquidityAdd;
170     mapping (address => bool) private isLpPair;
171     mapping (address => uint256) private balance;
172 
173 
174     uint256 constant public _totalSupply = 47000000 * 10**18;
175     uint256 constant public swapThreshold = _totalSupply / 5_00;
176     uint256 constant public buyfee = 2;
177     uint256 constant public sellfee = 2;
178     uint256 constant public transferfee = 0;
179     uint256 constant public fee_denominator = 1_00;
180     bool private canSwapFees = true;
181     address payable private marketingAddress = payable(0xf6C0D301FD8DD2d12F0154438aba67a9F612a1D3);
182 
183 
184     IRouter02 public swapRouter;
185     string constant private _name = "BABYTRUMP";
186     string constant private _symbol = "BABYTRUMP";
187     uint8 constant private _decimals = 18;
188     address public lpPair;
189     bool public isTradingEnabled = true;
190     bool private inSwap;
191 
192         modifier inSwapFlag {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197 
198 
199     event _enableTrading();
200 
201 
202     constructor () {
203         _noFee[msg.sender] = true;
204 
205         if (block.chainid == 1 || block.chainid == 5) {
206             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
207         }
208         liquidityAdd[msg.sender] = true;
209         balance[msg.sender] = _totalSupply;
210         emit Transfer(address(0), msg.sender, _totalSupply);
211 
212         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
213         isLpPair[lpPair] = true;
214         _approve(msg.sender, address(swapRouter), type(uint256).max);
215         _approve(address(this), address(swapRouter), type(uint256).max);
216     }
217     
218     receive() external payable {}
219 
220         function transfer(address recipient, uint256 amount) public override returns (bool) {
221         _transfer(msg.sender, recipient, amount);
222         return true;
223     }
224 
225         function approve(address spender, uint256 amount) external override returns (bool) {
226         _approve(msg.sender, spender, amount);
227         return true;
228     }
229 
230         function _approve(address sender, address spender, uint256 amount) internal {
231         require(sender != address(0), "ERC20: Zero Address");
232         require(spender != address(0), "ERC20: Zero Address");
233 
234         _allowances[sender][spender] = amount;
235     }
236 
237         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
238         if (_allowances[sender][msg.sender] != type(uint256).max) {
239             _allowances[sender][msg.sender] -= amount;
240         }
241 
242         return _transfer(sender, recipient, amount);
243     }
244     function isExemptWallet(address account) external view returns(bool) {
245         return _noFee[account];
246     }
247 
248     function setExemptWallet(address account, bool enabled) public onlyOwner {
249         _noFee[account] = enabled;
250     }
251 
252     function isLimitedAddress(address ins, address out) internal view returns (bool) {
253 
254         bool isLimited = ins != owner()
255             && out != owner() && msg.sender != owner()
256             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != address(0) && out != address(this);
257             return isLimited;
258     }
259 
260     function is_buy(address ins, address out) internal view returns (bool) {
261         bool _is_buy = !isLpPair[out] && isLpPair[ins];
262         return _is_buy;
263     }
264 
265     function is_sell(address ins, address out) internal view returns (bool) { 
266         bool _is_sell = isLpPair[out] && !isLpPair[ins];
267         return _is_sell;
268     } 
269 
270     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
271         bool takeFee = true;
272         require(to != address(0), "ERC20: transfer to the zero address");
273         require(from != address(0), "ERC20: transfer from the zero address");
274         require(amount > 0, "Transfer amount must be greater than zero");
275 
276         if (isLimitedAddress(from,to)) {
277             require(isTradingEnabled,"Trading is not enabled");
278         }
279 
280 
281         if(is_sell(from, to) &&  !inSwap) {
282             uint256 contractTokenBalance = balanceOf(address(this));
283             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
284         }
285 
286         if (_noFee[from] || _noFee[to]){
287             takeFee = false;
288         }
289 
290         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
291         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
292 
293         return true;
294 
295     }
296 
297 
298     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
299         uint256 fee;
300         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
301         if (fee == 0)  return amount;
302         uint256 feeAmount = amount * fee / fee_denominator;
303         if (feeAmount > 0) {
304 
305             balance[address(this)] += feeAmount;
306             emit Transfer(from, address(this), feeAmount);
307             
308         }
309         return amount - feeAmount;
310     }
311 
312     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
313         
314         address[] memory path = new address[](2);
315         path[0] = address(this);
316         path[1] = swapRouter.WETH();
317 
318         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
319             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
320         }
321 
322         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
323             contractTokenBalance,
324             0,
325             path,
326             address(this),
327             block.timestamp
328         ) {} catch {
329             return;
330         }
331         bool success;
332 
333         if(address(this).balance > 0) {(success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");}
334 
335     }
336         function enableTrading() external onlyOwner {
337             require(!isTradingEnabled, "Trading already enabled");
338             isTradingEnabled = true;
339             emit _enableTrading();
340         }
341     
342 }