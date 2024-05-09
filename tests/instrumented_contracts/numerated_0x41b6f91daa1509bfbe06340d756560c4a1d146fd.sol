1 /**
2  *Submitted for verification at BscScan.com on 2023-07-01
3 */
4 
5 // SPDX-License-Identifier: No
6 
7 pragma solidity = 0.8.19;
8 
9 //--- Context ---//
10 abstract contract Context {
11     constructor() {
12     }
13 
14     function _msgSender() internal view returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view returns (bytes memory) {
19         this;
20         return msg.data;
21     }
22 }
23 
24 //--- Ownable ---//
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor() {
31         _setOwner(_msgSender());
32     }
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _setOwner(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         _setOwner(newOwner);
50     }
51 
52     function _setOwner(address newOwner) private {
53         address oldOwner = _owner;
54         _owner = newOwner;
55         emit OwnershipTransferred(oldOwner, newOwner);
56     }
57 }
58 
59 interface IFactoryV2 {
60     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
61     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
62     function createPair(address tokenA, address tokenB) external returns (address lpPair);
63 }
64 
65 interface IV2Pair {
66     function factory() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function sync() external;
69 }
70 
71 interface IRouter01 {
72     function factory() external pure returns (address);
73     function WETH() external pure returns (address);
74     function addLiquidityETH(
75         address token,
76         uint amountTokenDesired,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline
81     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
82     function addLiquidity(
83         address tokenA,
84         address tokenB,
85         uint amountADesired,
86         uint amountBDesired,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline
91     ) external returns (uint amountA, uint amountB, uint liquidity);
92     function swapExactETHForTokens(
93         uint amountOutMin, 
94         address[] calldata path, 
95         address to, uint deadline
96     ) external payable returns (uint[] memory amounts);
97     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
98     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
99 }
100 
101 interface IRouter02 is IRouter01 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external payable;
115     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122     function swapExactTokensForTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external returns (uint[] memory amounts);
129 }
130 
131 
132 
133 //--- Interface for ERC20 ---//
134 interface IERC20 {
135     function totalSupply() external view returns (uint256);
136     function decimals() external view returns (uint8);
137     function symbol() external view returns (string memory);
138     function name() external view returns (string memory);
139     function getOwner() external view returns (address);
140     function balanceOf(address account) external view returns (uint256);
141     function transfer(address recipient, uint256 amount) external returns (bool);
142     function allowance(address _owner, address spender) external view returns (uint256);
143     function approve(address spender, uint256 amount) external returns (bool);
144     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
145     event Transfer(address indexed from, address indexed to, uint256 value);
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 //--- Contract v2 ---//
150 contract Babydoge2 is Context, Ownable, IERC20 {
151 
152     function totalSupply() external pure override returns (uint256) { if (_totalSupply == 0) { revert(); } return _totalSupply; }
153     function decimals() external pure override returns (uint8) { if (_totalSupply == 0) { revert(); } return _decimals; }
154     function symbol() external pure override returns (string memory) { return _symbol; }
155     function name() external pure override returns (string memory) { return _name; }
156     function getOwner() external view override returns (address) { return owner(); }
157     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
158     function balanceOf(address account) public view override returns (uint256) {
159         return balance[account];
160     }
161 
162 
163     mapping (address => mapping (address => uint256)) private _allowances;
164     mapping (address => bool) private _noFee;
165     mapping (address => bool) private liquidityAdd;
166     mapping (address => bool) private isLpPair;
167     mapping (address => bool) private isPresaleAddress;
168     mapping (address => uint256) private balance;
169 
170 
171     uint256 constant public _totalSupply = 420_000_000_000_000_000 * 10**9;
172     uint256 constant public swapThreshold = _totalSupply / 5_000;
173     uint256 constant public buyfee = 0;
174     uint256 constant public sellfee = 30;
175     uint256 constant public transferfee = 0;
176     uint256 constant public fee_denominator = 1_000;
177     bool private canSwapFees = false;
178     address payable private marketingAddress = payable(0x4765Dd152Ae878A53a001c61Bd9c421f51664a99);
179     address payable private marketing2Address = payable(0x77FD62C2A1EFBE70c0d1581aa73b32922A9751E1);
180 
181 
182     IRouter02 public swapRouter;
183     string constant private _name = "Babydoge 2.0";
184     string constant private _symbol = "Babydoge2.0";
185     uint8 constant private _decimals = 9;
186     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
187     address public lpPair;
188     bool public isTradingEnabled = false;
189     bool private inSwap;
190 
191         modifier inSwapFlag {
192         inSwap = true;
193         _;
194         inSwap = false;
195     }
196 
197 
198     event _enableTrading();
199     event _setPresaleAddress(address account, bool enabled);
200     event _toggleCanSwapFees(bool enabled);
201     event _changePair(address newLpPair);
202     event _changeWallets(address marketing, address marketing2);
203 
204 
205     constructor () {
206         _noFee[msg.sender] = true;
207 
208         if (block.chainid == 56) {
209             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
210         } else if (block.chainid == 97) {
211             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
212         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
213             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         } else if (block.chainid == 43114) {
215             swapRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
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
229     }
230     
231     receive() external payable {}
232 
233         function transfer(address recipient, uint256 amount) public override returns (bool) {
234         _transfer(msg.sender, recipient, amount);
235         return true;
236     }
237 
238         function approve(address spender, uint256 amount) external override returns (bool) {
239         _approve(msg.sender, spender, amount);
240         return true;
241     }
242 
243         function _approve(address sender, address spender, uint256 amount) internal {
244         require(sender != address(0), "ERC20: Zero Address");
245         require(spender != address(0), "ERC20: Zero Address");
246 
247         _allowances[sender][spender] = amount;
248     }
249 
250         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
251         if (_allowances[sender][msg.sender] != type(uint256).max) {
252             _allowances[sender][msg.sender] -= amount;
253         }
254 
255         return _transfer(sender, recipient, amount);
256     }
257     function isNoFeeWallet(address account) external view returns(bool) {
258         return _noFee[account];
259     }
260 
261     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
262         _noFee[account] = enabled;
263     }
264 
265     function isLimitedAddress(address ins, address out) internal view returns (bool) {
266 
267         bool isLimited = ins != owner()
268             && out != owner() && msg.sender != owner()
269             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
270             return isLimited;
271     }
272 
273     function is_buy(address ins, address out) internal view returns (bool) {
274         bool _is_buy = !isLpPair[out] && isLpPair[ins];
275         return _is_buy;
276     }
277 
278     function is_sell(address ins, address out) internal view returns (bool) { 
279         bool _is_sell = isLpPair[out] && !isLpPair[ins];
280         return _is_sell;
281     } 
282 
283     function canSwap(address ins, address out) internal view returns (bool) {
284         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
285 
286         return canswap;
287     }
288 
289     function changeLpPair(address newPair) external onlyOwner {
290         isLpPair[newPair] = true;
291         emit _changePair(newPair);
292     }
293 
294     function toggleCanSwapFees(bool yesno) external onlyOwner {
295         require(canSwapFees != yesno,"Bool is the same");
296         canSwapFees = yesno;
297         emit _toggleCanSwapFees(yesno);
298     }
299 
300     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
301         bool takeFee = true;
302         require(to != address(0), "ERC20: transfer to the zero address");
303         require(from != address(0), "ERC20: transfer from the zero address");
304         require(amount > 0, "Transfer amount must be greater than zero");
305 
306         if (isLimitedAddress(from,to)) {
307             require(isTradingEnabled,"Trading is not enabled");
308         }
309 
310 
311         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
312             uint256 contractTokenBalance = balanceOf(address(this));
313             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
314         }
315 
316         if (_noFee[from] || _noFee[to]){
317             takeFee = false;
318         }
319 
320         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
321         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
322 
323         return true;
324 
325     }
326 
327     function changeWallets(address marketing, address marketing2) external onlyOwner {
328         marketingAddress = payable(marketing);
329         marketing2Address = payable(marketing2);
330         emit _changeWallets(marketing, marketing2);
331     }
332 
333 
334     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
335         uint256 fee;
336         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
337         if (fee == 0)  return amount;
338         uint256 feeAmount = amount * fee / fee_denominator;
339         if (feeAmount > 0) {
340 
341             balance[address(this)] += feeAmount;
342             emit Transfer(from, address(this), feeAmount);
343             
344         }
345         return amount - feeAmount;
346     }
347 
348     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
349         
350         address[] memory path = new address[](2);
351         path[0] = address(this);
352         path[1] = swapRouter.WETH();
353 
354         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
355             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
356         }
357 
358         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
359             contractTokenBalance,
360             0,
361             path,
362             address(this),
363             block.timestamp
364         ) {} catch {
365             return;
366         }
367         bool success;
368 
369         uint256 twoThird = address(this).balance * 2 / 3;
370 
371         if(twoThird > 0) {(success,) = marketingAddress.call{value: twoThird, gas: 35000}("");}
372         if(address(this).balance > 0) {(success,) = marketing2Address.call{value: address(this).balance, gas: 35000}("");}
373 
374     }
375 
376         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
377             require(isPresaleAddress[presale] != yesno,"Same bool");
378             isPresaleAddress[presale] = yesno;
379             _noFee[presale] = yesno;
380             liquidityAdd[presale] = yesno;
381             emit _setPresaleAddress(presale, yesno);
382         }
383 
384         function enableTrading() external onlyOwner {
385             require(!isTradingEnabled, "Trading already enabled");
386             isTradingEnabled = true;
387             emit _enableTrading();
388         }
389     
390 }