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
319 contract TheRevolutionToken is IERC20, Ownable {
320 	using Address for address;
321     using SafeMath for uint256;
322 
323 	IRouter public uniswapV2Router;
324 	address public immutable uniswapV2Pair;
325 
326 	string private constant _name =  "The Revolution Token";
327 	string private constant _symbol = "TRT";
328 	uint8 private constant _decimals = 18;
329 
330 	mapping (address => uint256) private _rOwned;
331 	mapping (address => uint256) private _tOwned;
332 	mapping (address => mapping (address => uint256)) private _allowances;
333 
334 	uint256 private constant MAX = ~uint256(0);
335 	uint256 private constant _tTotal = 100000000000 * 10**18;
336 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
337 	uint256 private _tFeeTotal;
338 
339 	bool public isTradingEnabled;
340 
341 	// max wallet is 1.0% of initialSupply
342 	uint256 public maxWalletAmount = _tTotal * 100 / 10000;
343 
344     // max tx is 0.33% of initialSupply
345 	uint256 public maxTxAmount = _tTotal * 330 / 100000;
346 
347 	bool private _swapping;
348 
349     // max wallet is 0.025% of initialSupply
350 	uint256 public minimumTokensBeforeSwap = _tTotal * 250 / 1000000;
351 
352     address private dead = 0x000000000000000000000000000000000000dEaD;
353 
354 	address public liquidityWallet;
355     address public marketingWallet;
356 	address public buyBackWallet;
357 	address public devWallet;
358 
359 	struct CustomTaxPeriod {
360 		bytes23 periodName;
361 		uint8 blocksInPeriod;
362 		uint256 timeInPeriod;
363 		uint8 liquidityFeeOnBuy;
364 		uint8 liquidityFeeOnSell;
365 		uint8 marketingFeeOnBuy;
366 		uint8 marketingFeeOnSell;
367         uint8 devFeeOnBuy;
368 		uint8 devFeeOnSell;
369 		uint8 buyBackFeeOnBuy;
370 		uint8 buyBackFeeOnSell;
371 		uint8 holdersFeeOnBuy;
372 		uint8 holdersFeeOnSell;
373 	}
374 
375 	// Base taxes
376 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,1,1,3,3,2,2,2,2,2,2);
377 
378     uint256 private constant _blockedTimeLimit = 259200;
379     uint256 private _launchBlockNumber;
380     uint256 private _launchTimestamp;
381     mapping (address => bool) private _isBlocked;
382 	mapping (address => bool) private _isExcludedFromFee;
383 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
384 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
385 	mapping (address => bool) public automatedMarketMakerPairs;
386     mapping (address => bool) private _isExcludedFromDividends;
387 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
388     address[] private _excludedFromDividends;
389 
390 	uint8 private _liquidityFee;
391 	uint8 private _marketingFee;
392     uint8 private _devFee;
393 	uint8 private _buyBackFee;
394 	uint8 private _holdersFee;
395 	uint8 private _totalFee;
396 
397 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
398 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
399     event BlockedAccountChange(address indexed holder, bool indexed status);
400 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
401 	event WalletChange(string indexed indentifier, address indexed newWallet, address indexed oldWallet);
402 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 devFee, uint8 buyBackFee, uint8 holdersFee);
403 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
404 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
405 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
406     event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
407 	event ExcludeFromFeesChange(address indexed account, bool isExcluded);
408 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
409 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
410 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
411 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
412 	event ClaimETHOverflow(uint256 amount);
413 	event FeesApplied(uint8 liquidityFee, uint8 marketingFee, uint8 devFee, uint8 buyBackFee, uint8 holdersFee, uint8 totalFee);
414 
415 	constructor() {
416 		liquidityWallet = owner();
417 		marketingWallet = owner();
418 		buyBackWallet = owner();
419         devWallet = owner();
420 
421 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
422 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
423 			address(this),
424 			_uniswapV2Router.WETH()
425 		);
426         uniswapV2Router = _uniswapV2Router;
427 		uniswapV2Pair = _uniswapV2Pair;
428 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
429 
430         _isExcludedFromFee[owner()] = true;
431 		_isExcludedFromFee[address(this)] = true;
432 
433         excludeFromDividends(address(this), true);
434 		excludeFromDividends(address(dead), true);
435 		excludeFromDividends(address(_uniswapV2Router), true);
436 
437 		_isAllowedToTradeWhenDisabled[owner()] = true;
438 		_isAllowedToTradeWhenDisabled[address(this)] = true;
439 
440 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
441 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
442 		_isExcludedFromMaxWalletLimit[address(this)] = true;
443 		_isExcludedFromMaxWalletLimit[owner()] = true;
444 
445         _isExcludedFromMaxTransactionLimit[address(this)] = true;
446 		_isExcludedFromMaxTransactionLimit[address(dead)] = true;
447 		_isExcludedFromMaxTransactionLimit[owner()] = true;
448 
449 		_rOwned[owner()] = _rTotal;
450 		emit Transfer(address(0), owner(), _tTotal);
451 	}
452 
453 	receive() external payable {}
454 
455 	// Setters
456 	function transfer(address recipient, uint256 amount) external override returns (bool) {
457 		_transfer(_msgSender(), recipient, amount);
458 		return true;
459 	}
460 	function approve(address spender, uint256 amount) public override returns (bool) {
461 		_approve(_msgSender(), spender, amount);
462 		return true;
463 	}
464 	function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
465 		_transfer(sender, recipient, amount);
466 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
467 		return true;
468 	}
469 	function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
470 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].add(addedValue));
471 		return true;
472 	}
473 	function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
474 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].sub(subtractedValue,"ERC20: decreased allowance below zero"));
475 		return true;
476 	}
477 	function _approve(address owner,address spender,uint256 amount) private {
478 		require(owner != address(0), "ERC20: approve from the zero address");
479 		require(spender != address(0), "ERC20: approve to the zero address");
480 		_allowances[owner][spender] = amount;
481 		emit Approval(owner, spender, amount);
482 	}
483 	function activateTrading() external onlyOwner {
484 		isTradingEnabled = true;
485         if (_launchTimestamp == 0) {
486 			_launchTimestamp = block.timestamp;
487 			_launchBlockNumber = block.number;
488 		}
489 	}
490 	function deactivateTrading() external onlyOwner {
491 		isTradingEnabled = false;
492 	}
493     function _setAutomatedMarketMakerPair(address pair, bool value) private {
494 		require(automatedMarketMakerPairs[pair] != value, "The Revolution Token: Automated market maker pair is already set to that value");
495 		automatedMarketMakerPairs[pair] = value;
496 		emit AutomatedMarketMakerPairChange(pair, value);
497 	}
498     function blockAccount(address account) external onlyOwner {
499 		require(!_isBlocked[account], "The Revolution Token: Account is already blocked");
500 		require((block.timestamp - _launchTimestamp) < _blockedTimeLimit, "The Revolution Token: Time to block accounts has expired");
501 		_isBlocked[account] = true;
502 		emit BlockedAccountChange(account, true);
503 	}
504 	function unblockAccount(address account) external onlyOwner {
505 		require(_isBlocked[account], "The Revolution Token: Account is not blcoked");
506 		_isBlocked[account] = false;
507 		emit BlockedAccountChange(account, false);
508 	}
509 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
510 		_isAllowedToTradeWhenDisabled[account] = allowed;
511 		emit AllowedWhenTradingDisabledChange(account, allowed);
512 	}
513 	function excludeFromFees(address account, bool excluded) external onlyOwner {
514 		require(_isExcludedFromFee[account] != excluded, "The Revolution Token: Account is already the value of 'excluded'");
515 		_isExcludedFromFee[account] = excluded;
516 		emit ExcludeFromFeesChange(account, excluded);
517 	}
518     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
519 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "The Revolution Token: Account is already the value of 'excluded'");
520 		_isExcludedFromMaxWalletLimit[account] = excluded;
521 		emit ExcludeFromMaxWalletChange(account, excluded);
522 	}
523 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
524 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "The Revolution Token: Account is already the value of 'excluded'");
525 		_isExcludedFromMaxTransactionLimit[account] = excluded;
526 		emit ExcludeFromMaxTransferChange(account, excluded);
527 	}
528 	function setWallets(address newLiquidityWallet, address newMarketingWallet, address newDevWallet, address newBuyBackWallet) external onlyOwner {
529 		if(liquidityWallet != newLiquidityWallet) {
530             require(newLiquidityWallet != address(0), "The Revolution Token: The liquidityWallet cannot be 0");
531 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
532 			liquidityWallet = newLiquidityWallet;
533 		}
534         if(marketingWallet != newMarketingWallet) {
535             require(newMarketingWallet != address(0), "The Revolution Token: The marketingWallet cannot be 0");
536 			emit WalletChange('marketingWallet', newMarketingWallet, marketingWallet);
537 			marketingWallet = newMarketingWallet;
538 		}
539 		if(devWallet != newDevWallet) {
540             require(newDevWallet != address(0), "The Revolution Token: The devWallet cannot be 0");
541 			emit WalletChange('devWallet', newDevWallet, devWallet);
542 			devWallet = newDevWallet;
543 		}
544 		if(buyBackWallet != newBuyBackWallet) {
545             require(newBuyBackWallet != address(0), "The Revolution Token: The buyBackWallet cannot be 0");
546 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
547 			buyBackWallet = newBuyBackWallet;
548 		}
549 	}
550     // Base fees
551 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy,  uint8 _marketingFeeOnBuy, uint8 _devFeeOnBuy,  uint8 _buyBackFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
552 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
553 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
554 	}
555 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _marketingFeeOnSell, uint8 _devFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
556 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
557 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
558 	}
559 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
560 		require(newValue != maxWalletAmount, "The Revolution Token: Cannot update maxWalletAmount to same value");
561 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
562 		maxWalletAmount = newValue;
563 	}
564 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
565 		require(newValue != maxTxAmount, "The Revolution Token: Cannot update maxTxAmount to same value");
566         emit MaxTransactionAmountChange(newValue, maxTxAmount);
567         maxTxAmount = newValue;
568 	}
569 	function excludeFromDividends(address account, bool excluded) public onlyOwner {
570 		require(_isExcludedFromDividends[account] != excluded, "The Revolution Token: Account is already the value of 'excluded'");
571 		if(excluded) {
572 			if(_rOwned[account] > 0) {
573 				_tOwned[account] = tokenFromReflection(_rOwned[account]);
574 			}
575 			_isExcludedFromDividends[account] = excluded;
576 			_excludedFromDividends.push(account);
577 		} else {
578 			for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
579 				if (_excludedFromDividends[i] == account) {
580 					_excludedFromDividends[i] = _excludedFromDividends[_excludedFromDividends.length - 1];
581 					_tOwned[account] = 0;
582 					_isExcludedFromDividends[account] = false;
583 					_excludedFromDividends.pop();
584 					break;
585 				}
586 			}
587 		}
588 		emit ExcludeFromDividendsChange(account, excluded);
589 	}
590 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
591 		require(newValue != minimumTokensBeforeSwap, "The Revolution Token: Cannot update minimumTokensBeforeSwap to same value");
592 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
593 		minimumTokensBeforeSwap = newValue;
594 	}
595 	function claimETHOverflow() external onlyOwner {
596 		require(address(this).balance > 0, "The Revolution Token: Cannot send more than contract balance");
597         uint256 amount = address(this).balance;
598 		(bool success,) = address(owner()).call{value : amount}("");
599 		if (success){
600 			emit ClaimETHOverflow(amount);
601 		}
602 	}
603 
604 	// Getters
605 	function name() external view returns (string memory) {
606 		return _name;
607 	}
608 	function symbol() external view returns (string memory) {
609 		return _symbol;
610 	}
611 	function decimals() external view virtual returns (uint8) {
612 		return _decimals;
613 	}
614 	function totalSupply() external view override returns (uint256) {
615 		return _tTotal;
616 	}
617 	function balanceOf(address account) public view override returns (uint256) {
618 		if (_isExcludedFromDividends[account]) return _tOwned[account];
619 		return tokenFromReflection(_rOwned[account]);
620 	}
621 	function totalFees() external view returns (uint256) {
622 		return _tFeeTotal;
623 	}
624 	function allowance(address owner, address spender) external view override returns (uint256) {
625 		return _allowances[owner][spender];
626 	}
627     function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8, uint8){
628 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.devFeeOnBuy, _base.buyBackFeeOnBuy, _base.holdersFeeOnBuy);
629 	}
630 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8, uint8){
631 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.devFeeOnSell, _base.buyBackFeeOnSell, _base.holdersFeeOnSell);
632 	}
633 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
634 		require(rAmount <= _rTotal, "The Revolution Token: Amount must be less than total reflections");
635 		uint256 currentRate =  _getRate();
636 		return rAmount / currentRate;
637 	}
638 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
639 		require(tAmount <= _tTotal, "The Revolution Token: Amount must be less than supply");
640 		uint256 currentRate = _getRate();
641 		uint256 rAmount  = tAmount * currentRate;
642 		if (!deductTransferFee) {
643 			return rAmount;
644 		}
645 		else {
646 			uint256 rTotalFee  = tAmount * _totalFee / 100 * currentRate;
647 			uint256 rTransferAmount = rAmount - rTotalFee;
648 			return rTransferAmount;
649 		}
650 	}
651 
652 	// Main
653 	function _transfer(
654 	address from,
655 	address to,
656 	uint256 amount
657 	) internal {
658 		require(from != address(0), "ERC20: transfer from the zero address");
659 		require(to != address(0), "ERC20: transfer to the zero address");
660 		require(amount > 0, "Transfer amount must be greater than zero");
661 		require(amount <= balanceOf(from), "The Revolution Token: Cannot transfer more than balance");
662 
663 		bool isBuyFromLp = automatedMarketMakerPairs[from];
664 		bool isSelltoLp = automatedMarketMakerPairs[to];
665 
666 		if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
667 			require(isTradingEnabled, "The Revolution Token: Trading is currently disabled.");
668             require(!_isBlocked[to], "The Revolution Token: Account is blocked");
669 			require(!_isBlocked[from], "The Revolution Token: Account is blocked");
670             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
671                 require(amount <= maxTxAmount, "The Revolution Token: Transfer amount exceeds the maxTxAmount.");
672             }
673 			if (!_isExcludedFromMaxWalletLimit[to]) {
674 				require((balanceOf(to) + amount) <= maxWalletAmount, "The Revolution Token: Expected wallet amount exceeds the maxWalletAmount.");
675 			}
676 		}
677 
678 		_adjustTaxes(isBuyFromLp, isSelltoLp);
679 		bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
680 
681 		if (
682 			isTradingEnabled &&
683 			canSwap &&
684 			!_swapping &&
685 			_totalFee > 0 &&
686 			automatedMarketMakerPairs[to]
687 		) {
688 			_swapping = true;
689 			_swapAndLiquify();
690 			_swapping = false;
691 		}
692 
693 		bool takeFee = !_swapping && isTradingEnabled;
694 
695 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
696 			takeFee = false;
697 		}
698 		_tokenTransfer(from, to, amount, takeFee);
699 	}
700 	function _tokenTransfer(address sender,address recipient, uint256 tAmount, bool takeFee) private {
701 		(uint256 tTransferAmount,uint256 tFee, uint256 tOther) = _getTValues(tAmount, takeFee);
702 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rOther) = _getRValues(tAmount, tFee, tOther, _getRate());
703 
704 		if (_isExcludedFromDividends[sender]) {
705 			_tOwned[sender] = _tOwned[sender] - tAmount;
706 		}
707 		if (_isExcludedFromDividends[recipient]) {
708 			_tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
709 		}
710 		_rOwned[sender] = _rOwned[sender] - rAmount;
711 		_rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
712 		_takeContractFees(rOther, tOther);
713 		_reflectFee(rFee, tFee);
714 		emit Transfer(sender, recipient, tTransferAmount);
715 	}
716 	function _reflectFee(uint256 rFee, uint256 tFee) private {
717 		_rTotal -= rFee;
718 		_tFeeTotal += tFee;
719 	}
720 	function _getTValues(uint256 tAmount, bool takeFee) private view returns (uint256,uint256,uint256){
721 		if (!takeFee) {
722 			return (tAmount, 0, 0);
723 		}
724 		else {
725 			uint256 tFee = tAmount * _holdersFee / 100;
726 			uint256 tOther = tAmount * (_liquidityFee + _devFee + _marketingFee + _buyBackFee) / 100;
727 			uint256 tTransferAmount = tAmount - (tFee + tOther);
728 			return (tTransferAmount, tFee, tOther);
729 		}
730 	}
731 	function _getRValues(
732 		uint256 tAmount,
733 		uint256 tFee,
734 		uint256 tOther,
735 		uint256 currentRate
736 		) private pure returns ( uint256, uint256, uint256, uint256) {
737 		uint256 rAmount = tAmount * currentRate;
738 		uint256 rFee = tFee * currentRate;
739 		uint256 rOther = tOther * currentRate;
740 		uint256 rTransferAmount = rAmount - (rFee + rOther);
741 		return (rAmount, rTransferAmount, rFee, rOther);
742 	}
743 	function _getRate() private view returns (uint256) {
744 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
745 		return rSupply.div(tSupply);
746 	}
747 	function _getCurrentSupply() private view returns (uint256, uint256) {
748 		uint256 rSupply = _rTotal;
749 		uint256 tSupply = _tTotal;
750 		for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
751 			if (
752 				_rOwned[_excludedFromDividends[i]] > rSupply ||
753 				_tOwned[_excludedFromDividends[i]] > tSupply
754 			) return (_rTotal, _tTotal);
755 			rSupply = rSupply - _rOwned[_excludedFromDividends[i]];
756 			tSupply = tSupply - _tOwned[_excludedFromDividends[i]];
757 		}
758 		if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
759 		return (rSupply, tSupply);
760 	}
761 	function _takeContractFees(uint256 rOther, uint256 tOther) private {
762 		if (_isExcludedFromDividends[address(this)]) {
763 			_tOwned[address(this)] += tOther;
764 		}
765 		_rOwned[address(this)] += rOther;
766 	}
767 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp) private {
768 		_liquidityFee = 0;
769 		_devFee = 0;
770 		_marketingFee = 0;
771 		_buyBackFee = 0;
772 		_holdersFee = 0;
773 
774 		if (isBuyFromLp) {
775             if ((block.number - _launchBlockNumber) <= 5) {
776 				_liquidityFee = 100;
777 			} else {
778                 _liquidityFee = _base.liquidityFeeOnBuy;
779                 _devFee = _base.devFeeOnBuy;
780                 _marketingFee = _base.marketingFeeOnBuy;
781                 _buyBackFee = _base.buyBackFeeOnBuy;
782                 _holdersFee = _base.holdersFeeOnBuy;
783             }
784 		}
785 		if (isSelltoLp) {
786             _liquidityFee = _base.liquidityFeeOnSell;
787 			_devFee = _base.devFeeOnSell;
788 			_marketingFee = _base.marketingFeeOnSell;
789 			_buyBackFee = _base.buyBackFeeOnSell;
790 			_holdersFee = _base.holdersFeeOnSell;
791 
792             if (block.timestamp - _launchTimestamp <= 259200) {
793                 _liquidityFee = 2;
794                 _devFee = 3;
795                 _marketingFee = 10;
796                 _buyBackFee = 8;
797                 _holdersFee = 2;
798             }
799 		}
800 		_totalFee = _liquidityFee + _marketingFee + _devFee + _buyBackFee + _holdersFee;
801 		emit FeesApplied(_liquidityFee, _marketingFee, _devFee, _buyBackFee, _holdersFee, _totalFee);
802 	}
803 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
804 		uint8 _liquidityFeeOnSell,
805 		uint8 _marketingFeeOnSell,
806         uint8 _devFeeOnSell,
807 		uint8 _buyBackFeeOnSell,
808 		uint8 _holdersFeeOnSell
809 	) private {
810 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
811 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
812 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
813 		}
814 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
815 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, 'marketingFeeOnSell', map.periodName);
816 			map.marketingFeeOnSell = _marketingFeeOnSell;
817 		}
818         if (map.devFeeOnSell != _devFeeOnSell) {
819 			emit CustomTaxPeriodChange(_devFeeOnSell, map.devFeeOnSell, 'devFeeOnSell', map.periodName);
820 			map.devFeeOnSell = _devFeeOnSell;
821 		}
822 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
823 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
824 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
825 		}
826 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
827 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
828 			map.holdersFeeOnSell = _holdersFeeOnSell;
829 		}
830 	}
831 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
832 		uint8 _liquidityFeeOnBuy,
833 		uint8 _marketingFeeOnBuy,
834         uint8 _devFeeOnBuy,
835 		uint8 _buyBackFeeOnBuy,
836 		uint8 _holdersFeeOnBuy
837 	) private {
838 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
839 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
840 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
841 		}
842 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
843 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, 'marketingFeeOnBuy', map.periodName);
844 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
845 		}
846         if (map.devFeeOnBuy != _devFeeOnBuy) {
847 			emit CustomTaxPeriodChange(_devFeeOnBuy, map.devFeeOnBuy, 'devFeeOnBuy', map.periodName);
848 			map.devFeeOnBuy = _devFeeOnBuy;
849 		}
850 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
851 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
852 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
853 		}
854 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
855 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
856 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
857 		}
858 	}
859 	function _swapAndLiquify() private {
860 		uint256 contractBalance = balanceOf(address(this));
861 		uint256 initialETHBalance = address(this).balance;
862 
863 		uint8 totalFeePrior = _totalFee;
864         uint8 liquidityFeePrior = _liquidityFee;
865         uint8 marketingFeePrior = _marketingFee;
866         uint8 devFeePrior = _devFee;
867         uint8 buyBackFeePrior  = _buyBackFee;
868 		uint8 holdersFeePrior = _holdersFee;
869 
870 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
871 		uint256 amountToSwapForETH = contractBalance - amountToLiquify;
872 
873 		_swapTokensForETH(amountToSwapForETH);
874 
875 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
876 		uint256 totalETHFee = totalFeePrior - (liquidityFeePrior / 2) - (holdersFeePrior);
877 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * liquidityFeePrior / totalETHFee / 2;
878 		uint256 amountETHDev = ETHBalanceAfterSwap * devFeePrior / totalETHFee;
879 		uint256 amountETHBuyBack = ETHBalanceAfterSwap * buyBackFeePrior / totalETHFee;
880 		uint256 amountETHMarketing = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHDev + amountETHBuyBack);
881 
882 		payable(marketingWallet).transfer(amountETHMarketing);
883 		payable(devWallet).transfer(amountETHDev);
884 		payable(buyBackWallet).transfer(amountETHBuyBack);
885 
886 		if (amountToLiquify > 0) {
887 			_addLiquidity(amountToLiquify, amountETHLiquidity);
888 			emit SwapAndLiquify(amountToSwapForETH, amountETHLiquidity, amountToLiquify);
889 		}
890 		_totalFee = totalFeePrior;
891         _liquidityFee = liquidityFeePrior;
892         _marketingFee = marketingFeePrior;
893         _devFee = devFeePrior;
894         _buyBackFee = buyBackFeePrior;
895 		_holdersFee = holdersFeePrior;
896 	}
897 	function _swapTokensForETH(uint256 tokenAmount) private {
898 		address[] memory path = new address[](2);
899 		path[0] = address(this);
900 		path[1] = uniswapV2Router.WETH();
901 		_approve(address(this), address(uniswapV2Router), tokenAmount);
902 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
903 		tokenAmount,
904 		0, // accept any amount of ETH
905 		path,
906 		address(this),
907 		block.timestamp
908 		);
909 	}
910 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
911 		_approve(address(this), address(uniswapV2Router), tokenAmount);
912 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
913 		address(this),
914 		tokenAmount,
915 		0, // slippage is unavoidable
916 		0, // slippage is unavoidable
917 		liquidityWallet,
918 		block.timestamp
919 		);
920     }
921 }