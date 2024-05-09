1 //SPDX-License-Identifier: MIT 
2 
3 pragma solidity 0.8.17;
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
24 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner; emit OwnershipTransferred(newOwner); }
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
36 contract KNDX is IERC20, Auth {
37 	string constant _name = "Kondux";
38 	string constant _symbol = "KNDX";
39 	uint8 constant _decimals = 9;
40 	uint256 constant _totalSupply = 1_000_000_000 * 10**_decimals;
41 	mapping (address => uint256) _balances;
42 	mapping (address => mapping (address => uint256)) _allowances;
43 	mapping (address => bool) public excludedFromFees;
44 	bool public tradingOpen;
45 	uint256 public taxSwapMin; uint256 public taxSwapMax;
46 	mapping (address => bool) private _isLiqPool;
47 	uint8 constant _maxTaxRate = 5; 
48 	uint8 public taxRateBuy; uint8 public taxRateSell;
49 
50 	bool public antiBotEnabled;
51 	mapping (address => bool) public excludedFromAntiBot;
52 	mapping (address => uint256) private _lastSwapBlock;
53 
54 	address payable private taxWallet = payable(0x79BD02b5936FFdC5915cB7Cd58156E3169F4F569);
55 
56 	bool private _inTaxSwap = false;
57 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
58 	IUniswapV2Router02 private _uniswapV2Router;
59 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
60 
61 	event TokensAirdropped(uint256 totalWallets, uint256 totalTokens);
62 	event TokensBurned(address indexed burnedByWallet, uint256 tokenAmount);
63 	event TaxWalletChanged(address newTaxWallet);
64 	event TaxRateChanged(uint8 newBuyTax, uint8 newSellTax);
65 
66 	constructor () Auth(msg.sender) {      
67 		taxSwapMin = _totalSupply * 10 / 10000;
68 		taxSwapMax = _totalSupply * 50 / 10000;
69 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
70 		excludedFromFees[_uniswapV2RouterAddress] = true;
71 
72 		excludedFromAntiBot[owner] = true;
73 		excludedFromAntiBot[address(this)] = true;
74 
75 		excludedFromFees[owner] = true;
76 		excludedFromFees[address(this)] = true;
77 		excludedFromFees[taxWallet] = true;
78 	}
79 
80 	receive() external payable {}
81 	
82 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
83 	function decimals() external pure override returns (uint8) { return _decimals; }
84 	function symbol() external pure override returns (string memory) { return _symbol; }
85 	function name() external pure override returns (string memory) { return _name; }
86 	function getOwner() external view override returns (address) { return owner; }
87 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
88 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
89 
90 	function approve(address spender, uint256 amount) public override returns (bool) {
91 		_allowances[msg.sender][spender] = amount;
92 		emit Approval(msg.sender, spender, amount);
93 		return true;
94 	}
95 
96 	function transfer(address recipient, uint256 amount) external override returns (bool) {
97 		require(_checkTradingOpen(), "Trading not open");
98 		return _transferFrom(msg.sender, recipient, amount);
99 	}
100 
101 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
102 		require(_checkTradingOpen(), "Trading not open");
103 		if (_allowances[sender][msg.sender] != type(uint256).max){
104 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
105 		}
106 		return _transferFrom(sender, recipient, amount);
107 	}
108 
109 	function _distributeInitialBalances() internal {
110 		//holder airdrops 27.965%, 1556 wallets
111 		uint256 airdropTokensAmount = 279_646_010 * 10**_decimals;
112 		_balances[owner] = airdropTokensAmount;
113 		emit Transfer(address(0), owner, airdropTokensAmount ); 
114 
115 		// Treasury 25%: 0x1D0A105F0cED39b207AE444957cc70483c04C767
116 		uint256 treasuryAmount = 250_000_000 * 10**_decimals;
117 		_balances[address(0x1D0A105F0cED39b207AE444957cc70483c04C767)] = treasuryAmount;
118 		emit Transfer(address(0), address(0x1D0A105F0cED39b207AE444957cc70483c04C767), treasuryAmount );
119 
120 		// Dev Fund 19.462% : 0xac5c6FDd4F32977eec56C48978bAe86CE08968e0 
121 		uint256 devFundAmount = 194_620_743 * 10**_decimals;
122 		_balances[address(0xac5c6FDd4F32977eec56C48978bAe86CE08968e0)] = devFundAmount;
123 		emit Transfer(address(0), address(0xac5c6FDd4F32977eec56C48978bAe86CE08968e0), devFundAmount );
124 
125 		// Rewards pool 15%: 0x94baCbCceE5c16520Ab8545c35e89eCE7017a34D 
126 		uint256 rewardsPoolAmount = 150_000_000 * 10**_decimals;
127 		_balances[address(0x94baCbCceE5c16520Ab8545c35e89eCE7017a34D)] = rewardsPoolAmount;
128 		emit Transfer(address(0), address(0x94baCbCceE5c16520Ab8545c35e89eCE7017a34D), rewardsPoolAmount );
129 
130 		// Marketing 44076978.428271124 : 0xCbE59E5967B80Ad18764d49c9184E6249aFe2D28 
131 		uint256 marketingAmount = 44_076_978 * 10**_decimals;
132 		_balances[address(0xCbE59E5967B80Ad18764d49c9184E6249aFe2D28)] = marketingAmount;
133 		emit Transfer(address(0), address(0xCbE59E5967B80Ad18764d49c9184E6249aFe2D28), marketingAmount );
134 
135 		//liquidity pool is 2.507%
136 		uint256 liquidityPoolAmount = 25_066_478 * 10**_decimals; 
137 		_balances[address(this)] = liquidityPoolAmount;
138 		emit Transfer(address(0), address(this), liquidityPoolAmount );
139 
140 		// Burn amount (diff between total supply and the above, ~ 5.659%
141 		uint256 burnAmount = _totalSupply - (airdropTokensAmount+treasuryAmount+devFundAmount+rewardsPoolAmount+marketingAmount+liquidityPoolAmount);
142 		_balances[address(0)] = burnAmount;
143 		emit Transfer(address(0), address(0), burnAmount );
144 		emit TokensBurned(address(0), burnAmount);
145 	}
146 
147 	function initLP() external onlyOwner {
148 		require(!tradingOpen, "trading already open");
149 
150 		_distributeInitialBalances();
151 
152 		uint256 _contractETHBalance = address(this).balance;
153 		require(_contractETHBalance > 0, "no eth in contract");
154 		uint256 _contractTokenBalance = balanceOf(address(this));
155 		require(_contractTokenBalance > 0, "no tokens");
156 		address _uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
157 		_isLiqPool[_uniLpAddr] = true;
158 
159 		_approveRouter(_contractTokenBalance);
160 		_addLiquidity(_contractTokenBalance, _contractETHBalance, false);
161 
162 		// _openTrading(); //trading will be open manually through enableTrading() function
163 	}
164 
165 	function _approveRouter(uint256 _tokenAmount) internal {
166 		if ( _allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount ) {
167 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
168 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
169 		}
170 	}
171 
172 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
173 		address lpTokenRecipient = address(0);
174 		if ( !autoburn ) { lpTokenRecipient = owner; }
175 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
176 	}
177 
178     function enableTrading() external onlyOwner {
179         _openTrading();
180     }
181 
182 	function _openTrading() internal {
183         require(!tradingOpen, "trading already open");
184 		taxRateBuy = 3;
185 		taxRateSell = 3;
186 		tradingOpen = true;
187 	}
188 
189 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
190 		require(sender != address(0) || recipient != address(0), "Zero wallet cannot do transfers.");
191 		if ( tradingOpen ) {
192 			if ( antiBotEnabled ) { checkAntiBot(sender, recipient); }
193 			if ( !_inTaxSwap && _isLiqPool[recipient] ) { _swapTaxAndDistributeEth(); }
194 		}
195 
196 		uint256 _taxAmount = _calculateTax(sender, recipient, amount);
197 		uint256 _transferAmount = amount - _taxAmount;
198 		_balances[sender] = _balances[sender] - amount;
199 		if ( _taxAmount > 0 ) { _balances[address(this)] = _balances[address(this)] + _taxAmount; }
200 		_balances[recipient] = _balances[recipient] + _transferAmount;
201 		emit Transfer(sender, recipient, amount);
202 		return true;
203 	}
204 
205 	function _checkTradingOpen() private view returns (bool){
206 		bool checkResult = false;
207 		if ( tradingOpen ) { checkResult = true; } 
208 		else if ( tx.origin == owner ) { checkResult = true; } 
209 		return checkResult;
210 	}
211 
212 	function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
213 		uint256 taxAmount;
214 		if ( !tradingOpen || excludedFromFees[sender] || excludedFromFees[recipient] ) { taxAmount = 0; }
215 		else if ( _isLiqPool[sender] ) { taxAmount = amount * taxRateBuy / 100; }
216 		else if ( _isLiqPool[recipient] ) { taxAmount = amount * taxRateSell / 100; }
217 		else { taxAmount = 0; }
218 		return taxAmount;
219 	}
220 
221 
222 	function burnTokens(uint256 amount) external {
223 		//burns tokens from the msg.sender's wallet
224 		uint256 _tokensAvailable = balanceOf(msg.sender);
225 		require(amount <= _tokensAvailable, "Token balance too low");
226 		_balances[msg.sender] -= amount;
227 		_balances[address(0)] += amount;
228 		emit Transfer(msg.sender,address(0), amount);
229 		emit TokensBurned(msg.sender, amount);
230 	}
231 
232 
233 	function checkAntiBot(address sender, address recipient) internal {
234 		if ( _isLiqPool[sender] && !excludedFromAntiBot[recipient] ) { //buy transactions
235 			require(_lastSwapBlock[recipient] < block.number, "AntiBot triggered");
236 			_lastSwapBlock[recipient] = block.number;
237 		} else if ( _isLiqPool[recipient] && !excludedFromAntiBot[sender] ) { //sell transactions
238 			require(_lastSwapBlock[sender] < block.number, "AntiBot triggered");
239 			_lastSwapBlock[sender] = block.number;
240 		}
241 	}
242 
243 	function enableAntiBot(bool isEnabled) external onlyOwner {
244 		antiBotEnabled = isEnabled;
245 	}
246 
247 	function excludeFromAntiBot(address wallet, bool isExcluded) external onlyOwner {
248 		if (!isExcluded) { require(wallet != address(this) && wallet != owner, "This address must be excluded" ); }
249 		excludedFromAntiBot[wallet] = isExcluded;
250 	}
251 
252 	function excludeFromFees(address wallet, bool isExcluded) external onlyOwner {
253 		if (isExcluded) { require(wallet != address(this) && wallet != owner, "Cannot enforce fees for this address"); }
254 		excludedFromFees[wallet] = isExcluded;
255 	}
256 
257 	function adjustTaxRate(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
258 		require(newBuyTax <= _maxTaxRate && newSellTax <= _maxTaxRate, "Tax too high");
259 		//set new tax rate percentage - cannot be higher than the default rate 5%
260 		taxRateBuy = newBuyTax;
261 		taxRateSell = newSellTax;
262 		emit TaxRateChanged(newBuyTax, newSellTax);
263 	}
264   
265 	function setTaxWallet(address newTaxWallet) external onlyOwner {
266 		taxWallet = payable(newTaxWallet);
267 		excludedFromFees[newTaxWallet] = true;
268 		emit TaxWalletChanged(newTaxWallet);
269 	}
270 
271 	function taxSwapSettings(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external onlyOwner {
272 		taxSwapMin = _totalSupply * minValue / minDivider;
273 		taxSwapMax = _totalSupply * maxValue / maxDivider;
274 		require(taxSwapMax>=taxSwapMin, "MinMax error");
275 		require(taxSwapMax>_totalSupply / 10000, "Upper threshold too low");
276 		require(taxSwapMax<_totalSupply * 2 / 100, "Upper threshold too high");
277 	}
278 
279 	function _swapTaxAndDistributeEth() private lockTaxSwap {
280 		uint256 _taxTokensAvailable = balanceOf(address(this));
281 		if ( _taxTokensAvailable >= taxSwapMin && tradingOpen ) {
282 			if ( _taxTokensAvailable >= taxSwapMax ) { _taxTokensAvailable = taxSwapMax; }
283 			if ( _taxTokensAvailable > 10**_decimals) {
284 				_swapTaxTokensForEth(_taxTokensAvailable);
285 				uint256 _contractETHBalance = address(this).balance;
286 				if (_contractETHBalance > 0) { _distributeTaxEth(_contractETHBalance); }
287 			}
288 			
289 		}
290 	}
291 
292 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
293 		_approveRouter(_tokenAmount);
294 		address[] memory path = new address[](2);
295 		path[0] = address(this);
296 		path[1] = _uniswapV2Router.WETH();
297 		_uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
298 	}
299 
300 	function _distributeTaxEth(uint256 _amount) private {
301 		taxWallet.transfer(_amount);
302 	}
303 
304 	function taxTokensSwap() external onlyOwner {
305 		uint256 taxTokenBalance = balanceOf(address(this));
306 		require(taxTokenBalance > 0, "No tokens");
307 		_swapTaxTokensForEth(taxTokenBalance);
308 	}
309 
310 	function taxEthSend() external onlyOwner { 
311 		uint256 _contractEthBalance = address(this).balance;
312 		require(_contractEthBalance > 0, "No ETH in contract to distribute");
313 		_distributeTaxEth(_contractEthBalance); 
314 	}
315 
316 	function airdrop(address[] calldata addresses, uint256[] calldata tokenAmounts) external onlyOwner {
317         require(addresses.length <= 250,"Wallet count over 250 (gas risk)");
318         require(addresses.length == tokenAmounts.length,"Address and token amount list mismach");
319 
320         uint256 airdropTotal = 0;
321         for(uint i=0; i < addresses.length; i++){
322             airdropTotal += (tokenAmounts[i] * 10**_decimals);
323         }
324         require(_balances[msg.sender] >= airdropTotal, "Token balance lower than airdrop total");
325 
326         for(uint i=0; i < addresses.length; i++){
327             _balances[msg.sender] -= (tokenAmounts[i] * 10**_decimals);
328             _balances[addresses[i]] += (tokenAmounts[i] * 10**_decimals);
329 			emit Transfer(msg.sender, addresses[i], (tokenAmounts[i] * 10**_decimals) );       
330         }
331 
332         emit TokensAirdropped(addresses.length, airdropTotal);
333     }
334 }