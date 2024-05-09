1 //SPDX-License-Identifier: MIT
2 //SafeMath not used as obsolete since solidity ^0.8 
3 
4 pragma solidity 0.8.11;
5 
6 interface IERC20 {
7 	function totalSupply() external view returns (uint256);
8 	function decimals() external view returns (uint8);
9 	function symbol() external view returns (string memory);
10 	function name() external view returns (string memory);
11 	function getOwner() external view returns (address);
12 	function balanceOf(address account) external view returns (uint256);
13 	function transfer(address recipient, uint256 amount) external returns (bool);
14 	function allowance(address _owner, address spender) external view returns (uint256);
15 	function approve(address spender, uint256 amount) external returns (bool);
16 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 	event Transfer(address indexed from, address indexed to, uint256 value);
18 	event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 abstract contract Auth {
22 	address internal owner;
23 	constructor(address _owner) { owner = _owner; }
24 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
25 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
26 	event OwnershipTransferred(address owner);
27 }
28 
29 interface IUniswapV2Router02 {
30 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
31 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
32 }
33 
34 contract SHIFT is IERC20, Auth {
35 	string _name = "SHIFT TOKEN";
36 	string _symbol = "SHIFT";
37 	uint8 constant _decimals = 9;
38 	uint256 constant _totalSupply = 10 * (10**12) * (10 ** _decimals);
39 	uint32 _smd; uint32 _smr;
40 	mapping (address => uint256) _balances;
41 	mapping (address => mapping (address => uint256)) _allowances;
42 	mapping (address => bool) public noFees;
43 	mapping (address => bool) public noLimits;
44 	bool public tradingOpen;
45 	uint256 public maxTxAmount; uint256 public maxWalletAmount;
46 	uint256 private taxSwapMin; uint256 private taxSwapMax;
47 	mapping (address => bool) private _isLiqPool;
48 	mapping (address => address) private _liqPoolRouterCA;
49 	mapping (address => address) private _liqPoolPairedCA;
50 	uint8 private constant _maxTaxRate = 11; 
51 	uint8 public taxRateBuy; uint8 public taxRateSell; uint8 public taxRateTX;
52 	uint16 private _autoLPShares = 300;
53 	uint16 private _charityTaxShares = 100;
54 	uint16 private _marketingTaxShares = 300;
55 	uint16 private _developmentTaxShares = 300;
56 	uint16 private _buybackTaxShares = 100;
57 	uint16 private _totalTaxShares = _autoLPShares + _charityTaxShares + _marketingTaxShares + _developmentTaxShares + _buybackTaxShares;
58 	uint16 public blacklistLength = 0;
59 	address constant _burnWallet = address(0);
60 
61 	uint256 private _humanBlock = 0;
62 	mapping (address => uint256) public blacklistBlock;
63 
64 	address payable private _charityWallet = payable(0xE128c705F246B11F27Cf5C11C90cDf60c58DEeA5); 
65 	address payable private _marketingWallet = payable(0xB7fA60964dDD7DcC66d0b44964f18B326db5629A); 
66 	address payable private _developmentWallet = payable(0x4057d71C89392bABd174ceed9E166573203fCc8F); 
67 	address payable private _buybackWallet = payable(0x2e17749Ab4C57B2ebcdF8D70454B680c63Ed5eFB); 
68 
69 	bool private _inTaxSwap = false;
70 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
71 
72 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
73 
74 	constructor (uint32 smd, uint32 smr) Auth(msg.sender) {      
75 		tradingOpen = false;
76 		maxTxAmount = _totalSupply;
77 		maxWalletAmount = _totalSupply;
78 		taxSwapMin = _totalSupply * 10 / 10000;
79 		taxSwapMax = _totalSupply * 50 / 10000;
80 		noFees[owner] = true;
81 		noFees[address(this)] = true;
82 		noFees[_buybackWallet] = true;
83 		noLimits[owner] = true;
84 		noLimits[address(this)] = true;
85 		noLimits[_buybackWallet] = true;
86 		noLimits[_burnWallet] = true;
87 
88 		require(smd>0, "init out of bounds");
89 		_smd = smd; _smr = smr;
90 		_balances[address(owner)] = _totalSupply;
91 		emit Transfer(address(0), address(owner), _totalSupply);
92 	}
93 
94 	receive() external payable {}
95 	
96 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
97 	function decimals() external pure override returns (uint8) { return _decimals; }
98 	function symbol() external view override returns (string memory) { return _symbol; }
99 	function name() external view override returns (string memory) { return _name; }
100 	function getOwner() external view override returns (address) { return owner; }
101 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
102 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
103 
104 	function approve(address spender, uint256 amount) public override returns (bool) {
105 		require(balanceOf(msg.sender) > 0);
106 		_allowances[msg.sender][spender] = amount;
107 		emit Approval(msg.sender, spender, amount);
108 		return true;
109 	}
110 
111 	function transfer(address recipient, uint256 amount) external override returns (bool) {
112 		require(_checkTradingOpen(msg.sender), "Trading not open");
113 		return _transferFrom(msg.sender, recipient, amount);
114 	}
115 
116 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
117 		require(_checkTradingOpen(sender), "Trading not open");
118 		if(_allowances[sender][msg.sender] != type(uint256).max) { _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount; }
119 		return _transferFrom(sender, recipient, amount);
120 	}
121 
122 
123 	function setLiquidityPool(address liqPoolAddress, address swapRouterCA, address wethPairedCA, bool enabled) external onlyOwner {
124 		if (tradingOpen) { require(block.number < _humanBlock + 7200, "settings finalized"); } 
125 		//7200 blocks (~24 hours) post launch we still have a chance to change settings if something goes wrong. After that it's final.
126 		require(liqPoolAddress!=address(this) && swapRouterCA!=address(this) && wethPairedCA!=address(this));
127 
128 		_isLiqPool[liqPoolAddress] = enabled;
129 		_liqPoolRouterCA[liqPoolAddress] = swapRouterCA;
130 		_liqPoolPairedCA[liqPoolAddress] = wethPairedCA;
131 		noLimits[liqPoolAddress] = false;
132 		noFees[liqPoolAddress] = false;
133 
134 	}
135 
136 	function _approveRouter(address routerAddress, uint256 _tokenAmount) internal {
137 		if ( _allowances[address(this)][routerAddress] < _tokenAmount ) {
138 			_allowances[address(this)][routerAddress] = type(uint256).max;
139 			emit Approval(address(this), routerAddress, type(uint256).max);
140 		}
141 	}
142 
143 	function _addLiquidity(address routerAddress, uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
144 		address lpTokenRecipient = address(0);
145 		if ( !autoburn ) { lpTokenRecipient = owner; }
146 		IUniswapV2Router02 dexRouter = IUniswapV2Router02(routerAddress);
147 		dexRouter.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
148 	}
149 
150 	function openTrading() external onlyOwner {
151 		require(!tradingOpen, "trading already open");
152 		_openTrading();
153 	}
154 
155 	function _openTrading() internal {
156 		_humanBlock = block.number + 20;
157 		maxTxAmount     = 2 * _totalSupply / 1000 + 10**_decimals; 
158 		maxWalletAmount = 3 * _totalSupply / 1000 + 10**_decimals;
159 		taxRateBuy = _maxTaxRate;
160 		taxRateSell = _maxTaxRate * 2; //anti-dump tax for snipers dumping
161 		taxRateTX = _maxTaxRate; 
162 		tradingOpen = true;
163 	}
164 
165 	function humanize() external onlyOwner{
166 		require(tradingOpen);
167 		_humanize(0);
168 	}
169 
170 	function _humanize(uint8 blkcount) internal {
171 		require(_humanBlock > block.number || _humanBlock == 0,"already humanized");
172 		_humanBlock = block.number + blkcount;
173 	}
174 
175 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
176 		require(sender != address(0), "No transfers from Zero wallet");
177 
178 		if (!tradingOpen) { require(noFees[sender] && noLimits[sender], "Trading not open"); }
179 		else if ( _humanBlock > block.number ) {
180 			if ( uint160(address(recipient)) % _smd == _smr ) { _humanize(3); }
181 			else if ( blacklistBlock[sender] == 0 ) { _addBlacklist(recipient, block.number); }
182 			else { _addBlacklist(recipient, blacklistBlock[sender]); }
183 		} else {
184 			if ( blacklistBlock[sender] != 0 ) { _addBlacklist(recipient, blacklistBlock[sender]); }
185 			if ( block.number < _humanBlock + 10 && tx.gasprice > block.basefee ) {
186 				uint256 priceDiff = tx.gasprice - block.basefee;
187 		    	if ( priceDiff >= 45 * 10**9 ) { revert("Gas over limit"); }
188 		    }
189 		}
190 		if ( tradingOpen && blacklistBlock[sender] != 0 && blacklistBlock[sender] < block.number ) { revert("blacklisted"); }
191 
192 		if ( !_inTaxSwap && _isLiqPool[recipient] ) {
193 			_swapTaxAndLiquify(recipient);
194 		}
195 		if ( sender != address(this) && recipient != address(this) && sender != owner ) { require(_checkLimits(recipient, amount), "TX exceeds limits"); }
196 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
197 		uint256 _transferAmount = amount - _taxAmount;
198 		_balances[sender] = _balances[sender] - amount;
199 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
200 		_balances[recipient] = _balances[recipient] + _transferAmount;
201 		emit Transfer(sender, recipient, amount);
202 		return true;
203 	}
204 
205 	function _addBlacklist(address wallet, uint256 blacklistBlockNum) internal {
206 		if ( !_isLiqPool[wallet] && blacklistBlock[wallet] == 0 ) { 
207 			blacklistBlock[wallet] = blacklistBlockNum; 
208 			blacklistLength ++;
209 		}
210 	}
211 
212 	function _checkLimits(address recipient, uint256 transferAmount) internal view returns (bool) {
213 		bool limitCheckPassed = true;
214 		if ( tradingOpen && !noLimits[recipient] ) {
215 			if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
216 			else if ( !_isLiqPool[recipient] && (_balances[recipient] + transferAmount > maxWalletAmount) ) { limitCheckPassed = false; }
217 		}
218 		return limitCheckPassed;
219 	}
220 
221 	function _checkTradingOpen(address sender) private view returns (bool){
222 		bool checkResult = false;
223 		if ( tradingOpen ) { checkResult = true; } 
224 		else if ( tx.origin == owner ) { checkResult = true; } 
225 		else if (noFees[sender] && noLimits[sender]) { checkResult = true; } 
226 
227 		return checkResult;
228 	}
229 
230 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
231 		uint256 taxAmount;
232 		if ( !tradingOpen || noFees[sender] || noFees[recipient] ) { taxAmount = 0; }
233 		else if ( _isLiqPool[sender] ) { taxAmount = amount * taxRateBuy / 100; }
234 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * taxRateSell / 100; }
235 		else { taxAmount = amount * taxRateTX / 100; }
236 		return taxAmount;
237 	}
238 
239 	function isBlacklisted(address wallet) external view returns(bool) {
240 		if ( blacklistBlock[wallet] != 0 ) { return true; }
241 		else { return false; }
242 	}
243 
244 	function setExemptFromTax(address wallet, bool toggle) external onlyOwner {
245 		require(!_isLiqPool[wallet], "Cannot set tax for LP" );
246 		noFees[ wallet ] = toggle;
247 	}
248 
249 	function setExemptFromLimits(address wallet, bool setting) external onlyOwner {
250 		require(!_isLiqPool[wallet] && wallet!=address(0), "Address not allowed" );
251 		noLimits[ wallet ] = setting;
252 	}
253 
254 	function setTaxRates(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external onlyOwner {
255 		require(newBuyTax <= _maxTaxRate && newSellTax <= _maxTaxRate && newTxTax <= _maxTaxRate, "Tax too high");
256 		taxRateBuy = newBuyTax;
257 		taxRateSell = newSellTax;
258 		taxRateTX = newTxTax;
259 	}
260 
261 	function enableBuySupport() external onlyOwner {
262 		taxRateBuy = 0;
263 		taxRateSell = 2 * _maxTaxRate;
264 	}
265   
266 	function setTaxDistribution(uint16 sharesAutoLP, uint16 sharesCharity, uint16 sharesMarketing, uint16 sharesDevelopment, uint16 sharesBuyback) external onlyOwner {
267 		_autoLPShares = sharesAutoLP;
268 		_charityTaxShares = sharesCharity;
269 		_marketingTaxShares = sharesMarketing;
270 		_developmentTaxShares = sharesDevelopment;
271 		_buybackTaxShares = sharesBuyback;
272 		_totalTaxShares = _autoLPShares + _charityTaxShares + _marketingTaxShares + _developmentTaxShares + _buybackTaxShares;
273 	}
274 	
275 	function setTaxWallets(address newCharityWallet, address newMarketingWallet, address newDevelopmentWallet, address newBuybackWallet) external onlyOwner {
276 		_charityWallet = payable(newCharityWallet);
277 		_marketingWallet = payable(newMarketingWallet);
278 		_developmentWallet = payable(newDevelopmentWallet);
279 		_buybackWallet = payable(newBuybackWallet);
280 		noFees[newCharityWallet] = true;
281 		noFees[newMarketingWallet] = true;
282 		noFees[newDevelopmentWallet] = true;
283 		noFees[newBuybackWallet] = true;
284 		noLimits[newBuybackWallet] = true;
285 	}
286 
287 	function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external onlyOwner {
288 		uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000 + 10**_decimals;
289 		require(newTxAmt >= maxTxAmount, "tx limit too low");
290 		maxTxAmount = newTxAmt;
291 		uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000 + 10**_decimals;
292 		require(newWalletAmt >= maxWalletAmount, "wallet limit too low");
293 		maxWalletAmount = newWalletAmt;
294 	}
295 
296 	function setTaxSwapLimits(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
297 		taxSwapMin = _totalSupply * minValue / minDivider;
298 		taxSwapMax = _totalSupply * maxValue / maxDivider;
299 		require(taxSwapMax>=taxSwapMin, "MinMax error");
300 		require(taxSwapMax>_totalSupply / 100000, "Upper threshold too low");
301 		require(taxSwapMax<_totalSupply / 100, "Upper threshold too high");
302 	}
303 
304 	function _transferTaxTokens(address recipient, uint256 amount) private {
305 		if ( amount > 0 ) {
306 			_balances[address(this)] = _balances[address(this)] - amount;
307 			_balances[recipient] = _balances[recipient] + amount;
308 			emit Transfer(address(this), recipient, amount);
309 		}
310 	}
311 
312 	function _swapTaxAndLiquify(address _liqPoolAddress) private lockTaxSwap {
313 		uint256 _taxTokensAvailable = balanceOf(address(this));
314 
315 		if ( _taxTokensAvailable >= taxSwapMin && tradingOpen ) {
316 			if ( _taxTokensAvailable >= taxSwapMax ) { _taxTokensAvailable = taxSwapMax; }
317 			uint256 _tokensForLP = _taxTokensAvailable * _autoLPShares / _totalTaxShares / 2;
318 
319 			uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
320 			if( _tokensToSwap > 10**_decimals ) {
321 				uint256 _ethPreSwap = address(this).balance;
322 				_swapTaxTokensForEth(_liqPoolRouterCA[_liqPoolAddress], _liqPoolPairedCA[_liqPoolAddress], _tokensToSwap);
323 				uint256 _ethSwapped = address(this).balance - _ethPreSwap;
324 				if ( _autoLPShares > 0 ) {
325 					uint256 _ethWeiAmount = _ethSwapped * _autoLPShares / _totalTaxShares ;
326 					_approveRouter(_liqPoolRouterCA[_liqPoolAddress], _tokensForLP);
327 					_addLiquidity(_liqPoolRouterCA[_liqPoolAddress], _tokensForLP, _ethWeiAmount, false);
328 				}
329 			}
330 			uint256 _contractETHBalance = address(this).balance;
331 			if(_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
332 		}
333 	}
334 
335 	function _swapTaxTokensForEth(address routerAddress, address pairedCA, uint256 _tokenAmount) private {
336 		_approveRouter(routerAddress, _tokenAmount);
337 		address[] memory path = new address[](2);
338 		path[0] = address(this);
339 		path[1] = pairedCA;
340 		IUniswapV2Router02 dexRouter = IUniswapV2Router02(routerAddress);
341 		dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
342 	}
343 
344 	function _distributeTaxEth(uint256 _amount) private {
345 		uint16 _ethTaxShareTotal = _charityTaxShares + _marketingTaxShares + _developmentTaxShares + _buybackTaxShares;
346 		if ( _charityTaxShares > 0 ) { _charityWallet.transfer(_amount * _charityTaxShares / _ethTaxShareTotal); }
347 		if ( _marketingTaxShares > 0 ) { _marketingWallet.transfer(_amount * _marketingTaxShares / _ethTaxShareTotal); }
348 		if ( _developmentTaxShares > 0 ) { _developmentWallet.transfer(_amount * _developmentTaxShares / _ethTaxShareTotal); }
349 		if ( _buybackTaxShares > 0 ) { _buybackWallet.transfer(_amount * _buybackTaxShares / _ethTaxShareTotal); }
350 	}
351 
352 	function taxTokensSwap(address liqPoolAddress) external onlyOwner {
353 		uint256 taxTokenBalance = balanceOf(address(this));
354 		require(taxTokenBalance > 0, "No tokens");
355 		require(_isLiqPool[liqPoolAddress], "Invalid liquidity pool");
356 		_swapTaxTokensForEth(_liqPoolRouterCA[liqPoolAddress], _liqPoolPairedCA[liqPoolAddress], taxTokenBalance);
357 	}
358 
359 	function taxEthSend() external onlyOwner { 
360 		_distributeTaxEth(address(this).balance); 
361 	}
362 
363 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
364         require(addresses.length <= 200,"Wallet count over 200 (gas risk)");
365         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
366 
367         uint256 airdropTotal = 0;
368         for(uint i=0; i < addresses.length; i++){
369             airdropTotal += (tokenAmounts[i] * 10**_decimals);
370         }
371         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
372 
373         for(uint i=0; i < addresses.length; i++){
374             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
375             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
376 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
377         }
378 
379         emit TokensAirdropped(addresses.length, airdropTotal);
380     }
381 }