1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 interface IERC20 {
5 	function totalSupply() external view returns (uint256);
6 
7 	function balanceOf(address account) external view returns (uint256);
8 
9 	function transfer(address recipient, uint256 amount)
10 	external
11 	returns (bool);
12 
13 	function allowance(address owner, address spender)
14 	external
15 	view
16 	returns (uint256);
17 
18 	function approve(address spender, uint256 amount) external returns (bool);
19 
20 	function transferFrom(
21 		address sender,
22 		address recipient,
23 		uint256 amount
24 	) external returns (bool);
25 
26 	event Transfer(address indexed from, address indexed to, uint256 value);
27 
28 	event Approval(
29 		address indexed owner,
30 		address indexed spender,
31 		uint256 value
32 	);
33 }
34 
35 interface IFactory {
36     function createPair(address tokenA, address tokenB)
37         external
38         returns (address pair);
39 
40     function getPair(address tokenA, address tokenB)
41         external
42         view
43         returns (address pair);
44 }
45 
46 interface IRouter {
47 	function factory() external pure returns (address);
48 
49 	function WETH() external pure returns (address);
50 
51 	function addLiquidityETH(
52 		address token,
53 		uint256 amountTokenDesired,
54 		uint256 amountTokenMin,
55 		uint256 amountETHMin,
56 		address to,
57 		uint256 deadline
58 	)
59 	external
60 	payable
61 	returns (
62 		uint256 amountToken,
63 		uint256 amountETH,
64 		uint256 liquidity
65 	);
66 
67 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
68 		uint256 amountOutMin,
69 		address[] calldata path,
70 		address to,
71 		uint256 deadline
72 	) external payable;
73 
74 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
75 		uint256 amountIn,
76 		uint256 amountOutMin,
77 		address[] calldata path,
78 		address to,
79 		uint256 deadline
80 	) external;
81 }
82 
83 library SafeMath {
84 
85 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
86 		uint256 c = a + b;
87 		require(c >= a, "SafeMath: addition overflow");
88 
89 		return c;
90 	}
91 
92 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93 		return sub(a, b, "SafeMath: subtraction overflow");
94 	}
95 
96 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97 		require(b <= a, errorMessage);
98 		uint256 c = a - b;
99 
100 		return c;
101 	}
102 
103 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105 		// benefit is lost if 'b' is also tested.
106 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107 		if (a == 0) {
108 			return 0;
109 		}
110 
111 		uint256 c = a * b;
112 		require(c / a == b, "SafeMath: multiplication overflow");
113 
114 		return c;
115 	}
116 
117 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
118 		return div(a, b, "SafeMath: division by zero");
119 	}
120 
121 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122 		require(b > 0, errorMessage);
123 		uint256 c = a / b;
124 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126 		return c;
127 	}
128 
129 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130 		return mod(a, b, "SafeMath: modulo by zero");
131 	}
132 
133 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134 		require(b != 0, errorMessage);
135 		return a % b;
136 	}
137 }
138 
139 library Address {
140 	function isContract(address account) internal view returns (bool) {
141 		uint256 size;
142 		assembly {
143 			size := extcodesize(account)
144 		}
145 		return size > 0;
146 	}
147 
148 	function sendValue(address payable recipient, uint256 amount) internal {
149 		require(
150 			address(this).balance >= amount,
151 			"Address: insufficient balance"
152 		);
153 
154 		(bool success, ) = recipient.call{value: amount}("");
155 		require(
156 			success,
157 			"Address: unable to send value, recipient may have reverted"
158 		);
159 	}
160 
161 	function functionCall(address target, bytes memory data)
162 	internal
163 	returns (bytes memory)
164 	{
165 		return functionCall(target, data, "Address: low-level call failed");
166 	}
167 
168 	function functionCall(
169 		address target,
170 		bytes memory data,
171 		string memory errorMessage
172 	) internal returns (bytes memory) {
173 		return functionCallWithValue(target, data, 0, errorMessage);
174 	}
175 
176 	function functionCallWithValue(
177 		address target,
178 		bytes memory data,
179 		uint256 value
180 	) internal returns (bytes memory) {
181 		return
182 		functionCallWithValue(
183 			target,
184 			data,
185 			value,
186 			"Address: low-level call with value failed"
187 		);
188 	}
189 
190 	function functionCallWithValue(
191 		address target,
192 		bytes memory data,
193 		uint256 value,
194 		string memory errorMessage
195 	) internal returns (bytes memory) {
196 		require(
197 			address(this).balance >= value,
198 			"Address: insufficient balance for call"
199 		);
200 		require(isContract(target), "Address: call to non-contract");
201 
202 		(bool success, bytes memory returndata) = target.call{value: value}(
203 		data
204 		);
205 		return _verifyCallResult(success, returndata, errorMessage);
206 	}
207 
208 	function functionStaticCall(address target, bytes memory data)
209 	internal
210 	view
211 	returns (bytes memory)
212 	{
213 		return
214 		functionStaticCall(
215 			target,
216 			data,
217 			"Address: low-level static call failed"
218 		);
219 	}
220 
221 	function functionStaticCall(
222 		address target,
223 		bytes memory data,
224 		string memory errorMessage
225 	) internal view returns (bytes memory) {
226 		require(isContract(target), "Address: static call to non-contract");
227 
228 		(bool success, bytes memory returndata) = target.staticcall(data);
229 		return _verifyCallResult(success, returndata, errorMessage);
230 	}
231 
232 	function functionDelegateCall(address target, bytes memory data)
233 	internal
234 	returns (bytes memory)
235 	{
236 		return
237 		functionDelegateCall(
238 			target,
239 			data,
240 			"Address: low-level delegate call failed"
241 		);
242 	}
243 
244 	function functionDelegateCall(
245 		address target,
246 		bytes memory data,
247 		string memory errorMessage
248 	) internal returns (bytes memory) {
249 		require(isContract(target), "Address: delegate call to non-contract");
250 
251 		(bool success, bytes memory returndata) = target.delegatecall(data);
252 		return _verifyCallResult(success, returndata, errorMessage);
253 	}
254 
255 	function _verifyCallResult(
256 		bool success,
257 		bytes memory returndata,
258 		string memory errorMessage
259 	) private pure returns (bytes memory) {
260 		if (success) {
261 			return returndata;
262 		} else {
263 			if (returndata.length > 0) {
264 				assembly {
265 					let returndata_size := mload(returndata)
266 					revert(add(32, returndata), returndata_size)
267 				}
268 			} else {
269 				revert(errorMessage);
270 			}
271 		}
272 	}
273 }
274 
275 abstract contract Context {
276 		function _msgSender() internal view virtual returns (address) {
277 		return msg.sender;
278 	}
279 
280 	function _msgData() internal view virtual returns (bytes calldata) {
281 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
282 		return msg.data;
283 	}
284 }
285 
286 contract Ownable is Context {
287 	address private _owner;
288 
289 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291 	constructor () public {
292 		address msgSender = _msgSender();
293 		_owner = msgSender;
294 		emit OwnershipTransferred(address(0), msgSender);
295 	}
296 
297 	function owner() public view returns (address) {
298 		return _owner;
299 	}
300 
301 	modifier onlyOwner() {
302 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
303 		_;
304 	}
305 
306 	function renounceOwnership() public virtual onlyOwner {
307 		emit OwnershipTransferred(_owner, address(0));
308 		_owner = address(0);
309 	}
310 
311 	function transferOwnership(address newOwner) public virtual onlyOwner {
312 		require(newOwner != address(0), "Ownable: new owner is the zero address");
313 		emit OwnershipTransferred(_owner, newOwner);
314 		_owner = newOwner;
315 	}
316 }
317 
318 contract RedKnightToken is IERC20, Ownable {
319 	using Address for address;
320 	using SafeMath for uint256;
321 
322 	IRouter public uniswapV2Router;
323 	address public immutable uniswapV2Pair;
324 
325 	string private constant _name =  "Red Knight Token";
326 	string private constant _symbol = "RKT";
327 	uint8 private constant _decimals = 18;
328 
329 	mapping (address => uint256) private _rOwned;
330 	mapping (address => uint256) private _tOwned;
331 	mapping (address => mapping (address => uint256)) private _allowances;
332 
333 	uint256 private constant MAX = ~uint256(0);
334 	uint256 private constant _tTotal = 999000000000000 * 10**18;
335 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
336 	uint256 private _tFeeTotal;
337 
338 	bool public isTradingEnabled;
339     uint256 private _tradingPausedTimestamp;
340 
341 	// max wallet is 2.0% of initialSupply
342 	uint256 public maxWalletAmount = _tTotal * 200 / 10000;
343 
344     // max tx is 0.53% of initialSupply
345 	uint256 public maxTxAmount = _tTotal * 530 / 100000;
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
356 	address public devWallet;
357 	address public buyBackWallet;
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
375 	// Launch taxes
376 	bool private _isLaunched;
377 	uint256 private _launchStartTimestamp;
378 	uint256 private _launchBlockNumber;
379 	CustomTaxPeriod private _launch1 = CustomTaxPeriod('launch1',5,0,100,1,0,4,0,2,0,3,0,2);
380 	CustomTaxPeriod private _launch2 = CustomTaxPeriod('launch2',0,3600,1,2,4,10,2,3,3,10,2,5);
381 	CustomTaxPeriod private _launch3 = CustomTaxPeriod('launch3',0,86400,1,2,4,8,2,3,3,10,2,4);
382 
383 	// Base taxes
384 	CustomTaxPeriod private _default = CustomTaxPeriod('default',0,0,1,1,4,4,2,2,3,3,2,2);
385 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,1,1,4,4,2,2,3,3,2,2);
386 
387     uint256 private constant _blockedTimeLimit = 172800;
388 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
389 	mapping (address => bool) private _isExcludedFromFee;
390 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
391 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
392     mapping (address => bool) private _isExcludedFromDividends;
393 	mapping (address => bool) private _isBlocked;
394 	mapping (address => bool) public automatedMarketMakerPairs;
395     address[] private _excludedFromDividends;
396 
397 	uint8 private _liquidityFee;
398 	uint8 private _devFee;
399 	uint8 private _marketingFee;
400 	uint8 private _buyBackFee;
401 	uint8 private _holdersFee;
402 	uint8 private _totalFee;
403 
404 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
405 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
406 	event WalletChange(string indexed indentifier, address indexed newWallet, address indexed oldWallet);
407 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 devFee, uint8 buyBackFee, uint8 holdersFee);
408 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
409 	event BlockedAccountChange(address indexed holder, bool indexed status);
410 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
411 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
412 	event ExcludeFromFeesChange(address indexed account, bool isExcluded);
413 	event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
414 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
415     event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
416 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
417 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
418 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
419 	event ClaimETHOverflow(uint256 amount);
420 	event FeesApplied(uint8 liquidityFee, uint8 marketingFee, uint8 devFee, uint8 buyBackFee, uint8 holdersFee, uint8 totalFee);
421 
422 	constructor() {
423 		liquidityWallet = owner();
424 		marketingWallet = owner();
425         devWallet = owner();
426 		buyBackWallet = owner();
427 
428 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
429 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
430 			address(this),
431 			_uniswapV2Router.WETH()
432 		);
433         uniswapV2Router = _uniswapV2Router;
434 		uniswapV2Pair = _uniswapV2Pair;
435 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
436 
437         _isExcludedFromFee[owner()] = true;
438 		_isExcludedFromFee[address(this)] = true;
439 
440         excludeFromDividends(address(this), true);
441 		excludeFromDividends(address(dead), true);
442 		excludeFromDividends(address(_uniswapV2Router), true);
443 
444 		_isAllowedToTradeWhenDisabled[owner()] = true;
445 
446 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
447 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
448 		_isExcludedFromMaxWalletLimit[address(this)] = true;
449 		_isExcludedFromMaxWalletLimit[owner()] = true;
450 
451         _isExcludedFromMaxTransactionLimit[address(this)] = true;
452 		_isExcludedFromMaxTransactionLimit[address(dead)] = true;
453 		_isExcludedFromMaxTransactionLimit[owner()] = true;
454 
455 		_rOwned[owner()] = _rTotal;
456 		emit Transfer(address(0), owner(), _tTotal);
457 	}
458 
459 	receive() external payable {}
460 
461 	// Setters
462 	function transfer(address recipient, uint256 amount) external override returns (bool) {
463 		_transfer(_msgSender(), recipient, amount);
464 		return true;
465 	}
466 	function approve(address spender, uint256 amount) public override returns (bool) {
467 		_approve(_msgSender(), spender, amount);
468 		return true;
469 	}
470 	function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
471 		_transfer(sender, recipient, amount);
472 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
473 		return true;
474 	}
475 	function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
476 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].add(addedValue));
477 		return true;
478 	}
479 	function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
480 		_approve(_msgSender(),spender,_allowances[_msgSender()][spender].sub(subtractedValue,"ERC20: decreased allowance below zero"));
481 		return true;
482 	}
483 	function _approve(address owner,address spender,uint256 amount) private {
484 		require(owner != address(0), "ERC20: approve from the zero address");
485 		require(spender != address(0), "ERC20: approve to the zero address");
486 		_allowances[owner][spender] = amount;
487 		emit Approval(owner, spender, amount);
488 	}
489 	function _getNow() private view returns (uint256) {
490 		return block.timestamp;
491 	}
492 	function launch() external onlyOwner {
493 		_launchStartTimestamp = _getNow();
494 		_launchBlockNumber = block.number;
495 		isTradingEnabled = true;
496 		_isLaunched = true;
497 	}
498 	function cancelLaunch() external onlyOwner {
499 		require(this.isInLaunch(), "RedKnightToken: Launch is not set");
500 		_launchStartTimestamp = 0;
501 		_launchBlockNumber = 0;
502 		_isLaunched = false;
503 	}
504 	function activateTrading() external onlyOwner {
505 		isTradingEnabled = true;
506 	}
507 	function deactivateTrading() external onlyOwner {
508 		isTradingEnabled = false;
509 		_tradingPausedTimestamp = _getNow();
510 	}
511     function _setAutomatedMarketMakerPair(address pair, bool value) private {
512 		require(automatedMarketMakerPairs[pair] != value, "RedKnightToken: Automated market maker pair is already set to that value");
513 		automatedMarketMakerPairs[pair] = value;
514 		emit AutomatedMarketMakerPairChange(pair, value);
515 	}
516 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
517 		_isAllowedToTradeWhenDisabled[account] = allowed;
518 		emit AllowedWhenTradingDisabledChange(account, allowed);
519 	}
520 	function excludeFromFees(address account, bool excluded) external onlyOwner {
521 		require(_isExcludedFromFee[account] != excluded, "RedKnightToken: Account is already the value of 'excluded'");
522 		_isExcludedFromFee[account] = excluded;
523 		emit ExcludeFromFeesChange(account, excluded);
524 	}
525     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
526 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "RedKnightToken: Account is already the value of 'excluded'");
527 		_isExcludedFromMaxWalletLimit[account] = excluded;
528 		emit ExcludeFromMaxWalletChange(account, excluded);
529 	}
530 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
531 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "RedKnightToken: Account is already the value of 'excluded'");
532 		_isExcludedFromMaxTransactionLimit[account] = excluded;
533 		emit ExcludeFromMaxTransferChange(account, excluded);
534 	}
535     function blockAccount(address account) external onlyOwner {
536 		uint256 currentTimestamp = _getNow();
537 		require(!_isBlocked[account], "RedKnightToken: Account is already blocked");
538 		if (_isLaunched) {
539 			require((currentTimestamp - _launchStartTimestamp) < _blockedTimeLimit, "RedKnightToken: Time to block accounts has expired");
540 		}
541 		_isBlocked[account] = true;
542 		emit BlockedAccountChange(account, true);
543 	}
544 	function unblockAccount(address account) external onlyOwner {
545 		require(_isBlocked[account], "RedKnightToken: Account is not blcoked");
546 		_isBlocked[account] = false;
547 		emit BlockedAccountChange(account, false);
548 	}
549 	function setWallets(address newLiquidityWallet, address newDevWallet, address newMarketingWallet, address newBuyBackWallett) external onlyOwner {
550 		if(liquidityWallet != newLiquidityWallet) {
551             require(newLiquidityWallet != address(0), "RedKnightToken: The liquidityWallet cannot be 0");
552 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
553 			liquidityWallet = newLiquidityWallet;
554 		}
555 		if(devWallet != newDevWallet) {
556             require(newDevWallet != address(0), "RedKnightToken: The devWallet cannot be 0");
557 			emit WalletChange('devWallet', newDevWallet, devWallet);
558 			devWallet = newDevWallet;
559 		}
560 		if(marketingWallet != newMarketingWallet) {
561             require(newMarketingWallet != address(0), "RedKnightToken: The marketingWallet cannot be 0");
562 			emit WalletChange('marketingWallet', newMarketingWallet, marketingWallet);
563 			marketingWallet = newMarketingWallet;
564 		}
565 		if(buyBackWallet != newBuyBackWallett) {
566             require(newBuyBackWallett != address(0), "RedKnightToken: The buyBackWallet cannot be 0");
567 			emit WalletChange('buyBackWallet', newBuyBackWallett, buyBackWallet);
568 			buyBackWallet = newBuyBackWallett;
569 		}
570 	}
571     // Base fees
572 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy,  uint8 _marketingFeeOnBuy, uint8 _devFeeOnBuy,  uint8 _buyBackFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
573 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
574 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
575 	}
576 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _marketingFeeOnSell, uint8 _devFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
577 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
578 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
579 	}
580     //Launch2 Fees
581 	function setLaunch2FeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _devFeeOnBuy,  uint8 _buyBackFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
582 		_setCustomBuyTaxPeriod(_launch2, _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
583 		emit FeeChange('launch2Fees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
584 	}
585 	function setLaunch2FeesOnSell(uint8 _liquidityFeeOnSell, uint8 _marketingFeeOnSell, uint8 _devFeeOnSell, uint8 _buyBackFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
586 		_setCustomSellTaxPeriod(_launch2, _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
587 		emit FeeChange('launch2Fees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
588 	}
589 	//Launch3 Fees
590 	function setLaunch3FeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _devFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
591 		_setCustomBuyTaxPeriod(_launch3, _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
592 		emit FeeChange('launch3Fees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _devFeeOnBuy, _buyBackFeeOnBuy, _holdersFeeOnBuy);
593 	}
594 	function setLaunch3FeesOnSell(uint8 _liquidityFeeOnSell, uint8 _marketingFeeOnSell, uint8 _devFeeOnSell, uint8 _buyBackFeeOnSell,  uint8 _holdersFeeOnSell) external onlyOwner {
595 		_setCustomSellTaxPeriod(_launch3, _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
596 		emit FeeChange('launch3Fees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _devFeeOnSell, _buyBackFeeOnSell, _holdersFeeOnSell);
597 	}
598 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
599 		require(newValue != maxWalletAmount, "RedKnightToken: Cannot update maxWalletAmount to same value");
600 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
601 		maxWalletAmount = newValue;
602 	}
603 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
604 		require(newValue != maxTxAmount, "RedKnightToken: Cannot update maxTxAmount to same value");
605         emit MaxTransactionAmountChange(newValue, maxTxAmount);
606         maxTxAmount = newValue;
607 	}
608 	function excludeFromDividends(address account, bool excluded) public onlyOwner {
609 		require(_isExcludedFromDividends[account] != excluded, "RedKnightToken: Account is already the value of 'excluded'");
610 		if(excluded) {
611 			if(_rOwned[account] > 0) {
612 				_tOwned[account] = tokenFromReflection(_rOwned[account]);
613 			}
614 			_isExcludedFromDividends[account] = excluded;
615 			_excludedFromDividends.push(account);
616 		} else {
617 			for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
618 				if (_excludedFromDividends[i] == account) {
619 					_excludedFromDividends[i] = _excludedFromDividends[_excludedFromDividends.length - 1];
620 					_tOwned[account] = 0;
621 					_isExcludedFromDividends[account] = false;
622 					_excludedFromDividends.pop();
623 					break;
624 				}
625 			}
626 		}
627 		emit ExcludeFromDividendsChange(account, excluded);
628 	}
629 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
630 		require(newValue != minimumTokensBeforeSwap, "RedKnightToken: Cannot update minimumTokensBeforeSwap to same value");
631 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
632 		minimumTokensBeforeSwap = newValue;
633 	}
634 	function claimETHOverflow() external onlyOwner {
635 		require(address(this).balance > 0, "RedKnightToken: Cannot send more than contract balance");
636         uint256 amount = address(this).balance;
637 		(bool success,) = address(owner()).call{value : amount}("");
638 		if (success){
639 			emit ClaimETHOverflow(amount);
640 		}
641 	}
642 
643 	// Getters
644 	function name() external view returns (string memory) {
645 		return _name;
646 	}
647 	function symbol() external view returns (string memory) {
648 		return _symbol;
649 	}
650 	function decimals() external view virtual returns (uint8) {
651 		return _decimals;
652 	}
653 	function totalSupply() external view override returns (uint256) {
654 		return _tTotal;
655 	}
656 	function balanceOf(address account) public view override returns (uint256) {
657 		if (_isExcludedFromDividends[account]) return _tOwned[account];
658 		return tokenFromReflection(_rOwned[account]);
659 	}
660 	function totalFees() external view returns (uint256) {
661 		return _tFeeTotal;
662 	}
663 	function allowance(address owner, address spender) external view override returns (uint256) {
664 		return _allowances[owner][spender];
665 	}
666 	function isInLaunch() external view returns (bool) {
667 		uint256 currentTimestamp = !isTradingEnabled && _tradingPausedTimestamp > _launchStartTimestamp  ? _tradingPausedTimestamp : _getNow();
668 		uint256 totalLaunchTime =  _launch1.timeInPeriod + _launch2.timeInPeriod + _launch3.timeInPeriod;
669 		if(_isLaunched && ((currentTimestamp - _launchStartTimestamp) < totalLaunchTime || (block.number - _launchBlockNumber) < _launch1.blocksInPeriod )) {
670 			return true;
671 		} else {
672 			return false;
673 		}
674 	}
675     function getBaseBuyFees() external view returns (uint256, uint256, uint256, uint256, uint256){
676 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.devFeeOnBuy, _base.buyBackFeeOnBuy, _base.holdersFeeOnBuy);
677 	}
678 	function getBaseSellFees() external view returns (uint256, uint256, uint256, uint256, uint256){
679 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.devFeeOnSell, _base.buyBackFeeOnSell, _base.holdersFeeOnSell);
680 	}
681 	function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
682 		require(rAmount <= _rTotal, "RedKnightToken: Amount must be less than total reflections");
683 		uint256 currentRate =  _getRate();
684 		return rAmount / currentRate;
685 	}
686 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
687 		require(tAmount <= _tTotal, "RedKnightToken: Amount must be less than supply");
688 		uint256 currentRate = _getRate();
689 		uint256 rAmount  = tAmount * currentRate;
690 		if (!deductTransferFee) {
691 			return rAmount;
692 		}
693 		else {
694 			uint256 rTotalFee  = tAmount * _totalFee / 100 * currentRate;
695 			uint256 rTransferAmount = rAmount - rTotalFee;
696 			return rTransferAmount;
697 		}
698 	}
699 
700 	// Main
701 	function _transfer(
702 	address from,
703 	address to,
704 	uint256 amount
705 	) internal {
706 		require(from != address(0), "ERC20: transfer from the zero address");
707 		require(to != address(0), "ERC20: transfer to the zero address");
708 		require(amount > 0, "Transfer amount must be greater than zero");
709 		require(amount <= balanceOf(from), "RedKnightToken: Cannot transfer more than balance");
710 
711 		bool isBuyFromLp = automatedMarketMakerPairs[from];
712 		bool isSelltoLp = automatedMarketMakerPairs[to];
713         bool _isInLaunch = this.isInLaunch();
714 
715 		if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
716 			require(isTradingEnabled, "RedKnightToken: Trading is currently disabled.");
717 			require(!_isBlocked[to], "RedKnightToken: Account is blocked");
718 			require(!_isBlocked[from], "RedKnightToken: Account is blocked");
719             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
720                 require(amount <= maxTxAmount, "RedKnightToken: Transfer amount exceeds the maxTxAmount.");
721             }
722 			if (!_isExcludedFromMaxWalletLimit[to]) {
723 				require((balanceOf(to) + amount) <= maxWalletAmount, "RedKnightToken: Expected wallet amount exceeds the maxWalletAmount.");
724 			}
725 		}
726 
727 		_adjustTaxes(isBuyFromLp, isSelltoLp, _isInLaunch);
728 		bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
729 
730 		if (
731 			isTradingEnabled &&
732 			canSwap &&
733 			!_swapping &&
734 			_totalFee > 0 &&
735 			automatedMarketMakerPairs[to] &&
736 			from != liquidityWallet && to != liquidityWallet &&
737 			from != devWallet && to != devWallet &&
738 			from != marketingWallet && to != marketingWallet &&
739 			from != buyBackWallet && to != buyBackWallet
740 		) {
741 			_swapping = true;
742 			_swapAndLiquify();
743 			_swapping = false;
744 		}
745 
746 		bool takeFee = !_swapping && isTradingEnabled;
747 
748 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
749 			takeFee = false;
750 		}
751 		_tokenTransfer(from, to, amount, takeFee);
752 	}
753 	function _tokenTransfer(address sender,address recipient, uint256 tAmount, bool takeFee) private {
754 		(uint256 tTransferAmount,uint256 tFee, uint256 tOther) = _getTValues(tAmount, takeFee);
755 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rOther) = _getRValues(tAmount, tFee, tOther, _getRate());
756 
757 		if (_isExcludedFromDividends[sender]) {
758 			_tOwned[sender] = _tOwned[sender] - tAmount;
759 		}
760 		if (_isExcludedFromDividends[recipient]) {
761 			_tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
762 		}
763 		_rOwned[sender] = _rOwned[sender] - rAmount;
764 		_rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
765 		_takeContractFees(rOther, tOther);
766 		_reflectFee(rFee, tFee);
767 		emit Transfer(sender, recipient, tTransferAmount);
768 	}
769 	function _reflectFee(uint256 rFee, uint256 tFee) private {
770 		_rTotal -= rFee;
771 		_tFeeTotal += tFee;
772 	}
773 	function _getTValues(uint256 tAmount, bool takeFee) private view returns (uint256,uint256,uint256){
774 		if (!takeFee) {
775 			return (tAmount, 0, 0);
776 		}
777 		else {
778 			uint256 tFee = tAmount * _holdersFee / 100;
779 			uint256 tOther = tAmount * (_liquidityFee + _devFee + _marketingFee + _buyBackFee) / 100;
780 			uint256 tTransferAmount = tAmount - (tFee + tOther);
781 			return (tTransferAmount, tFee, tOther);
782 		}
783 	}
784 	function _getRValues(
785 		uint256 tAmount,
786 		uint256 tFee,
787 		uint256 tOther,
788 		uint256 currentRate
789 		) private pure returns ( uint256, uint256, uint256, uint256) {
790 		uint256 rAmount = tAmount * currentRate;
791 		uint256 rFee = tFee * currentRate;
792 		uint256 rOther = tOther * currentRate;
793 		uint256 rTransferAmount = rAmount - (rFee + rOther);
794 		return (rAmount, rTransferAmount, rFee, rOther);
795 	}
796 	function _getRate() private view returns (uint256) {
797 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
798 		return rSupply.div(tSupply);
799 	}
800 	function _getCurrentSupply() private view returns (uint256, uint256) {
801 		uint256 rSupply = _rTotal;
802 		uint256 tSupply = _tTotal;
803 		for (uint256 i = 0; i < _excludedFromDividends.length; i++) {
804 			if (
805 				_rOwned[_excludedFromDividends[i]] > rSupply ||
806 				_tOwned[_excludedFromDividends[i]] > tSupply
807 			) return (_rTotal, _tTotal);
808 			rSupply = rSupply - _rOwned[_excludedFromDividends[i]];
809 			tSupply = tSupply - _tOwned[_excludedFromDividends[i]];
810 		}
811 		if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
812 		return (rSupply, tSupply);
813 	}
814 	function _takeContractFees(uint256 rOther, uint256 tOther) private {
815 		if (_isExcludedFromDividends[address(this)]) {
816 			_tOwned[address(this)] += tOther;
817 		}
818 		_rOwned[address(this)] += rOther;
819 	}
820 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, bool isLaunching) private {
821 		uint256 blocksSinceLaunch = block.number - _launchBlockNumber;
822 		uint256 currentTimestamp = !isTradingEnabled && _tradingPausedTimestamp > _launchStartTimestamp  ? _tradingPausedTimestamp : _getNow();
823 		uint256 timeSinceLaunch = currentTimestamp - _launchStartTimestamp;
824 
825 		_liquidityFee = 0;
826 		_devFee = 0;
827 		_marketingFee = 0;
828 		_buyBackFee = 0;
829 		_holdersFee = 0;
830 
831 		if (isBuyFromLp) {
832 			_liquidityFee = _base.liquidityFeeOnBuy;
833 			_devFee = _base.devFeeOnBuy;
834 			_marketingFee = _base.marketingFeeOnBuy;
835 			_buyBackFee = _base.buyBackFeeOnBuy;
836 			_holdersFee = _base.holdersFeeOnBuy;
837 
838 			if(isLaunching) {
839 				if (_isLaunched && blocksSinceLaunch < _launch1.blocksInPeriod) {
840 					_liquidityFee = _launch1.liquidityFeeOnBuy;
841 					_devFee = _launch1.devFeeOnBuy;
842 					_marketingFee = _launch1.marketingFeeOnBuy;
843 					_buyBackFee = _launch1.buyBackFeeOnBuy;
844 					_holdersFee = _launch1.holdersFeeOnBuy;
845 				}
846 				else if (_isLaunched && timeSinceLaunch <= _launch2.timeInPeriod && blocksSinceLaunch > _launch1.blocksInPeriod) {
847 					_liquidityFee = _launch2.liquidityFeeOnBuy;
848 					_devFee = _launch2.devFeeOnBuy;
849 					_marketingFee = _launch2.marketingFeeOnBuy;
850 					_buyBackFee = _launch2.buyBackFeeOnBuy;
851 					_holdersFee = _launch2.holdersFeeOnBuy;
852 				}
853 				else {
854 					_liquidityFee = _launch3.liquidityFeeOnBuy;
855 					_devFee = _launch3.devFeeOnBuy;
856 					_marketingFee = _launch3.marketingFeeOnBuy;
857 					_buyBackFee = _launch3.buyBackFeeOnBuy;
858 					_holdersFee = _launch3.holdersFeeOnBuy;
859 				}
860 			}
861 		}
862 		if (isSelltoLp) {
863 			_liquidityFee = _base.liquidityFeeOnSell;
864 			_devFee = _base.devFeeOnSell;
865 			_marketingFee = _base.marketingFeeOnSell;
866 			_buyBackFee = _base.buyBackFeeOnSell;
867 			_holdersFee = _base.holdersFeeOnSell;
868 
869 			if(isLaunching) {
870 				if (_isLaunched && blocksSinceLaunch < _launch1.blocksInPeriod) {
871 					_liquidityFee = _launch1.liquidityFeeOnSell;
872 					_devFee = _launch1.devFeeOnSell;
873 					_marketingFee = _launch1.marketingFeeOnSell;
874 					_buyBackFee = _launch1.buyBackFeeOnSell;
875 					_holdersFee = _launch1.holdersFeeOnSell;
876 				}
877 				else if (_isLaunched && timeSinceLaunch <= _launch2.timeInPeriod && blocksSinceLaunch > _launch1.blocksInPeriod) {
878 					_liquidityFee = _launch2.liquidityFeeOnSell;
879 					_devFee = _launch2.devFeeOnSell;
880 					_marketingFee = _launch2.marketingFeeOnSell;
881 					_buyBackFee = _launch2.buyBackFeeOnSell;
882 					_holdersFee = _launch2.holdersFeeOnSell;
883 				}
884 				else {
885 					_liquidityFee = _launch3.liquidityFeeOnSell;
886 					_devFee = _launch3.devFeeOnSell;
887 					_marketingFee = _launch3.marketingFeeOnSell;
888 					_buyBackFee = _launch3.buyBackFeeOnSell;
889 					_holdersFee = _launch3.holdersFeeOnSell;
890 				}
891 			}
892 		}
893 
894 		_totalFee = _liquidityFee + _marketingFee + _devFee + _buyBackFee + _holdersFee;
895 		emit FeesApplied(_liquidityFee, _marketingFee, _devFee, _buyBackFee, _holdersFee, _totalFee);
896 	}
897 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
898 		uint8 _liquidityFeeOnSell,
899 		uint8 _marketingFeeOnSell,
900         uint8 _devFeeOnSell,
901 		uint8 _buyBackFeeOnSell,
902 		uint8 _holdersFeeOnSell
903 	) private {
904 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
905 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
906 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
907 		}
908 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
909 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, 'marketingFeeOnSell', map.periodName);
910 			map.marketingFeeOnSell = _marketingFeeOnSell;
911 		}
912         if (map.devFeeOnSell != _devFeeOnSell) {
913 			emit CustomTaxPeriodChange(_devFeeOnSell, map.devFeeOnSell, 'devFeeOnSell', map.periodName);
914 			map.devFeeOnSell = _devFeeOnSell;
915 		}
916 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
917 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
918 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
919 		}
920 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
921 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
922 			map.holdersFeeOnSell = _holdersFeeOnSell;
923 		}
924 	}
925 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
926 		uint8 _liquidityFeeOnBuy,
927 		uint8 _marketingFeeOnBuy,
928         uint8 _devFeeOnBuy,
929 		uint8 _buyBackFeeOnBuy,
930 		uint8 _holdersFeeOnBuy
931 	) private {
932 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
933 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
934 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
935 		}
936 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
937 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, 'marketingFeeOnBuy', map.periodName);
938 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
939 		}
940         if (map.devFeeOnBuy != _devFeeOnBuy) {
941 			emit CustomTaxPeriodChange(_devFeeOnBuy, map.devFeeOnBuy, 'devFeeOnBuy', map.periodName);
942 			map.devFeeOnBuy = _devFeeOnBuy;
943 		}
944 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
945 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
946 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
947 		}
948 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
949 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
950 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
951 		}
952 	}
953 	function _swapAndLiquify() private {
954 		uint256 contractBalance = balanceOf(address(this));
955 		uint256 initialETHBalance = address(this).balance;
956 
957 		uint8 totalFeePrior = _totalFee;
958         uint8 liquidityFeePrior = _liquidityFee;
959         uint8 marketingFeePrior = _marketingFee;
960         uint8 devFeePrior = _devFee;
961         uint8 buyBackFeePrior  = _buyBackFee;
962 
963 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
964 		uint256 amountToSwapForETH = contractBalance - amountToLiquify;
965 
966 		_swapTokensForETH(amountToSwapForETH);
967 
968 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
969 		uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
970 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
971 		uint256 amountETHDev = ETHBalanceAfterSwap * _devFee / totalETHFee;
972 		uint256 amountETHBuyBack = ETHBalanceAfterSwap * _buyBackFee / totalETHFee;
973 		uint256 amountETHMarketing = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHDev + amountETHBuyBack);
974 
975 		payable(marketingWallet).transfer(amountETHMarketing);
976 		payable(devWallet).transfer(amountETHDev);
977         payable(buyBackWallet).transfer(amountETHBuyBack);
978 
979 		if (amountToLiquify > 0) {
980 			_addLiquidity(amountToLiquify, amountETHLiquidity);
981 			emit SwapAndLiquify(amountToSwapForETH, amountETHLiquidity, amountToLiquify);
982 		}
983 		_totalFee = totalFeePrior;
984         _liquidityFee = liquidityFeePrior;
985         _marketingFee = marketingFeePrior;
986         _devFee = devFeePrior;
987         _buyBackFee = buyBackFeePrior;
988 	}
989 	function _swapTokensForETH(uint256 tokenAmount) private {
990 		address[] memory path = new address[](2);
991 		path[0] = address(this);
992 		path[1] = uniswapV2Router.WETH();
993 		_approve(address(this), address(uniswapV2Router), tokenAmount);
994 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
995 		tokenAmount,
996 		0, // accept any amount of ETH
997 		path,
998 		address(this),
999 		block.timestamp
1000 		);
1001 	}
1002 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1003 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1004 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
1005 		address(this),
1006 		tokenAmount,
1007 		0, // slippage is unavoidable
1008 		0, // slippage is unavoidable
1009 		liquidityWallet,
1010 		block.timestamp
1011 		);
1012     }
1013 }