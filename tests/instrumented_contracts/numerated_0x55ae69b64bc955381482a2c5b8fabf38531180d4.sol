1 //SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Be Disciplined. A New world order has been sanctioned.
6 
7 Tg: http://t.me/osamuOfficial
8 
9 Web: https://weareosamu.com
10 
11 */
12 
13 pragma solidity 0.8.17;
14 
15 interface IERC20 {
16 	function totalSupply() external view returns (uint256);
17 	function decimals() external view returns (uint8);
18 	function symbol() external view returns (string memory);
19 	function name() external view returns (string memory);
20 	function balanceOf(address account) external view returns (uint256);
21 	function transfer(address recipient, uint256 amount) external returns (bool);
22 	function allowance(address __owner, address spender) external view returns (uint256);
23 	function approve(address spender, uint256 amount) external returns (bool);
24 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25 	event Transfer(address indexed from, address indexed to, uint256 value);
26 	event Approval(address indexed _owner, address indexed spender, uint256 value);
27 }
28 
29 abstract contract Auth {
30 	address internal _owner;
31 	constructor(address creatorOwner) { _owner = creatorOwner; }
32 	modifier onlyOwner() { require(msg.sender == _owner, "Only contract _owner can call this function"); _; }
33 	function transferOwnership(address payable newOwner) external onlyOwner { _owner = newOwner; emit OwnershipTransferred(newOwner); }
34 	event OwnershipTransferred(address _owner);
35 }
36 
37 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
38 interface IUniswapV2Router02 {
39 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
40 	function WETH() external pure returns (address);
41 	function factory() external pure returns (address);
42 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
43 }
44 
45 contract OSA is IERC20, Auth {
46 	uint8 private constant _decimals      = 9;
47 	uint256 private constant _totalSupply = 100_000_000 * (10**_decimals);
48 	string private constant _name         = "OSAMU";
49 	string private constant _symbol       = "OSA";
50 
51 	uint8 private _buyTaxRate  = 99; //SNIPERS + BOTS GET REKT!
52 	uint8 private _sellTaxRate = 12;
53 
54 	uint16 private _taxSharesMarketing   = 5;
55 	uint16 private _taxSharesDevelopment = 1;
56 	uint16 private _taxSharesBurn        = 0;
57 	uint16 private _taxSharesLP          = 0;
58 	uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesDevelopment + _taxSharesBurn + _taxSharesLP;
59 
60 	address payable private _walletMarketing = payable(0x3C45B955D67214d97B80d3495B487fe90B39C21f); 
61 	address payable private _walletDevelopment = payable(0x10782D83EdE1D5B90ed0B3aC5d6d2Ee0a6a788E4); 
62 
63 	uint256 private _maxTxAmount     = _totalSupply; 
64 	uint256 private _maxWalletAmount = _totalSupply;
65 	uint256 private _taxSwapMin = _totalSupply * 10 / 100000;
66 	uint256 private _taxSwapMax = _totalSupply * 85 / 100000;
67 
68 	mapping (address => uint256) private _balances;
69 	mapping (address => mapping (address => uint256)) private _allowances;
70 	mapping (address => bool) private _noFees;
71 	mapping (address => bool) private _noLimits;
72 
73 	address constant private _burnWallet = address(0);
74 	address private _lpOwner;
75 
76 	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //uniswap v2 router
77 	IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
78 	address private _primaryLP;
79 	mapping (address => bool) private _isLP;
80 
81 	bool private _tradingOpen;
82 
83 	bool private _inTaxSwap = false;
84 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
85 
86 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
87 	event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
88 
89 	constructor() Auth(msg.sender) {
90 		_lpOwner = msg.sender;
91 
92 		_balances[address(this)] =  80_000_000 * (10 ** _decimals);
93 		emit Transfer(address(0), address(this), _balances[address(this)]);
94 
95 		_balances[_owner] = _totalSupply - _balances[address(this)];
96 		emit Transfer(address(0), _owner, _balances[_owner]);
97 
98 		_noFees[_owner] = true;
99 		_noFees[address(this)] = true;
100 		_noFees[_swapRouterAddress] = true;
101 		_noFees[_walletMarketing] = true;
102 		_noFees[_walletDevelopment] = true;
103 		_noFees[_burnWallet] = true;
104 		_noLimits[_owner] = true;
105 		_noLimits[address(this)] = true;
106 		_noLimits[_swapRouterAddress] = true;
107 		_noLimits[_walletMarketing] = true;
108 		_noLimits[_walletDevelopment] = true;
109 		_noLimits[_burnWallet] = true;	
110 	}
111 
112 	receive() external payable {}
113 	
114 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
115 	function decimals() external pure override returns (uint8) { return _decimals; }
116 	function symbol() external pure override returns (string memory) { return _symbol; }
117 	function name() external pure override returns (string memory) { return _name; }
118 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
119 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
120 
121 	function approve(address spender, uint256 amount) public override returns (bool) {
122 		_allowances[msg.sender][spender] = amount;
123 		emit Approval(msg.sender, spender, amount);
124 		return true;
125 	}
126 
127 	function transfer(address recipient, uint256 amount) external override returns (bool) {
128 		require(_checkTradingOpen(msg.sender), "Trading not open");
129 		return _transferFrom(msg.sender, recipient, amount);
130 	}
131 
132 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
133 		require(_checkTradingOpen(sender), "Trading not open");
134 		if(_allowances[sender][msg.sender] != type(uint256).max){
135 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
136 		}
137 		return _transferFrom(sender, recipient, amount);
138 	}
139 
140 	function openTrading() external onlyOwner {
141 		require(!_tradingOpen, "trading already open");
142 		_openTrading();
143 	}
144 
145 	function _approveRouter(uint256 _tokenAmount) internal {
146 		if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
147 			_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
148 			emit Approval(address(this), _swapRouterAddress, type(uint256).max);
149 		}
150 	}
151 
152 	function addInitialLiquidity() external onlyOwner lockTaxSwap {
153 		require(_primaryLP == address(0), "LP exists");
154 		require(address(this).balance>0, "No ETH in contract");
155 		require(_balances[address(this)]>0, "No tokens in contract");
156 		_primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), _primarySwapRouter.WETH());
157 		_addLiquidity(_balances[address(this)], address(this).balance, false);
158 		_isLP[_primaryLP] = true;
159 	}
160 
161 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
162 		address lpTokenRecipient = _lpOwner;
163 		if ( autoburn ) { lpTokenRecipient = address(0); }
164 		_approveRouter(_tokenAmount);
165 		_primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
166 	}
167 
168 	function _openTrading() internal {
169 		_maxTxAmount     = _totalSupply * 1 / 100; 
170 		_maxWalletAmount = _totalSupply * 1 / 100;
171 		_tradingOpen = true;
172 	}
173 
174 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
175 		require(sender != address(0), "No transfers from Zero wallet");
176 		if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
177 		if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
178 		
179 		if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
180 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
181 		uint256 _transferAmount = amount - _taxAmount;
182 		_balances[sender] = _balances[sender] - amount;
183 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
184 		_balances[recipient] = _balances[recipient] + _transferAmount;
185 		emit Transfer(sender, recipient, amount);
186 		return true;
187 	}
188 
189 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
190 		bool limitCheckPassed = true;
191 		if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
192 			if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
193 			else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
194 		}
195 		return limitCheckPassed;
196 	}
197 
198 	function _checkTradingOpen(address sender) private view returns (bool){
199 		bool checkResult = false;
200 		if ( _tradingOpen ) { checkResult = true; } 
201 		else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
202 
203 		return checkResult;
204 	}
205 
206 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
207 		uint256 taxAmount;
208 		if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
209 		else if ( _isLP[sender] ) { taxAmount = amount * _buyTaxRate / 100; }
210 		else if ( _isLP[recipient] ) { taxAmount = amount * _sellTaxRate / 100; }
211 		return taxAmount;
212 	}
213 
214 
215 	function getExemptions(address wallet) external view returns (bool noFees, bool noLimits) {
216 		return ( _noFees[wallet], _noLimits[wallet] );
217 	}
218 	function setExemptions(address wallet, bool noFees, bool noLimits) external onlyOwner {
219 		if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
220 		_noFees[ wallet ] = noFees;
221 		_noLimits[ wallet ] = noLimits;
222 	}
223 	function setExtraLP(address lpContractAddress, bool isLiquidityPool) external onlyOwner { 
224 		require(lpContractAddress != _primaryLP, "Cannot change the primary LP");
225 		_isLP[lpContractAddress] = isLiquidityPool; 
226 		if (isLiquidityPool) { 
227 			_noFees[lpContractAddress] = false; 
228 			_noLimits[lpContractAddress] = false; 
229 		}
230 	}
231 	function isLP(address wallet) external view returns (bool) {
232 		return _isLP[wallet];
233 	}
234 
235 	function getTaxInfo() external view returns (uint8 buyTax, uint8 sellTax, uint16 sharesMarketing, uint16 sharesDevelopment, uint16 sharesLP, uint16 sharesTokenBurn ) {
236 		return ( _buyTaxRate, _sellTaxRate, _taxSharesMarketing, _taxSharesDevelopment, _taxSharesLP, _taxSharesBurn);
237 	}
238 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
239 		require(newBuyTax + newSellTax <= 70, "Roundtrip too high");
240 		_buyTaxRate = newBuyTax;
241 		_sellTaxRate = newSellTax;
242 	}  
243 	function setTaxDistribution(uint16 sharesTokenBurn, uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
244 		_taxSharesLP = sharesAutoLP;
245 		_taxSharesMarketing = sharesMarketing;
246 		_taxSharesDevelopment = sharesDevelopment;
247 		_totalTaxShares = sharesTokenBurn + sharesAutoLP + sharesMarketing + sharesDevelopment;
248 	}
249 
250 	function getAddresses() external view returns (address owner, address primaryLP, address marketing, address development, address LPowner ) {
251 		return ( _owner, _primaryLP, _walletMarketing, _walletDevelopment, _lpOwner);
252 	}
253 	function setTaxWallets(address newMarketing, address newDevelopment, address newLpOwner) external onlyOwner {
254 		require(!_isLP[newMarketing] && !_isLP[newDevelopment] && !_isLP[newLpOwner], "LP cannot be tax wallet");
255 		_walletMarketing = payable(newMarketing);
256 		_walletDevelopment = payable(newDevelopment);
257 		_lpOwner = newLpOwner;
258 		_noFees[newMarketing] = true;
259 		_noFees[newDevelopment] = true;
260 		_noLimits[newMarketing] = true;
261 		_noLimits[newDevelopment] = true;
262 	}
263 
264 	function getLimitsInfo() external view returns (uint256 maxTX, uint256 maxWallet, uint256 taxSwapMin, uint256 taxSwapMax ) {
265 		return ( _maxTxAmount, _maxWalletAmount, _taxSwapMin, _taxSwapMax);
266 	}
267 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
268 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
269 		require(newTxAmt >= _maxTxAmount, "tx limit too low");
270 		_maxTxAmount = newTxAmt;
271 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
272 		require(newWalletAmt >= _maxWalletAmount, "wallet limit too low");
273 		_maxWalletAmount = newWalletAmt;
274 	}
275 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
276 		_taxSwapMin = _totalSupply * minValue / minDivider;
277 		_taxSwapMax = _totalSupply * maxValue / maxDivider;
278 		require(_taxSwapMax>=_taxSwapMin, "MinMax error");
279 		require(_taxSwapMax>_totalSupply / 100000, "Upper threshold too low");
280 		require(_taxSwapMax<_totalSupply / 100, "Upper threshold too high");
281 	}
282 
283 	function _burnTokens(address fromWallet, uint256 amount) private {
284 		if ( amount > 0 ) {
285 			_balances[fromWallet] -= amount;
286 			_balances[_burnWallet] += amount;
287 			emit Transfer(fromWallet, _burnWallet, amount);
288 		}
289 	}
290 
291 	function _swapTaxAndLiquify() private lockTaxSwap {
292 		uint256 _taxTokensAvailable = balanceOf(address(this));
293 
294 		if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
295 			if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
296 
297 			uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
298 			uint256 _tokensToBurn = _taxTokensAvailable * _taxSharesBurn / _totalTaxShares;
299 			_burnTokens(address(this), _tokensToBurn);
300 			
301 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP - _tokensToBurn;
302 			if( _tokensToSwap > 10**_decimals ) {
303 				uint256 _ethPreSwap = address(this).balance;
304 				_swapTaxTokensForEth(_tokensToSwap);
305 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
306 				if ( _taxSharesLP > 0 ) {
307 					uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
308 					_approveRouter(_tokensForLP);
309 					_addLiquidity(_tokensForLP, _ethWeiAmount, false);
310 				}
311 			}
312 			uint256 _contractETHBalance = address(this).balance;
313 			if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
314 		}
315 	}
316 
317 	function _swapTaxTokensForEth(uint256 tokenAmount) private {
318 		_approveRouter(tokenAmount);
319 		address[] memory path = new address[](2);
320 		path[0] = address(this);
321 		path[1] = _primarySwapRouter.WETH();
322 		_primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
323 	}
324 
325 	function _distributeTaxEth(uint256 amount) private {
326 		uint16 _taxShareTotal = _taxSharesMarketing + _taxSharesDevelopment;
327 		if (_taxShareTotal > 0) {
328 			uint256 marketingAmount = amount * _taxSharesMarketing / _taxShareTotal;
329 			uint256 developmentAmount = amount * _taxSharesDevelopment / _taxShareTotal;
330 			if ( marketingAmount > 0 ) { _walletMarketing.transfer(marketingAmount); }
331 			if ( developmentAmount > 0 ) { _walletDevelopment.transfer(developmentAmount); }
332 		}
333 	}
334 
335 	function manualTaxSwapAndSend(bool swapTokens, bool sendEth) external onlyOwner {
336 		if (swapTokens) {
337 			uint256 taxTokenBalance = balanceOf(address(this));
338 			require(taxTokenBalance > 0, "No tokens");
339 			_swapTaxTokensForEth(taxTokenBalance);
340 		}
341 		if (sendEth) { 
342 			uint256 ethBalance = address(this).balance;
343 			require(ethBalance > 0, "No tokens");
344 			_distributeTaxEth(address(this).balance); 
345 		}
346 	}
347 
348 	function burnTokens(uint256 amount) external {
349 		uint256 _tokensAvailable = balanceOf(msg.sender);
350 		require(amount <= _tokensAvailable, "Token balance too low");
351 		_burnTokens(msg.sender, amount);
352 		emit TokensBurned(msg.sender, amount);
353 	}
354 
355 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
356         require(addresses.length <= 250,"Wallet count over 250 (gas risk)");
357         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
358 
359         uint256 airdropTotal = 0;
360         for(uint i=0; i < addresses.length; i++){
361             airdropTotal += (tokenAmounts[i] * 10**_decimals);
362         }
363         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
364 
365         for(uint i=0; i < addresses.length; i++){
366             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
367             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
368 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
369         }
370 
371         emit TokensAirdropped(addresses.length, airdropTotal);
372     }
373 }