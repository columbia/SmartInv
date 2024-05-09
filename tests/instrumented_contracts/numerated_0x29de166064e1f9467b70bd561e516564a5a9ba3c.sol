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
146 contract povchain is Context, Ownable, IERC20 {
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
167     uint256 constant public _totalSupply = 420_000_000_000_000_000 * 10**9;
168     uint256 constant public swapThreshold = _totalSupply / 5_000;
169     uint256 constant public buyfee = 0;
170     uint256 constant public sellfee = 30;
171     uint256 constant public transferfee = 0;
172     uint256 constant public fee_denominator = 1_000;
173     bool private canSwapFees = false;
174     address payable private marketingAddress = payable(0x55628F08f4d947bBCd1c90509FeA9b71e2A099B0);
175     address payable private marketing2Address = payable(0x6bf35E66D227141616FDA303947861BA4348b2Bc);
176 
177 
178     IRouter02 public swapRouter;
179     string constant private _name = "POV Chain";
180     string constant private _symbol = "$POVChain";
181     uint8 constant private _decimals = 9;
182     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
183     address public lpPair;
184     bool public isTradingEnabled = false;
185     bool private inSwap;
186 
187         modifier inSwapFlag {
188         inSwap = true;
189         _;
190         inSwap = false;
191     }
192 
193 
194     event _enableTrading();
195     event _setPresaleAddress(address account, bool enabled);
196     event _toggleCanSwapFees(bool enabled);
197     event _changePair(address newLpPair);
198     event _changeWallets(address marketing, address marketing2);
199 
200 
201     constructor () {
202         _noFee[msg.sender] = true;
203 
204         if (block.chainid == 56) {
205             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
206         } else if (block.chainid == 97) {
207             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
208         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
209             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
210         } else if (block.chainid == 43114) {
211             swapRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
212         } else if (block.chainid == 250) {
213             swapRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
214         } else {
215             revert("Chain not valid");
216         }
217         liquidityAdd[msg.sender] = true;
218         balance[msg.sender] = _totalSupply;
219         emit Transfer(address(0), msg.sender, _totalSupply);
220 
221         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
222         isLpPair[lpPair] = true;
223         _approve(msg.sender, address(swapRouter), type(uint256).max);
224         _approve(address(this), address(swapRouter), type(uint256).max);
225     }
226     
227     receive() external payable {}
228 
229         function transfer(address recipient, uint256 amount) public override returns (bool) {
230         _transfer(msg.sender, recipient, amount);
231         return true;
232     }
233 
234         function approve(address spender, uint256 amount) external override returns (bool) {
235         _approve(msg.sender, spender, amount);
236         return true;
237     }
238 
239         function _approve(address sender, address spender, uint256 amount) internal {
240         require(sender != address(0), "ERC20: Zero Address");
241         require(spender != address(0), "ERC20: Zero Address");
242 
243         _allowances[sender][spender] = amount;
244     }
245 
246         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
247         if (_allowances[sender][msg.sender] != type(uint256).max) {
248             _allowances[sender][msg.sender] -= amount;
249         }
250 
251         return _transfer(sender, recipient, amount);
252     }
253     function isNoFeeWallet(address account) external view returns(bool) {
254         return _noFee[account];
255     }
256 
257     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
258         _noFee[account] = enabled;
259     }
260 
261     function isLimitedAddress(address ins, address out) internal view returns (bool) {
262 
263         bool isLimited = ins != owner()
264             && out != owner() && msg.sender != owner()
265             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
266             return isLimited;
267     }
268 
269     function is_buy(address ins, address out) internal view returns (bool) {
270         bool _is_buy = !isLpPair[out] && isLpPair[ins];
271         return _is_buy;
272     }
273 
274     function is_sell(address ins, address out) internal view returns (bool) { 
275         bool _is_sell = isLpPair[out] && !isLpPair[ins];
276         return _is_sell;
277     } 
278 
279     function canSwap(address ins, address out) internal view returns (bool) {
280         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
281 
282         return canswap;
283     }
284 
285     function changeLpPair(address newPair) external onlyOwner {
286         isLpPair[newPair] = true;
287         emit _changePair(newPair);
288     }
289 
290     function toggleCanSwapFees(bool yesno) external onlyOwner {
291         require(canSwapFees != yesno,"Bool is the same");
292         canSwapFees = yesno;
293         emit _toggleCanSwapFees(yesno);
294     }
295 
296     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
297         bool takeFee = true;
298         require(to != address(0), "ERC20: transfer to the zero address");
299         require(from != address(0), "ERC20: transfer from the zero address");
300         require(amount > 0, "Transfer amount must be greater than zero");
301 
302         if (isLimitedAddress(from,to)) {
303             require(isTradingEnabled,"Trading is not enabled");
304         }
305 
306 
307         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
308             uint256 contractTokenBalance = balanceOf(address(this));
309             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
310         }
311 
312         if (_noFee[from] || _noFee[to]){
313             takeFee = false;
314         }
315 
316         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
317         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
318 
319         return true;
320 
321     }
322 
323     function changeWallets(address marketing, address marketing2) external onlyOwner {
324         marketingAddress = payable(marketing);
325         marketing2Address = payable(marketing2);
326         emit _changeWallets(marketing, marketing2);
327     }
328 
329 
330     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
331         uint256 fee;
332         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
333         if (fee == 0)  return amount;
334         uint256 feeAmount = amount * fee / fee_denominator;
335         if (feeAmount > 0) {
336 
337             balance[address(this)] += feeAmount;
338             emit Transfer(from, address(this), feeAmount);
339             
340         }
341         return amount - feeAmount;
342     }
343 
344     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
345         
346         address[] memory path = new address[](2);
347         path[0] = address(this);
348         path[1] = swapRouter.WETH();
349 
350         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
351             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
352         }
353 
354         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
355             contractTokenBalance,
356             0,
357             path,
358             address(this),
359             block.timestamp
360         ) {} catch {
361             return;
362         }
363         bool success;
364 
365         uint256 twoThird = address(this).balance * 2 / 3;
366 
367         if(twoThird > 0) {(success,) = marketingAddress.call{value: twoThird, gas: 35000}("");}
368         if(address(this).balance > 0) {(success,) = marketing2Address.call{value: address(this).balance, gas: 35000}("");}
369 
370     }
371 
372         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
373             require(isPresaleAddress[presale] != yesno,"Same bool");
374             isPresaleAddress[presale] = yesno;
375             _noFee[presale] = yesno;
376             liquidityAdd[presale] = yesno;
377             emit _setPresaleAddress(presale, yesno);
378         }
379 
380         function enableTrading() external onlyOwner {
381             require(!isTradingEnabled, "Trading already enabled");
382             isTradingEnabled = true;
383             emit _enableTrading();
384         }
385     
386 }