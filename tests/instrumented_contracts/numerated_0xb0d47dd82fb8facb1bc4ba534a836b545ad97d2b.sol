1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
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
91 
92 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
93 		uint256 c = a + b;
94 		require(c >= a, "SafeMath: addition overflow");
95 
96 		return c;
97 	}
98 
99 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100 		return sub(a, b, "SafeMath: subtraction overflow");
101 	}
102 
103 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104 		require(b <= a, errorMessage);
105 		uint256 c = a - b;
106 
107 		return c;
108 	}
109 
110 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112 		// benefit is lost if 'b' is also tested.
113 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
114 		if (a == 0) {
115 			return 0;
116 		}
117 
118 		uint256 c = a * b;
119 		require(c / a == b, "SafeMath: multiplication overflow");
120 
121 		return c;
122 	}
123 
124 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
125 		return div(a, b, "SafeMath: division by zero");
126 	}
127 
128 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129 		require(b > 0, errorMessage);
130 		uint256 c = a / b;
131 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133 		return c;
134 	}
135 
136 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137 		return mod(a, b, "SafeMath: modulo by zero");
138 	}
139 
140 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141 		require(b != 0, errorMessage);
142 		return a % b;
143 	}
144 }
145 
146 library IterableMapping {
147 	struct Map {
148 		address[] keys;
149 		mapping(address => uint) values;
150 		mapping(address => uint) indexOf;
151 		mapping(address => bool) inserted;
152 	}
153 
154 	function get(Map storage map, address key) public view returns (uint) {
155 		return map.values[key];
156 	}
157 
158 	function getIndexOfKey(Map storage map, address key) public view returns (int) {
159 		if(!map.inserted[key]) {
160 			return -1;
161 		}
162 		return int(map.indexOf[key]);
163 	}
164 
165 	function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
166 		return map.keys[index];
167 	}
168 
169 	function size(Map storage map) public view returns (uint) {
170 		return map.keys.length;
171 	}
172 
173 	function set(Map storage map, address key, uint val) public {
174 		if (map.inserted[key]) {
175 			map.values[key] = val;
176 		} else {
177 			map.inserted[key] = true;
178 			map.values[key] = val;
179 			map.indexOf[key] = map.keys.length;
180 			map.keys.push(key);
181 		}
182 	}
183 
184 	function remove(Map storage map, address key) public {
185 		if (!map.inserted[key]) {
186 			return;
187 		}
188 
189 		delete map.inserted[key];
190 		delete map.values[key];
191 
192 		uint index = map.indexOf[key];
193 		uint lastIndex = map.keys.length - 1;
194 		address lastKey = map.keys[lastIndex];
195 
196 		map.indexOf[lastKey] = index;
197 		delete map.indexOf[key];
198 
199 		map.keys[index] = lastKey;
200 		map.keys.pop();
201 	}
202 }
203 
204 abstract contract Context {
205 	function _msgSender() internal view virtual returns (address) {
206 		return msg.sender;
207 	}
208 
209 	function _msgData() internal view virtual returns (bytes calldata) {
210 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
211 		return msg.data;
212 	}
213 }
214 
215 contract Ownable is Context {
216 	address private _owner;
217 
218 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220 	constructor () {
221 		address msgSender = _msgSender();
222 		_owner = msgSender;
223 		emit OwnershipTransferred(address(0), msgSender);
224 	}
225 
226 	function owner() public view returns (address) {
227 		return _owner;
228 	}
229 
230 	modifier onlyOwner() {
231 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
232 		_;
233 	}
234 
235 	function renounceOwnership() public virtual onlyOwner {
236 		emit OwnershipTransferred(_owner, address(0));
237 		_owner = address(0);
238 	}
239 
240 	function transferOwnership(address newOwner) public virtual onlyOwner {
241 		require(newOwner != address(0), "Ownable: new owner is the zero address");
242 		emit OwnershipTransferred(_owner, newOwner);
243 		_owner = newOwner;
244 	}
245 }
246 
247 contract ERC20 is Context, IERC20, IERC20Metadata {
248 	using SafeMath for uint256;
249 
250 	mapping(address => uint256) private _balances;
251 	mapping(address => mapping(address => uint256)) private _allowances;
252 
253 	uint256 private _totalSupply;
254 	string private _name;
255 	string private _symbol;
256 
257 	constructor(string memory name_, string memory symbol_) {
258 		_name = name_;
259 		_symbol = symbol_;
260 	}
261 
262 	function name() public view virtual override returns (string memory) {
263 		return _name;
264 	}
265 
266 	function symbol() public view virtual override returns (string memory) {
267 		return _symbol;
268 	}
269 
270 	function decimals() public view virtual override returns (uint8) {
271 		return 18;
272 	}
273 
274 	function totalSupply() public view virtual override returns (uint256) {
275 		return _totalSupply;
276 	}
277 
278 	function balanceOf(address account) public view virtual override returns (uint256) {
279 		return _balances[account];
280 	}
281 
282 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
283 		_transfer(_msgSender(), recipient, amount);
284 		return true;
285 	}
286 
287 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
288 		return _allowances[owner][spender];
289 	}
290 
291 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
292 		_approve(_msgSender(), spender, amount);
293 		return true;
294 	}
295 
296 	function transferFrom(
297 		address sender,
298 		address recipient,
299 		uint256 amount
300 	) public virtual override returns (bool) {
301 		_transfer(sender, recipient, amount);
302 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
303 		return true;
304 	}
305 
306 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
307 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
308 		return true;
309 	}
310 
311 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
312 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
313 		return true;
314 	}
315 
316 	function _transfer(
317 		address sender,
318 		address recipient,
319 		uint256 amount
320 	) internal virtual {
321 		require(sender != address(0), "ERC20: transfer from the zero address");
322 		require(recipient != address(0), "ERC20: transfer to the zero address");
323 		_beforeTokenTransfer(sender, recipient, amount);
324 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
325 		_balances[recipient] = _balances[recipient].add(amount);
326 		emit Transfer(sender, recipient, amount);
327 	}
328 
329 	function _mint(address account, uint256 amount) internal virtual {
330 		require(account != address(0), "ERC20: mint to the zero address");
331 		_beforeTokenTransfer(address(0), account, amount);
332 		_totalSupply = _totalSupply.add(amount);
333 		_balances[account] = _balances[account].add(amount);
334 		emit Transfer(address(0), account, amount);
335 	}
336 
337 	function _burn(address account, uint256 amount) internal virtual {
338 		require(account != address(0), "ERC20: burn from the zero address");
339 		_beforeTokenTransfer(account, address(0), amount);
340 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
341 		_totalSupply = _totalSupply.sub(amount);
342 		emit Transfer(account, address(0), amount);
343 	}
344 
345 	function _approve(
346 		address owner,
347 		address spender,
348 		uint256 amount
349 	) internal virtual {
350 		require(owner != address(0), "ERC20: approve from the zero address");
351 		require(spender != address(0), "ERC20: approve to the zero address");
352 		_allowances[owner][spender] = amount;
353 		emit Approval(owner, spender, amount);
354 	}
355 
356 	function _beforeTokenTransfer(
357 		address from,
358 		address to,
359 		uint256 amount
360 	) internal virtual {}
361 }
362 
363 contract JigsawToken is ERC20, Ownable {
364 	using IterableMapping for IterableMapping.Map;
365 
366 	IRouter public uniswapV2Router;
367 	address public immutable uniswapV2Pair;
368 
369     IterableMapping.Map private tokenHoldersMap;
370 
371 	string private constant _name = "JigsawToken";
372 	string private constant _symbol = "JIGSAW";
373 	uint8 private constant _decimals = 18;
374 
375 	bool public isTradingEnabled;
376 	uint256 private _tradingPausedTimestamp;
377 
378 	// initialSupply
379 	uint256 constant initialSupply = 1000000000 * (10**18);
380 
381 	// max wallet is 2.0% of initialSupply
382 	uint256 public maxWalletAmount = initialSupply * 200 / 10000;
383 
384 	bool private _swapping;
385 	uint256 public minimumTokensBeforeSwap = 25000000 * (10**18);
386 
387     address public liquidityWallet;
388 	address public operationsWallet;
389 	address public jigsawWallet;
390 
391 	struct CustomTaxPeriod {
392 		bytes23 periodName;
393 		uint8 blocksInPeriod;
394 		uint256 timeInPeriod;
395 		uint8 liquidityFeeOnBuy;
396 		uint8 liquidityFeeOnSell;
397 		uint8 operationsFeeOnBuy;
398 		uint8 operationsFeeOnSell;
399 		uint8 jigsawFeeOnBuy;
400 		uint8 jigsawFeeOnSell;
401 	}
402 
403 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,1,1,2,2,3,3);
404 
405     uint256 private _launchStartTimestamp;
406     uint256 private _launchBlockNumber;
407 	uint256 private constant _blockedTimeLimit = 172800;
408 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
409 	mapping (address => bool) private _feeOnSelectedWalletTransfers;
410 	mapping (address => bool) private _isExcludedFromFee;
411 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
412 	mapping (address => bool) private _isBlocked;
413 	mapping (address => bool) public automatedMarketMakerPairs;
414 
415 	uint8 private _liquidityFee;
416 	uint8 private _operationsFee;
417 	uint8 private _jigsawFee;
418 	uint8 private _totalFee;
419 
420 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
421 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
422 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
423 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 operationsFee, uint8 jigsawFee);
424 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
425 	event BlockedAccountChange(address indexed holder, bool indexed status);
426     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
427 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
428 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
429     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
430 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
431 	event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
432 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
433     event ClaimETHOverflow(uint256 amount);
434 	event FeesApplied(uint8 liquidityFee, uint8 operationsFee, uint8 jigsawFee, uint8 totalFee);
435 
436 	constructor() ERC20(_name, _symbol) {
437         liquidityWallet = owner();
438         operationsWallet = owner();
439 	    jigsawWallet = owner();
440 
441 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
442 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
443 			address(this),
444 			_uniswapV2Router.WETH()
445 		);
446 		uniswapV2Router = _uniswapV2Router;
447 		uniswapV2Pair = _uniswapV2Pair;
448 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
449 
450 		_isExcludedFromFee[owner()] = true;
451 		_isExcludedFromFee[address(this)] = true;
452 
453         _isAllowedToTradeWhenDisabled[owner()] = true;
454         _isAllowedToTradeWhenDisabled[address(this)] = true;
455 
456 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
457 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
458 		_isExcludedFromMaxWalletLimit[address(this)] = true;
459 		_isExcludedFromMaxWalletLimit[owner()] = true;
460 
461 		_mint(owner(), initialSupply);
462 	}
463 
464 	receive() external payable {}
465 
466 	// Setters
467 	function activateTrading() external onlyOwner {
468 		isTradingEnabled = true;
469         if (_launchStartTimestamp == 0) {
470             _launchStartTimestamp = block.timestamp;
471             _launchBlockNumber = block.number;
472         }
473 	}
474 	function deactivateTrading() external onlyOwner {
475 		isTradingEnabled = false;
476 	}
477 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
478         require(automatedMarketMakerPairs[pair] != value, "Jigsaw: Automated market maker pair is already set to that value");
479         automatedMarketMakerPairs[pair] = value;
480         emit AutomatedMarketMakerPairChange(pair, value);
481     }
482     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
483 		_isAllowedToTradeWhenDisabled[account] = allowed;
484 		emit AllowedWhenTradingDisabledChange(account, allowed);
485 	}
486 	function excludeFromFees(address account, bool excluded) external onlyOwner {
487 		require(_isExcludedFromFee[account] != excluded, "Jigsaw: Account is already the value of 'excluded'");
488 		_isExcludedFromFee[account] = excluded;
489 		emit ExcludeFromFeesChange(account, excluded);
490 	}
491 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
492 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "Jigsaw: Account is already the value of 'excluded'");
493 		_isExcludedFromMaxWalletLimit[account] = excluded;
494 		emit ExcludeFromMaxWalletChange(account, excluded);
495 	}
496 	function blockAccount(address account) external onlyOwner {
497 		require(!_isBlocked[account], "Jigsaw: Account is already blocked");
498 		require((block.timestamp - _launchStartTimestamp) < _blockedTimeLimit, "Jigsaw: Time to block accounts has expired");
499 		_isBlocked[account] = true;
500 		emit BlockedAccountChange(account, true);
501 	}
502 	function unblockAccount(address account) external onlyOwner {
503 		require(_isBlocked[account], "Jigsaw: Account is not blcoked");
504 		_isBlocked[account] = false;
505 		emit BlockedAccountChange(account, false);
506 	}
507 	function setWallets(address newLiquidityWallet, address newOperationsWallet, address newJigsawWallet) external onlyOwner {
508 		if(liquidityWallet != newLiquidityWallet) {
509 			require(newLiquidityWallet != address(0), "Jigsaw: The liquidityWallet cannot be 0");
510 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
511 			liquidityWallet = newLiquidityWallet;
512 		}
513 		if(operationsWallet != newOperationsWallet) {
514 			require(newOperationsWallet != address(0), "Jigsaw: The operationsWallet cannot be 0");
515 			emit WalletChange('operationsWallet', newOperationsWallet, operationsWallet);
516 			operationsWallet = newOperationsWallet;
517 		}
518 		if(jigsawWallet != newJigsawWallet) {
519 			require(newJigsawWallet != address(0), "Jigsaw: The jigsawWallet cannot be 0");
520 			emit WalletChange('jigsawWallet', newJigsawWallet, jigsawWallet);
521 			jigsawWallet = newJigsawWallet;
522 		}
523 	}
524 	function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
525 		require(_feeOnSelectedWalletTransfers[account] != value, "Jigsaw: The selected wallet is already set to the value ");
526 		_feeOnSelectedWalletTransfers[account] = value;
527 		emit FeeOnSelectedWalletTransfersChange(account, value);
528 	}
529 	// Base Fees
530 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _operationsFeeOnBuy, uint8 _jigsawFeeOnBuy) external onlyOwner {
531 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _operationsFeeOnBuy, _jigsawFeeOnBuy);
532 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _operationsFeeOnBuy, _jigsawFeeOnBuy);
533 	}
534 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell, uint8 _jigsawFeeOnSell) external onlyOwner {
535 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _operationsFeeOnSell, _jigsawFeeOnSell);
536 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _operationsFeeOnSell, _jigsawFeeOnSell);
537 	}
538 	function setUniswapRouter(address newAddress) external onlyOwner {
539 		require(newAddress != address(uniswapV2Router), "Jigsaw: The router already has that address");
540 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
541 		uniswapV2Router = IRouter(newAddress);
542 	}
543 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
544 		require(newValue != maxWalletAmount, "Jigsaw: Cannot update maxWalletAmount to same value");
545 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
546 		maxWalletAmount = newValue;
547 	}
548 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
549 		require(newValue != minimumTokensBeforeSwap, "Jigsaw: Cannot update minimumTokensBeforeSwap to same value");
550 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
551 		minimumTokensBeforeSwap = newValue;
552 	}
553 	function claimETHOverflow() external onlyOwner {
554 	    uint256 amount = address(this).balance;
555         (bool success,) = address(owner()).call{value : amount}("");
556         if (success){
557             emit ClaimETHOverflow(amount);
558         }
559 	}
560 
561 	// Getters
562 	function getBaseBuyFees() external view returns (uint8, uint8, uint8){
563 		return (_base.liquidityFeeOnBuy, _base.operationsFeeOnBuy, _base.jigsawFeeOnBuy);
564 	}
565 	function getBaseSellFees() external view returns (uint8, uint8, uint8){
566 		return (_base.liquidityFeeOnSell, _base.operationsFeeOnSell, _base.jigsawFeeOnSell);
567 	}
568 	function getNumberOfTokenHolders() external view returns(uint256) {
569         return tokenHoldersMap.keys.length;
570     }
571 	function getTokenHolderAtIndex(uint256 accountIndex) external view returns(address) {
572 		if(accountIndex >= tokenHoldersMap.keys.length) {
573 			accountIndex = 0;
574 		}
575 		address account = tokenHoldersMap.keys[accountIndex];
576         return account;
577     }
578 
579 	// Main
580 	function _transfer(
581 		address from,
582 		address to,
583 		uint256 amount
584 		) internal override {
585         require(from != address(0), "ERC20: transfer from the zero address");
586         require(to != address(0), "ERC20: transfer to the zero address");
587 
588         if(amount == 0) {
589             super._transfer(from, to, 0);
590             return;
591         }
592 
593         bool isBuyFromLp = automatedMarketMakerPairs[from];
594         bool isSelltoLp = automatedMarketMakerPairs[to];
595 
596         if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
597             require(isTradingEnabled, "Jigsaw: Trading is currently disabled.");
598             require(!_isBlocked[to], "Jigsaw: Account is blocked");
599             require(!_isBlocked[from], "Jigsaw: Account is blocked");
600             if (!_isExcludedFromMaxWalletLimit[to]) {
601                 require((balanceOf(to) + amount) <= maxWalletAmount, "Jigsaw: Expected wallet amount exceeds the maxWalletAmount.");
602             }
603         }
604 
605         _adjustTaxes(isBuyFromLp, isSelltoLp, to, from);
606         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
607 
608         if (
609             isTradingEnabled &&
610             canSwap &&
611             !_swapping &&
612             _totalFee > 0 &&
613             automatedMarketMakerPairs[to]
614         ) {
615             _swapping = true;
616             _swapAndLiquify();
617             _swapping = false;
618         }
619 
620         bool takeFee = !_swapping && isTradingEnabled;
621 
622         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
623             takeFee = false;
624         }
625         if (takeFee && _totalFee > 0) {
626             uint256 fee = amount * _totalFee / 100;
627             amount = amount - fee;
628             super._transfer(from, address(this), fee);
629         }
630 
631         super._transfer(from, to, amount);
632 
633 		_setBalance(from, balanceOf(from));
634         _setBalance(to, balanceOf(to));
635 	}
636 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address to, address from) private {
637 		_liquidityFee = 0;
638 		_operationsFee = 0;
639         _jigsawFee = 0;
640 
641 		if (isBuyFromLp) {
642             if (block.number - _launchBlockNumber <= 5) {
643                 _liquidityFee = 100;
644             }
645 		    else {
646                 _liquidityFee = _base.liquidityFeeOnBuy;
647                 _operationsFee = _base.operationsFeeOnBuy;
648                 _jigsawFee = _base.jigsawFeeOnBuy;
649             }
650         }
651 	    if (isSelltoLp) {
652 	    	_liquidityFee = _base.liquidityFeeOnSell;
653 			_operationsFee = _base.operationsFeeOnSell;
654             _jigsawFee = _base.jigsawFeeOnSell;
655 		}
656 		if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
657 			_liquidityFee = _base.liquidityFeeOnSell;
658 			_operationsFee = _base.operationsFeeOnSell;
659             _jigsawFee = _base.jigsawFeeOnSell;
660 		}
661 		_totalFee = _liquidityFee + _operationsFee + _jigsawFee;
662 		emit FeesApplied(_liquidityFee, _operationsFee, _jigsawFee, _totalFee);
663 	}
664 	function _setBalance(address account, uint256 newBalance) private {
665         if(newBalance > 0) {
666             tokenHoldersMap.set(account, newBalance);
667         }
668         else {
669             tokenHoldersMap.remove(account);
670         }
671     }
672 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
673 		uint8 _liquidityFeeOnSell,
674 		uint8 _operationsFeeOnSell,
675         uint8 _jigsawFeeOnSell
676 	) private {
677 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
678 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
679 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
680 		}
681 		if (map.operationsFeeOnSell != _operationsFeeOnSell) {
682 			emit CustomTaxPeriodChange(_operationsFeeOnSell, map.operationsFeeOnSell, 'operationsFeeOnSell', map.periodName);
683 			map.operationsFeeOnSell = _operationsFeeOnSell;
684 		}
685         if (map.jigsawFeeOnSell != _jigsawFeeOnSell) {
686 			emit CustomTaxPeriodChange(_jigsawFeeOnSell, map.jigsawFeeOnSell, 'jigsawFeeOnSell', map.periodName);
687 			map.jigsawFeeOnSell = _jigsawFeeOnSell;
688 		}
689 	}
690 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
691 		uint8 _liquidityFeeOnBuy,
692 		uint8 _operationsFeeOnBuy,
693         uint8 _jigsawFeeOnBuy
694 		) private {
695 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
696 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
697 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
698 		}
699 		if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
700 			emit CustomTaxPeriodChange(_operationsFeeOnBuy, map.operationsFeeOnBuy, 'operationsFeeOnBuy', map.periodName);
701 			map.operationsFeeOnBuy = _operationsFeeOnBuy;
702 		}
703 		if (map.jigsawFeeOnBuy != _jigsawFeeOnBuy) {
704 			emit CustomTaxPeriodChange(_jigsawFeeOnBuy, map.jigsawFeeOnBuy, 'jigsawFeeOnBuy', map.periodName);
705 			map.jigsawFeeOnBuy = _jigsawFeeOnBuy;
706 		}
707 	}
708 	function _swapAndLiquify() private {
709 		uint256 contractBalance = balanceOf(address(this));
710 		uint256 initialETHBalance = address(this).balance;
711 		uint8 totalFeePrior = _totalFee;
712 
713 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
714 		uint256 amountToSwap = contractBalance - (amountToLiquify);
715 
716 		_swapTokensForETH(amountToSwap);
717 
718 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
719 		uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
720 
721 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
722 		uint256 amountETHOperations = ETHBalanceAfterSwap * _operationsFee / totalETHFee;
723 		uint256 amountETHJigsaw = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHOperations);
724 
725         payable(operationsWallet).transfer(amountETHOperations);
726         payable(jigsawWallet).transfer(amountETHJigsaw);
727 
728         if (amountToLiquify > 0) {
729 			_addLiquidity(amountToLiquify, amountETHLiquidity);
730 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
731 		}
732 
733 		_totalFee = totalFeePrior;
734 	}
735 	function _swapTokensForETH(uint256 tokenAmount) private {
736 		address[] memory path = new address[](2);
737 		path[0] = address(this);
738 		path[1] = uniswapV2Router.WETH();
739 		_approve(address(this), address(uniswapV2Router), tokenAmount);
740 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
741 			tokenAmount,
742 			0, // accept any amount of ETH
743 			path,
744 			address(this),
745 			block.timestamp
746 		);
747 	}
748 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
749 		_approve(address(this), address(uniswapV2Router), tokenAmount);
750 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
751 			address(this),
752 			tokenAmount,
753 			0, // slippage is unavoidable
754 			0, // slippage is unavoidable
755 			liquidityWallet,
756 			block.timestamp
757 		);
758 	}
759 }