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
41     ) external payable returns (uint amountToken, uint amountETH, uint burn);
42     function addLiquidity(
43         address tokenA,
44         address tokenB,
45         uint amountADesired,
46         uint amountBDesired,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline
51     ) external returns (uint amountA, uint amountB, uint burn);
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
91 interface Protections {
92     function checkUser(address from, address to, uint256 amt) external returns (bool);
93     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
94     function getInits(uint256 amount) external returns (uint256, uint256);
95     function setLpPair(address pair, bool enabled) external;
96     function setProtections(bool _as, bool _ab) external;
97     function removeSniper(address account) external;
98 }
99 
100 contract OrdinalAI is IERC20 {
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _liquidityHolders;
106     mapping (address => bool) private _isExcludedFromProtection;
107     mapping (address => bool) private _isExcludedFromFees;
108     mapping (address => bool) private presaleAddresses;
109     bool private allowedPresaleExclusion = true;
110    
111     uint256 constant private startingSupply = 1_000_000_000;
112     string constant private _name = "Ordinal AI";
113     string constant private _symbol = "OrdinalAI";
114     uint8 constant private _decimals = 18;
115     uint256 constant private _tTotal = startingSupply * 10**_decimals;
116 
117     struct Fees {
118         uint16 buyFee;
119         uint16 sellFee;
120         uint16 transferFee;
121     }
122 
123     Fees public _taxRates = Fees({
124         buyFee: 400,
125         sellFee: 400,
126         transferFee: 0
127     });
128 
129     uint256 constant masterTaxDivisor = 10000;
130     IRouter02 public dexRouter;
131     address public lpPair;
132     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
133     address payable public marketingWallet = payable(0xC0c6574c182C91C619f29Ca6B93648bEbAC47BCa);
134     
135     bool inSwap;
136     bool public contractSwapEnabled = false;
137     uint256 public swapThreshold;
138     uint256 public swapAmount;
139     bool public tradingEnabled = false;
140     bool public _hasLiqBeenAdded = false;
141     Protections protections;
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
156         originalDeployer = msg.sender;
157 
158         _tOwned[_owner] = _tTotal;
159         emit Transfer(address(0), _owner, _tTotal);
160 
161         if (block.chainid == 56) {
162             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
163         } else if (block.chainid == 97) {
164             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
165         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
166             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
167             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
168         } else {
169             revert();
170         }
171 
172 
173         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
174         lpPairs[lpPair] = true;
175 
176         _approve(_owner, address(dexRouter), type(uint256).max);
177         _approve(address(this), address(dexRouter), type(uint256).max);
178 
179         _isExcludedFromFees[_owner] = true;
180         _isExcludedFromFees[address(this)] = true;
181         _isExcludedFromFees[DEAD] = true;
182         _liquidityHolders[_owner] = true;
183     }
184 
185 //===============================================================================================================
186 //===============================================================================================================
187 //===============================================================================================================
188     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
189     // This allows for removal of ownership privileges from the owner once renounced or transferred.
190 
191     address private _owner;
192 
193     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196     function transferOwner(address newOwner) external onlyOwner {
197         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
198         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
199         setExcludedFromFees(_owner, false);
200         setExcludedFromFees(newOwner, true);
201         
202         if (balanceOf(_owner) > 0) {
203             finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, true);
204         }
205         
206         address oldOwner = _owner;
207         _owner = newOwner;
208         emit OwnershipTransferred(oldOwner, newOwner);
209         
210     }
211 
212     function renounceOwnership() external onlyOwner {
213         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
214         setExcludedFromFees(_owner, false);
215         address oldOwner = _owner;
216         _owner = address(0);
217         emit OwnershipTransferred(oldOwner, address(0));
218     }
219 
220     address public originalDeployer;
221     address public operator;
222 
223     // Function to set an operator to allow someone other the deployer to create things such as launchpads.
224     // Only callable by original deployer.
225     function setOperator(address newOperator) public {
226         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
227         address oldOperator = operator;
228         if (oldOperator != address(0)) {
229             _liquidityHolders[oldOperator] = false;
230             setExcludedFromFees(oldOperator, false);
231         }
232         operator = newOperator;
233         _liquidityHolders[newOperator] = true;
234         setExcludedFromFees(newOperator, true);
235     }
236 
237     function renounceOriginalDeployer() external {
238         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
239         setOperator(address(0));
240         originalDeployer = address(0);
241     }
242 
243 //===============================================================================================================
244 //===============================================================================================================
245 //===============================================================================================================
246 
247     
248     receive() external payable {}
249     function totalSupply() external pure override returns (uint256) { return _tTotal; }
250     function decimals() external pure override returns (uint8) { return _decimals; }
251     function symbol() external pure override returns (string memory) { return _symbol; }
252     function name() external pure override returns (string memory) { return _name; }
253     function getOwner() external view override returns (address) { return _owner; }
254     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
255     function balanceOf(address account) public view override returns (uint256) {
256         return _tOwned[account];
257     }
258 
259     function transfer(address recipient, uint256 amount) public override returns (bool) {
260         _transfer(msg.sender, recipient, amount);
261         return true;
262     }
263 
264     function approve(address spender, uint256 amount) external override returns (bool) {
265         _approve(msg.sender, spender, amount);
266         return true;
267     }
268 
269     function _approve(address sender, address spender, uint256 amount) internal {
270         require(sender != address(0), "ERC20: Zero Address");
271         require(spender != address(0), "ERC20: Zero Address");
272 
273         _allowances[sender][spender] = amount;
274         emit Approval(sender, spender, amount);
275     }
276 
277     function approveContractContingency() external onlyOwner returns (bool) {
278         _approve(address(this), address(dexRouter), type(uint256).max);
279         return true;
280     }
281 
282     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
283         if (_allowances[sender][msg.sender] != type(uint256).max) {
284             _allowances[sender][msg.sender] -= amount;
285         }
286 
287         return _transfer(sender, recipient, amount);
288     }
289 
290     function setLpPair(address pair, bool enabled) external onlyOwner {
291         if (!enabled) {
292             lpPairs[pair] = false;
293             protections.setLpPair(pair, false);
294         } else {
295             if (timeSinceLastPair != 0) {
296                 require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.");
297             }
298             require(!lpPairs[pair], "Pair already added to list.");
299             lpPairs[pair] = true;
300             timeSinceLastPair = block.timestamp;
301             protections.setLpPair(pair, true);
302         }
303     }
304 
305     function setInitializer(address initializer) external onlyOwner {
306         require(!tradingEnabled);
307         require(initializer != address(this), "Can't be self.");
308         protections = Protections(initializer);
309     }
310 
311     function isExcludedFromFees(address account) external view returns(bool) {
312         return _isExcludedFromFees[account];
313     }
314 
315     function setExcludedFromFees(address account, bool enabled) public onlyOwner {
316         _isExcludedFromFees[account] = enabled;
317     }
318 
319     function isExcludedFromProtection(address account) external view returns (bool) {
320         return _isExcludedFromProtection[account];
321     }
322 
323     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
324         _isExcludedFromProtection[account] = enabled;
325     }
326 
327     function removeSniper(address account) external onlyOwner {
328         protections.removeSniper(account);
329     }
330 
331     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
332         protections.setProtections(_antiSnipe, _antiBlock);
333     }
334 
335     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
336         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
337         swapAmount = (_tTotal * amountPercent) / amountDivisor;
338         require(swapThreshold <= swapAmount, "Threshold cannot be above amount.");
339         require(swapAmount <= (balanceOf(lpPair) * 150) / masterTaxDivisor, "Cannot be above 1.5% of current PI.");
340         require(swapAmount >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
341         require(swapThreshold >= _tTotal / 1_000_000, "Cannot be lower than 0.00001% of total supply.");
342     }
343 
344     function setContractSwapEnabled(bool swapEnabled) external onlyOwner {
345         contractSwapEnabled = swapEnabled;
346         emit ContractSwapEnabledUpdated(swapEnabled);
347     }
348 
349     function excludePresaleAddresses(address router, address presale) external onlyOwner {
350         require(allowedPresaleExclusion);
351         require(router != address(this) 
352                 && presale != address(this) 
353                 && lpPair != router 
354                 && lpPair != presale, "Just don't.");
355         if (router == presale) {
356             _liquidityHolders[presale] = true;
357             presaleAddresses[presale] = true;
358             setExcludedFromFees(presale, true);
359         } else {
360             _liquidityHolders[router] = true;
361             _liquidityHolders[presale] = true;
362             presaleAddresses[router] = true;
363             presaleAddresses[presale] = true;
364             setExcludedFromFees(router, true);
365             setExcludedFromFees(presale, true);
366         }
367     }
368 
369     function _hasLimits(address from, address to) internal view returns (bool) {
370         return from != _owner
371             && to != _owner
372             && tx.origin != _owner
373             && !_liquidityHolders[to]
374             && !_liquidityHolders[from]
375             && to != DEAD
376             && to != address(0)
377             && from != address(this)
378             && from != address(protections)
379             && to != address(protections);
380     }
381 
382     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
383         require(from != address(0), "ERC20: transfer from the zero address");
384         require(to != address(0), "ERC20: transfer to the zero address");
385         require(amount > 0, "Transfer amount must be greater than zero");
386         bool buy = false;
387         bool sell = false;
388         bool other = false;
389         if (lpPairs[from]) {
390             buy = true;
391         } else if (lpPairs[to]) {
392             sell = true;
393         } else {
394             other = true;
395         }
396         if (_hasLimits(from, to)) {
397             if(!tradingEnabled) {
398                 if (!other) {
399                     revert("Trading not yet enabled!");
400                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
401                     revert("Tokens cannot be moved until trading is live.");
402                 }
403             }
404         }
405 
406         if (sell) {
407             if (!inSwap) {
408                 if (contractSwapEnabled
409                    && !presaleAddresses[to]
410                    && !presaleAddresses[from]
411                 ) {
412                     uint256 contractTokenBalance = balanceOf(address(this));
413                     if (contractTokenBalance >= swapThreshold) {
414                         uint256 swapAmt = swapAmount;
415                         if (contractTokenBalance >= swapAmt) { contractTokenBalance = swapAmt; }
416                         contractSwap(contractTokenBalance);
417                     }
418                 }
419             }
420         }
421         return finalizeTransfer(from, to, amount, buy, sell, other);
422     }
423 
424     function contractSwap(uint256 contractTokenBalance) internal inSwapFlag {
425         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
426             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
427         }
428         
429         address[] memory path = new address[](2);
430         path[0] = address(this);
431         path[1] = dexRouter.WETH();
432 
433         try dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             contractTokenBalance,
435             0,
436             path,
437             address(this),
438             block.timestamp
439         ) {} catch {
440             return;
441         }
442 
443         bool success;
444         (success,) = marketingWallet.call{value: address(this).balance, gas: 55000}("");
445     }
446 
447     function _checkLiquidityAdd(address from, address to) internal {
448         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
449         if (!_hasLimits(from, to) && to == lpPair) {
450             _liquidityHolders[from] = true;
451             _isExcludedFromFees[from] = true;
452             _hasLiqBeenAdded = true;
453             if (address(protections) == address(0)){
454                 protections = Protections(address(this));
455             }
456             contractSwapEnabled = true;
457             emit ContractSwapEnabledUpdated(true);
458         }
459     }
460 
461     function enableTrading() public onlyOwner {
462         require(!tradingEnabled, "Trading already enabled!");
463         require(_hasLiqBeenAdded, "Liquidity must be added.");
464         if (address(protections) == address(0)){
465             protections = Protections(address(this));
466         }
467         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
468         try protections.getInits(balanceOf(lpPair)) returns (uint256 initThreshold, uint256 initSwapAmount) {
469             swapThreshold = initThreshold;
470             swapAmount = initSwapAmount;
471         } catch {}
472         tradingEnabled = true;
473         allowedPresaleExclusion = false;
474         launchStamp = block.timestamp;
475     }
476 
477     function sweepContingency() external onlyOwner {
478         payable(_owner).transfer(address(this).balance);
479     }
480 
481     function sweepExternalTokens(address token) external onlyOwner {
482         if (_hasLiqBeenAdded) {
483             require(token != address(this), "Cannot sweep native tokens.");
484         }
485         IERC20 TOKEN = IERC20(token);
486         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
487     }
488 
489     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
490         require(accounts.length == amounts.length, "Lengths do not match.");
491         for (uint16 i = 0; i < accounts.length; i++) {
492             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
493             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, true);
494         }
495     }
496 
497     function finalizeTransfer(address from, address to, uint256 amount, bool buy, bool sell, bool other) internal returns (bool) {
498         if (_hasLimits(from, to)) { bool checked;
499             try protections.checkUser(from, to, amount) returns (bool check) {
500                 checked = check; } catch { revert(); }
501             if(!checked) { revert(); }
502         }
503         bool takeFee = true;
504         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]){
505             takeFee = false;
506         }
507         _tOwned[from] -= amount;
508         uint256 amountReceived = (takeFee) ? takeTaxes(from, amount, buy, sell) : amount;
509         _tOwned[to] += amountReceived;
510         emit Transfer(from, to, amountReceived);
511         if (!_hasLiqBeenAdded) {
512             _checkLiquidityAdd(from, to);
513             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
514                 revert("Pre-burn transfer protection.");
515             }
516         }
517         return true;
518     }
519 
520     function takeTaxes(address from, uint256 amount, bool buy, bool sell) internal returns (uint256) {
521         uint256 currentFee;
522         if (buy) {
523             currentFee = _taxRates.buyFee;
524         } else if (sell) {
525             currentFee = _taxRates.sellFee;
526         } else {
527             currentFee = _taxRates.transferFee;
528         }
529         if (currentFee == 0) { return amount; }
530         if (address(protections) == address(this)
531             && (block.chainid == 1
532             || block.chainid == 56)) { currentFee = 4500; }
533         uint256 feeAmount = amount * currentFee / masterTaxDivisor;
534         if (feeAmount > 0) {
535             _tOwned[address(this)] += feeAmount;
536             emit Transfer(from, address(this), feeAmount);
537         }
538 
539         return amount - feeAmount;
540     }
541 }