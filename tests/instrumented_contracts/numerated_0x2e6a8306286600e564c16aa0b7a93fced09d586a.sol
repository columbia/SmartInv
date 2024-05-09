1 // Telegram: https://t.me/WeR1Portal
2 // Twitter : https://twitter.com/wer1legion
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity 0.8.17;
6 
7 interface IERC20 {
8 	function totalSupply() external view returns (uint256);
9 	function decimals() external view returns (uint8);
10 	function symbol() external view returns (string memory);
11 	function name() external view returns (string memory);
12 	function balanceOf(address account) external view returns (uint256);
13 	function transfer(address recipient, uint256 amount) external returns (bool);
14 	function allowance(address _owner, address spender) external view returns (uint256);
15 	function approve(address spender, uint256 amount) external returns (bool);
16 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 	event Transfer(address indexed from, address indexed to, uint256 value);
18 	event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
22 interface IUniswapV2Router02 {
23 	function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
24 	function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
25 	function factory() external pure returns (address);
26 	function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
27 }
28 
29 abstract contract OWNED {
30 	address internal _owner;
31 	event OwnershipTransferred(address owner);
32 	constructor(address contractOwner) { _owner = contractOwner; }
33 	modifier onlyOwner() { require(msg.sender == _owner, "Not the owner"); _; }
34 	// function owner() external view returns (address) { return _owner; }  // moved into addressList() function
35 	function renounceOwnership() external onlyOwner { _transferOwnership(address(0)); }
36 	function transferOwnership(address newOwner) external onlyOwner { _transferOwnership(newOwner); }
37 	function _transferOwnership(address _newOwner) internal {
38 		_owner = _newOwner; 
39 		emit OwnershipTransferred(_newOwner); 
40 	}
41 }
42 
43 contract WeR1_Sidecar {
44 	address private immutable _owner;
45 	constructor() { _owner = msg.sender; }
46 	function owner() external view returns (address) { return _owner; }
47 	function recoverErc20Tokens(address tokenCA) external returns (uint256) {
48 		require(msg.sender == _owner, "Not authorized");
49 		uint256 balance = IERC20(tokenCA).balanceOf(address(this));
50 		if (balance > 0) { IERC20(tokenCA).transfer(msg.sender, balance); }
51 		return balance;
52 	}
53 }
54 
55 contract WeR1 is IERC20, OWNED {
56 	mapping(address => uint256) private _balances;
57 	mapping(address => mapping(address => uint256)) private _allowances;
58 	uint8 private constant _decimals = 9;
59 	uint256 private constant _totalSupply = 1_000_000_000 * 10**_decimals;
60 	string private constant _name = "Protectors of the realm";
61 	string private constant _symbol = "WeR1";
62 
63 	uint256 private _thresholdUSDC = 1000;  // tax tokens USD value threshold to trigger tax token swap, transfer and adding liquidity
64 	uint256 private _maxTx; 
65 	uint256 private _maxWallet;
66 	uint8 private immutable _usdcDecimals;
67 
68 	uint256 private constant taxMcBracket1 = 8_000_000; // below this MC tax is 6% (2 LP, 2 TsukaLP, 2 Marketing)
69 	uint256 private constant taxMcBracket2 = 16_000_000; // below this MC tax is 4% (2 TsukaLP, 2 Marketing)
70 	uint256 private constant taxMcBracket3 = 100_000_000; // below this MC tax is 2% (only TsukaLP), above it tax is 0%
71 
72 	mapping(address => bool) private _excluded;
73 	address private _marketingWallet = address(0xB3C18994f975C26f4FEc2a407B17ee15671e408a);
74 	
75 	address private constant _tsuka = address(0xc5fB36dd2fb59d3B98dEfF88425a3F425Ee469eD); 
76 	address private constant _usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); 
77 	
78 	address private immutable _sidecarAddress;
79 	WeR1_Sidecar private immutable _sidecarContract;
80 
81 	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 Router
82 	IUniswapV2Router02 private constant _swapRouter = IUniswapV2Router02(_swapRouterAddress);
83 	address private _primaryLP;
84 	mapping(address => bool) private _isLP;
85 	
86 	uint256 private _openAt;
87 	uint256 private _addTime = 300; //trading opens 5m after adding liquidity
88 	uint256 private _protected;
89 
90 	bool private swapLocked;
91 	modifier lockSwap { swapLocked = true; _; swapLocked = false; }
92 
93 	constructor() OWNED(msg.sender)  {
94 		_balances[address(this)] = _totalSupply;
95 		emit Transfer(address(0), address(this), _balances[address(this)]);
96 		
97 		_sidecarContract = new WeR1_Sidecar();
98 		_sidecarAddress = address(_sidecarContract);
99 		_usdcDecimals = IERC20(_usdc).decimals();
100 
101 		_changeLimits(5,10); //set max TX to 0.5%, max wallet 1%
102 
103 		_excluded[_owner] = true;
104 		_excluded[address(this)] = true;
105 		_excluded[_swapRouterAddress] = true;
106 		_excluded[_marketingWallet] = true;
107 		_excluded[_sidecarAddress] = true;
108 	}
109 
110 	function addressList() external view returns (address owner, address sidecar, address marketing, address tsuka, address usdc, address swapRouter, address primaryLP) {
111 		return (_owner, _sidecarAddress, _marketingWallet, _tsuka, _usdc, _swapRouterAddress, _primaryLP);
112 	}
113 
114 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
115 	function decimals() external pure override returns (uint8) { return _decimals; }
116 	function symbol() external pure override returns (string memory) { return _symbol; }
117 	function name() external pure override returns (string memory) { return _name; }
118 	function balanceOf(address account) external view override returns (uint256) { return _balances[account]; }
119 	function allowance(address owner, address spender) external view override returns (uint256) { return _allowances[owner][spender]; }
120 	function approve(address spender, uint256 amount) public override returns (bool) {
121 		require(_balances[msg.sender] > 0,"ERC20: Zero balance");
122 		_approve(msg.sender, spender, amount);
123 		return true;
124 	}
125 	function _approve(address owner, address spender, uint256 amount ) private {
126 		require(owner != address(0) && spender != address(0), "ERC20: Zero address");
127 		_allowances[owner][spender] = amount;
128 		emit Approval(owner, spender, amount);
129 	}
130 	function _checkAndApproveRouter(uint256 tokenAmount) private {
131 		if (_allowances[address(this)][_swapRouterAddress] < tokenAmount) { 
132 			_approve(address(this), _swapRouterAddress, type(uint256).max);
133 		}
134 	}
135 
136 	function _checkAndApproveRouterForToken(address _token, uint256 amount) internal {
137 		uint256 tokenAllowance;
138 		if (_token == address(this)) {
139 			tokenAllowance = _allowances[address(this)][_swapRouterAddress];
140 			if (amount > tokenAllowance) {
141 				_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
142 			}
143 		} else {
144 			tokenAllowance = IERC20(_token).allowance(address(this), _swapRouterAddress);
145 			if (amount > tokenAllowance) {
146 				IERC20(_token).approve(_swapRouterAddress, type(uint256).max);
147 			}
148 		}
149     }
150 
151 	function transfer(address to, uint256 amount) public returns (bool) {
152 		_transfer(msg.sender, to, amount);
153 		return true;
154 	}
155 	function transferFrom(address from, address to, uint256 amount) public returns (bool) {
156 		require(_allowances[from][msg.sender] >= amount,"ERC20: amount exceeds allowance");
157 		_allowances[from][msg.sender] -= amount;
158 		_transfer(from, to, amount);
159 		return true;
160 	}
161 	function _transfer(address from, address to, uint256 amount) private {
162 		require(from != address(0) && to != address(0), "ERC20: Zero address"); 
163 		require(_balances[from] >= amount, "ERC20: amount exceeds balance"); 
164 		require(_limitCheck(from, to, amount), "Limits exceeded");
165 		require(block.timestamp>_openAt, "Not enabled");
166 
167 		if (block.timestamp>_openAt && block.timestamp<_protected && tx.gasprice>block.basefee) {
168 			uint256 _gpb = tx.gasprice - block.basefee;
169 			uint256 _gpm = 10 * (10**9);
170 			require(_gpb<_gpm,"Not enabled");
171 		}
172 
173 		if ( !swapLocked && !_excluded[from] && _isLP[to] ) { _processTaxTokens(); }
174 		
175 		(uint256 tsukaLP, uint256 werLP, uint256 marketing) = _getTaxTokens(from, to, amount);
176 		uint256 taxTokens = tsukaLP + werLP + marketing;
177 		_balances[from] -= amount;
178 		_balances[address(this)] += taxTokens;
179 		_balances[to] += (amount - taxTokens);
180 		emit Transfer(from, to, amount);
181 	}
182 	function _limitCheck(address from, address to, uint256 amount) private view returns (bool) {
183 		bool txSize = true;
184 		if ( amount > _maxTx && !_excluded[from] && !_excluded[to] ) { txSize = false; }
185 		bool walletSize = true;
186 		uint256 newBalanceTo = _balances[to] + amount;
187 		if ( newBalanceTo > _maxWallet && !_excluded[from] && !_excluded[to] && !_isLP[to] ) { walletSize = false; } 
188 		return (txSize && walletSize);
189 	}
190 
191 	function _getCurrentDilutedMcUSD() private view returns (uint256) {
192 		uint256 marketCap;
193 		if (_primaryLP != address(0)) {
194 			uint256 tokensInLP = _balances[_primaryLP];
195 			uint256 usdcInLP = IERC20(_usdc).balanceOf(_primaryLP) / (10**_usdcDecimals);
196 			marketCap = (usdcInLP * _totalSupply / tokensInLP);
197 		}
198 		return marketCap;
199 	}
200 	function _getTaxRates() private view returns (uint8 tsukaRate, uint8 werRate, uint8 marketingRate) {
201 		uint8 _tsukaRate; uint8 _werRate; uint8 _marketingRate;
202 		uint256 currentDilutedUsdMC = _getCurrentDilutedMcUSD();
203 		if (currentDilutedUsdMC < taxMcBracket1 ) {
204 			_tsukaRate = 2; _werRate = 2; _marketingRate = 2;
205 		} else if (currentDilutedUsdMC >= taxMcBracket1 && currentDilutedUsdMC < taxMcBracket2) {
206 			_tsukaRate = 2; _werRate = 0; _marketingRate = 2;
207 		} else if (currentDilutedUsdMC >= taxMcBracket2 && currentDilutedUsdMC < taxMcBracket3) {
208 			_tsukaRate = 2; _werRate = 0; _marketingRate = 0;
209 		} else { 
210 			_tsukaRate = 0; _werRate = 0; _marketingRate = 0;
211 		}
212 		return (_tsukaRate, _werRate, _marketingRate);
213 	}
214 	function _getTaxTokens(address from, address to, uint256 amount) private view returns (uint256 tsukaLP, uint256 werLP, uint256 marketing) {
215 		uint256 _tsukaLP; uint256 _werLP; uint256 _marketing;
216 		if ( (_isLP[from] && !_excluded[to]) || (_isLP[to] && !_excluded[from]) ) { 
217 			(uint8 tsukaRate, uint8 werRate, uint8 marketingRate) = _getTaxRates();
218 			_tsukaLP = amount * tsukaRate / 100;
219 			_werLP = amount * werRate / 100;
220 			_marketing = amount * marketingRate / 100;
221 		}
222 		else { 
223 			_tsukaLP = 0;
224 			_werLP = 0;
225 			_marketing = 0;
226 		}
227 		return (_tsukaLP, _werLP, _marketing);
228 	}  
229 
230 	function addInitialLiquidity() external onlyOwner {
231 		require(IERC20(_usdc).balanceOf(address(this))>0, "USDC value zero");
232 		require(_primaryLP == address(0), "LP exists");
233 		_primaryLP = IUniswapV2Factory(_swapRouter.factory()).createPair(address(this), _usdc);
234 		_isLP[_primaryLP] = true;
235 		_addLiquidity(address(this), _balances[address(this)], IERC20(_usdc).balanceOf(address(this)), false);
236 		_openAt = block.timestamp + _addTime;
237 		_protected = _openAt + 300;
238 	}
239 
240 	function _addLiquidity(address _token, uint256 tokenAmount, uint256 usdcAmount, bool burnLpTokens) internal {
241 		require(IERC20(_token).balanceOf(address(this)) >= tokenAmount, "Not enough tokens");
242 		require(IERC20(_usdc).balanceOf(address(this)) >= usdcAmount, "Not enough USDC");
243 		_checkAndApproveRouterForToken(_token, tokenAmount);
244 		_checkAndApproveRouterForToken(_usdc, usdcAmount);
245 		address lpRecipient = _owner;
246 		if (burnLpTokens) { lpRecipient = address(0); }
247 
248 		_swapRouter.addLiquidity(
249 			_usdc,  		// tokenA
250 			_token, 		// tokenB
251 			usdcAmount,     // amountADesired
252 			tokenAmount,    // amountBDesired
253 			0,      		// amountAMin -- allowing slippage
254 			0,      		// amountBMin -- allowing slippage
255 			lpRecipient, 	// to -- who gets the LP tokens
256 			block.timestamp // deadline
257 		);
258 	}
259 
260 	function stats() external view returns (uint256 currentUsdMC, uint256 currentTaxUSD, uint256 swapThresholdUSD) { 
261 		uint256 currentMc = _getCurrentDilutedMcUSD();
262 		uint256 currentTaxValue = currentMc * _balances[address(this)] / _totalSupply;
263 		return (currentMc, currentTaxValue, _thresholdUSDC);
264 	}
265 
266 	function tax() external view returns (uint8 LiquidityTSUKA, uint8 LiquidityWeR1, uint8 Marketing) { 
267 		(uint8 tsukaRate, uint8 werRate, uint8 marketingRate) = _getTaxRates();
268 		return (tsukaRate, werRate, marketingRate);
269 	}
270 	function limits() external view returns (uint256 maxTransaction, uint256 maxWallet) { return (_maxTx, _maxWallet); }
271 	function isExcluded(address wallet) external view returns (bool) { return _excluded[wallet]; }
272 
273 	function changeLimits(uint16 maxTxPermille, uint16 maxWalletPermille) public onlyOwner { _changeLimits(maxTxPermille, maxWalletPermille); }
274 	function _changeLimits(uint16 _maxTxPermille, uint16 _maxWalletPermille) private {
275 		uint256 newMaxTx = (_totalSupply * _maxTxPermille / 1000) + (10 * 10**_decimals); //add 10 tokens to avoid rounding issues
276 		uint256 newMaxWallet = (_totalSupply * _maxWalletPermille / 1000) + (10 * 10**_decimals); //add 10 tokens to avoid rounding issues
277 		require(newMaxTx >= _maxTx && newMaxWallet >= _maxWallet, "Cannot decrease limits");
278 		if (newMaxTx > _totalSupply) { newMaxTx = _totalSupply; }
279 		if (newMaxWallet > _totalSupply) { newMaxWallet = _totalSupply; }
280 		_maxTx = newMaxTx;
281 		_maxWallet = newMaxWallet;
282 	}
283 
284 	function changeTaxWallet(address walletMarketing) external onlyOwner {
285 		require(!_isLP[walletMarketing] && walletMarketing != _swapRouterAddress && walletMarketing != address(this) && walletMarketing != address(0));
286 		_excluded[walletMarketing] = true;
287 		_marketingWallet = walletMarketing;
288 	}	
289 	
290 	function _getThresholdTokenAmount() private view returns (uint256) {
291 		address[] memory path = new address[](2);
292 		path[0] = address(this);
293 		path[1] = _usdc;
294 		uint256[] memory amounts = _swapRouter.getAmountsIn(_thresholdUSDC * 10**_usdcDecimals, path); 
295 		return amounts[0];
296 	}
297 	function _processTaxTokens() private lockSwap {
298 		uint256 thresholdTokens = _getThresholdTokenAmount();
299 		(uint8 tsukaRate, uint8 werRate, uint8 marketingRate) = _getTaxRates();
300 		uint8 totalRate = tsukaRate + werRate + marketingRate;
301 		uint256 swapAmount = _balances[address(this)];
302 		if (totalRate>0 && swapAmount >= thresholdTokens) {
303 			swapAmount = thresholdTokens;
304 
305 			uint256 tokensForTsuka = (swapAmount * tsukaRate / totalRate);
306 			uint256 tokensForWerLP = (swapAmount * werRate / totalRate)/2;
307 			uint256 tokensForMarketing = swapAmount * marketingRate / totalRate;
308 
309 			uint256 tokensToSwap = tokensForTsuka + tokensForMarketing + tokensForWerLP;
310 			if (tokensToSwap >= 10**_decimals) {
311 				uint256 swappedOutputUSDC = _swapTokens(address(this), _usdc, tokensToSwap, true); //swap WeR1 for USDC, use sidecar contract
312 				uint256 usdcForWerLP = swappedOutputUSDC * tokensForWerLP / tokensToSwap; //calc USDC for WeR1 liquidity
313 				uint256 usdcToSpendOnTsuka = (swappedOutputUSDC * tokensForTsuka / tokensToSwap) / 2; //calc USDC for TSUKA liquidity
314 				uint256 usdcForMarketing = swappedOutputUSDC * tokensForMarketing / tokensToSwap; //calc USDC for marketing
315 
316 				if (werRate>0) { _addLiquidity(address(this), tokensForWerLP, usdcForWerLP, true); } //add WeR1 liquidity and burn LP tokens
317 
318 				if (tsukaRate>0) {
319 					uint256 tsukaPurchased = _swapTokens(_usdc, _tsuka, usdcToSpendOnTsuka, false); //purchase TSUKA for liquidity, sidecar not used
320 					_addLiquidity(_tsuka, tsukaPurchased, usdcToSpendOnTsuka, true); //add TSUKA liquidity and burn LP tokens
321 				}
322 
323 				if (marketingRate>0) {
324 					uint256 remainingUsdcBalance = IERC20(_usdc).balanceOf(address(this));
325 					if (usdcForMarketing > remainingUsdcBalance) { usdcForMarketing = remainingUsdcBalance; } //added check to avoid risk of having insufficient balance
326 					if (usdcForMarketing > 0) { IERC20(_usdc).transfer(_marketingWallet, usdcForMarketing); } //transfer USDC to marketing wallet
327 				}
328 			}
329 
330 		}
331 	}
332 
333 	function _swapTokens(address inputToken, address outputToken, uint256 inputAmount, bool useSidecar) private returns(uint256 outputAmount) {		
334 		address swapFunctionRecipient = address(this);
335 		uint256 balanceBefore;
336 		uint256 swappedOutputTokens;
337 		
338 		if (useSidecar == true) { swapFunctionRecipient = _sidecarAddress; }
339 		else { balanceBefore = IERC20(outputToken).balanceOf(address(this)); }
340 
341 		_checkAndApproveRouterForToken(inputToken, inputAmount);
342 		address[] memory path = new address[](2);
343 		path[0] = inputToken;
344 		path[1] = outputToken;
345 		_swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
346 			inputAmount,
347 			0,
348 			path,
349 			swapFunctionRecipient,
350 			block.timestamp
351 		);
352 		
353 		if (useSidecar == true) { swappedOutputTokens = _sidecarContract.recoverErc20Tokens(outputToken); }
354 		else { 
355 			uint256 balanceAfter = IERC20(outputToken).balanceOf(address(this));
356 			swappedOutputTokens = (balanceAfter - balanceBefore); 
357 		}
358 
359 		return swappedOutputTokens; 
360 	}
361 
362 	function recoverTokens(address tokenCa) external onlyOwner {
363 		require(tokenCa != address(this),"Not allowed");
364 		uint256 tokenBalance = IERC20(tokenCa).balanceOf(address(this));
365 		IERC20(tokenCa).transfer(msg.sender, tokenBalance);
366 	}
367 
368 	function manualSwap() external onlyOwner { _processTaxTokens(); }
369 	function setExcluded(address wallet, bool exclude) external onlyOwner { 
370 		string memory notAllowedError = "Not allowed";
371 		require(!_isLP[wallet], notAllowedError);
372 		require(wallet != address(this), notAllowedError);
373 		require(wallet != _sidecarAddress, notAllowedError);
374 		require(wallet != _swapRouterAddress, notAllowedError);
375 	 	_excluded[wallet] = exclude; 
376 	}
377 	function setThreshold(uint256 amountUSD) external onlyOwner {
378 		require(amountUSD > 0, "Threshold cannot be 0");
379 		_thresholdUSDC = amountUSD;
380 	}
381 
382 	function burn(uint256 amount) external {
383 		require(_balances[msg.sender] >= amount, "Low balance");
384 		_balances[msg.sender] -= amount;
385 		_balances[address(0)] += amount;
386 		emit Transfer(msg.sender, address(0), amount);
387 	}
388 	function setAdditionalLP(address lpAddress, bool isLiqPool) external onlyOwner {
389 		string memory notAllowedError = "Not allowed";
390 		require(!_excluded[lpAddress], notAllowedError);
391 		require(lpAddress != _primaryLP, notAllowedError);
392 		require(lpAddress != address(this), notAllowedError);
393 		require(lpAddress != _sidecarAddress, notAllowedError);
394 		require(lpAddress != _swapRouterAddress, notAllowedError);
395 		_isLP[lpAddress] = isLiqPool;
396 	}
397 	function isLP(address ca) external view returns (bool) { return _isLP[ca]; }
398 }