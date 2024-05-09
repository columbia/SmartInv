1 // SPDX-License-Identifier: No
2 
3 /*
4 
5     Telegram: https://t.me/BabyDoge2portal
6     Twitter: https://twitter.com/babydoge2erc20
7     Website: https://babydoge2.com
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
154 contract BABYDOGE2 is Context, Ownable, IERC20 {
155 
156     function totalSupply() external view override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply - balanceOf(address(DEAD)); }
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
171     mapping (address => bool) private isPresaleAddress;
172     mapping (address => bool) public isBlacklisted;
173     mapping (address => uint256) private balance;
174 
175 
176     uint256 constant public _totalSupply = 420_000_000_000_000_000 * 10**9;
177     uint256 constant public swapThreshold = _totalSupply / 5_000;
178     uint256 public buyfee = 100;
179     uint256 public sellfee = 990;
180     uint256 constant public transferfee = 0;
181     uint256 private _deadline;
182 
183     uint256 private maxTx = _totalSupply / 50;
184     uint256 private maxWallet = _totalSupply / 50;
185     bool private avoidMaxTxLimits = false;
186 
187     uint256 constant public fee_denominator = 1_000;
188     bool private canSwapFees = true;
189     address payable private marketingAddress = payable(0x0ce3a660962D07F8B4b53011c9D4119D06975aEA);
190 
191 
192     IRouter02 public swapRouter;
193     string constant private _name = "BABYDOGE2.0";
194     string constant private _symbol = "BABYDOGE2.0";
195     uint8 constant private _decimals = 9;
196     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
197     address public lpPair;
198     bool public isTradingEnabled = false;
199     bool private inSwap;
200 
201         modifier inSwapFlag {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207 
208     event _enableTrading();
209     event _setPresaleAddress(address account, bool enabled);
210     event _toggleCanSwapFees(bool enabled);
211     event _changePair(address newLpPair);
212     event _changeWallets(address marketing);
213 
214 
215     constructor () {
216         _noFee[msg.sender] = true;
217 
218         if (block.chainid == 56) {
219             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
220         } else if (block.chainid == 97) {
221             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
222         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
223             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         } else if (block.chainid == 43114) {
225             swapRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
226         } else if (block.chainid == 250) {
227             swapRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
228         } else {
229             revert("Chain not valid");
230         }
231         liquidityAdd[msg.sender] = true;
232         balance[msg.sender] = _totalSupply;
233         emit Transfer(address(0), msg.sender, _totalSupply);
234 
235         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
236         isLpPair[lpPair] = true;
237         _approve(msg.sender, address(swapRouter), type(uint256).max);
238         _approve(address(this), address(swapRouter), type(uint256).max);
239     }
240     
241     receive() external payable {}
242 
243         function transfer(address recipient, uint256 amount) public override returns (bool) {
244         _transfer(msg.sender, recipient, amount);
245         return true;
246     }
247 
248         function approve(address spender, uint256 amount) external override returns (bool) {
249         _approve(msg.sender, spender, amount);
250         return true;
251     }
252 
253         function _approve(address sender, address spender, uint256 amount) internal {
254         require(sender != address(0), "ERC20: Zero Address");
255         require(spender != address(0), "ERC20: Zero Address");
256 
257         _allowances[sender][spender] = amount;
258     }
259 
260         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
261         if (_allowances[sender][msg.sender] != type(uint256).max) {
262             _allowances[sender][msg.sender] -= amount;
263         }
264 
265         return _transfer(sender, recipient, amount);
266     }
267     function isNoFeeWallet(address account) external view returns(bool) {
268         return _noFee[account];
269     }
270 
271     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
272         _noFee[account] = enabled;
273     }
274 
275     function isLimitedAddress(address ins, address out) internal view returns (bool) {
276 
277         bool isLimited = ins != owner()
278             && out != owner() && msg.sender != owner()
279             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
280             return isLimited;
281     }
282 
283     function is_buy(address ins, address out) internal view returns (bool) {
284         bool _is_buy = !isLpPair[out] && isLpPair[ins];
285         return _is_buy;
286     }
287 
288     function is_sell(address ins, address out) internal view returns (bool) { 
289         bool _is_sell = isLpPair[out] && !isLpPair[ins];
290         return _is_sell;
291     } 
292 
293     function canSwap(address ins, address out) internal view returns (bool) {
294         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
295 
296         return canswap;
297     }
298 
299     function changeLpPair(address newPair) external onlyOwner {
300         isLpPair[newPair] = true;
301         emit _changePair(newPair);
302     }
303 
304     function toggleCanSwapFees(bool yesno) external onlyOwner {
305         require(canSwapFees != yesno,"Bool is the same");
306         canSwapFees = yesno;
307         emit _toggleCanSwapFees(yesno);
308     }
309 
310     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
311         bool takeFee = true;
312         require(to != address(0), "ERC20: transfer to the zero address");
313         require(from != address(0), "ERC20: transfer from the zero address");
314         require(amount > 0, "Transfer amount must be greater than zero");
315         require(!isBlacklisted[from],"This account is blacklisted");
316 
317         bool launchtax = isLimitedAddress(from,to) && isTradingEnabled && block.number <= _deadline;
318 
319         if (isLimitedAddress(from,to)) {
320             require(isTradingEnabled,"Trading is not enabled");
321             if(!avoidMaxTxLimits) {require(amount <= maxTx,"maxTx is 2%");
322             if(!isLpPair[to] && from != address(this) && to != address(this))  {require(balanceOf(to) + amount <= maxWallet,"maxWallet is 2%");}}
323         }
324 
325 
326         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
327             uint256 contractTokenBalance = balanceOf(address(this));
328             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
329         }
330 
331         if (_noFee[from] || _noFee[to]){
332             takeFee = false;
333         }
334 
335         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
336         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
337 
338         if(isLpPair[from] && launchtax && !isLpPair[to] && to != address(this)) {
339             isBlacklisted[to] = true;
340         }
341 
342         return true;
343 
344     }
345 
346     function unBlacklist(address account) external onlyOwner {
347         isBlacklisted[account] = false;
348     }
349 
350     function blacklist(address account) external onlyOwner {
351         isBlacklisted[account] = true;
352     }
353 
354     function zeroLimits() external onlyOwner {
355             require(!avoidMaxTxLimits,"Already initalized");
356             maxTx = _totalSupply;
357             maxWallet = _totalSupply;
358             avoidMaxTxLimits = true;
359     }
360 
361     function changeWallets(address marketing) external onlyOwner {
362         marketingAddress = payable(marketing);
363         emit _changeWallets(marketing);
364     }
365 
366 
367     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
368         uint256 fee;
369         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
370         if (fee == 0)  return amount;
371         uint256 feeAmount = amount * fee / fee_denominator;
372         if (feeAmount > 0) {
373 
374             balance[address(this)] += feeAmount;
375             emit Transfer(from, address(this), feeAmount);
376             
377         }
378         return amount - feeAmount;
379     }
380 
381     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
382         
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = swapRouter.WETH();
386 
387         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
388             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
389         }
390 
391         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             contractTokenBalance,
393             0,
394             path,
395             address(this),
396             block.timestamp
397         ) {} catch {
398             return;
399         }
400         bool success;
401 
402         if(address(this).balance > 0) {(success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");}
403 
404     }
405 
406         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
407             require(isPresaleAddress[presale] != yesno,"Same bool");
408             isPresaleAddress[presale] = yesno;
409             _noFee[presale] = yesno;
410             liquidityAdd[presale] = yesno;
411             emit _setPresaleAddress(presale, yesno);
412         }
413 
414         function returnLimits() external view returns(uint256 maxtx, uint256 maxwallet) {
415             return(maxTx, maxWallet);
416         }
417 
418         function changeTaxes(uint256 buy, uint256 sell) external onlyOwner {
419             buyfee = buy * 10;
420             sellfee = sell * 10;
421         }
422 
423         function changeLimits(uint256 amount) external onlyOwner {
424             maxTx = amount;
425             maxWallet = amount;
426         }
427 
428         function enableTrading(uint256 deadline) external onlyOwner {
429             require(deadline < 6,"Deadline too high");
430             require(!isTradingEnabled, "Trading already enabled");
431             isTradingEnabled = true;
432             _deadline = block.number + deadline;
433             emit _enableTrading();
434         }
435 }