1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
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
84 library SafeMath {
85 
86 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
87 		uint256 c = a + b;
88 		require(c >= a, "SafeMath: addition overflow");
89 
90 		return c;
91 	}
92 
93 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94 		return sub(a, b, "SafeMath: subtraction overflow");
95 	}
96 
97 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98 		require(b <= a, errorMessage);
99 		uint256 c = a - b;
100 
101 		return c;
102 	}
103 
104 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106 		// benefit is lost if 'b' is also tested.
107 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108 		if (a == 0) {
109 			return 0;
110 		}
111 
112 		uint256 c = a * b;
113 		require(c / a == b, "SafeMath: multiplication overflow");
114 
115 		return c;
116 	}
117 
118 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
119 		return div(a, b, "SafeMath: division by zero");
120 	}
121 
122 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123 		require(b > 0, errorMessage);
124 		uint256 c = a / b;
125 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127 		return c;
128 	}
129 
130 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131 		return mod(a, b, "SafeMath: modulo by zero");
132 	}
133 
134 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135 		require(b != 0, errorMessage);
136 		return a % b;
137 	}
138 }
139 
140 library Address {
141 	function isContract(address account) internal view returns (bool) {
142 		uint256 size;
143 		assembly {
144 			size := extcodesize(account)
145 		}
146 		return size > 0;
147 	}
148 
149 	function sendValue(address payable recipient, uint256 amount) internal {
150 		require(
151 			address(this).balance >= amount,
152 			"Address: insufficient balance"
153 		);
154 
155 		(bool success, ) = recipient.call{value: amount}("");
156 		require(
157 			success,
158 			"Address: unable to send value, recipient may have reverted"
159 		);
160 	}
161 
162 	function functionCall(address target, bytes memory data)
163 	internal
164 	returns (bytes memory)
165 	{
166 		return functionCall(target, data, "Address: low-level call failed");
167 	}
168 
169 	function functionCall(
170 		address target,
171 		bytes memory data,
172 		string memory errorMessage
173 	) internal returns (bytes memory) {
174 		return functionCallWithValue(target, data, 0, errorMessage);
175 	}
176 
177 	function functionCallWithValue(
178 		address target,
179 		bytes memory data,
180 		uint256 value
181 	) internal returns (bytes memory) {
182 		return
183 		functionCallWithValue(
184 			target,
185 			data,
186 			value,
187 			"Address: low-level call with value failed"
188 		);
189 	}
190 
191 	function functionCallWithValue(
192 		address target,
193 		bytes memory data,
194 		uint256 value,
195 		string memory errorMessage
196 	) internal returns (bytes memory) {
197 		require(
198 			address(this).balance >= value,
199 			"Address: insufficient balance for call"
200 		);
201 		require(isContract(target), "Address: call to non-contract");
202 
203 		(bool success, bytes memory returndata) = target.call{value: value}(
204 		data
205 		);
206 		return _verifyCallResult(success, returndata, errorMessage);
207 	}
208 
209 	function functionStaticCall(address target, bytes memory data)
210 	internal
211 	view
212 	returns (bytes memory)
213 	{
214 		return
215 		functionStaticCall(
216 			target,
217 			data,
218 			"Address: low-level static call failed"
219 		);
220 	}
221 
222 	function functionStaticCall(
223 		address target,
224 		bytes memory data,
225 		string memory errorMessage
226 	) internal view returns (bytes memory) {
227 		require(isContract(target), "Address: static call to non-contract");
228 
229 		(bool success, bytes memory returndata) = target.staticcall(data);
230 		return _verifyCallResult(success, returndata, errorMessage);
231 	}
232 
233 	function functionDelegateCall(address target, bytes memory data)
234 	internal
235 	returns (bytes memory)
236 	{
237 		return
238 		functionDelegateCall(
239 			target,
240 			data,
241 			"Address: low-level delegate call failed"
242 		);
243 	}
244 
245 	function functionDelegateCall(
246 		address target,
247 		bytes memory data,
248 		string memory errorMessage
249 	) internal returns (bytes memory) {
250 		require(isContract(target), "Address: delegate call to non-contract");
251 
252 		(bool success, bytes memory returndata) = target.delegatecall(data);
253 		return _verifyCallResult(success, returndata, errorMessage);
254 	}
255 
256 	function _verifyCallResult(
257 		bool success,
258 		bytes memory returndata,
259 		string memory errorMessage
260 	) private pure returns (bytes memory) {
261 		if (success) {
262 			return returndata;
263 		} else {
264 			if (returndata.length > 0) {
265 				assembly {
266 					let returndata_size := mload(returndata)
267 					revert(add(32, returndata), returndata_size)
268 				}
269 			} else {
270 				revert(errorMessage);
271 			}
272 		}
273 	}
274 }
275 
276 abstract contract Context {
277 		function _msgSender() internal view virtual returns (address) {
278 		return msg.sender;
279 	}
280 
281 	function _msgData() internal view virtual returns (bytes calldata) {
282 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
283 		return msg.data;
284 	}
285 }
286 
287 contract Ownable is Context {
288 	address private _owner;
289 
290 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
291 
292 	constructor () {
293 		address msgSender = _msgSender();
294 		_owner = msgSender;
295 		emit OwnershipTransferred(address(0), msgSender);
296 	}
297 
298 	function owner() public view returns (address) {
299 		return _owner;
300 	}
301 
302 	modifier onlyOwner() {
303 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
304 		_;
305 	}
306 
307 	function renounceOwnership() public virtual onlyOwner {
308 		emit OwnershipTransferred(_owner, address(0));
309 		_owner = address(0);
310 	}
311 
312 	function transferOwnership(address newOwner) public virtual onlyOwner {
313 		require(newOwner != address(0), "Ownable: new owner is the zero address");
314 		emit OwnershipTransferred(_owner, newOwner);
315 		_owner = newOwner;
316 	}
317 }
318 
319 contract MetaMerceToken is IERC20, Ownable {
320 	using Address for address;
321 	using SafeMath for uint256;
322 
323 	IRouter public uniswapV2Router;
324 	address public immutable uniswapV2Pair;
325 
326 	string private constant _name =  "MetaMerce Token";
327 	string private constant _symbol = "MMTKN";
328 	uint8 private constant _decimals = 18;
329 
330 	mapping (address => uint256) private _rOwned;
331 	mapping (address => uint256) private _tOwned;
332 	mapping (address => mapping (address => uint256)) private _allowances;
333 
334 	uint256 private constant MAX = ~uint256(0);
335 	uint256 private constant _tTotal = 1000000000 * 10**18;
336 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
337 	uint256 private _tFeeTotal;
338 
339 	bool public isTradingEnabled;
340 
341 	// max wallet is 2.0% of _tTotal
342 	uint256 public maxWalletAmount = _tTotal * 200 / 10000;
343 
344     // max buy and sell tx is 1.0% of _tTotal
345 	uint256 public maxTxAmount = _tTotal * 100 / 10000;
346 
347 	bool private _swapping;
348 	uint256 public minimumTokensBeforeSwap = _tTotal * 50 / 100000;
349 
350     address public liquidityWallet;
351 	address public marketingWallet;
352 	address public buyBackWallet;
353 
354 	struct CustomTaxPeriod {
355 		bytes23 periodName;
356 		uint8 blocksInPeriod;
357 		uint256 timeInPeriod;
358 		uint8 liquidityFeeOnBuy;
359 		uint8 liquidityFeeOnSell;
360 		uint8 marketingFeeOnBuy;
361 		uint8 marketingFeeOnSell;
362 		uint8 buyBackFeeOnBuy;
363 		uint8 buyBackFeeOnSell;
364 		uint8 holdersFeeOnBuy;
365 		uint8 holdersFeeOnSell;
366 	}
367 
368 	// Base taxes
369 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,2,2,4,4,2,2,2,2);
370 
371 	uint256 public launchTokens;
372     uint256 private _launchStartTimestamp;
373 	uint256 private _launchBlockNumber;
374 	bool public _launchTokensClaimed;
375 	mapping (address => bool) private _isBlocked;
376 	mapping (address => bool) private _isExcludedFromFee;
377 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
378 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
379 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
380 	mapping (address => bool) private _isExcludedFromDividends;
381     mapping (address => bool) private _feeOnSelectedWalletTransfers;
382 	address[] private _excludedFromDividends;
383 	mapping (address => bool) public automatedMarketMakerPairs;
384 
385 	uint8 private _liquidityFee;
386 	uint8 private _marketingFee;
387 	uint8 private _buyBackFee;
388 	uint8 private _holdersFee;
389 	uint8 private _totalFee;
390 
391 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
392 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
393 	event BlockedAccountChange(address indexed holder, bool indexed status);
394 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
395 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 buyBackFee, uint8 holdersFee);
396 	event CustomTaxPeriodChange(uint8 indexed newValue, uint8 indexed oldValue, string indexed taxType, bytes23 period);
397     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
398 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
399 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
400 	event ExcludeFromFeesChange(address indexed account, bool isExcluded);
401 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
402 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
403 	event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
404 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
405     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
406 	event ClaimOverflow(address token, uint256 amount);
407 	event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
408 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
409 
410 	constructor() {
411 		liquidityWallet = owner();
412         marketingWallet = owner();
413 		buyBackWallet = owner();
414 
415 		IRouter _uniswapV2Router = IRouter(0x1fdD76e18dD21046b7e7D54C8254Bf08B239e4D9);
416 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
417 			address(this),
418 			_uniswapV2Router.WETH()
419 		);
420 		uniswapV2Router = _uniswapV2Router;
421 		uniswapV2Pair = _uniswapV2Pair;
422 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
423 
424 		_isExcludedFromFee[owner()] = true;
425 		_isExcludedFromFee[address(this)] = true;
426 
427 		excludeFromDividends(address(0), true);
428 		excludeFromDividends(address(_uniswapV2Router), true);
429 		excludeFromDividends(address(_uniswapV2Pair), true);
430 
431 		_isAllowedToTradeWhenDisabled[owner()] = true;
432 
433 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
434 		_isExcludedFromMaxTransactionLimit[owner()] = true;
435 
436 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
437 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
438 		_isExcludedFromMaxWalletLimit[address(this)] = true;
439 		_isExcludedFromMaxWalletLimit[owner()] = true;
440 
441 		_rOwned[owner()] = _rTotal;
442 		emit Transfer(address(0), owner(), _tTotal);
443 	}
444 
445 	receive() external payable {}
446 
447 	// Setters
448 	function transfer(address recipient, uint256 amount) external override returns (bool) {
449 		_transfer(_msgSender(), recipient, amount);
450 		return true;
451 	}
452 	function approve(address spender, uint256 amount) public override returns (bool) {
453 		_approve(_msgSender(), spender, amount);
454 		return true;
455 	}
456 	function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
457 		_transfer(sender, recipient, amount);
458 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
459 		return true;
460 	}
461 	function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
462 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].add(addedValue));
463 		return true;
464 	}
465 	function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
466 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].sub(subtractedValue,"ERC20: decreased allowance below zero"));
467 		return true;
468 	}
469 	function _approve(address owner,address spender,uint256 amount) private {
470 		require(owner != address(0), "ERC20: approve from the zero address");
471 		require(spender != address(0), "ERC20: approve to the zero address");
472 		_allowances[owner][spender] = amount;
473 		emit Approval(owner, spender, amount);
474 	}
475 	function activateTrading() external onlyOwner {
476 		isTradingEnabled = true;
477         if (_launchStartTimestamp == 0) {
478             _launchStartTimestamp = block.timestamp;
479             _launchBlockNumber = block.number;
480         }
481 		emit TradingStatusChange(true, false);
482 	}
483 	function deactivateTrading() external onlyOwner {
484 		isTradingEnabled = false;
485 		emit TradingStatusChange(false, true);
486 	}
487 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
488 		_isAllowedToTradeWhenDisabled[account] = allowed;
489 		emit AllowedWhenTradingDisabledChange(account, allowed);
490 	}
491     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
492 		require(_feeOnSelectedWalletTransfers[account] != value, "MetaMerce: The selected wallet is already set to the value");
493 		_feeOnSelectedWalletTransfers[account] = value;
494 		emit FeeOnSelectedWalletTransfersChange(account, value);
495 	}
496 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
497 		require(automatedMarketMakerPairs[pair] != value, "MetaMerce: Automated market maker pair is already set to that value");
498 		automatedMarketMakerPairs[pair] = value;
499 		emit AutomatedMarketMakerPairChange(pair, value);
500 	}
501 	function blockAccount(address account) external onlyOwner {
502 		require(!_isBlocked[account], "MetaMerce: Account is already blocked");
503 		if (_launchStartTimestamp > 0) {
504 			require((block.timestamp - _launchStartTimestamp) < 172800, "MetaMerce: Time to block accounts has expired");
505 		}
506 		_isBlocked[account] = true;
507 		emit BlockedAccountChange(account, true);
508 	}
509 	function unblockAccount(address account) external onlyOwner {
510 		require(_isBlocked[account], "MetaMerce: Account is not blcoked");
511 		_isBlocked[account] = false;
512 		emit BlockedAccountChange(account, false);
513 	}
514 	function excludeFromFees(address account, bool excluded) external onlyOwner {
515 		require(_isExcludedFromFee[account] != excluded, "MetaMerce: Account is already the value of 'excluded'");
516 		_isExcludedFromFee[account] = excluded;
517 		emit ExcludeFromFeesChange(account, excluded);
518 	}
519 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
520 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "MetaMerce: Account is already the value of 'excluded'");
521 		_isExcludedFromMaxTransactionLimit[account] = excluded;
522 		emit ExcludeFromMaxTransferChange(account, excluded);
523 	}
524 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
525 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "MetaMerce: Account is already the value of 'excluded'");
526 		_isExcludedFromMaxWalletLimit[account] = excluded;
527 		emit ExcludeFromMaxWalletChange(account, excluded);
528 	}
529 	function excludeFromDividends(address account, bool excluded) public onlyOwner {
530 		require(_isExcludedFromDividends[account] != excluded, "MetaMerce: Account is already the value of 'excluded'");
531 		if(excluded) {
532 			if(_rOwned[account] > 0) {
533 				_tOwned[account] = tokenFromReflection(_rOwned[account]);
534 			}
535 			_isExcludedFromDividends[account] = excluded;
536 			_excludedFromDividends.push(account);
537 		} else {
538 			for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
539 				if (_excludedFromDividends[i] == account) {
540 					_excludedFromDividends[i] = _excludedFromDividends[_excludedFromDividends.length - 1];
541 					_tOwned[account] = 0;
542 					_isExcludedFromDividends[account] = false;
543 					_excludedFromDividends.pop();
544 					break;
545 				}
546 			}
547 		}
548 		emit ExcludeFromDividendsChange(account, excluded);
549 	}
550 	function setWallets(address newLiquidityWallet, address newMarketingWallet, address newBuyBackWallet) external onlyOwner {
551 		if(liquidityWallet != newLiquidityWallet) {
552 			require(newLiquidityWallet != address(0), "MetaMerce: The liquidityWallet cannot be 0");
553 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
554 			liquidityWallet = newLiquidityWallet;
555 		}
556 		if(marketingWallet != newMarketingWallet) {
557 			require(newMarketingWallet != address(0), "MetaMerce: The marketingWallet cannot be 0");
558 			emit WalletChange('marketingWallet', newMarketingWallet, marketingWallet);
559 			marketingWallet = newMarketingWallet;
560 		}
561 		if(buyBackWallet != newBuyBackWallet) {
562 			require(newBuyBackWallet != address(0), "MetaMerce: The buyBackWallet cannot be 0");
563 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
564 			buyBackWallet = newBuyBackWallet;
565 		}
566 	}
567 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
568 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
569 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
570 	}
571 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _marketingFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
572 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
573 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
574 	}
575 	function setUniswapRouter(address newAddress) external onlyOwner {
576 		require(newAddress != address(uniswapV2Router), "MetaMerce: The router already has that address");
577 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
578 		uniswapV2Router = IRouter(newAddress);
579 	}
580 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
581 		require(newValue != maxTxAmount, "MetaMerce: Cannot update maxTxAmount to same value");
582 		emit MaxTransactionAmountChange(newValue, maxTxAmount);
583 		maxTxAmount = newValue;
584 	}
585 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
586 		require(newValue != maxWalletAmount, "MetaMerce: Cannot update maxWalletAmount to same value");
587 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
588 		maxWalletAmount = newValue;
589 	}
590 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
591 		require(newValue != minimumTokensBeforeSwap, "MetaMerce: Cannot update minimumTokensBeforeSwap to same value");
592 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
593 		minimumTokensBeforeSwap = newValue;
594 	}
595 	function claimLaunchTokens() external onlyOwner {
596 		require(_launchStartTimestamp > 0, "MetaMerce: Launch must have occurred");
597 		require(!_launchTokensClaimed, "MetaMerce: Launch tokens have already been claimed");
598 		require(block.number - _launchBlockNumber > 5, "MetaMerce: Only claim launch tokens after launch");
599 		uint256 tokenBalance = balanceOf(address(this));
600 		_launchTokensClaimed = true;
601 		require(launchTokens <= tokenBalance, "MetaMerce: A swap and liquify has already occurred");
602 		uint256 amount = launchTokens;
603 		launchTokens = 0;
604         (bool success) = IERC20(address(this)).transfer(owner(), amount);
605         if (success){
606             emit ClaimOverflow(address(this), amount);
607         }
608     }
609 	function claimETHOverflow(uint256 amount) external onlyOwner {
610 		require(amount < address(this).balance, "MetaMerce: Cannot send more than contract balance");
611 		(bool success,) = address(owner()).call{value : amount}("");
612 		if (success){
613 			emit ClaimOverflow(uniswapV2Router.WETH(), amount);
614 		}
615 	}
616 
617 	// Getters
618 	function name() external pure returns (string memory) {
619 		return _name;
620 	}
621 	function symbol() external pure returns (string memory) {
622 		return _symbol;
623 	}
624 	function decimals() external view virtual returns (uint8) {
625 		return _decimals;
626 	}
627 	function totalSupply() external pure override returns (uint256) {
628 		return _tTotal;
629 	}
630 	function balanceOf(address account) public view override returns (uint256) {
631 		if (_isExcludedFromDividends[account]) return _tOwned[account];
632 		return tokenFromReflection(_rOwned[account]);
633 	}
634 	function totalFees() external view returns (uint256) {
635 		return _tFeeTotal;
636 	}
637 	function allowance(address owner, address spender) external view override returns (uint256) {
638 		return _allowances[owner][spender];
639 	}
640 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8){
641 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.buyBackFeeOnBuy, _base.holdersFeeOnBuy);
642 	}
643 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8){
644 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.buyBackFeeOnSell, _base.holdersFeeOnSell);
645 	}
646 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
647 		require(rAmount <= _rTotal, "MetaMerce: Amount must be less than total reflections");
648 		uint256 currentRate =  _getRate();
649 		return rAmount / currentRate;
650 	}
651 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
652 		require(tAmount <= _tTotal, "MetaMerce: Amount must be less than supply");
653 		uint256 currentRate = _getRate();
654 		uint256 rAmount  = tAmount * currentRate;
655 		if (!deductTransferFee) {
656 			return rAmount;
657 		}
658 		else {
659 			uint256 rTotalFee  = tAmount * _totalFee / 100 * currentRate;
660 			uint256 rTransferAmount = rAmount - rTotalFee;
661 			return rTransferAmount;
662 		}
663 	}
664 
665 	// Main
666 	function _transfer(
667 	address from,
668 	address to,
669 	uint256 amount
670 	) internal {
671 		require(from != address(0), "ERC20: transfer from the zero address");
672 		require(to != address(0), "ERC20: transfer to the zero address");
673 		require(amount > 0, "MetaMerce: Transfer amount must be greater than zero");
674 		require(amount <= balanceOf(from), "MetaMerce: Cannot transfer more than balance");
675 
676 		if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
677 			require(isTradingEnabled, "MetaMerce: Trading is currently disabled.");
678 			require(!_isBlocked[to], "MetaMerce: Account is blocked");
679 			require(!_isBlocked[from], "MetaMerce: Account is blocked");
680 			if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
681 				require(amount <= maxTxAmount, "MetaMerce: Buy amount exceeds the maxTxBuyAmount.");
682 			}
683 			if (!_isExcludedFromMaxWalletLimit[to]) {
684 				require((balanceOf(to) + amount) <= maxWalletAmount, "MetaMerce: Expected wallet amount exceeds the maxWalletAmount.");
685 			}
686 		}
687 
688 		_adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], to, from);
689 		bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
690 
691 		if (
692 			isTradingEnabled &&
693 			canSwap &&
694 			!_swapping &&
695 			_totalFee > 0 &&
696 			automatedMarketMakerPairs[to]
697 		) {
698 			_swapping = true;
699 			_swapAndLiquify();
700 			_swapping = false;
701 		}
702 
703 		bool takeFee = !_swapping && isTradingEnabled;
704 
705 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
706 			takeFee = false;
707 		}
708 
709 		_tokenTransfer(from, to, amount, takeFee);
710 
711 	}
712 	function _tokenTransfer(address sender,address recipient, uint256 tAmount, bool takeFee) private {
713 		(uint256 tTransferAmount,uint256 tFee, uint256 tOther) = _getTValues(tAmount, takeFee);
714 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rOther) = _getRValues(tAmount, tFee, tOther, _getRate());
715 
716 		if (_isExcludedFromDividends[sender]) {
717 			_tOwned[sender] = _tOwned[sender] - tAmount;
718 		}
719 		if (_isExcludedFromDividends[recipient]) {
720 			_tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
721 		}
722 		_rOwned[sender] = _rOwned[sender] - rAmount;
723 		_rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
724 		_reflectFee(rFee, tFee, rOther, tOther);
725 		emit Transfer(sender, recipient, tTransferAmount);
726 	}
727 	function _reflectFee(uint256 rFee, uint256 tFee, uint256 rOther, uint256 tOther) private {
728 		_rTotal -= rFee;
729 		_tFeeTotal += tFee;
730 
731 		if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
732 			launchTokens += tOther;
733 		}
734 
735         if (_isExcludedFromDividends[address(this)]) {
736 			_tOwned[address(this)] += tOther;
737 		}
738 		_rOwned[address(this)] += rOther;
739 	}
740 	function _getTValues(uint256 tAmount, bool takeFee) private view returns (uint256,uint256,uint256){
741 		if (!takeFee) {
742 			return (tAmount, 0, 0);
743 		}
744 		else {
745 			uint256 tFee = tAmount * _holdersFee / 100;
746 			uint256 tOther = tAmount * (_liquidityFee + _marketingFee + _buyBackFee) / 100;
747 			uint256 tTransferAmount = tAmount - (tFee + tOther);
748 			return (tTransferAmount, tFee, tOther);
749 		}
750 	}
751 	function _getRValues(
752 		uint256 tAmount,
753 		uint256 tFee,
754 		uint256 tOther,
755 		uint256 currentRate
756 		) private pure returns ( uint256, uint256, uint256, uint256) {
757 		uint256 rAmount = tAmount * currentRate;
758 		uint256 rFee = tFee * currentRate;
759 		uint256 rOther = tOther * currentRate;
760 		uint256 rTransferAmount = rAmount - (rFee + rOther);
761 		return (rAmount, rTransferAmount, rFee, rOther);
762 	}
763 	function _getRate() private view returns (uint256) {
764 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
765 		return rSupply.div(tSupply);
766 	}
767 	function _getCurrentSupply() private view returns (uint256, uint256) {
768 		uint256 rSupply = _rTotal;
769 		uint256 tSupply = _tTotal;
770 		for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
771 			if (
772 				_rOwned[_excludedFromDividends[i]] > rSupply ||
773 				_tOwned[_excludedFromDividends[i]] > tSupply
774 			) return (_rTotal, _tTotal);
775 			rSupply = rSupply - _rOwned[_excludedFromDividends[i]];
776 			tSupply = tSupply - _tOwned[_excludedFromDividends[i]];
777 		}
778 		if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
779 		return (rSupply, tSupply);
780 	}
781 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address to, address from) private {
782 		_liquidityFee = 0;
783         _marketingFee = 0;
784         _buyBackFee = 0;
785         _holdersFee = 0;
786 
787         if (isBuyFromLp) {
788             if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
789                 _liquidityFee = 100;
790             }
791 			else {
792                 _liquidityFee = _base.liquidityFeeOnBuy;
793                 _marketingFee = _base.marketingFeeOnBuy;
794                 _buyBackFee = _base.buyBackFeeOnBuy;
795                 _holdersFee = _base.holdersFeeOnBuy;
796             }
797 		}
798 		if (isSelltoLp) {
799 			_liquidityFee = _base.liquidityFeeOnSell;
800 			_marketingFee = _base.marketingFeeOnSell;
801 			_buyBackFee = _base.buyBackFeeOnSell;
802 			_holdersFee = _base.holdersFeeOnSell;
803 		}
804 		if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
805 			_liquidityFee = _base.liquidityFeeOnSell;
806 			_marketingFee = _base.marketingFeeOnSell;
807 			_buyBackFee = _base.buyBackFeeOnSell;
808 			_holdersFee = _base.holdersFeeOnSell;
809 		}
810 		_totalFee = _liquidityFee + _marketingFee + _buyBackFee + _holdersFee;
811 	}
812 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
813 		uint8 _liquidityFeeOnSell,
814 		uint8 _marketingFeeOnSell,
815 		uint8 _buyBackFeeOnSell,
816 		uint8 _holdersFeeOnSell
817 		) private {
818 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
819 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
820 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
821 		}
822 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
823 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, 'marketingFeeOnSell', map.periodName);
824 			map.marketingFeeOnSell = _marketingFeeOnSell;
825 		}
826 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
827 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
828 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
829 		}
830 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
831 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
832 			map.holdersFeeOnSell = _holdersFeeOnSell;
833 		}
834 	}
835 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
836 		uint8 _liquidityFeeOnBuy,
837 		uint8 _marketingFeeOnBuy,
838 		uint8 _buyBackFeeOnBuy,
839 		uint8 _holdersFeeOnBuy
840 		) private {
841 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
842 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
843 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
844 		}
845 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
846 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, 'marketingFeeOnBuy', map.periodName);
847 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
848 		}
849 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
850 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
851 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
852 		}
853 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
854 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
855 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
856 		}
857 	}
858 	function _swapAndLiquify() private {
859 		uint256 contractBalance = balanceOf(address(this));
860 		uint256 initialEthBalance = address(this).balance;
861 
862 		uint8 totalFeePrior = _totalFee;
863 		uint8 liquidityFeePrior = _liquidityFee;
864 		uint8 marketingFeePrior = _marketingFee;
865 		uint8 buyBackFeePrior  = _buyBackFee;
866 		uint8 holdersFeePrior = _holdersFee;
867 
868 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
869 		uint256 amountToSwap = contractBalance - amountToLiquify;
870 
871 		_swapTokensForEth(amountToSwap);
872 
873 		uint256 ethBalanceAfterSwap = address(this).balance - initialEthBalance;
874 		uint256 totalEthFee = totalFeePrior - (liquidityFeePrior / 2) - (holdersFeePrior);
875 		uint256 amountEthLiquidity = ethBalanceAfterSwap * liquidityFeePrior / totalEthFee / 2;
876 		uint256 amountEthMarketing = ethBalanceAfterSwap * marketingFeePrior / totalEthFee;
877 		uint256 amountEthBuyBack = ethBalanceAfterSwap - (amountEthLiquidity + amountEthMarketing);
878 
879 		payable(marketingWallet).transfer(amountEthMarketing);
880 		payable(buyBackWallet).transfer(amountEthBuyBack);
881 
882 		if (amountToLiquify > 0) {
883 			_addLiquidity(amountToLiquify, amountEthLiquidity);
884 			emit SwapAndLiquify(amountToSwap, amountEthLiquidity, amountToLiquify);
885 		}
886 
887 		_totalFee = totalFeePrior;
888 		_liquidityFee = liquidityFeePrior;
889 		_marketingFee = marketingFeePrior;
890 		_buyBackFee = buyBackFeePrior;
891 		_holdersFee = holdersFeePrior;
892 	}
893 	function _swapTokensForEth(uint256 tokenAmount) private {
894 		address[] memory path = new address[](2);
895 		path[0] = address(this);
896 		path[1] = uniswapV2Router.WETH();
897 		_approve(address(this), address(uniswapV2Router), tokenAmount);
898 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
899 			tokenAmount,
900 			0, // accept any amount of ETH
901 			path,
902 			address(this),
903 			block.timestamp
904 		);
905 	}
906 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
907 		_approve(address(this), address(uniswapV2Router), tokenAmount);
908 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
909 			address(this),
910 			tokenAmount,
911 			0, // slippage is unavoidable
912 			0, // slippage is unavoidable
913 			liquidityWallet,
914 			block.timestamp
915 		);
916 	}
917 }