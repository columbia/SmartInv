1 //SPDX-License-Identifier: MIT 
2 //Note: SafeMath is not used because it is redundant since solidity 0.8
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
25 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner; emit OwnershipTransferred(newOwner); }
26 	event OwnershipTransferred(address owner);
27 }
28 
29 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
30 interface IUniswapV2Router02 {
31 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
32 	function WETH() external pure returns (address);
33 	function factory() external pure returns (address);
34 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
35 }
36 
37 contract KNDX is IERC20, Auth {
38 	string constant _name = "Kondux";
39 	string constant _symbol = "KNDX";
40 	uint8 constant _decimals = 9;
41 	uint256 constant _totalSupply = 10_000_000_000_000 * 10**_decimals;
42 	mapping (address => uint256) _balances;
43 	mapping (address => mapping (address => uint256)) _allowances;
44 	mapping (address => bool) public excludedFromFees;
45 	bool public tradingOpen;
46 	uint256 public taxSwapMin; uint256 public taxSwapMax;
47 	mapping (address => bool) private _isLiqPool;
48 	uint8 constant _maxTaxRate = 5; 
49 	uint8 public taxRateBuy; uint8 public taxRateSell;
50 
51 	bool public antiBotEnabled;
52 	mapping (address => bool) public excludedFromAntiBot;
53 	mapping (address => uint256) private _lastSwapBlock;
54 
55 	address payable private taxWallet = payable(0x79BD02b5936FFdC5915cB7Cd58156E3169F4F569);
56 
57 	bool private _inTaxSwap = false;
58 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
59 	IUniswapV2Router02 private _uniswapV2Router;
60 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
61 
62 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
63 	event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
64 	event TaxWalletChanged(address newTaxWallet);
65 	event TaxRateChanged(uint8 newBuyTax, uint8 newSellTax);
66 
67 	constructor () Auth(msg.sender) {      
68 		taxSwapMin = _totalSupply * 10 / 10000;
69 		taxSwapMax = _totalSupply * 50 / 10000;
70 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
71 		excludedFromFees[_uniswapV2RouterAddress] = true;
72 
73 		excludedFromAntiBot[owner] = true;
74 		excludedFromAntiBot[address(this)] = true;
75 
76 		excludedFromFees[owner] = true;
77 		excludedFromFees[address(this)] = true;
78 		excludedFromFees[taxWallet] = true;
79 	}
80 
81 	receive() external payable {}
82 	
83 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
84 	function decimals() external pure override returns (uint8) { return _decimals; }
85 	function symbol() external pure override returns (string memory) { return _symbol; }
86 	function name() external pure override returns (string memory) { return _name; }
87 	function getOwner() external view override returns (address) { return owner; }
88 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
89 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
90 
91 	function approve(address spender, uint256 amount) public override returns (bool) {
92 		_allowances[msg.sender][spender] = amount;
93 		emit Approval(msg.sender, spender, amount);
94 		return true;
95 	}
96 
97 	function transfer(address recipient, uint256 amount) external override returns (bool) {
98 		require(_checkTradingOpen(), "Trading not open");
99 		return _transferFrom(msg.sender, recipient, amount);
100 	}
101 
102 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
103 		require(_checkTradingOpen(), "Trading not open");
104 		if (_allowances[sender][msg.sender] != type(uint256).max){
105 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
106 		}
107 		return _transferFrom(sender, recipient, amount);
108 	}
109 
110 	//TODO - fix addresses and values before deploying!
111 	function _distributeInitialBalances() internal {
112 		// Rewards pool allocation address 25% 2.5T: 0x700830a7E81Bee3cd485f27bd7fA4C6754DE437f 
113 		uint256 rewardsPoolAmount = 2_500_000_000_000 * 10**_decimals;
114 		_balances[address(0x700830a7E81Bee3cd485f27bd7fA4C6754DE437f)] = rewardsPoolAmount;
115 		emit Transfer(address(0), address(0x700830a7E81Bee3cd485f27bd7fA4C6754DE437f), rewardsPoolAmount );
116 
117 		// exchange/partnerships 25%  2.5T: 0xF5f6AA0Fd5Ae2cBF7e14e16be4642c5Fb1c0739D
118 		uint256 exchangePartnershipAmount = 2_500_000_000_000 * 10**_decimals;
119 		_balances[address(0xF5f6AA0Fd5Ae2cBF7e14e16be4642c5Fb1c0739D)] = exchangePartnershipAmount;
120 		emit Transfer(address(0), address(0xF5f6AA0Fd5Ae2cBF7e14e16be4642c5Fb1c0739D), exchangePartnershipAmount );
121 		 
122 		// Dev Fund 15% 1.5T: 0x107039123098d4b1aCef2c3e9FEd95031f42a61d 
123 		uint256 devFundAmount = 1_500_000_000_000 * 10**_decimals;
124 		_balances[address(0x107039123098d4b1aCef2c3e9FEd95031f42a61d)] = devFundAmount;
125 		emit Transfer(address(0), address(0x107039123098d4b1aCef2c3e9FEd95031f42a61d), devFundAmount );
126 
127 		// Team wallet 5% 500B: 0x4696c2555Be4231ca06C876c4c34AE0E0EeE32CC
128 		uint256 teamAmount = 500_000_000_000 * 10**_decimals;
129 		_balances[address(0x4696c2555Be4231ca06C876c4c34AE0E0EeE32CC)] = teamAmount;
130 		emit Transfer(address(0), address(0x4696c2555Be4231ca06C876c4c34AE0E0EeE32CC), teamAmount );
131 		 
132 		// Marketing 1.7% 170B: 0xB8A95684053fE7dD1543cabBae96F840374Be95b 
133 		uint256 marketingAmount = 161_948_209_087 * 10**_decimals;
134 		_balances[address(0xB8A95684053fE7dD1543cabBae96F840374Be95b)] = marketingAmount;
135 		emit Transfer(address(0), address(0xB8A95684053fE7dD1543cabBae96F840374Be95b), marketingAmount );
136 
137 		// TXN settlement address + 263B - 0x79BD02b5936FFdC5915cB7Cd58156E3169F4F569
138 		uint256 txnSettlementAmount = 263_000_000_000 * 10**_decimals;
139 		_balances[address(0x79BD02b5936FFdC5915cB7Cd58156E3169F4F569)] = txnSettlementAmount;
140 		emit Transfer(address(0), address(0x79BD02b5936FFdC5915cB7Cd58156E3169F4F569), txnSettlementAmount );
141 		
142 		// Burn amount =  287,545,998,160 
143 		uint256 burnAmount = 287_545_998_160 * 10**_decimals;
144 		_balances[address(0)] = burnAmount;
145 		emit Transfer(address(0), address(0), burnAmount );
146 		emit TokensBurned(address(0), burnAmount);
147 
148 		uint256 liquidityPoolAmount = 567_141_443_087 * 10**_decimals; 
149 		_balances[address(this)] = liquidityPoolAmount;
150 		emit Transfer(address(0), address(this), liquidityPoolAmount );
151 
152 		uint256 airdropTokensAmount = _totalSupply - txnSettlementAmount - rewardsPoolAmount - exchangePartnershipAmount - devFundAmount - teamAmount - marketingAmount - burnAmount - liquidityPoolAmount;
153 		_balances[address(0x32Bdac9Be1fe8BD91170a6Cd8A9502410127F5f4)] = airdropTokensAmount;
154 		emit Transfer(address(0), address(0x32Bdac9Be1fe8BD91170a6Cd8A9502410127F5f4), airdropTokensAmount );
155 	}
156 
157 	function initLP(uint256 ethAmountWei) external onlyOwner {
158 		require(!tradingOpen, "trading already open");
159 		require(ethAmountWei > 0, "eth cannot be 0");
160 
161 		_distributeInitialBalances();
162 
163 		uint256 _contractETHBalance = address(this).balance;
164 		require(_contractETHBalance >= ethAmountWei, "not enough eth");
165 		uint256 _contractTokenBalance = balanceOf(address(this));
166 		require(_contractTokenBalance > 0, "no tokens");
167 		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
168 		_isLiqPool[_uniLpAddr] = true;
169 
170 		_approveRouter(_contractTokenBalance);
171 		_addLiquidity(_contractTokenBalance, ethAmountWei, false);
172 
173 		_openTrading();
174 	}
175 
176 	function _approveRouter(uint256 _tokenAmount) internal {
177 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
178 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
179 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
180 		}
181 	}
182 
183 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
184 		address lpTokenRecipient = address(0);
185 		if ( !autoburn ) { lpTokenRecipient = owner; }
186 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
187 	}
188 
189 	function _openTrading() internal {
190 		taxRateBuy = 3;
191 		taxRateSell = 3;
192 		tradingOpen = true;
193 	}
194 
195 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
196 		require(sender != address(0) || recipient != address(0), "Zero wallet cannot do transfers.");
197 		if ( tradingOpen ) {
198 			if ( antiBotEnabled ) { checkAntiBot(sender, recipient); }
199 			if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndDistributeEth(); }
200 		}
201 
202 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
203 		uint256 _transferAmount = amount - _taxAmount;
204 		_balances[sender] = _balances[sender] - amount;
205 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
206 		_balances[recipient] = _balances[recipient] + _transferAmount;
207 		emit Transfer(sender, recipient, amount);
208 		return true;
209 	}
210 
211 	function _checkTradingOpen() private view returns (bool){
212 		bool checkResult = false;
213 		if ( tradingOpen ) { checkResult = true; } 
214 		else if ( tx.origin == owner ) { checkResult = true; } 
215 		return checkResult;
216 	}
217 
218 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
219 		uint256 taxAmount;
220 		if ( !tradingOpen || excludedFromFees[sender] || excludedFromFees[recipient] ) { taxAmount = 0; }
221 		else if ( _isLiqPool[sender] ) { taxAmount = amount * taxRateBuy / 100; }
222 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * taxRateSell / 100; }
223 		else { taxAmount = 0; }
224 		return taxAmount;
225 	}
226 
227 
228 	function burnTokens(uint256 amount) external {
229 		//burns tokens from the msg.sender's wallet
230 		uint256 _tokensAvailable = balanceOf(msg.sender);
231 		require(amount <= _tokensAvailable, "Token balance too low");
232 		_balances[msg.sender] -= amount;
233 		_balances[address(0)] += amount;
234 		emit Transfer(msg.sender,address(0), amount);
235 		emit TokensBurned(msg.sender, amount);
236 	}
237 
238 
239 	function checkAntiBot(address sender, address recipient) internal {
240 		if ( _isLiqPool[sender] && !excludedFromAntiBot[recipient] ) { //buy transactions
241 			require(_lastSwapBlock[recipient] < block.number, "AntiBot triggered");
242 			_lastSwapBlock[recipient] = block.number;
243 		} else if ( _isLiqPool[recipient] && !excludedFromAntiBot[sender] ) { //sell transactions
244 			require(_lastSwapBlock[sender] < block.number, "AntiBot triggered");
245 			_lastSwapBlock[sender] = block.number;
246 		}
247 	}
248 
249 	function enableAntiBot(bool isEnabled) external onlyOwner {
250 		antiBotEnabled = isEnabled;
251 	}
252 
253 	function excludeFromAntiBot(address wallet, bool isExcluded) external onlyOwner {
254 		if (!isExcluded) { require(wallet != address(this) && wallet != owner, "This address must be excluded" ); }
255 		excludedFromAntiBot[wallet] = isExcluded;
256 	}
257 
258 	function excludeFromFees(address wallet, bool isExcluded) external onlyOwner {
259 		if (isExcluded) { require(wallet != address(this) && wallet != owner, "Cannot enforce fees for this address"); }
260 		excludedFromFees[wallet] = isExcluded;
261 	}
262 
263 	function adjustTaxRate(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
264 		require(newBuyTax <= _maxTaxRate && newSellTax <= _maxTaxRate, "Tax too high");
265 		//set new tax rate percentage - cannot be higher than the default rate 5%
266 		taxRateBuy = newBuyTax;
267 		taxRateSell = newSellTax;
268 		emit TaxRateChanged(newBuyTax, newSellTax);
269 	}
270   
271 	function setTaxWallet(address newTaxWallet) external onlyOwner {
272 		taxWallet = payable(newTaxWallet);
273 		excludedFromFees[newTaxWallet] = true;
274 		emit TaxWalletChanged(newTaxWallet);
275 	}
276 
277 	function taxSwapSettings(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
278 		taxSwapMin = _totalSupply * minValue / minDivider;
279 		taxSwapMax = _totalSupply * maxValue / maxDivider;
280 		require(taxSwapMax>=taxSwapMin, "MinMax error");
281 		require(taxSwapMax>_totalSupply / 10000, "Upper threshold too low");
282 		require(taxSwapMax<_totalSupply / 10, "Upper threshold too high");
283 	}
284 
285 	function _swapTaxAndDistributeEth() private lockTaxSwap {
286 		uint256 _taxTokensAvailable = balanceOf(address(this));
287 		if ( _taxTokensAvailable >= taxSwapMin && tradingOpen ) {
288 			if ( _taxTokensAvailable >= taxSwapMax ) { _taxTokensAvailable = taxSwapMax; }
289 			_swapTaxTokensForEth(_taxTokensAvailable);
290 			uint256 _contractETHBalance = address(this).balance;
291 			if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
292 		}
293 	}
294 
295 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
296 		_approveRouter(_tokenAmount);
297 		address[] memory path = new address[](2);
298 		path[0] = address(this);
299 		path[1] = _uniswapV2Router.WETH();
300 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
301 	}
302 
303 	function _distributeTaxEth(uint256 _amount) private {
304 		taxWallet.transfer(_amount);
305 	}
306 
307 	function taxTokensSwap() external onlyOwner {
308 		uint256 taxTokenBalance = balanceOf(address(this));
309 		require(taxTokenBalance > 0, "No tokens");
310 		_swapTaxTokensForEth(taxTokenBalance);
311 	}
312 
313 	function taxEthSend() external onlyOwner { 
314 		uint256 _contractEthBalance = address(this).balance;
315 		require(_contractEthBalance > 0, "No ETH in contract to distribute");
316 		_distributeTaxEth(_contractEthBalance); 
317 	}
318 
319 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
320         require(addresses.length <= 200,"Wallet count over 200 (gas risk)");
321         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
322 
323         uint256 airdropTotal = 0;
324         for(uint i=0; i < addresses.length; i++){
325             airdropTotal += (tokenAmounts[i] * 10**_decimals);
326         }
327         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
328 
329         for(uint i=0; i < addresses.length; i++){
330             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
331             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
332 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
333         }
334 
335         emit TokensAirdropped(addresses.length, airdropTotal);
336     }
337 }