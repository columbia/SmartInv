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
145 //--- Contract v3 ---//
146 contract Blaze is Context, Ownable, IERC20 {
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
167     uint256 private swapThreshold = _totalSupply / 20_000;
168     uint256 constant public _totalSupply = 1_000_000_000_000 * 10**18;
169     uint256 public buyfee = 100;
170     uint256 public sellfee = 120;
171     uint256 constant public transferfee = 0;
172     uint256 constant public fee_denominator = 1_000;
173     bool private canSwapFees = true;
174     address payable private buyMarketingAddress = payable(0x9a99eb0E6aa4d2822CDd1Aa6db5A4D8276c094D8); // build: 0x9a99eb0E6aa4d2822CDd1Aa6db5A4D8276c094D8
175     address payable private sellMarketingAddress = payable(0x72CCCcc4C3E51FC4520B6108C5d277DD9bbDD1F3); // build: 0x72CCCcc4C3E51FC4520B6108C5d277DD9bbDD1F3
176 
177 
178 //--- v3 Allocations by Freddy analytixaudit.com ---//
179     uint256 private buyAllocation = 37;
180     uint256 private sellAllocation = 45;
181     uint256 private liquidityAllocation = 18;
182 
183 
184     IRouter02 public swapRouter;
185     string constant private _name = "Blaze";
186     string constant private _symbol = "BLZE";
187     string constant public copyright = "analytixaudit.com";
188     uint8 constant private _decimals = 18;
189     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
190     address public lpPair;
191     bool public isTradingEnabled = false;
192     bool private inSwap;
193 
194         modifier inSwapFlag {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200 
201     event _enableTrading();
202     event _setPresaleAddress(address account, bool enabled);
203     event _toggleCanSwapFees(bool enabled);
204     event _changePair(address newLpPair);
205     event _changeThreshold(uint256 newThreshold);
206     event _changeWallets(address newBuy, address newSell);
207     event _changeFees(uint256 buy, uint256 sell);
208     event SwapAndLiquify();
209 
210 
211     constructor () {
212         _noFee[msg.sender] = true;
213 
214         if (block.chainid == 56) {
215             swapRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
216         } else if (block.chainid == 97) {
217             swapRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
218         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
219             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
220         } else if (block.chainid == 42161) {
221             swapRouter = IRouter02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
222         } else if (block.chainid == 5) {
223             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
224         } else {
225             revert("Chain not valid");
226         }
227         liquidityAdd[msg.sender] = true;
228         balance[msg.sender] = _totalSupply;
229         emit Transfer(address(0), msg.sender, _totalSupply);
230 
231         require(buyAllocation + sellAllocation + liquidityAllocation == 100,"Freddy: Must equals to 100%");
232 
233         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
234         isLpPair[lpPair] = true;
235         _approve(msg.sender, address(swapRouter), type(uint256).max);
236         _approve(address(this), address(swapRouter), type(uint256).max);
237 
238 
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
278             && out != owner() && tx.origin != owner() // any transaction with no direct interaction from owner will be accepted
279             && msg.sender != owner()
280             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
281             return isLimited;
282     }
283 
284     function is_buy(address ins, address out) internal view returns (bool) {
285         bool _is_buy = !isLpPair[out] && isLpPair[ins];
286         return _is_buy;
287     }
288 
289     function is_sell(address ins, address out) internal view returns (bool) { 
290         bool _is_sell = isLpPair[out] && !isLpPair[ins];
291         return _is_sell;
292     }
293 
294     function is_transfer(address ins, address out) internal view returns (bool) { 
295         bool _is_transfer = !isLpPair[out] && !isLpPair[ins];
296         return _is_transfer;
297     }
298 
299     function canSwap(address ins, address out) internal view returns (bool) {
300         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
301 
302         return canswap;
303     }
304 
305     function changeLpPair(address newPair) external onlyOwner {
306         isLpPair[newPair] = true;
307         emit _changePair(newPair);
308     }
309 
310     function toggleCanSwapFees(bool yesno) external onlyOwner {
311         require(canSwapFees != yesno,"Bool is the same");
312         canSwapFees = yesno;
313         emit _toggleCanSwapFees(yesno);
314     }
315 
316     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
317         bool takeFee = true;
318         require(to != address(0), "ERC20: transfer to the zero address");
319         require(from != address(0), "ERC20: transfer from the zero address");
320         require(amount > 0, "Transfer amount must be greater than zero");
321 
322         if (isLimitedAddress(from,to)) {
323             require(isTradingEnabled,"Trading is not enabled");
324         }
325 
326 
327         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
328             uint256 contractTokenBalance = balanceOf(address(this));
329             if(contractTokenBalance >= swapThreshold) { 
330                 if(buyAllocation > 0 || sellAllocation > 0) internalSwap((contractTokenBalance * (buyAllocation + sellAllocation)) / 100);
331                 if(liquidityAllocation > 0) {swapAndLiquify(contractTokenBalance * liquidityAllocation / 100);}
332              }
333         }
334 
335         if (_noFee[from] || _noFee[to]){
336             takeFee = false;
337         }
338         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
339         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
340 
341         return true;
342 
343     }
344 
345     function changeWallets(address newBuy, address newSell) external onlyOwner {
346         require(newBuy != address(0),"Freddy: Address Zero");
347         require(newSell != address(0),"Freddy: Address Zero");
348         buyMarketingAddress = payable(newBuy);
349         sellMarketingAddress = payable(newSell);
350         emit _changeWallets(newBuy, newSell);
351     }
352 
353 
354     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
355         uint256 fee;
356         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
357         if (fee == 0)  return amount; 
358         uint256 feeAmount = amount * fee / fee_denominator;
359         if (feeAmount > 0) {
360 
361             balance[address(this)] += feeAmount;
362             emit Transfer(from, address(this), feeAmount);
363             
364         }
365         return amount - feeAmount;
366     }
367 
368     function swapAndLiquify(uint256 contractTokenBalance) internal inSwapFlag {
369         uint256 firstmath = contractTokenBalance / 2;
370         uint256 secondMath = contractTokenBalance - firstmath;
371 
372         uint256 initialBalance = address(this).balance;
373 
374         address[] memory path = new address[](2);
375         path[0] = address(this);
376         path[1] = swapRouter.WETH();
377 
378         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
379             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
380         }
381 
382         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
383             firstmath,
384             0, 
385             path,
386             address(this),
387             block.timestamp) {} catch {return;}
388         
389         uint256 newBalance = address(this).balance - initialBalance;
390 
391         try swapRouter.addLiquidityETH{value: newBalance}(
392             address(this),
393             secondMath,
394             0,
395             0,
396             DEAD,
397             block.timestamp
398         ){} catch {return;}
399 
400         emit SwapAndLiquify();
401     }
402 
403     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
404         
405         address[] memory path = new address[](2);
406         path[0] = address(this);
407         path[1] = swapRouter.WETH();
408 
409         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
410             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
411         }
412 
413         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
414             contractTokenBalance,
415             0,
416             path,
417             address(this),
418             block.timestamp
419         ) {} catch {
420             return;
421         }
422         bool success;
423 
424         uint256 amount1 = address(this).balance * 45 / 100;
425         uint256 amount2 = address(this).balance * 55 / 100;
426 
427         if(amount1 > 0) (success,) = buyMarketingAddress.call{value: amount1, gas: 35000}("");
428         if(amount2 > 0) (success,) = sellMarketingAddress.call{value: amount2, gas: 35000}("");
429     }
430 
431         function changeFees(uint256 buy, uint256 sell) external onlyOwner {
432             require(buy <= 10,"Freddy: Fees Error");
433             require(sell <= 12,"Freddy: Fees Error");
434 
435             buyfee = buy * 10;
436             sellfee = sell * 10;
437             emit _changeFees(buyfee, sellfee);
438         }
439 
440         function changeAllocations(uint256 allBuy, uint256 allSell, uint256 allLiq) external onlyOwner {
441             buyAllocation = allBuy;
442             sellAllocation = allSell;
443             liquidityAllocation = allLiq;
444 
445             require(buyAllocation + sellAllocation + liquidityAllocation == 100,"Freddy: Must equals to 100%");
446         }
447 
448         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
449             require(isPresaleAddress[presale] != yesno,"Same bool");
450             isPresaleAddress[presale] = yesno;
451             _noFee[presale] = yesno;
452             liquidityAdd[presale] = yesno;
453             emit _setPresaleAddress(presale, yesno);
454         }
455 
456         function enableTrading() external onlyOwner {
457             require(!isTradingEnabled, "Trading already enabled");
458             isTradingEnabled = true;
459             emit _enableTrading();
460         }
461 }