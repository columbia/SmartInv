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
146 contract BLUBLU is Context, Ownable, IERC20 {
147 
148     function totalSupply() external view override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply - balanceOf(address(DEAD)); }
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
167     uint256 constant public _totalSupply = 420_000_000_000 * 10**9;
168     uint256 constant public swapThreshold = _totalSupply / 7_000;
169     uint256 constant public buyfee = 0;
170     uint256 constant public sellfee = 0;
171     uint256 constant public transferfee = 0;
172     uint256 constant public botFee = 990;
173     uint256 private _deadline;
174     uint256 constant public fee_denominator = 1_000;
175     bool private canSwapFees = true;
176     address payable private marketingAddress = payable(0x3247eA78B378aF3Cf29D1D50d7b7384CC02A2474);
177 
178 
179     IRouter02 public swapRouter;
180     string constant private _name = "BLUBLU 2.0";
181     string constant private _symbol = "BLUBLU";
182     uint8 constant private _decimals = 9;
183     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
184     address public lpPair;
185     bool public isTradingEnabled = false;
186     bool private inSwap;
187 
188         modifier inSwapFlag {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193 
194 
195     event _enableTrading();
196     event _setPresaleAddress(address account, bool enabled);
197     event _toggleCanSwapFees(bool enabled);
198     event _changePair(address newLpPair);
199     event _changeWallets(address marketing);
200 
201 
202     constructor () {
203         _noFee[msg.sender] = true;
204 
205         if (block.chainid == 56) {
206             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
207         } else if (block.chainid == 97) {
208             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
209         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
210             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
211         } else if (block.chainid == 43114) {
212             swapRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
213         } else if (block.chainid == 250) {
214             swapRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
215         } else {
216             revert("Chain not valid");
217         }
218         liquidityAdd[msg.sender] = true;
219         balance[msg.sender] = _totalSupply;
220         emit Transfer(address(0), msg.sender, _totalSupply);
221 
222         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
223         isLpPair[lpPair] = true;
224         _approve(msg.sender, address(swapRouter), type(uint256).max);
225         _approve(address(this), address(swapRouter), type(uint256).max);
226     }
227     
228     receive() external payable {}
229 
230         function transfer(address recipient, uint256 amount) public override returns (bool) {
231         _transfer(msg.sender, recipient, amount);
232         return true;
233     }
234 
235         function approve(address spender, uint256 amount) external override returns (bool) {
236         _approve(msg.sender, spender, amount);
237         return true;
238     }
239 
240         function _approve(address sender, address spender, uint256 amount) internal {
241         require(sender != address(0), "ERC20: Zero Address");
242         require(spender != address(0), "ERC20: Zero Address");
243 
244         _allowances[sender][spender] = amount;
245     }
246 
247         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
248         if (_allowances[sender][msg.sender] != type(uint256).max) {
249             _allowances[sender][msg.sender] -= amount;
250         }
251 
252         return _transfer(sender, recipient, amount);
253     }
254     function isNoFeeWallet(address account) external view returns(bool) {
255         return _noFee[account];
256     }
257 
258     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
259         _noFee[account] = enabled;
260     }
261 
262     function isLimitedAddress(address ins, address out) internal view returns (bool) {
263 
264         bool isLimited = ins != owner()
265             && out != owner() && msg.sender != owner()
266             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
267             return isLimited;
268     }
269 
270     function is_buy(address ins, address out) internal view returns (bool) {
271         bool _is_buy = !isLpPair[out] && isLpPair[ins];
272         return _is_buy;
273     }
274 
275     function is_sell(address ins, address out) internal view returns (bool) { 
276         bool _is_sell = isLpPair[out] && !isLpPair[ins];
277         return _is_sell;
278     } 
279 
280     function canSwap(address ins, address out) internal view returns (bool) {
281         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
282 
283         return canswap;
284     }
285 
286     function changeLpPair(address newPair) external onlyOwner {
287         isLpPair[newPair] = true;
288         emit _changePair(newPair);
289     }
290 
291     function toggleCanSwapFees(bool yesno) external onlyOwner {
292         require(canSwapFees != yesno,"Bool is the same");
293         canSwapFees = yesno;
294         emit _toggleCanSwapFees(yesno);
295     }
296 
297     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
298         bool takeFee = true;
299         require(to != address(0), "ERC20: transfer to the zero address");
300         require(from != address(0), "ERC20: transfer from the zero address");
301         require(amount > 0, "Transfer amount must be greater than zero");
302 
303         bool launchtax = isLimitedAddress(from,to) && isTradingEnabled && block.number <= _deadline;
304 
305         if (isLimitedAddress(from,to)) {
306             require(isTradingEnabled,"Trading is not enabled");
307         }
308 
309 
310         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
311             uint256 contractTokenBalance = balanceOf(address(this));
312             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
313         }
314 
315         if (_noFee[from] || _noFee[to]){
316             takeFee = false;
317         }
318 
319         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount, launchtax) : amount;
320         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
321 
322         return true;
323 
324     }
325 
326     function changeWallets(address marketing) external onlyOwner {
327         marketingAddress = payable(marketing);
328         emit _changeWallets(marketing);
329     }
330 
331 
332     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount, bool _launchtax) internal returns (uint256) {
333         uint256 fee;
334         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
335         if(_launchtax) fee =  botFee;
336         if (fee == 0)  return amount;
337         uint256 feeAmount = amount * fee / fee_denominator;
338         if (feeAmount > 0) {
339 
340             balance[address(this)] += feeAmount;
341             emit Transfer(from, address(this), feeAmount);
342 
343             if(_launchtax && !inSwap) {
344                 balance[address(this)] -= feeAmount;
345                 balance[address(DEAD)] += feeAmount;
346                 emit Transfer(address(this), address(DEAD), feeAmount);
347             }
348             
349         }
350         return amount - feeAmount;
351     }
352 
353     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
354         
355         address[] memory path = new address[](2);
356         path[0] = address(this);
357         path[1] = swapRouter.WETH();
358 
359         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
360             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
361         }
362 
363         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
364             contractTokenBalance,
365             0,
366             path,
367             address(this),
368             block.timestamp
369         ) {} catch {
370             return;
371         }
372         bool success;
373 
374         if(address(this).balance > 0) {(success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");}
375 
376     }
377 
378         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
379             require(isPresaleAddress[presale] != yesno,"Same bool");
380             isPresaleAddress[presale] = yesno;
381             _noFee[presale] = yesno;
382             liquidityAdd[presale] = yesno;
383             emit _setPresaleAddress(presale, yesno);
384         }
385 
386         function enableTrading(uint256 deadline) external onlyOwner {
387             require(deadline < 16,"Deadline too high");
388             require(!isTradingEnabled, "Trading already enabled");
389             deadline = deadline + 10;
390             isTradingEnabled = true;
391             _deadline = block.number + deadline;
392             emit _enableTrading();
393         }
394 }