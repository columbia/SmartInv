1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
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
95 }
96 
97 contract FLASH is IERC20 {
98     mapping (address => uint256) private _tOwned;
99     mapping (address => bool) lpPairs;
100     uint256 private timeSinceLastPair = 0;
101     mapping (address => mapping (address => uint256)) private _allowances;
102 
103     mapping (address => bool) private _liquidityHolders;
104     mapping (address => bool) private _isExcludedFromProtection;
105     mapping (address => bool) private _isExcludedFromFees;
106     mapping (address => bool) private presaleAddresses;
107     bool private allowedPresaleExclusion = true;
108    
109     uint256 constant private startingSupply = 100_000_000;
110     string constant private _name = "Flash 3.0";
111     string constant private _symbol = "FLASH";
112     uint8 constant private _decimals = 18;
113     uint256 private _tTotal = startingSupply * 10**_decimals;
114     IRouter02 public dexRouter;
115     address public lpPair;
116     bool public tradingEnabled = false;
117     bool public _hasLiqBeenAdded = false;
118     Initializer initializer;
119 
120     constructor () payable {
121         _tOwned[msg.sender] = _tTotal;
122         emit Transfer(address(0), msg.sender, _tTotal);
123 
124         // Set the owner.
125         _owner = msg.sender;
126         _liquidityHolders[_owner] = true;
127     }
128 
129     receive() external payable {}
130 
131 //===============================================================================================================
132 //===============================================================================================================
133 //===============================================================================================================
134     // Ownable removed as a lib and added here to allow for custom transfers and renouncements.
135     // This allows for removal of ownership privileges from the owner once renounced or transferred.
136 
137     address private _owner;
138 
139     modifier onlyOwner() { require(_owner == msg.sender, "Caller =/= owner."); _; }
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     function transferOwner(address newOwner) external onlyOwner {
143         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
144         require(newOwner != address(0xDead), "Call renounceOwnership to transfer owner to the zero address.");
145         if (balanceOf(_owner) > 0) {
146             finalizeTransfer(_owner, newOwner, balanceOf(_owner), true);
147         }
148         
149         address oldOwner = _owner;
150         _owner = newOwner;
151         emit OwnershipTransferred(oldOwner, newOwner);
152         
153     }
154 
155     function renounceOwnership() external onlyOwner {
156         require(tradingEnabled, "Cannot renounce until trading has been enabled.");
157         address oldOwner = _owner;
158         _owner = address(0);
159         emit OwnershipTransferred(oldOwner, address(0));
160     }
161 
162 //===============================================================================================================
163 //===============================================================================================================
164 //===============================================================================================================
165 
166     function totalSupply() external view override returns (uint256) { return _tTotal; }
167     function decimals() external pure override returns (uint8) { return _decimals; }
168     function symbol() external pure override returns (string memory) { return _symbol; }
169     function name() external pure override returns (string memory) { return _name; }
170     function getOwner() external view override returns (address) { return _owner; }
171     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
172     function balanceOf(address account) public view override returns (uint256) {
173         return _tOwned[account];
174     }
175 
176     function transfer(address recipient, uint256 amount) public override returns (bool) {
177         _transfer(msg.sender, recipient, amount);
178         return true;
179     }
180 
181     function approve(address spender, uint256 amount) external override returns (bool) {
182         _approve(msg.sender, spender, amount);
183         return true;
184     }
185 
186     function _approve(address sender, address spender, uint256 amount) internal {
187         require(sender != address(0), "ERC20: Zero Address");
188         require(spender != address(0), "ERC20: Zero Address");
189 
190         _allowances[sender][spender] = amount;
191         emit Approval(sender, spender, amount);
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
195         if (_allowances[sender][msg.sender] != type(uint256).max) {
196             _allowances[sender][msg.sender] -= amount;
197         }
198 
199         return _transfer(sender, recipient, amount);
200     }
201 
202     function setInitializer(address _initializer) public onlyOwner {
203         require(!tradingEnabled);
204         require(_initializer != address(this), "Can't be self.");
205         initializer = Initializer(_initializer);
206         try initializer.getConfig() returns (address router, address constructorLP) {
207             require(router != address(0) && constructorLP != address(0));
208             dexRouter = IRouter02(router); lpPair = constructorLP; lpPairs[constructorLP] = true;
209             _approve(_owner, address(dexRouter), type(uint256).max);
210         } catch {}
211     }
212 
213     function isExcludedFromProtection(address account) external view returns (bool) {
214         return _isExcludedFromProtection[account];
215     }
216 
217     event ExcludedFromProtection(address indexed account, bool enabled);
218     function setExcludedFromProtection(address account, bool enabled) external onlyOwner {
219         _isExcludedFromProtection[account] = enabled;
220         emit ExcludedFromProtection(account, enabled);
221     }
222 
223     event PresaleAddressExcluded(address indexed presale);
224     event PresaleAddressesExcluded(address indexed presale, address indexed router);
225     function excludePresaleAddresses(address router, address presale) external onlyOwner {
226         require(allowedPresaleExclusion);
227         require(router != address(this) 
228                 && presale != address(this) 
229                 && lpPair != router 
230                 && lpPair != presale, "Just don't.");
231         if (router == presale) {
232             _liquidityHolders[presale] = true;
233             emit PresaleAddressesExcluded(presale, router);
234         } else {
235             _liquidityHolders[router] = true;
236             _liquidityHolders[presale] = true;
237             emit PresaleAddressesExcluded(presale, router);
238         }
239     }
240 
241     function _hasLimits(address from, address to) internal view returns (bool) {
242         return from != _owner
243             && to != _owner
244             && tx.origin != _owner
245             && !_liquidityHolders[to]
246             && !_liquidityHolders[from]
247             && to != address(0xDead)
248             && to != address(0)
249             && from != address(this)
250             && from != address(initializer)
251             && to != address(initializer);
252     }
253 
254     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
255         require(from != address(0), "ERC20: transfer from the zero address");
256         require(to != address(0), "ERC20: transfer to the zero address");
257         require(amount > 0, "Transfer amount must be greater than zero");
258         bool buy = false;
259         bool sell = false;
260         bool other = false;
261         if (lpPairs[from]) {
262             buy = true;
263         } else if (lpPairs[to]) {
264             sell = true;
265         } else {
266             other = true;
267         }
268         if (_hasLimits(from, to)) {
269             if(!tradingEnabled) {
270                 if (!other) {
271                     revert("Trading not yet enabled!");
272                 } else if (!_isExcludedFromProtection[from] && !_isExcludedFromProtection[to]) {
273                     revert("Tokens cannot be moved until trading is live.");
274                 }
275             }
276         }
277 
278         return finalizeTransfer(from, to, amount, other);
279     }
280 
281     function _checkLiquidityAdd(address from, address to) internal {
282         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
283         if (!_hasLimits(from, to) && to == lpPair) {
284             if (address(initializer) == address(0)){
285                 initializer = Initializer(address(this));
286             } else {
287                 _liquidityHolders[from] = true;
288                 _hasLiqBeenAdded = true;
289                 tradingEnabled = true;
290                 allowedPresaleExclusion = false;
291             }
292         }
293     }
294 
295     function finalizeTransfer(address from, address to, uint256 amount, bool other) internal returns (bool) {
296         _tOwned[from] -= amount;
297         _tOwned[to] += amount;
298         emit Transfer(from, to, amount);
299         if (!_hasLiqBeenAdded) {
300             _checkLiquidityAdd(from, to);
301             if (!_hasLiqBeenAdded && _hasLimits(from, to) && !_isExcludedFromProtection[from] && !_isExcludedFromProtection[to] && !other) {
302                 revert("Pre-liquidity transfer protection.");
303             }
304         }
305         return true;
306     }
307 
308     function burn(uint256 amountTokens) external {
309         address sender = msg.sender;
310         amountTokens *= 10**_decimals;
311         require(balanceOf(sender) >= amountTokens, "You do not have enough tokens.");
312         _tOwned[sender] -= amountTokens;
313         _tTotal -= amountTokens;
314         emit Transfer(sender, address(0), amountTokens);
315     }
316 
317     function sweepContingency() external onlyOwner {
318         payable(_owner).call{value: address(this).balance, gas: 55000}("");
319     }
320 
321     function sweepTokens(address token) external onlyOwner {
322         IERC20 TOKEN = IERC20(token);
323         TOKEN.transfer(_owner, TOKEN.balanceOf(address(this)));
324     }
325 }