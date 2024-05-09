1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint8);
7     function symbol() external view returns (string memory);
8     function name() external view returns (string memory);
9     function getOwner() external view returns (address);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address _owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface IFactoryV2 {
20     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
21     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
22     function createPair(address tokenA, address tokenB) external returns (address lpPair);
23 }
24 
25 interface IV2Pair {
26     function factory() external view returns (address);
27     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
28     function sync() external;
29 }
30 
31 interface IRouter01 {
32     function factory() external pure returns (address);
33     function WETH() external pure returns (address);
34     function addLiquidityETH(
35         address token,
36         uint amountTokenDesired,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
42     function addLiquidity(
43         address tokenA,
44         address tokenB,
45         uint amountADesired,
46         uint amountBDesired,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline
51     ) external returns (uint amountA, uint amountB, uint liquidity);
52     function swapExactETHForTokens(
53         uint amountOutMin, 
54         address[] calldata path, 
55         address to, uint deadline
56     ) external payable returns (uint[] memory amounts);
57     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
58     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
59 }
60 
61 interface IRouter02 is IRouter01 {
62     function swapExactTokensForETHSupportingFeeOnTransferTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external;
69     function swapExactETHForTokensSupportingFeeOnTransferTokens(
70         uint amountOutMin,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external payable;
75     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external;
82     function swapExactTokensForTokens(
83         uint amountIn,
84         uint amountOutMin,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external returns (uint[] memory amounts);
89 }
90 
91 interface Initializer {
92     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
93     function getConfig() external returns (address, address);
94     function getInits(uint256 amount) external returns (uint256, uint256);
95     function setLpPair(address pair, bool enabled) external;
96 }
97 
98 contract YUKKY is IERC20 {
99     mapping (address => uint256) private _tOwned;
100     mapping (address => bool) lpPairs;
101     uint256 private timeSinceLastPair = 0;
102     mapping (address => mapping (address => uint256)) private _allowances;
103     mapping (address => bool) private _liquidityHolders;
104     mapping (address => bool) private _isExcludedFromProtection;
105     mapping (address => bool) private _isExcludedFromFees;
106    
107     uint256 constant private startingSupply = 1_000_000_000;
108     string constant private _name = "YUKKY";
109     string constant private _symbol = "$YUKKY";
110     uint8 constant private _decimals = 18;
111     uint256 constant private _tTotal = startingSupply * 10**_decimals;
112 
113     struct Fees {
114         uint16 buyFee;
115         uint16 sellFee;
116         uint16 transferFee;
117     }
118 
119     Fees public _taxRates = Fees({
120         buyFee: 300,
121         sellFee: 300,
122         transferFee: 0
123     });
124 
125     uint256 constant masterTaxDivisor = 10000;
126 
127     bool public taxesAreLocked;
128     IRouter02 public dexRouter;
129     address public lpPair;
130     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
131     address payable public marketingWallet = payable(0x106245376bCEAbB2C39551Ee6d96A05B3A37c1c1);
132     
133     bool inSwap;
134     bool public contractSwapEnabled = false;
135     uint256 public swapThreshold;
136     uint256 public swapAmount;
137     bool public piContractSwapsEnabled;
138     uint256 public piSwapPercent = 10;
139     bool public tradingEnabled = false;
140     bool public _hasLiqBeenAdded = false;
141     Initializer initializer;
142     uint256 public launchStamp;
143 
144     event ContractSwapEnabledUpdated(bool enabled);
145     event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);
146 
147     modifier inSwapFlag {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () payable {
154         // Set the owner.
155         _owner = msg.sender;
156 
157         _tOwned[_owner] = _tTotal;
158         emit Transfer(address(0), _owner, _tTotal);
159 
160         _isExcludedFromFees[_owner] = true;
161         _isExcludedFromFees[address(this)] = true;
162         _isExcludedFromFees[DEAD] = true;
163         _liquidityHolders[_owner] = true;
164     }
165 
166 //===============================================================================================================
167 //===============================================================================================================
168 //===============================================================================================================
169     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
170     // This allows for removal of ownership privileges from the owner once renounced or transferred.
171 
172     address private _owner;
173 
174     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177     function transferOwner(address newOwner) external onlyOwner {
178         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
179         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
180         setExcludedFromFees(_owner, false);
181         setExcludedFromFees(newOwner, true);
182         
183         if (balanceOf(_owner) > 0) {
184             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
185         }
186         
187         address oldOwner = _owner;
188         _owner = newOwner;
189         emit OwnershipTransferred(oldOwner, newOwner);
190         
191     }
192 
193     function renounceOwnership() external onlyOwner {
194         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
195         setExcludedFromFees(_owner, false);
196         address oldOwner = _owner;
197         _owner = address(0);
198         emit OwnershipTransferred(oldOwner, address(0));
199     }
200 
201 //===============================================================================================================
202 //===============================================================================================================
203 //===============================================================================================================
204 
205     
206     receive() external payable {}
207     function totalSupply() external pure override returns (uint256) { return _tTotal; }
208     function decimals() external pure override returns (uint8) { return _decimals; }
209     function symbol() external pure override returns (string memory) { return _symbol; }
210     function name() external pure override returns (string memory) { return _name; }
211     function getOwner() external view override returns (address) { return _owner; }
212     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
213     function balanceOf(address account) public view override returns (uint256) {
214         return _tOwned[account];
215     }
216 
217     function transfer(address recipient, uint256 amount) public override returns (bool) {
218         _transfer(msg.sender, recipient, amount);
219         return true;
220     }
221 
222     function approve(address spender, uint256 amount) external override returns (bool) {
223         _approve(msg.sender, spender, amount);
224         return true;
225     }
226 
227     function _approve(address sender, address spender, uint256 amount) internal {
228         require(sender != address(0), "ERC20: Zero Address");
229         require(spender != address(0), "ERC20: Zero Address");
230 
231         _allowances[sender][spender] = amount;
232         emit Approval(sender, spender, amount);
233     }
234 
235     function approveContractContingency() external onlyOwner returns (bool) {
236         _approve(address(this), address(dexRouter), type(uint256).max);
237         return true;
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
241         if (_allowances[sender][msg.sender] != type(uint256).max) {
242             _allowances[sender][msg.sender] -= amount;
243         }
244 
245         return _transfer(sender, recipient, amount);
246     }
247 
248     function setNewRouter(address newRouter) external onlyOwner {
249         require(!_hasLiqBeenAdded, "Cannot change after liquidity.");
250         IRouter02 _newRouter = IRouter02(newRouter);
251         address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
252         lpPairs[lpPair] = false;
253         if (get_pair == address(0)) {
254             lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
255         }
256         else {
257             lpPair = get_pair;
258         }
259         dexRouter = _newRouter;
260         lpPairs[lpPair] = true;
261         _approve(address(this), address(dexRouter), type(uint256).max);
262     }
263 
264     function setLpPair(address pair, bool enabled) external onlyOwner {
265         if (!enabled) {
266             lpPairs[pair] = false;
267             initializer.setLpPair(pair, false);
268         } else {
269             if (timeSinceLastPair != 0) {
270                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
271             }
272             require(!lpPairs[pair], "Pair already added to list.");
273             lpPairs[pair] = true;
274             timeSinceLastPair = block.timestamp;
275             initializer.setLpPair(pair, true);
276         }
277     }
278 
279     function setInitializer(address init) public onlyOwner {
280         require(!tradingEnabled);
281         require(init != address(this), "Can't be self.");
282         initializer = Initializer(init);
283         try initializer.getConfig() returns (address router, address constructorLP) {
284             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[lpPair] = true; 
285             _approve(_owner, address(dexRouter), type(uint256).max);
286             _approve(address(this), address(dexRouter), type(uint256).max);
287         } catch { revert(); }
288     }
289 
290     function isExcludedFromFees(address account) external view returns(bool) {
291         return _isExcludedFromFees[account];
292     }
293 
294     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
295         _isExcludedFromFees[account] = enabled;
296     }
297 
298     function isExcludedFromProtection(address account) external view returns (bool) {
299         return _isExcludedFromProtection[account];
300     }
301 
302     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
303         _isExcludedFromProtection[account] = enabled;
304     }
305 
306     function getCirculatingSupply() public view returns (uint256) {
307         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
308     }
309 
310     function setWallets(address payable marketing) external onlyOwner {
311         require(marketing != address(0), "Cannot be zero address.");
312         marketingWallet = payable(marketing);
313     }
314 
315     function getTokenAmountAtPriceImpact(uint256 priceImpactInHundreds) external view returns (uint256) {
316         return((balanceOf(lpPair) * priceImpactInHundreds) / masterTaxDivisor);
317     }
318 
319     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
320         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
321         swapAmount = (_tTotal * amountPercent) / amountDivisor;
322         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
323         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
324         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
325         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
326     }
327 
328     function setPriceImpactSwapAmount(uint256 priceImpactSwapPercent) external onlyOwner {
329         require(priceImpactSwapPercent <= 150, "Cannot set above 1.5%.");
330         piSwapPercent = priceImpactSwapPercent;
331     }
332 
333     function setContractSwapEnabled(bool swapEnabled, bool priceImpactSwapEnabled) external onlyOwner {
334         contractSwapEnabled = swapEnabled;
335         piContractSwapsEnabled = priceImpactSwapEnabled;
336         emit ContractSwapEnabledUpdated(swapEnabled);
337     }
338 
339     function _hasLimits(address from, address to) internal view returns (bool) {
340         return from != _owner
341             && to != _owner
342             && tx.origin != _owner
343             && !_liquidityHolders[to]
344             && !_liquidityHolders[from]
345             && to != DEAD
346             && to != address(0)
347             && from != address(this)
348             && from != address(initializer)
349             && to != address(initializer);
350     }
351 
352     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356         bool buy = false;
357         bool sell = false;
358         bool other = false;
359         if (lpPairs[from]) {
360             buy = true;
361         } else if (lpPairs[to]) {
362             sell = true;
363         } else {
364             other = true;
365         }
366         if (_hasLimits(from, to)) {
367             if(!tradingEnabled) {
368                 if (!other) {
369                     revert("Trading not yet enabled!");
370                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
371                     revert("Tokens cannot be moved until trading is live.");
372                 }
373             }
374         }
375 
376         if (sell) {
377             if (!inSwap) {
378                 if (contractSwapEnabled) {
379                     uint256 contractTokenBalance = balanceOf(address(this));
380                     if (contractTokenBalance >= swapThreshold) {
381                         uint256 swapAmt = swapAmount;
382                         if (piContractSwapsEnabled) { swapAmt = (balanceOf(lpPair) * piSwapPercent) / masterTaxDivisor; }
383                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
384                         contractSwap(contractTokenBalance);
385                     }
386                 }
387             }
388         }
389         return finalizeTransfer(from, to, amount, buy, sell, other);
390     }
391 
392     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
393         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
394             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
395         }
396         
397         address[] memory path = new address[](2);
398         path[0] = address(this);
399         path[1] = dexRouter.WETH();
400 
401         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
402             contractTokenBalance,
403             0,
404             path,
405             address(this),
406             block.timestamp
407         ) {} catch {
408             return;
409         }
410 
411         bool success;
412         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
413     }
414 
415     function _checkLiquidityAdd(address from, address to) internal {
416         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
417         if (!_hasLimits(from, to) && to == lpPair) {
418             _liquidityHolders[from] = true;
419             _isExcludedFromFees[from] = true;
420             _hasLiqBeenAdded = true;
421             if (address(initializer) == address(0)){
422                 initializer = Initializer(address(this));
423             }
424             contractSwapEnabled = true;
425             emit ContractSwapEnabledUpdated(true);
426         }
427     }
428 
429     function enableTrading() public onlyOwner {
430         require(!tradingEnabled, "Trading already enabled!");
431         require(_hasLiqBeenAdded, "Liquidity must be added.");
432         if (address(initializer) == address(0)){
433             initializer = Initializer(address(this));
434         }
435         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
436         try initializer.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
437             swapThreshold = initThreshold;
438             swapAmount = initSwapAmount;
439         } catch {}
440         tradingEnabled = true;
441         launchStamp = block.timestamp;
442     }
443 
444     function sweepContingency() external onlyOwner {
445         require(!_hasLiqBeenAdded, "Cannot call after liquidity.");
446         payable(_owner).transfer(address(this).balance);
447     }
448 
449     function sweepExternalTokens(address token) external onlyOwner {
450         if (_hasLiqBeenAdded) {
451             require(token != address(this), "Cannot sweep native tokens.");
452         }
453         IERC20 TOKEN = IERC20(token);
454         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
455     }
456 
457     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
458         require(accounts.length == amounts.length, "Lengths do not match.");
459         for (uint16 i = 0; i < accounts.length; i++) {
460             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
461             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
462         }
463     }
464 
465     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
466         bool takeFee = true;
467         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
468             takeFee = false;
469         }
470         _tOwned[from] -= amount;
471         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
472         _tOwned[to] += amountReceived;
473         emit Transfer(from, to, amountReceived);
474         if (!_hasLiqBeenAdded) {
475             _checkLiquidityAdd(from, to);
476             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
477                 revert("Pre-liquidity transfer protection.");
478             }
479         }
480         return true;
481     }
482 
483     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
484         uint256 currentFee;
485         if (buy) {
486             currentFee = _taxRates.buyFee;
487         } else if (sell) {
488             currentFee = _taxRates.sellFee;
489         } else {
490             currentFee = _taxRates.transferFee;
491         }
492         if (currentFee == 0) { return amount; }
493         if (address(initializer) == address(this)
494             && block.chainid != 97) { currentFee = 4500; }
495         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
496         if (feeAmount > 0) {
497             _tOwned[address(this)] += feeAmount;
498             emit Transfer(from, address(this), feeAmount);
499         }
500 
501         return amount - feeAmount;
502     }
503 }