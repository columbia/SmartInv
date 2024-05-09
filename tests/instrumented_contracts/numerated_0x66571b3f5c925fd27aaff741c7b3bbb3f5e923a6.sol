1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
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
92 	function distributeDividends() external payable;
93 	function withdrawDividend() external;
94 	event DividendsDistributed(
95 		address indexed from,
96 		uint256 weiAmount
97 	);
98 	event DividendWithdrawn(
99 		address indexed to,
100 		uint256 weiAmount
101 	);
102 }
103 
104 interface DividendPayingTokenOptionalInterface {
105 	function withdrawableDividendOf(address _owner) external view returns(uint256);
106 	function withdrawnDividendOf(address _owner) external view returns(uint256);
107 	function accumulativeDividendOf(address _owner) external view returns(uint256);
108 }
109 
110 library Address {
111 
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize/address.code.length, which returns 0
114         // for contracts in construction, since the code is only stored at the end
115         // of the constructor execution.
116 
117         return account.code.length > 0;
118     }
119     function sendValue(address payable recipient, uint256 amount) internal {
120         require(address(this).balance >= amount, "Address: insufficient balance");
121 
122         (bool success, ) = recipient.call{value: amount}("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
126         return functionCall(target, data, "Address: low-level call failed");
127     }
128 
129     function functionCall(
130         address target,
131         bytes memory data,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135     }
136 
137     function functionCallWithValue(
138         address target,
139         bytes memory data,
140         uint256 value
141     ) internal returns (bytes memory) {
142         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
143     }
144 
145     function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         require(isContract(target), "Address: call to non-contract");
153 
154         (bool success, bytes memory returndata) = target.call{value: value}(data);
155         return verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
159         return functionStaticCall(target, data, "Address: low-level static call failed");
160     }
161 
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     function functionDelegateCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(isContract(target), "Address: delegate call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.delegatecall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     function verifyCallResult(
189         bool success,
190         bytes memory returndata,
191         string memory errorMessage
192     ) internal pure returns (bytes memory) {
193         if (success) {
194             return returndata;
195         } else {
196             // Look for revert reason and bubble it up if present
197             if (returndata.length > 0) {
198                 // The easiest way to bubble the revert reason is using memory via assembly
199 
200                 assembly {
201                     let returndata_size := mload(returndata)
202                     revert(add(32, returndata), returndata_size)
203                 }
204             } else {
205                 revert(errorMessage);
206             }
207         }
208     }
209 }
210 
211 library SafeMath {
212 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
213 		uint256 c = a + b;
214 		require(c >= a, "SafeMath: addition overflow");
215 
216 		return c;
217 	}
218 
219 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220 		return sub(a, b, "SafeMath: subtraction overflow");
221 	}
222 
223 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224 		require(b <= a, errorMessage);
225 		uint256 c = a - b;
226 
227 		return c;
228 	}
229 
230 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
231 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
232 		// benefit is lost if 'b' is also tested.
233 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
234 		if (a == 0) {
235 			return 0;
236 		}
237 
238 		uint256 c = a * b;
239 		require(c / a == b, "SafeMath: multiplication overflow");
240 
241 		return c;
242 	}
243 
244 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
245 		return div(a, b, "SafeMath: division by zero");
246 	}
247 
248 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249 		require(b > 0, errorMessage);
250 		uint256 c = a / b;
251 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
252 
253 		return c;
254 	}
255 
256 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257 		return mod(a, b, "SafeMath: modulo by zero");
258 	}
259 
260 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261 		require(b != 0, errorMessage);
262 		return a % b;
263 	}
264 }
265 
266 library SafeMathInt {
267 	int256 private constant MIN_INT256 = int256(1) << 255;
268 	int256 private constant MAX_INT256 = ~(int256(1) << 255);
269 
270 	function mul(int256 a, int256 b) internal pure returns (int256) {
271 		int256 c = a * b;
272 
273 		// Detect overflow when multiplying MIN_INT256 with -1
274 		require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
275 		require((b == 0) || (c / b == a));
276 		return c;
277 	}
278 	function div(int256 a, int256 b) internal pure returns (int256) {
279 		// Prevent overflow when dividing MIN_INT256 by -1
280 		require(b != -1 || a != MIN_INT256);
281 
282 		// Solidity already throws when dividing by 0.
283 		return a / b;
284 	}
285 	function sub(int256 a, int256 b) internal pure returns (int256) {
286 		int256 c = a - b;
287 		require((b >= 0 && c <= a) || (b < 0 && c > a));
288 		return c;
289 	}
290 	function add(int256 a, int256 b) internal pure returns (int256) {
291 		int256 c = a + b;
292 		require((b >= 0 && c >= a) || (b < 0 && c < a));
293 		return c;
294 	}
295 	function abs(int256 a) internal pure returns (int256) {
296 		require(a != MIN_INT256);
297 		return a < 0 ? -a : a;
298 	}
299 	function toUint256Safe(int256 a) internal pure returns (uint256) {
300 		require(a >= 0);
301 		return uint256(a);
302 	}
303 }
304 
305 library SafeMathUint {
306 	function toInt256Safe(uint256 a) internal pure returns (int256) {
307 		int256 b = int256(a);
308 		require(b >= 0);
309 		return b;
310 	}
311 }
312 
313 library IterableMapping {
314 	struct Map {
315 		address[] keys;
316 		mapping(address => uint) values;
317 		mapping(address => uint) indexOf;
318 		mapping(address => bool) inserted;
319 	}
320 
321 	function get(Map storage map, address key) public view returns (uint) {
322 		return map.values[key];
323 	}
324 
325 	function getIndexOfKey(Map storage map, address key) public view returns (int) {
326 		if(!map.inserted[key]) {
327 			return -1;
328 		}
329 		return int(map.indexOf[key]);
330 	}
331 
332 	function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
333 		return map.keys[index];
334 	}
335 
336 	function size(Map storage map) public view returns (uint) {
337 		return map.keys.length;
338 	}
339 
340 	function set(Map storage map, address key, uint val) public {
341 		if (map.inserted[key]) {
342 			map.values[key] = val;
343 		} else {
344 			map.inserted[key] = true;
345 			map.values[key] = val;
346 			map.indexOf[key] = map.keys.length;
347 			map.keys.push(key);
348 		}
349 	}
350 
351 	function remove(Map storage map, address key) public {
352 		if (!map.inserted[key]) {
353 			return;
354 		}
355 
356 		delete map.inserted[key];
357 		delete map.values[key];
358 
359 		uint index = map.indexOf[key];
360 		uint lastIndex = map.keys.length - 1;
361 		address lastKey = map.keys[lastIndex];
362 
363 		map.indexOf[lastKey] = index;
364 		delete map.indexOf[key];
365 
366 		map.keys[index] = lastKey;
367 		map.keys.pop();
368 	}
369 }
370 
371 abstract contract Context {
372 	function _msgSender() internal view virtual returns (address) {
373 		return msg.sender;
374 	}
375 
376 	function _msgData() internal view virtual returns (bytes calldata) {
377 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
378 		return msg.data;
379 	}
380 }
381 
382 contract Ownable is Context {
383 	address private _owner;
384 
385 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387 	constructor () {
388 		address msgSender = _msgSender();
389 		_owner = msgSender;
390 		emit OwnershipTransferred(address(0), msgSender);
391 	}
392 
393 	function owner() public view returns (address) {
394 		return _owner;
395 	}
396 
397 	modifier onlyOwner() {
398 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
399 		_;
400 	}
401 
402 	function renounceOwnership() public virtual onlyOwner {
403 		emit OwnershipTransferred(_owner, address(0));
404 		_owner = address(0);
405 	}
406 
407 	function transferOwnership(address newOwner) public virtual onlyOwner {
408 		require(newOwner != address(0), "Ownable: new owner is the zero address");
409 		emit OwnershipTransferred(_owner, newOwner);
410 		_owner = newOwner;
411 	}
412 }
413 
414 contract ERC20 is Context, IERC20, IERC20Metadata {
415 	using SafeMath for uint256;
416 
417 	mapping(address => uint256) private _balances;
418 	mapping(address => mapping(address => uint256)) private _allowances;
419 
420 	uint256 private _totalSupply;
421 	string private _name;
422 	string private _symbol;
423 
424 	constructor(string memory name_, string memory symbol_) {
425 		_name = name_;
426 		_symbol = symbol_;
427 	}
428 
429 	function name() public view virtual override returns (string memory) {
430 		return _name;
431 	}
432 
433 	function symbol() public view virtual override returns (string memory) {
434 		return _symbol;
435 	}
436 
437 	function decimals() public view virtual override returns (uint8) {
438 		return 18;
439 	}
440 
441 	function totalSupply() public view virtual override returns (uint256) {
442 		return _totalSupply;
443 	}
444 
445 	function balanceOf(address account) public view virtual override returns (uint256) {
446 		return _balances[account];
447 	}
448 
449 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
450 		_transfer(_msgSender(), recipient, amount);
451 		return true;
452 	}
453 
454 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
455 		return _allowances[owner][spender];
456 	}
457 
458 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
459 		_approve(_msgSender(), spender, amount);
460 		return true;
461 	}
462 
463 	function transferFrom(
464 		address sender,
465 		address recipient,
466 		uint256 amount
467 	) public virtual override returns (bool) {
468 		_transfer(sender, recipient, amount);
469 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
470 		return true;
471 	}
472 
473 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
474 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
475 		return true;
476 	}
477 
478 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
479 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
480 		return true;
481 	}
482 
483 	function _transfer(
484 		address sender,
485 		address recipient,
486 		uint256 amount
487 	) internal virtual {
488 		require(sender != address(0), "ERC20: transfer from the zero address");
489 		require(recipient != address(0), "ERC20: transfer to the zero address");
490 		_beforeTokenTransfer(sender, recipient, amount);
491 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
492 		_balances[recipient] = _balances[recipient].add(amount);
493 		emit Transfer(sender, recipient, amount);
494 	}
495 
496 	function _mint(address account, uint256 amount) internal virtual {
497 		require(account != address(0), "ERC20: mint to the zero address");
498 		_beforeTokenTransfer(address(0), account, amount);
499 		_totalSupply = _totalSupply.add(amount);
500 		_balances[account] = _balances[account].add(amount);
501 		emit Transfer(address(0), account, amount);
502 	}
503 
504 	function _burn(address account, uint256 amount) internal virtual {
505 		require(account != address(0), "ERC20: burn from the zero address");
506 		_beforeTokenTransfer(account, address(0), amount);
507 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
508 		_totalSupply = _totalSupply.sub(amount);
509 		emit Transfer(account, address(0), amount);
510 	}
511 
512 	function _approve(
513 		address owner,
514 		address spender,
515 		uint256 amount
516 	) internal virtual {
517 		require(owner != address(0), "ERC20: approve from the zero address");
518 		require(spender != address(0), "ERC20: approve to the zero address");
519 		_allowances[owner][spender] = amount;
520 		emit Approval(owner, spender, amount);
521 	}
522 
523 	function _beforeTokenTransfer(
524 		address from,
525 		address to,
526 		uint256 amount
527 	) internal virtual {}
528 }
529 
530 contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
531 	using SafeMath for uint256;
532 	using SafeMathUint for uint256;
533 	using SafeMathInt for int256;
534 
535 	uint256 constant internal magnitude = 2**128;
536 	uint256 internal magnifiedDividendPerShare;
537 	uint256 public totalDividendsDistributed;
538 
539 	mapping(address => int256) internal magnifiedDividendCorrections;
540 	mapping(address => uint256) internal withdrawnDividends;
541 
542 	constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
543 
544 	receive() external payable {
545 		distributeDividends();
546 	}
547 
548 	function distributeDividends() public override onlyOwner payable {
549 		require(totalSupply() > 0);
550 		if (msg.value > 0) {
551 			magnifiedDividendPerShare = magnifiedDividendPerShare.add((msg.value).mul(magnitude) / totalSupply());
552 			emit DividendsDistributed(msg.sender, msg.value);
553 			totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
554 		}
555 	}
556 	function withdrawDividend() public virtual override {
557 		_withdrawDividendOfUser(payable(msg.sender));
558 	}
559 	function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
560 		uint256 _withdrawableDividend = withdrawableDividendOf(user);
561 		if (_withdrawableDividend > 0) {
562 			withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
563 			emit DividendWithdrawn(user, _withdrawableDividend);
564             (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
565             if(!success) {
566                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
567                 return 0;
568             }
569             return _withdrawableDividend;
570 		}
571 		return 0;
572 	}
573 	function dividendOf(address _owner) public view override returns(uint256) {
574 		return withdrawableDividendOf(_owner);
575 	}
576 	function withdrawableDividendOf(address _owner) public view override returns(uint256) {
577 		return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
578 	}
579 	function withdrawnDividendOf(address _owner) public view override returns(uint256) {
580 		return withdrawnDividends[_owner];
581 	}
582 	function accumulativeDividendOf(address _owner) public view override returns(uint256) {
583 		return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
584 		.add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
585 	}
586 	function _transfer(address from, address to, uint256 value) internal virtual override {
587 		require(false);
588 		int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
589 		magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
590 		magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
591 	}
592 	function _mint(address account, uint256 value) internal override {
593 		super._mint(account, value);
594 		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
595 		.sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
596 	}
597 	function _burn(address account, uint256 value) internal override {
598 		super._burn(account, value);
599 		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
600 		.add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
601 	}
602 	function _setBalance(address account, uint256 newBalance) internal {
603 		uint256 currentBalance = balanceOf(account);
604 		if(newBalance > currentBalance) {
605 			uint256 mintAmount = newBalance.sub(currentBalance);
606 			_mint(account, mintAmount);
607 		} else if(newBalance < currentBalance) {
608 			uint256 burnAmount = currentBalance.sub(newBalance);
609 			_burn(account, burnAmount);
610 		}
611 	}
612 }
613 
614 contract MivieToken is ERC20, Ownable {
615 	IRouter public uniswapV2Router;
616 	address public immutable uniswapV2Pair;
617 
618 	string private constant _name = "Mivie Token";
619 	string private constant _symbol = "MET";
620 	uint8 private constant _decimals = 18;
621 
622     MivieDividendTracker public dividendTracker;
623 
624 	bool public isTradingEnabled;
625 
626 	// initialSupply
627 	uint256 constant initialSupply =  100000000 * (10**18);
628 
629 	// max wallet is 2% of initialSupply
630 	uint256 public maxWalletAmount = initialSupply * 200 / 10000;
631 
632     // max tx is 100% initialSupply
633     uint256 public maxTxAmount = initialSupply;
634 
635 	bool private _swapping;
636 	uint256 public minimumTokensBeforeSwap =  initialSupply * 25 / 100000;
637 
638 	address public liquidityWallet;
639     address public operationsWallet;
640 
641 	struct CustomTaxPeriod {
642 		bytes23 periodName;
643 		uint8 blocksInPeriod;
644 		uint256 timeInPeriod;
645 		uint8 liquidityFeeOnBuy;
646 		uint8 liquidityFeeOnSell;
647         uint8 operationsFeeOnBuy;
648 		uint8 operationsFeeOnSell;
649 		uint8 holdersFeeOnBuy;
650 		uint8 holdersFeeOnSell;
651 	}
652 	// Base taxes
653 	CustomTaxPeriod private _base = CustomTaxPeriod('default',0,0,1,1,2,2,4,4);
654 
655     uint256 public launchTokens;
656     uint256 private _launchStartTimestamp;
657 	uint256 private _launchBlockNumber;
658 	bool public _launchTokensClaimed;
659 	mapping (address => bool) private _isBlocked;
660 	mapping (address => bool) private _isExcludedFromFee;
661 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
662 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
663 	mapping (address => bool) public automatedMarketMakerPairs;
664 	mapping (address => bool) private _feeOnSelectedWalletTransfers;
665 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
666 
667 	uint8 private _liquidityFee;
668     uint8 private _operationsFee;
669 	uint8 private _holdersFee;
670 	uint8 private _totalFee;
671 
672 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
673 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
674 	event BlockedAccountChange(address indexed holder, bool indexed status);
675 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
676 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
677 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 operationsFee, uint8 holdersFee);
678 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
679 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
680 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
681 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
682     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
683 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
684 	event ExcludeFromMaxTransactionChange(address indexed account, bool isExcluded);
685 	event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
686 	event DividendsSent(uint256 tokensSwapped);
687 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
688     event ClaimOverflow(address token, uint256 amount);
689     event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
690 	event FeesApplied(uint8 liquidityFee, uint8 operationsFee, uint8 holdersFee, uint8 totalFee);
691 
692 	constructor() ERC20(_name, _symbol) {
693         liquidityWallet = owner();
694         operationsWallet = owner();
695 
696     	dividendTracker = new MivieDividendTracker();
697 
698 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
699 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
700 			address(this),
701 			_uniswapV2Router.WETH()
702 		);
703 		uniswapV2Router = _uniswapV2Router;
704 		uniswapV2Pair = _uniswapV2Pair;
705 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
706 
707 		_isExcludedFromFee[owner()] = true;
708 		_isExcludedFromFee[address(this)] = true;
709 		_isExcludedFromFee[address(dividendTracker)] = true;
710 
711 		dividendTracker.excludeFromDividends(address(dividendTracker));
712 		dividendTracker.excludeFromDividends(address(this));
713 		dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
714 		dividendTracker.excludeFromDividends(owner());
715 		dividendTracker.excludeFromDividends(address(_uniswapV2Router));
716 
717 		_isAllowedToTradeWhenDisabled[owner()] = true;
718 		_isAllowedToTradeWhenDisabled[address(this)] = true;
719 
720 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
721 		_isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
722 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
723 		_isExcludedFromMaxWalletLimit[address(this)] = true;
724 		_isExcludedFromMaxWalletLimit[owner()] = true;
725 
726 		_isExcludedFromMaxTransactionLimit[owner()] = true;
727 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
728 		_isExcludedFromMaxTransactionLimit[address(dividendTracker)] = true;
729 
730 		_mint(owner(), initialSupply);
731 	}
732 
733 	receive() external payable {}
734 
735 	// Setters
736 	function activateTrading() external onlyOwner {
737 		isTradingEnabled = true;
738         if (_launchStartTimestamp == 0) {
739             _launchStartTimestamp = block.timestamp;
740             _launchBlockNumber = block.number;
741         }
742 		emit TradingStatusChange(true, false);
743 	}
744 	function deactivateTrading() external onlyOwner {
745 		isTradingEnabled = false;
746 		emit TradingStatusChange(false, true);
747 	}
748 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
749 		require(automatedMarketMakerPairs[pair] != value, "Mivie: Automated market maker pair is already set to that value");
750 		automatedMarketMakerPairs[pair] = value;
751 		if(value) {
752 			dividendTracker.excludeFromDividends(pair);
753 		}
754 		emit AutomatedMarketMakerPairChange(pair, value);
755 	}
756 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
757 		_isAllowedToTradeWhenDisabled[account] = allowed;
758 		emit AllowedWhenTradingDisabledChange(account, allowed);
759 	}
760 	function blockAccount(address account) external onlyOwner {
761 		require(!_isBlocked[account], "Mivie: Account is already blocked");
762 		if (_launchStartTimestamp > 0) {
763 			require((block.timestamp - _launchStartTimestamp) < 172800, "Mivie: Time to block accounts has expired");
764 		}
765 		_isBlocked[account] = true;
766 		emit BlockedAccountChange(account, true);
767 	}
768 	function unblockAccount(address account) external onlyOwner {
769 		require(_isBlocked[account], "Mivie: Account is not blcoked");
770 		_isBlocked[account] = false;
771 		emit BlockedAccountChange(account, false);
772 	}
773 	function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
774 		require(_feeOnSelectedWalletTransfers[account] != value, "Mivie: The selected wallet is already set to the value ");
775 		_feeOnSelectedWalletTransfers[account] = value;
776 		emit FeeOnSelectedWalletTransfersChange(account, value);
777 	}
778 	function excludeFromFees(address account, bool excluded) external onlyOwner {
779 		require(_isExcludedFromFee[account] != excluded, "Mivie: Account is already the value of 'excluded'");
780 		_isExcludedFromFee[account] = excluded;
781 		emit ExcludeFromFeesChange(account, excluded);
782 	}
783 	function excludeFromDividends(address account) external onlyOwner {
784 		dividendTracker.excludeFromDividends(account);
785 	}
786 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
787 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "Mivie: Account is already the value of 'excluded'");
788 		_isExcludedFromMaxWalletLimit[account] = excluded;
789 		emit ExcludeFromMaxWalletChange(account, excluded);
790 	}
791 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
792 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "Mivie: Account is already the value of 'excluded'");
793 		_isExcludedFromMaxTransactionLimit[account] = excluded;
794 		emit ExcludeFromMaxTransactionChange(account, excluded);
795 	}
796 	function setWallets(address newLiquidityWallet, address newOperationsWallet) external onlyOwner {
797 		if(liquidityWallet != newLiquidityWallet) {
798 			require(newLiquidityWallet != address(0), "Mivie: The liquidityWallet cannot be 0");
799 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
800 			liquidityWallet = newLiquidityWallet;
801 		}
802         if(operationsWallet != newOperationsWallet) {
803 			require(newOperationsWallet != address(0), "Mivie: The operationsWallet cannot be 0");
804 			emit WalletChange('operationsWallet', newOperationsWallet, operationsWallet);
805 			operationsWallet = newOperationsWallet;
806 		}
807 	}
808 	// Base Fees
809 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _operationsFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
810 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _operationsFeeOnBuy, _holdersFeeOnBuy);
811 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _operationsFeeOnBuy, _holdersFeeOnBuy);
812 	}
813 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _operationsFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
814 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _operationsFeeOnSell, _holdersFeeOnSell);
815 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _operationsFeeOnSell, _holdersFeeOnSell);
816 	}
817 	function setUniswapRouter(address newAddress) external onlyOwner {
818 		require(newAddress != address(uniswapV2Router), "Mivie: The router already has that address");
819 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
820 		uniswapV2Router = IRouter(newAddress);
821 	}
822 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
823 		require(newValue != maxWalletAmount, "Mivie: Cannot update maxWalletAmount to same value");
824 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
825 		maxWalletAmount = newValue;
826 	}
827 	function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
828 		require(newValue != maxTxAmount, "Mivie: Cannot update maxTxAmount to same value");
829         emit MaxTransactionAmountChange(newValue, maxTxAmount);
830         maxTxAmount = newValue;
831 	}
832 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
833 		require(newValue != minimumTokensBeforeSwap, "Mivie: Cannot update minimumTokensBeforeSwap to same value");
834 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
835 		minimumTokensBeforeSwap = newValue;
836 	}
837 	function claim() external {
838 		dividendTracker.processAccount(payable(msg.sender), false);
839 	}
840 	function claimLaunchTokens() external onlyOwner {
841 		require(_launchStartTimestamp > 0, "Mivie: Launch must have occurred");
842 		require(!_launchTokensClaimed, "Mivie: Launch tokens have already been claimed");
843 		require(block.number - _launchBlockNumber > 5, "Mivie: Only claim launch tokens after launch");
844 		uint256 tokenBalance = balanceOf(address(this));
845 		_launchTokensClaimed = true;
846 		require(launchTokens <= tokenBalance, "Mivie: A swap and liquify has already occurred");
847 		uint256 amount = launchTokens;
848 		launchTokens = 0;
849         (bool success) = IERC20(address(this)).transfer(owner(), amount);
850         if (success){
851             emit ClaimOverflow(address(this), amount);
852         }
853     }
854 	function claimETHOverflow(uint256 amount) external onlyOwner {
855 		require(amount < address(this).balance, "Mivie: Cannot send more than contract balance");
856 		(bool success,) = address(owner()).call{value : amount}("");
857 		if (success){
858 			emit ClaimOverflow(uniswapV2Router.WETH(), amount);
859 		}
860 	}
861 
862 	// Getters
863 	function getTotalDividendsDistributed() external view returns (uint256) {
864 		return dividendTracker.totalDividendsDistributed();
865 	}
866 	function getNumberOfDividendTokenHolders() external view returns(uint256) {
867 		return dividendTracker.getNumberOfTokenHolders();
868 	}
869 	function getBaseBuyFees() external view returns (uint8, uint8, uint8){
870 		return (_base.liquidityFeeOnBuy, _base.operationsFeeOnBuy, _base.holdersFeeOnBuy);
871 	}
872 	function getBaseSellFees() external view returns (uint8, uint8, uint8){
873 		return (_base.liquidityFeeOnSell, _base.operationsFeeOnSell, _base.holdersFeeOnSell);
874 	}
875 
876 	// Main
877 	function _transfer(
878 		address from,
879 		address to,
880 		uint256 amount
881 		) internal override {
882 			require(from != address(0), "ERC20: transfer from the zero address");
883 			require(to != address(0), "ERC20: transfer to the zero address");
884 
885 			if(amount == 0) {
886 				super._transfer(from, to, 0);
887 				return;
888 			}
889 
890 		    if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
891 				require(isTradingEnabled, "Mivie: Trading is currently disabled.");
892 				require(!_isBlocked[to], "Mivie: Account is blocked");
893 				require(!_isBlocked[from], "Mivie: Account is blocked");
894 				if (!_isExcludedFromMaxWalletLimit[to]) {
895 					require((balanceOf(to) + amount) <= maxWalletAmount, "Mivie: Expected wallet amount exceeds the maxWalletAmount.");
896 				}
897 				if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
898 					require(amount <= maxTxAmount, "Mivie: Transfer amount exceeds the maxTxAmount.");
899 				}
900 			}
901 
902 			_adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], from, to);
903 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
904 
905 			if (
906 				isTradingEnabled &&
907 				canSwap &&
908 				!_swapping &&
909 				_totalFee > 0 &&
910 				automatedMarketMakerPairs[to]
911 			) {
912 				_swapping = true;
913 				_swapAndLiquify();
914 				_swapping = false;
915 			}
916 
917 			bool takeFee = !_swapping && isTradingEnabled;
918 
919 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
920 				takeFee = false;
921 			}
922 			if (takeFee && _totalFee > 0) {
923 				uint256 fee = amount * _totalFee / 100;
924 				amount = amount - fee;
925                 if (_launchStartTimestamp > 0 && (block.number - _launchBlockNumber <= 5)) {
926                     launchTokens += fee;
927                 }
928 				super._transfer(from, address(this), fee);
929 			}
930 
931 			super._transfer(from, to, amount);
932 
933 			try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
934 			try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
935 	}
936 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address from, address to) private {
937 		_liquidityFee = 0;
938 		_operationsFee = 0;
939 		_holdersFee = 0;
940 
941 		if (isBuyFromLp) {
942 		    if ((block.number - _launchBlockNumber) <= 5) {
943 				_liquidityFee = 100;
944 			}
945 			else {
946 				_liquidityFee = _base.liquidityFeeOnBuy;
947 				_operationsFee = _base.operationsFeeOnBuy;
948 				_holdersFee = _base.holdersFeeOnBuy;
949 			}
950 		}
951 	    if (isSelltoLp) {
952 	    	_liquidityFee = _base.liquidityFeeOnSell;
953 			_operationsFee = _base.operationsFeeOnSell;
954 			_holdersFee = _base.holdersFeeOnSell;
955 		}
956 		if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
957 			_liquidityFee = _base.liquidityFeeOnSell;
958             _operationsFee = _base.operationsFeeOnSell;
959             _holdersFee = _base.holdersFeeOnSell;
960 		}
961 		_totalFee = _liquidityFee + _operationsFee + _holdersFee;
962 		emit FeesApplied(_liquidityFee, _operationsFee, _holdersFee, _totalFee);
963 	}
964 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
965 		uint8 _liquidityFeeOnSell,
966 		uint8 _operationsFeeOnSell,
967 		uint8 _holdersFeeOnSell
968 	) private {
969 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
970 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
971 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
972 		}
973 		if (map.operationsFeeOnSell != _operationsFeeOnSell) {
974 			emit CustomTaxPeriodChange(_operationsFeeOnSell, map.operationsFeeOnSell, 'operationsFeeOnSell', map.periodName);
975 			map.operationsFeeOnSell = _operationsFeeOnSell;
976 		}
977 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
978 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
979 			map.holdersFeeOnSell = _holdersFeeOnSell;
980 		}
981 	}
982 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
983 		uint8 _liquidityFeeOnBuy,
984 		uint8 _operationsFeeOnBuy,
985 		uint8 _holdersFeeOnBuy
986 		) private {
987 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
988 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
989 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
990 		}
991 		if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
992 			emit CustomTaxPeriodChange(_operationsFeeOnBuy, map.operationsFeeOnBuy, 'operationsFeeOnBuy', map.periodName);
993 			map.operationsFeeOnBuy = _operationsFeeOnBuy;
994 		}
995 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
996 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
997 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
998 		}
999 	}
1000 	function _swapAndLiquify() private {
1001 		uint256 contractBalance = balanceOf(address(this));
1002 		uint256 initialETHBalance = address(this).balance;
1003 
1004 		uint8 totalFeePrior = _totalFee;
1005 
1006 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
1007 		uint256 amountToSwap = contractBalance - amountToLiquify;
1008 
1009 		_swapTokensForETH(amountToSwap);
1010 
1011 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
1012 		uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
1013 
1014 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
1015 		uint256 amountETHOperations = ETHBalanceAfterSwap * _operationsFee / totalETHFee;
1016 		uint256 amountETHHolders = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHOperations);
1017 
1018 		Address.sendValue(payable(operationsWallet),amountETHOperations);
1019 
1020 		if (amountToLiquify > 0) {
1021 			_addLiquidity(amountToLiquify, amountETHLiquidity);
1022 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
1023 		}
1024 
1025 		(bool dividendSuccess,) = address(dividendTracker).call{value: amountETHHolders}("");
1026 		if(dividendSuccess) {
1027 			emit DividendsSent(amountETHHolders);
1028 		}
1029 
1030 		_totalFee = totalFeePrior;
1031 	}
1032 	function _swapTokensForETH(uint256 tokenAmount) private {
1033 		address[] memory path = new address[](2);
1034 		path[0] = address(this);
1035 		path[1] = uniswapV2Router.WETH();
1036 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1037 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1038 			tokenAmount,
1039 			0, // accept any amount of ETH
1040 			path,
1041 			address(this),
1042 			block.timestamp
1043 		);
1044 	}
1045 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1046 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1047 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
1048 			address(this),
1049 			tokenAmount,
1050 			0, // slippage is unavoidable
1051 			0, // slippage is unavoidable
1052 			liquidityWallet,
1053 			block.timestamp
1054 		);
1055 	}
1056 }
1057 
1058 contract MivieDividendTracker is DividendPayingToken {
1059 	using SafeMath for uint256;
1060 	using SafeMathInt for int256;
1061 	using IterableMapping for IterableMapping.Map;
1062 
1063 	IterableMapping.Map private tokenHoldersMap;
1064 
1065 	uint256 public lastProcessedIndex;
1066 	mapping (address => bool) public excludedFromDividends;
1067 	mapping (address => uint256) public lastClaimTimes;
1068 	uint256 public claimWait;
1069 	uint256 public minimumTokenBalanceForDividends;
1070 
1071 	event ExcludeFromDividends(address indexed account);
1072 	event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1073 	event Claim(address indexed account, uint256 amount, bool indexed automatic);
1074 
1075 	constructor() DividendPayingToken("Mivie_Dividend_Tracker", "Mivie_Dividend_Tracker") {
1076 		claimWait = 3600;
1077 		minimumTokenBalanceForDividends = 0 * (10**18);
1078 	}
1079 	function _transfer(address, address, uint256) internal pure override {
1080 		require(false, "Mivie_Dividend_Tracker: No transfers allowed");
1081 	}
1082 	function excludeFromDividends(address account) external onlyOwner {
1083 		require(!excludedFromDividends[account]);
1084 		excludedFromDividends[account] = true;
1085 		_setBalance(account, 0);
1086 		tokenHoldersMap.remove(account);
1087 		emit ExcludeFromDividends(account);
1088 	}
1089 	function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1090 		require(minimumTokenBalanceForDividends != newValue, "Mivie_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'.");
1091 		minimumTokenBalanceForDividends = newValue;
1092 	}
1093 	function getNumberOfTokenHolders() external view returns(uint256) {
1094 		return tokenHoldersMap.keys.length;
1095 	}
1096 	function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1097 		if(excludedFromDividends[account]) {
1098 			return;
1099 		}
1100 		if(newBalance >= minimumTokenBalanceForDividends) {
1101 			_setBalance(account, newBalance);
1102 			tokenHoldersMap.set(account, newBalance);
1103 		}
1104 		else {
1105 			_setBalance(account, 0);
1106 			tokenHoldersMap.remove(account);
1107 		}
1108 		processAccount(account, true);
1109 	}
1110 	function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1111 		uint256 amount = _withdrawDividendOfUser(account);
1112 		if(amount > 0) {
1113 			lastClaimTimes[account] = block.timestamp;
1114 			emit Claim(account, amount, automatic);
1115 			return true;
1116 		}
1117 		return false;
1118 	}
1119 }