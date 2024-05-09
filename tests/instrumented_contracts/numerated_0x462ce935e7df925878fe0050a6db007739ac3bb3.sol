1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.15;
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
18 abstract contract Auth {
19 	address internal owner;
20 	constructor(address _owner) { owner = _owner; }
21 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
22 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
23 	event OwnershipTransferred(address owner);
24 }
25 
26 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
27 interface IUniswapV2Router02 {
28 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
29 	function WETH() external pure returns (address);
30 	function factory() external pure returns (address);
31 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
32 }
33 
34 contract J is IERC20, Auth {
35 	string constant _name = "Last Dragon Slayer"; 
36 	string constant _symbol = "J"; 
37 	uint8 constant _decimals = 9;
38 	uint256 constant _totalSupply = 1_000_000_000_000 * 10**_decimals;
39 	mapping (address => uint256) _balances;
40 	mapping (address => mapping (address => uint256)) _allowances;
41 	uint256 private _tradingOpenBlock;
42 	mapping (address => bool) private _isLiqPool;
43 
44 	uint8 private fee_taxRateMaxLimit; uint8 private fee_taxRateBuy; uint8 private fee_taxRateSell;
45 
46 	uint256 private lim_maxTxAmount; uint256 private lim_maxWalletAmount;
47 	uint256 private lim_taxSwapMin; uint256 private lim_taxSwapMax;
48 
49 	address private _liquidityPool;
50 
51 	mapping(address => bool) private exm_noFees;
52 	mapping(address => bool) private exm_noLimits;
53 	
54 	bool private _inTaxSwap = false;
55 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
56 	address private _wethAddress = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
57 	IUniswapV2Router02 private _uniswapV2Router;
58 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
59 
60 	event TokensBurned(address burnedFrom, uint256 tokenAmount);
61 	event TaxRatesChanged(uint8 taxRateBuy, uint8 taxRateSell);
62 	event LimitsIncreased(uint256 maxTransaction, uint256 maxWalletSize);
63 	event TaxSwapSettingsChanged(uint256 taxSwapMin, uint256 taxSwapMax);
64 	event WalletExemptionsSet(address wallet, bool noFees, bool noLimits);
65 
66 	constructor() Auth(msg.sender) {
67 		_tradingOpenBlock = type(uint256).max; 
68 		fee_taxRateMaxLimit = 7;
69 		lim_maxTxAmount = _totalSupply;
70 		lim_maxWalletAmount = _totalSupply;
71 		lim_taxSwapMin = _totalSupply * 10 / 10000;
72 		lim_taxSwapMax = _totalSupply * 50 / 10000;
73 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
74 
75 		exm_noFees[owner] = true;
76 		exm_noFees[address(this)] = true;
77 		exm_noFees[_uniswapV2RouterAddress] = true;
78 
79 		exm_noLimits[owner] = true;
80 		exm_noLimits[address(this)] = true;
81 		exm_noLimits[_uniswapV2RouterAddress] = true;
82 	}
83 	
84 	receive() external payable {}
85 	
86 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
87 	function decimals() external pure override returns (uint8) { return _decimals; }
88 	function symbol() external pure override returns (string memory) { return _symbol; }
89 	function name() external pure override returns (string memory) { return _name; }
90 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
91 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
92 
93 	function approve(address spender, uint256 amount) public override returns (bool) {
94 		_allowances[msg.sender][spender] = amount;
95 		emit Approval(msg.sender, spender, amount);
96 		return true;
97 	}
98 
99 	function transfer(address recipient, uint256 amount) external override returns (bool) {
100 		require(_checkTradingOpen(), "Trading not open");
101 		return _transferFrom(msg.sender, recipient, amount);
102 	}
103 
104 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
105 		require(_checkTradingOpen(), "Trading not open");
106 		if (_allowances[sender][msg.sender] != type(uint256).max){
107 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
108 		}
109 		return _transferFrom(sender, recipient, amount);
110 	}
111 
112 	function addLP() external onlyOwner {
113 		require(!_tradingOpen(), "trading already open");
114 		require(_liquidityPool == address(0), "LP already added");
115 
116 		_balances[address(this)] = _totalSupply / 2;
117 		emit Transfer(address(0), address(this), _balances[address(this)]);
118 
119 		_balances[owner] = _totalSupply - _balances[address(this)];
120 		emit Transfer(address(0), owner, _balances[owner]);
121 
122 		_wethAddress = _uniswapV2Router.WETH(); //override the WETH address from router
123 		_liquidityPool = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _wethAddress);
124 
125 		_isLiqPool[_liquidityPool] = true;
126 
127 		uint256 _contractETHBalance = address(this).balance;
128 		require(_contractETHBalance >= 0, "no eth");		
129 		uint256 _contractTokenBalance = balanceOf(address(this));
130 		require(_contractTokenBalance > 0, "no tokens");
131 
132 		_approveRouter(_contractTokenBalance);
133 		_addLiquidity(_contractTokenBalance, _contractETHBalance, false);
134 	}
135 
136 	function _approveRouter(uint256 _tokenAmount) internal {
137 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
138 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
139 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
140 		}
141 	}
142 
143 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
144 		address lpTokenRecipient = address(0);
145 		if ( !autoburn ) { lpTokenRecipient = owner; }
146 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
147 	}
148 
149 	function openTrading() external onlyOwner {
150 		require(!_tradingOpen(), "trading already open");
151 		require(_liquidityPool != address(0), "LP not initialized");
152 		_openTrading();
153 	}
154 
155 	function _openTrading() internal {
156 		lim_maxTxAmount     = 100 * _totalSupply / 10000 + 10**_decimals; 
157 		lim_maxWalletAmount = 100 * _totalSupply / 10000 + 10**_decimals;
158 		fee_taxRateBuy = 4;
159 		fee_taxRateSell = 4;
160 		_tradingOpenBlock = block.number + 134;
161 	}
162 
163 	function tradingOpen() external view returns (bool) {
164 		if (_tradingOpen() && block.number >= _tradingOpenBlock + 10) { return _tradingOpen(); }
165 		else { return false; }
166 	}
167 
168 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
169 		require(sender!=address(0) && recipient!=address(0), "Zero address not allowed");
170 
171 		if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndLiquify();	}
172 
173 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
174 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
175 		uint256 _transferAmount = amount - _taxAmount;
176 		_balances[sender] = _balances[sender] - amount;
177 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
178 		_balances[recipient] = _balances[recipient] + _transferAmount;
179 		emit Transfer(sender, recipient, amount);
180 		return true;
181 	}
182 	
183 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
184 		bool limitCheckPassed = true;
185 		if ( _tradingOpen() && !exm_noLimits[recipient] && !exm_noLimits[sender] ) {
186 			if ( transferAmount > lim_maxTxAmount ) { limitCheckPassed = false; }
187 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > lim_maxWalletAmount) ) { limitCheckPassed = false; }
188 		}
189 		return limitCheckPassed;
190 	}
191 
192 	function _tradingOpen() private view returns (bool) {
193 		bool result = false;
194 		if (block.number >= _tradingOpenBlock) { result = true; }
195 		return result;
196 	}
197 
198 	function _checkTradingOpen() private view returns (bool){
199 		bool checkResult = false;
200 		if ( _tradingOpen() ) { checkResult = true; } 
201 		else if ( tx.origin == owner ) { checkResult = true; } 
202 		return checkResult;
203 	}
204 
205 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
206 		uint256 taxAmount;
207 		if ( !_tradingOpen() || exm_noFees[sender] || exm_noFees[recipient] ) { taxAmount = 0; }
208 		else if ( _isLiqPool[sender] ) { taxAmount = amount * fee_taxRateBuy / 100; }
209 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * fee_taxRateSell / 100; }
210 		else { taxAmount = 0; }
211 		return taxAmount;
212 	}
213 
214 	function getExemptions(address wallet) external view returns(bool noFees, bool noLimits) {
215 		return (exm_noFees[wallet], exm_noLimits[wallet]);
216 	}
217 
218 	function setExemptions(address wallet, bool noFees, bool noLimits) external onlyOwner {
219 		exm_noFees[wallet] = noFees;
220 		exm_noLimits[wallet] = noLimits;
221 		emit WalletExemptionsSet(wallet, noFees, noLimits);
222 	}
223 
224 	function getFeeSettings() external view returns(uint8 taxRateMaxLimit, uint8 taxRateBuy, uint8 taxRateSell) {
225 		return (fee_taxRateMaxLimit, fee_taxRateBuy, fee_taxRateSell);
226 	}
227 
228 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
229 		require( newBuyTax+newSellTax <= 2*fee_taxRateMaxLimit, "Tax too high");
230 		fee_taxRateBuy = newBuyTax;
231 		fee_taxRateSell = newSellTax;
232 		emit TaxRatesChanged(newBuyTax, newSellTax);
233 	}
234 
235 	function getWallets() external view returns(address contractOwner, address liquidityPool) {
236 		return (owner, _liquidityPool);
237 	}
238 
239 	function getLimits() external view returns(uint256 maxTxAmount, uint256 maxWalletAmount, uint256 taxSwapMin, uint256 taxSwapMax) {
240 		return (lim_maxTxAmount, lim_maxWalletAmount, lim_taxSwapMin, lim_taxSwapMax);
241 	}
242 
243 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
244 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
245 		require(newTxAmt >= lim_maxTxAmount, "tx limit too low");
246 		lim_maxTxAmount = newTxAmt;
247 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
248 		require(newWalletAmt >= lim_maxWalletAmount, "wallet limit too low");
249 		lim_maxWalletAmount = newWalletAmt;
250 		emit LimitsIncreased(lim_maxTxAmount, lim_maxWalletAmount);
251 	}
252 
253 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
254 		lim_taxSwapMin = _totalSupply * minValue / minDivider;
255 		lim_taxSwapMax = _totalSupply * maxValue / maxDivider;
256 		require(lim_taxSwapMax > lim_taxSwapMin);
257 		emit TaxSwapSettingsChanged(lim_taxSwapMin, lim_taxSwapMax);
258 	}
259 
260 	function _swapTaxAndLiquify() private lockTaxSwap {
261 		uint256 _taxTokensAvailable = balanceOf(address(this));
262 
263 		if ( _taxTokensAvailable >= lim_taxSwapMin && _tradingOpen() ) {
264 			if ( _taxTokensAvailable >= lim_taxSwapMax ) { _taxTokensAvailable = lim_taxSwapMax; }
265 			uint256 _tokensForLP = _taxTokensAvailable / 2;
266 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
267 			if (_tokensToSwap >= 10**_decimals) {
268 				uint256 _ethPreSwap = address(this).balance;
269 				_swapTaxTokensForEth(_tokensToSwap);
270 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
271 				if ( _ethSwapped > 0 ) {
272 					_approveRouter(_tokensForLP);
273 					_addLiquidity(_tokensForLP, _ethSwapped, false);
274 				}
275 			}
276 		}
277 	}
278 
279 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
280 		_approveRouter(_tokenAmount);
281 		address[] memory path = new address[](2);
282 		path[0] = address(this);
283 		path[1] = _wethAddress;
284 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
285 	}
286 
287 	function recoverBalance() external onlyOwner {
288 		uint256 _stuckEthBalance = address(this).balance;
289         require (_stuckEthBalance > 0);
290 		address payable recipient = payable(owner);
291 		recipient.transfer(_stuckEthBalance);
292 	}
293 
294 	function manualSwap(uint8 swapPercent) external onlyOwner {
295 		uint256 taxTokenBalance = balanceOf(address(this));
296 		require(taxTokenBalance > 0, "No tokens");
297 		uint256 tokensToSwap = taxTokenBalance * swapPercent / 100;
298 		_swapTaxTokensForEth(tokensToSwap);
299 	}
300 
301 	function burnTokens(uint256 amount) external {
302 		uint256 _tokensAvailable = balanceOf(msg.sender);
303 		require(amount <= _tokensAvailable, "Token balance too low");
304 		_balances[msg.sender] -= amount;
305 		_balances[address(0)] += amount;
306 		emit Transfer(msg.sender, address(0), amount);
307 		emit TokensBurned(msg.sender, amount);
308 	}
309 }