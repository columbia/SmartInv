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
35 contract KYOKAI is IERC20, Auth {
36 	uint8   private constant _decimals    = 9;
37 	uint256 private constant _totalSupply = 100_000_000 * (10**_decimals);
38 	string  private constant _name        = "Kyokai";
39 	string  private constant _symbol      = "KYOKAI";
40 
41 	uint256 private _antibotTaxBlock;
42 
43 	uint8 private _buyTaxRate  = 3;
44 	uint8 private _sellTaxRate = 22;
45 
46 	uint8 private _taxRtHardCap = 25;
47 
48 	uint16 private _taxSharesMarketing   = 2;
49 	uint16 private _taxSharesLP          = 1;
50 	uint16 private _totalTaxShares = _taxSharesMarketing + _taxSharesLP;
51 
52 	address payable private _walletMarketing = payable(0xe46d00c3De194fe50DfCce3CeC5449636f5F8dA7);
53 
54 	uint256 private _maxTxAmount     = _totalSupply; 
55 	uint256 private _maxWalletAmount = _totalSupply;
56 	uint256 private _taxSwapMin = _totalSupply *  10 / 100000;
57 	uint256 private _taxSwapMax = _totalSupply * 100 / 100000;
58 
59 	mapping (address => uint256) private _balances;
60 	mapping (address => mapping (address => uint256)) private _allowances;
61 	mapping (address => bool) private _noFees;
62 	mapping (address => bool) private _noLimits;
63 
64 	address private _lpOwner;
65 
66 	address private constant _swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
67 	IUniswapV2Router02 private _primarySwapRouter = IUniswapV2Router02(_swapRouterAddress);
68     address private WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
69 	address private _primaryLP;
70 	mapping (address => bool) private _isLP;
71 
72 	bool private _tradingOpen;
73 
74 	bool private _inTaxSwap = false;
75 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
76 
77 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
78 	event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
79 
80 	constructor() Auth(msg.sender) {
81 		_lpOwner = msg.sender;
82 
83 		_balances[address(this)] =  8_292_240 * (10 ** _decimals);   // 8.29% to LP, rest airdropped to old hodlders
84 		emit Transfer(address(0), address(this), _balances[address(this)]);
85 
86 		_balances[_owner] = _totalSupply - _balances[address(this)];
87 		emit Transfer(address(0), _owner, _balances[_owner]);
88 
89 		_noFees[_owner] = true;
90 		_noFees[address(this)] = true;
91 		_noFees[_swapRouterAddress] = true;
92 		_noFees[_walletMarketing] = true;
93 		_noLimits[_owner] = true;
94 		_noLimits[address(this)] = true;
95 		_noLimits[_swapRouterAddress] = true;
96 		_noLimits[_walletMarketing] = true;
97 	}
98 
99 	receive() external payable {}
100 	
101 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
102 	function decimals() external pure override returns (uint8) { return _decimals; }
103 	function symbol() external pure override returns (string memory) { return _symbol; }
104 	function name() external pure override returns (string memory) { return _name; }
105 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
106 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
107 
108 	function approve(address spender, uint256 amount) public override returns (bool) {
109 		_allowances[msg.sender][spender] = amount;
110 		emit Approval(msg.sender, spender, amount);
111 		return true;
112 	}
113 
114 	function transfer(address recipient, uint256 amount) external override returns (bool) {
115 		require(_checkTradingOpen(msg.sender), "Trading not open");
116 		return _transferFrom(msg.sender, recipient, amount);
117 	}
118 
119 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
120 		require(_checkTradingOpen(sender), "Trading not open");
121 		if(_allowances[sender][msg.sender] != type(uint256).max){
122 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
123 		}
124 		return _transferFrom(sender, recipient, amount);
125 	}
126 
127 	function openTrading() external onlyOwner {
128 		_openTrading();
129 	}
130 
131 	function _approveRouter(uint256 _tokenAmount) internal {
132 		if ( _allowances[address(this)][_swapRouterAddress] < _tokenAmount ) {
133 			_allowances[address(this)][_swapRouterAddress] = type(uint256).max;
134 			emit Approval(address(this), _swapRouterAddress, type(uint256).max);
135 		}
136 	}
137 
138 	function addInitialLiquidity() external onlyOwner lockTaxSwap {
139 		require(_primaryLP == address(0), "LP exists");
140 		require(address(this).balance>0, "No ETH in contract");
141 		require(_balances[address(this)]>0, "No tokens in contract");
142         WETH = _primarySwapRouter.WETH();
143 		_primaryLP = IUniswapV2Factory(_primarySwapRouter.factory()).createPair(address(this), WETH);
144 		_addLiquidity(_balances[address(this)], address(this).balance);
145 		_isLP[_primaryLP] = true;
146 	}
147 
148 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
149 		address lpTokenRecipient = _lpOwner;
150 		_approveRouter(_tokenAmount);
151 		_primarySwapRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
152 	}
153 
154 	function _openTrading() internal {
155         require(!_tradingOpen, "trading already open");
156         require(_primaryLP != address(0), "LP not initialized");
157 		_maxTxAmount     = _totalSupply * 35 / 1000;
158 		_maxWalletAmount = _totalSupply * 35 / 1000;
159 		_antibotTaxBlock = block.number + 5;
160 		_tradingOpen = true;
161 	}
162 
163 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
164 		require(sender != address(0), "No transfers from Zero wallet");
165 		if (!_tradingOpen) { require(_noFees[sender] && _noLimits[sender], "Trading not open"); }
166 		if ( !_inTaxSwap && _isLP[recipient] ) { _swapTaxAndLiquify(); }
167 		
168 		if ( sender != address(this) && recipient != address(this) && sender != _owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
169 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
170 		uint256 _transferAmount = amount - _taxAmount;
171 		_balances[sender] = _balances[sender] - amount;
172 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
173 		_balances[recipient] = _balances[recipient] + _transferAmount;
174 		emit Transfer(sender, recipient, amount);
175 		return true;
176 	}
177 
178 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
179 		bool limitCheckPassed = true;
180 		if ( _tradingOpen && !_noLimits[sender] && !_noLimits[recipient] ) {
181 			if ( transferAmount > _maxTxAmount ) { limitCheckPassed = false; }
182 			else if ( !_isLP[recipient] && (_balances[recipient] + transferAmount > _maxWalletAmount) ) { limitCheckPassed = false; }
183 		}
184 		return limitCheckPassed;
185 	}
186 
187 	function _checkTradingOpen(address sender) private view returns (bool){
188 		bool checkResult = false;
189 		if ( _tradingOpen ) { checkResult = true; } 
190 		else if (_noFees[sender] && _noLimits[sender]) { checkResult = true; } 
191 
192 		return checkResult;
193 	}
194 
195 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
196 		uint256 taxAmount;
197 		if ( !_tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
198 		else if ( _isLP[sender] ) { 
199 			taxAmount = amount * _buyTaxRate / 100; 
200 			if (block.number >= _antibotTaxBlock) { taxAmount = amount * _buyTaxRate / 100; } // regular buy tax
201 			else { taxAmount = amount * 99 / 100; } // antibot buy tax for a few blocks after openTrading
202 		}
203 		else if ( _isLP[recipient] ) { taxAmount = amount * _sellTaxRate / 100; }
204 		return taxAmount;
205 	}
206 
207 	function getExemptions(address wallet) external view returns (bool noFees, bool noLimits) {
208 		return ( _noFees[wallet], _noLimits[wallet] );
209 	}
210 	function setExemptions(address wallet, bool noFees, bool noLimits) external onlyOwner {
211 		if (noLimits || noFees) { require(!_isLP[wallet], "Cannot exempt LP"); }
212 		_noFees[ wallet ] = noFees;
213 		_noLimits[ wallet ] = noLimits;
214 	}
215 
216 	function getTaxInfo() external view returns (uint8 buyTax, uint8 sellTax, uint16 sharesMarketing, uint16 sharesLP, uint8 taxRoundtripHardcap ) {
217 		return ( _buyTaxRate, _sellTaxRate, _taxSharesMarketing, _taxSharesLP, _taxRtHardCap);
218 	}
219 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
220 		require(newBuyTax + newSellTax <= _taxRtHardCap, "Roundtrip too high");
221 		_buyTaxRate = newBuyTax;
222 		_sellTaxRate = newSellTax;
223 	}
224 	function decreaseTaxRTHardcap(uint8 newRoundtripHardcap) external onlyOwner {
225 		require (newRoundtripHardcap < _taxRtHardCap, "New hardcap must be lower");
226 		_taxRtHardCap = newRoundtripHardcap;
227 	}
228 	function setTaxDistribution(uint16 sharesAutoLP, uint16 sharesMarketing) external onlyOwner {
229 		uint16 totalShares = sharesAutoLP + sharesMarketing;
230 		require( totalShares > 0, "Both cannot be 0");
231 		_taxSharesLP = sharesAutoLP;
232 		_taxSharesMarketing = sharesMarketing;
233 		_totalTaxShares = totalShares;
234 	}
235 
236 	function getAddresses() external view returns (address owner, address primaryLP, address marketing, address LPowner ) {
237 		return ( _owner, _primaryLP, _walletMarketing, _lpOwner);
238 	}
239 	function setTaxWallets(address newMarketing, address newLpOwner) external onlyOwner {
240 		require(!_isLP[newMarketing] && !_isLP[newLpOwner], "LP cannot be tax wallet");
241 		_walletMarketing = payable(newMarketing);
242 		_lpOwner = newLpOwner;
243 		_noFees[newMarketing] = true;
244 		_noLimits[newMarketing] = true;
245 	}
246 
247 	function getLimitsInfo() external view returns (uint256 maxTX, uint256 maxWallet, uint256 taxSwapMin, uint256 taxSwapMax ) {
248 		return ( _maxTxAmount, _maxWalletAmount, _taxSwapMin, _taxSwapMax);
249 	}
250 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
251 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
252 		require(newTxAmt >= _maxTxAmount, "tx limit too low");
253 		_maxTxAmount = newTxAmt;
254 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
255 		require(newWalletAmt >= _maxWalletAmount, "wallet limit too low");
256 		_maxWalletAmount = newWalletAmt;
257 	}
258 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
259 		_taxSwapMin = _totalSupply * minValue / minDivider;
260 		_taxSwapMax = _totalSupply * maxValue / maxDivider;
261 		require(_taxSwapMax>=_taxSwapMin, "MinMax error");
262 		require(_taxSwapMax>_totalSupply / 100000, "Upper threshold too low");
263 		require(_taxSwapMax<_totalSupply / 100, "Upper threshold too high");
264 	}
265 
266 	function _swapTaxAndLiquify() private lockTaxSwap {
267 		uint256 _taxTokensAvailable = balanceOf(address(this));
268 
269 		if ( _taxTokensAvailable >= _taxSwapMin && _tradingOpen ) {
270 			if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
271 
272 			uint256 _tokensForLP = _taxTokensAvailable * _taxSharesLP / _totalTaxShares / 2;
273 			
274 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
275 			if( _tokensToSwap > 10**_decimals ) {
276 				uint256 _ethPreSwap = address(this).balance;
277 				_swapTaxTokensForEth(_tokensToSwap);
278 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
279 				if ( _taxSharesLP > 0 ) {
280 					uint256 _ethWeiAmount = _ethSwapped * _taxSharesLP / _totalTaxShares ;
281 					_approveRouter(_tokensForLP);
282 					_addLiquidity(_tokensForLP, _ethWeiAmount);
283 				}
284 			}
285 			uint256 _contractETHBalance = address(this).balance;
286 			if(_contractETHBalance > 0) { _sendTaxEth(_contractETHBalance); }
287 		}
288 	}
289 
290 	function _swapTaxTokensForEth(uint256 tokenAmount) private {
291 		_approveRouter(tokenAmount);
292 		address[] memory path = new address[](2);
293 		path[0] = address(this);
294 		path[1] = WETH;
295 		_primarySwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
296 	}
297 
298 	function _sendTaxEth(uint256 amount) private {
299 		_walletMarketing.transfer(amount);
300 	}
301 
302 	function manualTaxSwapAndSend(uint8 swapTokenPercent, bool sendEth) external onlyOwner lockTaxSwap {
303 		require(swapTokenPercent <= 100, "Cannot swap more than 100%");
304 		uint256 tokensToSwap = balanceOf(address(this)) * swapTokenPercent / 100;
305 		if (tokensToSwap > 10 ** _decimals) {
306 			_swapTaxTokensForEth(tokensToSwap);
307 		}
308 		if (sendEth) { 
309 			uint256 _contractETHBalance = address(this).balance;
310 			if(_contractETHBalance > 0) { _sendTaxEth(_contractETHBalance); }
311 		}
312 	}
313 
314 
315 	function burnTokens(uint256 amount) external {
316 		uint256 _tokensAvailable = balanceOf(msg.sender);
317 		require(amount <= _tokensAvailable, "Token balance too low");
318 		if ( amount > 0 ) {
319 			_balances[msg.sender] -= amount;
320 			_balances[address(0)] += amount;
321 			emit Transfer(msg.sender, address(0), amount);
322 			emit TokensBurned(msg.sender, amount);
323 		}
324 	}
325 
326 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
327         require(addresses.length <= 250,"Wallet count over 250 (gas risk)");
328         require(addresses.length == tokenAmounts.length,"Input length mismatch");
329 
330         uint256 airdropTotal = 0;
331         for(uint i=0; i < addresses.length; i++){
332             airdropTotal += (tokenAmounts[i] * 10**_decimals);
333         }
334         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
335 
336         for(uint i=0; i < addresses.length; i++){
337             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
338             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
339 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
340         }
341 
342         emit TokensAirdropped(addresses.length, airdropTotal);
343     }
344 }