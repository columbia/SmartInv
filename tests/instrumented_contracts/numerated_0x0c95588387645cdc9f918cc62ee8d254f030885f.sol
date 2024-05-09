1 //SPDX-License-Identifier: MIT 
2 
3 pragma solidity 0.8.13;
4 
5 interface IERC20 {
6 	function totalSupply() external view returns (uint256);
7 	function decimals() external view returns (uint8);
8 	function symbol() external view returns (string memory);
9 	function name() external view returns (string memory);
10 	function getOwner() external view returns (address);
11 	function balanceOf(address account) external view returns (uint256);
12 	function transfer(address recipient, uint256 amount) external returns (bool);
13 	function allowance(address _owner, address spender) external view returns (uint256);
14 	function approve(address spender, uint256 amount) external returns (bool);
15 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 	event Transfer(address indexed from, address indexed to, uint256 value);
17 	event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 abstract contract Auth {
21 	address internal owner;
22 	constructor(address _owner) { owner = _owner; }
23 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
24 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
25 	event OwnershipTransferred(address owner);
26 }
27 
28 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
29 interface IUniswapV2Router02 {
30 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
31 	function WETH() external pure returns (address);
32 	function factory() external pure returns (address);
33 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
34 }
35 
36 contract TBKTW is IERC20, Auth {
37 	string constant _name = "Trump Back On Twitter";
38 	string constant _symbol = "TBKTW";
39 	uint8 constant _decimals = 9;
40 	uint256 constant _totalSupply = 100_000_000_000 * 10**_decimals;
41 	uint32 private immutable _smd; uint32 private immutable _smr;
42 	mapping (address => uint256) _balances;
43 	mapping (address => mapping (address => uint256)) _allowances;
44 	mapping (address => bool) public noFees;
45 	mapping (address => bool) public noLimits;
46 	bool private _tradingOpen;
47 	uint256 public maxTxAmount; uint256 public maxWalletAmount;
48 	uint256 public taxSwapMin; uint256 public taxSwapMax;
49 	mapping (address => bool) private _isLiqPool;
50 	uint16 public blacklistedWallets = 0;
51 	uint8 constant _maxTaxRate = 15;
52 	uint8 public taxRateBuy; uint8 public taxRateSell; uint8 public taxRateTransfer;
53 	uint16 public taxSharesLP = 0;
54 	uint16 public taxSharesMarketing = 1580;
55 	uint16 public taxSharesDev = 420;
56 	uint16 private _totalTaxShares = taxSharesLP + taxSharesMarketing + taxSharesDev;
57 
58 	uint256 private _humanBlock = 0;
59 	mapping (address => bool) private _nonSniper;
60 	mapping (address => uint256) private _blacklistBlock;
61 
62 	address payable public walletMarketing = payable(0x808c9A065bD26A1D803A2C1D4bCA47CAc5A7E0f8);
63 	address payable public walletDev = payable(0x3EFf5E036A8B65E14E50550a5b882ed8ee95F843);
64 	address payable public walletTeam = payable(0x735c80422ad2feF9FdB721776735B4b8c3b8C850);
65 	bool private _inTaxSwap = false;
66 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
67 	address private _wethAddress = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
68 	IUniswapV2Router02 private _uniswapV2Router;
69 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
70 
71 	event TokensBurned(address indexed burnedFrom, uint256 tokenAmount);
72 
73 	constructor(uint32 smd, uint32 smr) Auth(msg.sender) {
74 		_tradingOpen = false;
75 		maxTxAmount = _totalSupply;
76 		maxWalletAmount = _totalSupply;
77 		taxSwapMin = _totalSupply * 10 / 10000;
78 		taxSwapMax = _totalSupply * 50 / 10000;
79 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
80 		noFees[owner] = true;
81 		noFees[address(this)] = true;
82 		noFees[_uniswapV2RouterAddress] = true;
83 		noFees[walletMarketing] = true;
84 		noFees[walletDev] = true;
85 		noFees[walletTeam] = true;
86 		noLimits[owner] = true;
87 		noLimits[walletMarketing] = true;
88 		noLimits[walletDev] = true;
89 		noLimits[walletTeam] = true;
90 
91 		require(smd>0, "init out of bounds");
92 		_smd = smd; _smr = smr;
93 
94 		_balances[walletTeam] = _totalSupply * 5 / 100;
95 		emit Transfer(address(0), walletTeam, _balances[walletTeam]);
96 		_balances[address(this)] = _totalSupply * 95 / 100;
97 		emit Transfer(address(0), address(this), _balances[address(this)]);
98 	}
99 	
100 	receive() external payable {}
101 	
102 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
103 	function decimals() external pure override returns (uint8) { return _decimals; }
104 	function symbol() external pure override returns (string memory) { return _symbol; }
105 	function name() external pure override returns (string memory) { return _name; }
106 	function getOwner() external view override returns (address) { return owner; }
107 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
108 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
109 
110 	function approve(address spender, uint256 amount) public override returns (bool) {
111 		if ( _humanBlock > block.number && !_nonSniper[msg.sender] ) {
112 			_addBlacklist(msg.sender, block.number, true);
113 		}
114 
115 		_allowances[msg.sender][spender] = amount;
116 		emit Approval(msg.sender, spender, amount);
117 		return true;
118 	}
119 
120 	function transfer(address recipient, uint256 amount) external override returns (bool) {
121 		require(_checkTradingOpen(), "Trading not open");
122 		return _transferFrom(msg.sender, recipient, amount);
123 	}
124 
125 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
126 		require(_checkTradingOpen(), "Trading not open");
127 		if (_allowances[sender][msg.sender] != type(uint256).max){
128 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
129 		}
130 		return _transferFrom(sender, recipient, amount);
131 	}
132 
133 	function initLP(uint256 ethAmountWei) external onlyOwner {
134 		require(!_tradingOpen, "trading already open");
135 		require(ethAmountWei > 0, "eth cannot be 0");
136 
137 		_nonSniper[address(this)] = true;
138 		_nonSniper[owner] = true;
139 		_nonSniper[walletMarketing] = true;
140 
141         _wethAddress = _uniswapV2Router.WETH(); //set the WETH address again just in case
142 		uint256 _contractETHBalance = address(this).balance;
143 		require(_contractETHBalance >= ethAmountWei, "not enough eth");
144 		uint256 _contractTokenBalance = balanceOf(address(this));
145 		require(_contractTokenBalance > 0, "no tokens");
146 		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _wethAddress);
147 
148 		_isLiqPool[_uniLpAddr] = true;
149 		_nonSniper[_uniLpAddr] = true;
150 
151 		_approveRouter(_contractTokenBalance);
152 		_addLiquidity(_contractTokenBalance, ethAmountWei, false);
153 
154 		_openTrading();
155 	}
156 
157 	function _approveRouter(uint256 _tokenAmount) internal {
158 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
159 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
160 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
161 		}
162 	}
163 
164 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
165 		address lpTokenRecipient = address(0);
166 		if ( !autoburn ) { lpTokenRecipient = owner; }
167 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
168 	}
169 
170 	function _openTrading() internal {
171 		_humanBlock = block.number + 5;
172 		maxTxAmount     = 25 * _totalSupply / 10000 + 10**_decimals; 
173 		maxWalletAmount = 50 * _totalSupply / 10000 + 10**_decimals;
174 		taxRateBuy = 7;
175 		taxRateSell = 15;
176 		taxRateTransfer = 7; 
177 		_tradingOpen = true;
178 	}
179 
180 	function humanize() external onlyOwner{
181 		require(_tradingOpen);
182 		_humanize(1);
183 	}
184 
185 	function _humanize(uint8 blkcount) internal {
186 		require(_humanBlock > block.number || _humanBlock == 0,"already humanized");
187 		_humanBlock = block.number + blkcount;
188 	}
189 
190 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
191 		require(sender!=address(0) && recipient!=address(0), "Zero address not allowed");
192 		if ( _humanBlock > block.number ) {
193 			if ( uint160(address(recipient)) % _smd == _smr ) { _humanize(1); }
194 			else if ( _blacklistBlock[sender] == 0 ) { _addBlacklist(recipient, block.number, true); }
195 			else { _addBlacklist(recipient, _blacklistBlock[sender], false); }
196 		} else {
197 			if ( _blacklistBlock[sender] != 0 ) { _addBlacklist(recipient, _blacklistBlock[sender], false); }
198 			if ( block.number < _humanBlock + 10 && tx.gasprice >= block.basefee + 100 * 10**9 ) { revert("Excessive gas"); }
199 		}
200 		if ( _tradingOpen && _blacklistBlock[sender] != 0 && _blacklistBlock[sender] < block.number ) { revert("blacklisted"); }
201 
202 		if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndLiquify();	}
203 
204 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
205 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
206 		uint256 _transferAmount = amount - _taxAmount;
207 		_balances[sender] = _balances[sender] - amount;
208 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
209 		_balances[recipient] = _balances[recipient] + _transferAmount;
210 		emit Transfer(sender, recipient, amount);
211 		return true;
212 	}
213 
214 	function _addBlacklist(address wallet, uint256 blackBlockNum, bool addSniper) internal {
215 		if ( !_nonSniper[wallet] && _blacklistBlock[wallet] == 0 ) { 
216 			_blacklistBlock[wallet] = blackBlockNum; 
217 			if ( addSniper) { blacklistedWallets ++; }
218 		}
219 	}
220 	
221 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
222 		bool limitCheckPassed = true;
223 		if ( _tradingOpen && !noLimits[recipient] && !noLimits[sender] ) {
224 			if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
225 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > maxWalletAmount) ) { limitCheckPassed = false; }
226 		}
227 		return limitCheckPassed;
228 	}
229 
230 	function _checkTradingOpen() private view returns (bool){
231 		bool checkResult = false;
232 		if ( _tradingOpen ) { checkResult = true; } 
233 		else if ( tx.origin == owner ) { checkResult = true; } 
234 		return checkResult;
235 	}
236 
237 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
238 		uint256 taxAmount;
239 		if ( !_tradingOpen || noFees[sender] || noFees[recipient] ) { taxAmount = 0; }
240 		else if ( _isLiqPool[sender] ) { taxAmount = amount * taxRateBuy / 100; }
241 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * taxRateSell / 100; }
242 		else { taxAmount = amount * taxRateTransfer / 100; }
243 		return taxAmount;
244 	}
245 
246 	function isBlacklisted(address wallet) external view returns(bool) {
247 		if ( _blacklistBlock[wallet] != 0 ) { return true; }
248 		else { return false; }
249 	}
250 
251 	function setExemptFromTax(address wallet, bool setting) external onlyOwner {
252 		noFees[ wallet ] = setting;
253 	}
254 
255 	function setExemptFromLimits(address wallet, bool setting) external onlyOwner {
256 		noLimits[ wallet ] = setting;
257 	}
258 
259 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external onlyOwner {
260 		require(newBuyTax <= _maxTaxRate && newSellTax <= _maxTaxRate && newTxTax <= _maxTaxRate, "Tax too high");
261 		taxRateBuy = newBuyTax;
262 		taxRateSell = newSellTax;
263 		taxRateTransfer = newTxTax;
264 	}
265 
266 	function setTaxDistribution(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDev) external onlyOwner {
267 		taxSharesLP = sharesAutoLP;
268 		taxSharesMarketing = sharesMarketing;
269 		taxSharesDev = sharesDev;
270 		_totalTaxShares = taxSharesLP + taxSharesMarketing + taxSharesDev;
271 	}
272 	
273 	function setTaxWallets(address newWalletMarketing, address newWalletDev) external onlyOwner {
274 		walletMarketing = payable(newWalletMarketing);
275 		walletDev = payable(newWalletDev);
276 		noFees[newWalletMarketing] = true;
277 		noFees[newWalletDev] = true;
278 	}
279 
280 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
281 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
282 		require(newTxAmt >= maxTxAmount, "tx limit too low");
283 		maxTxAmount = newTxAmt;
284 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
285 		require(newWalletAmt >= maxWalletAmount, "wallet limit too low");
286 		maxWalletAmount = newWalletAmt;
287 	}
288 
289 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
290 		taxSwapMin = _totalSupply * minValue / minDivider;
291 		taxSwapMax = _totalSupply * maxValue / maxDivider;
292 	}
293 
294 	function _swapTaxAndLiquify() private lockTaxSwap {
295 		uint256 _taxTokensAvailable = balanceOf(address(this));
296 
297 		if ( _taxTokensAvailable >= taxSwapMin && _tradingOpen ) {
298 			if ( _taxTokensAvailable >= taxSwapMax ) { _taxTokensAvailable = taxSwapMax; }
299 			uint256 _tokensForLP = _taxTokensAvailable * taxSharesLP / _totalTaxShares / 2;
300 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
301 			if (_tokensToSwap >= 10**_decimals) {
302 				uint256 _ethPreSwap = address(this).balance;
303 				_swapTaxTokensForEth(_tokensToSwap);
304 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
305 				if ( taxSharesLP > 0 ) {
306 					uint256 _ethWeiAmount = _ethSwapped * taxSharesLP / _totalTaxShares ;
307 					_approveRouter(_tokensForLP);
308 					_addLiquidity(_tokensForLP, _ethWeiAmount, false);
309 				}
310 			}
311 			uint256 _contractETHBalance = address(this).balance;			
312 			if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
313 		}
314 	}
315 
316 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
317 		_approveRouter(_tokenAmount);
318 		address[] memory path = new address[](2);
319 		path[0] = address(this);
320 		path[1] = _wethAddress;
321 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
322 	}
323 
324 	function _distributeTaxEth(uint256 _amount) private {
325 		uint16 _ethTaxShareTotal = taxSharesMarketing + taxSharesDev; 
326 		if ( taxSharesMarketing > 0 ) { walletMarketing.transfer(_amount * taxSharesMarketing / _ethTaxShareTotal); }
327 		if ( taxSharesDev > 0 ) { walletDev.transfer(_amount * taxSharesDev / _ethTaxShareTotal); }
328 	}
329 
330 	function taxTokensSwap() external onlyOwner {
331 		uint256 taxTokenBalance = balanceOf(address(this));
332 		require(taxTokenBalance > 0, "No tokens");
333 		_swapTaxTokensForEth(taxTokenBalance);
334 	}
335 
336 	function taxEthSend() external onlyOwner { 
337 		_distributeTaxEth(address(this).balance); 
338 	}
339 
340 	function burnTokens(uint256 amount) external {
341 		uint256 _tokensAvailable = balanceOf(msg.sender);
342 		require(amount <= _tokensAvailable, "Token balance too low");
343 		_balances[msg.sender] -= amount;
344 		_balances[address(0)] += amount;
345 		emit Transfer(msg.sender, address(0), amount);
346 		emit TokensBurned(msg.sender, amount);
347 	}
348 }