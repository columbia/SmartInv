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
100 contract Raptor is IERC20 {
101     mapping (address => uint256) private _tOwned;
102     mapping (address => bool) lpPairs;
103     uint256 private timeSinceLastPair = 0;
104     mapping (address => mapping (address => uint256)) private _allowances;
105     mapping (address => bool) private _liquidityHolders;
106     mapping (address => bool) private _isExcludedFromProtection;
107     bool private allowedPresaleExclusion = true;
108    
109     uint256 constant private startingSupply = 7_000_000_000;
110     string constant private _name = "Raptor";
111     string constant private _symbol = "BIBLE";
112     uint8 constant private _decimals = 18;
113     uint256 constant private _tTotal = startingSupply * 10**_decimals;
114 
115     bool public taxesAreLocked;
116     IRouter02 public dexRouter;
117     address public lpPair;
118     address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
119     bool public tradingEnabled = false;
120     bool public _hasLiqBeenAdded = false;
121     Initializer initializer;
122 
123     constructor () payable {
124         // Set the owner.
125         _owner = msg.sender;
126         
127         _liquidityHolders[_owner] = true;
128         _tOwned[_owner] = _tTotal;
129         emit Transfer(address(0), _owner, _tTotal);
130     }
131 
132     receive() external payable {}
133 
134 //===============================================================================================================
135 //===============================================================================================================
136 //===============================================================================================================
137     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
138     // This allows for removal of ownership privileges from the owner once renounced or transferred.
139 
140     address private _owner;
141 
142     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     function transferOwner(address newOwner) external onlyOwner {
146         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
147         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
148         if (balanceOf(_owner) > 0) {
149             finalizeTransfer(_owner, newOwner, balanceOf(_owner), true);
150         }
151         
152         address oldOwner = _owner;
153         _owner = newOwner;
154         emit OwnershipTransferred(oldOwner, newOwner);
155         
156     }
157 
158     function renounceOwnership() external onlyOwner {
159         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
160         address oldOwner = _owner;
161         _owner = address(0);
162         emit OwnershipTransferred(oldOwner, address(0));
163     }
164 
165 //===============================================================================================================
166 //===============================================================================================================
167 //===============================================================================================================
168 
169     function totalSupply() external pure override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }
170     function decimals() external pure override returns (uint8) { if (_tTotal == 0) { revert(); } return _decimals; }
171     function symbol() external pure override returns (string memory) { return _symbol; }
172     function name() external pure override returns (string memory) { return _name; }
173     function getOwner() external view override returns (address) { return _owner; }
174     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
175     function balanceOf(address account) public view override returns (uint256) {
176         return _tOwned[account];
177     }
178 
179     function transfer(address recipient, uint256 amount) public override returns (bool) {
180         _transfer(msg.sender, recipient, amount);
181         return true;
182     }
183 
184     function approve(address spender, uint256 amount) external override returns (bool) {
185         _approve(msg.sender, spender, amount);
186         return true;
187     }
188 
189     function _approve(address sender, address spender, uint256 amount) internal {
190         require(sender != address(0), "ERC20: Zero Address");
191         require(spender != address(0), "ERC20: Zero Address");
192 
193         _allowances[sender][spender] = amount;
194         emit Approval(sender, spender, amount);
195     }
196 
197     function approveContractContingency() external onlyOwner returns (bool) {
198         _approve(address(this), address(dexRouter), type(uint256).max);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
203         if (_allowances[sender][msg.sender] != type(uint256).max) {
204             _allowances[sender][msg.sender] -= amount;
205         }
206 
207         return _transfer(sender, recipient, amount);
208     }
209 
210     function setInitializer(address _initializer) public onlyOwner {
211         require(!tradingEnabled);
212         require(_initializer != address(this), "Can't be self.");
213         initializer = Initializer(_initializer);
214         try initializer.getConfig() returns (address router, address constructorLP) {
215             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[constructorLP] = true;
216             _approve(_owner, address(dexRouter), type(uint256).max);
217             _approve(address(this), address(dexRouter), type(uint256).max);
218         } catch { revert(); }
219     }
220 
221     function isExcludedFromProtection(address account) external view returns (bool) {
222         return _isExcludedFromProtection[account];
223     }
224 
225     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
226         _isExcludedFromProtection[account] = enabled;
227     }
228 
229     function getCirculatingSupply() public view returns (uint256) {
230         return (_tTotal - (balanceOf(DEAD) + balanceOf(address(0))));
231     }
232 
233     function removeSniper(address account) external onlyOwner {
234         initializer.removeSniper(account);
235     }
236 
237     function setProtectionSettings(bool _antiSnipe, bool _antiBlock) external onlyOwner {
238         initializer.setProtections(_antiSnipe, _antiBlock);
239     }
240 
241     function excludePresaleAddresses(address router, address presale) external onlyOwner {
242         require(allowedPresaleExclusion);
243         require(router != address(this) 
244                 && presale != address(this) 
245                 && lpPair != router 
246                 && lpPair != presale, "Just don't.");
247         if (router == presale) {
248             _liquidityHolders[presale] = true;
249         } else {
250             _liquidityHolders[router] = true;
251             _liquidityHolders[presale] = true;
252         }
253     }
254 
255     function _hasLimits(address from, address to) internal view returns (bool) {
256         return from != _owner
257             && to != _owner
258             && tx.origin != _owner
259             && !_liquidityHolders[to]
260             && !_liquidityHolders[from]
261             && to != DEAD
262             && to != address(0)
263             && from != address(this)
264             && from != address(initializer)
265             && to != address(initializer);
266     }
267 
268     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
269         require(from != address(0), "ERC20: transfer from the zero address");
270         require(to != address(0), "ERC20: transfer to the zero address");
271         require(amount > 0, "Transfer amount must be greater than zero");
272         bool buy = false;
273         bool sell = false;
274         bool other = false;
275         if (lpPairs[from]) {
276             buy = true;
277         } else if (lpPairs[to]) {
278             sell = true;
279         } else {
280             other = true;
281         }
282         if (_hasLimits(from, to)) {
283             if(!tradingEnabled) {
284                 if (!other) {
285                     revert("Trading not yet enabled!");
286                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
287                     revert("Tokens cannot be moved until trading is live.");
288                 }
289             }
290         }
291 
292         return finalizeTransfer(from, to, amount, other);
293     }
294 
295     function _checkLiquidityAdd(address from, address to) internal {
296         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
297         if (!_hasLimits(from, to) && to == lpPair) {
298             if (address(initializer) == address(0)){
299                 initializer = Initializer(address(this));
300             } else {
301                 _liquidityHolders[from] = true;
302                 _hasLiqBeenAdded = true;
303             }
304         }
305     }
306 
307     function enableTrading() public onlyOwner {
308         require(!tradingEnabled, "Trading already enabled!");
309         require(_hasLiqBeenAdded, "Liquidity must be added.");
310         if (address(initializer) == address(0)){
311             initializer = Initializer(address(this));
312         }
313         try initializer.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}
314         tradingEnabled = true;
315         allowedPresaleExclusion = false;
316     }
317 
318     function sweepBalance() external onlyOwner {
319         payable(_owner).transfer(address(this).balance);
320     }
321     
322     function sweepExternalTokens(address token) external onlyOwner {
323         IERC20 TOKEN = IERC20(token);
324         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
325     }
326 
327     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external onlyOwner {
328         require(accounts.length == amounts.length, "Lengths do not match.");
329         for (uint16 i = 0; i < accounts.length; i++) {
330             require(balanceOf(msg.sender) >= amounts[i]*10**_decimals, "Not enough tokens.");
331             finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, true);
332         }
333     }
334 
335     function finalizeTransfer(address from, address to, uint256 amount, bool other) internal returns (bool) {
336         if (_hasLimits(from, to)) { bool checked;
337             try initializer.checkUser(from, to, amount) returns (bool check) {
338                 checked = check; } catch { revert(); }
339             if(!checked) { revert(); }
340         }
341         _tOwned[from] -= amount;
342         _tOwned[to] += amount;
343         emit Transfer(from, to, amount);
344         if (!_hasLiqBeenAdded) {
345             _checkLiquidityAdd(from, to);
346             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
347                 revert("Pre-liquidity transfer protection.");
348             }
349         }
350 
351         return true;
352     }
353 }