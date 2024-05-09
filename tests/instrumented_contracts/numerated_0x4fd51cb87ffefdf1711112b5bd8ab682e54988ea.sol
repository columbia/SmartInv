1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * @author Brewlabs
5  * This token contract has been developed by Brewlabs.info
6  */
7 
8 pragma solidity 0.8.15;
9 
10 interface IERC20 {
11 	function totalSupply() external view returns (uint256);
12 
13 	function balanceOf(address account) external view returns (uint256);
14 
15 	function transfer(address recipient, uint256 amount)
16 	external
17 	returns (bool);
18 
19 	function allowance(address owner, address spender)
20 	external
21 	view
22 	returns (uint256);
23 
24 	function approve(address spender, uint256 amount) external returns (bool);
25 
26 	function transferFrom(
27 		address sender,
28 		address recipient,
29 		uint256 amount
30 	) external returns (bool);
31 
32 	event Transfer(address indexed from, address indexed to, uint256 value);
33 
34 	event Approval(
35 		address indexed owner,
36 		address indexed spender,
37 		uint256 value
38 	);
39 }
40 
41 interface IFactory {
42 	function createPair(address tokenA, address tokenB)
43 	external
44 	returns (address pair);
45 
46 	function getPair(address tokenA, address tokenB)
47 	external
48 	view
49 	returns (address pair);
50 }
51 
52 interface IRouter {
53 	function factory() external pure returns (address);
54 
55 	function WETH() external pure returns (address);
56 
57 	function addLiquidityETH(
58 		address token,
59 		uint256 amountTokenDesired,
60 		uint256 amountTokenMin,
61 		uint256 amountETHMin,
62 		address to,
63 		uint256 deadline
64 	)
65 	external
66 	payable
67 	returns (
68 		uint256 amountToken,
69 		uint256 amountETH,
70 		uint256 liquidity
71 	);
72 
73 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
74 		uint256 amountOutMin,
75 		address[] calldata path,
76 		address to,
77 		uint256 deadline
78 	) external payable;
79 
80 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
81 		uint256 amountIn,
82 		uint256 amountOutMin,
83 		address[] calldata path,
84 		address to,
85 		uint256 deadline
86 	) external;
87 }
88 
89 interface IERC20Metadata is IERC20 {
90 	function name() external view returns (string memory);
91 	function symbol() external view returns (string memory);
92 	function decimals() external view returns (uint8);
93 }
94 
95 library SafeMath {
96 
97 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
98 		uint256 c = a + b;
99 		require(c >= a, "SafeMath: addition overflow");
100 
101 		return c;
102 	}
103 
104 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105 		return sub(a, b, "SafeMath: subtraction overflow");
106 	}
107 
108 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109 		require(b <= a, errorMessage);
110 		uint256 c = a - b;
111 
112 		return c;
113 	}
114 
115 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117 		// benefit is lost if 'b' is also tested.
118 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119 		if (a == 0) {
120 			return 0;
121 		}
122 
123 		uint256 c = a * b;
124 		require(c / a == b, "SafeMath: multiplication overflow");
125 
126 		return c;
127 	}
128 
129 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
130 		return div(a, b, "SafeMath: division by zero");
131 	}
132 
133 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134 		require(b > 0, errorMessage);
135 		uint256 c = a / b;
136 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138 		return c;
139 	}
140 
141 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142 		return mod(a, b, "SafeMath: modulo by zero");
143 	}
144 
145 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146 		require(b != 0, errorMessage);
147 		return a % b;
148 	}
149 }
150 
151 abstract contract Context {
152 	function _msgSender() internal view virtual returns (address) {
153 		return msg.sender;
154 	}
155 
156 	function _msgData() internal view virtual returns (bytes calldata) {
157 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
158 		return msg.data;
159 	}
160 }
161 
162 contract Ownable is Context {
163 	address private _owner;
164 
165 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167 	constructor () {
168 		address msgSender = _msgSender();
169 		_owner = msgSender;
170 		emit OwnershipTransferred(address(0), msgSender);
171 	}
172 
173 	function owner() public view returns (address) {
174 		return _owner;
175 	}
176 
177 	modifier onlyOwner() {
178 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
179 		_;
180 	}
181 
182 	function renounceOwnership() public virtual onlyOwner {
183 		emit OwnershipTransferred(_owner, address(0));
184 		_owner = address(0);
185 	}
186 
187 	function transferOwnership(address newOwner) public virtual onlyOwner {
188 		require(newOwner != address(0), "Ownable: new owner is the zero address");
189 		emit OwnershipTransferred(_owner, newOwner);
190 		_owner = newOwner;
191 	}
192 }
193 
194 contract ERC20 is Context, IERC20, IERC20Metadata {
195 	using SafeMath for uint256;
196 
197 	mapping(address => uint256) private _balances;
198 	mapping(address => mapping(address => uint256)) private _allowances;
199 
200 	uint256 private _totalSupply;
201 	string private _name;
202 	string private _symbol;
203 
204 	constructor(string memory name_, string memory symbol_) {
205 		_name = name_;
206 		_symbol = symbol_;
207 	}
208 
209 	function name() public view virtual override returns (string memory) {
210 		return _name;
211 	}
212 
213 	function symbol() public view virtual override returns (string memory) {
214 		return _symbol;
215 	}
216 
217 	function decimals() public view virtual override returns (uint8) {
218 		return 18;
219 	}
220 
221 	function totalSupply() public view virtual override returns (uint256) {
222 		return _totalSupply;
223 	}
224 
225 	function balanceOf(address account) public view virtual override returns (uint256) {
226 		return _balances[account];
227 	}
228 
229 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
230 		_transfer(_msgSender(), recipient, amount);
231 		return true;
232 	}
233 
234 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
235 		return _allowances[owner][spender];
236 	}
237 
238 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
239 		_approve(_msgSender(), spender, amount);
240 		return true;
241 	}
242 
243 	function transferFrom(
244 		address sender,
245 		address recipient,
246 		uint256 amount
247 	) public virtual override returns (bool) {
248 		_transfer(sender, recipient, amount);
249 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
250 		return true;
251 	}
252 
253 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
254 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
255 		return true;
256 	}
257 
258 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
259 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
260 		return true;
261 	}
262 
263 	function _transfer(
264 		address sender,
265 		address recipient,
266 		uint256 amount
267 	) internal virtual {
268 		require(sender != address(0), "ERC20: transfer from the zero address");
269 		require(recipient != address(0), "ERC20: transfer to the zero address");
270 		_beforeTokenTransfer(sender, recipient, amount);
271 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
272 		_balances[recipient] = _balances[recipient].add(amount);
273 		emit Transfer(sender, recipient, amount);
274 	}
275 
276 	function _mint(address account, uint256 amount) internal virtual {
277 		require(account != address(0), "ERC20: mint to the zero address");
278 		_beforeTokenTransfer(address(0), account, amount);
279 		_totalSupply = _totalSupply.add(amount);
280 		_balances[account] = _balances[account].add(amount);
281 		emit Transfer(address(0), account, amount);
282 	}
283 
284 	function _burn(address account, uint256 amount) internal virtual {
285 		require(account != address(0), "ERC20: burn from the zero address");
286 		_beforeTokenTransfer(account, address(0), amount);
287 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
288 		_totalSupply = _totalSupply.sub(amount);
289 		emit Transfer(account, address(0), amount);
290 	}
291 
292 	function _approve(
293 		address owner,
294 		address spender,
295 		uint256 amount
296 	) internal virtual {
297 		require(owner != address(0), "ERC20: approve from the zero address");
298 		require(spender != address(0), "ERC20: approve to the zero address");
299 		_allowances[owner][spender] = amount;
300 		emit Approval(owner, spender, amount);
301 	}
302 
303 	function _beforeTokenTransfer(
304 		address from,
305 		address to,
306 		uint256 amount
307 	) internal virtual {}
308 }
309 
310 contract WPTInvestingCorpToken is Ownable, ERC20 {
311 	IRouter public uniswapV2Router;
312 	address public immutable uniswapV2Pair;
313 
314 	string private constant _name = "WPT Investing Corp";
315 	string private constant _symbol = "WPT";
316 	uint8 private constant _decimals = 18;
317 
318 	bool public isTradingEnabled;
319 
320 	// initialSupply
321 	uint256 constant initialSupply = 10000000 * (10**18);
322 	uint256 public maxWalletAmount = initialSupply * 2 / 100;
323 	uint256 public maxTxAmount = initialSupply * 1 / 100;
324 
325 	bool private _swapping;
326 	uint256 public minimumTokensBeforeSwap = initialSupply * 25 / 100000;
327 
328 	address public liquidityWallet;
329 	address public operationsWallet;
330 	address public buyBackWallet;
331     address public treasuryWallet;
332 
333 	struct CustomTaxPeriod {
334 		bytes23 periodName;
335 		uint8 blocksInPeriod;
336 		uint256 timeInPeriod;
337 		uint8 liquidityFeeOnBuy;
338 		uint8 liquidityFeeOnSell;
339 		uint8 operationsFeeOnBuy;
340 		uint8 operationsFeeOnSell;
341 		uint8 buyBackFeeOnBuy;
342 		uint8 buyBackFeeOnSell;
343 		uint8 treasuryFeeOnBuy;
344 		uint8 treasuryFeeOnSell;
345 	}
346 
347 	// Base taxes
348 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,3,3,6,6,3,3,3,3);
349 
350     uint256 private _launchStartTimestamp;
351 	uint256 private _launchBlockNumber;
352     uint256 private constant _blockedTimeLimit = 172800;
353     mapping (address => bool) private _isBlocked;
354 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
355 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
356 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
357 	mapping (address => bool) private _isExcludedFromFee;
358 	mapping (address => bool) public automatedMarketMakerPairs;
359 
360 	uint8 private _liquidityFee;
361 	uint8 private _operationsFee;
362 	uint8 private _buyBackFee;
363 	uint8 private _treasuryFee;
364 	uint8 private _totalFee;
365 
366 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
367 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
368 	event WalletChange(string indexed indentifier, address indexed newWallet, address indexed oldWallet);
369 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee, uint8 treasuryFee);
370 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
371 	event BlockedAccountChange(address indexed holder, bool indexed status);
372     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
373 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
374 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
375 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
376 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
377 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
378 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
379 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
380     event ClaimETHOverflow(uint256 amount);
381 	event FeesApplied(uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee, uint8 treasuryFee, uint8 totalFee);
382 
383 	constructor() ERC20(_name, _symbol) {
384 		liquidityWallet = owner();
385 		operationsWallet = owner();
386 		buyBackWallet = owner();
387         treasuryWallet = owner();
388 
389 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
391 		uniswapV2Router = _uniswapV2Router;
392 		uniswapV2Pair = _uniswapV2Pair;
393 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
394 
395 		_isExcludedFromFee[owner()] = true;
396 		_isExcludedFromFee[address(this)] = true;
397 
398 		_isAllowedToTradeWhenDisabled[owner()] = true;
399 
400 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
401 
402 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
403 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
404 		_isExcludedFromMaxWalletLimit[address(this)] = true;
405 		_isExcludedFromMaxWalletLimit[owner()] = true;
406 
407 		_mint(owner(), initialSupply);
408 	}
409 
410 	receive() external payable {}
411 
412 	// Setters
413 	function activateTrading() external onlyOwner {
414 		isTradingEnabled = true;
415         if (_launchStartTimestamp == 0) {
416             _launchStartTimestamp = block.timestamp;
417             _launchBlockNumber = block.number;
418         }
419 	}
420 	function deactivateTrading() external onlyOwner {
421 		isTradingEnabled = false;
422 	}
423 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
424 		require(automatedMarketMakerPairs[pair] != value, "WarPigsToken: Automated market maker pair is already set to that value");
425 		automatedMarketMakerPairs[pair] = value;
426 		emit AutomatedMarketMakerPairChange(pair, value);
427 	}
428 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
429 		_isAllowedToTradeWhenDisabled[account] = allowed;
430 		emit AllowedWhenTradingDisabledChange(account, allowed);
431 	}
432 	function excludeFromFees(address account, bool excluded) external onlyOwner {
433 		require(_isExcludedFromFee[account] != excluded, "WarPigsToken: Account is already the value of 'excluded'");
434 		_isExcludedFromFee[account] = excluded;
435 		emit ExcludeFromFeesChange(account, excluded);
436 	}
437 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
438 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "WarPigsToken: Account is already the value of 'excluded'");
439 		_isExcludedFromMaxTransactionLimit[account] = excluded;
440 		emit ExcludeFromMaxTransferChange(account, excluded);
441 	}
442 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
443 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "WarPigsToken: Account is already the value of 'excluded'");
444 		_isExcludedFromMaxWalletLimit[account] = excluded;
445 		emit ExcludeFromMaxWalletChange(account, excluded);
446 	}
447 	function setWallets(address newLiquidityWallet, address newOperationsWallet, address newBuyBackWallet, address newTreasuryWallet) external onlyOwner {
448 		if(liquidityWallet != newLiquidityWallet) {
449 			require(newLiquidityWallet != address(0), "WarPigsToken: The liquidityWallet cannot be 0");
450 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
451 			liquidityWallet = newLiquidityWallet;
452 		}
453 		if(operationsWallet != newOperationsWallet) {
454 			require(newOperationsWallet != address(0), "WarPigsToken: The operationsWallet cannot be 0");
455 			emit WalletChange('operationsWallet', newOperationsWallet, operationsWallet);
456 			operationsWallet = newOperationsWallet;
457 		}
458 		if(buyBackWallet != newBuyBackWallet) {
459 			require(newBuyBackWallet != address(0), "WarPigsToken: The buyBackWallet cannot be 0");
460 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
461 			buyBackWallet = newBuyBackWallet;
462 		}
463         if(treasuryWallet != newTreasuryWallet) {
464 			require(newTreasuryWallet != address(0), "WarPigsToken: The treasuryWallet cannot be 0");
465 			emit WalletChange('treasuryWallet', newTreasuryWallet, treasuryWallet);
466 			treasuryWallet = newTreasuryWallet;
467 		}
468 	}
469     function blockAccount(address account) external onlyOwner {
470 		require(!_isBlocked[account], "WarPigsToken: Account is already blocked");
471 		if (_launchStartTimestamp > 0) {
472 			require((block.timestamp - _launchStartTimestamp) < _blockedTimeLimit, "WarPigsToken: Time to block accounts has expired");
473 		}
474 		_isBlocked[account] = true;
475 		emit BlockedAccountChange(account, true);
476 	}
477 	function unblockAccount(address account) external onlyOwner {
478 		require(_isBlocked[account], "WarPigsToken: Account is not blcoked");
479 		_isBlocked[account] = false;
480 		emit BlockedAccountChange(account, false);
481 	}
482 	// Base fees
483 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _operationsFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _treasuryFeeOnBuy) external onlyOwner {
484 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _operationsFeeOnBuy, _buyBackFeeOnBuy, _treasuryFeeOnBuy);
485 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _operationsFeeOnBuy, _buyBackFeeOnBuy, _treasuryFeeOnBuy);
486 	}
487 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _operationsFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _treasuryFeeOnSell) external onlyOwner {
488 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _operationsFeeOnSell, _buyBackFeeOnSell, _treasuryFeeOnSell);
489 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _operationsFeeOnSell, _buyBackFeeOnSell, _treasuryFeeOnSell);
490 	}
491 	function setUniswapRouter(address newAddress) external onlyOwner {
492 		require(newAddress != address(uniswapV2Router), "WarPigsToken: The router already has that address");
493 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
494 		uniswapV2Router = IRouter(newAddress);
495 	}
496 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
497 		require(newValue != minimumTokensBeforeSwap, "WarPigsToken: Cannot update minimumTokensBeforeSwap to same value");
498 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
499 		minimumTokensBeforeSwap = newValue;
500 	}
501 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
502         require(newValue != maxTxAmount, "WarPigsToken: Cannot update maxTxAmount to same value");
503         emit MaxTransactionAmountChange(newValue, maxTxAmount);
504         maxTxAmount = newValue;
505 	}
506 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
507 		require(newValue != maxWalletAmount, "WarPigsToken Cannot update maxWalletAmount to same value");
508 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
509 		maxWalletAmount = newValue;
510 	}
511 	function claimETHOverflow(uint256 amount) external onlyOwner {
512 	    require(amount < address(this).balance, "WarPigsToken: Cannot send more than contract balance");
513         (bool success,) = address(owner()).call{value : amount}("");
514         if (success){
515             emit ClaimETHOverflow(amount);
516         }
517 	}
518 
519 	// Getters
520 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8){
521 		return (_base.liquidityFeeOnBuy, _base.operationsFeeOnBuy, _base.buyBackFeeOnBuy, _base.treasuryFeeOnBuy);
522 	}
523 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8){
524 		return (_base.liquidityFeeOnSell, _base.operationsFeeOnSell, _base.buyBackFeeOnSell, _base.treasuryFeeOnSell);
525 	}
526 
527 	// Main
528 	function _transfer(
529 		address from,
530 		address to,
531 		uint256 amount
532 		) internal override {
533 			require(from != address(0), "ERC20: transfer from the zero address");
534 			require(to != address(0), "ERC20: transfer to the zero address");
535 
536 			if(amount == 0) {
537 				super._transfer(from, to, 0);
538 				return;
539 			}
540 
541 			bool isBuyFromLp = automatedMarketMakerPairs[from];
542 			bool isSelltoLp = automatedMarketMakerPairs[to];
543 
544 			if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
545 				require(isTradingEnabled, "WarPigsToken: Trading is currently disabled.");
546                 require(!_isBlocked[to], "WarPigsToken: Account is blocked");
547 			    require(!_isBlocked[from], "WarPigsToken: Account is blocked");
548 
549 				if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
550                 	require(amount <= maxTxAmount, "WarPigsToken: Amount exceeds the maxTxAmount.");
551 				}
552 				if (!_isExcludedFromMaxWalletLimit[to]) {
553 					require((balanceOf(to) + amount) <= maxWalletAmount, "WarPigsToken: Expected wallet amount exceeds the maxWalletAmount.");
554 				}
555 			}
556 
557 			_adjustTaxes(isBuyFromLp, isSelltoLp);
558 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
559 
560 			if (
561 				isTradingEnabled &&
562 				canSwap &&
563 				!_swapping &&
564 				_totalFee > 0 &&
565 				automatedMarketMakerPairs[to]
566 			) {
567 				_swapping = true;
568 				_swapAndLiquify();
569 				_swapping = false;
570 			}
571 
572 			bool takeFee = !_swapping && isTradingEnabled;
573 
574 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
575 				takeFee = false;
576 			}
577 			if (takeFee && _totalFee > 0) {
578 				uint256 fee = amount * _totalFee / 100;
579 				amount = amount - fee;
580 				super._transfer(from, address(this), fee);
581 			}
582 			super._transfer(from, to, amount);
583 	}
584 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp) private {
585 		_liquidityFee = 0;
586 		_operationsFee = 0;
587 		_buyBackFee = 0;
588 		_treasuryFee = 0;
589 
590 		if (isBuyFromLp) {
591             if (block.number - _launchBlockNumber <= 5) {
592                 _liquidityFee = 100;
593             }
594 			else {
595                 _liquidityFee = _base.liquidityFeeOnBuy;
596                 _operationsFee = _base.operationsFeeOnBuy;
597                 _buyBackFee = _base.buyBackFeeOnBuy;
598                 _treasuryFee = _base.treasuryFeeOnBuy;
599             }
600 		}
601 	    if (isSelltoLp) {
602 	    	_liquidityFee = _base.liquidityFeeOnSell;
603 			_operationsFee = _base.operationsFeeOnSell;
604 			_buyBackFee = _base.buyBackFeeOnSell;
605 			_treasuryFee = _base.treasuryFeeOnSell;
606 		}
607 		_totalFee = _liquidityFee + _operationsFee + _buyBackFee + _treasuryFee;
608 		emit FeesApplied(_liquidityFee, _operationsFee, _buyBackFee, _treasuryFee, _totalFee);
609 	}
610 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
611 		uint8 _liquidityFeeOnSell,
612 		uint8 _operationsFeeOnSell,
613 		uint8 _buyBackFeeOnSell,
614 		uint8 _treasuryFeeOnSell
615 	) private {
616 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
617 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
618 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
619 		}
620 		if (map.operationsFeeOnSell != _operationsFeeOnSell) {
621 			emit CustomTaxPeriodChange(_operationsFeeOnSell, map.operationsFeeOnSell, 'operationsFeeOnSell', map.periodName);
622 			map.operationsFeeOnSell = _operationsFeeOnSell;
623 		}
624 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
625 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
626 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
627 		}
628 		if (map.treasuryFeeOnSell != _treasuryFeeOnSell) {
629 			emit CustomTaxPeriodChange(_treasuryFeeOnSell, map.treasuryFeeOnSell, 'treasuryFeeOnSell', map.periodName);
630 			map.treasuryFeeOnSell = _treasuryFeeOnSell;
631 		}
632 	}
633 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
634 		uint8 _liquidityFeeOnBuy,
635 		uint8 _operationsFeeOnBuy,
636 		uint8 _buyBackFeeOnBuy,
637 		uint8 _treasuryFeeOnBuy
638 		) private {
639 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
640 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
641 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
642 		}
643 		if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
644 			emit CustomTaxPeriodChange(_operationsFeeOnBuy, map.operationsFeeOnBuy, 'operationsFeeOnBuy', map.periodName);
645 			map.operationsFeeOnBuy = _operationsFeeOnBuy;
646 		}
647 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
648 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
649 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
650 		}
651 		if (map.treasuryFeeOnBuy != _treasuryFeeOnBuy) {
652 			emit CustomTaxPeriodChange(_treasuryFeeOnBuy, map.treasuryFeeOnBuy, 'treasuryFeeOnBuy', map.periodName);
653 			map.treasuryFeeOnBuy = _treasuryFeeOnBuy;
654 		}
655 	}
656 	function _swapAndLiquify() private {
657 		uint256 contractBalance = balanceOf(address(this));
658 		uint256 initialETHBalance = address(this).balance;
659 
660 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
661 		uint256 amountToSwap = contractBalance - amountToLiquify;
662 
663 		_swapTokensForETH(amountToSwap);
664 
665 		uint256 ETHBalanceAfterSwap = address(this).balance  - initialETHBalance;
666 		uint256 totalETHFee = _totalFee - _liquidityFee / 2;
667 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
668 		uint256 amountETHBuyBack = ETHBalanceAfterSwap * _buyBackFee / totalETHFee;
669 		uint256 amountETHOperations = ETHBalanceAfterSwap * _operationsFee / totalETHFee;
670 		uint256 amountETHTreasury = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHBuyBack + amountETHOperations);
671 
672 		payable(buyBackWallet).transfer(amountETHBuyBack);
673 		payable(operationsWallet).transfer(amountETHOperations);
674         payable(treasuryWallet).transfer(amountETHTreasury);
675 
676 		if (amountToLiquify > 0) {
677 			_addLiquidity(amountToLiquify, amountETHLiquidity);
678 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
679         }
680 	}
681 	function _swapTokensForETH(uint256 tokenAmount) private {
682 		address[] memory path = new address[](2);
683 		path[0] = address(this);
684 		path[1] = uniswapV2Router.WETH();
685 		_approve(address(this), address(uniswapV2Router), tokenAmount);
686 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
687 			tokenAmount,
688 			0, // accept any amount of ETH
689 			path,
690 			address(this),
691 			block.timestamp
692 		);
693 	}
694 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
695 		_approve(address(this), address(uniswapV2Router), tokenAmount);
696 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
697 			address(this),
698 			tokenAmount,
699 			0, // slippage is unavoidable
700 			0, // slippage is unavoidable
701 			liquidityWallet,
702 			block.timestamp
703 		);
704 	}
705 }