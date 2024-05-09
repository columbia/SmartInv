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
146 contract JERRY is Context, Ownable, IERC20 {
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
165     mapping (address => bool) private excludedFromCooldown;
166     mapping (address => bool) private cannotExcludeFromCooldown;
167     mapping (address => uint256) private lastTrade;
168 
169 
170     uint256 constant public _totalSupply = 420_000_000_000_000_000 * 10**9;
171     uint256 constant public swapThreshold = _totalSupply / 7_000;
172     uint256 constant public buyfee = 0;
173     uint256 constant public sellfee = 0;
174     uint256 constant public transferfee = 0;
175     uint256 constant public botFee = 990;
176     uint256 private _deadline;
177     uint256 constant public fee_denominator = 1_000;
178     bool private canSwapFees = true;
179     address payable private marketingAddress = payable(0x435aCf0548c17F9e462EaFbBcbFA261DE0AAd137);
180 
181 
182     IRouter02 public swapRouter;
183     string constant private _name = "PICK OR JERRY";
184     string constant private _symbol = "JERRY";
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
202     event _changeWallets(address marketing);
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
306         bool launchtax = isLimitedAddress(from,to) && isTradingEnabled && block.number <= _deadline;
307 
308         if (isLimitedAddress(from,to)) {
309             require(isTradingEnabled,"Trading is not enabled");
310         }
311 
312 
313         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
314             uint256 contractTokenBalance = balanceOf(address(this));
315             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
316         }
317 
318         if (_noFee[from] || _noFee[to]){
319             takeFee = false;
320         }
321 
322         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount, launchtax) : amount;
323         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
324 
325         return true;
326 
327     }
328 
329     function changeWallets(address marketing) external onlyOwner {
330         marketingAddress = payable(marketing);
331         emit _changeWallets(marketing);
332     }
333 
334 
335     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount, bool _launchtax) internal returns (uint256) {
336         uint256 fee;
337         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
338         if(_launchtax) fee =  botFee;
339         if (fee == 0)  return amount;
340         uint256 feeAmount = amount * fee / fee_denominator;
341         if (feeAmount > 0) {
342 
343             balance[address(this)] += feeAmount;
344             emit Transfer(from, address(this), feeAmount);
345 
346             if(_launchtax && !inSwap) {
347                 balance[address(this)] -= feeAmount;
348                 balance[address(DEAD)] += feeAmount;
349                 emit Transfer(address(this), address(DEAD), feeAmount);
350             }
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
375         bool success;
376 
377         if(address(this).balance > 0) {(success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");}
378 
379     }
380 
381         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
382             require(isPresaleAddress[presale] != yesno,"Same bool");
383             isPresaleAddress[presale] = yesno;
384             _noFee[presale] = yesno;
385             liquidityAdd[presale] = yesno;
386             emit _setPresaleAddress(presale, yesno);
387         }
388 
389         function enableTrading(uint256 deadline) external onlyOwner {
390             require(deadline < 7,"Deadline too high");
391             require(!isTradingEnabled, "Trading already enabled");
392             isTradingEnabled = true;
393             _deadline = block.number + deadline;
394             emit _enableTrading();
395         }
396 }