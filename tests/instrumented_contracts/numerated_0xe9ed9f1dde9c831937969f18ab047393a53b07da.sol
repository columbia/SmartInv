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
146 contract ONLINE is Context, Ownable, IERC20 {
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
167     uint256 constant public _totalSupply = 1_000_000 * 10**18;
168     uint256 constant public  swapThreshold = _totalSupply / 7_000;
169     uint256 constant public buyfee = 0;
170     uint256 constant public sellfee = 0;
171     uint256 constant public transferfee = 0;
172     uint256 constant public fee_denominator = 1_000;
173     bool private canSwapFees = true;
174     address payable private marketingAddress = payable(0xd905a41Ed6423D05AB7ec98b2da84642c94C6FBe);
175 
176 
177     IRouter02 public swapRouter;
178     string constant private _name = "Onlinebase";
179     string constant private _symbol = "ONLINE";
180     uint8 constant private _decimals = 18;
181     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
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
194     event _setPresaleAddress(address account, bool enabled);
195     event _toggleCanSwapFees(bool enabled);
196     event _changePair(address newLpPair);
197     event _changeThreshold(uint256 newThreshold);
198     event _changeWallets(address marketing);
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
225 
226 
227     }
228 
229     receive() external payable {}
230 
231         function transfer(address recipient, uint256 amount) public override returns (bool) {
232         _transfer(msg.sender, recipient, amount);
233         return true;
234     }
235 
236         function approve(address spender, uint256 amount) external override returns (bool) {
237         _approve(msg.sender, spender, amount);
238         return true;
239     }
240 
241         function _approve(address sender, address spender, uint256 amount) internal {
242         require(sender != address(0), "ERC20: Zero Address");
243         require(spender != address(0), "ERC20: Zero Address");
244 
245         _allowances[sender][spender] = amount;
246     }
247 
248         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
249         if (_allowances[sender][msg.sender] != type(uint256).max) {
250             _allowances[sender][msg.sender] -= amount;
251         }
252 
253         return _transfer(sender, recipient, amount);
254     }
255     function isNoFeeWallet(address account) external view returns(bool) {
256         return _noFee[account];
257     }
258 
259     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
260         _noFee[account] = enabled;
261     }
262 
263     function isLimitedAddress(address ins, address out) internal view returns (bool) {
264 
265         bool isLimited = ins != owner()
266             && out != owner() && msg.sender != owner()
267             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
268             return isLimited;
269     }
270 
271     function is_buy(address ins, address out) internal view returns (bool) {
272         bool _is_buy = !isLpPair[out] && isLpPair[ins];
273         return _is_buy;
274     }
275 
276     function is_sell(address ins, address out) internal view returns (bool) { 
277         bool _is_sell = isLpPair[out] && !isLpPair[ins];
278         return _is_sell;
279     }
280 
281     function is_transfer(address ins, address out) internal view returns (bool) { 
282         bool _is_transfer = !isLpPair[out] && !isLpPair[ins];
283         return _is_transfer;
284     }
285 
286     function canSwap(address ins, address out) internal view returns (bool) {
287         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
288 
289         return canswap;
290     }
291 
292     function changeLpPair(address newPair) external onlyOwner {
293         isLpPair[newPair] = true;
294         emit _changePair(newPair);
295     }
296 
297     function toggleCanSwapFees(bool yesno) external onlyOwner {
298         require(canSwapFees != yesno,"Bool is the same");
299         canSwapFees = yesno;
300         emit _toggleCanSwapFees(yesno);
301     }
302 
303     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
304         bool takeFee = true;
305         require(to != address(0), "ERC20: transfer to the zero address");
306         require(from != address(0), "ERC20: transfer from the zero address");
307         require(amount > 0, "Transfer amount must be greater than zero");
308 
309         if (isLimitedAddress(from,to)) {
310             require(isTradingEnabled,"Trading is not enabled");
311         }
312 
313 
314         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
315             uint256 contractTokenBalance = balanceOf(address(this));
316             if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
317         }
318 
319         if (_noFee[from] || _noFee[to]){
320             takeFee = false;
321         }
322         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
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
335     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
336         uint256 fee;
337         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
338         if (fee == 0)  return amount; 
339         uint256 feeAmount = amount * fee / fee_denominator;
340         if (feeAmount > 0) {
341 
342             balance[address(this)] += feeAmount;
343             emit Transfer(from, address(this), feeAmount);
344             
345         }
346         return amount - feeAmount;
347     }
348 
349     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
350         
351         address[] memory path = new address[](2);
352         path[0] = address(this);
353         path[1] = swapRouter.WETH();
354 
355         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
356             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
357         }
358 
359         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
360             contractTokenBalance,
361             0,
362             path,
363             address(this),
364             block.timestamp
365         ) {} catch {
366             return;
367         }
368         bool success;
369 
370         if(address(this).balance > 0) {(success,) = marketingAddress.call{value: address(this).balance, gas: 35000}("");}
371 
372     }
373 
374         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
375             require(isPresaleAddress[presale] != yesno,"Same bool");
376             isPresaleAddress[presale] = yesno;
377             _noFee[presale] = yesno;
378             liquidityAdd[presale] = yesno;
379             emit _setPresaleAddress(presale, yesno);
380         }
381 
382         function enableTrading() external onlyOwner {
383             require(!isTradingEnabled, "Trading already enabled");
384             isTradingEnabled = true;
385             emit _enableTrading();
386         }
387 }