1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 
6 interface IERC20 {
7 	function totalSupply() external view returns (uint256);
8 
9 	function balanceOf(address account) external view returns (uint256);
10 
11 	function transfer(address recipient, uint256 amount)
12 	external
13 	returns (bool);
14 
15 	function allowance(address owner, address spender)
16 	external
17 	view
18 	returns (uint256);
19 
20 	function approve(address spender, uint256 amount) external returns (bool);
21 
22 	function transferFrom(
23 		address sender,
24 		address recipient,
25 		uint256 amount
26 	) external returns (bool);
27 
28 	event Transfer(address indexed from, address indexed to, uint256 value);
29 
30 	event Approval(
31 		address indexed owner,
32 		address indexed spender,
33 		uint256 value
34 	);
35 }
36 
37 interface IFactory {
38 	function createPair(address tokenA, address tokenB)
39 	external
40 	returns (address pair);
41 
42 	function getPair(address tokenA, address tokenB)
43 	external
44 	view
45 	returns (address pair);
46 }
47 
48 interface IRouter {
49 	function factory() external pure returns (address);
50 
51 	function WETH() external pure returns (address);
52 
53 	function addLiquidityETH(
54 		address token,
55 		uint256 amountTokenDesired,
56 		uint256 amountTokenMin,
57 		uint256 amountETHMin,
58 		address to,
59 		uint256 deadline
60 	)
61 	external
62 	payable
63 	returns (
64 		uint256 amountToken,
65 		uint256 amountETH,
66 		uint256 liquidity
67 	);
68 
69 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
70 		uint256 amountOutMin,
71 		address[] calldata path,
72 		address to,
73 		uint256 deadline
74 	) external payable;
75 
76 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
77 		uint256 amountIn,
78 		uint256 amountOutMin,
79 		address[] calldata path,
80 		address to,
81 		uint256 deadline
82 	) external;
83 }
84 
85 library SafeMath {
86 
87 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
88 		uint256 c = a + b;
89 		require(c >= a, "SafeMath: addition overflow");
90 
91 		return c;
92 	}
93 
94 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95 		return sub(a, b, "SafeMath: subtraction overflow");
96 	}
97 
98 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99 		require(b <= a, errorMessage);
100 		uint256 c = a - b;
101 
102 		return c;
103 	}
104 
105 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107 		// benefit is lost if 'b' is also tested.
108 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109 		if (a == 0) {
110 			return 0;
111 		}
112 
113 		uint256 c = a * b;
114 		require(c / a == b, "SafeMath: multiplication overflow");
115 
116 		return c;
117 	}
118 
119 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
120 		return div(a, b, "SafeMath: division by zero");
121 	}
122 
123 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124 		require(b > 0, errorMessage);
125 		uint256 c = a / b;
126 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128 		return c;
129 	}
130 
131 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132 		return mod(a, b, "SafeMath: modulo by zero");
133 	}
134 
135 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136 		require(b != 0, errorMessage);
137 		return a % b;
138 	}
139 }
140 
141 library Address {
142 	function isContract(address account) internal view returns (bool) {
143 		uint256 size;
144 		assembly {
145 			size := extcodesize(account)
146 		}
147 		return size > 0;
148 	}
149 
150 	function sendValue(address payable recipient, uint256 amount) internal {
151 		require(
152 			address(this).balance >= amount,
153 			"Address: insufficient balance"
154 		);
155 
156 		(bool success, ) = recipient.call{value: amount}("");
157 		require(
158 			success,
159 			"Address: unable to send value, recipient may have reverted"
160 		);
161 	}
162 
163 	function functionCall(address target, bytes memory data)
164 	internal
165 	returns (bytes memory)
166 	{
167 		return functionCall(target, data, "Address: low-level call failed");
168 	}
169 
170 	function functionCall(
171 		address target,
172 		bytes memory data,
173 		string memory errorMessage
174 	) internal returns (bytes memory) {
175 		return functionCallWithValue(target, data, 0, errorMessage);
176 	}
177 
178 	function functionCallWithValue(
179 		address target,
180 		bytes memory data,
181 		uint256 value
182 	) internal returns (bytes memory) {
183 		return
184 		functionCallWithValue(
185 			target,
186 			data,
187 			value,
188 			"Address: low-level call with value failed"
189 		);
190 	}
191 
192 	function functionCallWithValue(
193 		address target,
194 		bytes memory data,
195 		uint256 value,
196 		string memory errorMessage
197 	) internal returns (bytes memory) {
198 		require(
199 			address(this).balance >= value,
200 			"Address: insufficient balance for call"
201 		);
202 		require(isContract(target), "Address: call to non-contract");
203 
204 		(bool success, bytes memory returndata) = target.call{value: value}(
205 		data
206 		);
207 		return _verifyCallResult(success, returndata, errorMessage);
208 	}
209 
210 	function functionStaticCall(address target, bytes memory data)
211 	internal
212 	view
213 	returns (bytes memory)
214 	{
215 		return
216 		functionStaticCall(
217 			target,
218 			data,
219 			"Address: low-level static call failed"
220 		);
221 	}
222 
223 	function functionStaticCall(
224 		address target,
225 		bytes memory data,
226 		string memory errorMessage
227 	) internal view returns (bytes memory) {
228 		require(isContract(target), "Address: static call to non-contract");
229 
230 		(bool success, bytes memory returndata) = target.staticcall(data);
231 		return _verifyCallResult(success, returndata, errorMessage);
232 	}
233 
234 	function functionDelegateCall(address target, bytes memory data)
235 	internal
236 	returns (bytes memory)
237 	{
238 		return
239 		functionDelegateCall(
240 			target,
241 			data,
242 			"Address: low-level delegate call failed"
243 		);
244 	}
245 
246 	function functionDelegateCall(
247 		address target,
248 		bytes memory data,
249 		string memory errorMessage
250 	) internal returns (bytes memory) {
251 		require(isContract(target), "Address: delegate call to non-contract");
252 
253 		(bool success, bytes memory returndata) = target.delegatecall(data);
254 		return _verifyCallResult(success, returndata, errorMessage);
255 	}
256 
257 	function _verifyCallResult(
258 		bool success,
259 		bytes memory returndata,
260 		string memory errorMessage
261 	) private pure returns (bytes memory) {
262 		if (success) {
263 			return returndata;
264 		} else {
265 			if (returndata.length > 0) {
266 				assembly {
267 					let returndata_size := mload(returndata)
268 					revert(add(32, returndata), returndata_size)
269 				}
270 			} else {
271 				revert(errorMessage);
272 			}
273 		}
274 	}
275 }
276 
277 abstract contract Context {
278 		function _msgSender() internal view virtual returns (address) {
279 		return msg.sender;
280 	}
281 
282 	function _msgData() internal view virtual returns (bytes calldata) {
283 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
284 		return msg.data;
285 	}
286 }
287 
288 contract Ownable is Context {
289 	address private _owner;
290 
291 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293 	constructor () {
294 		address msgSender = _msgSender();
295 		_owner = msgSender;
296 		emit OwnershipTransferred(address(0), msgSender);
297 	}
298 
299 	function owner() public view returns (address) {
300 		return _owner;
301 	}
302 
303 	modifier onlyOwner() {
304 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
305 		_;
306 	}
307 
308 	function renounceOwnership() public virtual onlyOwner {
309 		emit OwnershipTransferred(_owner, address(0));
310 		_owner = address(0);
311 	}
312 
313 	function transferOwnership(address newOwner) public virtual onlyOwner {
314 		require(newOwner != address(0), "Ownable: new owner is the zero address");
315 		emit OwnershipTransferred(_owner, newOwner);
316 		_owner = newOwner;
317 	}
318 }
319 
320 contract LuckyRoo is IERC20, Ownable {
321 	using Address for address;
322 	using SafeMath for uint256;
323 
324 	IRouter public uniswapV2Router;
325 	address public immutable uniswapV2Pair;
326 
327 	string private constant _name =  "LUCKY ROO";
328 	string private constant _symbol = "ROO";
329 	uint8 private constant _decimals = 18;
330 
331 	mapping (address => uint256) private _rOwned;
332 	mapping (address => uint256) private _tOwned;
333 	mapping (address => mapping (address => uint256)) private _allowances;
334 
335 	uint256 private constant MAX = ~uint256(0);
336 	uint256 private constant _tTotal = 10000000000000 * 10**18;
337 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
338 	uint256 private _tFeeTotal;
339 
340 	bool public isTradingEnabled;
341 
342 	// max wallet is 1.5% of _tTotal
343 	uint256 public maxWalletAmount = _tTotal * 150 / 10000;
344 
345     // max buy and sell tx is 0.5% of _tTotal
346 	uint256 public maxTxAmount = _tTotal * 50 / 10000;
347 
348 	bool private _swapping;
349 	uint256 public minimumTokensBeforeSwap = 25000000 * (10**18);
350 
351     address public liquidityWallet;
352 	address public marketingWallet;
353 	address public buyBackWallet;
354     address public airdropWallet;
355 
356 	struct CustomTaxPeriod {
357 		bytes23 periodName;
358 		uint8 blocksInPeriod;
359 		uint256 timeInPeriod;
360 		uint8 liquidityFeeOnBuy;
361 		uint8 liquidityFeeOnSell;
362 		uint8 marketingFeeOnBuy;
363 		uint8 marketingFeeOnSell;
364 		uint8 buyBackFeeOnBuy;
365 		uint8 buyBackFeeOnSell;
366         uint8 airdropFeeOnBuy;
367 		uint8 airdropFeeOnSell;
368 		uint8 holdersFeeOnBuy;
369 		uint8 holdersFeeOnSell;
370 	}
371 
372 	// Base taxes
373 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,1,1,3,3,1,1,1,1,2,2);
374 
375     uint256 private _launchStartTimestamp;
376 	uint256 private _launchBlockNumber;
377     uint256 private constant _blockedTimeLimit = 172800;
378     mapping (address => bool) private _isBlocked;
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
391     uint8 private _airdropFee;
392 	uint8 private _holdersFee;
393 	uint8 private _totalFee;
394 
395 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
396 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
397 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
398 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
399 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 buyBackFee, uint8 airdropFee, uint8 holdersFee);
400 	event CustomTaxPeriodChange(uint8 indexed newValue, uint8 indexed oldValue, string indexed taxType, bytes23 period);
401 	event BlockedAccountChange(address indexed holder, bool indexed status);
402     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
403 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
404 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
405 	event ExcludeFromFeesChange(address indexed account, bool isExcluded);
406 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
407 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
408 	event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
409 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
410     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
411 	event ClaimEthOverflow(uint256 amount);
412 	event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
413 
414 	constructor() {
415 		liquidityWallet = owner();
416         marketingWallet = owner();
417 		buyBackWallet = owner();
418         airdropWallet = owner();
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
497 		require(_feeOnSelectedWalletTransfers[account] != value, "LuckyRoo: The selected wallet is already set to the value ");
498 		_feeOnSelectedWalletTransfers[account] = value;
499 		emit FeeOnSelectedWalletTransfersChange(account, value);
500 	}
501 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
502 		require(automatedMarketMakerPairs[pair] != value, "LuckyRoo: Automated market maker pair is already set to that value");
503 		automatedMarketMakerPairs[pair] = value;
504 		emit AutomatedMarketMakerPairChange(pair, value);
505 	}
506     function blockAccount(address account) external onlyOwner {
507 		require(!_isBlocked[account], "LuckyRoo: Account is already blocked");
508 		if (_launchStartTimestamp > 0) {
509 			require((block.timestamp - _launchStartTimestamp) < _blockedTimeLimit, "LuckyRoo: Time to block accounts has expired");
510 		}
511 		_isBlocked[account] = true;
512 		emit BlockedAccountChange(account, true);
513 	}
514 	function unblockAccount(address account) external onlyOwner {
515 		require(_isBlocked[account], "LuckyRoo: Account is not blcoked");
516 		_isBlocked[account] = false;
517 		emit BlockedAccountChange(account, false);
518 	}
519 	function excludeFromFees(address account, bool excluded) external onlyOwner {
520 		require(_isExcludedFromFee[account] != excluded, "LuckyRoo: Account is already the value of 'excluded'");
521 		_isExcludedFromFee[account] = excluded;
522 		emit ExcludeFromFeesChange(account, excluded);
523 	}
524 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
525 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "LuckyRoo: Account is already the value of 'excluded'");
526 		_isExcludedFromMaxTransactionLimit[account] = excluded;
527 		emit ExcludeFromMaxTransferChange(account, excluded);
528 	}
529 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
530 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "LuckyRoo: Account is already the value of 'excluded'");
531 		_isExcludedFromMaxWalletLimit[account] = excluded;
532 		emit ExcludeFromMaxWalletChange(account, excluded);
533 	}
534 	function excludeFromDividends(address account, bool excluded) public onlyOwner {
535 		require(_isExcludedFromDividends[account] != excluded, "LuckyRoo: Account is already the value of 'excluded'");
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
555 	function setWallets(address newLiquidityWallet, address newMarketingWallet, address newBuyBackWallet, address newAirdropWallet) external onlyOwner {
556 		if(liquidityWallet != newLiquidityWallet) {
557 			require(newLiquidityWallet != address(0), "LuckyRoo: The liquidityWallet cannot be 0");
558 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
559 			liquidityWallet = newLiquidityWallet;
560 		}
561 		if(marketingWallet != newMarketingWallet) {
562 			require(newMarketingWallet != address(0), "LuckyRoo: The marketingWallet cannot be 0");
563 			emit WalletChange('marketingWallet', newMarketingWallet, marketingWallet);
564 			marketingWallet = newMarketingWallet;
565 		}
566 		if(buyBackWallet != newBuyBackWallet) {
567 			require(newBuyBackWallet != address(0), "LuckyRoo: The buyBackWallet cannot be 0");
568 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
569 			buyBackWallet = newBuyBackWallet;
570 		}
571         if(airdropWallet != newAirdropWallet) {
572 			require(newAirdropWallet != address(0), "LuckyRoo: The airdropWallet cannot be 0");
573 			emit WalletChange('airdropWallet', newAirdropWallet, airdropWallet);
574 			airdropWallet = newAirdropWallet;
575 		}
576 	}
577 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _airdropFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
578 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _airdropFeeOnBuy, _holdersFeeOnBuy);
579 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _buyBackFeeOnBuy, _airdropFeeOnBuy, _holdersFeeOnBuy);
580 	}
581 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _marketingFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _airdropFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
582 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _airdropFeeOnSell, _holdersFeeOnSell);
583 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _buyBackFeeOnSell, _airdropFeeOnSell, _holdersFeeOnSell);
584 	}
585 	function setUniswapRouter(address newAddress) external onlyOwner {
586 		require(newAddress != address(uniswapV2Router), "LuckyRoo: The router already has that address");
587 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
588 		uniswapV2Router = IRouter(newAddress);
589 	}
590 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
591 		require(newValue != maxTxAmount, "LuckyRoo: Cannot update maxTxAmount to same value");
592 		emit MaxTransactionAmountChange(newValue, maxTxAmount);
593 		maxTxAmount = newValue;
594 	}
595 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
596 		require(newValue != maxWalletAmount, "LuckyRoo: Cannot update maxWalletAmount to same value");
597 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
598 		maxWalletAmount = newValue;
599 	}
600 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
601 		require(newValue != minimumTokensBeforeSwap, "LuckyRoo: Cannot update minimumTokensBeforeSwap to same value");
602 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
603 		minimumTokensBeforeSwap = newValue;
604 	}
605 	function claimEthOverflow(uint256 amount) external onlyOwner {
606 		require(amount < address(this).balance, "LuckyRoo: Cannot send more than contract balance");
607 		(bool success,) = address(owner()).call{value : amount}("");
608 		if (success){
609 			emit ClaimEthOverflow(amount);
610 		}
611 	}
612 
613 	// Getters
614 	function name() external pure returns (string memory) {
615 		return _name;
616 	}
617 	function symbol() external pure returns (string memory) {
618 		return _symbol;
619 	}
620 	function decimals() external view virtual returns (uint8) {
621 		return _decimals;
622 	}
623 	function totalSupply() external pure override returns (uint256) {
624 		return _tTotal;
625 	}
626 	function balanceOf(address account) public view override returns (uint256) {
627 		if (_isExcludedFromDividends[account]) return _tOwned[account];
628 		return tokenFromReflection(_rOwned[account]);
629 	}
630 	function totalFees() external view returns (uint256) {
631 		return _tFeeTotal;
632 	}
633 	function allowance(address owner, address spender) external view override returns (uint256) {
634 		return _allowances[owner][spender];
635 	}
636 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8, uint8){
637 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.buyBackFeeOnBuy, _base.airdropFeeOnBuy, _base.holdersFeeOnBuy);
638 	}
639 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8, uint8){
640 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.buyBackFeeOnSell, _base.airdropFeeOnSell, _base.holdersFeeOnSell);
641 	}
642 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
643 		require(rAmount <= _rTotal, "LuckyRoo: Amount must be less than total reflections");
644 		uint256 currentRate =  _getRate();
645 		return rAmount / currentRate;
646 	}
647 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
648 		require(tAmount <= _tTotal, "LuckyRoo: Amount must be less than supply");
649 		uint256 currentRate = _getRate();
650 		uint256 rAmount  = tAmount * currentRate;
651 		if (!deductTransferFee) {
652 			return rAmount;
653 		}
654 		else {
655 			uint256 rTotalFee  = tAmount * _totalFee / 100 * currentRate;
656 			uint256 rTransferAmount = rAmount - rTotalFee;
657 			return rTransferAmount;
658 		}
659 	}
660 
661 	// Main
662 	function _transfer(
663 	address from,
664 	address to,
665 	uint256 amount
666 	) internal {
667 		require(from != address(0), "ERC20: transfer from the zero address");
668 		require(to != address(0), "ERC20: transfer to the zero address");
669 		require(amount > 0, "LuckyRoo: Transfer amount must be greater than zero");
670 		require(amount <= balanceOf(from), "LuckyRoo: Cannot transfer more than balance");
671 
672 		if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
673 			require(isTradingEnabled, "LuckyRoo: Trading is currently disabled.");
674             require(!_isBlocked[to], "LuckyRoo: Account is blocked");
675 			require(!_isBlocked[from], "LuckyRoo: Account is blocked");
676 			if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
677 				require(amount <= maxTxAmount, "LuckyRoo: Buy amount exceeds the maxTxBuyAmount.");
678 			}
679 			if (!_isExcludedFromMaxWalletLimit[to]) {
680 				require((balanceOf(to) + amount) <= maxWalletAmount, "LuckyRoo: Expected wallet amount exceeds the maxWalletAmount.");
681 			}
682 		}
683 
684 		_adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], to, from);
685 		bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
686 
687 		if (
688 			isTradingEnabled &&
689 			canSwap &&
690 			!_swapping &&
691 			_totalFee > 0 &&
692 			automatedMarketMakerPairs[to]
693 		) {
694 			_swapping = true;
695 			_swapAndLiquify();
696 			_swapping = false;
697 		}
698 
699 		bool takeFee = !_swapping && isTradingEnabled;
700 
701 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
702 			takeFee = false;
703 		}
704 
705 		_tokenTransfer(from, to, amount, takeFee);
706 
707 	}
708 	function _tokenTransfer(address sender,address recipient, uint256 tAmount, bool takeFee) private {
709 		(uint256 tTransferAmount,uint256 tFee, uint256 tOther) = _getTValues(tAmount, takeFee);
710 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rOther) = _getRValues(tAmount, tFee, tOther, _getRate());
711 
712 		if (_isExcludedFromDividends[sender]) {
713 			_tOwned[sender] = _tOwned[sender] - tAmount;
714 		}
715 		if (_isExcludedFromDividends[recipient]) {
716 			_tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
717 		}
718 		_rOwned[sender] = _rOwned[sender] - rAmount;
719 		_rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
720 		_reflectFee(rFee, tFee, rOther, tOther);
721 		emit Transfer(sender, recipient, tTransferAmount);
722 	}
723 	function _reflectFee(uint256 rFee, uint256 tFee, uint256 rOther, uint256 tOther) private {
724 		_rTotal -= rFee;
725 		_tFeeTotal += tFee;
726 
727         if (_isExcludedFromDividends[address(this)]) {
728 			_tOwned[address(this)] += tOther;
729 		}
730 		_rOwned[address(this)] += rOther;
731 	}
732 	function _getTValues(uint256 tAmount, bool takeFee) private view returns (uint256,uint256,uint256){
733 		if (!takeFee) {
734 			return (tAmount, 0, 0);
735 		}
736 		else {
737 			uint256 tFee = tAmount * _holdersFee / 100;
738 			uint256 tOther = tAmount * (_liquidityFee + _marketingFee + _airdropFee + _buyBackFee) / 100;
739 			uint256 tTransferAmount = tAmount - (tFee + tOther);
740 			return (tTransferAmount, tFee, tOther);
741 		}
742 	}
743 	function _getRValues(
744 		uint256 tAmount,
745 		uint256 tFee,
746 		uint256 tOther,
747 		uint256 currentRate
748 		) private pure returns ( uint256, uint256, uint256, uint256) {
749 		uint256 rAmount = tAmount * currentRate;
750 		uint256 rFee = tFee * currentRate;
751 		uint256 rOther = tOther * currentRate;
752 		uint256 rTransferAmount = rAmount - (rFee + rOther);
753 		return (rAmount, rTransferAmount, rFee, rOther);
754 	}
755 	function _getRate() private view returns (uint256) {
756 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
757 		return rSupply.div(tSupply);
758 	}
759 	function _getCurrentSupply() private view returns (uint256, uint256) {
760 		uint256 rSupply = _rTotal;
761 		uint256 tSupply = _tTotal;
762 		for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
763 			if (
764 				_rOwned[_excludedFromDividends[i]] > rSupply ||
765 				_tOwned[_excludedFromDividends[i]] > tSupply
766 			) return (_rTotal, _tTotal);
767 			rSupply = rSupply - _rOwned[_excludedFromDividends[i]];
768 			tSupply = tSupply - _tOwned[_excludedFromDividends[i]];
769 		}
770 		if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
771 		return (rSupply, tSupply);
772 	}
773 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address to, address from) private {
774 		_liquidityFee = 0;
775         _marketingFee = 0;
776         _airdropFee = 0;
777         _buyBackFee = 0;
778         _holdersFee = 0;
779 
780         if (isBuyFromLp) {
781             if (block.number - _launchBlockNumber <= 5) {
782                 _liquidityFee = 100;
783             }
784 			else {
785                 _liquidityFee = _base.liquidityFeeOnBuy;
786                 _marketingFee = _base.marketingFeeOnBuy;
787                 _buyBackFee = _base.buyBackFeeOnBuy;
788                 _airdropFee = _base.airdropFeeOnBuy;
789                 _holdersFee = _base.holdersFeeOnBuy;
790             }
791 		}
792 		if (isSelltoLp) {
793 			_liquidityFee = _base.liquidityFeeOnSell;
794 			_marketingFee = _base.marketingFeeOnSell;
795 			_buyBackFee = _base.buyBackFeeOnSell;
796             _airdropFee = _base.airdropFeeOnSell;
797 			_holdersFee = _base.holdersFeeOnSell;
798 		}
799 		if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
800 			_liquidityFee = _base.liquidityFeeOnSell;
801 			_marketingFee = _base.marketingFeeOnSell;
802 			_buyBackFee = _base.buyBackFeeOnSell;
803             _airdropFee = _base.airdropFeeOnSell;
804 			_holdersFee = _base.holdersFeeOnSell;
805 		}
806 		_totalFee = _liquidityFee + _marketingFee + _buyBackFee + _airdropFee + _holdersFee;
807 	}
808 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
809 		uint8 _liquidityFeeOnSell,
810 		uint8 _marketingFeeOnSell,
811 		uint8 _buyBackFeeOnSell,
812         uint8 _airdropFeeOnSell,
813 		uint8 _holdersFeeOnSell
814 		) private {
815 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
816 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
817 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
818 		}
819 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
820 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, 'marketingFeeOnSell', map.periodName);
821 			map.marketingFeeOnSell = _marketingFeeOnSell;
822 		}
823 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
824 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
825 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
826 		}
827         if (map.airdropFeeOnSell != _airdropFeeOnSell) {
828 			emit CustomTaxPeriodChange(_airdropFeeOnSell, map.airdropFeeOnSell, 'airdropFeeOnSell', map.periodName);
829 			map.airdropFeeOnSell = _airdropFeeOnSell;
830 		}
831 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
832 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
833 			map.holdersFeeOnSell = _holdersFeeOnSell;
834 		}
835 	}
836 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
837 		uint8 _liquidityFeeOnBuy,
838 		uint8 _marketingFeeOnBuy,
839 		uint8 _buyBackFeeOnBuy,
840         uint8 _airdropFeeOnBuy,
841 		uint8 _holdersFeeOnBuy
842 		) private {
843 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
844 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
845 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
846 		}
847 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
848 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, 'marketingFeeOnBuy', map.periodName);
849 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
850 		}
851 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
852 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
853 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
854 		}
855         if (map.airdropFeeOnBuy != _airdropFeeOnBuy) {
856 			emit CustomTaxPeriodChange(_airdropFeeOnBuy, map.airdropFeeOnBuy, 'airdropFeeOnBuy', map.periodName);
857 			map.airdropFeeOnBuy = _airdropFeeOnBuy;
858 		}
859 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
860 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
861 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
862 		}
863 	}
864 	function _swapAndLiquify() private {
865 		uint256 contractBalance = balanceOf(address(this));
866 		uint256 initialEthBalance = address(this).balance;
867 
868 		uint8 totalFeePrior = _totalFee;
869 		uint8 liquidityFeePrior = _liquidityFee;
870 		uint8 marketingFeePrior = _marketingFee;
871 		uint8 buyBackFeePrior  = _buyBackFee;
872         uint8 airdropFeePrior = _airdropFee;
873 		uint8 holdersFeePrior = _holdersFee;
874 
875 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
876 		uint256 amountToSwap = contractBalance - amountToLiquify;
877 
878 		_swapTokensForEth(amountToSwap);
879 
880 		uint256 ethBalanceAfterSwap = address(this).balance - initialEthBalance;
881 		uint256 totalEthFee = totalFeePrior - (liquidityFeePrior / 2) - (holdersFeePrior);
882 		uint256 amountEthLiquidity = ethBalanceAfterSwap * liquidityFeePrior / totalEthFee / 2;
883 		uint256 amountEthMarketing = ethBalanceAfterSwap * marketingFeePrior / totalEthFee;
884 		uint256 amountEthBuyBack = ethBalanceAfterSwap * buyBackFeePrior / totalEthFee;
885 		uint256 amountEthAirdrop = ethBalanceAfterSwap - (amountEthLiquidity + amountEthMarketing + amountEthBuyBack);
886 
887 		Address.sendValue(payable(marketingWallet),amountEthMarketing);
888         Address.sendValue(payable(buyBackWallet),amountEthBuyBack);
889         Address.sendValue(payable(airdropWallet),amountEthAirdrop);
890 
891 		if (amountToLiquify > 0) {
892 			_addLiquidity(amountToLiquify, amountEthLiquidity);
893 			emit SwapAndLiquify(amountToSwap, amountEthLiquidity, amountToLiquify);
894 		}
895 
896 		_totalFee = totalFeePrior;
897 		_liquidityFee = liquidityFeePrior;
898 		_marketingFee = marketingFeePrior;
899 		_buyBackFee = buyBackFeePrior;
900         _airdropFee = airdropFeePrior;
901 		_holdersFee = holdersFeePrior;
902 	}
903 	function _swapTokensForEth(uint256 tokenAmount) private {
904 		address[] memory path = new address[](2);
905 		path[0] = address(this);
906 		path[1] = uniswapV2Router.WETH();
907 		_approve(address(this), address(uniswapV2Router), tokenAmount);
908 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
909 			tokenAmount,
910 			1, // accept any amount of ETH
911 			path,
912 			address(this),
913 			block.timestamp
914 		);
915 	}
916 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
917 		_approve(address(this), address(uniswapV2Router), tokenAmount);
918 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
919 			address(this),
920 			tokenAmount,
921 			1, // slippage is unavoidable
922 			1, // slippage is unavoidable
923 			liquidityWallet,
924 			block.timestamp
925 		);
926 	}
927 }