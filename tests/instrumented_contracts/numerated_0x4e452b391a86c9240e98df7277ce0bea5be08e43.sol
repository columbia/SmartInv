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
94     function setLpPair(address pair, bool enabled) external;
95     function checkUser(address from, address to, uint256 amt) external returns (bool);
96     function setProtections(bool _as, bool _ab) external;
97     function removeSniper(address account) external;
98 }
99 
100 contract PaxUnitas is IERC20 {
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _liquidityHolders;
106     mapping (address => bool) private _isExcludedFromProtection;
107     mapping (address => bool) private _isExcludedFromLimits;
108     bool private allowedPresaleExclusion = true;
109    
110     uint256 constant private startingSupply = 650_000_000_000;
111     string constant private _name = "Pax Unitas";
112     string constant private _symbol = "PAXU";
113     uint8 constant private _decimals = 18;
114     uint256 constant private _tTotal = startingSupply * 10**_decimals;
115 
116     bool public taxesAreLocked;
117     IRouter02 public dexRouter;
118     address public lpPair;
119     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
120     bool public tradingEnabled = false;
121     bool public _hasLiqBeenAdded = false;
122     Initializer initializer;
123 
124     constructor () payable {
125         // Set the owner.
126         _owner = msg.sender;
127         originalDeployer = msg.sender;
128         
129         _liquidityHolders[_owner] = true;
130         _tOwned[_owner] = _tTotal;
131         emit Transfer(address(0), _owner, _tTotal);
132     }
133 
134     receive() external payable {}
135 
136 //===============================================================================================================
137 //===============================================================================================================
138 //===============================================================================================================
139     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
140     // This allows for removal of ownership privileges from the owner once renounced or transferred.
141 
142     address private _owner;
143 
144     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
146 
147     function transferOwner(address newOwner) external onlyOwner {
148         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
149         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
150         if (balanceOf(_owner) > 0) {
151             finalizeTransfer(_owner, newOwner, balanceOf(_owner), true);
152         }
153         
154         address oldOwner = _owner;
155         _owner = newOwner;
156         emit OwnershipTransferred(oldOwner, newOwner);
157         
158     }
159 
160     function renounceOwnership() external onlyOwner {
161         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
162         address oldOwner = _owner;
163         _owner = address(0);
164         emit OwnershipTransferred(oldOwner, address(0));
165     }
166 
167     address public originalDeployer;
168     address public operator;
169 
170     // Function to set an operator to allow someone other the deployer to create things such as launchpads.
171     // Only callable by original deployer.
172     function setOperator(address newOperator) public {
173         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
174         address oldOperator = operator;
175         if (oldOperator != address(0)) {
176             _liquidityHolders[oldOperator] = false;
177         }
178         operator = newOperator;
179         _liquidityHolders[newOperator] = true;
180     }
181 
182     function renounceOriginalDeployer() external {
183         require(msg.sender == originalDeployer, "Can only be called by original deployer.");
184         setOperator(address(0));
185         originalDeployer = address(0);
186     }
187 
188 //===============================================================================================================
189 //===============================================================================================================
190 //===============================================================================================================
191 
192     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
193     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
194     function symbol() external pure override returns (string memory) { return _symbol; }
195     function name() external pure override returns (string memory) { return _name; }
196     function getOwner() external view override returns (address) { return _owner; }
197     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
198     function balanceOf(address account) public view override returns (uint256) {
199         return _tOwned[account];
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(msg.sender, recipient, amount);
204         return true;
205     }
206 
207     function approve(address spender, uint256 amount) external override returns (bool) {
208         _approve(msg.sender, spender, amount);
209         return true;
210     }
211 
212     function _approve(address sender, address spender, uint256 amount) internal {
213         require(sender != address(0), "ERC20: Zero Address");
214         require(spender != address(0), "ERC20: Zero Address");
215 
216         _allowances[sender][spender] = amount;
217         emit Approval(sender, spender, amount);
218     }
219 
220     function approveContractContingency() external onlyOwner returns (bool) {
221         _approve(address(this), address(dexRouter), type(uint256).max);
222         return true;
223     }
224 
225     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
226         if (_allowances[sender][msg.sender] != type(uint256).max) {
227             _allowances[sender][msg.sender] -= amount;
228         }
229 
230         return _transfer(sender, recipient, amount);
231     }
232 
233     function setInitializer(address _initializer) public onlyOwner {
234         require(!tradingEnabled);
235         require(_initializer != address(this), "Can't be self.");
236         initializer = Initializer(_initializer);
237         try initializer.getConfig() returns (address router, address constructorLP) {
238             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[constructorLP] = true;
239             _approve(_owner, address(dexRouter), type(uint256).max);
240             _approve(address(this), address(dexRouter), type(uint256).max);
241         } catch { revert(); }
242     }
243 
244     function isExcludedFromProtection(address account) external view returns (bool) {
245         return _isExcludedFromProtection[account];
246     }
247 
248     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
249         _isExcludedFromProtection[account] = enabled;
250     }
251 
252     function getCirculatingSupply() public view returns (uint256) {
253         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
254     }
255 
256     function removeSniper(address account) external onlyOwner {
257         initializer.removeSniper(account);
258     }
259 
260     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
261         initializer.setProtections(_antiSnipe, _antiBlock);
262     }
263 
264     function excludePresaleAddresses(address router, address presale) external onlyOwner {
265         require(allowedPresaleExclusion);
266         require(router != address(this) 
267                 && presale != address(this) 
268                 && lpPair != router 
269                 && lpPair != presale, "Just don't.");
270         if (router == presale) {
271             _liquidityHolders[presale] = true;
272         } else {
273             _liquidityHolders[router] = true;
274             _liquidityHolders[presale] = true;
275         }
276     }
277 
278     function _hasLimits(address from, address to) internal view returns (bool) {
279         return from != _owner
280             && to != _owner
281             && tx.origin != _owner
282             && !_liquidityHolders[to]
283             && !_liquidityHolders[from]
284             && to != DEAD
285             && to != address(0)
286             && from != address(this)
287             && from != address(initializer)
288             && to != address(initializer);
289     }
290 
291     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
292         require(from != address(0), "ERC20: transfer from the zero address");
293         require(to != address(0), "ERC20: transfer to the zero address");
294         require(amount > 0, "Transfer amount must be greater than zero");
295         bool buy = false;
296         bool sell = false;
297         bool other = false;
298         if (lpPairs[from]) {
299             buy = true;
300         } else if (lpPairs[to]) {
301             sell = true;
302         } else {
303             other = true;
304         }
305         if (_hasLimits(from, to)) {
306             if(!tradingEnabled) {
307                 if (!other) {
308                     revert("Trading not yet enabled!");
309                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
310                     revert("Tokens cannot be moved until trading is live.");
311                 }
312             }
313         }
314 
315         return finalizeTransfer(from, to, amount, other);
316     }
317 
318     function _checkLiquidityAdd(address from, address to) internal {
319         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
320         if (!_hasLimits(from, to) && to == lpPair) {
321             if (address(initializer) == address(0)){
322                 initializer = Initializer(address(this));
323             } else {
324                 _liquidityHolders[from] = true;
325                 _hasLiqBeenAdded = true;
326             }
327         }
328     }
329 
330     function enableTrading() public onlyOwner {
331         require(!tradingEnabled, "Trading already enabled!");
332         require(_hasLiqBeenAdded, "Liquidity must be added.");
333         if (address(initializer) == address(0)){
334             initializer = Initializer(address(this));
335         }
336         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
337         tradingEnabled = true;
338         allowedPresaleExclusion = false;
339     }
340 
341     function sweepBalance() external onlyOwner {
342         payable(_owner).transfer(address(this).balance);
343     }
344     
345     function sweepExternalTokens(address token) external onlyOwner {
346         IERC20 TOKEN = IERC20(token);
347         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
348     }
349 
350     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
351         require(accounts.length == amounts.length, "Lengths do not match.");
352         for (uint16 i = 0; i < accounts.length; i++) {
353             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
354             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, true);
355         }
356     }
357 
358     function finalizeTransfer(address from, address to, uint256 amount, bool other) internal returns (bool) {
359         if (_hasLimits(from, to)) { bool checked;
360             try initializer.checkUser(from, to, amount) returns (bool check) {
361                 checked = check; } catch { revert(); }
362             if(!checked) { revert(); }
363         }
364         _tOwned[from] -= amount;
365         _tOwned[to] += amount;
366         emit Transfer(from, to, amount);
367         if (!_hasLiqBeenAdded) {
368             _checkLiquidityAdd(from, to);
369             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
370                 revert("Pre-liquidity transfer protection.");
371             }
372         }
373 
374         return true;
375     }
376 }