1 // SPDX-License-Identifier: No
2 
3 pragma solidity = 0.8.19;
4 
5 //--- Context ---//
6 abstract contract Context {
7     constructor() {
8     }
9 
10     function _msgSender() internal view returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this;
16         return msg.data;
17     }
18 }
19 
20 //--- Ownable ---//
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _setOwner(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner {
40         _setOwner(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _setOwner(newOwner);
46     }
47 
48     function _setOwner(address newOwner) private {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IFactoryV2 {
56     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
57     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
58     function createPair(address tokenA, address tokenB) external returns (address lpPair);
59 }
60 
61 interface IV2Pair {
62     function factory() external view returns (address);
63     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64     function sync() external;
65 }
66 
67 interface IRouter01 {
68     function factory() external pure returns (address);
69     function WETH() external pure returns (address);
70     function addLiquidityETH(
71         address token,
72         uint amountTokenDesired,
73         uint amountTokenMin,
74         uint amountETHMin,
75         address to,
76         uint deadline
77     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
78     function addLiquidity(
79         address tokenA,
80         address tokenB,
81         uint amountADesired,
82         uint amountBDesired,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline
87     ) external returns (uint amountA, uint amountB, uint liquidity);
88     function swapExactETHForTokens(
89         uint amountOutMin, 
90         address[] calldata path, 
91         address to, uint deadline
92     ) external payable returns (uint[] memory amounts);
93     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
94     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
95 }
96 
97 interface IRouter02 is IRouter01 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118     function swapExactTokensForTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external returns (uint[] memory amounts);
125 }
126 
127 
128 
129 //--- Interface for ERC20 ---//
130 interface IERC20 {
131     function totalSupply() external view returns (uint256);
132     function decimals() external view returns (uint8);
133     function symbol() external view returns (string memory);
134     function name() external view returns (string memory);
135     function getOwner() external view returns (address);
136     function balanceOf(address account) external view returns (uint256);
137     function transfer(address recipient, uint256 amount) external returns (bool);
138     function allowance(address _owner, address spender) external view returns (uint256);
139     function approve(address spender, uint256 amount) external returns (bool);
140     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
141     event Transfer(address indexed from, address indexed to, uint256 value);
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 //--- Contract v2 ---//
146 contract ChainSwitch is Context, Ownable, IERC20 {
147 
148     function totalSupply() external pure override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply; }
149     function decimals() external pure override returns (uint8) { if (_totalSupply == 0) { revert(); } return _decimals; }
150     function symbol() external pure override returns (string memory) { return _symbol; }
151     function name() external pure override returns (string memory) { return _name; }
152     function getOwner() external view override returns (address) { return owner(); }
153     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
154     function balanceOf(address account) public view override returns (uint256) {
155         return balance[account];
156     }
157 
158 
159     mapping (address => mapping (address => uint256)) private _allowances;
160     mapping (address => bool) private _noFee;
161     mapping (address => bool) private liquidityAdd;
162     mapping (address => bool) private isLpPair;
163     mapping (address => bool) private isPresaleAddress;
164     mapping (address => uint256) private balance;
165 
166 
167 
168     uint256 constant public _totalSupply = 10_000_000 * 10**9;
169     uint256 constant public swapThreshold = _totalSupply / 20_000;
170     uint256 constant public buyfee = 30;
171     uint256 constant public sellfee = 30;
172     uint256 constant public transferfee = 0;
173     uint256 constant public fee_denominator = 1_000;
174     bool private canSwapFees = true;
175     address payable private marketingAddress = payable(0x1321a912d0CfA875A5ca021aB7ebcE78C4dDB05D);
176     address payable private developmentAddress = payable(0x4E3d3C5f70491DB1e1265ff0d27b182dEa799F1f);
177     address payable private teamAddress = payable(0xEDa35900a511fa4B16eDc32fa203cBc7b6515d99);
178 
179 
180     IRouter02 public swapRouter;
181     string constant private _name = "Chainswitch";
182     string constant private _symbol = "SWITCH";
183     uint8 constant private _decimals = 9;
184     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
185     address public lpPair;
186     bool public isTradingEnabled = false;
187     bool inSwap;
188 
189         modifier inSwapFlag {
190         inSwap = true;
191         _;
192         inSwap = false;
193     }
194 
195 
196     event _enableTrading();
197     event _setPresaleAddress(address account, bool enabled);
198     event _toggleCanSwapFees(bool enabled);
199     event _changePair(address newLpPair);
200     event _changeThreshold(uint256 newThreshold);
201     event _changeWallets(address marketing, address team, address development);
202     event _changeFees(uint256 buy, uint256 sell);
203 
204 
205     constructor () {
206         _noFee[msg.sender] = true;
207 
208         if (block.chainid == 56) {
209             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
210         } else if (block.chainid == 97) {
211             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); // 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3 // 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
212         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
213             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         } else if (block.chainid == 42161) {
215             swapRouter = IRouter02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
216         } else if (block.chainid == 250) {
217             swapRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
218         } else {
219             revert("Chain not valid");
220         }
221         liquidityAdd[msg.sender] = true;
222         balance[msg.sender] = _totalSupply;
223         emit Transfer(address(0), msg.sender, _totalSupply);
224 
225         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
226         isLpPair[lpPair] = true;
227         _approve(msg.sender, address(swapRouter), type(uint256).max);
228         _approve(address(this), address(swapRouter), type(uint256).max);
229 
230 
231     }
232 
233     receive() external payable {}
234 
235         function transfer(address recipient, uint256 amount) public override returns (bool) {
236         _transfer(msg.sender, recipient, amount);
237         return true;
238     }
239 
240         function approve(address spender, uint256 amount) external override returns (bool) {
241         _approve(msg.sender, spender, amount);
242         return true;
243     }
244 
245         function _approve(address sender, address spender, uint256 amount) internal {
246         require(sender != address(0), "ERC20: Zero Address");
247         require(spender != address(0), "ERC20: Zero Address");
248 
249         _allowances[sender][spender] = amount;
250     }
251 
252         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
253         if (_allowances[sender][msg.sender] != type(uint256).max) {
254             _allowances[sender][msg.sender] -= amount;
255         }
256 
257         return _transfer(sender, recipient, amount);
258     }
259     function isNoFeeWallet(address account) external view returns(bool) {
260         return _noFee[account];
261     }
262 
263     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
264         _noFee[account] = enabled;
265     }
266 
267     function isLimitedAddress(address ins, address out) internal view returns (bool) {
268 
269         bool isLimited = ins != owner()
270             && out != owner() && tx.origin != owner() // any transaction with no direct interaction from owner will be accepted
271             && msg.sender != owner()
272             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
273             return isLimited;
274     }
275 
276     function is_buy(address ins, address out) internal view returns (bool) {
277         bool _is_buy = !isLpPair[out] && isLpPair[ins];
278         return _is_buy;
279     }
280 
281     function is_sell(address ins, address out) internal view returns (bool) { 
282         bool _is_sell = isLpPair[out] && !isLpPair[ins];
283         return _is_sell;
284     }
285 
286     function is_transfer(address ins, address out) internal view returns (bool) { 
287         bool _is_transfer = !isLpPair[out] && !isLpPair[ins];
288         return _is_transfer;
289     }
290 
291     function canSwap(address ins, address out) internal view returns (bool) {
292         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
293 
294         return canswap;
295     }
296 
297     function changeLpPair(address newPair) external onlyOwner {
298         isLpPair[newPair] = true;
299         emit _changePair(newPair);
300     }
301 
302     function toggleCanSwapFees(bool yesno) external onlyOwner {
303         require(canSwapFees != yesno,"Bool is the same");
304         canSwapFees = yesno;
305         emit _toggleCanSwapFees(yesno);
306     }
307 
308     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
309         bool takeFee = true;
310         require(to != address(0), "ERC20: transfer to the zero address");
311         require(from != address(0), "ERC20: transfer from the zero address");
312         require(amount > 0, "Transfer amount must be greater than zero");
313 
314         if (isLimitedAddress(from,to)) {
315             require(isTradingEnabled,"Trading is not enabled");
316         }
317 
318 
319         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
320             uint256 contractTokenBalance = balanceOf(address(this));
321             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
322         }
323 
324         if (_noFee[from] || _noFee[to]){
325             takeFee = false;
326         }
327         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
328         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
329 
330         return true;
331 
332     }
333 
334     function changeWallets(address marketing, address team, address development) external onlyOwner {
335         teamAddress = payable(team);
336         developmentAddress = payable(development);
337         marketingAddress = payable(marketing);
338         emit _changeWallets(marketing, team, development);
339     }
340 
341 
342     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
343         uint256 fee;
344         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
345         if (fee == 0)  return amount; 
346         uint256 feeAmount = amount * fee / fee_denominator;
347         if (feeAmount > 0) {
348 
349             balance[address(this)] += feeAmount;
350             emit Transfer(from, address(this), feeAmount);
351             
352         }
353         return amount - feeAmount;
354     }
355 
356     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
357         
358         address[] memory path = new address[](2);
359         path[0] = address(this);
360         path[1] = swapRouter.WETH();
361 
362         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
363             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
364         }
365 
366         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
367             contractTokenBalance,
368             0,
369             path,
370             address(this),
371             block.timestamp
372         ) {} catch {
373             return;
374         }
375         bool success1;
376         bool success2;
377         bool success3;
378 
379         uint256 Marketing =  address(this).balance / 2;
380         uint256 Development =  address(this).balance / 4;
381 
382 
383         if(Marketing > 0 || Development > 0) {
384             (success1,) = marketingAddress.call{value: Marketing, gas: 35000}("");
385             (success2,) = developmentAddress.call{value: Development, gas: 35000}("");
386             (success3,) = teamAddress.call{value: address(this).balance, gas: 35000}("");
387         }
388     }
389 
390 
391         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
392             require(isPresaleAddress[presale] != yesno,"Same bool");
393             isPresaleAddress[presale] = yesno;
394             _noFee[presale] = yesno;
395             liquidityAdd[presale] = yesno;
396             emit _setPresaleAddress(presale, yesno);
397         }
398 
399         function enableTrading() external onlyOwner {
400             require(!isTradingEnabled, "Trading already enabled");
401             isTradingEnabled = true;
402             emit _enableTrading();
403         }
404 }