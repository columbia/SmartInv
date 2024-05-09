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
614 contract REIToken is ERC20, Ownable {
615 	IRouter public uniswapV2Router;
616 	address public immutable uniswapV2Pair;
617 
618 	string private constant _name = "REIToken";
619 	string private constant _symbol = "REIT";
620 	uint8 private constant _decimals = 18;
621 
622 	REITDividendTracker public dividendTracker;
623 
624 	bool public isTradingEnabled;
625 	uint256 private _launchBlockNumber;
626 	uint256 private _launchTimestamp;
627 
628 	uint256 private constant _blockedTimeLimit = 172800;
629 
630 	address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
631 
632 	// initialSupply
633 	uint256 constant initialSupply = 1000000000000 * (10**18);
634 
635 	// max wallet is 1% of initialSupply
636 	uint256 public maxWalletAmount = initialSupply * 100 / 10000;
637 
638     // max buy is 0.5%, max sell is 0.3% of initialSupply
639     uint256 public maxTxBuyAmount = initialSupply * 500 / 100000;
640     uint256 public maxTxSellAmount = initialSupply * 300 / 100000;
641 
642 	bool private _swapping;
643 	uint256 public minimumTokensBeforeSwap = 15000000 * (10**18);
644 
645 	address public liquidityWallet;
646     address public marketingWallet;
647 	address public treasuryWallet;
648 	address public capitalWallet;
649 
650 	struct CustomTaxPeriod {
651 		bytes23 periodName;
652 		uint8 blocksInPeriod;
653 		uint256 timeInPeriod;
654 		uint8 liquidityFeeOnBuy;
655 		uint8 liquidityFeeOnSell;
656         uint8 marketingFeeOnBuy;
657 		uint8 marketingFeeOnSell;
658 		uint8 treasuryFeeOnBuy;
659 		uint8 treasuryFeeOnSell;
660 		uint8 capitalFeeOnBuy;
661 		uint8 capitalFeeOnSell;
662 		uint8 holdersFeeOnBuy;
663 		uint8 holdersFeeOnSell;
664 	}
665 	// Base taxes
666 	CustomTaxPeriod private _base = CustomTaxPeriod('default',0,0,1,1,3,3,2,2,3,3,1,1);
667 
668 	mapping (address => bool) private _isBlocked;
669 	mapping (address => bool) private _isExcludedFromFee;
670 	mapping (address => bool) private _isExcludedFromMaxWalletLimit;
671 	mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
672 	mapping (address => bool) public automatedMarketMakerPairs;
673 	mapping (address => bool) private _feeOnSelectedWalletTransfers;
674 	mapping (address => bool) private _isAllowedToTradeWhenDisabled;
675 
676 	uint8 private _liquidityFee;
677     uint8 private _marketingFee;
678 	uint8 private _treasuryFee;
679 	uint8 private _capitalFee;
680 	uint8 private _holdersFee;
681 	uint8 private _totalFee;
682 
683 	event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
684 	event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
685 	event BlockedAccountChange(address indexed holder, bool indexed status);
686 	event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
687 	event WalletChange(string indexed walletIdentifier, address indexed newWallet, address indexed oldWallet);
688 	event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 marketingFee, uint8 treasuryFee, uint8 capitalFee, uint8 holdersFee);
689 	event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
690 	event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
691 	event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
692 	event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
693     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
694 	event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
695 	event ExcludeFromMaxTransactionChange(address indexed account, bool isExcluded);
696 	event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
697 	event DividendsSent(uint256 tokensSwapped);
698 	event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
699     event ClaimETHOverflow(uint256 amount);
700 	event FeesApplied(uint8 liquidityFee, uint8 marketingFee, uint8 treasuryFee, uint8 capitalFee, uint8 holdersFee, uint8 totalFee);
701 
702 	constructor() ERC20(_name, _symbol) {
703         liquidityWallet = owner();
704         marketingWallet = owner();
705         treasuryWallet = owner();
706 	    capitalWallet = owner();
707 
708 		dividendTracker = new REITDividendTracker();
709 
710 		IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Mainnet
711 		address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(
712 			address(this),
713 			_uniswapV2Router.WETH()
714 		);
715 		uniswapV2Router = _uniswapV2Router;
716 		uniswapV2Pair = _uniswapV2Pair;
717 		_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
718 
719 		_isExcludedFromFee[owner()] = true;
720 		_isExcludedFromFee[address(this)] = true;
721 		_isExcludedFromFee[address(dividendTracker)] = true;
722 
723 		dividendTracker.excludeFromDividends(address(dividendTracker));
724 		dividendTracker.excludeFromDividends(address(this));
725 		dividendTracker.excludeFromDividends(address(0x000000000000000000000000000000000000dEaD));
726 		dividendTracker.excludeFromDividends(owner());
727 		dividendTracker.excludeFromDividends(address(_uniswapV2Router));
728 
729 		_isAllowedToTradeWhenDisabled[owner()] = true;
730 		_isAllowedToTradeWhenDisabled[address(this)] = true;
731 
732 		_isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
733 		_isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
734 		_isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
735 		_isExcludedFromMaxWalletLimit[address(this)] = true;
736 		_isExcludedFromMaxWalletLimit[owner()] = true;
737 
738 		_isExcludedFromMaxTransactionLimit[owner()] = true;
739 		_isExcludedFromMaxTransactionLimit[address(this)] = true;
740 		_isExcludedFromMaxTransactionLimit[address(dividendTracker)] = true;
741 
742 		_mint(owner(), initialSupply);
743 	}
744 
745 	receive() external payable {}
746 
747 	// Setters
748 	function activateTrading() external onlyOwner {
749 		isTradingEnabled = true;
750 		if (_launchTimestamp == 0) {
751 			_launchTimestamp = block.timestamp;
752 			_launchBlockNumber = block.number;
753 		}
754 	}
755 	function deactivateTrading() external onlyOwner {
756 		isTradingEnabled = false;
757 	}
758 	function _setAutomatedMarketMakerPair(address pair, bool value) private {
759 		require(automatedMarketMakerPairs[pair] != value, "REIT: Automated market maker pair is already set to that value");
760 		automatedMarketMakerPairs[pair] = value;
761 		if(value) {
762 			dividendTracker.excludeFromDividends(pair);
763 		}
764 		emit AutomatedMarketMakerPairChange(pair, value);
765 	}
766 	function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
767 		_isAllowedToTradeWhenDisabled[account] = allowed;
768 		emit AllowedWhenTradingDisabledChange(account, allowed);
769 	}
770 	function blockAccount(address account) external onlyOwner {
771 		require(!_isBlocked[account], "REIT: Account is already blocked");
772 		require((block.timestamp - _launchTimestamp) < _blockedTimeLimit, "REIT: Time to block accounts has expired");
773 		_isBlocked[account] = true;
774 		emit BlockedAccountChange(account, true);
775 	}
776 	function unblockAccount(address account) external onlyOwner {
777 		require(_isBlocked[account], "REIT: Account is not blcoked");
778 		_isBlocked[account] = false;
779 		emit BlockedAccountChange(account, false);
780 	}
781 	function setUSDTAddress(address newUSDTAddress) external onlyOwner {
782 		require(newUSDTAddress != USDT, "REIT: The USDT address is already the value of newUSDTAddress");
783 		USDT = newUSDTAddress;
784 	}
785 	function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
786 		require(_feeOnSelectedWalletTransfers[account] != value, "REIT: The selected wallet is already set to the value ");
787 		_feeOnSelectedWalletTransfers[account] = value;
788 		emit FeeOnSelectedWalletTransfersChange(account, value);
789 	}
790 	function excludeFromFees(address account, bool excluded) external onlyOwner {
791 		require(_isExcludedFromFee[account] != excluded, "REIT: Account is already the value of 'excluded'");
792 		_isExcludedFromFee[account] = excluded;
793 		emit ExcludeFromFeesChange(account, excluded);
794 	}
795 	function excludeFromDividends(address account) external onlyOwner {
796 		dividendTracker.excludeFromDividends(account);
797 	}
798 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
799 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "REIT: Account is already the value of 'excluded'");
800 		_isExcludedFromMaxWalletLimit[account] = excluded;
801 		emit ExcludeFromMaxWalletChange(account, excluded);
802 	}
803 	function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
804 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "REIT: Account is already the value of 'excluded'");
805 		_isExcludedFromMaxTransactionLimit[account] = excluded;
806 		emit ExcludeFromMaxTransactionChange(account, excluded);
807 	}
808 	function setWallets(address newLiquidityWallet, address newMarketingWallet, address newTreasuryWallet, address newCapitalWallet) external onlyOwner {
809 		if(liquidityWallet != newLiquidityWallet) {
810 			require(newLiquidityWallet != address(0), "REIT: The liquidityWallet cannot be 0");
811 			emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
812 			liquidityWallet = newLiquidityWallet;
813 		}
814         if(marketingWallet != newMarketingWallet) {
815 			require(newMarketingWallet != address(0), "REIT: The marketingWallet cannot be 0");
816 			emit WalletChange('marketingWallet', newMarketingWallet, marketingWallet);
817 			marketingWallet = newMarketingWallet;
818 		}
819 		if(treasuryWallet != newTreasuryWallet) {
820 			require(newTreasuryWallet != address(0), "REIT: The treasuryWallet cannot be 0");
821 			emit WalletChange('treasuryWallet', newTreasuryWallet, treasuryWallet);
822 			treasuryWallet = newTreasuryWallet;
823 		}
824 		if(capitalWallet != newCapitalWallet) {
825 			require(newCapitalWallet != address(0), "REIT: The capitalWallet cannot be 0");
826 			emit WalletChange('capitalWallet', newCapitalWallet, capitalWallet);
827 			capitalWallet = newCapitalWallet;
828 		}
829 	}
830 	// Base Fees
831 	function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _marketingFeeOnBuy, uint8 _treasuryFeeOnBuy, uint8 _capitalFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
832 		_setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _marketingFeeOnBuy, _treasuryFeeOnBuy, _capitalFeeOnBuy, _holdersFeeOnBuy);
833 		emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _marketingFeeOnBuy, _treasuryFeeOnBuy, _capitalFeeOnBuy, _holdersFeeOnBuy);
834 	}
835 	function setBaseFeesOnSell(uint8 _liquidityFeeOnSell, uint8 _marketingFeeOnSell, uint8 _treasuryFeeOnSell, uint8 _capitalFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
836 		_setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _marketingFeeOnSell, _treasuryFeeOnSell, _capitalFeeOnSell, _holdersFeeOnSell);
837 		emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _marketingFeeOnSell, _treasuryFeeOnSell, _capitalFeeOnSell, _holdersFeeOnSell);
838 	}
839 	function setUniswapRouter(address newAddress) external onlyOwner {
840 		require(newAddress != address(uniswapV2Router), "REIT: The router already has that address");
841 		emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
842 		uniswapV2Router = IRouter(newAddress);
843 	}
844 	function setMaxWalletAmount(uint256 newValue) external onlyOwner {
845 		require(newValue != maxWalletAmount, "REIT: Cannot update maxWalletAmount to same value");
846 		emit MaxWalletAmountChange(newValue, maxWalletAmount);
847 		maxWalletAmount = newValue;
848 	}
849 	function setMaxTransactionAmount(bool isSell, uint256 newValue) external onlyOwner {
850 		if(isSell) {
851 			require(newValue != maxTxSellAmount, "REIT: Cannot update maxTxSellAmount to same value");
852 			emit MaxWalletAmountChange(newValue, maxTxSellAmount);
853 			maxTxSellAmount = newValue;
854 		} else {
855 			require(newValue != maxTxBuyAmount, "REIT: Cannot update maxTxBuyAmount to same value");
856 			emit MaxWalletAmountChange(newValue, maxTxBuyAmount);
857 			maxTxBuyAmount = newValue;
858 		}
859 	}
860 	function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
861 		require(newValue != minimumTokensBeforeSwap, "REIT: Cannot update minimumTokensBeforeSwap to same value");
862 		emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
863 		minimumTokensBeforeSwap = newValue;
864 	}
865 	function claim() external {
866 		dividendTracker.processAccount(payable(msg.sender), false);
867 	}
868 	function claimETHOverflow() external onlyOwner {
869 	    uint256 amount = address(this).balance;
870         (bool success,) = address(owner()).call{value : amount}("");
871         if (success){
872             emit ClaimETHOverflow(amount);
873         }
874 	}
875 
876 	// Getters
877 	function getTotalDividendsDistributed() external view returns (uint256) {
878 		return dividendTracker.totalDividendsDistributed();
879 	}
880 	function getNumberOfDividendTokenHolders() external view returns(uint256) {
881 		return dividendTracker.getNumberOfTokenHolders();
882 	}
883 	function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8, uint8){
884 		return (_base.liquidityFeeOnBuy, _base.marketingFeeOnBuy, _base.treasuryFeeOnBuy, _base.capitalFeeOnBuy, _base.holdersFeeOnBuy);
885 	}
886 	function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8, uint8){
887 		return (_base.liquidityFeeOnSell, _base.marketingFeeOnSell, _base.treasuryFeeOnSell, _base.capitalFeeOnSell, _base.holdersFeeOnSell);
888 	}
889 
890 	// Main
891 	function _transfer(
892 		address from,
893 		address to,
894 		uint256 amount
895 		) internal override {
896 			require(from != address(0), "ERC20: transfer from the zero address");
897 			require(to != address(0), "ERC20: transfer to the zero address");
898 
899 			if(amount == 0) {
900 				super._transfer(from, to, 0);
901 				return;
902 			}
903 
904 		    if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
905 				require(isTradingEnabled, "REIT: Trading is currently disabled.");
906 				require(!_isBlocked[to], "REIT: Account is blocked");
907 				require(!_isBlocked[from], "REIT: Account is blocked");
908 				if (!_isExcludedFromMaxWalletLimit[to]) {
909 					require((balanceOf(to) + amount) <= maxWalletAmount, "REIT: Expected wallet amount exceeds the maxWalletAmount.");
910 				}
911 				if (!_isExcludedFromMaxTransactionLimit[to]) {
912 					require(amount <= maxTxBuyAmount, "REIT: Transfer amount exceeds the maxTxBuyAmount.");
913 				}
914 				if (!_isExcludedFromMaxTransactionLimit[from]) {
915 					require(amount <= maxTxSellAmount, "REIT: Transfer amount exceeds the maxTxSellAmount.");
916 				}
917 			}
918 
919 			_adjustTaxes(automatedMarketMakerPairs[from], automatedMarketMakerPairs[to], from, to);
920 			bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
921 
922 			if (
923 				isTradingEnabled &&
924 				canSwap &&
925 				!_swapping &&
926 				_totalFee > 0 &&
927 				automatedMarketMakerPairs[to]
928 			) {
929 				_swapping = true;
930 				_swapAndLiquify();
931 				_swapping = false;
932 			}
933 
934 			bool takeFee = !_swapping && isTradingEnabled;
935 
936 			if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
937 				takeFee = false;
938 			}
939 			if (takeFee && _totalFee > 0) {
940 				uint256 fee = amount * _totalFee / 100;
941 				amount = amount - fee;
942 				super._transfer(from, address(this), fee);
943 			}
944 
945 			super._transfer(from, to, amount);
946 
947 			try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
948 			try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
949 	}
950 	function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address from, address to) private {
951 		_liquidityFee = 0;
952 		_marketingFee = 0;
953 		_treasuryFee = 0;
954 		_capitalFee = 0;
955 		_holdersFee = 0;
956 
957 		if (isBuyFromLp) {
958 		    if ((block.number - _launchBlockNumber) <= 5) {
959 				_liquidityFee = 100;
960 			}
961 			else {
962 				_liquidityFee = _base.liquidityFeeOnBuy;
963 				_marketingFee = _base.marketingFeeOnBuy;
964 				_treasuryFee = _base.treasuryFeeOnBuy;
965 				_capitalFee = _base.capitalFeeOnBuy;
966 				_holdersFee = _base.holdersFeeOnBuy;
967 			}
968 		}
969 	    if (isSelltoLp) {
970 	    	_liquidityFee = _base.liquidityFeeOnSell;
971 			_marketingFee = _base.marketingFeeOnSell;
972 			_treasuryFee = _base.treasuryFeeOnSell;
973 			_capitalFee = _base.capitalFeeOnSell;
974 			_holdersFee = _base.holdersFeeOnSell;
975 		}
976 		if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
977 			_liquidityFee = _base.liquidityFeeOnSell;
978             _marketingFee = _base.marketingFeeOnSell;
979             _treasuryFee = _base.treasuryFeeOnSell;
980             _capitalFee = _base.capitalFeeOnSell;
981             _holdersFee = _base.holdersFeeOnSell;
982 		}
983 		_totalFee = _liquidityFee + _marketingFee + _treasuryFee + _capitalFee  + _holdersFee;
984 		emit FeesApplied(_liquidityFee, _marketingFee, _treasuryFee, _capitalFee, _holdersFee, _totalFee);
985 	}
986 	function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
987 		uint8 _liquidityFeeOnSell,
988 		uint8 _marketingFeeOnSell,
989 		uint8 _treasuryFeeOnSell,
990 		uint8 _capitalFeeOnSell,
991 		uint8 _holdersFeeOnSell
992 	) private {
993 		if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
994 			emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
995 			map.liquidityFeeOnSell = _liquidityFeeOnSell;
996 		}
997 		if (map.marketingFeeOnSell != _marketingFeeOnSell) {
998 			emit CustomTaxPeriodChange(_marketingFeeOnSell, map.marketingFeeOnSell, 'marketingFeeOnSell', map.periodName);
999 			map.marketingFeeOnSell = _marketingFeeOnSell;
1000 		}
1001 		if (map.treasuryFeeOnSell != _treasuryFeeOnSell) {
1002 			emit CustomTaxPeriodChange(_treasuryFeeOnSell, map.treasuryFeeOnSell, 'treasuryFeeOnSell', map.periodName);
1003 			map.treasuryFeeOnSell = _treasuryFeeOnSell;
1004 		}
1005 		if (map.capitalFeeOnSell != _capitalFeeOnSell) {
1006 			emit CustomTaxPeriodChange(_capitalFeeOnSell, map.capitalFeeOnSell, 'capitalFeeOnSell', map.periodName);
1007 			map.capitalFeeOnSell = _capitalFeeOnSell;
1008 		}
1009 		if (map.holdersFeeOnSell != _holdersFeeOnSell) {
1010 			emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
1011 			map.holdersFeeOnSell = _holdersFeeOnSell;
1012 		}
1013 	}
1014 	function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
1015 		uint8 _liquidityFeeOnBuy,
1016 		uint8 _marketingFeeOnBuy,
1017 		uint8 _treasuryFeeOnBuy,
1018 		uint8 _capitalFeeOnBuy,
1019 		uint8 _holdersFeeOnBuy
1020 		) private {
1021 		if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
1022 			emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
1023 			map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
1024 		}
1025 		if (map.marketingFeeOnBuy != _marketingFeeOnBuy) {
1026 			emit CustomTaxPeriodChange(_marketingFeeOnBuy, map.marketingFeeOnBuy, 'marketingFeeOnBuy', map.periodName);
1027 			map.marketingFeeOnBuy = _marketingFeeOnBuy;
1028 		}
1029 		if (map.treasuryFeeOnBuy != _treasuryFeeOnBuy) {
1030 			emit CustomTaxPeriodChange(_treasuryFeeOnBuy, map.treasuryFeeOnBuy, 'treasuryFeeOnBuy', map.periodName);
1031 			map.treasuryFeeOnBuy = _treasuryFeeOnBuy;
1032 		}
1033 		if (map.capitalFeeOnBuy != _capitalFeeOnBuy) {
1034 			emit CustomTaxPeriodChange(_capitalFeeOnBuy, map.capitalFeeOnBuy, 'capitalFeeOnBuy', map.periodName);
1035 			map.capitalFeeOnBuy = _capitalFeeOnBuy;
1036 		}
1037 		if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
1038 			emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
1039 			map.holdersFeeOnBuy = _holdersFeeOnBuy;
1040 		}
1041 	}
1042 	function _swapAndLiquify() private {
1043 		uint256 contractBalance = balanceOf(address(this));
1044 		uint256 initialETHBalance = address(this).balance;
1045 
1046 		uint8 totalFeePrior = _totalFee;
1047 
1048 		uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFee / 2;
1049 		uint256 amountToSwap = contractBalance - amountToLiquify;
1050 
1051 		_swapTokensForETH(amountToSwap);
1052 
1053 		uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
1054 		uint256 totalETHFee = _totalFee - (_liquidityFee / 2);
1055 
1056 		uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
1057 		uint256 amountETHMarketing = ETHBalanceAfterSwap * _marketingFee / totalETHFee;
1058 		uint256 amountETHTreasury = ETHBalanceAfterSwap * _treasuryFee / totalETHFee;
1059 		uint256 amountETHCapital = ETHBalanceAfterSwap * _capitalFee / totalETHFee;
1060 		uint256 amountETHHolders = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHMarketing + amountETHTreasury + amountETHCapital);
1061 
1062 		payable(treasuryWallet).transfer(amountETHTreasury);
1063 
1064 		_swapETHForCustomToken(amountETHMarketing, USDT, marketingWallet);
1065 		_swapETHForCustomToken(amountETHCapital, USDT, capitalWallet);
1066 
1067 		if (amountToLiquify > 0) {
1068 			_addLiquidity(amountToLiquify, amountETHLiquidity);
1069 			emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
1070 		}
1071 
1072 		(bool dividendSuccess,) = address(dividendTracker).call{value: amountETHHolders}("");
1073 		if(dividendSuccess) {
1074 			emit DividendsSent(amountETHHolders);
1075 		}
1076 
1077 		_totalFee = totalFeePrior;
1078 	}
1079 	function _swapETHForCustomToken(uint256 ethAmount, address token, address wallet) private {
1080         address[] memory path = new address[](2);
1081 		path[0] = uniswapV2Router.WETH();
1082 		path[1] = token;
1083 
1084 		uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : ethAmount}(
1085 		0, // accept any amount of ETH
1086 		path,
1087 		address(wallet),
1088 		block.timestamp
1089 		);
1090     }
1091 	function _swapTokensForETH(uint256 tokenAmount) private {
1092 		address[] memory path = new address[](2);
1093 		path[0] = address(this);
1094 		path[1] = uniswapV2Router.WETH();
1095 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1096 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1097 			tokenAmount,
1098 			0, // accept any amount of ETH
1099 			path,
1100 			address(this),
1101 			block.timestamp
1102 		);
1103 	}
1104 	function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1105 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1106 		uniswapV2Router.addLiquidityETH{value: ethAmount}(
1107 			address(this),
1108 			tokenAmount,
1109 			0, // slippage is unavoidable
1110 			0, // slippage is unavoidable
1111 			liquidityWallet,
1112 			block.timestamp
1113 		);
1114 	}
1115 }
1116 
1117 contract REITDividendTracker is DividendPayingToken {
1118 	using SafeMath for uint256;
1119 	using SafeMathInt for int256;
1120 	using IterableMapping for IterableMapping.Map;
1121 
1122 	IterableMapping.Map private tokenHoldersMap;
1123 
1124 	uint256 public lastProcessedIndex;
1125 	mapping (address => bool) public excludedFromDividends;
1126 	mapping (address => uint256) public lastClaimTimes;
1127 	uint256 public claimWait;
1128 	uint256 public minimumTokenBalanceForDividends;
1129 
1130 	event ExcludeFromDividends(address indexed account);
1131 	event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1132 	event Claim(address indexed account, uint256 amount, bool indexed automatic);
1133 
1134 	constructor() DividendPayingToken("REIT_Dividend_Tracker", "REIT_Dividend_Tracker") {
1135 		claimWait = 3600;
1136 		minimumTokenBalanceForDividends = 0 * (10**18);
1137 	}
1138 	function _transfer(address, address, uint256) internal pure override {
1139 		require(false, "REIT_Dividend_Tracker: No transfers allowed");
1140 	}
1141 	function excludeFromDividends(address account) external onlyOwner {
1142 		require(!excludedFromDividends[account]);
1143 		excludedFromDividends[account] = true;
1144 		_setBalance(account, 0);
1145 		tokenHoldersMap.remove(account);
1146 		emit ExcludeFromDividends(account);
1147 	}
1148 	function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1149 		require(minimumTokenBalanceForDividends != newValue, "REIT_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'.");
1150 		minimumTokenBalanceForDividends = newValue;
1151 	}
1152 	function getNumberOfTokenHolders() external view returns(uint256) {
1153 		return tokenHoldersMap.keys.length;
1154 	}
1155 	function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1156 		if(excludedFromDividends[account]) {
1157 			return;
1158 		}
1159 		if(newBalance >= minimumTokenBalanceForDividends) {
1160 			_setBalance(account, newBalance);
1161 			tokenHoldersMap.set(account, newBalance);
1162 		}
1163 		else {
1164 			_setBalance(account, 0);
1165 			tokenHoldersMap.remove(account);
1166 		}
1167 		processAccount(account, true);
1168 	}
1169 	function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1170 		uint256 amount = _withdrawDividendOfUser(account);
1171 		if(amount > 0) {
1172 			lastClaimTimes[account] = block.timestamp;
1173 			emit Claim(account, amount, automatic);
1174 			return true;
1175 		}
1176 		return false;
1177 	}
1178 }