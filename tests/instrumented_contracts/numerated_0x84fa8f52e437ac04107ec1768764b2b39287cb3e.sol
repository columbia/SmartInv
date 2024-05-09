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
90 interface DividendPayingTokenInterface {
91 	function dividendOf(address _owner) external view returns(uint256);
92 	function withdrawDividend() external;
93 	event DividendsDistributed(
94 		address indexed from,
95 		uint256 weiAmount
96 	);
97 	event DividendWithdrawn(
98 		address indexed to,
99 		uint256 weiAmount
100 	);
101 }
102 
103 interface DividendPayingTokenOptionalInterface {
104 	function withdrawableDividendOf(address _owner) external view returns(uint256);
105 	function withdrawnDividendOf(address _owner) external view returns(uint256);
106 	function accumulativeDividendOf(address _owner) external view returns(uint256);
107 }
108 
109 library SafeMath {
110 
111 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
112 		uint256 c = a + b;
113 		require(c >= a, "SafeMath: addition overflow");
114 
115 		return c;
116 	}
117 
118 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119 		return sub(a, b, "SafeMath: subtraction overflow");
120 	}
121 
122 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123 		require(b <= a, errorMessage);
124 		uint256 c = a - b;
125 
126 		return c;
127 	}
128 
129 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131 		// benefit is lost if 'b' is also tested.
132 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133 		if (a == 0) {
134 			return 0;
135 		}
136 
137 		uint256 c = a * b;
138 		require(c / a == b, "SafeMath: multiplication overflow");
139 
140 		return c;
141 	}
142 
143 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
144 		return div(a, b, "SafeMath: division by zero");
145 	}
146 
147 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148 		require(b > 0, errorMessage);
149 		uint256 c = a / b;
150 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152 		return c;
153 	}
154 
155 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156 		return mod(a, b, "SafeMath: modulo by zero");
157 	}
158 
159 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160 		require(b != 0, errorMessage);
161 		return a % b;
162 	}
163 }
164 
165 library SafeMathInt {
166 	int256 private constant MIN_INT256 = int256(1) << 255;
167 	int256 private constant MAX_INT256 = ~(int256(1) << 255);
168 
169 	function mul(int256 a, int256 b) internal pure returns (int256) {
170 		int256 c = a * b;
171 
172 		// Detect overflow when multiplying MIN_INT256 with -1
173 		require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
174 		require((b == 0) || (c / b == a));
175 		return c;
176 	}
177 	function div(int256 a, int256 b) internal pure returns (int256) {
178 		// Prevent overflow when dividing MIN_INT256 by -1
179 		require(b != -1 || a != MIN_INT256);
180 
181 		// Solidity already throws when dividing by 0.
182 		return a / b;
183 	}
184 	function sub(int256 a, int256 b) internal pure returns (int256) {
185 		int256 c = a - b;
186 		require((b >= 0 && c <= a) || (b < 0 && c > a));
187 		return c;
188 	}
189 	function add(int256 a, int256 b) internal pure returns (int256) {
190 		int256 c = a + b;
191 		require((b >= 0 && c >= a) || (b < 0 && c < a));
192 		return c;
193 	}
194 	function abs(int256 a) internal pure returns (int256) {
195 		require(a != MIN_INT256);
196 		return a < 0 ? -a : a;
197 	}
198 	function toUint256Safe(int256 a) internal pure returns (uint256) {
199 		require(a >= 0);
200 		return uint256(a);
201 	}
202 }
203 
204 library SafeMathUint {
205 	function toInt256Safe(uint256 a) internal pure returns (int256) {
206 		int256 b = int256(a);
207 		require(b >= 0);
208 		return b;
209 	}
210 }
211 
212 library IterableMapping {
213 	struct Map {
214 		address[] keys;
215 		mapping(address => uint) values;
216 		mapping(address => uint) indexOf;
217 		mapping(address => bool) inserted;
218 	}
219 
220 	function get(Map storage map, address key) public view returns (uint) {
221 		return map.values[key];
222 	}
223 
224 	function getIndexOfKey(Map storage map, address key) public view returns (int) {
225 		if(!map.inserted[key]) {
226 			return -1;
227 		}
228 		return int(map.indexOf[key]);
229 	}
230 
231 	function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
232 		return map.keys[index];
233 	}
234 
235 	function size(Map storage map) public view returns (uint) {
236 		return map.keys.length;
237 	}
238 
239 	function set(Map storage map, address key, uint val) public {
240 		if (map.inserted[key]) {
241 			map.values[key] = val;
242 		} else {
243 			map.inserted[key] = true;
244 			map.values[key] = val;
245 			map.indexOf[key] = map.keys.length;
246 			map.keys.push(key);
247 		}
248 	}
249 
250 	function remove(Map storage map, address key) public {
251 		if (!map.inserted[key]) {
252 			return;
253 		}
254 
255 		delete map.inserted[key];
256 		delete map.values[key];
257 
258 		uint index = map.indexOf[key];
259 		uint lastIndex = map.keys.length - 1;
260 		address lastKey = map.keys[lastIndex];
261 
262 		map.indexOf[lastKey] = index;
263 		delete map.indexOf[key];
264 
265 		map.keys[index] = lastKey;
266 		map.keys.pop();
267 	}
268 }
269 
270 abstract contract Context {
271 	function _msgSender() internal view virtual returns (address) {
272 		return msg.sender;
273 	}
274 
275 	function _msgData() internal view virtual returns (bytes calldata) {
276 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277 		return msg.data;
278 	}
279 }
280 
281 contract Ownable is Context {
282 	address private _owner;
283 
284 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286 	constructor () {
287 		address msgSender = _msgSender();
288 		_owner = msgSender;
289 		emit OwnershipTransferred(address(0), msgSender);
290 	}
291 
292 	function owner() public view returns (address) {
293 		return _owner;
294 	}
295 
296 	modifier onlyOwner() {
297 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
298 		_;
299 	}
300 
301 	function renounceOwnership() public virtual onlyOwner {
302 		emit OwnershipTransferred(_owner, address(0));
303 		_owner = address(0);
304 	}
305 
306 	function transferOwnership(address newOwner) public virtual onlyOwner {
307 		require(newOwner != address(0), "Ownable: new owner is the zero address");
308 		emit OwnershipTransferred(_owner, newOwner);
309 		_owner = newOwner;
310 	}
311 }
312 
313 contract ERC20 is Context, IERC20, IERC20Metadata {
314 	using SafeMath for uint256;
315 
316 	mapping(address => uint256) private _balances;
317 	mapping(address => mapping(address => uint256)) private _allowances;
318 
319 	uint256 private _totalSupply;
320 	string private _name;
321 	string private _symbol;
322 
323 	constructor(string memory name_, string memory symbol_) {
324 		_name = name_;
325 		_symbol = symbol_;
326 	}
327 
328 	function name() public view virtual override returns (string memory) {
329 		return _name;
330 	}
331 
332 	function symbol() public view virtual override returns (string memory) {
333 		return _symbol;
334 	}
335 
336 	function decimals() public view virtual override returns (uint8) {
337 		return 18;
338 	}
339 
340 	function totalSupply() public view virtual override returns (uint256) {
341 		return _totalSupply;
342 	}
343 
344 	function balanceOf(address account) public view virtual override returns (uint256) {
345 		return _balances[account];
346 	}
347 
348 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
349 		_transfer(_msgSender(), recipient, amount);
350 		return true;
351 	}
352 
353 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
354 		return _allowances[owner][spender];
355 	}
356 
357 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
358 		_approve(_msgSender(), spender, amount);
359 		return true;
360 	}
361 
362 	function transferFrom(
363 		address sender,
364 		address recipient,
365 		uint256 amount
366 	) public virtual override returns (bool) {
367 		_transfer(sender, recipient, amount);
368 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
369 		return true;
370 	}
371 
372 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
373 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
374 		return true;
375 	}
376 
377 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
379 		return true;
380 	}
381 
382 	function _transfer(
383 		address sender,
384 		address recipient,
385 		uint256 amount
386 	) internal virtual {
387 		require(sender != address(0), "ERC20: transfer from the zero address");
388 		require(recipient != address(0), "ERC20: transfer to the zero address");
389 		_beforeTokenTransfer(sender, recipient, amount);
390 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
391 		_balances[recipient] = _balances[recipient].add(amount);
392 		emit Transfer(sender, recipient, amount);
393 	}
394 
395 	function _mint(address account, uint256 amount) internal virtual {
396 		require(account != address(0), "ERC20: mint to the zero address");
397 		_beforeTokenTransfer(address(0), account, amount);
398 		_totalSupply = _totalSupply.add(amount);
399 		_balances[account] = _balances[account].add(amount);
400 		emit Transfer(address(0), account, amount);
401 	}
402 
403 	function _burn(address account, uint256 amount) internal virtual {
404 		require(account != address(0), "ERC20: burn from the zero address");
405 		_beforeTokenTransfer(account, address(0), amount);
406 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
407 		_totalSupply = _totalSupply.sub(amount);
408 		emit Transfer(account, address(0), amount);
409 	}
410 
411 	function _approve(
412 		address owner,
413 		address spender,
414 		uint256 amount
415 	) internal virtual {
416 		require(owner != address(0), "ERC20: approve from the zero address");
417 		require(spender != address(0), "ERC20: approve to the zero address");
418 		_allowances[owner][spender] = amount;
419 		emit Approval(owner, spender, amount);
420 	}
421 
422 	function _beforeTokenTransfer(
423 		address from,
424 		address to,
425 		uint256 amount
426 	) internal virtual {}
427 }
428 
429 contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
430 	using SafeMath for uint256;
431 	using SafeMathUint for uint256;
432 	using SafeMathInt for int256;
433 
434 	uint256 constant internal magnitude = 2**128;
435 	uint256 internal magnifiedDividendPerShare;
436 	uint256 public totalDividendsDistributed;
437 	address public rewardToken;
438 	IRouter public uniswapV2Router;
439 
440 	mapping(address => int256) internal magnifiedDividendCorrections;
441 	mapping(address => uint256) internal withdrawnDividends;
442 
443 	constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
444 
445 	receive() external payable {}
446 
447 	function distributeDividendsUsingAmount(uint256 amount) public onlyOwner {
448 		require(totalSupply() > 0);
449 		if (amount > 0) {
450 			magnifiedDividendPerShare = magnifiedDividendPerShare.add((amount).mul(magnitude) / totalSupply());
451 			emit DividendsDistributed(msg.sender, amount);
452 			totalDividendsDistributed = totalDividendsDistributed.add(amount);
453 		}
454 	}
455 	function withdrawDividend() public virtual override onlyOwner {
456 		_withdrawDividendOfUser(payable(msg.sender));
457 	}
458 	function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
459 		uint256 _withdrawableDividend = withdrawableDividendOf(user);
460 		if (_withdrawableDividend > 0) {
461 			withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
462 			emit DividendWithdrawn(user, _withdrawableDividend);
463 			(bool success) = IERC20(rewardToken).transfer(user, _withdrawableDividend);
464 			if(!success) {
465 				withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
466 				return 0;
467 			}
468 			return _withdrawableDividend;
469 		}
470 		return 0;
471 	}
472 	function dividendOf(address _owner) public view override returns(uint256) {
473 		return withdrawableDividendOf(_owner);
474 	}
475 	function withdrawableDividendOf(address _owner) public view override returns(uint256) {
476 		return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
477 	}
478 	function withdrawnDividendOf(address _owner) public view override returns(uint256) {
479 		return withdrawnDividends[_owner];
480 	}
481 	function accumulativeDividendOf(address _owner) public view override returns(uint256) {
482 		return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
483 		.add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
484 	}
485 	function _transfer(address from, address to, uint256 value) internal virtual override {
486 		require(false);
487 		int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
488 		magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
489 		magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
490 	}
491 	function _mint(address account, uint256 value) internal override {
492 		super._mint(account, value);
493 		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
494 		.sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
495 	}
496 	function _burn(address account, uint256 value) internal override {
497 		super._burn(account, value);
498 		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
499 		.add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
500 	}
501 	function _setBalance(address account, uint256 newBalance) internal {
502 		uint256 currentBalance = balanceOf(account);
503 		if(newBalance > currentBalance) {
504 			uint256 mintAmount = newBalance.sub(currentBalance);
505 			_mint(account, mintAmount);
506 		} else if(newBalance < currentBalance) {
507 			uint256 burnAmount = currentBalance.sub(newBalance);
508 			_burn(account, burnAmount);
509 		}
510 	}
511 	function _setRewardToken(address token) internal onlyOwner {
512 	    rewardToken = token;
513 	}
514 	function _setUniswapRouter(address router) internal onlyOwner {
515 	    uniswapV2Router = IRouter(router);
516 	}
517 }
518 
519 contract GroveToken is Ownable, ERC20 {
520 
521 	IRouter public uniswapV2Router;
522 	address public immutable uniswapV2Pair;
523 
524 	string private constant _name =  "Grove Token";
525 	string private constant _symbol = "GVR";
526 	uint8 private constant _decimals = 18;
527 
528 	GroveTokenDividendTracker public dividendTracker;
529 
530 	bool public isTradingEnabled;
531 
532 	// initialSupply
533 	uint256 constant initialSupply = 5000000000000000 * (10**18);
534 
535 	uint256 public maxWalletAmount = initialSupply * 3;
536 
537 	uint256 public maxTxAmount = initialSupply * 3;
538 
539 	bool private _swapping;
540 	uint256 public minimumTokensBeforeSwap = 150000000 * (10**18);
541 
542 	address public liquidityWallet;
543 	address public marketingWallet;
544 	address public buyBackWallet;
545 	address private bridge;
546 
547 	struct CustomTaxPeriod {
548 		bytes23 periodName;
549 		uint8 blocksInPeriod;
550 		uint256 timeInPeriod;
551 		uint8 liquidityFeeOnBuy;
552 		uint8 liquidityFeeOnSell;
553 		uint8 marketingFeeOnBuy;
554 		uint8 marketingFeeOnSell;
555 		uint8 buyBackFeeOnBuy;
556 		uint8 buyBackFeeOnSell;
557         uint8 burnFeeOnBuy;
558 		uint8 burnFeeOnSell;
559 		uint8 holdersFeeOnBuy;
560 		uint8 holdersFeeOnSell;
561 	}
562 
563 	// Base taxes
564 	CustomTaxPeriod private _base = CustomTaxPeriod("base",0,0,1,1,3,3,1,1,2,2,3,3);
565 
566 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
567 	mapping (address => bool) private _isExcludedFromFee;
568 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
569 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
570 	mapping (address => bool) public automatedMarketMakerPairs;
571 
572 	uint8 private _liquidityFee;
573 	uint8 private _marketingFee;
574 	uint8 private _buyBackFee;
575     uint8 private _burnFee;
576 	uint8 private _holdersFee;
577 	uint8 private _totalFee;
578 
579 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
580 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
581 	event WalletChange(string indexed indentifier, address indexed newWallet, address indexed oldWallet);
582 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 buyBackFee, uint8 burnFee, uint8 holdersFee);
583 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
584 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
585 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
586 	event ExcludeFromFeesChange(address indexed account, bool isExcluded);
587 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
588 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
589 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
590 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
591 	event MinTokenAmountForDividendsChange(uint256 indexed newValue, uint256 indexed oldValue);
592 	event DividendsSent(uint256 tokensSwapped);
593 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
594     event ClaimETHOverflow(uint256 amount);
595     event TokenBurn(uint8 _burnFee, uint256 burnAmount);
596 	event FeesApplied(uint8 liquidityFee, uint8 marketingFee, uint8 buyBackFee, uint8 burnFee, uint8 holdersFee, uint8 totalFee);
597 	event BridgeContractChange(address bridgeContract);
598 
599 	modifier hasMintPermission {
600 		require(msg.sender == bridge, "only bridge contract can mint");
601 		_;
602 	}
603 
604 	constructor() ERC20(_name, _symbol) {
605 		dividendTracker = new GroveTokenDividendTracker();
606 		dividendTracker.setUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
607         dividendTracker.setRewardToken(address(this));
608 
609 		liquidityWallet = owner();
610 		marketingWallet = owner();
611 		buyBackWallet = owner();
612 
613 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
614 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
615 		uniswapV2Router = _uniswapV2Router;
616 		uniswapV2Pair = _uniswapV2Pair;
617 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
618 
619 		_isExcludedFromFee[owner()] = true;
620 		_isExcludedFromFee[address(this)] = true;
621 		_isExcludedFromFee[address(dividendTracker)] = true;
622 
623 		dividendTracker.excludeFromDividends(address(dividendTracker));
624 		dividendTracker.excludeFromDividends(address(this));
625 		dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
626 		dividendTracker.excludeFromDividends(owner());
627 		dividendTracker.excludeFromDividends(address(_uniswapV2Router));
628 
629 		_isAllowedToTradeWhenDisabled[owner()] = true;
630 
631 		_isExcludedFromMaxTransactionLimit[address(dividendTracker)] = true;
632 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
633 
634 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
635 		_isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
636 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
637 		_isExcludedFromMaxWalletLimit[address(this)] = true;
638 		_isExcludedFromMaxWalletLimit[owner()] = true;
639 
640 		_mint(owner(), initialSupply);
641 	}
642 
643 	receive() external payable {}
644 
645 	// Setters
646 	function activateTrading() external onlyOwner {
647 		isTradingEnabled = true;
648 	}
649 	function deactivateTrading() external onlyOwner {
650 		isTradingEnabled = false;
651 	}
652 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
653 		require(automatedMarketMakerPairs[pair] != value, "GroveToken: Automated market maker pair is already set to that value");
654 		automatedMarketMakerPairs[pair] = value;
655 		if(value) {
656 			dividendTracker.excludeFromDividends(pair);
657 		}
658 		emit AutomatedMarketMakerPairChange(pair, value);
659 	}
660 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
661 		_isAllowedToTradeWhenDisabled[account] = allowed;
662 		emit AllowedWhenTradingDisabledChange(account, allowed);
663 	}
664 	function excludeFromFees(address account, bool excluded) external onlyOwner {
665 		require(_isExcludedFromFee[account] != excluded, "GroveToken: Account is already the value of 'excluded'");
666 		_isExcludedFromFee[account] = excluded;
667 		emit ExcludeFromFeesChange(account, excluded);
668 	}
669 	function excludeFromDividends(address account) external onlyOwner {
670 		dividendTracker.excludeFromDividends(account);
671 	}
672 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
673 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "GroveToken: Account is already the value of 'excluded'");
674 		_isExcludedFromMaxTransactionLimit[account] = excluded;
675 		emit ExcludeFromMaxTransferChange(account, excluded);
676 	}
677 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
678 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "GroveToken: Account is already the value of 'excluded'");
679 		_isExcludedFromMaxWalletLimit[account] = excluded;
680 		emit ExcludeFromMaxWalletChange(account, excluded);
681 	}
682 	function setWallets(address newLiquidityWallet, address newMarketingWallet, address newBuyBackWallet) external onlyOwner {
683 		if(liquidityWallet != newLiquidityWallet) {
684 			require(newLiquidityWallet != address(0), "GroveToken: The liquidityWallet cannot be 0");
685 			emit WalletChange("liquidityWallet", newLiquidityWallet, liquidityWallet);
686 			liquidityWallet = newLiquidityWallet;
687 		}
688 		if(marketingWallet != newMarketingWallet) {
689 			require(newMarketingWallet != address(0), "GroveToken: The marketingWallet cannot be 0");
690 			emit WalletChange("marketingWallet", newMarketingWallet, marketingWallet);
691 			marketingWallet = newMarketingWallet;
692 		}
693 		if(buyBackWallet != newBuyBackWallet) {
694 			require(newBuyBackWallet != address(0), "GroveToken: The buyBackWallet cannot be 0");
695 			emit WalletChange("buyBackWallet", newBuyBackWallet, buyBackWallet);
696 			buyBackWallet = newBuyBackWallet;
697 		}
698 	}
699 	// Base fees
700 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _burnFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
701 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _burnFeeOnBuy, _holdersFeeOnBuy);
702 		emit FeeChange("baseFees-Buy", _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _burnFeeOnBuy, _holdersFeeOnBuy);
703 	}
704 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _marketingFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _burnFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
705 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _burnFeeOnSell, _holdersFeeOnSell);
706 		emit FeeChange("baseFees-Sell", _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _burnFeeOnSell, _holdersFeeOnSell);
707 	}
708 	function setUniswapRouter(address newAddress) external onlyOwner {
709 		require(newAddress != address(uniswapV2Router), "GroveToken: The router already has that address");
710 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
711 		uniswapV2Router = IRouter(newAddress);
712 		dividendTracker.setUniswapRouter(newAddress);
713 	}
714 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
715 		require(newValue != maxTxAmount, "GroveToken: Cannot update maxTxAmount to same value");
716 		emit MaxTransactionAmountChange(newValue, maxTxAmount);
717 		maxTxAmount = newValue;
718 	}
719 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
720 		require(newValue != maxWalletAmount, "GroveToken: Cannot update maxWalletAmount to same value");
721 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
722 		maxWalletAmount = newValue;
723 	}
724 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
725 		require(newValue != minimumTokensBeforeSwap, "GroveToken: Cannot update minimumTokensBeforeSwap to same value");
726 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
727 		minimumTokensBeforeSwap = newValue;
728 	}
729 	function setMinimumTokenBalanceForDividends(uint256 newValue) external onlyOwner {
730 		dividendTracker.setTokenBalanceForDividends(newValue);
731 	}
732 	function claim() external {
733 		dividendTracker.processAccount(payable(msg.sender), false);
734     }
735 	function claimETHOverflow(uint256 amount) external onlyOwner {
736 	    require(amount < address(this).balance, "GroveToken: Cannot send more than contract balance");
737         (bool success,) = address(owner()).call{value : amount}("");
738         if (success){
739             emit ClaimETHOverflow(amount);
740         }
741 	}
742 	function mint(address account, uint256 value) external hasMintPermission returns(bool) {
743 		_mint(account, value);
744 		return true;
745 	}
746 	function burn(uint256 value) external {
747 		_burn(msg.sender, value);
748 	}
749 
750     function bridgeContract() external view returns (address) {
751         return bridge;
752     }
753 
754     function setBridgeContract(address _bridgeContract) external onlyOwner {
755         require(_bridgeContract != address(0x0) && _bridgeContract != bridge, "invalid address");
756         bridge = _bridgeContract;
757 		emit BridgeContractChange(_bridgeContract);
758     }
759 
760 	// Getters
761 	function getTotalDividendsDistributed() external view returns (uint256) {
762 		return dividendTracker.totalDividendsDistributed();
763 	}
764 	function withdrawableDividendOf(address account) external view returns(uint256) {
765 		return dividendTracker.withdrawableDividendOf(account);
766 	}
767 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
768 		return dividendTracker.balanceOf(account);
769 	}
770 	function getNumberOfDividendTokenHolders() external view returns(uint256) {
771 		return dividendTracker.getNumberOfTokenHolders();
772 	}
773 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8, uint8){
774 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.buyBackFeeOnBuy, _base.burnFeeOnBuy, _base.holdersFeeOnBuy);
775 	}
776 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8, uint8){
777 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.buyBackFeeOnSell, _base.burnFeeOnSell, _base.holdersFeeOnSell);
778 	}
779 
780 	// Main
781 	function _transfer(
782 		address from,
783 		address to,
784 		uint256 amount
785 		) internal override {
786 			require(from != address(0), "ERC20: transfer from the zero address");
787 			require(to != address(0), "ERC20: transfer to the zero address");
788 
789 			if(amount == 0) {
790 				super._transfer(from, to, 0);
791 				return;
792 			}
793 
794 			bool isBuyFromLp = automatedMarketMakerPairs[from];
795 			bool isSelltoLp = automatedMarketMakerPairs[to];
796 
797 			if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
798 				require(isTradingEnabled, "GroveToken: Trading is currently disabled.");
799 				if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
800 					require(amount <= maxTxAmount, "GroveToken: Buy amount exceeds the maxTxBuyAmount.");
801 				}
802 				if (!_isExcludedFromMaxWalletLimit[to]) {
803 					require((balanceOf(to) + amount) <= maxWalletAmount, "GroveToken: Expected wallet amount exceeds the maxWalletAmount.");
804 				}
805 			}
806 
807 			_adjustTaxes(isBuyFromLp, isSelltoLp);
808 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
809 
810 			if (
811 				isTradingEnabled &&
812 				canSwap &&
813 				!_swapping &&
814 				_totalFee > 0 &&
815 				automatedMarketMakerPairs[to]
816 			) {
817 				_swapping = true;
818 				_swapAndLiquify();
819 				_swapping = false;
820 			}
821 
822 			bool takeFee = !_swapping && isTradingEnabled;
823 
824 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
825 				takeFee = false;
826 			}
827 			if (takeFee && _totalFee > 0) {
828 				uint256 fee = amount * _totalFee / 100;
829                 uint256 burnAmount = amount * _burnFee / 100;
830 				amount = amount - fee;
831 				super._transfer(from, address(this), fee);
832 
833                 if (burnAmount > 0) {
834                     super._burn(address(this), burnAmount);
835                     emit TokenBurn(_burnFee, burnAmount);
836 			    }
837 			}
838 			super._transfer(from, to, amount);
839 
840             try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
841 		    try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
842 	}
843 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp) private {
844 		_liquidityFee = 0;
845 		_marketingFee = 0;
846 		_buyBackFee = 0;
847         _burnFee = 0;
848 		_holdersFee = 0;
849 
850 		if (isBuyFromLp) {
851 			_liquidityFee = _base.liquidityFeeOnBuy;
852 			_marketingFee = _base.marketingFeeOnBuy;
853 			_buyBackFee = _base.buyBackFeeOnBuy;
854             _burnFee = _base.burnFeeOnBuy;
855 			_holdersFee = _base.holdersFeeOnBuy;
856 		}
857 	    if (isSelltoLp) {
858 	    	_liquidityFee = _base.liquidityFeeOnSell;
859 			_marketingFee = _base.marketingFeeOnSell;
860 			_buyBackFee = _base.buyBackFeeOnSell;
861             _burnFee = _base.burnFeeOnSell;
862 			_holdersFee = _base.holdersFeeOnSell;
863 		}
864         if (!isSelltoLp && !isBuyFromLp) {
865 			_liquidityFee = _base.liquidityFeeOnSell;
866 			_marketingFee = _base.marketingFeeOnSell;
867 			_buyBackFee = _base.buyBackFeeOnSell;
868             _burnFee = _base.burnFeeOnSell;
869 			_holdersFee = _base.holdersFeeOnSell;
870 		}
871 		_totalFee = _liquidityFee + _marketingFee + _buyBackFee + _burnFee + _holdersFee;
872 		emit FeesApplied(_liquidityFee, _marketingFee, _buyBackFee, _burnFee, _holdersFee, _totalFee);
873 	}
874 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
875 		uint8 _liquidityFeeOnSell,
876 		uint8 _marketingFeeOnSell,
877 		uint8 _buyBackFeeOnSell,
878         uint8 _burnFeeOnSell,
879 		uint8 _holdersFeeOnSell
880 	) private {
881 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
882 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, "liquidityFeeOnSell", map.periodName);
883 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
884 		}
885 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
886 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, "marketingFeeOnSell", map.periodName);
887 			map.marketingFeeOnSell = _marketingFeeOnSell;
888 		}
889 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
890 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, "buyBackFeeOnSell", map.periodName);
891 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
892 		}
893         if (map.burnFeeOnSell != _burnFeeOnSell) {
894 			emit CustomTaxPeriodChange(_burnFeeOnSell, map.burnFeeOnSell, "burnFeeOnSell", map.periodName);
895 			map.burnFeeOnSell = _burnFeeOnSell;
896 		}
897 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
898 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, "holdersFeeOnSell", map.periodName);
899 			map.holdersFeeOnSell = _holdersFeeOnSell;
900 		}
901 	}
902 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
903 		uint8 _liquidityFeeOnBuy,
904 		uint8 _marketingFeeOnBuy,
905 		uint8 _buyBackFeeOnBuy,
906         uint8 _burnFeeOnBuy,
907 		uint8 _holdersFeeOnBuy
908 		) private {
909 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
910 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, "liquidityFeeOnBuy", map.periodName);
911 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
912 		}
913 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
914 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, "marketingFeeOnBuy", map.periodName);
915 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
916 		}
917 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
918 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, "buyBackFeeOnBuy", map.periodName);
919 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
920 		}
921         if (map.burnFeeOnBuy != _burnFeeOnBuy) {
922 			emit CustomTaxPeriodChange(_burnFeeOnBuy, map.burnFeeOnBuy, "burnFeeOnBuy", map.periodName);
923 			map.burnFeeOnBuy = _burnFeeOnBuy;
924 		}
925 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
926 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, "holdersFeeOnBuy", map.periodName);
927 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
928 		}
929 	}
930 	function _swapAndLiquify() private {
931 		uint256 contractBalance = balanceOf(address(this));
932 		uint256 initialETHBalance = address(this).balance;
933 
934 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
935         uint256 amountForHolders = contractBalance * _holdersFee / _totalFee;
936 		uint256 amountToSwap = contractBalance - (amountToLiquify + amountForHolders);
937 
938 		_swapTokensForETH(amountToSwap);
939 
940 		uint256 ETHBalanceAfterSwap = address(this).balance  - initialETHBalance;
941 		uint256 totalETHFee = _totalFee - ((_liquidityFee / 2) + _burnFee + _holdersFee);
942 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
943         uint256 amountETHMarketing = ETHBalanceAfterSwap * _marketingFee / totalETHFee;
944 		uint256 amountETHBuyBack = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHMarketing);
945 
946 		payable(buyBackWallet).transfer(amountETHBuyBack);
947         payable(marketingWallet).transfer(amountETHMarketing);
948 
949 		if (amountToLiquify > 0) {
950 			_addLiquidity(amountToLiquify, amountETHLiquidity);
951 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
952         }
953 
954 		(bool success) = IERC20(address(this)).transfer(address(dividendTracker), amountForHolders);
955 		if(success) {
956 			dividendTracker.distributeDividendsUsingAmount(amountForHolders);
957 			emit DividendsSent(amountForHolders);
958 		}
959 	}
960 	function _swapTokensForETH(uint256 tokenAmount) private {
961 		address[] memory path = new address[](2);
962 		path[0] = address(this);
963 		path[1] = uniswapV2Router.WETH();
964 		_approve(address(this), address(uniswapV2Router), tokenAmount);
965 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
966 			tokenAmount,
967 			0, // accept any amount of ETH
968 			path,
969 			address(this),
970 			block.timestamp
971 		);
972 	}
973 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
974 		_approve(address(this), address(uniswapV2Router), tokenAmount);
975 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
976 			address(this),
977 			tokenAmount,
978 			0, // slippage is unavoidable
979 			0, // slippage is unavoidable
980 			liquidityWallet,
981 			block.timestamp
982 		);
983 	}
984 }
985 
986 contract GroveTokenDividendTracker is DividendPayingToken {
987 	using SafeMath for uint256;
988 	using SafeMathInt for int256;
989 	using IterableMapping for IterableMapping.Map;
990 
991 	IterableMapping.Map private tokenHoldersMap;
992 
993 	mapping (address => bool) public excludedFromDividends;
994 	mapping (address => uint256) public lastClaimTimes;
995 	uint256 public claimWait;
996 	uint256 public minimumTokenBalanceForDividends;
997 
998 	event ExcludeFromDividends(address indexed account);
999 	event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1000 	event Claim(address indexed account, uint256 amount, bool indexed automatic);
1001 
1002 	constructor() DividendPayingToken("GroveToken_Dividend_Tracker", "GroveToken_Dividend_Tracker") {
1003 		claimWait = 3600;
1004 		minimumTokenBalanceForDividends = 0 * (10**18);
1005 	}
1006 	function setRewardToken(address token) external onlyOwner {
1007 	    _setRewardToken(token);
1008 	}
1009 	function setUniswapRouter(address router) external onlyOwner {
1010 	    _setUniswapRouter(router);
1011 	}
1012 	function _transfer(address, address, uint256) internal override pure {
1013 		require(false, "GroveToken_Dividend_Tracker: No transfers allowed");
1014 	}
1015 	function excludeFromDividends(address account) external onlyOwner {
1016 		require(!excludedFromDividends[account]);
1017 		excludedFromDividends[account] = true;
1018 		_setBalance(account, 0);
1019 		tokenHoldersMap.remove(account);
1020 		emit ExcludeFromDividends(account);
1021 	}
1022 	function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1023 		require(minimumTokenBalanceForDividends != newValue, "GroveToken_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'.");
1024 		minimumTokenBalanceForDividends = newValue;
1025 	}
1026 	function getNumberOfTokenHolders() external view returns(uint256) {
1027 		return tokenHoldersMap.keys.length;
1028 	}
1029     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1030 		if(excludedFromDividends[account]) {
1031 			return;
1032 		}
1033 		if(newBalance >= minimumTokenBalanceForDividends) {
1034 			_setBalance(account, newBalance);
1035 			tokenHoldersMap.set(account, newBalance);
1036 		}
1037 		else {
1038 			_setBalance(account, 0);
1039 			tokenHoldersMap.remove(account);
1040 		}
1041 		processAccount(account, true);
1042 	}
1043 	function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1044 		uint256 amount = _withdrawDividendOfUser(account);
1045 		if(amount > 0) {
1046 			lastClaimTimes[account] = block.timestamp;
1047 			emit Claim(account, amount, automatic);
1048 			return true;
1049 		}
1050 		return false;
1051 	}
1052 }