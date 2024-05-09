1 //SPDX-License-Identifier: MIT 
2 
3 pragma solidity 0.8.13;
4 
5 interface IERC20 {
6 	function totalSupply() external view returns (uint256);
7 	function decimals() external view returns (uint8);
8 	function symbol() external view returns (string memory);
9 	function name() external view returns (string memory);
10 	function balanceOf(address account) external view returns (uint256);
11 	function transfer(address recipient, uint256 amount) external returns (bool);
12 	function allowance(address _owner, address spender) external view returns (uint256);
13 	function approve(address spender, uint256 amount) external returns (bool);
14 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 abstract contract Auth {
20 	address internal owner;
21 	constructor(address _owner) { owner = _owner; }
22 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
23 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
24 	event OwnershipTransferred(address owner);
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
35 contract SHIFT is IERC20, Auth {
36 	string constant _name = "SHIFT";
37 	string constant _symbol = "SHIFT";
38 	uint8 constant _decimals = 9;
39 	uint256 constant _totalSupply = 10_000_000_000_000 * 10**_decimals;
40 	mapping (address => uint256) _balances;
41 	mapping (address => mapping (address => uint256)) _allowances;
42 	bool private _tradingOpen;
43 	mapping (address => bool) private _isLiqPool;
44 	uint16 private _blacklistedWallets = 0;
45 
46 
47 	uint8 private fee_taxRateMaxLimit; uint8 private fee_taxRateBuy; uint8 private fee_taxRateSell; uint8 private fee_taxRateTransfer;
48 	uint16 private fee_sharesAutoLP; uint16 private fee_sharesMarketing; uint16 private fee_sharesDevelopment; uint16 private fee_sharesCharity; uint16 private fee_sharesBuyback; uint16 private fee_sharesTOTAL;
49 
50 	uint256 private lim_maxTxAmount; uint256 private lim_maxWalletAmount;
51 	uint256 private lim_taxSwapMin; uint256 private lim_taxSwapMax;
52 
53 	address payable private wlt_marketing;
54 	address payable private wlt_development;
55 	address payable private wlt_charity;
56 	address payable private wlt_buyback;
57 	address private _liquidityPool;
58 
59 	mapping(address => bool) private exm_noFees;
60 	mapping(address => bool) private exm_noLimits;
61 	
62 	uint256 private _humanBlock = 0;
63 	mapping (address => bool) private _nonSniper;
64 	mapping (address => uint256) private _blacklistBlock;
65 
66 	bool private _inTaxSwap = false;
67 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
68 	address private _wethAddress = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
69 	IUniswapV2Router02 private _uniswapV2Router;
70 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
71 
72 	event TokensBurned(address burnedFrom, uint256 tokenAmount);
73 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
74 	event TaxRatesChanged(uint8 taxRateBuy, uint8 taxRateSell, uint8 taxRateTransfer, bool buySupport);
75 	event TaxWalletsChanged(address marketing, address development, address charity, address buyback);
76 	event TaxDistributionChanged(uint16 autoLP, uint16 marketing, uint16 development, uint16 charity, uint16 buyback);
77 	event LimitsIncreased(uint256 maxTransaction, uint256 maxWalletSize);
78 	event TaxSwapSettingsChanged(uint256 taxSwapMin, uint256 taxSwapMax);
79 	event WalletExemptionsSet(address wallet, bool noFees, bool noLimits);
80 
81 
82 	constructor() Auth(msg.sender) {
83 		_tradingOpen = false;
84 		fee_taxRateMaxLimit = 11;
85 		lim_maxTxAmount = _totalSupply;
86 		lim_maxWalletAmount = _totalSupply;
87 		lim_taxSwapMin = _totalSupply * 10 / 10000;
88 		lim_taxSwapMax = _totalSupply * 50 / 10000;
89 		fee_sharesAutoLP = 300;
90 		fee_sharesMarketing = 300;
91 		fee_sharesDevelopment = 300;
92 		fee_sharesCharity = 100;
93 		fee_sharesBuyback = 100;
94 		fee_sharesTOTAL = fee_sharesAutoLP + fee_sharesMarketing + fee_sharesDevelopment + fee_sharesCharity + fee_sharesBuyback;
95 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
96 
97 		wlt_marketing = payable(0x6a61ab526CEBD515a7a22BfA4b7614F819d1e498);
98 		wlt_development = payable(0xB72524dcE54383dEc67FA674e16D6Ba9B8D9aCc1);
99 		wlt_charity = payable(0xDe8102579e1E10669e585c046de820EcE332C9Ac);
100 		wlt_buyback = payable(0x5f0004f0DFa960A842e5571126bF95c273878Bc1);
101 
102 		exm_noFees[owner] = true;
103 		exm_noFees[address(this)] = true;
104 		exm_noFees[_uniswapV2RouterAddress] = true;
105 		exm_noFees[wlt_marketing] = true;
106 		exm_noFees[wlt_development] = true;
107 		exm_noFees[wlt_charity] = true;
108 		exm_noFees[wlt_buyback] = true;
109 
110 		exm_noLimits[owner] = true;
111 		exm_noLimits[address(this)] = true;
112 		exm_noLimits[_uniswapV2RouterAddress] = true;
113 		exm_noLimits[wlt_marketing] = true;
114 		exm_noLimits[wlt_development] = true;
115 		exm_noLimits[wlt_charity] = true;
116 		exm_noLimits[wlt_buyback] = true;
117 
118 		_balances[address(this)] = 1_345_453_713_993_929_670_215; //v1 token balance of LP at block 14681213, paired with 53.82 WETH
119 		emit Transfer(address(0), address(this), _balances[address(this)]);
120 		_balances[owner] = _totalSupply - _balances[address(this)];
121 		emit Transfer(address(0), owner, _balances[owner]);
122 	}
123 	
124 	receive() external payable {}
125 	
126 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
127 	function decimals() external pure override returns (uint8) { return _decimals; }
128 	function symbol() external pure override returns (string memory) { return _symbol; }
129 	function name() external pure override returns (string memory) { return _name; }
130 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
131 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
132 
133 	function approve(address spender, uint256 amount) public override returns (bool) {
134 		if ( _humanBlock > block.number && !_nonSniper[msg.sender] ) {
135 			_addBlacklist(msg.sender, block.number, true);
136 		}
137 
138 		_allowances[msg.sender][spender] = amount;
139 		emit Approval(msg.sender, spender, amount);
140 		return true;
141 	}
142 
143 	function transfer(address recipient, uint256 amount) external override returns (bool) {
144 		require(_checkTradingOpen(), "Trading not open");
145 		return _transferFrom(msg.sender, recipient, amount);
146 	}
147 
148 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
149 		require(_checkTradingOpen(), "Trading not open");
150 		if (_allowances[sender][msg.sender] != type(uint256).max){
151 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
152 		}
153 		return _transferFrom(sender, recipient, amount);
154 	}
155 
156 	function initLP(uint256 ethAmountWei) external onlyOwner {
157 		require(!_tradingOpen, "trading already open");
158 		require(_liquidityPool == address(0), "LP already initialized");
159 		require(ethAmountWei > 0, "eth cannot be 0");
160 
161 		_nonSniper[address(this)] = true;
162 		_nonSniper[owner] = true;
163 		_nonSniper[wlt_marketing] = true;
164 
165         _wethAddress = _uniswapV2Router.WETH(); //override the WETH address from router
166 		uint256 _contractETHBalance = address(this).balance;
167 		require(_contractETHBalance >= ethAmountWei, "not enough eth");
168 		uint256 _contractTokenBalance = balanceOf(address(this));
169 		require(_contractTokenBalance > 0, "no tokens");
170 		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _wethAddress);
171 		_liquidityPool = _uniLpAddr;
172 
173 		_isLiqPool[_uniLpAddr] = true;
174 		_nonSniper[_uniLpAddr] = true;
175 
176 		_approveRouter(_contractTokenBalance);
177 		_addLiquidity(_contractTokenBalance, ethAmountWei, false);
178 	}
179 
180 	function _approveRouter(uint256 _tokenAmount) internal {
181 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
182 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
183 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
184 		}
185 	}
186 
187 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
188 		address lpTokenRecipient = address(0);
189 		if ( !autoburn ) { lpTokenRecipient = owner; }
190 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
191 	}
192 
193 	function openTrading() external onlyOwner {
194 		require(!_tradingOpen, "trading already open");
195 		require(_liquidityPool != address(0), "LP not initialized");
196 		_openTrading();
197 	}
198 
199 	function _openTrading() internal {
200 		_humanBlock = block.number + 1;
201 		lim_maxTxAmount     = 100 * _totalSupply / 10000 + 10**_decimals; 
202 		lim_maxWalletAmount = 100 * _totalSupply / 10000 + 10**_decimals;
203 		fee_taxRateBuy = 11;
204 		fee_taxRateSell = 22; //temporarily doubled after launch to discourage dumps
205 		fee_taxRateTransfer = 0; 
206 		_tradingOpen = true;
207 	}
208 
209 	function tradingOpen() external view returns (bool) {
210 		if (_tradingOpen && block.number >= _humanBlock + 5) { return _tradingOpen; }
211 		else { return false; }
212 	}
213 
214 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
215 		require(sender!=address(0) && recipient!=address(0), "Zero address not allowed");
216 		if ( _humanBlock > block.number ) {
217 			if ( _blacklistBlock[sender] == 0 ) { _addBlacklist(recipient, block.number, true); }
218 			else { _addBlacklist(recipient, _blacklistBlock[sender], false); }
219 		} else {
220 			if ( _blacklistBlock[sender] != 0 ) { _addBlacklist(recipient, _blacklistBlock[sender], false); }
221 		}
222 
223 		if ( _tradingOpen && _blacklistBlock[sender] != 0 && _blacklistBlock[sender] < block.number ) { revert("blacklisted"); }
224 
225 		if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndLiquify();	}
226 
227 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(sender, recipient, amount), "TX exceeds limits"); }
228 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
229 		uint256 _transferAmount = amount - _taxAmount;
230 		_balances[sender] = _balances[sender] - amount;
231 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
232 		_balances[recipient] = _balances[recipient] + _transferAmount;
233 		emit Transfer(sender, recipient, amount);
234 		return true;
235 	}
236 
237 	function _addBlacklist(address wallet, uint256 blackBlockNum, bool addSniper) internal {
238 		if ( !_nonSniper[wallet] && _blacklistBlock[wallet] == 0 ) { 
239 			_blacklistBlock[wallet] = blackBlockNum; 
240 			if ( addSniper) { _blacklistedWallets ++; }
241 		}
242 	}
243 	
244 	function _checkLimits(address sender, address recipient, uint256 transferAmount) internal view returns (bool) {
245 		bool limitCheckPassed = true;
246 		if ( _tradingOpen && !exm_noLimits[recipient] && !exm_noLimits[sender] ) {
247 			if ( transferAmount > lim_maxTxAmount ) { limitCheckPassed = false; }
248 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > lim_maxWalletAmount) ) { limitCheckPassed = false; }
249 		}
250 		return limitCheckPassed;
251 	}
252 
253 	function _checkTradingOpen() private view returns (bool){
254 		bool checkResult = false;
255 		if ( _tradingOpen ) { checkResult = true; } 
256 		else if ( tx.origin == owner ) { checkResult = true; } 
257 		return checkResult;
258 	}
259 
260 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
261 		uint256 taxAmount;
262 		if ( !_tradingOpen || exm_noFees[sender] || exm_noFees[recipient] ) { taxAmount = 0; }
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
280 		exm_noFees[wallet] = noFees;
281 		exm_noLimits[wallet] = noLimits;
282 		emit WalletExemptionsSet(wallet, noFees, noLimits);
283 	}
284 
285 	function getFeeSettings() external view returns(uint8 taxRateMaxLimit, uint8 taxRateBuy, uint8 taxRateSell, uint8 taxRateTransfer, uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment, uint16 sharesCharity, uint16 sharesBuyback ) {
286 		return (fee_taxRateMaxLimit, fee_taxRateBuy, fee_taxRateSell, fee_taxRateTransfer, fee_sharesAutoLP, fee_sharesMarketing, fee_sharesDevelopment, fee_sharesCharity, fee_sharesBuyback);
287 	}
288 
289 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax, bool enableBuySupport) external onlyOwner {
290 		if (enableBuySupport) {
291 			require( newSellTax > newBuyTax, "Sell tax must be higher than buy tax");
292 			require( newBuyTax+newSellTax <= 2*fee_taxRateMaxLimit, "Avg tax too high");
293 		} else {
294 			require(newBuyTax <= fee_taxRateMaxLimit && newSellTax <= fee_taxRateMaxLimit, "Tax too high");
295 		}
296 		require(newTxTax <= fee_taxRateMaxLimit, "Tax too high");
297 		fee_taxRateBuy = newBuyTax;
298 		fee_taxRateSell = newSellTax;
299 		fee_taxRateTransfer = newTxTax;
300 		emit TaxRatesChanged(newBuyTax, newSellTax, newTxTax, enableBuySupport);
301 	}
302 
303 	function setTaxDistribution(uint16 sharesAutoLP, uint16 sharesMarketing, uint16 sharesDevelopment, uint16 sharesCharity, uint16 sharesBuyback) external onlyOwner {
304 		fee_sharesAutoLP = sharesAutoLP;
305 		fee_sharesMarketing = sharesMarketing;
306 		fee_sharesDevelopment = sharesDevelopment;
307 		fee_sharesCharity = sharesCharity;
308 		fee_sharesBuyback = sharesBuyback;
309 		fee_sharesTOTAL = fee_sharesAutoLP + fee_sharesMarketing + fee_sharesDevelopment + fee_sharesCharity + fee_sharesBuyback;
310 		emit TaxDistributionChanged(sharesAutoLP, sharesMarketing, sharesDevelopment, sharesCharity, sharesBuyback);
311 	}
312 	
313 	function getWallets() external view returns(address contractOwner, address liquidityPool, address marketing, address development, address charity, address buyback) {
314 		return (owner, _liquidityPool, wlt_marketing, wlt_development, wlt_charity, wlt_buyback);
315 	}
316 
317 	function setTaxWallets(address newMarketingWallet, address newDevelopmentWallet, address newCharityWallet, address newBuybackWallet) external onlyOwner {
318 		wlt_marketing = payable(newMarketingWallet);
319 		wlt_development = payable(newDevelopmentWallet);
320 		wlt_charity = payable(newCharityWallet);
321 		wlt_buyback = payable(newBuybackWallet);
322 		exm_noFees[newMarketingWallet] = true;
323 		exm_noLimits[newMarketingWallet] = true;
324 		exm_noFees[newBuybackWallet] = true;
325 		exm_noLimits[newBuybackWallet] = true;
326 		emit TaxWalletsChanged(newMarketingWallet, newDevelopmentWallet, newCharityWallet, newBuybackWallet);
327 	}
328 
329 	function getLimits() external view returns(uint256 maxTxAmount, uint256 maxWalletAmount, uint256 taxSwapMin, uint256 taxSwapMax) {
330 		return (lim_maxTxAmount, lim_maxWalletAmount, lim_taxSwapMin, lim_taxSwapMax);
331 	}
332 
333 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
334 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 1;
335 		require(newTxAmt >= lim_maxTxAmount, "tx limit too low");
336 		lim_maxTxAmount = newTxAmt;
337 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 1;
338 		require(newWalletAmt >= lim_maxWalletAmount, "wallet limit too low");
339 		lim_maxWalletAmount = newWalletAmt;
340 		emit LimitsIncreased(lim_maxTxAmount, lim_maxWalletAmount);
341 	}
342 
343 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
344 		lim_taxSwapMin = _totalSupply * minValue / minDivider;
345 		lim_taxSwapMax = _totalSupply * maxValue / maxDivider;
346 		require(lim_taxSwapMax > lim_taxSwapMin);
347 		emit TaxSwapSettingsChanged(lim_taxSwapMin, lim_taxSwapMax);
348 	}
349 
350 	function _swapTaxAndLiquify() private lockTaxSwap {
351 		uint256 _taxTokensAvailable = balanceOf(address(this));
352 
353 		if ( _taxTokensAvailable >= lim_taxSwapMin && _tradingOpen ) {
354 			if ( _taxTokensAvailable >= lim_taxSwapMax ) { _taxTokensAvailable = lim_taxSwapMax; }
355 			uint256 _tokensForLP = _taxTokensAvailable * fee_sharesAutoLP / fee_sharesTOTAL / 2;
356 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
357 			if (_tokensToSwap >= 10**_decimals) {
358 				uint256 _ethPreSwap = address(this).balance;
359 				_swapTaxTokensForEth(_tokensToSwap);
360 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
361 				if ( fee_sharesAutoLP > 0 ) {
362 					uint256 _ethWeiAmount = _ethSwapped * fee_sharesAutoLP / fee_sharesTOTAL ;
363 					_approveRouter(_tokensForLP);
364 					_addLiquidity(_tokensForLP, _ethWeiAmount, false);
365 				}
366 			}
367 			uint256 _contractETHBalance = address(this).balance;			
368 			if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
369 		}
370 	}
371 
372 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
373 		_approveRouter(_tokenAmount);
374 		address[] memory path = new address[](2);
375 		path[0] = address(this);
376 		path[1] = _wethAddress;
377 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
378 	}
379 
380 	function _distributeTaxEth(uint256 _amount) private {
381 		uint16 _ethTaxShareTotal = fee_sharesMarketing + fee_sharesDevelopment + fee_sharesCharity + fee_sharesBuyback; 
382 		if ( fee_sharesMarketing > 0 ) { wlt_marketing.transfer(_amount * fee_sharesMarketing / _ethTaxShareTotal); }
383 		if ( fee_sharesDevelopment > 0 ) { wlt_development.transfer(_amount * fee_sharesDevelopment / _ethTaxShareTotal); }
384 		if ( fee_sharesCharity > 0 ) { wlt_charity.transfer(_amount * fee_sharesCharity / _ethTaxShareTotal); }
385 		if ( fee_sharesBuyback > 0 ) { wlt_buyback.transfer(_amount * fee_sharesBuyback / _ethTaxShareTotal); }
386 	}
387 
388 	function taxTokensSwap() external onlyOwner {
389 		uint256 taxTokenBalance = balanceOf(address(this));
390 		require(taxTokenBalance > 0, "No tokens");
391 		_swapTaxTokensForEth(taxTokenBalance);
392 	}
393 
394 	function taxEthSend() external onlyOwner { 
395 		_distributeTaxEth(address(this).balance); 
396 	}
397 
398 	function burnTokens(uint256 amount) external {
399 		uint256 _tokensAvailable = balanceOf(msg.sender);
400 		require(amount <= _tokensAvailable, "Token balance too low");
401 		_balances[msg.sender] -= amount;
402 		_balances[address(0)] += amount;
403 		emit Transfer(msg.sender, address(0), amount);
404 		emit TokensBurned(msg.sender, amount);
405 	}
406 
407 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
408         require(addresses.length <= 200,"Wallet count over 200 (gas risk)");
409         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
410 
411         uint256 airdropTotal = 0;
412         for(uint i=0; i < addresses.length; i++){
413             airdropTotal += (tokenAmounts[i] * 10**_decimals);
414         }
415         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
416 
417         for(uint i=0; i < addresses.length; i++){
418             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
419             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
420 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
421         }
422 
423         emit TokensAirdropped(addresses.length, airdropTotal);
424     }
425 }