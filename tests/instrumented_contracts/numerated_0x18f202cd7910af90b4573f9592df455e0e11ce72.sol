1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IERC20 {
5 	function totalSupply() external view returns (uint256);
6 	function decimals() external view returns (uint8);
7 	function symbol() external view returns (string memory);
8 	function name() external view returns (string memory);
9 	function balanceOf(address account) external view returns (uint256);
10 	function transfer(address recipient, uint256 amount) external returns (bool);
11 	function allowance(address _owner, address spender) external view returns (uint256);
12 	function approve(address spender, uint256 amount) external returns (bool);
13 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14 	event Transfer(address indexed from, address indexed to, uint256 value);
15 	event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
19 interface IUniswapV2Router02 {
20 	function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
21 	function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
22 	function factory() external pure returns (address);
23 	function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
24 }
25 
26 abstract contract OWNED {
27 	address internal _owner;
28 	event OwnershipTransferred(address owner);
29 	constructor(address contractOwner) { _owner = contractOwner; }
30 	modifier onlyOwner() { require(msg.sender == _owner, "Not the owner"); _; }
31 	// function owner() external view returns (address) { return _owner; }  // moved into addressList() function
32 	function renounceOwnership() external onlyOwner { _transferOwnership(address(0)); }
33 	function transferOwnership(address newOwner) external onlyOwner { _transferOwnership(newOwner); }
34 	function _transferOwnership(address _newOwner) internal {
35 		_owner = _newOwner; 
36 		emit OwnershipTransferred(_newOwner); 
37 	}
38 }
39 
40 contract BLOOD is IERC20, OWNED {
41 	mapping(address => uint256) private _balances;
42 	mapping(address => mapping(address => uint256)) private _allowances;
43 	uint8 private constant _decimals = 9;
44 	uint256 private constant _totalSupply = 100_000_000 * 10**_decimals;
45 	string private constant _name = "Blood Bank";
46 	string private constant _symbol = "BLOOD";
47 
48 	uint256 private _maxTx; 
49 	uint256 private _maxWallet;
50 
51 	uint256 private _swapThreshold = _totalSupply;
52 	uint256 private _swapLimit = _totalSupply;
53 
54 	uint8 private _taxRateBuy;
55 	uint8 private _taxRateSell;
56 
57 	mapping(address => bool) private _excluded;
58 	address private _treasuryWallet = address(0x35E6b861DbE175F64dEf1FAC5E2853e5613Eb764);
59 	address private constant _usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
60 	
61 	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 Router
62 	IUniswapV2Router02 private constant _swapRouter = IUniswapV2Router02(_swapRouterAddress);
63 	address private _primaryLP;
64 	mapping(address => bool) private _isLP;
65 	bool private _initialLiquidityAdded;
66 	
67 	uint256 private _openAt;
68 	uint256 private _protected;
69 
70 	bool private swapLocked;
71 	modifier lockSwap { swapLocked = true; _; swapLocked = false; }
72 
73 	constructor() OWNED(msg.sender)  {
74 		_balances[address(msg.sender)] = _totalSupply;
75 		emit Transfer(address(0), address(msg.sender), _balances[address(msg.sender)]);
76 
77 		_changeLimits(3,6); //set max TX to 0.3%, max wallet 0.6%
78 
79 		_excluded[_owner] = true;
80 		_excluded[address(this)] = true;
81 		_excluded[_swapRouterAddress] = true;
82 		_excluded[_treasuryWallet] = true;
83 
84 		_primaryLP = IUniswapV2Factory(_swapRouter.factory()).createPair(address(this), _usdc);
85 		_isLP[_primaryLP] = true;
86 	}
87 
88 	function addressList() external view returns (address owner, address treasury, address usdc, address swapRouter, address primaryLP) {
89 		return (_owner, _treasuryWallet, _usdc, _swapRouterAddress, _primaryLP);
90 	}
91 
92 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
93 	function decimals() external pure override returns (uint8) { return _decimals; }
94 	function symbol() external pure override returns (string memory) { return _symbol; }
95 	function name() external pure override returns (string memory) { return _name; }
96 	function balanceOf(address account) external view override returns (uint256) { return _balances[account]; }
97 	function allowance(address owner, address spender) external view override returns (uint256) { return _allowances[owner][spender]; }
98 	function approve(address spender, uint256 amount) public override returns (bool) {
99 		require(_balances[msg.sender] > 0,"ERC20: Zero balance");
100 		_approve(msg.sender, spender, amount);
101 		return true;
102 	}
103 	function _approve(address owner, address spender, uint256 amount ) private {
104 		require(owner != address(0) && spender != address(0), "ERC20: Zero address");
105 		_allowances[owner][spender] = amount;
106 		emit Approval(owner, spender, amount);
107 	}
108 	function _checkAndApproveRouter(uint256 tokenAmount) private {
109 		if (_allowances[address(this)][_swapRouterAddress] < tokenAmount) { 
110 			_approve(address(this), _swapRouterAddress, type(uint256).max);
111 		}
112 	}
113 
114 	function _checkAndApproveRouterForToken(address _token, uint256 amount) internal {
115 		uint256 tokenAllowance;
116 		if (_token == address(this)) {
117 			tokenAllowance = _allowances[address(this)][_swapRouterAddress];
118 			if (amount > tokenAllowance) {
119 				_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
120 			}
121 		} else {
122 			tokenAllowance = IERC20(_token).allowance(address(this), _swapRouterAddress);
123 			if (amount > tokenAllowance) {
124 				IERC20(_token).approve(_swapRouterAddress, type(uint256).max);
125 			}
126 		}
127     }
128 
129 	function transfer(address to, uint256 amount) public returns (bool) {
130 		_transfer(msg.sender, to, amount);
131 		return true;
132 	}
133 	function transferFrom(address from, address to, uint256 amount) public returns (bool) {
134 		require(_allowances[from][msg.sender] >= amount,"ERC20: amount exceeds allowance");
135 		_allowances[from][msg.sender] -= amount;
136 		_transfer(from, to, amount);
137 		return true;
138 	}
139 	function _transfer(address from, address to, uint256 amount) private {
140 		require(from != address(0) && to != address(0), "ERC20: Zero address"); 
141 		require(_balances[from] >= amount, "ERC20: amount exceeds balance"); 
142 		require(_limitCheck(from, to, amount), "Limits exceeded");
143 		require(block.timestamp>_openAt, "Not enabled");
144 
145 		if (block.timestamp>=_openAt && block.timestamp<_protected && tx.gasprice>block.basefee) {
146 			uint256 _gpb = tx.gasprice - block.basefee;
147 			uint256 _gpm = 10 * (10**9);
148 			require(_gpb<_gpm,"Not enabled");
149 		}
150 
151 		if ( !swapLocked && !_excluded[from] && _isLP[to] ) { _processTaxTokens(); }
152 
153 		uint256 taxTokens = _getTaxTokens(from, to, amount);
154 		_balances[from] -= amount;
155 		_balances[address(this)] += taxTokens;
156 		_balances[to] += (amount - taxTokens);
157 		emit Transfer(from, to, amount);
158 	}
159 	function _limitCheck(address from, address to, uint256 amount) private view returns (bool) {
160 		bool txSize = true;
161 		if ( amount > _maxTx && !_excluded[from] && !_excluded[to] ) { txSize = false; }
162 		bool walletSize = true;
163 		uint256 newBalanceTo = _balances[to] + amount;
164 		if ( newBalanceTo > _maxWallet && !_excluded[from] && !_excluded[to] && !_isLP[to] ) { walletSize = false; } 
165 		return (txSize && walletSize);
166 	}
167 
168 	function _getTaxTokens(address from, address to, uint256 amount) private view returns (uint256) {
169 		uint256 _taxTokensAmount;
170 		if ( (_isLP[from] && !_excluded[to]) ) { 
171             if (block.timestamp > _openAt + 120) { _taxTokensAmount = amount * _taxRateBuy / 100; }
172             else if (block.timestamp > _openAt) { _taxTokensAmount = amount * 99 / 100; } //antisnipe 99% tax for 120 seconds after trading opens
173 		} else if (_isLP[to] && !_excluded[from]) { 
174 			_taxTokensAmount = amount * _taxRateSell / 100; 
175 		}
176 		return _taxTokensAmount;
177 	}
178 
179 
180 	function addInitialLiquidity(uint256 val) external onlyOwner {
181 		require(IERC20(_usdc).balanceOf(address(this))>0, "No USDC");
182 		require(!_initialLiquidityAdded, "Liquidity already added");
183 		_addLiquidity(address(this), _balances[address(this)], IERC20(_usdc).balanceOf(address(this)), false);
184 		_initialLiquidityAdded = true;
185 
186 		_swapThreshold = _totalSupply * 5 / 10000;
187 		_swapLimit = _totalSupply * 25 / 10000;
188 
189 		_taxRateBuy = 10;
190 		_taxRateSell = 15; //anti-dump sell tax at launch
191 
192 		_openAt = block.timestamp + (val * 7 / 10) + 1662;
193 		_protected = _openAt + 600;
194 	}
195 
196 	function _addLiquidity(address _token, uint256 tokenAmount, uint256 usdcAmount, bool burnLpTokens) internal {
197 		require(IERC20(_token).balanceOf(address(this)) >= tokenAmount, "Not enough tokens");
198 		require(IERC20(_usdc).balanceOf(address(this)) >= usdcAmount, "Not enough USDC");
199 		_checkAndApproveRouterForToken(_token, tokenAmount);
200 		_checkAndApproveRouterForToken(_usdc, usdcAmount);
201 		address lpRecipient = _owner;
202 		if (burnLpTokens) { lpRecipient = address(0); }
203 
204 		_swapRouter.addLiquidity(_usdc, _token, usdcAmount, tokenAmount, 0, 0, lpRecipient, block.timestamp);
205 	}
206 
207 	function setPreLaunch(uint256 t1, uint256 t2) external onlyOwner {
208 		require(_openAt > block.timestamp, "already live");
209 		_openAt = block.timestamp + (t1 / t2) + 462;
210 		_protected = _openAt + 600;
211 	}
212 
213 	function tax() external view returns (uint8 buyTax, uint8 sellTax) { return (_taxRateBuy, _taxRateSell); }
214 	function limits() external view returns (uint256 maxTransaction, uint256 maxWallet) { return (_maxTx, _maxWallet); }
215 	function isExcluded(address wallet) external view returns (bool) { return _excluded[wallet]; }
216 
217 	function changeLimits(uint16 maxTxPermille, uint16 maxWalletPermille) external onlyOwner { _changeLimits(maxTxPermille, maxWalletPermille); }
218 	function _changeLimits(uint16 _maxTxPermille, uint16 _maxWalletPermille) private {
219 		uint256 newMaxTx = (_totalSupply * _maxTxPermille / 1000) + (10 * 10**_decimals); //add 10 tokens to avoid rounding issues
220 		uint256 newMaxWallet = (_totalSupply * _maxWalletPermille / 1000) + (10 * 10**_decimals); //add 10 tokens to avoid rounding issues
221 		require(newMaxTx >= _maxTx && newMaxWallet >= _maxWallet, "Cannot decrease limits");
222 		if (newMaxTx > _totalSupply) { newMaxTx = _totalSupply; }
223 		if (newMaxWallet > _totalSupply) { newMaxWallet = _totalSupply; }
224 		_maxTx = newMaxTx;
225 		_maxWallet = newMaxWallet;
226 	}
227 
228 	function changeTaxWallet(address walletTreasury) external onlyOwner {
229 		require(!_isLP[walletTreasury] && walletTreasury != _swapRouterAddress && walletTreasury != address(this) && walletTreasury != address(0));
230 		_excluded[walletTreasury] = true;
231 		_treasuryWallet = walletTreasury;
232 	}	
233 
234 	function changeTaxRates(uint8 newTaxRateBuy, uint8 newTaxRateSell) external onlyOwner {
235 		require( (newTaxRateBuy+newTaxRateSell) <= 20, "Max roundtrip is 20%" );
236 		_taxRateBuy = newTaxRateBuy;
237 		_taxRateSell = newTaxRateSell;
238 	}
239 	
240 	function _processTaxTokens() private lockSwap {
241 		uint256 tokensToSwap = _balances[address(this)];
242 		if (tokensToSwap >= _swapThreshold) {
243 			if (tokensToSwap > _swapLimit) { tokensToSwap = _swapLimit; }
244 			if (tokensToSwap >= 10**_decimals) {
245 				_swapTokens(address(this), _usdc, tokensToSwap, _treasuryWallet);
246 			}
247 		}
248 	}
249 
250 	function _swapTokens(address inputToken, address outputToken, uint256 inputAmount, address recipient) private {		
251 		_checkAndApproveRouterForToken(inputToken, inputAmount);
252 		address[] memory path = new address[](2);
253 		path[0] = inputToken;
254 		path[1] = outputToken;
255 		_swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
256 			inputAmount,
257 			0,
258 			path,
259 			recipient,
260 			block.timestamp
261 		);
262 	}
263 
264 	function recoverTokens(address tokenCa) external onlyOwner {
265 		require(tokenCa != address(this),"Not allowed");
266 		uint256 tokenBalance = IERC20(tokenCa).balanceOf(address(this));
267 		IERC20(tokenCa).transfer(msg.sender, tokenBalance);
268 	}
269 
270 	function manualSwap() external onlyOwner { _processTaxTokens(); }
271 
272 	function setExcluded(address wallet, bool exclude) external onlyOwner { 
273 		string memory notAllowedError = "Not allowed";
274 		require(!_isLP[wallet], notAllowedError);
275 		require(wallet != address(this), notAllowedError);
276 		require(wallet != _swapRouterAddress, notAllowedError);
277 	 	_excluded[wallet] = exclude; 
278 	}
279 
280 	function changeSwapThresholds(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
281 		_swapThreshold = _totalSupply * minValue / minDivider;
282 		_swapLimit = _totalSupply * maxValue / maxDivider;
283 		require(_swapLimit > _swapThreshold);
284 		require(_swapLimit <= _totalSupply * 5 / 1000); // limit must be less than 0.5% supply
285 	}
286 
287 	function burn(uint256 amount) external {
288 		require(_balances[msg.sender] >= amount, "Low balance");
289 		_balances[msg.sender] -= amount;
290 		_balances[address(0)] += amount;
291 		emit Transfer(msg.sender, address(0), amount);
292 	}
293 	function setAdditionalLP(address lpAddress, bool isLiqPool) external onlyOwner {
294 		string memory notAllowedError = "Not allowed";
295 		require(!_excluded[lpAddress], notAllowedError);
296 		require(lpAddress != _primaryLP, notAllowedError);
297 		require(lpAddress != address(this), notAllowedError);
298 		require(lpAddress != _swapRouterAddress, notAllowedError);
299 		_isLP[lpAddress] = isLiqPool;
300 	}
301 	function isLP(address ca) external view returns (bool) { return _isLP[ca]; }
302 }