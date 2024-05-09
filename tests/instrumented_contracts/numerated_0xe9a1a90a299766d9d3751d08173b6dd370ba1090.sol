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
146 contract BladesOfGlory is Context, Ownable, IERC20 {
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
167     uint256 constant public _totalSupply = 1_000_000_000_000 * 10**9;
168     uint256 constant public swapThreshold = _totalSupply / 2_500;
169     uint256 constant public buyfee = 20;
170     uint256 constant public sellfee = 20;
171     uint256 constant public transferfee = 0;
172     uint256 constant public fee_denominator = 1_000;
173     uint256 private maxTx = _totalSupply / 100;
174     uint256 private maxWallet = _totalSupply / 100;
175     bool private canSwapFees = false;
176     uint256 constant public botFee = 890;
177     uint256 private _deadline;
178     address payable private marketingAddress = payable(address(0x1439cd62F3bbD4B200aDce8e7331BC20c8B7c0bD)); // build: ?
179     address payable private devAddress = payable(address(0x22fC0FB24D170904c6389c329bC8C8FaEd372519)); // build: ?
180 
181 //--- v3 Allocations by Freddy analytixaudit.com ---//
182     uint256 private buyAllocation = 50;
183     uint256 private sellAllocation = 50;
184     uint256 private liquidityAllocation = 0;
185 
186 
187     IRouter02 public swapRouter;
188     string constant private _name = "Blades Of Glory";
189     string constant private _symbol = "BladesOfGlory";
190     string constant public copyright = "analytixaudit.com";
191     uint8 constant private _decimals = 9;
192     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
193     address public lpPair;
194     bool public isTradingEnabled = false;
195     bool private inSwap;
196     bool private avoidMaxTxLimits = false;
197 
198         modifier inSwapFlag {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203 
204 
205     event _enableTrading();
206     event _setPresaleAddress(address account, bool enabled);
207     event _toggleCanSwapFees(bool enabled);
208     event _changePair(address newLpPair);
209     event _changeThreshold(uint256 newThreshold);
210     event _changeWallets(address newBuy, address newDev);
211     event _changeFees(uint256 buy, uint256 sell);
212     event SwapAndLiquify();
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
224         } else if (block.chainid == 42161) {
225             swapRouter = IRouter02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
226         } else if (block.chainid == 5) {
227             swapRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
228         } else {
229             revert("Chain not valid");
230         }
231         liquidityAdd[msg.sender] = true;
232         balance[msg.sender] = _totalSupply;
233         emit Transfer(address(0), msg.sender, _totalSupply);
234 
235         require(buyAllocation + sellAllocation + liquidityAllocation == 100,"Freddy: Must equals to 100%");
236 
237         lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
238         isLpPair[lpPair] = true;
239         _approve(msg.sender, address(swapRouter), type(uint256).max);
240         _approve(address(this), address(swapRouter), type(uint256).max);
241 
242 
243     }
244 
245     receive() external payable {}
246 
247         function transfer(address recipient, uint256 amount) public override returns (bool) {
248         _transfer(msg.sender, recipient, amount);
249         return true;
250     }
251 
252         function approve(address spender, uint256 amount) external override returns (bool) {
253         _approve(msg.sender, spender, amount);
254         return true;
255     }
256 
257         function _approve(address sender, address spender, uint256 amount) internal {
258         require(sender != address(0), "ERC20: Zero Address");
259         require(spender != address(0), "ERC20: Zero Address");
260 
261         _allowances[sender][spender] = amount;
262     }
263 
264         function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
265         if (_allowances[sender][msg.sender] != type(uint256).max) {
266             _allowances[sender][msg.sender] -= amount;
267         }
268 
269         return _transfer(sender, recipient, amount);
270     }
271     function isNoFeeWallet(address account) external view returns(bool) {
272         return _noFee[account];
273     }
274 
275     function setNoFeeWallet(address account, bool enabled) public onlyOwner {
276         require(account != address(0),"Whoops");
277         _noFee[account] = enabled;
278     }
279 
280     function isLimitedAddress(address ins, address out) internal view returns (bool) {
281 
282         bool isLimited = ins != owner()
283             && out != owner() && tx.origin != owner() // any transaction with no direct interaction from owner will be accepted
284             && msg.sender != owner()
285             && !liquidityAdd[ins]  && !liquidityAdd[out] && out != DEAD && out != address(0) && out != address(this);
286             return isLimited;
287     }
288 
289     function is_buy(address ins, address out) internal view returns (bool) {
290         bool _is_buy = !isLpPair[out] && isLpPair[ins];
291         return _is_buy;
292     }
293 
294     function is_sell(address ins, address out) internal view returns (bool) { 
295         bool _is_sell = isLpPair[out] && !isLpPair[ins];
296         return _is_sell;
297     }
298 
299     function canSwap(address ins, address out) internal view returns (bool) {
300         bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];
301 
302         return canswap;
303     }
304 
305     function changeLpPair(address newPair) external onlyOwner {
306         require(newPair != address(0),"Whoops");
307         isLpPair[newPair] = true;
308         emit _changePair(newPair);
309     }
310 
311     function toggleCanSwapFees(bool yesno) external onlyOwner {
312         require(canSwapFees != yesno,"Bool is the same");
313         canSwapFees = yesno;
314         emit _toggleCanSwapFees(yesno);
315     }
316 
317     function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
318         bool takeFee = true;
319         require(to != address(0), "ERC20: transfer to the zero address");
320         require(from != address(0), "ERC20: transfer from the zero address");
321         require(amount > 0, "Transfer amount must be greater than zero");
322 
323         if (isLimitedAddress(from,to)) {
324             require(isTradingEnabled,"Trading is not enabled");
325             if(!avoidMaxTxLimits) {require(amount <= maxTx,"maxTx is 1%");
326             if(!isLpPair[to] && from != address(this) && to != address(this))  {require(balanceOf(to) + amount <= maxWallet,"maxWallet is 1%");}}
327         }
328 
329         bool launchtax = isLimitedAddress(from,to) && isTradingEnabled && block.number <= _deadline;
330 
331         if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
332             uint256 contractTokenBalance = balanceOf(address(this));
333             if(contractTokenBalance >= swapThreshold) { 
334                 if(buyAllocation > 0 || sellAllocation > 0) internalSwap((contractTokenBalance * (buyAllocation + sellAllocation)) / 100);
335                 if(liquidityAllocation > 0) {swapAndLiquify(contractTokenBalance * liquidityAllocation / 100);}
336              }
337         }
338 
339         if (_noFee[from] || _noFee[to]){
340             takeFee = false;
341         }
342         balance[from] -= amount; uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount, launchtax) : amount;
343         balance[to] += amountAfterFee; emit Transfer(from, to, amountAfterFee);
344 
345         return true;
346 
347     }
348 
349     function changeWallets(address newDev, address newBuy) external onlyOwner {
350         require(newBuy != address(0),"Freddy: Address Zero");
351         marketingAddress = payable(newBuy);
352         devAddress = payable(newDev);
353         emit _changeWallets(newBuy, newDev);
354     }
355 
356     function takeTaxes(address from, bool isbuy, bool issell, uint256 amount, bool _launchtax) internal returns (uint256) {
357         uint256 fee;
358         if (isbuy)  fee = buyfee;  else if (issell)  fee = sellfee;  else  fee = transferfee; 
359         if(_launchtax) fee =  botFee;
360         if (fee == 0)  return amount;
361         uint256 feeAmount = amount * fee / fee_denominator;
362         if (feeAmount > 0) {
363 
364             balance[address(this)] += feeAmount;
365             emit Transfer(from, address(this), feeAmount);
366             
367         }
368         return amount - feeAmount;
369     }
370 
371     function swapAndLiquify(uint256 contractTokenBalance) internal inSwapFlag {
372         uint256 firstmath = contractTokenBalance / 2;
373         uint256 secondMath = contractTokenBalance - firstmath;
374 
375         uint256 initialBalance = address(this).balance;
376 
377         address[] memory path = new address[](2);
378         path[0] = address(this);
379         path[1] = swapRouter.WETH();
380 
381         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
382             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
383         }
384 
385         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
386             firstmath,
387             0, 
388             path,
389             address(this),
390             block.timestamp) {} catch {return;}
391         
392         uint256 newBalance = address(this).balance - initialBalance;
393 
394         try swapRouter.addLiquidityETH{value: newBalance}(
395             address(this),
396             secondMath,
397             0,
398             0,
399             DEAD,
400             block.timestamp
401         ){} catch {return;}
402 
403         emit SwapAndLiquify();
404     }
405 
406     function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
407         
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = swapRouter.WETH();
411 
412         if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
413             _allowances[address(this)][address(swapRouter)] = type(uint256).max;
414         }
415 
416         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             contractTokenBalance,
418             0,
419             path,
420             address(this),
421             block.timestamp
422         ) {} catch {
423             return;
424         }
425         bool success;
426 
427         uint256 half = address(this).balance / 2;
428         if(half > 0) (success,) = marketingAddress.call{value: half, gas: 35000}("");
429         if(address(this).balance > 0) (success,) = devAddress.call{value: address(this).balance, gas: 35000}("");
430         
431 
432     } 
433 
434         function setPresaleAddress(address presale, bool yesno) external onlyOwner {
435             require(isPresaleAddress[presale] != yesno,"Same bool");
436             isPresaleAddress[presale] = yesno;
437             _noFee[presale] = yesno;
438             liquidityAdd[presale] = yesno;
439             emit _setPresaleAddress(presale, yesno);
440         }
441 
442         function enableTrading(uint256 deadline) external onlyOwner {
443             require(deadline < 25,"Deadline too high");
444             require(!isTradingEnabled, "Trading already enabled");
445             isTradingEnabled = true;
446             _deadline = block.number + deadline;
447             emit _enableTrading();
448         }
449 
450         function zeroLimits() external onlyOwner {
451             require(!avoidMaxTxLimits,"Already initalized");
452             maxTx = _totalSupply;
453             maxWallet = _totalSupply;
454             avoidMaxTxLimits = true;
455         }
456 
457         function bulkPresaleAddresses(address[] memory accounts, bool state) external onlyOwner {
458         for (uint256 i = 0; i < accounts.length; i++) {
459             isPresaleAddress[accounts[i]] = state;
460             _noFee[accounts[i]] = state;
461             liquidityAdd[accounts[i]] = state;
462         }
463     }
464 
465         function returnLimits() external view returns(uint256 _maxTx, uint256 _maxWallet) {
466             return(maxTx, maxWallet);
467         }
468 }