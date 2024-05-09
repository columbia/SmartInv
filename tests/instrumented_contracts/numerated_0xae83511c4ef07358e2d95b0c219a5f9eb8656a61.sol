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
146 contract BABYFLOKI is Context, Ownable, IERC20 {
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
167     uint256 constant public _totalSupply = 420_690_000_000_000 * 10**18;
168     uint256 constant public swapThreshold = _totalSupply / 1_000;
169     uint256 constant public buyfee = 10;
170     uint256 constant public sellfee = 10;
171     uint256 constant public transferfee = 0;
172     uint256 constant public botFee = 890;
173     uint256 private _deadline;
174     uint256 constant public fee_denominator = 1_000;
175     bool private canSwapFees = false;
176     address payable private marketingAddress = payable(address(0x1234));
177     address payable private devAddress = payable(address(0x12345));
178 
179 
180     IRouter02 public swapRouter;
181     string constant private _name = "Baby Floki";
182     string constant private _symbol = "BABYFLOKI";
183     uint8 constant private _decimals = 18;
184     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
185     address public lpPair;
186     bool public isTradingEnabled = false;
187     bool private inSwap;
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
201     event _changeWallets(address marketing, address dev);
202 
203 
204     constructor () {
205         _noFee[msg.sender] = true;
206 
207         if (block.chainid == 56) {
208             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
209         } else if (block.chainid == 97) {
210             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
211         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
212             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
213         } else if (block.chainid == 43114) {
214             swapRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
215         } else if (block.chainid == 250) {
216             swapRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
217         } else {
218             revert("Chain not valid");
219         }
220         liquidityAdd[msg.sender] = true;
221         balance[msg.sender] = _totalSupply;
222         emit Transfer(address(0), msg.sender, _totalSupply);
223 
224         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
225         isLpPair[lpPair] = true;
226         _approve(msg.sender, address(swapRouter), type(uint256).max);
227         _approve(address(this), address(swapRouter), type(uint256).max);
228     }
229     
230     receive() external payable {}
231 
232         function transfer(address recipient, uint256 amount) public override returns (bool) {
233         _transfer(msg.sender, recipient, amount);
234         return true;
235     }
236 
237         function approve(address spender, uint256 amount) external override returns (bool) {
238         _approve(msg.sender, spender, amount);
239         return true;
240     }
241 
242         function _approve(address sender, address spender, uint256 amount) internal {
243         require(sender != address(0), "ERC20: Zero Address");
244         require(spender != address(0), "ERC20: Zero Address");
245 
246         _allowances[sender][spender] = amount;
247     }
248 
249         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
250         if (_allowances[sender][msg.sender] != type(uint256).max) {
251             _allowances[sender][msg.sender] -= amount;
252         }
253 
254         return _transfer(sender, recipient, amount);
255     }
256     function isNoFeeWallet(address account) external view returns(bool) {
257         return _noFee[account];
258     }
259 
260     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
261         _noFee[account] = enabled;
262     }
263 
264     function isLimitedAddress(address ins, address out) internal view returns (bool) {
265 
266         bool isLimited = ins != owner()
267             && out != owner() && msg.sender != owner()
268             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
269             return isLimited;
270     }
271 
272     function is_buy(address ins, address out) internal view returns (bool) {
273         bool _is_buy = !isLpPair[out] && isLpPair[ins];
274         return _is_buy;
275     }
276 
277     function is_sell(address ins, address out) internal view returns (bool) { 
278         bool _is_sell = isLpPair[out] && !isLpPair[ins];
279         return _is_sell;
280     }
281 
282     function canSwap(address ins, address out) internal view returns (bool) {
283         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
284 
285         return canswap;
286     }
287 
288     function changeLpPair(address newPair) external onlyOwner {
289         isLpPair[newPair] = true;
290         emit _changePair(newPair);
291     }
292 
293     function toggleCanSwapFees(bool yesno) external onlyOwner {
294         require(canSwapFees != yesno,"Bool is the same");
295         canSwapFees = yesno;
296         emit _toggleCanSwapFees(yesno);
297     }
298 
299     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
300         bool takeFee = true;
301         require(to != address(0), "ERC20: transfer to the zero address");
302         require(from != address(0), "ERC20: transfer from the zero address");
303         require(amount > 0, "Transfer amount must be greater than zero");
304 
305         bool launchtax = isLimitedAddress(from,to) && isTradingEnabled && block.number <= _deadline;
306 
307         if (isLimitedAddress(from,to)) {
308             require(isTradingEnabled,"Trading is not enabled");
309         }
310 
311 
312         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
313             uint256 contractTokenBalance = balanceOf(address(this));
314             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
315         }
316 
317         if (_noFee[from] || _noFee[to]){
318             takeFee = false;
319         }
320 
321         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount, launchtax) : amount;
322         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
323 
324         return true;
325 
326     }
327 
328     function changeWallets(address marketing, address dev) external onlyOwner {
329         require(marketing != address(0));
330         require(dev != address(0));
331         devAddress = payable(dev);
332         marketingAddress = payable(marketing);
333         emit _changeWallets(marketing, dev);
334     }
335 
336 
337     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount, bool _launchtax) internal returns (uint256) {
338         uint256 fee;
339         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
340         if(_launchtax) fee =  botFee;
341         if (fee == 0)  return amount;
342         uint256 feeAmount = amount * fee / fee_denominator;
343         if (feeAmount > 0) {
344 
345             balance[address(this)] += feeAmount;
346             emit Transfer(from, address(this), feeAmount);
347             
348         }
349         return amount - feeAmount;
350     }
351 
352     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
353         
354         address[] memory path = new address[](2);
355         path[0] = address(this);
356         path[1] = swapRouter.WETH();
357 
358         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
359             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
360         }
361 
362         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
363             contractTokenBalance,
364             0,
365             path,
366             address(this),
367             block.timestamp
368         ) {} catch {
369             return;
370         }
371         bool success;
372 
373         uint256 half = address(this).balance / 2;
374 
375         if(half > 0) {(success,) = marketingAddress.call{value: half, gas: 35000}("");
376                       (success,) = devAddress.call{value: address(this).balance, gas: 35000}("");}
377 
378     }
379 
380         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
381             require(isPresaleAddress[presale] != yesno,"Same bool");
382             isPresaleAddress[presale] = yesno;
383             _noFee[presale] = yesno;
384             liquidityAdd[presale] = yesno;
385             emit _setPresaleAddress(presale, yesno);
386         }
387 
388         function enableTrading(uint256 deadline) external onlyOwner {
389             require(deadline < 6,"Deadline too high");
390             require(!isTradingEnabled, "Trading already enabled");
391             isTradingEnabled = true;
392             _deadline = block.number + deadline;
393             emit _enableTrading();
394         }
395 }