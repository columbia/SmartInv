1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.13;
4 
5 interface IERC20 {
6 	function totalSupply() external view returns (uint256);
7 
8 	function balanceOf(address account) external view returns (uint256);
9 
10 	function transfer(address recipient, uint256 amount)
11 	external
12 	returns (bool);
13 
14 	function allowance(address owner, address spender)
15 	external
16 	view
17 	returns (uint256);
18 
19 	function approve(address spender, uint256 amount) external returns (bool);
20 
21 	function transferFrom(
22 		address sender,
23 		address recipient,
24 		uint256 amount
25 	) external returns (bool);
26 
27 	event Transfer(address indexed from, address indexed to, uint256 value);
28 
29 	event Approval(
30 		address indexed owner,
31 		address indexed spender,
32 		uint256 value
33 	);
34 }
35 
36 interface IFactory {
37 	function createPair(address tokenA, address tokenB)
38 	external
39 	returns (address pair);
40 
41 	function getPair(address tokenA, address tokenB)
42 	external
43 	view
44 	returns (address pair);
45 }
46 
47 interface IRouter {
48 	function factory() external pure returns (address);
49 
50 	function WETH() external pure returns (address);
51 
52 	function addLiquidityETH(
53 		address token,
54 		uint256 amountTokenDesired,
55 		uint256 amountTokenMin,
56 		uint256 amountETHMin,
57 		address to,
58 		uint256 deadline
59 	)
60 	external
61 	payable
62 	returns (
63 		uint256 amountToken,
64 		uint256 amountETH,
65 		uint256 liquidity
66 	);
67 
68 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
69 		uint256 amountOutMin,
70 		address[] calldata path,
71 		address to,
72 		uint256 deadline
73 	) external payable;
74 
75 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
76 		uint256 amountIn,
77 		uint256 amountOutMin,
78 		address[] calldata path,
79 		address to,
80 		uint256 deadline
81 	) external;
82 }
83 
84 interface IERC20Metadata is IERC20 {
85 	function name() external view returns (string memory);
86 	function symbol() external view returns (string memory);
87 	function decimals() external view returns (uint8);
88 }
89 
90 library SafeMath {
91 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
92 		uint256 c = a + b;
93 		require(c >= a, "SafeMath: addition overflow");
94 
95 		return c;
96 	}
97 
98 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99 		return sub(a, b, "SafeMath: subtraction overflow");
100 	}
101 
102 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103 		require(b <= a, errorMessage);
104 		uint256 c = a - b;
105 
106 		return c;
107 	}
108 
109 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111 		// benefit is lost if 'b' is also tested.
112 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
113 		if (a == 0) {
114 			return 0;
115 		}
116 
117 		uint256 c = a * b;
118 		require(c / a == b, "SafeMath: multiplication overflow");
119 
120 		return c;
121 	}
122 
123 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
124 		return div(a, b, "SafeMath: division by zero");
125 	}
126 
127 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128 		require(b > 0, errorMessage);
129 		uint256 c = a / b;
130 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132 		return c;
133 	}
134 
135 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136 		return mod(a, b, "SafeMath: modulo by zero");
137 	}
138 
139 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140 		require(b != 0, errorMessage);
141 		return a % b;
142 	}
143 }
144 
145 abstract contract Context {
146 	function _msgSender() internal view virtual returns (address) {
147 		return msg.sender;
148 	}
149 
150 	function _msgData() internal view virtual returns (bytes calldata) {
151 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
152 		return msg.data;
153 	}
154 }
155 
156 contract Ownable is Context {
157 	address private _owner;
158 
159 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161 	constructor () {
162 		address msgSender = _msgSender();
163 		_owner = msgSender;
164 		emit OwnershipTransferred(address(0), msgSender);
165 	}
166 
167 	function owner() public view returns (address) {
168 		return _owner;
169 	}
170 
171 	modifier onlyOwner() {
172 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
173 		_;
174 	}
175 
176 	function renounceOwnership() public virtual onlyOwner {
177 		emit OwnershipTransferred(_owner, address(0));
178 		_owner = address(0);
179 	}
180 
181 	function transferOwnership(address newOwner) public virtual onlyOwner {
182 		require(newOwner != address(0), "Ownable: new owner is the zero address");
183 		emit OwnershipTransferred(_owner, newOwner);
184 		_owner = newOwner;
185 	}
186 }
187 
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189 	using SafeMath for uint256;
190 
191 	mapping(address => uint256) private _balances;
192 	mapping(address => mapping(address => uint256)) private _allowances;
193 
194 	uint256 private _totalSupply;
195 	string private _name;
196 	string private _symbol;
197 
198 	constructor(string memory name_, string memory symbol_) {
199 		_name = name_;
200 		_symbol = symbol_;
201 	}
202 
203 	function name() public view virtual override returns (string memory) {
204 		return _name;
205 	}
206 
207 	function symbol() public view virtual override returns (string memory) {
208 		return _symbol;
209 	}
210 
211 	function decimals() public view virtual override returns (uint8) {
212 		return 18;
213 	}
214 
215 	function totalSupply() public view virtual override returns (uint256) {
216 		return _totalSupply;
217 	}
218 
219 	function balanceOf(address account) public view virtual override returns (uint256) {
220 		return _balances[account];
221 	}
222 
223 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
224 		_transfer(_msgSender(), recipient, amount);
225 		return true;
226 	}
227 
228 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
229 		return _allowances[owner][spender];
230 	}
231 
232 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
233 		_approve(_msgSender(), spender, amount);
234 		return true;
235 	}
236 
237 	function transferFrom(
238 		address sender,
239 		address recipient,
240 		uint256 amount
241 	) public virtual override returns (bool) {
242 		_transfer(sender, recipient, amount);
243 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244 		return true;
245 	}
246 
247 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
249 		return true;
250 	}
251 
252 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
253 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
254 		return true;
255 	}
256 
257 	function _transfer(
258 		address sender,
259 		address recipient,
260 		uint256 amount
261 	) internal virtual {
262 		require(sender != address(0), "ERC20: transfer from the zero address");
263 		require(recipient != address(0), "ERC20: transfer to the zero address");
264 		_beforeTokenTransfer(sender, recipient, amount);
265 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
266 		_balances[recipient] = _balances[recipient].add(amount);
267 		emit Transfer(sender, recipient, amount);
268 	}
269 
270 	function _mint(address account, uint256 amount) internal virtual {
271 		require(account != address(0), "ERC20: mint to the zero address");
272 		_beforeTokenTransfer(address(0), account, amount);
273 		_totalSupply = _totalSupply.add(amount);
274 		_balances[account] = _balances[account].add(amount);
275 		emit Transfer(address(0), account, amount);
276 	}
277 
278 	function _burn(address account, uint256 amount) internal virtual {
279 		require(account != address(0), "ERC20: burn from the zero address");
280 		_beforeTokenTransfer(account, address(0), amount);
281 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
282 		_totalSupply = _totalSupply.sub(amount);
283 		emit Transfer(account, address(0), amount);
284 	}
285 
286 	function _approve(
287 		address owner,
288 		address spender,
289 		uint256 amount
290 	) internal virtual {
291 		require(owner != address(0), "ERC20: approve from the zero address");
292 		require(spender != address(0), "ERC20: approve to the zero address");
293 		_allowances[owner][spender] = amount;
294 		emit Approval(owner, spender, amount);
295 	}
296 
297 	function _beforeTokenTransfer(
298 		address from,
299 		address to,
300 		uint256 amount
301 	) internal virtual {}
302 }
303 
304 contract SCARDust is ERC20, Ownable {
305 	IRouter public uniswapV2Router;
306 	address public immutable uniswapV2Pair;
307 
308 	string private constant _name = "SCARDust";
309 	string private constant _symbol = "SCARD";
310 	uint8 private constant _decimals = 18;
311 
312 	bool public isTradingEnabled;
313 	uint256 private _launchTimestamp;
314 	uint256 private _launchBlockNumber;
315 
316 	// initialSupply
317 	uint256 constant initialSupply = 10000000000003 * (10**18);
318 
319 	// max wallet is 4% of initialSupply
320 	uint256 public maxWalletAmount = initialSupply * 400 / 10000;
321 
322 	// max transaction is 4% of initialSupply
323 	uint256 public maxTxAmount = initialSupply * 400 / 10000;
324 
325 	bool private _swapping;
326 	// swap and liquify at 0.025% of initialSupply
327 	uint256 public minimumTokensBeforeSwap = initialSupply * 250 / 1000000;
328 
329 	address public liquidityWallet;
330 	address public operationsWallet;
331 	address public buyBackWallet;
332 	address public charityWallet;
333 
334 	struct CustomTaxPeriod {
335 		bytes23 periodName;
336 		uint8 blocksInPeriod;
337 		uint256 timeInPeriod;
338 		uint8 liquidityFeeOnBuy;
339 		uint8 liquidityFeeOnSell;
340 		uint8 operationsFeeOnBuy;
341 		uint8 operationsFeeOnSell;
342 		uint8 buyBackFeeOnBuy;
343 		uint8 buyBackFeeOnSell;
344 		uint8 charityFeeOnBuy;
345 		uint8 charityFeeOnSell;
346 	}
347 	// Base taxes
348 	CustomTaxPeriod private _default = CustomTaxPeriod('default',0,0,2,2,5,5,4,4,3,3);
349 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,2,2,5,5,4,4,3,3);
350 
351 	uint256 private constant _blockedTimeLimit = 172800;
352 	bool private _feeOnWalletTranfers;
353 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
354 	mapping (address => bool) private _feeOnSelectedWalletTransfers;
355 	mapping (address => bool) private _isExcludedFromFee;
356 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
357 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
358 	mapping (address => bool) public automatedMarketMakerPairs;
359 	mapping (address => bool) private _isBlocked;
360 
361 	uint8 private _liquidityFee;
362 	uint8 private _operationsFee;
363 	uint8 private _buyBackFee;
364 	uint8 private _charityFee;
365 	uint8 private _totalFee;
366 
367 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
368 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
369 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
370 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
371 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee, uint8 charityFee);
372 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
373 	event BlockedAccountChange(address indexed holder, bool indexed status);
374 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
375 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
376 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
377     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
378 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
379 	event ExcludeFromMaxTransactionChange(address indexed account, bool isExcluded);
380 	event FeeOnWalletTransferChange(bool indexed newValue, bool indexed oldValue);
381 	event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
382 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
383     event ClaimETHOverflow(uint256 amount);
384 	event FeesApplied(uint8 liquidityFee, uint8 operationsFee, uint8 buybackFee, uint8 charityFee, uint8 totalFee);
385 
386 	constructor() ERC20(_name, _symbol) {
387         liquidityWallet = owner();
388         operationsWallet = owner();
389 	    buyBackWallet = owner();
390 		charityWallet = owner();
391 
392 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Mainnet
393 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
394 			address(this),
395 			_uniswapV2Router.WETH()
396 		);
397 		uniswapV2Router = _uniswapV2Router;
398 		uniswapV2Pair = _uniswapV2Pair;
399 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
400 
401 		_isExcludedFromFee[owner()] = true;
402 		_isExcludedFromFee[address(this)] = true;
403 
404 		_isAllowedToTradeWhenDisabled[owner()] = true;
405 		_isAllowedToTradeWhenDisabled[address(this)] = true;
406 
407 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
408 		_isExcludedFromMaxTransactionLimit[owner()] = true;
409 
410 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
411 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
412 		_isExcludedFromMaxWalletLimit[address(this)] = true;
413 		_isExcludedFromMaxWalletLimit[owner()] = true;
414 
415 		_mint(owner(), initialSupply);
416 	}
417 
418 	receive() external payable {}
419 
420 	// Setters
421 	function activateTrading() external onlyOwner {
422 		isTradingEnabled = true;
423 		if (_launchTimestamp == 0) {
424 			_launchTimestamp = block.timestamp;
425 			_launchBlockNumber = block.number;
426 		}
427 	}
428 	function deactivateTrading() external onlyOwner {
429 		isTradingEnabled = false;
430 	}
431 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
432 		require(automatedMarketMakerPairs[pair] != value, "SCARDust: Automated market maker pair is already set to that value");
433 		automatedMarketMakerPairs[pair] = value;
434 		emit AutomatedMarketMakerPairChange(pair, value);
435 	}
436 	function excludeFromFees(address account, bool excluded) external onlyOwner {
437 		require(_isExcludedFromFee[account] != excluded, "SCARDust: Account is already the value of 'excluded'");
438 		_isExcludedFromFee[account] = excluded;
439 		emit ExcludeFromFeesChange(account, excluded);
440 	}
441 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
442 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "SCARDust: Account is already the value of 'excluded'");
443 		_isExcludedFromMaxTransactionLimit[account] = excluded;
444 		emit ExcludeFromMaxTransactionChange(account, excluded);
445 	}
446 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
447 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "SCARDust: Account is already the value of 'excluded'");
448 		_isExcludedFromMaxWalletLimit[account] = excluded;
449 		emit ExcludeFromMaxWalletChange(account, excluded);
450 	}
451 	function blockAccount(address account) external onlyOwner {
452 		require(!_isBlocked[account], "SCARDust: Account is already blocked");
453 		require((block.timestamp - _launchTimestamp) < _blockedTimeLimit, "SCARDust: Time to block accounts has expired");
454 		_isBlocked[account] = true;
455 		emit BlockedAccountChange(account, true);
456 	}
457 	function unblockAccount(address account) external onlyOwner {
458 		require(_isBlocked[account], "SCARDust: Account is not blocked");
459 		_isBlocked[account] = false;
460 		emit BlockedAccountChange(account, false);
461 	}
462 	function setWallets(address newLiquidityWallet, address newOperationsWallet, address newBuyBackWallet, address newCharityWallet) external onlyOwner {
463 		if(liquidityWallet != newLiquidityWallet) {
464 			require(newLiquidityWallet != address(0), "SCARDust: The liquidityWallet cannot be 0");
465 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
466 			liquidityWallet = newLiquidityWallet;
467 		}
468 		if(operationsWallet != newOperationsWallet) {
469 			require(newOperationsWallet != address(0), "SCARDust: The operationsWallet cannot be 0");
470 			emit WalletChange('operationsWallet', newOperationsWallet, operationsWallet);
471 			operationsWallet = newOperationsWallet;
472 		}
473 		if(buyBackWallet != newBuyBackWallet) {
474 			require(newBuyBackWallet != address(0), "SCARDust: The buyBackWallet cannot be 0");
475 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
476 			buyBackWallet = newBuyBackWallet;
477 		}
478 		if(charityWallet != newCharityWallet) {
479 			require(newCharityWallet != address(0), "SCARDust: The charityWallet cannot be 0");
480 			emit WalletChange('charityWallet', newCharityWallet, charityWallet);
481 			charityWallet = newCharityWallet;
482 		}
483 	}
484 	// Base Fees
485 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _operationsFeeOnBuy, uint8 _buybackFeeOnBuy, uint8 _charityFeeOnBuy) external onlyOwner {
486 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _operationsFeeOnBuy, _buybackFeeOnBuy, _charityFeeOnBuy);
487 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _operationsFeeOnBuy, _buybackFeeOnBuy, _charityFeeOnBuy);
488 	}
489 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _operationsFeeOnSell, uint8 _buybackFeeOnSell, uint8 _charityFeeOnSell) external onlyOwner {
490 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _operationsFeeOnSell, _buybackFeeOnSell, _charityFeeOnSell);
491 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _operationsFeeOnSell, _buybackFeeOnSell, _charityFeeOnSell);
492 	}
493 	function setFeeOnWalletTransfers(bool value) external onlyOwner {
494 		emit FeeOnWalletTransferChange(value, _feeOnWalletTranfers);
495 		_feeOnWalletTranfers = value;
496 	}
497 	function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
498 		require(_feeOnSelectedWalletTransfers[account] != value, "SCARDust: The selected wallet is already set to the value ");
499 		_feeOnSelectedWalletTransfers[account] = value;
500 		emit FeeOnSelectedWalletTransfersChange(account, value);
501 	}
502 	function setUniswapRouter(address newAddress) external onlyOwner {
503 		require(newAddress != address(uniswapV2Router), "SCARDust: The router already has that address");
504 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
505 		uniswapV2Router = IRouter(newAddress);
506 	}
507 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
508 		require(newValue != maxWalletAmount, "SCARDust: Cannot update maxWalletAmount to same value");
509 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
510 		maxWalletAmount = newValue;
511 	}
512 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
513 		require(newValue != maxTxAmount, "SCARDust: Cannot update maxTxAmount to same value");
514 		emit MaxTransactionAmountChange(newValue, maxTxAmount);
515 		maxTxAmount = newValue;
516 	}
517 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
518 		require(newValue != minimumTokensBeforeSwap, "SCARDust: Cannot update minimumTokensBeforeSwap to same value");
519 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
520 		minimumTokensBeforeSwap = newValue;
521 	}
522 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
523 		_isAllowedToTradeWhenDisabled[account] = allowed;
524 		emit AllowedWhenTradingDisabledChange(account, allowed);
525 	}
526 	function claimETHOverflow() external onlyOwner {
527 	    uint256 amount = address(this).balance;
528         (bool success,) = address(owner()).call{value : amount}("");
529         if (success){
530             emit ClaimETHOverflow(amount);
531         }
532 	}
533 
534 	// Getters
535 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8){
536 		return (_base.liquidityFeeOnBuy, _base.operationsFeeOnBuy, _base.buyBackFeeOnBuy, _base.charityFeeOnBuy);
537 	}
538 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8){
539 		return (_base.liquidityFeeOnSell, _base.operationsFeeOnSell, _base.buyBackFeeOnSell, _base.charityFeeOnSell);
540 	}
541 
542 	// Main
543 	function _transfer(
544 		address from,
545 		address to,
546 		uint256 amount
547 		) internal override {
548 			require(from != address(0), "ERC20: transfer from the zero address");
549 			require(to != address(0), "ERC20: transfer to the zero address");
550 
551 			if(amount == 0) {
552 				super._transfer(from, to, 0);
553 				return;
554 			}
555 
556 			bool isBuyFromLp = automatedMarketMakerPairs[from];
557 			bool isSelltoLp = automatedMarketMakerPairs[to];
558 
559 		    if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
560 				require(isTradingEnabled, "SCARDust: Trading is currently disabled.");
561 				require(!_isBlocked[to], "SCARDust: Account is blocked");
562 				require(!_isBlocked[from], "SCARDust: Account is blocked");
563 				if (!_isExcludedFromMaxWalletLimit[to]) {
564 					require((balanceOf(to) + amount) <= maxWalletAmount, "SCARDust: Expected wallet amount exceeds the maxWalletAmount.");
565 				}
566 				if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
567 					require(amount <= maxTxAmount, "SCARDust: Buy amount exceeds the maxTxAmount.");
568 				}
569 			}
570 
571 			_adjustTaxes(isBuyFromLp, isSelltoLp, from, to);
572 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
573 
574 			if (
575 				isTradingEnabled &&
576 				canSwap &&
577 				!_swapping &&
578 				_totalFee > 0 &&
579 				automatedMarketMakerPairs[to]
580 			) {
581 				_swapping = true;
582 				_swapAndLiquify();
583 				_swapping = false;
584 			}
585 
586 			bool takeFee = !_swapping && isTradingEnabled;
587 
588 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
589 				takeFee = false;
590 			}
591 			if (takeFee && _totalFee > 0) {
592 				uint256 fee = amount * _totalFee / 100;
593 				amount = amount - fee;
594 				super._transfer(from, address(this), fee);
595 			}
596 
597 			super._transfer(from, to, amount);
598 	}
599 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address from, address to) private {
600 		_liquidityFee = 0;
601 		_operationsFee = 0;
602 		_buyBackFee = 0;
603 		_charityFee = 0;
604 
605 		if (isBuyFromLp) {
606 			if ((block.number - _launchBlockNumber) <= 5) {
607 				_liquidityFee = 100;
608 			} else {
609 				_liquidityFee = _base.liquidityFeeOnBuy;
610 				_operationsFee = _base.operationsFeeOnBuy;
611 				_buyBackFee = _base.buyBackFeeOnBuy;
612 				_charityFee = _base.charityFeeOnBuy;
613 			}
614 		}
615 	    else if (isSelltoLp) {
616 	    	_liquidityFee = _base.liquidityFeeOnSell;
617 			_charityFee = _base.charityFeeOnSell;
618 			_operationsFee = _base.operationsFeeOnSell;
619 			_buyBackFee = _base.buyBackFeeOnSell;
620 		}
621 	 	else if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
622 			_liquidityFee = _base.liquidityFeeOnSell;
623 			_operationsFee = _base.operationsFeeOnSell;
624 			_buyBackFee = _base.buyBackFeeOnSell;
625 			_charityFee = _base.charityFeeOnSell;
626 		}
627 		else if (!isSelltoLp && !isBuyFromLp && !_feeOnSelectedWalletTransfers[from] && !_feeOnSelectedWalletTransfers[to] && _feeOnWalletTranfers) {
628 			_liquidityFee = _base.liquidityFeeOnBuy;
629 			_operationsFee = _base.operationsFeeOnBuy;
630 			_buyBackFee = _base.buyBackFeeOnBuy;
631 			_charityFee = _base.charityFeeOnBuy;
632 		}
633 		_totalFee = _liquidityFee + _operationsFee + _buyBackFee  + _charityFee;
634 		emit FeesApplied(_liquidityFee, _operationsFee, _buyBackFee, _charityFee, _totalFee);
635 	}
636 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
637 		uint8 _liquidityFeeOnSell,
638 		uint8 _operationsFeeOnSell,
639 		uint8 _buyBackFeeOnSell,
640 		uint8 _charityFeeOnSell
641 	) private {
642 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
643 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
644 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
645 		}
646 		if (map.operationsFeeOnSell != _operationsFeeOnSell) {
647 			emit CustomTaxPeriodChange(_operationsFeeOnSell, map.operationsFeeOnSell, 'operationsFeeOnSell', map.periodName);
648 			map.operationsFeeOnSell = _operationsFeeOnSell;
649 		}
650 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
651 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
652 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
653 		}
654 		if (map.charityFeeOnSell != _charityFeeOnSell) {
655 			emit CustomTaxPeriodChange(_charityFeeOnSell, map.charityFeeOnSell, 'charityFeeOnSell', map.periodName);
656 			map.charityFeeOnSell = _charityFeeOnSell;
657 		}
658 	}
659 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
660 		uint8 _liquidityFeeOnBuy,
661 		uint8 _operationsFeeOnBuy,
662 		uint8 _buyBackFeeOnBuy,
663 		uint8 _charityFeeOnBuy
664 		) private {
665 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
666 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
667 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
668 		}
669 		if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
670 			emit CustomTaxPeriodChange(_operationsFeeOnBuy, map.operationsFeeOnBuy, 'operationsFeeOnBuy', map.periodName);
671 			map.operationsFeeOnBuy = _operationsFeeOnBuy;
672 		}
673 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
674 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
675 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
676 		}
677 		if (map.charityFeeOnBuy != _charityFeeOnBuy) {
678 			emit CustomTaxPeriodChange(_charityFeeOnBuy, map.charityFeeOnBuy, 'charityFeeOnBuy', map.periodName);
679 			map.charityFeeOnBuy = _charityFeeOnBuy;
680 		}
681 	}
682 	function _swapAndLiquify() private {
683 		uint256 contractBalance = balanceOf(address(this));
684 		uint256 initialETHBalance = address(this).balance;
685 
686 		uint8 totalFeePrior = _totalFee;
687 
688 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
689 		uint256 amountToSwap = contractBalance - amountToLiquify;
690 
691 		_swapTokensForETH(amountToSwap);
692 
693 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
694 		uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
695 
696 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
697 		uint256 amountETHOperations = ETHBalanceAfterSwap * _operationsFee / totalETHFee;
698 		uint256 amountETHBuyBack = ETHBalanceAfterSwap * _buyBackFee / totalETHFee;
699 		uint256 amountETHCharity = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHOperations + amountETHBuyBack);
700 
701 		payable(operationsWallet).transfer(amountETHOperations);
702 		payable(buyBackWallet).transfer(amountETHBuyBack);
703 		payable(charityWallet).transfer(amountETHCharity);
704 
705 		if (amountToLiquify > 0) {
706 			_addLiquidity(amountToLiquify, amountETHLiquidity);
707 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
708 		}
709 
710 		_totalFee = totalFeePrior;
711 	}
712 	function _swapTokensForETH(uint256 tokenAmount) private {
713 		address[] memory path = new address[](2);
714 		path[0] = address(this);
715 		path[1] = uniswapV2Router.WETH();
716 		_approve(address(this), address(uniswapV2Router), tokenAmount);
717 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
718 			tokenAmount,
719 			0, // accept any amount of ETH
720 			path,
721 			address(this),
722 			block.timestamp
723 		);
724 	}
725 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
726 		_approve(address(this), address(uniswapV2Router), tokenAmount);
727 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
728 			address(this),
729 			tokenAmount,
730 			0, // slippage is unavoidable
731 			0, // slippage is unavoidable
732 			liquidityWallet,
733 			block.timestamp
734 		);
735 	}
736 }