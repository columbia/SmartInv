1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
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
34 contract CHRYSEOS is IERC20, Auth {
35 	string constant _name = "Chryseos"; 
36 	string constant _symbol = "CHS"; 
37 	uint8 constant _decimals = 9;
38 	uint256 constant _totalSupply = 8_000_000_000 * 10**_decimals;
39 	mapping (address => uint256) _balances;
40 	mapping (address => mapping (address => uint256)) _allowances;
41 	uint256 private _tradingOpenBlock;
42 	mapping (address => bool) private _isLiqPool;
43 	uint16 private _blacklistedWallets = 0;
44 
45 	uint8 private fee_taxRateMaxLimit; uint8 private fee_taxRateBuy; uint8 private fee_taxRateSell; uint8 private fee_taxRateTransfer;
46 	uint16 private fee_sharesAutoLP; uint16 private fee_sharesMarketing; uint16 private fee_sharesDevelopment; uint16 private fee_sharesTOTAL;
47 
48 	uint256 private lim_maxTxAmount; uint256 private lim_maxWalletAmount;
49 	uint256 private lim_taxSwapMin; uint256 private lim_taxSwapMax;
50 
51 	address payable private wlt_marketing;
52 	address payable private wlt_development;
53 	address private _mainLiquidityPool;
54 
55 	mapping(address => bool) private exm_noFees;
56 	mapping(address => bool) private exm_noLimits;
57 	
58 	uint256 private _humanBlock = 0;
59 	uint256 private _gasBlock = 0;
60 	mapping (address => bool) private _nonSniper;
61 	mapping (address => uint256) private _blacklistBlock;
62 
63 	bool private _inTaxSwap = false;
64 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
65 	address private _wethAddress = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
66 	IUniswapV2Router02 private _uniswapV2Router;
67 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
68 
69 	event TokensBurned(address burnedFrom, uint256 tokenAmount);
70 	event TaxRatesChanged(uint8 taxRateBuy, uint8 taxRateSell, uint8 taxRateTransfer);
71 	event TaxWalletsChanged(address marketing, address development);
72 	event TaxDistributionChanged(uint16 autoLP, uint16 marketing, uint16 development);
73 	event LimitsIncreased(uint256 maxTransaction, uint256 maxWalletSize);
74 	event TaxSwapSettingsChanged(uint256 taxSwapMin, uint256 taxSwapMax);
75 	event WalletExemptionsSet(address wallet, bool noFees, bool noLimits);
76 
77 
78 	constructor() Auth(msg.sender) {
79 		_tradingOpenBlock = type(uint256).max; 
80 		fee_taxRateMaxLimit = 10;
81 		lim_maxTxAmount = _totalSupply;
82 		lim_maxWalletAmount = _totalSupply;
83 		lim_taxSwapMin = _totalSupply * 5 / 10000;
84 		lim_taxSwapMax = _totalSupply * 50 / 10000;
85 		fee_sharesAutoLP = 200;
86 		fee_sharesMarketing = 200;
87 		fee_sharesDevelopment = 200;
88 		fee_sharesTOTAL = fee_sharesAutoLP + fee_sharesDevelopment + fee_sharesMarketing;
89 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
90 
91 		wlt_marketing = payable(0xB30411fE765Df3f87354D4C3c38777A6Cae31915);
92 		wlt_development = payable(0xF1ccFdaC6682CFff278F48cC0486d005b21a42B7);
93 
94 		exm_noFees[owner] = true;
95 		exm_noFees[address(this)] = true;
96 		exm_noFees[_uniswapV2RouterAddress] = true;
97 		exm_noFees[wlt_marketing] = true;
98 		exm_noFees[wlt_development] = true;
99 
100 		exm_noLimits[owner] = true;
101 		exm_noLimits[address(this)] = true;
102 		exm_noLimits[_uniswapV2RouterAddress] = true;
103 		exm_noLimits[wlt_marketing] = true;
104 		exm_noLimits[wlt_development] = true;
105 
106 		_balances[owner] = _totalSupply * 40 / 100;
107 		emit Transfer(address(0), owner, _balances[owner]);		
108 		_balances[address(this)] = _totalSupply * 60 / 100;
109 		emit Transfer(address(0), address(this), _balances[address(this)]);
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
122 		if ( _humanBlock > block.number && !_nonSniper[msg.sender] ) {
123 			_addBlacklist(msg.sender, block.number, true);
124 		}
125 
126 		_allowances[msg.sender][spender] = amount;
127 		emit Approval(msg.sender, spender, amount);
128 		return true;
129 	}
130 
131 	function transfer(address recipient, uint256 amount) external override returns (bool) {
132 		require(_checkTradingOpen(), "Trading not open");
133 		return _transferFrom(msg.sender, recipient, amount);
134 	}
135 
136 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
137 		require(_checkTradingOpen(), "Trading not open");
138 		if (_allowances[sender][msg.sender] != type(uint256).max){
139 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
140 		}
141 		return _transferFrom(sender, recipient, amount);
142 	}
143 
144 	function addLiquidityPreset(uint256 b1, uint256 b2, uint256 b3) external onlyOwner {
145 		require(!_tradingOpen(), "trading already open");
146 		require(_mainLiquidityPool == address(0), "LP already added");
147 
148 		_nonSniper[address(this)] = true;
149 		_nonSniper[owner] = true;
150 		_nonSniper[wlt_marketing] = true;
151 		_nonSniper[wlt_development] = true;
152 
153 		_wethAddress = _uniswapV2Router.WETH();
154 		_mainLiquidityPool = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _wethAddress);
155 
156 		_isLiqPool[_mainLiquidityPool] = true;
157 		_nonSniper[_mainLiquidityPool] = true;
158 
159 		uint256 _contractETHBalance = address(this).balance;
160 		require(_contractETHBalance >= 0, "no eth");
161 		uint256 _contractTokenBalance = balanceOf(address(this));
162 		require(_contractTokenBalance > 0, "no tokens");
163 
164 		_approveRouter(_contractTokenBalance);
165 		_addLiquidity(_contractTokenBalance, _contractETHBalance, false);
166 
167 		uint256 _tob = 4*b1;
168 		uint256 _hb = 3*b2;
169 		uint256 _gb = 2*b3;
170 
171 		_openTrading(_tob, _hb, _gb);
172 	}
173 
174 	function _approveRouter(uint256 _tokenAmount) internal {
175 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
176 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
177 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
178 		}
179 	}
180 
181 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
182 		address lpTokenRecipient = address(0);
183 		if ( !autoburn ) { lpTokenRecipient = owner; }
184 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
185 	}
186 
187 	function _openTrading(uint256 tob, uint256 hb, uint256 gb) internal {
188 		lim_maxTxAmount     = 50 * _totalSupply / 10000 + 10**_decimals; 
189 		lim_maxWalletAmount = 50 * _totalSupply / 10000 + 10**_decimals;
190 		fee_taxRateBuy = 6;
191 		fee_taxRateSell = 12;
192 		fee_taxRateTransfer = 0; 
193 		_tradingOpenBlock = block.number + tob;
194 		_humanBlock = _tradingOpenBlock + hb;
195 		_gasBlock = _humanBlock + gb;
196 	}
197 
198 	function tradingOpen() external view returns (bool) {
199 		if (_tradingOpen() && block.number >= _humanBlock + 5) { return _tradingOpen(); }
200 		else { return false; }
201 	}
202 
203 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
204 		require(sender!=address(0) && recipient!=address(0), "Zero address not allowed");
205 		if ( _humanBlock > block.number ) {
206 			if ( _blacklistBlock[sender] == 0 ) { _addBlacklist(recipient, block.number, true); }
207 			else { _addBlacklist(recipient, _blacklistBlock[sender], false); }
208 		} else {
209 			if ( _blacklistBlock[sender] != 0 ) { _addBlacklist(recipient, _blacklistBlock[sender], false); }
210 			if ( _gasBlock > block.number ) {
211 				uint256 priceDiff = 0;
212 				if ( tx.gasprice >= block.basefee ) { priceDiff = tx.gasprice - block.basefee; }
213 				if ( priceDiff >= 20_000_000_000 ) { revert("Excessive TX fee"); }
214 			}
215 		}
216 
217 		if ( _tradingOpen() && _blacklistBlock[sender] != 0 && _blacklistBlock[sender] < block.number ) { revert("blacklisted"); }
218 
219 		if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndLiquify();	}
220 
221 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
222 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
223 		uint256 _transferAmount = amount - _taxAmount;
224 		_balances[sender] = _balances[sender] - amount;
225 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
226 		_balances[recipient] = _balances[recipient] + _transferAmount;
227 		emit Transfer(sender, recipient, amount);
228 		return true;
229 	}
230 
231 	function _addBlacklist(address wallet, uint256 blackBlockNum, bool addSniper) internal {
232 		if ( !_nonSniper[wallet] && _blacklistBlock[wallet] == 0 ) { 
233 			_blacklistBlock[wallet] = blackBlockNum; 
234 			if ( addSniper) { _blacklistedWallets ++; }
235 		}
236 	}
237 	
238 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
239 		bool limitCheckPassed = true;
240 		if ( _tradingOpen() && !exm_noLimits[recipient] && !exm_noLimits[sender] ) {
241 			if ( transferAmount > lim_maxTxAmount ) { limitCheckPassed = false; }
242 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > lim_maxWalletAmount) ) { limitCheckPassed = false; }
243 		}
244 		return limitCheckPassed;
245 	}
246 
247 	function _tradingOpen() private view returns (bool) {
248 		bool result = false;
249 		if (block.number >= _tradingOpenBlock) { result = true; }
250 		return result;
251 	}
252 
253 	function _checkTradingOpen() private view returns (bool){
254 		bool checkResult = false;
255 		if ( _tradingOpen() ) { checkResult = true; } 
256 		else if ( tx.origin == owner ) { checkResult = true; } 
257 		return checkResult;
258 	}
259 
260 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
261 		uint256 taxAmount;
262 		if ( !_tradingOpen() || exm_noFees[sender] || exm_noFees[recipient] ) { taxAmount = 0; }
263 		else if ( _isLiqPool[sender] ) { taxAmount = amount * fee_taxRateBuy / 100; }
264 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * fee_taxRateSell / 100; }
265 		else { taxAmount = amount * fee_taxRateTransfer / 100; }
266 		return taxAmount;
267 	}
268 
269 	function getBlacklistStatus(address wallet) external view returns(bool isBlacklisted, uint256 blacklistBlock, uint16 totalBlacklistedWallets) {
270 		bool _isBlacklisted;
271 		if ( _blacklistBlock[wallet] != 0 ) { _isBlacklisted = true; }
272 		return ( _isBlacklisted, _blacklistBlock[wallet], _blacklistedWallets);	
273 	}
274 
275 	function getExemptions(address wallet) external view returns(bool noFees, bool noLimits) {
276 		return (exm_noFees[wallet], exm_noLimits[wallet]);
277 	}
278 
279 	function setExemptions(address wallet, bool noFees, bool noLimits) external onlyOwner {
280 		require(!_isLiqPool[wallet],"LP cannot be exempt");
281 		exm_noFees[wallet] = noFees;
282 		exm_noLimits[wallet] = noLimits;
283 		emit WalletExemptionsSet(wallet, noFees, noLimits);
284 	}
285 
286 	function getFeeSettings() external view returns(uint8 taxRateMaxLimit, uint8 taxRateBuy, uint8 taxRateSell, uint8 taxRateTransfer, uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment ) {
287 		return (fee_taxRateMaxLimit, fee_taxRateBuy, fee_taxRateSell, fee_taxRateTransfer, fee_sharesAutoLP, fee_sharesMarketing, fee_sharesDevelopment);
288 	}
289 
290 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external onlyOwner {
291 		require(newBuyTax+newSellTax <= 2*fee_taxRateMaxLimit, "Avg tax too high");
292 		require(newTxTax <= fee_taxRateMaxLimit, "Tax too high");
293 		fee_taxRateBuy = newBuyTax;
294 		fee_taxRateSell = newSellTax;
295 		fee_taxRateTransfer = newTxTax;
296 		emit TaxRatesChanged(newBuyTax, newSellTax, newTxTax);
297 	}
298 
299 	function setTaxDistribution(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment) external onlyOwner {
300 		fee_sharesAutoLP = sharesAutoLP;
301 		fee_sharesMarketing = sharesMarketing;
302 		fee_sharesDevelopment = sharesDevelopment;
303 		fee_sharesTOTAL = fee_sharesAutoLP + fee_sharesMarketing + sharesDevelopment;
304 		emit TaxDistributionChanged(sharesAutoLP, sharesMarketing, sharesDevelopment);
305 	}
306 	
307 	function getWallets() external view returns(address contractOwner, address mainLiquidityPool, address marketing, address development) {
308 		return (owner, _mainLiquidityPool, wlt_marketing, wlt_development);
309 	}
310 
311 	function setTaxWallets(address newMarketingWallet, address newDevelopmentWallet) external onlyOwner {
312 		wlt_marketing = payable(newMarketingWallet);
313 		wlt_development = payable(newDevelopmentWallet);
314 		exm_noFees[newMarketingWallet] = true;
315 		exm_noFees[newDevelopmentWallet] = true;
316 		exm_noLimits[newMarketingWallet] = true;
317 		exm_noLimits[newDevelopmentWallet] = true;
318 		emit TaxWalletsChanged(newMarketingWallet, newDevelopmentWallet);
319 	}
320 
321 	function getLimits() external view returns(uint256 maxTxAmount, uint256 maxWalletAmount, uint256 taxSwapMin, uint256 taxSwapMax) {
322 		return (lim_maxTxAmount, lim_maxWalletAmount, lim_taxSwapMin, lim_taxSwapMax);
323 	}
324 
325 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
326 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
327 		require(newTxAmt >= lim_maxTxAmount, "tx limit too low");
328 		lim_maxTxAmount = newTxAmt;
329 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
330 		require(newWalletAmt >= lim_maxWalletAmount, "wallet limit too low");
331 		lim_maxWalletAmount = newWalletAmt;
332 		emit LimitsIncreased(lim_maxTxAmount, lim_maxWalletAmount);
333 	}
334 
335 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
336 		lim_taxSwapMin = _totalSupply * minValue / minDivider;
337 		lim_taxSwapMax = _totalSupply * maxValue / maxDivider;
338 		require(lim_taxSwapMax > lim_taxSwapMin);
339 		emit TaxSwapSettingsChanged(lim_taxSwapMin, lim_taxSwapMax);
340 	}
341 
342 	function isLiquidityPool(address ca) external view returns (bool) {
343 		return _isLiqPool[ca];
344 	}
345 
346 	function setLiquidityPool(address ca, bool isLP) external onlyOwner {
347 		require(ca != _mainLiquidityPool, "Cannot change main LP");
348 		require(!exm_noFees[ca], "LP cannot be fees exempt");
349 		require(!exm_noLimits[ca], "LP cannnot be limits exempt");
350 		_isLiqPool[ca] = isLP;
351 	}
352 
353 	function burnAndUnblacklistSniper(address sniperWallet) external onlyOwner {
354 		require(_blacklistBlock[sniperWallet] != 0, "Wallet is not blacklisted");
355 		uint256 blacklistedBalance = _balances[sniperWallet] * 98 / 100;
356 		_burnTokens(blacklistedBalance, sniperWallet);
357 		_blacklistBlock[sniperWallet] = 0;
358 	}
359 
360 	function _burnTokens(uint256 amount, address burnedFrom) private {
361 		if ( amount > 0 ) {
362 			_balances[burnedFrom] -= amount;
363 			_balances[address(0)] += amount;
364 			emit Transfer(burnedFrom, address(0), amount);
365 			emit TokensBurned(burnedFrom, amount);
366 		}
367 	}
368 
369 	function _swapTaxAndLiquify() private lockTaxSwap {
370 		uint256 _taxTokensAvailable = balanceOf(address(this));
371 
372 		if ( _taxTokensAvailable >= lim_taxSwapMin && _tradingOpen() ) {
373 			if ( _taxTokensAvailable >= lim_taxSwapMax ) { _taxTokensAvailable = lim_taxSwapMax; }
374 			
375 			uint256 _tokensForLP = _taxTokensAvailable * fee_sharesAutoLP / fee_sharesTOTAL / 2;
376 			
377 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
378 			if (_tokensToSwap >= 10**_decimals) {
379 				uint256 _ethPreSwap = address(this).balance;
380 				_swapTaxTokensForEth(_tokensToSwap);
381 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
382 				if ( fee_sharesAutoLP > 0 ) {
383 					uint256 _ethWeiAmount = _ethSwapped * fee_sharesAutoLP / fee_sharesTOTAL ;
384 					_approveRouter(_tokensForLP);
385 					_addLiquidity(_tokensForLP, _ethWeiAmount, false);
386 				}
387 			}
388 			uint256 _contractETHBalance = address(this).balance;			
389 			if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
390 		}
391 	}
392 
393 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
394 		_approveRouter(_tokenAmount);
395 		address[] memory path = new address[](2);
396 		path[0] = address(this);
397 		path[1] = _wethAddress;
398 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
399 	}
400 
401 	function _distributeTaxEth(uint256 _amount) private {
402 		uint16 _ethTaxShareTotal = fee_sharesMarketing + fee_sharesDevelopment; 
403 		if ( fee_sharesMarketing > 0 ) { wlt_marketing.transfer(_amount * fee_sharesMarketing / _ethTaxShareTotal); }
404 		if ( fee_sharesDevelopment > 0 ) { wlt_development.transfer(_amount * fee_sharesDevelopment / _ethTaxShareTotal); }
405 	}
406 
407 	function taxManualSwapSend(bool swapTokens, bool sendEth) external onlyOwner {
408 		if (swapTokens) {
409 			uint256 taxTokenBalance = balanceOf(address(this));
410 			require(taxTokenBalance > 0, "No tokens");
411 			_swapTaxTokensForEth(taxTokenBalance);
412 		}
413 		
414 		if (sendEth) {
415 			_distributeTaxEth(address(this).balance); 
416 		}
417 	}
418 
419 	function burnTokens(uint256 amount) external {
420 		uint256 _tokensAvailable = balanceOf(msg.sender);
421 		require(amount <= _tokensAvailable, "Token balance too low");
422 		_burnTokens(amount, msg.sender);
423 	}
424 }