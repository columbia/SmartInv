1 //SPDX-License-Identifier: MIT
2 
3 /*
4 
5 So they told me this was a bullish deployer, and my wife left me this evening, and i could do with the eth, so here we go DEGEM v2 LFG lets have some fun chads
6 
7  https://t.me/degemETH
8 
9 
10 */
11 pragma solidity 0.8.17;
12 
13 interface IERC20 {
14 	function totalSupply() external view returns (uint256);
15 	function decimals() external view returns (uint8);
16 	function symbol() external view returns (string memory);
17 	function name() external view returns (string memory);
18 	function balanceOf(address account) external view returns (uint256);
19 	function transfer(address recipient, uint256 amount) external returns (bool);
20 	function allowance(address __owner, address spender) external view returns (uint256);
21 	function approve(address spender, uint256 amount) external returns (bool);
22 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 	event Transfer(address indexed from, address indexed to, uint256 value);
24 	event Approval(address indexed _owner, address indexed spender, uint256 value);
25 }
26 
27 abstract contract Auth {
28 	address internal _owner;
29 	constructor(address creatorOwner) { _owner = creatorOwner; }
30 	modifier onlyOwner() { require(msg.sender == _owner, "Only contract _owner can call this function"); _; }
31 	function transferOwnership(address payable newOwner) external onlyOwner { _owner = newOwner; emit OwnershipTransferred(newOwner); }
32 	event OwnershipTransferred(address _owner);
33 }
34 
35 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
36 interface IUniswapV2Router02 {
37 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
38 	function WETH() external pure returns (address);
39 	function factory() external pure returns (address);
40 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41 }
42 
43 contract DGM is IERC20, Auth {
44 	uint8 private constant _decimals      = 9;
45 	uint256 private constant _totalSupply = 80_085 * (10**_decimals);
46 	string private constant _name         = "DEGEM V2";
47 	string private constant _symbol       = "DGM";
48 
49 	uint8 private _buyTaxRate  = 11;
50 	uint8 private _sellTaxRate = 11;
51 
52 	uint16 private _taxSharesMarketing   = 100;
53 	uint16 private _taxSharesDevelopment = 0;
54 	uint16 private _taxSharesBurn        = 0;
55 	uint16 private _taxSharesLP          = 0;
56 	uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesBurn + _taxSharesLP;
57 
58 	address payable private _walletMarketing = payable(0x93602BCE58A1dd2AeBe30c0F0d840d1bC2443612); 
59 	address payable private _walletDevelopment = payable(0x93602BCE58A1dd2AeBe30c0F0d840d1bC2443612); 
60 
61 	uint256 private _maxTxAmount     = _totalSupply; 
62 	uint256 private _maxWalletAmount = _totalSupply;
63 	uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
64 	uint256 private _taxSwapMax = _totalSupply * 125 / 100000;
65 
66 	mapping (address => uint256) private _balances;
67 	mapping (address => mapping (address => uint256)) private _allowances;
68 	mapping (address => bool) private _noFees;
69 	mapping (address => bool) private _noLimits;
70 
71 	address constant private _burnWallet = address(0);
72 	address private _lpOwner;
73 
74 	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //uniswap v2 router
75 	IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
76 	address private _primaryLP;
77 	mapping (address => bool) private _isLP;
78 
79 	bool private _tradingOpen;
80 
81 	bool private _inTaxSwap = false;
82 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
83 
84 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
85 	event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
86 
87 	constructor() Auth(msg.sender) {
88 		_lpOwner = msg.sender;
89 
90 		_balances[address(this)] =  80_085 * (10 ** _decimals);
91 		emit Transfer(address(0), address(this), _balances[address(this)]);
92 
93 		_balances[_owner] = _totalSupply - _balances[address(this)];
94 		emit Transfer(address(0), _owner, _balances[_owner]);
95 
96 		_noFees[_owner] = true;
97 		_noFees[address(this)] = true;
98 		_noFees[_swapRouterAddress] = true;
99 		_noFees[_walletMarketing] = true;
100 		_noFees[_walletDevelopment] = true;
101 		_noFees[_burnWallet] = true;
102 		_noLimits[_owner] = true;
103 		_noLimits[address(this)] = true;
104 		_noLimits[_swapRouterAddress] = true;
105 		_noLimits[_walletMarketing] = true;
106 		_noLimits[_walletDevelopment] = true;
107 		_noLimits[_burnWallet] = true;	
108 	}
109 
110 	receive() external payable {}
111 	
112 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
113 	function decimals() external pure override returns (uint8) { return _decimals; }
114 	function symbol() external pure override returns (string memory) { return _symbol; }
115 	function name() external pure override returns (string memory) { return _name; }
116 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
117 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
118 
119 	function approve(address spender, uint256 amount) public override returns (bool) {
120 		_allowances[msg.sender][spender] = amount;
121 		emit Approval(msg.sender, spender, amount);
122 		return true;
123 	}
124 
125 	function transfer(address recipient, uint256 amount) external override returns (bool) {
126 		require(_checkTradingOpen(msg.sender), "Trading not open");
127 		return _transferFrom(msg.sender, recipient, amount);
128 	}
129 
130 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
131 		require(_checkTradingOpen(sender), "Trading not open");
132 		if(_allowances[sender][msg.sender] != type(uint256).max){
133 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
134 		}
135 		return _transferFrom(sender, recipient, amount);
136 	}
137 
138 	function openTrading() external onlyOwner {
139 		require(!_tradingOpen, "trading already open");
140 		_openTrading();
141 	}
142 
143 	function _approveRouter(uint256 _tokenAmount) internal {
144 		if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
145 			_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
146 			emit Approval(address(this), _swapRouterAddress, type(uint256).max);
147 		}
148 	}
149 
150 	function addInitialLiquidity() external onlyOwner lockTaxSwap {
151 		require(_primaryLP == address(0), "LP exists");
152 		require(address(this).balance>0, "No ETH in contract");
153 		require(_balances[address(this)]>0, "No tokens in contract");
154 		_primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
155 		_addLiquidity(_balances[address(this)], address(this).balance, false);
156 		_isLP[_primaryLP] = true;
157 	}
158 
159 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
160 		address lpTokenRecipient = _lpOwner;
161 		if ( autoburn ) { lpTokenRecipient = address(0); }
162 		_approveRouter(_tokenAmount);
163 		_primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
164 	}
165 
166 	function _openTrading() internal {
167 		_maxTxAmount     = _totalSupply * 1 / 100; 
168 		_maxWalletAmount = _totalSupply * 1 / 100;
169 		_tradingOpen = true;
170 	}
171 
172 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
173 		require(sender != address(0), "No transfers from Zero wallet");
174 		if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
175 		if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
176 		
177 		if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
178 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
179 		uint256 _transferAmount = amount - _taxAmount;
180 		_balances[sender] = _balances[sender] - amount;
181 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
182 		_balances[recipient] = _balances[recipient] + _transferAmount;
183 		emit Transfer(sender, recipient, amount);
184 		return true;
185 	}
186 
187 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
188 		bool limitCheckPassed = true;
189 		if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
190 			if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
191 			else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
192 		}
193 		return limitCheckPassed;
194 	}
195 
196 	function _checkTradingOpen(address sender) private view returns (bool){
197 		bool checkResult = false;
198 		if ( _tradingOpen ) { checkResult = true; } 
199 		else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
200 
201 		return checkResult;
202 	}
203 
204 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
205 		uint256 taxAmount;
206 		if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
207 		else if ( _isLP[sender] ) { taxAmount = amount * _buyTaxRate / 100; }
208 		else if ( _isLP[recipient] ) { taxAmount = amount * _sellTaxRate / 100; }
209 		return taxAmount;
210 	}
211 
212 
213 	function getExemptions(address wallet) external view returns (bool noFees, bool noLimits) {
214 		return ( _noFees[wallet], _noLimits[wallet] );
215 	}
216 	function setExemptions(address wallet, bool noFees, bool noLimits) external onlyOwner {
217 		if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
218 		_noFees[ wallet ] = noFees;
219 		_noLimits[ wallet ] = noLimits;
220 	}
221 	function setExtraLP(address lpContractAddress, bool isLiquidityPool) external onlyOwner { 
222 		require(lpContractAddress != _primaryLP, "Cannot change the primary LP");
223 		_isLP[lpContractAddress] = isLiquidityPool; 
224 		if (isLiquidityPool) { 
225 			_noFees[lpContractAddress] = false; 
226 			_noLimits[lpContractAddress] = false; 
227 		}
228 	}
229 	function isLP(address wallet) external view returns (bool) {
230 		return _isLP[wallet];
231 	}
232 
233 	function getTaxInfo() external view returns (uint8 buyTax, uint8 sellTax, uint16 sharesMarketing, uint16 sharesDevelopment, uint16 sharesLP, uint16 sharesTokenBurn ) {
234 		return ( _buyTaxRate, _sellTaxRate, _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP, _taxSharesBurn);
235 	}
236 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
237 		require(newBuyTax + newSellTax <= 99, "Roundtrip too high");
238 		_buyTaxRate = newBuyTax;
239 		_sellTaxRate = newSellTax;
240 	}
241 	function setTaxDistribution(uint16 sharesTokenBurn, uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
242 		_taxSharesLP = sharesAutoLP;
243 		_taxSharesMarketing = sharesMarketing;
244 		_taxSharesDevelopment = sharesDevelopment;
245 		_totalTaxShares = sharesTokenBurn + sharesAutoLP + sharesMarketing + sharesDevelopment;
246 	}
247 
248 	function getAddresses() external view returns (address owner, address primaryLP, address marketing, address development, address LPowner ) {
249 		return ( _owner, _primaryLP, _walletMarketing, _walletDevelopment, _lpOwner);
250 	}
251 	function setTaxWallets(address newMarketing, address newDevelopment, address newLpOwner) external onlyOwner {
252 		require(!_isLP[newMarketing] && !_isLP[newDevelopment] && !_isLP[newLpOwner], "LP cannot be tax wallet");
253 		_walletMarketing = payable(newMarketing);
254 		_walletDevelopment = payable(newDevelopment);
255 		_lpOwner = newLpOwner;
256 		_noFees[newMarketing] = true;
257 		_noFees[newDevelopment] = true;
258 		_noLimits[newMarketing] = true;
259 		_noLimits[newDevelopment] = true;
260 	}
261 
262 	function getLimitsInfo() external view returns (uint256 maxTX, uint256 maxWallet, uint256 taxSwapMin, uint256 taxSwapMax ) {
263 		return ( _maxTxAmount, _maxWalletAmount, _taxSwapMin, _taxSwapMax);
264 	}
265 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
266 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
267 		require(newTxAmt >= _maxTxAmount, "tx limit too low");
268 		_maxTxAmount = newTxAmt;
269 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
270 		require(newWalletAmt >= _maxWalletAmount, "wallet limit too low");
271 		_maxWalletAmount = newWalletAmt;
272 	}
273 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
274 		_taxSwapMin = _totalSupply * minValue / minDivider;
275 		_taxSwapMax = _totalSupply * maxValue / maxDivider;
276 		require(_taxSwapMax>=_taxSwapMin, "MinMax error");
277 		require(_taxSwapMax>_totalSupply / 100000, "Upper threshold too low");
278 		require(_taxSwapMax<_totalSupply / 100, "Upper threshold too high");
279 	}
280 
281 	function _burnTokens(address fromWallet, uint256 amount) private {
282 		if ( amount > 0 ) {
283 			_balances[fromWallet] -= amount;
284 			_balances[_burnWallet] += amount;
285 			emit Transfer(fromWallet, _burnWallet, amount);
286 		}
287 	}
288 
289 	function _swapTaxAndLiquify() private lockTaxSwap {
290 		uint256 _taxTokensAvailable = balanceOf(address(this));
291 
292 		if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
293 			if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
294 
295 			uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
296 			uint256 _tokensToBurn = _taxTokensAvailable * _taxSharesBurn / _totalTaxShares;
297 			_burnTokens(address(this), _tokensToBurn);
298 			
299 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP - _tokensToBurn;
300 			if( _tokensToSwap > 10**_decimals ) {
301 				uint256 _ethPreSwap = address(this).balance;
302 				_swapTaxTokensForEth(_tokensToSwap);
303 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
304 				if ( _taxSharesLP > 0 ) {
305 					uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
306 					_approveRouter(_tokensForLP);
307 					_addLiquidity(_tokensForLP, _ethWeiAmount, false);
308 				}
309 			}
310 			uint256 _contractETHBalance = address(this).balance;
311 			if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
312 		}
313 	}
314 
315 	function _swapTaxTokensForEth(uint256 tokenAmount) private {
316 		_approveRouter(tokenAmount);
317 		address[] memory path = new address[](2);
318 		path[0] = address(this);
319 		path[1] = _primarySwapRouter.WETH();
320 		_primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
321 	}
322 
323 	function _distributeTaxEth(uint256 amount) private {
324 		uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
325 		if (_taxShareTotal > 0) {
326 			uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
327 			uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
328 			if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
329 			if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
330 		}
331 	}
332 
333 	function manualTaxSwapAndSend(bool swapTokens, bool sendEth) external onlyOwner {
334 		if (swapTokens) {
335 			uint256 taxTokenBalance = balanceOf(address(this));
336 			require(taxTokenBalance > 0, "No tokens");
337 			_swapTaxTokensForEth(taxTokenBalance);
338 		}
339 		if (sendEth) { 
340 			uint256 ethBalance = address(this).balance;
341 			require(ethBalance > 0, "No tokens");
342 			_distributeTaxEth(address(this).balance); 
343 		}
344 	}
345 
346 	function burnTokens(uint256 amount) external {
347 		uint256 _tokensAvailable = balanceOf(msg.sender);
348 		require(amount <= _tokensAvailable, "Token balance too low");
349 		_burnTokens(msg.sender, amount);
350 		emit TokensBurned(msg.sender, amount);
351 	}
352 
353 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
354         require(addresses.length <= 250,"Wallet count over 250 (gas risk)");
355         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
356 
357         uint256 airdropTotal = 0;
358         for(uint i=0; i < addresses.length; i++){
359             airdropTotal += (tokenAmounts[i] * 10**_decimals);
360         }
361         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
362 
363         for(uint i=0; i < addresses.length; i++){
364             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
365             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
366 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
367         }
368 
369         emit TokensAirdropped(addresses.length, airdropTotal);
370     }
371 }