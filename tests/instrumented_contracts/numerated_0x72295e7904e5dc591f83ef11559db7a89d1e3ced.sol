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
145 library Address {
146 	function isContract(address account) internal view returns (bool) {
147 		uint256 size;
148 		assembly {
149 			size := extcodesize(account)
150 		}
151 		return size > 0;
152 	}
153 
154 	function sendValue(address payable recipient, uint256 amount) internal {
155 		require(
156 			address(this).balance >= amount,
157 			"Address: insufficient balance"
158 		);
159 
160 		(bool success, ) = recipient.call{value: amount}("");
161 		require(
162 			success,
163 			"Address: unable to send value, recipient may have reverted"
164 		);
165 	}
166 
167 	function functionCall(address target, bytes memory data)
168 	internal
169 	returns (bytes memory)
170 	{
171 		return functionCall(target, data, "Address: low-level call failed");
172 	}
173 
174 	function functionCall(
175 		address target,
176 		bytes memory data,
177 		string memory errorMessage
178 	) internal returns (bytes memory) {
179 		return functionCallWithValue(target, data, 0, errorMessage);
180 	}
181 
182 	function functionCallWithValue(
183 		address target,
184 		bytes memory data,
185 		uint256 value
186 	) internal returns (bytes memory) {
187 		return
188 		functionCallWithValue(
189 			target,
190 			data,
191 			value,
192 			"Address: low-level call with value failed"
193 		);
194 	}
195 
196 	function functionCallWithValue(
197 		address target,
198 		bytes memory data,
199 		uint256 value,
200 		string memory errorMessage
201 	) internal returns (bytes memory) {
202 		require(
203 			address(this).balance >= value,
204 			"Address: insufficient balance for call"
205 		);
206 		require(isContract(target), "Address: call to non-contract");
207 
208 		(bool success, bytes memory returndata) = target.call{value: value}(
209 		data
210 		);
211 		return _verifyCallResult(success, returndata, errorMessage);
212 	}
213 
214 	function functionStaticCall(address target, bytes memory data)
215 	internal
216 	view
217 	returns (bytes memory)
218 	{
219 		return
220 		functionStaticCall(
221 			target,
222 			data,
223 			"Address: low-level static call failed"
224 		);
225 	}
226 
227 	function functionStaticCall(
228 		address target,
229 		bytes memory data,
230 		string memory errorMessage
231 	) internal view returns (bytes memory) {
232 		require(isContract(target), "Address: static call to non-contract");
233 
234 		(bool success, bytes memory returndata) = target.staticcall(data);
235 		return _verifyCallResult(success, returndata, errorMessage);
236 	}
237 
238 	function functionDelegateCall(address target, bytes memory data)
239 	internal
240 	returns (bytes memory)
241 	{
242 		return
243 		functionDelegateCall(
244 			target,
245 			data,
246 			"Address: low-level delegate call failed"
247 		);
248 	}
249 
250 	function functionDelegateCall(
251 		address target,
252 		bytes memory data,
253 		string memory errorMessage
254 	) internal returns (bytes memory) {
255 		require(isContract(target), "Address: delegate call to non-contract");
256 
257 		(bool success, bytes memory returndata) = target.delegatecall(data);
258 		return _verifyCallResult(success, returndata, errorMessage);
259 	}
260 
261 	function _verifyCallResult(
262 		bool success,
263 		bytes memory returndata,
264 		string memory errorMessage
265 	) private pure returns (bytes memory) {
266 		if (success) {
267 			return returndata;
268 		} else {
269 			if (returndata.length > 0) {
270 				assembly {
271 					let returndata_size := mload(returndata)
272 					revert(add(32, returndata), returndata_size)
273 				}
274 			} else {
275 				revert(errorMessage);
276 			}
277 		}
278 	}
279 }
280 
281 
282 abstract contract Context {
283 	function _msgSender() internal view virtual returns (address) {
284 		return msg.sender;
285 	}
286 
287 	function _msgData() internal view virtual returns (bytes calldata) {
288 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
289 		return msg.data;
290 	}
291 }
292 
293 contract Ownable is Context {
294 	address private _owner;
295 
296 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298 	constructor () {
299 		address msgSender = _msgSender();
300 		_owner = msgSender;
301 		emit OwnershipTransferred(address(0), msgSender);
302 	}
303 
304 	function owner() public view returns (address) {
305 		return _owner;
306 	}
307 
308 	modifier onlyOwner() {
309 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
310 		_;
311 	}
312 
313 	function renounceOwnership() public virtual onlyOwner {
314 		emit OwnershipTransferred(_owner, address(0));
315 		_owner = address(0);
316 	}
317 
318 	function transferOwnership(address newOwner) public virtual onlyOwner {
319 		require(newOwner != address(0), "Ownable: new owner is the zero address");
320 		emit OwnershipTransferred(_owner, newOwner);
321 		_owner = newOwner;
322 	}
323 }
324 
325 contract KryptoPets is IERC20, Ownable {
326 	using Address for address;
327 	using SafeMath for uint256;
328 
329 	IRouter public uniswapV2Router;
330 	address public immutable uniswapV2Pair;
331 
332 	string private constant _name = "Krypto Pets";
333 	string private constant _symbol = "KPETS";
334 	uint8 private constant _decimals = 18;
335 
336 	mapping (address => uint256) private _rOwned;
337 	mapping (address => uint256) private _tOwned;
338 	mapping (address => mapping (address => uint256)) private _allowances;
339 
340 	uint256 private constant MAX = ~uint256(0);
341 	uint256 private constant _tTotal = 1000000000000000 * 10**18;
342 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
343 	uint256 private _tFeeTotal;
344 
345 	bool public isTradingEnabled;
346 	uint256 private _tradingPausedTimestamp;
347 
348 	// max wallet is 2% of initialSupply
349 	uint256 public maxWalletAmount = _tTotal * 200 / 10000;
350 
351     // max tx is 1% of initialSupply
352 	uint256 public maxTxAmount = _tTotal * 100 / 10000;
353 
354 	bool private _swapping;
355 	uint256 public minimumTokensBeforeSwap = 25000000 * (10**18);
356 	address private dead = 0x000000000000000000000000000000000000dEaD;
357 
358 	address public liquidityWallet;
359 	address public devWallet;
360 	address public buyBackWallet;
361     address public gamingWallet;
362 
363 	struct CustomTaxPeriod {
364 		bytes23 periodName;
365 		uint8 blocksInPeriod;
366 		uint256 timeInPeriod;
367 		uint256 liquidityFeeOnBuy;
368 		uint256 liquidityFeeOnSell;
369 		uint256 devFeeOnBuy;
370 		uint256 devFeeOnSell;
371 		uint256 buyBackFeeOnBuy;
372 		uint256 buyBackFeeOnSell;
373         uint256 gamingFeeOnBuy;
374 		uint256 gamingFeeOnSell;
375 		uint256 holdersFeeOnBuy;
376 		uint256 holdersFeeOnSell;
377 	}
378 
379 	// Launch taxes
380 	uint256 private _launchTimestamp;
381 	uint256 private _launchBlockNumber;
382 
383     // Base taxes
384 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,100,100,550,550,200,200,150,150,200,200);
385 
386     mapping (address => bool) private _isAllowedToTradeWhenDisabled;
387 	mapping (address => bool) private _feeOnSelectedWalletTransfers;
388 	mapping (address => bool) private _isExcludedFromFee;
389 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
390     mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
391 	mapping (address => bool) public automatedMarketMakerPairs;
392 	address[] private _excludedFromDividends;
393 	mapping (address => bool) private _isExcludedFromDividends;
394 
395 	uint256 private _liquidityFee;
396 	uint256 private _devFee;
397 	uint256 private _buyBackFee;
398     uint256 private _gamingFee;
399 	uint256 private _holdersFee;
400 	uint256 private _totalFee;
401 
402 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
403 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
404 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
405 	event FeeChange(string indexed identifier, uint256 liquidityFee, uint256 devFee, uint256 buyBackFee, uint256 gamingFee, uint256 holdersFee);
406 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
407 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
408     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
409     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
410 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
411     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
412 	event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
413     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
414 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
415     event ClaimETHOverflow(uint256 amount);
416 	event FeesApplied(uint256 liquidityFee, uint256 devFee, uint256 buyBackFee, uint256 gamingFee, uint256 holdersFee, uint256 totalFee);
417 
418 	constructor() {
419         liquidityWallet = owner();
420         devWallet = owner();
421 	    buyBackWallet = owner();
422         gamingWallet = owner();
423 
424 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Mainnet
425 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
426 			address(this),
427 			_uniswapV2Router.WETH()
428 		);
429 		uniswapV2Router = _uniswapV2Router;
430 		uniswapV2Pair = _uniswapV2Pair;
431 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
432 
433 		_isExcludedFromFee[owner()] = true;
434 		_isExcludedFromFee[address(this)] = true;
435 
436         _isAllowedToTradeWhenDisabled[owner()] = true;
437 		_isAllowedToTradeWhenDisabled[address(this)] = true;
438 
439 		excludeFromDividends(address(this), true);
440 		excludeFromDividends(address(dead), true);
441 		excludeFromDividends(address(_uniswapV2Router), true);
442 		excludeFromDividends(address(_uniswapV2Pair), true);
443 
444 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
445 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
446 		_isExcludedFromMaxWalletLimit[address(this)] = true;
447 		_isExcludedFromMaxWalletLimit[owner()] = true;
448 
449 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
450 		_isExcludedFromMaxTransactionLimit[owner()] = true;
451 
452 		_rOwned[owner()] = _rTotal;
453 		emit Transfer(address(0), owner(), _tTotal);
454 	}
455 
456 	receive() external payable {}
457 
458 	// Setters
459 	function transfer(address recipient, uint256 amount) external override returns (bool) {
460 		_transfer(_msgSender(), recipient, amount);
461 		return true;
462 	}
463 	function approve(address spender, uint256 amount) public override returns (bool) {
464 		_approve(_msgSender(), spender, amount);
465 		return true;
466 	}
467 	function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
468 		_transfer(sender, recipient, amount);
469 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
470 		return true;
471 	}
472 	function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
473 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].add(addedValue));
474 		return true;
475 	}
476 	function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
477 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].sub(subtractedValue,"ERC20: decreased allowance below zero"));
478 		return true;
479 	}
480 	function _approve(address owner,address spender,uint256 amount) private {
481 		require(owner != address(0), "ERC20: approve from the zero address");
482 		require(spender != address(0), "ERC20: approve to the zero address");
483 		_allowances[owner][spender] = amount;
484 		emit Approval(owner, spender, amount);
485 	}
486 	function activateTrading() external onlyOwner {
487 		isTradingEnabled = true;
488 		if (_launchTimestamp == 0) {
489 			_launchTimestamp = block.timestamp;
490 			_launchBlockNumber = block.number;
491 		}
492 	}
493 	function deactivateTrading() external onlyOwner {
494 		isTradingEnabled = false;
495 	}
496 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
497 		require(automatedMarketMakerPairs[pair] != value, "KryptoPets: Automated market maker pair is already set to that value");
498 		automatedMarketMakerPairs[pair] = value;
499 		emit AutomatedMarketMakerPairChange(pair, value);
500 	}
501     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
502 		_isAllowedToTradeWhenDisabled[account] = allowed;
503 		emit AllowedWhenTradingDisabledChange(account, allowed);
504 	}
505 	function excludeFromFees(address account, bool excluded) external onlyOwner {
506 		require(_isExcludedFromFee[account] != excluded, "KryptoPets: Account is already the value of 'excluded'");
507 		_isExcludedFromFee[account] = excluded;
508 		emit ExcludeFromFeesChange(account, excluded);
509 	}
510 	function excludeFromDividends(address account, bool excluded) public onlyOwner {
511 		require(_isExcludedFromDividends[account] != excluded, "KryptoPets: Account is already the value of 'excluded'");
512 		if(excluded) {
513 			if(_rOwned[account] > 0) {
514 				_tOwned[account] = tokenFromReflection(_rOwned[account]);
515 			}
516 			_isExcludedFromDividends[account] = excluded;
517 			_excludedFromDividends.push(account);
518 		} else {
519 			for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
520 				if (_excludedFromDividends[i] == account) {
521 					_excludedFromDividends[i] = _excludedFromDividends[_excludedFromDividends.length - 1];
522 					_tOwned[account] = 0;
523 					_isExcludedFromDividends[account] = false;
524 					_excludedFromDividends.pop();
525 					break;
526 				}
527 			}
528 		}
529 		emit ExcludeFromDividendsChange(account, excluded);
530 	}
531 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
532 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "KryptoPets: Account is already the value of 'excluded'");
533 		_isExcludedFromMaxWalletLimit[account] = excluded;
534 		emit ExcludeFromMaxWalletChange(account, excluded);
535 	}
536 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
537 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "KryptoPets: Account is already the value of 'excluded'");
538 		_isExcludedFromMaxTransactionLimit[account] = excluded;
539 		emit ExcludeFromMaxTransferChange(account, excluded);
540 	}
541 	function setWallets(address newLiquidityWallet, address newDevWallet, address newBuyBackWallet, address newGamingWallet) external onlyOwner {
542 		if(liquidityWallet != newLiquidityWallet) {
543 			require(newLiquidityWallet != address(0), "KryptoPets: The liquidityWallet cannot be 0");
544 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
545 			liquidityWallet = newLiquidityWallet;
546 		}
547 		if(devWallet != newDevWallet) {
548 			require(newDevWallet != address(0), "KryptoPets: The devWallet cannot be 0");
549 			emit WalletChange('devWallet', newDevWallet, devWallet);
550 			devWallet = newDevWallet;
551 		}
552 		if(buyBackWallet != newBuyBackWallet) {
553 			require(newBuyBackWallet != address(0), "KryptoPets: The buyBackWallet cannot be 0");
554 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
555 			buyBackWallet = newBuyBackWallet;
556 		}
557         if(gamingWallet != newGamingWallet) {
558 			require(newGamingWallet != address(0), "KryptoPets: The gamingWallet cannot be 0");
559 			emit WalletChange('gamingWallet', newGamingWallet, gamingWallet);
560 			gamingWallet = newGamingWallet;
561 		}
562 	}
563 	// Base Fees
564 	function setBaseFeesOnBuy(uint256 _liquidityFeeOnBuy, uint256 _devFeeOnBuy, uint256 _buyBackFeeOnBuy, uint256 _gamingFeeOnBuy, uint256 _holdersFeeOnBuy) external onlyOwner {
565 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _gamingFeeOnBuy, _holdersFeeOnBuy);
566 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _gamingFeeOnBuy, _holdersFeeOnBuy);
567 	}
568 	function setBaseFeesOnSell(uint256 _liquidityFeeOnSell, uint256 _devFeeOnSell, uint256 _buyBackFeeOnSell, uint256 _gamingFeeOnSell, uint256 _holdersFeeOnSell) external onlyOwner {
569 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _gamingFeeOnSell, _holdersFeeOnSell);
570 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _gamingFeeOnSell, _holdersFeeOnSell);
571 	}
572 	function setUniswapRouter(address newAddress) external onlyOwner {
573 		require(newAddress != address(uniswapV2Router), "KryptoPets: The router already has that address");
574 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
575 		uniswapV2Router = IRouter(newAddress);
576 	}
577 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
578 		require(newValue != minimumTokensBeforeSwap, "KryptoPets: Cannot update minimumTokensBeforeSwap to same value");
579 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
580 		minimumTokensBeforeSwap = newValue;
581 	}
582     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
583 		require(_feeOnSelectedWalletTransfers[account] != value, "KryptoPets: The selected wallet is already set to the value ");
584 		_feeOnSelectedWalletTransfers[account] = value;
585 		emit FeeOnSelectedWalletTransfersChange(account, value);
586 	}
587 	function claimETHOverflow() external onlyOwner {
588 	    uint256 amount = address(this).balance;
589         (bool success,) = address(owner()).call{value : amount}("");
590         if (success){
591             emit ClaimETHOverflow(amount);
592         }
593 	}
594 
595 	// Getters
596 	function name() external view returns (string memory) {
597 		return _name;
598 	}
599 	function symbol() external view returns (string memory) {
600 		return _symbol;
601 	}
602 	function decimals() external view virtual returns (uint8) {
603 		return _decimals;
604 	}
605 	function totalSupply() external view override returns (uint256) {
606 		return _tTotal;
607 	}
608 	function balanceOf(address account) public view override returns (uint256) {
609 		if (_isExcludedFromDividends[account]) return _tOwned[account];
610 		return tokenFromReflection(_rOwned[account]);
611 	}
612 	function totalFees() external view returns (uint256) {
613 		return _tFeeTotal;
614 	}
615 	function allowance(address owner, address spender) external view override returns (uint256) {
616 		return _allowances[owner][spender];
617 	}
618 	function getBaseBuyFees() external view returns (uint256, uint256, uint256, uint256, uint256){
619 		return (_base.liquidityFeeOnBuy, _base.devFeeOnBuy, _base.buyBackFeeOnBuy, _base.gamingFeeOnBuy, _base.holdersFeeOnBuy);
620 	}
621 	function getBaseSellFees() external view returns (uint256, uint256, uint256, uint256, uint256){
622 		return (_base.liquidityFeeOnSell, _base.devFeeOnSell, _base.buyBackFeeOnSell, _base.gamingFeeOnSell, _base.holdersFeeOnSell);
623 	}
624 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
625 		require(rAmount <= _rTotal, "KryptoPets: Amount must be less than total reflections");
626 		uint256 currentRate =  _getRate();
627 		return rAmount / currentRate;
628 	}
629 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
630 		require(tAmount <= _tTotal, "KryptoPets: Amount must be less than supply");
631 		uint256 currentRate = _getRate();
632 		uint256 rAmount  = tAmount * currentRate;
633 		if (!deductTransferFee) {
634 			return rAmount;
635 		}
636 		else {
637 			uint256 rTotalFee  = tAmount * _totalFee / 10000 * currentRate;
638 			uint256 rTransferAmount = rAmount - rTotalFee;
639 			return rTransferAmount;
640 		}
641 	}
642 
643 	// Main
644 	function _transfer(
645 		address from,
646 		address to,
647 		uint256 amount
648 		) internal {
649 			require(from != address(0), "ERC20: transfer from the zero address");
650 			require(to != address(0), "ERC20: transfer to the zero address");
651 			require(amount > 0, "Transfer amount must be greater than zero");
652 			require(amount <= balanceOf(from), "KryptoPets: Cannot transfer more than balance");
653 
654 			bool isBuyFromLp = automatedMarketMakerPairs[from];
655 			bool isSelltoLp = automatedMarketMakerPairs[to];
656 
657 		    if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
658 				require(isTradingEnabled, "KryptoPets: Trading is currently disabled.");
659                 if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
660 					require(amount <= maxTxAmount, "KryptoPets: Transfer amount exceeds the maxTxAmount.");
661 				}
662 				if (!_isExcludedFromMaxWalletLimit[to]) {
663 					require((balanceOf(to) + amount) <= maxWalletAmount, "KryptoPets: Expected wallet amount exceeds the maxWalletAmount.");
664 				}
665 
666 			}
667 
668 			_adjustTaxes(isBuyFromLp, isSelltoLp, from, to);
669 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
670 
671 			if (
672 				isTradingEnabled &&
673 				canSwap &&
674 				!_swapping &&
675 				_totalFee > 0 &&
676 				automatedMarketMakerPairs[to]
677 			) {
678 				_swapping = true;
679 				_swapAndLiquify();
680 				_swapping = false;
681 			}
682 
683 			bool takeFee = !_swapping && isTradingEnabled;
684 
685 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
686 				takeFee = false;
687 			}
688 
689 			_tokenTransfer(from, to, amount, takeFee);
690 	}
691 	function _tokenTransfer(address sender,address recipient, uint256 tAmount, bool takeFee) private {
692 		(uint256 tTransferAmount,uint256 tFee, uint256 tOther) = _getTValues(tAmount, takeFee);
693 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rOther) = _getRValues(tAmount, tFee, tOther, _getRate());
694 
695 		if (_isExcludedFromDividends[sender]) {
696 			_tOwned[sender] = _tOwned[sender] - tAmount;
697 		}
698 		if (_isExcludedFromDividends[recipient]) {
699 			_tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
700 		}
701 		_rOwned[sender] = _rOwned[sender] - rAmount;
702 		_rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
703 		_takeContractFees(rOther, tOther);
704 		_reflectFee(rFee, tFee);
705 		emit Transfer(sender, recipient, tTransferAmount);
706 	}
707 	function _reflectFee(uint256 rFee, uint256 tFee) private {
708 		_rTotal -= rFee;
709 		_tFeeTotal += tFee;
710 	}
711 	function _getTValues(uint256 tAmount, bool takeFee) private view returns (uint256,uint256,uint256){
712 		if (!takeFee) {
713 			return (tAmount, 0, 0);
714 		}
715 		else {
716 			uint256 tFee = tAmount * _holdersFee / 10000;
717 			uint256 tOther = tAmount * (_liquidityFee + _devFee + _buyBackFee + _gamingFee) / 10000;
718 			uint256 tTransferAmount = tAmount - (tFee + tOther);
719 			return (tTransferAmount, tFee, tOther);
720 		}
721 	}
722 	function _getRValues(
723 		uint256 tAmount,
724 		uint256 tFee,
725 		uint256 tOther,
726 		uint256 currentRate
727 		) private pure returns ( uint256, uint256, uint256, uint256) {
728 		uint256 rAmount = tAmount * currentRate;
729 		uint256 rFee = tFee * currentRate;
730 		uint256 rOther = tOther * currentRate;
731 		uint256 rTransferAmount = rAmount - (rFee + rOther);
732 		return (rAmount, rTransferAmount, rFee, rOther);
733 	}
734 	function _getRate() private view returns (uint256) {
735 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
736 		return rSupply.div(tSupply);
737 	}
738 	function _getCurrentSupply() private view returns (uint256, uint256) {
739 		uint256 rSupply = _rTotal;
740 		uint256 tSupply = _tTotal;
741 		for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
742 			if (
743 				_rOwned[_excludedFromDividends[i]] > rSupply ||
744 				_tOwned[_excludedFromDividends[i]] > tSupply
745 			) return (_rTotal, _tTotal);
746 			rSupply = rSupply - _rOwned[_excludedFromDividends[i]];
747 			tSupply = tSupply - _tOwned[_excludedFromDividends[i]];
748 		}
749 		if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
750 		return (rSupply, tSupply);
751 	}
752 	function _takeContractFees(uint256 rOther, uint256 tOther) private {
753 		if (_isExcludedFromDividends[address(this)]) {
754 			_tOwned[address(this)] += tOther;
755 		}
756 		_rOwned[address(this)] += rOther;
757 	}
758 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address from, address to) private {
759         _liquidityFee = 0;
760 		_devFee = 0;
761 		_buyBackFee = 0;
762         _gamingFee = 0;
763 		_holdersFee = 0;
764 
765 		if (isBuyFromLp) {
766             if ((block.number - _launchBlockNumber) <= 5) {
767 				_liquidityFee = 10000;
768 			} else {
769                 _liquidityFee = _base.liquidityFeeOnBuy;
770                 _devFee = _base.devFeeOnBuy;
771                 _buyBackFee = _base.buyBackFeeOnBuy;
772                 _gamingFee = _base.gamingFeeOnBuy;
773                 _holdersFee = _base.holdersFeeOnBuy;
774             }
775 		}
776 	    if (isSelltoLp) {
777 			_liquidityFee = _base.liquidityFeeOnSell;
778 			_devFee = _base.devFeeOnSell;
779 			_buyBackFee = _base.buyBackFeeOnSell;
780 			_gamingFee = _base.gamingFeeOnSell;
781 			_holdersFee = _base.holdersFeeOnSell;
782 		}
783         if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
784 			_liquidityFee = _base.liquidityFeeOnSell;
785 			_devFee = _base.devFeeOnSell;
786 			_buyBackFee = _base.buyBackFeeOnSell;
787 			_gamingFee = _base.gamingFeeOnSell;
788 			_holdersFee = _base.holdersFeeOnSell;
789 		}
790 		_totalFee = _liquidityFee + _devFee + _buyBackFee + _gamingFee + _holdersFee;
791 		emit FeesApplied(_liquidityFee, _devFee, _buyBackFee, _gamingFee, _holdersFee, _totalFee);
792 	}
793 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
794 		uint256 _liquidityFeeOnSell,
795 		uint256 _devFeeOnSell,
796 		uint256 _buyBackFeeOnSell,
797         uint256 _gamingFeeOnSell,
798 		uint256 _holdersFeeOnSell
799 	) private {
800 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
801 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
802 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
803 		}
804 		if (map.devFeeOnSell != _devFeeOnSell) {
805 			emit CustomTaxPeriodChange(_devFeeOnSell, map.devFeeOnSell, 'devFeeOnSell', map.periodName);
806 			map.devFeeOnSell = _devFeeOnSell;
807 		}
808 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
809 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
810 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
811 		}
812         if (map.gamingFeeOnSell != _gamingFeeOnSell) {
813 			emit CustomTaxPeriodChange(_gamingFeeOnSell, map.gamingFeeOnSell, 'gamingFeeOnSell', map.periodName);
814 			map.gamingFeeOnSell = _gamingFeeOnSell;
815 		}
816 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
817 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
818 			map.holdersFeeOnSell = _holdersFeeOnSell;
819 		}
820 	}
821 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
822 		uint256 _liquidityFeeOnBuy,
823 		uint256 _devFeeOnBuy,
824 		uint256 _buyBackFeeOnBuy,
825         uint256 _gamingFeeOnBuy,
826 		uint256 _holdersFeeOnBuy
827 		) private {
828 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
829 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
830 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
831 		}
832 		if (map.devFeeOnBuy != _devFeeOnBuy) {
833 			emit CustomTaxPeriodChange(_devFeeOnBuy, map.devFeeOnBuy, 'devFeeOnBuy', map.periodName);
834 			map.devFeeOnBuy = _devFeeOnBuy;
835 		}
836 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
837 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
838 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
839 		}
840         if (map.gamingFeeOnBuy != _gamingFeeOnBuy) {
841 			emit CustomTaxPeriodChange(_gamingFeeOnBuy, map.gamingFeeOnBuy, 'gamingFeeOnBuy', map.periodName);
842 			map.gamingFeeOnBuy = _gamingFeeOnBuy;
843 		}
844 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
845 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
846 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
847 		}
848 	}
849 	function _swapAndLiquify() private {
850 		uint256 contractBalance = balanceOf(address(this));
851 		uint256 initialETHBalance = address(this).balance;
852 
853 		uint256 totalFeePrior = _totalFee;
854 		uint256 holdersFeePrior = _holdersFee;
855 		uint256 devFeePrior = _devFee;
856 		uint256 buyBackFeePrior = _buyBackFee;
857 		uint256 liquidityFeePrior = _liquidityFee;
858 		uint256 gamingFeePrior = _gamingFee;
859 
860 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
861 		uint256 amountToSwap = contractBalance - amountToLiquify;
862 
863 		_swapTokensForETH(amountToSwap);
864 
865 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
866 		uint256 totalETHFee = _totalFee - (liquidityFeePrior / 2) - holdersFeePrior;
867 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * liquidityFeePrior / totalETHFee / 2;
868 		uint256 amountETHDev = ETHBalanceAfterSwap * devFeePrior / totalETHFee;
869 		uint256 amountETHBuyBack = ETHBalanceAfterSwap * buyBackFeePrior / totalETHFee;
870         uint256 amountETHGaming = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHDev + amountETHBuyBack);
871 
872 		payable(devWallet).transfer(amountETHDev);
873 		payable(buyBackWallet).transfer(amountETHBuyBack);
874         payable(gamingWallet).transfer(amountETHGaming);
875 
876 		if (amountToLiquify > 0) {
877 			_addLiquidity(amountToLiquify, amountETHLiquidity);
878 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
879 		}
880 		_totalFee = totalFeePrior;
881 		_holdersFee = holdersFeePrior;
882 		_buyBackFee = buyBackFeePrior;
883 		_liquidityFee = liquidityFeePrior;
884 		_devFee = devFeePrior;
885 		_gamingFee = gamingFeePrior;
886 	}
887 	function _swapTokensForETH(uint256 tokenAmount) private {
888 		address[] memory path = new address[](2);
889 		path[0] = address(this);
890 		path[1] = uniswapV2Router.WETH();
891 		_approve(address(this), address(uniswapV2Router), tokenAmount);
892 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
893 			tokenAmount,
894 			0, // accept any amount of ETH
895 			path,
896 			address(this),
897 			block.timestamp
898 		);
899 	}
900 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
901 		_approve(address(this), address(uniswapV2Router), tokenAmount);
902 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
903 			address(this),
904 			tokenAmount,
905 			0, // slippage is unavoidable
906 			0, // slippage is unavoidable
907 			liquidityWallet,
908 			block.timestamp
909 		);
910 	}
911 }