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
91 interface Protections {
92     function checkUser(address from, address to, uint256 amt) external returns (bool);
93     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
94     function setLpPair(address pair, bool enabled) external;
95     function setProtections(bool _as, bool _ab) external;
96     function removeSniper(address account) external;
97 }
98 
99 contract Freddo is IERC20 {
100     mapping (address => uint256) private _tOwned;
101     mapping (address => bool) lpPairs;
102     uint256 private timeSinceLastPair = 0;
103     mapping (address => mapping (address => uint256)) private _allowances;
104     mapping (address => bool) private _liquidityHolders;
105     mapping (address => bool) private _isExcludedFromProtection;
106     mapping (address => bool) private _isExcludedFromLimits;
107     bool private allowedPresaleExclusion = true;
108    
109     uint256 constant private startingSupply = 1_000_000_000;
110     string constant private _name = "Freddo";
111     string constant private _symbol = "FRED";
112     uint8 constant private _decimals = 18;
113     uint256 constant private _tTotal = startingSupply * 10**_decimals;
114 
115     bool public taxesAreLocked;
116     IRouter02 public dexRouter;
117     address public lpPair;
118     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
119     address constant public developmentWallet = 0xdF76bdE88180A416161F0774098aD08fEfA6872E;
120     
121     uint256 private _maxTxAmount = (_tTotal * 2) / 100;
122     uint256 private _maxWalletSize = (_tTotal * 2) / 100;
123 
124     bool public tradingEnabled = false;
125     bool public _hasLiqBeenAdded = false;
126     Protections protections;
127 
128     constructor () payable {
129         // Set the owner.
130         _owner = msg.sender;
131         originalDeployer = msg.sender;
132         
133         _tOwned[_owner] = _tTotal;
134         emit Transfer(address(0), _owner, _tTotal);
135 
136         if (block.chainid == 56) {
137             dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
138         } else if (block.chainid == 97) {
139             dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
140         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3 || block.chainid == 5) {
141             dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
142             //Ropstein DAI 0xaD6D458402F60fD3Bd25163575031ACDce07538D
143         } else if (block.chainid == 43114) {
144             dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);
145         } else if (block.chainid == 250) {
146             dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);
147         } else {
148             revert();
149         }
150 
151         lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
152         lpPairs[lpPair] = true;
153 
154         _approve(_owner, address(dexRouter), type(uint256).max);
155         _approve(address(this), address(dexRouter), type(uint256).max);
156         _liquidityHolders[_owner] = true;
157     }
158 
159     receive() external payable {}
160 
161 //===============================================================================================================
162 //===============================================================================================================
163 //===============================================================================================================
164     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
165     // This allows for removal of ownership privileges from the owner once renounced or transferred.
166 
167     address private _owner;
168 
169     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     function transferOwner(address newOwner) external onlyOwner {
173         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
174         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
175         if (balanceOf(_owner) > 0) {
176             finalizeTransfer(_owner, newOwner, balanceOf(_owner), true);
177         }
178         
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182         
183     }
184 
185     function renounceOwnership() external onlyOwner {
186         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
187         address oldOwner = _owner;
188         _owner = address(0);
189         emit OwnershipTransferred(oldOwner, address(0));
190     }
191 
192     address public originalDeployer;
193     address public operator;
194 
195     // Function to set an operator to allow someone other the deployer to create things such as launchpads.
196     // Only callable by original deployer.
197     function setOperator(address newOperator) public {
198         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
199         address oldOperator = operator;
200         if (oldOperator != address(0)) {
201             _liquidityHolders[oldOperator] = false;
202         }
203         operator = newOperator;
204         _liquidityHolders[newOperator] = true;
205     }
206 
207     function renounceOriginalDeployer() external {
208         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
209         setOperator(address(0));
210         originalDeployer = address(0);
211     }
212 
213 //===============================================================================================================
214 //===============================================================================================================
215 //===============================================================================================================
216 
217     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
218     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
219     function symbol() external pure override returns (string memory) { return _symbol; }
220     function name() external pure override returns (string memory) { return _name; }
221     function getOwner() external view override returns (address) { return _owner; }
222     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
223     function balanceOf(address account) public view override returns (uint256) {
224         return _tOwned[account];
225     }
226 
227     function transfer(address recipient, uint256 amount) public override returns (bool) {
228         _transfer(msg.sender, recipient, amount);
229         return true;
230     }
231 
232     function approve(address spender, uint256 amount) external override returns (bool) {
233         _approve(msg.sender, spender, amount);
234         return true;
235     }
236 
237     function _approve(address sender, address spender, uint256 amount) internal {
238         require(sender != address(0), "ERC20: Zero Address");
239         require(spender != address(0), "ERC20: Zero Address");
240 
241         _allowances[sender][spender] = amount;
242         emit Approval(sender, spender, amount);
243     }
244 
245     function approveContractContingency() external onlyOwner returns (bool) {
246         _approve(address(this), address(dexRouter), type(uint256).max);
247         return true;
248     }
249 
250     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
251         if (_allowances[sender][msg.sender] != type(uint256).max) {
252             _allowances[sender][msg.sender] -= amount;
253         }
254 
255         return _transfer(sender, recipient, amount);
256     }
257 
258     function setInitializer(address initializer) external onlyOwner {
259         require(!tradingEnabled);
260         require(initializer != address(this), "Can't be self.");
261         protections = Protections(initializer);
262     }
263 
264     function isExcludedFromLimits(address account) external view returns (bool) {
265         return _isExcludedFromLimits[account];
266     }
267 
268     function setExcludedFromLimits(address account, bool enabled) external onlyOwner {
269         _isExcludedFromLimits[account] = enabled;
270     }
271 
272     function isExcludedFromProtection(address account) external view returns (bool) {
273         return _isExcludedFromProtection[account];
274     }
275 
276     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
277         _isExcludedFromProtection[account] = enabled;
278     }
279 
280     function getCirculatingSupply() public view returns (uint256) {
281         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
282     }
283 
284     function removeSniper(address account) external onlyOwner {
285         protections.removeSniper(account);
286     }
287 
288     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
289         protections.setProtections(_antiSnipe, _antiBlock);
290     }
291 
292     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
293         require((_tTotal * percent) / divisor >= (_tTotal * 5 / 1000), "Max Transaction amt must be above 0.5% of total supply.");
294         _maxTxAmount = (_tTotal * percent) / divisor;
295     }
296 
297     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
298         require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");
299         _maxWalletSize = (_tTotal * percent) / divisor;
300     }
301 
302     function getMaxTX() external view returns (uint256) {
303         return _maxTxAmount / (10**_decimals);
304     }
305 
306     function getMaxWallet() external view returns (uint256) {
307         return _maxWalletSize / (10**_decimals);
308     }
309 
310     function excludePresaleAddresses(address router, address presale) external onlyOwner {
311         require(allowedPresaleExclusion);
312         require(router != address(this) 
313                 && presale != address(this) 
314                 && lpPair != router 
315                 && lpPair != presale, "Just don't.");
316         if (router == presale) {
317             _liquidityHolders[presale] = true;
318         } else {
319             _liquidityHolders[router] = true;
320             _liquidityHolders[presale] = true;
321         }
322     }
323 
324     function _hasLimits(address from, address to) internal view returns (bool) {
325         return from != _owner
326             && to != _owner
327             && tx.origin != _owner
328             && !_liquidityHolders[to]
329             && !_liquidityHolders[from]
330             && to != DEAD
331             && to != address(0)
332             && from != address(this)
333             && from != address(protections)
334             && to != address(protections);
335     }
336 
337     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
338         require(from != address(0), "ERC20: transfer from the zero address");
339         require(to != address(0), "ERC20: transfer to the zero address");
340         require(amount > 0, "Transfer amount must be greater than zero");
341         bool buy = false;
342         bool sell = false;
343         bool other = false;
344         if (lpPairs[from]) {
345             buy = true;
346         } else if (lpPairs[to]) {
347             sell = true;
348         } else {
349             other = true;
350         }
351         if (_hasLimits(from, to)) {
352             if(!tradingEnabled) {
353                 if (!other) {
354                     revert("Trading not yet enabled!");
355                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
356                     revert("Tokens cannot be moved until trading is live.");
357                 }
358             }
359             if (buy || sell){
360                 if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
361                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
362                 }
363             }
364             if (to != address(dexRouter) && !sell) {
365                 if (!_isExcludedFromLimits[to]) {
366                     require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
367                 }
368             }
369         }
370 
371         return finalizeTransfer(from, to, amount, other);
372     }
373 
374     function _checkLiquidityAdd(address from, address to) internal {
375         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
376         if (!_hasLimits(from, to) && to == lpPair) {
377             _liquidityHolders[from] = true;
378             _hasLiqBeenAdded = true;
379             if (address(protections) == address(0)){
380                 protections = Protections(address(this));
381             }
382         }
383     }
384 
385     function enableTrading() public onlyOwner {
386         require(!tradingEnabled, "Trading already enabled!");
387         require(_hasLiqBeenAdded, "Liquidity must be added.");
388         if (address(protections) == address(0)){
389             protections = Protections(address(this));
390         }
391         try protections.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
392         tradingEnabled = true;
393         allowedPresaleExclusion = false;
394     }
395 
396     function sweepBalance() external {
397         payable(developmentWallet).transfer(address(this).balance);
398     }
399     
400     function sweepExternalTokens(address token) external {
401         IERC20 TOKEN = IERC20(token);
402         TOKEN.transfer(developmentWallet, TOKEN.balanceOf(address(this)));
403     }
404 
405     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
406         require(accounts.length == amounts.length, "Lengths do not match.");
407         for (uint16 i = 0; i < accounts.length; i++) {
408             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
409             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, true);
410         }
411     }
412 
413     function finalizeTransfer(address from, address to, uint256 amount, bool other) internal returns (bool) {
414         if (_hasLimits(from, to)) { bool checked;
415             try protections.checkUser(from, to, amount) returns (bool check) {
416                 checked = check; } catch { revert(); }
417             if(!checked) { revert(); }
418         }
419         _tOwned[from] -= amount;
420         _tOwned[to] += amount;
421         emit Transfer(from, to, amount);
422         if (!_hasLiqBeenAdded) {
423             _checkLiquidityAdd(from, to);
424             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
425                 revert("Pre-liquidity transfer protection.");
426             }
427         }
428 
429         return true;
430     }
431 }