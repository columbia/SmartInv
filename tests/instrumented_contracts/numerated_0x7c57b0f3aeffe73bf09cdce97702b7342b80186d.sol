1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 interface IERC20 {
6 	function totalSupply() external view returns (uint256);
7 	function decimals() external view returns (uint8);
8 	function symbol() external view returns (string memory);
9 	function name() external view returns (string memory);
10 	function balanceOf(address account) external view returns (uint256);
11 	function transfer(address recipient, uint256 amount) external returns (bool);
12 	function allowance(address __owner, address spender) external view returns (uint256);
13 	function approve(address spender, uint256 amount) external returns (bool);
14 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Approval(address indexed _owner, address indexed spender, uint256 value);
17 }
18 
19 abstract contract Auth {
20 	address internal _owner;
21 	constructor(address creatorOwner) { _owner = creatorOwner; }
22 	modifier onlyOwner() { require(msg.sender == _owner, "Only contract _owner can call this function"); _; }
23 	function transferOwnership(address payable newOwner) external onlyOwner { _owner = newOwner; emit OwnershipTransferred(newOwner); }
24 	event OwnershipTransferred(address _owner);
25 }
26 
27 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
28 interface IUniswapV2Router02 {
29 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
30 	function WETH() external pure returns (address);
31 	function factory() external pure returns (address);
32 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
33 }
34 
35 contract KOTJ is IERC20, Auth {
36 	uint8 private constant _decimals      = 9;
37 	uint256 private constant _totalSupply = 1_000_000_000 * (10**_decimals);
38 	string private constant _name         = "King of the Jungle";
39 	string private constant _symbol       = "KOTJ";
40 
41 	uint8 private _buyTaxRate  = 6;
42 	uint8 private _sellTaxRate = 6;
43 
44 	uint16 private _taxSharesMarketing   = 2;
45 	uint16 private _taxSharesDevelopment = 1;
46 	uint16 private _taxSharesBurn        = 1;
47 	uint16 private _taxSharesLP          = 1;
48 	uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesBurn + _taxSharesLP;
49 
50 	address payable private _walletMarketing = payable(0x36617691F3B9655d87e086620604671F9EE02170); 
51 	address payable private _walletDevelopment = payable(0xF73DCbD7ed8C0ba068eB5F9215CfdAa8b2cCBDef); 
52 
53 	uint256 private _maxTxAmount     = _totalSupply; 
54 	uint256 private _maxWalletAmount = _totalSupply;
55 	uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
56 	uint256 private _taxSwapMax = _totalSupply * 85 / 100000;
57 
58 	mapping (address => uint256) private _balances;
59 	mapping (address => mapping (address => uint256)) private _allowances;
60 	mapping (address => bool) private _noFees;
61 	mapping (address => bool) private _noLimits;
62 
63 	address constant private _burnWallet = address(0);
64 	address private _lpOwner;
65 
66 	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //uniswap v2 router
67 	IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
68 	address private _primaryLP;
69 	mapping (address => bool) private _isLP;
70 
71 	bool private _tradingOpen;
72 
73 	bool private _inTaxSwap = false;
74 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
75 
76 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
77 	event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
78 
79 	constructor() Auth(msg.sender) {
80 		_lpOwner = msg.sender;
81 
82 		_balances[address(this)] =  750_000_000 * (10 ** _decimals);
83 		emit Transfer(address(0), address(this), _balances[address(this)]);
84 
85 		_balances[_owner] = _totalSupply - _balances[address(this)];
86 		emit Transfer(address(0), _owner, _balances[_owner]);
87 
88 		_noFees[_owner] = true;
89 		_noFees[address(this)] = true;
90 		_noFees[_swapRouterAddress] = true;
91 		_noFees[_walletMarketing] = true;
92 		_noFees[_walletDevelopment] = true;
93 		_noFees[_burnWallet] = true;
94 		_noLimits[_owner] = true;
95 		_noLimits[address(this)] = true;
96 		_noLimits[_swapRouterAddress] = true;
97 		_noLimits[_walletMarketing] = true;
98 		_noLimits[_walletDevelopment] = true;
99 		_noLimits[_burnWallet] = true;	
100 	}
101 
102 	receive() external payable {}
103 	
104 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
105 	function decimals() external pure override returns (uint8) { return _decimals; }
106 	function symbol() external pure override returns (string memory) { return _symbol; }
107 	function name() external pure override returns (string memory) { return _name; }
108 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
109 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
110 
111 	function approve(address spender, uint256 amount) public override returns (bool) {
112 		_allowances[msg.sender][spender] = amount;
113 		emit Approval(msg.sender, spender, amount);
114 		return true;
115 	}
116 
117 	function transfer(address recipient, uint256 amount) external override returns (bool) {
118 		require(_checkTradingOpen(msg.sender), "Trading not open");
119 		return _transferFrom(msg.sender, recipient, amount);
120 	}
121 
122 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
123 		require(_checkTradingOpen(sender), "Trading not open");
124 		if(_allowances[sender][msg.sender] != type(uint256).max){
125 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
126 		}
127 		return _transferFrom(sender, recipient, amount);
128 	}
129 
130 	function openTrading() external onlyOwner {
131 		require(!_tradingOpen, "trading already open");
132 		_openTrading();
133 	}
134 
135 	function _approveRouter(uint256 _tokenAmount) internal {
136 		if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
137 			_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
138 			emit Approval(address(this), _swapRouterAddress, type(uint256).max);
139 		}
140 	}
141 
142 	function addInitialLiquidity() external onlyOwner lockTaxSwap {
143 		require(_primaryLP == address(0), "LP exists");
144 		require(address(this).balance>0, "No ETH in contract");
145 		require(_balances[address(this)]>0, "No tokens in contract");
146 		_primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
147 		_addLiquidity(_balances[address(this)], address(this).balance, false);
148 		_isLP[_primaryLP] = true;
149 	}
150 
151 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
152 		address lpTokenRecipient = _lpOwner;
153 		if ( autoburn ) { lpTokenRecipient = address(0); }
154 		_approveRouter(_tokenAmount);
155 		_primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
156 	}
157 
158 	function _openTrading() internal {
159 		_maxTxAmount     = _totalSupply * 1 / 100; 
160 		_maxWalletAmount = _totalSupply * 1 / 100;
161 		_tradingOpen = true;
162 	}
163 
164 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
165 		require(sender != address(0), "No transfers from Zero wallet");
166 		if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
167 		if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
168 		
169 		if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
170 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
171 		uint256 _transferAmount = amount - _taxAmount;
172 		_balances[sender] = _balances[sender] - amount;
173 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
174 		_balances[recipient] = _balances[recipient] + _transferAmount;
175 		emit Transfer(sender, recipient, amount);
176 		return true;
177 	}
178 
179 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
180 		bool limitCheckPassed = true;
181 		if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
182 			if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
183 			else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
184 		}
185 		return limitCheckPassed;
186 	}
187 
188 	function _checkTradingOpen(address sender) private view returns (bool){
189 		bool checkResult = false;
190 		if ( _tradingOpen ) { checkResult = true; } 
191 		else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
192 
193 		return checkResult;
194 	}
195 
196 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
197 		uint256 taxAmount;
198 		if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
199 		else if ( _isLP[sender] ) { taxAmount = amount * _buyTaxRate / 100; }
200 		else if ( _isLP[recipient] ) { taxAmount = amount * _sellTaxRate / 100; }
201 		return taxAmount;
202 	}
203 
204 
205 	function getExemptions(address wallet) external view returns (bool noFees, bool noLimits) {
206 		return ( _noFees[wallet], _noLimits[wallet] );
207 	}
208 	function setExemptions(address wallet, bool noFees, bool noLimits) external onlyOwner {
209 		if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
210 		_noFees[ wallet ] = noFees;
211 		_noLimits[ wallet ] = noLimits;
212 	}
213 	function setExtraLP(address lpContractAddress, bool isLiquidityPool) external onlyOwner { 
214 		require(lpContractAddress != _primaryLP, "Cannot change the primary LP");
215 		_isLP[lpContractAddress] = isLiquidityPool; 
216 		if (isLiquidityPool) { 
217 			_noFees[lpContractAddress] = false; 
218 			_noLimits[lpContractAddress] = false; 
219 		}
220 	}
221 	function isLP(address wallet) external view returns (bool) {
222 		return _isLP[wallet];
223 	}
224 
225 	function getTaxInfo() external view returns (uint8 buyTax, uint8 sellTax, uint16 sharesMarketing, uint16 sharesDevelopment, uint16 sharesLP, uint16 sharesTokenBurn ) {
226 		return ( _buyTaxRate, _sellTaxRate, _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP, _taxSharesBurn);
227 	}
228 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
229 		require(newBuyTax + newSellTax <= 20, "Roundtrip too high");
230 		_buyTaxRate = newBuyTax;
231 		_sellTaxRate = newSellTax;
232 	}  
233 	function setTaxDistribution(uint16 sharesTokenBurn, uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
234 		_taxSharesLP = sharesAutoLP;
235 		_taxSharesMarketing = sharesMarketing;
236 		_taxSharesDevelopment = sharesDevelopment;
237 		_totalTaxShares = sharesTokenBurn + sharesAutoLP + sharesMarketing + sharesDevelopment;
238 	}
239 
240 	function getAddresses() external view returns (address owner, address primaryLP, address marketing, address development, address LPowner ) {
241 		return ( _owner, _primaryLP, _walletMarketing, _walletDevelopment, _lpOwner);
242 	}
243 	function setTaxWallets(address newMarketing, address newDevelopment, address newLpOwner) external onlyOwner {
244 		require(!_isLP[newMarketing] && !_isLP[newDevelopment] && !_isLP[newLpOwner], "LP cannot be tax wallet");
245 		_walletMarketing = payable(newMarketing);
246 		_walletDevelopment = payable(newDevelopment);
247 		_lpOwner = newLpOwner;
248 		_noFees[newMarketing] = true;
249 		_noFees[newDevelopment] = true;
250 		_noLimits[newMarketing] = true;
251 		_noLimits[newDevelopment] = true;
252 	}
253 
254 	function getLimitsInfo() external view returns (uint256 maxTX, uint256 maxWallet, uint256 taxSwapMin, uint256 taxSwapMax ) {
255 		return ( _maxTxAmount, _maxWalletAmount, _taxSwapMin, _taxSwapMax);
256 	}
257 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
258 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
259 		require(newTxAmt >= _maxTxAmount, "tx limit too low");
260 		_maxTxAmount = newTxAmt;
261 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
262 		require(newWalletAmt >= _maxWalletAmount, "wallet limit too low");
263 		_maxWalletAmount = newWalletAmt;
264 	}
265 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
266 		_taxSwapMin = _totalSupply * minValue / minDivider;
267 		_taxSwapMax = _totalSupply * maxValue / maxDivider;
268 		require(_taxSwapMax>=_taxSwapMin, "MinMax error");
269 		require(_taxSwapMax>_totalSupply / 100000, "Upper threshold too low");
270 		require(_taxSwapMax<_totalSupply / 100, "Upper threshold too high");
271 	}
272 
273 	function _burnTokens(address fromWallet, uint256 amount) private {
274 		if ( amount > 0 ) {
275 			_balances[fromWallet] -= amount;
276 			_balances[_burnWallet] += amount;
277 			emit Transfer(fromWallet, _burnWallet, amount);
278 		}
279 	}
280 
281 	function _swapTaxAndLiquify() private lockTaxSwap {
282 		uint256 _taxTokensAvailable = balanceOf(address(this));
283 
284 		if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
285 			if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
286 
287 			uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
288 			uint256 _tokensToBurn = _taxTokensAvailable * _taxSharesBurn / _totalTaxShares;
289 			_burnTokens(address(this), _tokensToBurn);
290 			
291 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP - _tokensToBurn;
292 			if( _tokensToSwap > 10**_decimals ) {
293 				uint256 _ethPreSwap = address(this).balance;
294 				_swapTaxTokensForEth(_tokensToSwap);
295 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
296 				if ( _taxSharesLP > 0 ) {
297 					uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
298 					_approveRouter(_tokensForLP);
299 					_addLiquidity(_tokensForLP, _ethWeiAmount, false);
300 				}
301 			}
302 			uint256 _contractETHBalance = address(this).balance;
303 			if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
304 		}
305 	}
306 
307 	function _swapTaxTokensForEth(uint256 tokenAmount) private {
308 		_approveRouter(tokenAmount);
309 		address[] memory path = new address[](2);
310 		path[0] = address(this);
311 		path[1] = _primarySwapRouter.WETH();
312 		_primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
313 	}
314 
315 	function _distributeTaxEth(uint256 amount) private {
316 		uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
317 		if (_taxShareTotal > 0) {
318 			uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
319 			uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
320 			if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
321 			if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
322 		}
323 	}
324 
325 	function manualTaxSwapAndSend(bool swapTokens, bool sendEth) external onlyOwner {
326 		if (swapTokens) {
327 			uint256 taxTokenBalance = balanceOf(address(this));
328 			require(taxTokenBalance > 0, "No tokens");
329 			_swapTaxTokensForEth(taxTokenBalance);
330 		}
331 		if (sendEth) { 
332 			uint256 ethBalance = address(this).balance;
333 			require(ethBalance > 0, "No tokens");
334 			_distributeTaxEth(address(this).balance); 
335 		}
336 	}
337 
338 	function burnTokens(uint256 amount) external {
339 		uint256 _tokensAvailable = balanceOf(msg.sender);
340 		require(amount <= _tokensAvailable, "Token balance too low");
341 		_burnTokens(msg.sender, amount);
342 		emit TokensBurned(msg.sender, amount);
343 	}
344 
345 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
346         require(addresses.length <= 250,"Wallet count over 250 (gas risk)");
347         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
348 
349         uint256 airdropTotal = 0;
350         for(uint i=0; i < addresses.length; i++){
351             airdropTotal += (tokenAmounts[i] * 10**_decimals);
352         }
353         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
354 
355         for(uint i=0; i < addresses.length; i++){
356             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
357             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
358 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
359         }
360 
361         emit TokensAirdropped(addresses.length, airdropTotal);
362     }
363 }