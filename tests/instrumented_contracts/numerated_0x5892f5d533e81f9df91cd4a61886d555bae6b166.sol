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
614 contract ETHDox is ERC20, Ownable {
615 	IRouter public uniswapV2Router;
616 	address public immutable uniswapV2Pair;
617 
618 	string private constant _name = "ETHDox";
619 	string private constant _symbol = "ETHDOX";
620 	uint8 private constant _decimals = 18;
621 
622 	ETHDoxDividendTracker public dividendTracker;
623 
624 	bool public isTradingEnabled;
625 	uint256 private _launchBlockNumber;
626 	uint256 private _launchTimestamp;
627 	uint256 private _tradingPausedTimestamp;
628 	uint256 private constant _blockedTimeLimit = 172800;
629 
630 	// initialSupply
631 	uint256 constant initialSupply = 1000000000 * (10**18);
632 
633 	// max wallet is 2% of initialSupply
634 	uint256 public maxWalletAmount = initialSupply * 200 / 10000;
635 
636 	bool private _swapping;
637 	uint256 public minimumTokensBeforeSwap = 25000000 * (10**18);
638 
639 	address public liquidityWallet;
640 	address public buyBackWallet;
641 	address public devWallet;
642 
643 	struct CustomTaxPeriod {
644 		bytes23 periodName;
645 		uint8 blocksInPeriod;
646 		uint256 timeInPeriod;
647 		uint8 liquidityFeeOnBuy;
648 		uint8 liquidityFeeOnSell;
649 		uint8 devFeeOnBuy;
650 		uint8 devFeeOnSell;
651 		uint8 buyBackFeeOnBuy;
652 		uint8 buyBackFeeOnSell;
653 		uint8 holdersFeeOnBuy;
654 		uint8 holdersFeeOnSell;
655 	}
656 	// Base taxes
657 	CustomTaxPeriod private _default = CustomTaxPeriod('default',0,0,3,3,3,3,1,1,2,2);
658 	CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,3,3,3,3,1,1,2,2);
659 
660 	mapping (address => bool) private _isBlocked;
661 	mapping (address => bool) private _isExcludedFromFee;
662 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
663 	mapping (address => bool) public automatedMarketMakerPairs;
664 	mapping (address => uint256) private _sellTimesInLaunch;
665 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
666 
667 	uint8 private _liquidityFee;
668 	uint8 private _devFee;
669 	uint8 private _buyBackFee;
670 	uint8 private _holdersFee;
671 	uint8 private _totalFee;
672 
673 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
674 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
675 	event BlockedAccountChange(address indexed holder, bool indexed status);
676 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
677 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
678 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 devFee, uint8 buyBackFee, uint8 holdersFee);
679 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
680 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
681 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
682     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
683 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
684 	event ExcludeFromDividendsChange(address indexed account, bool isExcluded);
685 	event DividendsSent(uint256 tokensSwapped);
686 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
687     event ClaimETHOverflow(uint256 amount);
688 	event FeesApplied(uint8 liquidityFee, uint8 devFee, uint8 buybackFee, uint8 holdersFee, uint8 totalFee);
689 
690 	constructor() ERC20(_name, _symbol) {
691         liquidityWallet = owner();
692         devWallet = owner();
693 	    buyBackWallet = owner();
694 
695 		dividendTracker = new ETHDoxDividendTracker();
696 
697 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Mainnet
698 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
699 			address(this),
700 			_uniswapV2Router.WETH()
701 		);
702 		uniswapV2Router = _uniswapV2Router;
703 		uniswapV2Pair = _uniswapV2Pair;
704 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
705 
706 		_isExcludedFromFee[owner()] = true;
707 		_isExcludedFromFee[address(this)] = true;
708 		_isExcludedFromFee[address(dividendTracker)] = true;
709 
710 		dividendTracker.excludeFromDividends(address(dividendTracker));
711 		dividendTracker.excludeFromDividends(address(this));
712 		dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
713 		dividendTracker.excludeFromDividends(owner());
714 		dividendTracker.excludeFromDividends(address(_uniswapV2Router));
715 
716 		_isAllowedToTradeWhenDisabled[owner()] = true;
717 		_isAllowedToTradeWhenDisabled[address(this)] = true;
718 
719 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
720 		_isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
721 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
722 		_isExcludedFromMaxWalletLimit[address(this)] = true;
723 		_isExcludedFromMaxWalletLimit[owner()] = true;
724 
725 		_mint(owner(), initialSupply);
726 	}
727 
728 	receive() external payable {}
729 
730 	// Setters
731 	function activateTrading() external onlyOwner {
732 		isTradingEnabled = true;
733 		if (_launchTimestamp == 0) {
734 			_launchTimestamp = block.timestamp;
735 			_launchBlockNumber = block.number;
736 		}
737 	}
738 	function deactivateTrading() external onlyOwner {
739 		isTradingEnabled = false;
740 		_tradingPausedTimestamp = block.timestamp;
741 	}
742 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
743 		require(automatedMarketMakerPairs[pair] != value, "ETHDox: Automated market maker pair is already set to that value");
744 		automatedMarketMakerPairs[pair] = value;
745 		if(value) {
746 			dividendTracker.excludeFromDividends(pair);
747 		}
748 		emit AutomatedMarketMakerPairChange(pair, value);
749 	}
750 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
751 		_isAllowedToTradeWhenDisabled[account] = allowed;
752 		emit AllowedWhenTradingDisabledChange(account, allowed);
753 	}
754 	function blockAccount(address account) external onlyOwner {
755 		require(!_isBlocked[account], "ETHDox: Account is already blocked");
756 		require((block.timestamp - _launchTimestamp) < _blockedTimeLimit, "ETHDox: Time to block accounts has expired");
757 		_isBlocked[account] = true;
758 		emit BlockedAccountChange(account, true);
759 	}
760 	function unblockAccount(address account) external onlyOwner {
761 		require(_isBlocked[account], "ETHDox: Account is not blcoked");
762 		_isBlocked[account] = false;
763 		emit BlockedAccountChange(account, false);
764 	}
765 	function excludeFromFees(address account, bool excluded) external onlyOwner {
766 		require(_isExcludedFromFee[account] != excluded, "ETHDox: Account is already the value of 'excluded'");
767 		_isExcludedFromFee[account] = excluded;
768 		emit ExcludeFromFeesChange(account, excluded);
769 	}
770 	function excludeFromDividends(address account) external onlyOwner {
771 		dividendTracker.excludeFromDividends(account);
772 	}
773 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
774 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "ETHDox: Account is already the value of 'excluded'");
775 		_isExcludedFromMaxWalletLimit[account] = excluded;
776 		emit ExcludeFromMaxWalletChange(account, excluded);
777 	}
778 	function setWallets(address newLiquidityWallet, address newDevWallet, address newBuyBackWallet) external onlyOwner {
779 		if(liquidityWallet != newLiquidityWallet) {
780 			require(newLiquidityWallet != address(0), "ETHDox: The liquidityWallet cannot be 0");
781 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
782 			liquidityWallet = newLiquidityWallet;
783 		}
784 		if(devWallet != newDevWallet) {
785 			require(newDevWallet != address(0), "ETHDox: The devWallet cannot be 0");
786 			emit WalletChange('devWallet', newDevWallet, devWallet);
787 			devWallet = newDevWallet;
788 		}
789 		if(buyBackWallet != newBuyBackWallet) {
790 			require(newBuyBackWallet != address(0), "ETHDox: The buyBackWallet cannot be 0");
791 			emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
792 			buyBackWallet = newBuyBackWallet;
793 		}
794 	}
795 	// Base Fees
796 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _devFeeOnBuy, uint8 _buybackFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
797 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _devFeeOnBuy, _buybackFeeOnBuy, _holdersFeeOnBuy);
798 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _devFeeOnBuy, _buybackFeeOnBuy, _holdersFeeOnBuy);
799 	}
800 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _devFeeOnSell, uint8 _buybackFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
801 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _devFeeOnSell, _buybackFeeOnSell, _holdersFeeOnSell);
802 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _devFeeOnSell, _buybackFeeOnSell, _holdersFeeOnSell);
803 	}
804 	function setUniswapRouter(address newAddress) external onlyOwner {
805 		require(newAddress != address(uniswapV2Router), "ETHDox: The router already has that address");
806 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
807 		uniswapV2Router = IRouter(newAddress);
808 	}
809 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
810 		require(newValue != maxWalletAmount, "ETHDox: Cannot update maxWalletAmount to same value");
811 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
812 		maxWalletAmount = newValue;
813 	}
814 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
815 		require(newValue != minimumTokensBeforeSwap, "ETHDox: Cannot update minimumTokensBeforeSwap to same value");
816 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
817 		minimumTokensBeforeSwap = newValue;
818 	}
819 	function claim() external {
820 		dividendTracker.processAccount(payable(msg.sender), false);
821 	}
822 	function claimETHOverflow() external onlyOwner {
823 	    uint256 amount = address(this).balance;
824         (bool success,) = address(owner()).call{value : amount}("");
825         if (success){
826             emit ClaimETHOverflow(amount);
827         }
828 	}
829 
830 	// Getters
831 	function getTotalDividendsDistributed() external view returns (uint256) {
832 		return dividendTracker.totalDividendsDistributed();
833 	}
834 	function getNumberOfDividendTokenHolders() external view returns(uint256) {
835 		return dividendTracker.getNumberOfTokenHolders();
836 	}
837 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8){
838 		return (_base.liquidityFeeOnBuy, _base.devFeeOnBuy, _base.buyBackFeeOnBuy, _base.holdersFeeOnBuy);
839 	}
840 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8){
841 		return (_base.liquidityFeeOnSell, _base.devFeeOnSell, _base.buyBackFeeOnSell, _base.holdersFeeOnSell);
842 	}
843 	function isBot(address botAddress) external view returns(bool) {
844 		return Address.isContract(botAddress);
845 	}
846 
847 	// Main
848 	function _transfer(
849 		address from,
850 		address to,
851 		uint256 amount
852 		) internal override {
853 			require(from != address(0), "ERC20: transfer from the zero address");
854 			require(to != address(0), "ERC20: transfer to the zero address");
855 
856 			if(amount == 0) {
857 				super._transfer(from, to, 0);
858 				return;
859 			}
860 
861 		    if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
862 				require(isTradingEnabled, "ETHDox: Trading is currently disabled.");
863 				require(!_isBlocked[to], "ETHDox: Account is blocked");
864 				require(!_isBlocked[from], "ETHDox: Account is blocked");
865 				if (!_isExcludedFromMaxWalletLimit[to]) {
866 					require((balanceOf(to) + amount) <= maxWalletAmount, "ETHDox: Expected wallet amount exceeds the maxWalletAmount.");
867 				}
868 				if ((block.timestamp - _launchTimestamp) < 3600 && automatedMarketMakerPairs[to]) {
869 					require((block.timestamp - _sellTimesInLaunch[from]) > 60, "ETHDox: Cannot sell more than once per 60s in launch");
870 				}
871 			}
872 
873 			_adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to]);
874 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
875 
876 			if (
877 				isTradingEnabled &&
878 				canSwap &&
879 				!_swapping &&
880 				_totalFee > 0 &&
881 				automatedMarketMakerPairs[to]
882 			) {
883 				_swapping = true;
884 				_swapAndLiquify();
885 				_swapping = false;
886 			}
887 
888 			bool takeFee = !_swapping && isTradingEnabled;
889 
890 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
891 				takeFee = false;
892 			}
893 			if (takeFee) {
894 				uint256 fee = amount * _totalFee / 100;
895 				amount = amount - fee;
896 				super._transfer(from, address(this), fee);
897 			}
898 
899 			super._transfer(from, to, amount);
900 
901 			if (automatedMarketMakerPairs[to] && (block.timestamp - _launchTimestamp) < 3600 && !_isAllowedToTradeWhenDisabled[from]) {
902 				_sellTimesInLaunch[from] = block.timestamp;
903 			}
904 
905 			try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
906 			try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
907 	}
908 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp) private {
909 		_liquidityFee = 0;
910 		_devFee = 0;
911 		_buyBackFee = 0;
912 		_holdersFee = 0;
913 
914 		if (isBuyFromLp) {
915 		    if ((block.number - _launchBlockNumber) <= 5) {
916 				_liquidityFee = 100;
917 			}
918 			else {
919 				_liquidityFee = _base.liquidityFeeOnBuy;
920 				_devFee = _base.devFeeOnBuy;
921 				_buyBackFee = _base.buyBackFeeOnBuy;
922 				_holdersFee = _base.holdersFeeOnBuy;
923 			}
924 		}
925 	    if (isSelltoLp) {
926 	    	_liquidityFee = _base.liquidityFeeOnSell;
927 			_holdersFee = _base.holdersFeeOnSell;
928 			_devFee = _base.devFeeOnSell;
929 			_buyBackFee = _base.buyBackFeeOnSell;
930 		}
931 		_totalFee = _liquidityFee + _devFee + _buyBackFee  + _holdersFee;
932 		emit FeesApplied(_liquidityFee, _devFee, _buyBackFee, _holdersFee, _totalFee);
933 	}
934 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
935 		uint8 _liquidityFeeOnSell,
936 		uint8 _devFeeOnSell,
937 		uint8 _buyBackFeeOnSell,
938 		uint8 _holdersFeeOnSell
939 	) private {
940 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
941 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
942 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
943 		}
944 		if (map.devFeeOnSell != _devFeeOnSell) {
945 			emit CustomTaxPeriodChange(_devFeeOnSell, map.devFeeOnSell, 'devFeeOnSell', map.periodName);
946 			map.devFeeOnSell = _devFeeOnSell;
947 		}
948 		if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
949 			emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
950 			map.buyBackFeeOnSell = _buyBackFeeOnSell;
951 		}
952 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
953 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
954 			map.holdersFeeOnSell = _holdersFeeOnSell;
955 		}
956 	}
957 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
958 		uint8 _liquidityFeeOnBuy,
959 		uint8 _devFeeOnBuy,
960 		uint8 _buyBackFeeOnBuy,
961 		uint8 _holdersFeeOnBuy
962 		) private {
963 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
964 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
965 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
966 		}
967 		if (map.devFeeOnBuy != _devFeeOnBuy) {
968 			emit CustomTaxPeriodChange(_devFeeOnBuy, map.devFeeOnBuy, 'devFeeOnBuy', map.periodName);
969 			map.devFeeOnBuy = _devFeeOnBuy;
970 		}
971 		if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
972 			emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
973 			map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
974 		}
975 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
976 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
977 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
978 		}
979 	}
980 	function _swapAndLiquify() private {
981 		uint256 contractBalance = balanceOf(address(this));
982 		uint256 initialETHBalance = address(this).balance;
983 
984 		uint8 totalFeePrior = _totalFee;
985 
986 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
987 		uint256 amountToSwap = contractBalance - amountToLiquify;
988 
989 		_swapTokensForETH(amountToSwap);
990 
991 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
992 		uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
993 
994 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
995 		uint256 amountETHDev = ETHBalanceAfterSwap * _devFee / totalETHFee;
996 		uint256 amountETHBuyBack = ETHBalanceAfterSwap * _buyBackFee / totalETHFee;
997 		uint256 amountETHHolders = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHDev + amountETHBuyBack);
998 
999 		payable(devWallet).transfer(amountETHDev);
1000 		payable(buyBackWallet).transfer(amountETHBuyBack);
1001 
1002 		if (amountToLiquify > 0) {
1003 			_addLiquidity(amountToLiquify, amountETHLiquidity);
1004 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
1005 		}
1006 
1007 		(bool dividendSuccess,) = address(dividendTracker).call{value: amountETHHolders}("");
1008 		if(dividendSuccess) {
1009 			emit DividendsSent(amountETHHolders);
1010 		}
1011 
1012 		_totalFee = totalFeePrior;
1013 	}
1014 	function _swapTokensForETH(uint256 tokenAmount) private {
1015 		address[] memory path = new address[](2);
1016 		path[0] = address(this);
1017 		path[1] = uniswapV2Router.WETH();
1018 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1019 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1020 			tokenAmount,
1021 			0, // accept any amount of ETH
1022 			path,
1023 			address(this),
1024 			block.timestamp
1025 		);
1026 	}
1027 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1028 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1029 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
1030 			address(this),
1031 			tokenAmount,
1032 			0, // slippage is unavoidable
1033 			0, // slippage is unavoidable
1034 			liquidityWallet,
1035 			block.timestamp
1036 		);
1037 	}
1038 }
1039 
1040 contract ETHDoxDividendTracker is DividendPayingToken {
1041 	using SafeMath for uint256;
1042 	using SafeMathInt for int256;
1043 	using IterableMapping for IterableMapping.Map;
1044 
1045 	IterableMapping.Map private tokenHoldersMap;
1046 
1047 	uint256 public lastProcessedIndex;
1048 	mapping (address => bool) public excludedFromDividends;
1049 	mapping (address => uint256) public lastClaimTimes;
1050 	uint256 public claimWait;
1051 	uint256 public minimumTokenBalanceForDividends;
1052 
1053 	event ExcludeFromDividends(address indexed account);
1054 	event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1055 	event Claim(address indexed account, uint256 amount, bool indexed automatic);
1056 
1057 	constructor() DividendPayingToken("ETHDox_Dividend_Tracker", "ETHDox_Dividend_Tracker") {
1058 		claimWait = 3600;
1059 		minimumTokenBalanceForDividends = 0 * (10**18);
1060 	}
1061 	function _transfer(address, address, uint256) internal pure override {
1062 		require(false, "ETHDox_Dividend_Tracker: No transfers allowed");
1063 	}
1064 	function excludeFromDividends(address account) external onlyOwner {
1065 		require(!excludedFromDividends[account]);
1066 		excludedFromDividends[account] = true;
1067 		_setBalance(account, 0);
1068 		tokenHoldersMap.remove(account);
1069 		emit ExcludeFromDividends(account);
1070 	}
1071 	function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1072 		require(minimumTokenBalanceForDividends != newValue, "ETHDox_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'.");
1073 		minimumTokenBalanceForDividends = newValue;
1074 	}
1075 	function getNumberOfTokenHolders() external view returns(uint256) {
1076 		return tokenHoldersMap.keys.length;
1077 	}
1078 	function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1079 		if(excludedFromDividends[account]) {
1080 			return;
1081 		}
1082 		if(newBalance >= minimumTokenBalanceForDividends) {
1083 			_setBalance(account, newBalance);
1084 			tokenHoldersMap.set(account, newBalance);
1085 		}
1086 		else {
1087 			_setBalance(account, 0);
1088 			tokenHoldersMap.remove(account);
1089 		}
1090 		processAccount(account, true);
1091 	}
1092 	function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1093 		uint256 amount = _withdrawDividendOfUser(account);
1094 		if(amount > 0) {
1095 			lastClaimTimes[account] = block.timestamp;
1096 			emit Claim(account, amount, automatic);
1097 			return true;
1098 		}
1099 		return false;
1100 	}
1101 }