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
319 contract IMPACTXPRIMEToken is IERC20, Ownable {
320 	using Address for address;
321 	using SafeMath for uint256;
322 
323 	IRouter public uniswapV2Router;
324 	address public immutable uniswapV2Pair;
325 
326 	string private constant _name =  "IMPACTXPRIME";
327 	string private constant _symbol = "IXP";
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
348 	uint256 public minimumTokensBeforeSwap = _tTotal * 25 / 100000;
349 
350     address public liquidityWallet;
351 	address public marketingWallet;
352 	address public buyBackWallet;
353     address public gamingWallet;
354 
355 	struct CustomTaxPeriod {
356 		bytes23 periodName;
357 		uint8 blocksInPeriod;
358 		uint256 timeInPeriod;
359 		uint8 liquidityFeeOnBuy;
360 		uint8 liquidityFeeOnSell;
361 		uint8 marketingFeeOnBuy;
362 		uint8 marketingFeeOnSell;
363 		uint8 buyBackFeeOnBuy;
364 		uint8 buyBackFeeOnSell;
365         uint8 gamingFeeOnBuy;
366         uint8 gamingFeeOnSell;
367 		uint8 holdersFeeOnBuy;
368 		uint8 holdersFeeOnSell;
369 	}
370 
371 	// Base taxes
372 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,6,8,0,0,0,0,0,0,0,0);
373 
374 	uint256 public launchTokens;
375 	uint256 private _launchStartTimestamp;
376 	uint256 private _launchBlockNumber;
377 	bool public _launchTokensClaimed;
378 	mapping (address => bool) private _isBlocked;
379 	mapping (address => bool) private _isExcludedFromFee;
380 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
381 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
382 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
383 	mapping (address => bool) private _isExcludedFromDividends;
384     mapping (address => bool) private _feeOnSelectedWalletTransfers;
385 	address[] private _excludedFromDividends;
386 	mapping (address => bool) public automatedMarketMakerPairs;
387 
388 	uint8 private _liquidityFee;
389 	uint8 private _marketingFee;
390 	uint8 private _buyBackFee;
391     uint8 private _gamingFee;
392 	uint8 private _holdersFee;
393 	uint8 private _totalFee;
394 
395 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
396 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
397 	event BlockedAccountChange(address indexed holder, bool indexed status);
398 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
399 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 buyBackFee, uint8 gamingFee, uint8 holdersFee);
400 	event CustomTaxPeriodChange(uint8 indexed newValue, uint8 indexed oldValue, string indexed taxType, bytes23 period);
401     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
402 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
403 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
404 	event ExcludeFromFeesChange(address indexed account, bool isExcluded);
405 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
406 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
407 	event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
408 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
409     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
410 	event ClaimOverflow(address tokenAddress, uint256 amount);
411 	event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
412 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
413 
414 	constructor() {
415 		liquidityWallet = owner();
416         marketingWallet = owner();
417 		buyBackWallet = owner();
418         gamingWallet = owner();
419 
420 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
421 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
422 			address(this),
423 			_uniswapV2Router.WETH()
424 		);
425 		uniswapV2Router = _uniswapV2Router;
426 		uniswapV2Pair = _uniswapV2Pair;
427 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
428 
429 		_isExcludedFromFee[owner()] = true;
430 		_isExcludedFromFee[address(this)] = true;
431 
432 		excludeFromDividends(address(0), true);
433 		excludeFromDividends(address(_uniswapV2Router), true);
434 		excludeFromDividends(address(_uniswapV2Pair), true);
435 
436 		_isAllowedToTradeWhenDisabled[owner()] = true;
437 
438 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
439 		_isExcludedFromMaxTransactionLimit[owner()] = true;
440 
441 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
442 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
443 		_isExcludedFromMaxWalletLimit[address(this)] = true;
444 		_isExcludedFromMaxWalletLimit[owner()] = true;
445 
446 		_rOwned[owner()] = _rTotal;
447 		emit Transfer(address(0), owner(), _tTotal);
448 	}
449 
450 	receive() external payable {}
451 
452 	// Setters
453 	function transfer(address recipient, uint256 amount) external override returns (bool) {
454 		_transfer(_msgSender(), recipient, amount);
455 		return true;
456 	}
457 	function approve(address spender, uint256 amount) public override returns (bool) {
458 		_approve(_msgSender(), spender, amount);
459 		return true;
460 	}
461 	function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
462 		_transfer(sender, recipient, amount);
463 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
464 		return true;
465 	}
466 	function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
467 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].add(addedValue));
468 		return true;
469 	}
470 	function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
471 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].sub(subtractedValue,"ERC20: decreased allowance below zero"));
472 		return true;
473 	}
474 	function _approve(address owner,address spender,uint256 amount) private {
475 		require(owner != address(0), "ERC20: approve from the zero address");
476 		require(spender != address(0), "ERC20: approve to the zero address");
477 		_allowances[owner][spender] = amount;
478 		emit Approval(owner, spender, amount);
479 	}
480 	function activateTrading() external onlyOwner {
481 		isTradingEnabled = true;
482         if (_launchStartTimestamp == 0) {
483             _launchStartTimestamp = block.timestamp;
484             _launchBlockNumber = block.number;
485         }
486 		emit TradingStatusChange(true, false);
487 	}
488 	function deactivateTrading() external onlyOwner {
489 		isTradingEnabled = false;
490 		emit TradingStatusChange(false, true);
491 	}
492 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
493 		_isAllowedToTradeWhenDisabled[account] = allowed;
494 		emit AllowedWhenTradingDisabledChange(account, allowed);
495 	}
496     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
497 		require(_feeOnSelectedWalletTransfers[account] != value, "ImpactXP: The selected wallet is already set to the value");
498 		_feeOnSelectedWalletTransfers[account] = value;
499 		emit FeeOnSelectedWalletTransfersChange(account, value);
500 	}
501 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
502 		require(automatedMarketMakerPairs[pair] != value, "ImpactXP: Automated market maker pair is already set to that value");
503 		automatedMarketMakerPairs[pair] = value;
504 		emit AutomatedMarketMakerPairChange(pair, value);
505 	}
506 	function blockAccount(address account) external onlyOwner {
507 		require(!_isBlocked[account], "ImpactXP: Account is already blocked");
508 		if (_launchStartTimestamp > 0) {
509 			require((block.timestamp - _launchStartTimestamp) < 172800, "ImpactXP: Time to block accounts has expired");
510 		}
511 		_isBlocked[account] = true;
512 		emit BlockedAccountChange(account, true);
513 	}
514 	function unblockAccount(address account) external onlyOwner {
515 		require(_isBlocked[account], "ImpactXP: Account is not blcoked");
516 		_isBlocked[account] = false;
517 		emit BlockedAccountChange(account, false);
518 	}
519 	function excludeFromFees(address account, bool excluded) external onlyOwner {
520 		require(_isExcludedFromFee[account] != excluded, "ImpactXP: Account is already the value of 'excluded'");
521 		_isExcludedFromFee[account] = excluded;
522 		emit ExcludeFromFeesChange(account, excluded);
523 	}
524 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
525 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "ImpactXP: Account is already the value of 'excluded'");
526 		_isExcludedFromMaxTransactionLimit[account] = excluded;
527 		emit ExcludeFromMaxTransferChange(account, excluded);
528 	}
529 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
530 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "ImpactXP: Account is already the value of 'excluded'");
531 		_isExcludedFromMaxWalletLimit[account] = excluded;
532 		emit ExcludeFromMaxWalletChange(account, excluded);
533 	}
534 	function excludeFromDividends(address account, bool excluded) public onlyOwner {
535 		require(_isExcludedFromDividends[account] != excluded, "ImpactXP: Account is already the value of 'excluded'");
536 		if(excluded) {
537 			if(_rOwned[account] > 0) {
538 				_tOwned[account] = tokenFromReflection(_rOwned[account]);
539 			}
540 			_isExcludedFromDividends[account] = excluded;
541 			_excludedFromDividends.push(account);
542 		} else {
543 			for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
544 				if (_excludedFromDividends[i] == account) {
545 					_excludedFromDividends[i] = _excludedFromDividends[_excludedFromDividends.length - 1];
546 					_tOwned[account] = 0;
547 					_isExcludedFromDividends[account] = false;
548 					_excludedFromDividends.pop();
549 					break;
550 				}
551 			}
552 		}
553 		emit ExcludeFromDividendsChange(account, excluded);
554 	}
555 	function setWallets(address newLiquidityWallet, address newMarketingWallet, address newBuyBackWallet, address newGamingWallet) external onlyOwner {
556 		if(liquidityWallet != newLiquidityWallet) {
557 			require(newLiquidityWallet != address(0), "ImpactXP: The liquidityWallet cannot be 0");
558 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
559 			liquidityWallet = newLiquidityWallet;
560 		}
561 		if(marketingWallet != newMarketingWallet) {
562 			require(newMarketingWallet != address(0), "ImpactXP: The marketingWallet cannot be 0");
563 			emit WalletChange('marketingWallet', newMarketingWallet, marketingWallet);
564 			marketingWallet = newMarketingWallet;
565 		}
566 		if(buyBackWallet != newBuyBackWallet) {
567 			require(newBuyBackWallet != address(0), "ImpactXP: The buyBackWallet cannot be 0");
568 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
569 			buyBackWallet = newBuyBackWallet;
570 		}
571         if(gamingWallet != newGamingWallet) {
572 			require(newGamingWallet != address(0), "ImpactXP: The gamingWallet cannot be 0");
573 			emit WalletChange('gamingWallet', newGamingWallet, gamingWallet);
574 			gamingWallet = newGamingWallet;
575 		}
576 	}
577 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _gamingFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
578 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _gamingFeeOnBuy, _holdersFeeOnBuy);
579 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _gamingFeeOnBuy, _holdersFeeOnBuy);
580 	}
581 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _marketingFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _gamingFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
582 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _gamingFeeOnSell, _holdersFeeOnSell);
583 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _gamingFeeOnSell, _holdersFeeOnSell);
584 	}
585 	function setUniswapRouter(address newAddress) external onlyOwner {
586 		require(newAddress != address(uniswapV2Router), "ImpactXP: The router already has that address");
587 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
588 		uniswapV2Router = IRouter(newAddress);
589 	}
590 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
591 		require(newValue != maxTxAmount, "ImpactXP: Cannot update maxTxAmount to same value");
592 		emit MaxTransactionAmountChange(newValue, maxTxAmount);
593 		maxTxAmount = newValue;
594 	}
595 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
596 		require(newValue != maxWalletAmount, "ImpactXP: Cannot update maxWalletAmount to same value");
597 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
598 		maxWalletAmount = newValue;
599 	}
600 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
601 		require(newValue != minimumTokensBeforeSwap, "ImpactXP: Cannot update minimumTokensBeforeSwap to same value");
602 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
603 		minimumTokensBeforeSwap = newValue;
604 	}
605 	function claimLaunchTokens() external onlyOwner {
606 		require(_launchStartTimestamp > 0, "ImpactXP: Launch must have occurred");
607 		require(!_launchTokensClaimed, "ImpactXP: Launch tokens have already been claimed");
608 		require(block.number - _launchBlockNumber > 5, "ImpactXP: Only claim launch tokens after launch");
609 		uint256 tokenBalance = balanceOf(address(this));
610 		_launchTokensClaimed = true;
611 		require(launchTokens <= tokenBalance, "ImpactXP: A swap and liquify has already occurred");
612 		uint256 amount = launchTokens;
613 		launchTokens = 0;
614 		(bool success) = IERC20(address(this)).transfer(owner(), amount);
615 		if (success){
616 			emit ClaimOverflow(address(this), amount);
617 		}
618 	}
619 	function claimETHOverflow(uint256 amount) external onlyOwner {
620 		require(amount <= address(this).balance, "ImpactXP: Cannot send more than contract balance");
621 		(bool success,) = address(owner()).call{value : amount}("");
622 		if (success){
623 			emit ClaimOverflow(uniswapV2Router.WETH(), amount);
624 		}
625 	}
626 
627 	// Getters
628 	function name() external pure returns (string memory) {
629 		return _name;
630 	}
631 	function symbol() external pure returns (string memory) {
632 		return _symbol;
633 	}
634 	function decimals() external view virtual returns (uint8) {
635 		return _decimals;
636 	}
637 	function totalSupply() external pure override returns (uint256) {
638 		return _tTotal;
639 	}
640 	function balanceOf(address account) public view override returns (uint256) {
641 		if (_isExcludedFromDividends[account]) return _tOwned[account];
642 		return tokenFromReflection(_rOwned[account]);
643 	}
644 	function totalFees() external view returns (uint256) {
645 		return _tFeeTotal;
646 	}
647 	function allowance(address owner, address spender) external view override returns (uint256) {
648 		return _allowances[owner][spender];
649 	}
650 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8, uint8){
651 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.buyBackFeeOnBuy, _base.gamingFeeOnBuy, _base.holdersFeeOnBuy);
652 	}
653 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8, uint8){
654 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.buyBackFeeOnSell, _base.gamingFeeOnSell, _base.holdersFeeOnSell);
655 	}
656 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
657 		require(rAmount <= _rTotal, "ImpactXP: Amount must be less than total reflections");
658 		uint256 currentRate =  _getRate();
659 		return rAmount / currentRate;
660 	}
661 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
662 		require(tAmount <= _tTotal, "ImpactXP: Amount must be less than supply");
663 		uint256 currentRate = _getRate();
664 		uint256 rAmount  = tAmount * currentRate;
665 		if (!deductTransferFee) {
666 			return rAmount;
667 		}
668 		else {
669 			uint256 rTotalFee  = tAmount * _totalFee / 100 * currentRate;
670 			uint256 rTransferAmount = rAmount - rTotalFee;
671 			return rTransferAmount;
672 		}
673 	}
674 
675 	// Main
676 	function _transfer(
677 	address from,
678 	address to,
679 	uint256 amount
680 	) internal {
681 		require(from != address(0), "ERC20: transfer from the zero address");
682 		require(to != address(0), "ERC20: transfer to the zero address");
683 		require(amount > 0, "ImpactXP: Transfer amount must be greater than zero");
684 		require(amount <= balanceOf(from), "ImpactXP: Cannot transfer more than balance");
685 
686 		if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
687 			require(isTradingEnabled, "ImpactXP: Trading is currently disabled.");
688 			require(!_isBlocked[to], "ImpactXP: Account is blocked");
689 			require(!_isBlocked[from], "ImpactXP: Account is blocked");
690 			if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
691 				require(amount <= maxTxAmount, "ImpactXP: Buy amount exceeds the maxTxBuyAmount.");
692 			}
693 			if (!_isExcludedFromMaxWalletLimit[to]) {
694 				require((balanceOf(to) + amount) <= maxWalletAmount, "ImpactXP: Expected wallet amount exceeds the maxWalletAmount.");
695 			}
696 		}
697 
698 		_adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], to, from);
699 		bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
700 
701 		if (
702 			isTradingEnabled &&
703 			canSwap &&
704 			!_swapping &&
705 			_totalFee > 0 &&
706 			automatedMarketMakerPairs[to]
707 		) {
708 			_swapping = true;
709 			_swapAndLiquify();
710 			_swapping = false;
711 		}
712 
713 		bool takeFee = !_swapping && isTradingEnabled;
714 
715 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
716 			takeFee = false;
717 		}
718 
719 		_tokenTransfer(from, to, amount, takeFee);
720 
721 	}
722 	function _tokenTransfer(address sender,address recipient, uint256 tAmount, bool takeFee) private {
723 		(uint256 tTransferAmount,uint256 tFee, uint256 tOther) = _getTValues(tAmount, takeFee);
724 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rOther) = _getRValues(tAmount, tFee, tOther, _getRate());
725 
726 		if (_isExcludedFromDividends[sender]) {
727 			_tOwned[sender] = _tOwned[sender] - tAmount;
728 		}
729 		if (_isExcludedFromDividends[recipient]) {
730 			_tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
731 		}
732 		_rOwned[sender] = _rOwned[sender] - rAmount;
733 		_rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
734 		_reflectFee(rFee, tFee, rOther, tOther);
735 		emit Transfer(sender, recipient, tTransferAmount);
736 	}
737 	function _reflectFee(uint256 rFee, uint256 tFee, uint256 rOther, uint256 tOther) private {
738 		_rTotal -= rFee;
739 		_tFeeTotal += tFee;
740 
741 		if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
742 			launchTokens += tOther;
743 		}
744 
745         if (_isExcludedFromDividends[address(this)]) {
746 			_tOwned[address(this)] += tOther;
747 		}
748 		_rOwned[address(this)] += rOther;
749 	}
750 	function _getTValues(uint256 tAmount, bool takeFee) private view returns (uint256,uint256,uint256){
751 		if (!takeFee) {
752 			return (tAmount, 0, 0);
753 		}
754 		else {
755 			uint256 tFee = tAmount * _holdersFee / 100;
756 			uint256 tOther = tAmount * (_liquidityFee + _marketingFee + _buyBackFee + _gamingFee) / 100;
757 			uint256 tTransferAmount = tAmount - (tFee + tOther);
758 			return (tTransferAmount, tFee, tOther);
759 		}
760 	}
761 	function _getRValues(
762 		uint256 tAmount,
763 		uint256 tFee,
764 		uint256 tOther,
765 		uint256 currentRate
766 		) private pure returns ( uint256, uint256, uint256, uint256) {
767 		uint256 rAmount = tAmount * currentRate;
768 		uint256 rFee = tFee * currentRate;
769 		uint256 rOther = tOther * currentRate;
770 		uint256 rTransferAmount = rAmount - (rFee + rOther);
771 		return (rAmount, rTransferAmount, rFee, rOther);
772 	}
773 	function _getRate() private view returns (uint256) {
774 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
775 		return rSupply.div(tSupply);
776 	}
777 	function _getCurrentSupply() private view returns (uint256, uint256) {
778 		uint256 rSupply = _rTotal;
779 		uint256 tSupply = _tTotal;
780 		for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
781 			if (
782 				_rOwned[_excludedFromDividends[i]] > rSupply ||
783 				_tOwned[_excludedFromDividends[i]] > tSupply
784 			) return (_rTotal, _tTotal);
785 			rSupply = rSupply - _rOwned[_excludedFromDividends[i]];
786 			tSupply = tSupply - _tOwned[_excludedFromDividends[i]];
787 		}
788 		if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
789 		return (rSupply, tSupply);
790 	}
791 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address to, address from) private {
792 		_liquidityFee = 0;
793         _marketingFee = 0;
794         _buyBackFee = 0;
795         _gamingFee = 0;
796         _holdersFee = 0;
797 
798         if (isBuyFromLp) {
799 			if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
800 				_liquidityFee = 100;
801 			}
802 			else {
803                 _liquidityFee = _base.liquidityFeeOnBuy;
804                 _marketingFee = _base.marketingFeeOnBuy;
805                 _buyBackFee = _base.buyBackFeeOnBuy;
806                 _gamingFee = _base.gamingFeeOnBuy;
807                 _holdersFee = _base.holdersFeeOnBuy;
808             }
809 		}
810 		if (isSelltoLp) {
811 			_liquidityFee = _base.liquidityFeeOnSell;
812 			_marketingFee = _base.marketingFeeOnSell;
813 			_buyBackFee = _base.buyBackFeeOnSell;
814             _gamingFee = _base.gamingFeeOnSell;
815 			_holdersFee = _base.holdersFeeOnSell;
816 		}
817 		if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
818 			_liquidityFee = _base.liquidityFeeOnSell;
819 			_marketingFee = _base.marketingFeeOnSell;
820 			_buyBackFee = _base.buyBackFeeOnSell;
821             _gamingFee = _base.gamingFeeOnSell;
822 			_holdersFee = _base.holdersFeeOnSell;
823 		}
824 		_totalFee = _liquidityFee + _marketingFee + _buyBackFee + _gamingFee + _holdersFee;
825 	}
826 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
827 		uint8 _liquidityFeeOnSell,
828 		uint8 _marketingFeeOnSell,
829 		uint8 _buyBackFeeOnSell,
830         uint8 _gamingFeeOnSell,
831 		uint8 _holdersFeeOnSell
832 		) private {
833         require((_liquidityFeeOnSell+_marketingFeeOnSell+_buyBackFeeOnSell+_gamingFeeOnSell+_holdersFeeOnSell) <= 8, "ImpactXP: Sell tax must be less than 8%");
834 
835         if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
836 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
837 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
838 		}
839 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
840 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, 'marketingFeeOnSell', map.periodName);
841 			map.marketingFeeOnSell = _marketingFeeOnSell;
842 		}
843 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
844 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
845 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
846 		}
847         if (map.gamingFeeOnSell != _gamingFeeOnSell) {
848 			emit CustomTaxPeriodChange(_gamingFeeOnSell, map.gamingFeeOnSell, 'gamingFeeOnSell', map.periodName);
849 			map.gamingFeeOnSell = _gamingFeeOnSell;
850 		}
851 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
852 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
853 			map.holdersFeeOnSell = _holdersFeeOnSell;
854 		}
855 	}
856 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
857 		uint8 _liquidityFeeOnBuy,
858 		uint8 _marketingFeeOnBuy,
859 		uint8 _buyBackFeeOnBuy,
860         uint8 _gamingFeeOnBuy,
861 		uint8 _holdersFeeOnBuy
862 		) private {
863         require((_liquidityFeeOnBuy+_marketingFeeOnBuy+_buyBackFeeOnBuy+_gamingFeeOnBuy+_holdersFeeOnBuy) <= 6, "ImpactXP: Buy tax must be less than 6%");
864 
865 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
866 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
867 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
868 		}
869 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
870 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, 'marketingFeeOnBuy', map.periodName);
871 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
872 		}
873 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
874 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
875 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
876 		}
877         if (map.gamingFeeOnBuy != _gamingFeeOnBuy) {
878 			emit CustomTaxPeriodChange(_gamingFeeOnBuy, map.gamingFeeOnBuy, 'gamingFeeOnBuy', map.periodName);
879 			map.gamingFeeOnBuy = _gamingFeeOnBuy;
880 		}
881 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
882 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
883 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
884 		}
885 	}
886 	function _swapAndLiquify() private {
887 		uint256 contractBalance = balanceOf(address(this));
888 		uint256 initialEthBalance = address(this).balance;
889 
890 		uint8 totalFeePrior = _totalFee;
891 		uint8 liquidityFeePrior = _liquidityFee;
892 		uint8 marketingFeePrior = _marketingFee;
893 		uint8 buyBackFeePrior  = _buyBackFee;
894         uint8 gamingFeePrior = _gamingFee;
895 		uint8 holdersFeePrior = _holdersFee;
896 
897 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
898 		uint256 amountToSwap = contractBalance - amountToLiquify;
899 
900 		_swapTokensForEth(amountToSwap);
901 
902 		uint256 ethBalanceAfterSwap = address(this).balance - initialEthBalance;
903 		uint256 totalEthFee = totalFeePrior - (liquidityFeePrior / 2) - (holdersFeePrior);
904 		uint256 amountEthLiquidity = ethBalanceAfterSwap * liquidityFeePrior / totalEthFee / 2;
905 		uint256 amountEthMarketing = ethBalanceAfterSwap * marketingFeePrior / totalEthFee;
906         uint256 amountEthGaming = ethBalanceAfterSwap * gamingFeePrior / totalEthFee;
907 		uint256 amountEthBuyBack = ethBalanceAfterSwap - (amountEthLiquidity + amountEthMarketing + amountEthGaming);
908 
909 		payable(marketingWallet).transfer(amountEthMarketing);
910 		payable(buyBackWallet).transfer(amountEthBuyBack);
911         payable(gamingWallet).transfer(amountEthGaming);
912 
913 		if (amountToLiquify > 0) {
914 			_addLiquidity(amountToLiquify, amountEthLiquidity);
915 			emit SwapAndLiquify(amountToSwap, amountEthLiquidity, amountToLiquify);
916 		}
917 
918 		_totalFee = totalFeePrior;
919 		_liquidityFee = liquidityFeePrior;
920 		_marketingFee = marketingFeePrior;
921 		_buyBackFee = buyBackFeePrior;
922         _gamingFee = gamingFeePrior;
923 		_holdersFee = holdersFeePrior;
924 	}
925 	function _swapTokensForEth(uint256 tokenAmount) private {
926 		address[] memory path = new address[](2);
927 		path[0] = address(this);
928 		path[1] = uniswapV2Router.WETH();
929 		_approve(address(this), address(uniswapV2Router), tokenAmount);
930 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
931 			tokenAmount,
932 			0, // accept any amount of ETH
933 			path,
934 			address(this),
935 			block.timestamp
936 		);
937 	}
938 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
939 		_approve(address(this), address(uniswapV2Router), tokenAmount);
940 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
941 			address(this),
942 			tokenAmount,
943 			0, // slippage is unavoidable
944 			0, // slippage is unavoidable
945 			liquidityWallet,
946 			block.timestamp
947 		);
948 	}
949 }