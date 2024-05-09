1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
4 
5 interface IFactory {
6 	function createPair(address tokenA, address tokenB)
7 	external
8 	returns (address pair);
9 
10 	function getPair(address tokenA, address tokenB)
11 	external
12 	view
13 	returns (address pair);
14 }
15 
16 interface IRouter {
17 	function factory() external pure returns (address);
18 
19 	function WETH() external pure returns (address);
20 
21 	function addLiquidityETH(
22 		address token,
23 		uint256 amountTokenDesired,
24 		uint256 amountTokenMin,
25 		uint256 amountETHMin,
26 		address to,
27 		uint256 deadline
28 	)
29 	external
30 	payable
31 	returns (
32 		uint256 amountToken,
33 		uint256 amountETH,
34 		uint256 liquidity
35 	);
36 
37 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
38 		uint256 amountOutMin,
39 		address[] calldata path,
40 		address to,
41 		uint256 deadline
42 	) external payable;
43 
44 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
45 		uint256 amountIn,
46 		uint256 amountOutMin,
47 		address[] calldata path,
48 		address to,
49 		uint256 deadline
50 	) external;
51 
52     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
53 }
54 
55 interface IERC20 {
56 	function totalSupply() external view returns (uint256);
57 	function balanceOf(address account) external view returns (uint256);
58 	function transfer(address recipient, uint256 amount) external returns (bool);
59 	function allowance(address owner, address spender) external view returns (uint256);
60 	function approve(address spender, uint256 amount) external returns (bool);
61 
62 	function transferFrom(
63 		address sender,
64 		address recipient,
65 		uint256 amount
66 	) external returns (bool);
67 
68 	event Transfer(address indexed from, address indexed to, uint256 value);
69 	event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 interface IERC20Metadata is IERC20 {
73 	function name() external view returns (string memory);
74 	function symbol() external view returns (string memory);
75 	function decimals() external view returns (uint8);
76 }
77 
78 interface DividendPayingTokenInterface {
79 	function dividendOf(address _owner) external view returns(uint256);
80 	function distributeDividends() external payable;
81 	function withdrawDividend() external;
82 	event DividendsDistributed(
83 		address indexed from,
84 		uint256 weiAmount
85 	);
86 	event DividendWithdrawn(
87 		address indexed to,
88 		uint256 weiAmount
89 	);
90 }
91 
92 interface DividendPayingTokenOptionalInterface {
93 	function withdrawableDividendOf(address _owner) external view returns(uint256);
94 	function withdrawnDividendOf(address _owner) external view returns(uint256);
95 	function accumulativeDividendOf(address _owner) external view returns(uint256);
96 }
97 
98 library SafeMath {
99 
100 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
101 		uint256 c = a + b;
102 		require(c >= a, "SafeMath: addition overflow");
103 
104 		return c;
105 	}
106 
107 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108 		return sub(a, b, "SafeMath: subtraction overflow");
109 	}
110 
111 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112 		require(b <= a, errorMessage);
113 		uint256 c = a - b;
114 
115 		return c;
116 	}
117 
118 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120 		// benefit is lost if 'b' is also tested.
121 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122 		if (a == 0) {
123 			return 0;
124 		}
125 
126 		uint256 c = a * b;
127 		require(c / a == b, "SafeMath: multiplication overflow");
128 
129 		return c;
130 	}
131 
132 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
133 		return div(a, b, "SafeMath: division by zero");
134 	}
135 
136 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137 		require(b > 0, errorMessage);
138 		uint256 c = a / b;
139 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
140 
141 		return c;
142 	}
143 
144 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145 		return mod(a, b, "SafeMath: modulo by zero");
146 	}
147 
148 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149 		require(b != 0, errorMessage);
150 		return a % b;
151 	}
152 }
153 
154 library SafeMathInt {
155 	int256 private constant MIN_INT256 = int256(1) << 255;
156 	int256 private constant MAX_INT256 = ~(int256(1) << 255);
157 
158 	function mul(int256 a, int256 b) internal pure returns (int256) {
159 		int256 c = a * b;
160 
161 		// Detect overflow when multiplying MIN_INT256 with -1
162 		require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
163 		require((b == 0) || (c / b == a));
164 		return c;
165 	}
166 	function div(int256 a, int256 b) internal pure returns (int256) {
167 		// Prevent overflow when dividing MIN_INT256 by -1
168 		require(b != -1 || a != MIN_INT256);
169 
170 		// Solidity already throws when dividing by 0.
171 		return a / b;
172 	}
173 	function sub(int256 a, int256 b) internal pure returns (int256) {
174 		int256 c = a - b;
175 		require((b >= 0 && c <= a) || (b < 0 && c > a));
176 		return c;
177 	}
178 	function add(int256 a, int256 b) internal pure returns (int256) {
179 		int256 c = a + b;
180 		require((b >= 0 && c >= a) || (b < 0 && c < a));
181 		return c;
182 	}
183 	function abs(int256 a) internal pure returns (int256) {
184 		require(a != MIN_INT256);
185 		return a < 0 ? -a : a;
186 	}
187 	function toUint256Safe(int256 a) internal pure returns (uint256) {
188 		require(a >= 0);
189 		return uint256(a);
190 	}
191 }
192 
193 library SafeMathUint {
194 	function toInt256Safe(uint256 a) internal pure returns (int256) {
195 		int256 b = int256(a);
196 		require(b >= 0);
197 		return b;
198 	}
199 }
200 
201 library IterableMapping {
202 	struct Map {
203 		address[] keys;
204 		mapping(address => uint) values;
205 		mapping(address => uint) indexOf;
206 		mapping(address => bool) inserted;
207 	}
208 
209 	function get(Map storage map, address key) public view returns (uint) {
210 		return map.values[key];
211 	}
212 
213 	function getIndexOfKey(Map storage map, address key) public view returns (int) {
214 		if(!map.inserted[key]) {
215 			return -1;
216 		}
217 		return int(map.indexOf[key]);
218 	}
219 
220 	function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
221 		return map.keys[index];
222 	}
223 
224 	function size(Map storage map) public view returns (uint) {
225 		return map.keys.length;
226 	}
227 
228 	function set(Map storage map, address key, uint val) public {
229 		if (map.inserted[key]) {
230 			map.values[key] = val;
231 		} else {
232 			map.inserted[key] = true;
233 			map.values[key] = val;
234 			map.indexOf[key] = map.keys.length;
235 			map.keys.push(key);
236 		}
237 	}
238 
239 	function remove(Map storage map, address key) public {
240 		if (!map.inserted[key]) {
241 			return;
242 		}
243 
244 		delete map.inserted[key];
245 		delete map.values[key];
246 
247 		uint index = map.indexOf[key];
248 		uint lastIndex = map.keys.length - 1;
249 		address lastKey = map.keys[lastIndex];
250 
251 		map.indexOf[lastKey] = index;
252 		delete map.indexOf[key];
253 
254 		map.keys[index] = lastKey;
255 		map.keys.pop();
256 	}
257 }
258 
259 abstract contract Context {
260 	function _msgSender() internal view virtual returns (address) {
261 		return msg.sender;
262 	}
263 
264 	function _msgData() internal view virtual returns (bytes calldata) {
265 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
266 		return msg.data;
267 	}
268 }
269 
270 contract Ownable is Context {
271 	address private _owner;
272 
273 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275 	constructor () {
276 		address msgSender = _msgSender();
277 		_owner = msgSender;
278 		emit OwnershipTransferred(address(0), msgSender);
279 	}
280 
281 	function owner() public view returns (address) {
282 		return _owner;
283 	}
284 
285 	modifier onlyOwner() {
286 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
287 		_;
288 	}
289 
290 	function renounceOwnership() public virtual onlyOwner {
291 		emit OwnershipTransferred(_owner, address(0));
292 		_owner = address(0);
293 	}
294 
295 	function transferOwnership(address newOwner) public virtual onlyOwner {
296 		require(newOwner != address(0), "Ownable: new owner is the zero address");
297 		emit OwnershipTransferred(_owner, newOwner);
298 		_owner = newOwner;
299 	}
300 }
301 
302 contract ERC20 is Context, IERC20, IERC20Metadata {
303 	using SafeMath for uint256;
304 
305 	mapping(address => uint256) private _balances;
306 	mapping(address => mapping(address => uint256)) private _allowances;
307 
308 	uint256 private _totalSupply;
309 	string private _name;
310 	string private _symbol;
311 
312 	constructor(string memory name_, string memory symbol_) {
313 		_name = name_;
314 		_symbol = symbol_;
315 	}
316 
317 	function name() public view virtual override returns (string memory) {
318 		return _name;
319 	}
320 
321 	function symbol() public view virtual override returns (string memory) {
322 		return _symbol;
323 	}
324 
325 	function decimals() public view virtual override returns (uint8) {
326 		return 18;
327 	}
328 
329 	function totalSupply() public view virtual override returns (uint256) {
330 		return _totalSupply;
331 	}
332 
333 	function balanceOf(address account) public view virtual override returns (uint256) {
334 		return _balances[account];
335 	}
336 
337 	function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
338 		_transfer(_msgSender(), recipient, amount);
339 		return true;
340 	}
341 
342 	function allowance(address owner, address spender) public view virtual override returns (uint256) {
343 		return _allowances[owner][spender];
344 	}
345 
346 	function approve(address spender, uint256 amount) public virtual override returns (bool) {
347 		_approve(_msgSender(), spender, amount);
348 		return true;
349 	}
350 
351 	function transferFrom(
352 		address sender,
353 		address recipient,
354 		uint256 amount
355 	) public virtual override returns (bool) {
356 		_transfer(sender, recipient, amount);
357 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
358 		return true;
359 	}
360 
361 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
362 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
363 		return true;
364 	}
365 
366 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
367 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
368 		return true;
369 	}
370 
371 	function _transfer(
372 		address sender,
373 		address recipient,
374 		uint256 amount
375 	) internal virtual {
376 		require(sender != address(0), "ERC20: transfer from the zero address");
377 		require(recipient != address(0), "ERC20: transfer to the zero address");
378 		_beforeTokenTransfer(sender, recipient, amount);
379 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
380 		_balances[recipient] = _balances[recipient].add(amount);
381 		emit Transfer(sender, recipient, amount);
382 	}
383 
384 	function _mint(address account, uint256 amount) internal virtual {
385 		require(account != address(0), "ERC20: mint to the zero address");
386 		_beforeTokenTransfer(address(0), account, amount);
387 		_totalSupply = _totalSupply.add(amount);
388 		_balances[account] = _balances[account].add(amount);
389 		emit Transfer(address(0), account, amount);
390 	}
391 
392 	function _burn(address account, uint256 amount) internal virtual {
393 		require(account != address(0), "ERC20: burn from the zero address");
394 		_beforeTokenTransfer(account, address(0), amount);
395 		_balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
396 		_totalSupply = _totalSupply.sub(amount);
397 		emit Transfer(account, address(0), amount);
398 	}
399 
400 	function _approve(
401 		address owner,
402 		address spender,
403 		uint256 amount
404 	) internal virtual {
405 		require(owner != address(0), "ERC20: approve from the zero address");
406 		require(spender != address(0), "ERC20: approve to the zero address");
407 		_allowances[owner][spender] = amount;
408 		emit Approval(owner, spender, amount);
409 	}
410 
411 	function _beforeTokenTransfer(
412 		address from,
413 		address to,
414 		uint256 amount
415 	) internal virtual {}
416 }
417 
418 contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
419 	using SafeMath for uint256;
420 	using SafeMathUint for uint256;
421 	using SafeMathInt for int256;
422 
423 	uint256 constant internal magnitude = 2**128;
424 	uint256 internal magnifiedDividendPerShare;
425 	uint256 public totalDividendsDistributed;
426 	address public rewardToken;
427 	IRouter public uniswapV2Router;
428 
429 	mapping(address => int256) internal magnifiedDividendCorrections;
430 	mapping(address => uint256) internal withdrawnDividends;
431 
432 	constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
433 
434     receive() external payable {
435         distributeDividends();
436     }
437 
438     function distributeDividends() public override onlyOwner payable {
439         require(totalSupply() > 0);
440         if (msg.value > 0) {
441             magnifiedDividendPerShare = magnifiedDividendPerShare.add((msg.value).mul(magnitude) / totalSupply());
442             emit DividendsDistributed(msg.sender, msg.value);
443             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
444         }
445     }
446     function withdrawDividend() public virtual override onlyOwner {
447         _withdrawDividendOfUser(payable(msg.sender));
448     }
449     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
450         uint256 _withdrawableDividend = withdrawableDividendOf(user);
451         if (_withdrawableDividend > 0) {
452             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
453             emit DividendWithdrawn(user, _withdrawableDividend);
454             return swapETHForTokensAndWithdrawDividend(user, _withdrawableDividend);
455         }
456         return 0;
457     }
458     function swapETHForTokensAndWithdrawDividend(address holder, uint256 ethAmount) private returns(uint256) {
459         address[] memory path = new address[](2);
460         path[0] = uniswapV2Router.WETH();
461         path[1] = address(rewardToken);
462 
463         try uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : ethAmount}(
464         0, // accept any amount of tokens
465         path,
466         address(holder),
467         block.timestamp
468         ) {
469             return ethAmount;
470         } catch {
471             withdrawnDividends[holder] = withdrawnDividends[holder].sub(ethAmount);
472             return 0;
473         }
474     }
475     function dividendOf(address _owner) public view override returns(uint256) {
476          return withdrawableDividendOf(_owner);
477     }
478     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
479         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
480     }
481     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
482         return withdrawnDividends[_owner];
483     }
484     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
485         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
486         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
487     }
488     function _transfer(address from, address to, uint256 value) internal virtual override {
489         require(false);
490         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
491         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
492         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
493     }
494     function _mint(address account, uint256 value) internal override {
495         super._mint(account, value);
496         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
497         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
498     }
499     function _burn(address account, uint256 value) internal override {
500         super._burn(account, value);
501         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
502         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
503     }
504     function _setBalance(address account, uint256 newBalance) internal {
505         uint256 currentBalance = balanceOf(account);
506         if(newBalance > currentBalance) {
507              uint256 mintAmount = newBalance.sub(currentBalance);
508             _mint(account, mintAmount);
509         } else if(newBalance < currentBalance) {
510             uint256 burnAmount = currentBalance.sub(newBalance);
511             _burn(account, burnAmount);
512         }
513     }
514     function _setRewardToken(address token) internal onlyOwner {
515         rewardToken = token;
516     }
517     function _setUniswapRouter(address router) internal onlyOwner {
518         uniswapV2Router = IRouter(router);
519     }
520 }
521 
522 contract BaconToken is ERC20, Ownable {
523     IRouter public uniswapV2Router;
524     address public immutable uniswapV2Pair;
525 
526     string private constant _name = "Bacon Token";
527     string private constant _symbol = "BACON";
528     uint8 private constant _decimals = 18;
529 
530     BACONDividendTracker public dividendTracker;
531 
532     bool public isTradingEnabled;
533 
534     // initialSupply
535     uint256 constant initialSupply = 1000000 * (10**18);
536 
537     // max wallet is 2.0% of initialSupply
538     uint256 public maxWalletAmount = initialSupply * 200 / 10000;
539     // max buy and sell tx is 1.0 % of initialSupply
540     uint256 public maxTxAmount = initialSupply * 100 / 10000;
541 
542     bool private _swapping;
543     uint256 public minimumTokensBeforeSwap = initialSupply * 50 / 100000;
544     uint256 public gasForProcessing = 300000;
545 
546     address public liquidityWallet;
547     address public operationsWallet;
548     address public buyBackWallet;
549     address public treasuryWallet;
550 
551     struct CustomTaxPeriod {
552         bytes23 periodName;
553         uint8 blocksInPeriod;
554         uint256 timeInPeriod;
555         uint8 liquidityFeeOnBuy;
556         uint8 liquidityFeeOnSell;
557         uint8 operationsFeeOnBuy;
558         uint8 operationsFeeOnSell;
559         uint8 buyBackFeeOnBuy;
560         uint8 buyBackFeeOnSell;
561         uint8 treasuryFeeOnBuy;
562         uint8 treasuryFeeOnSell;
563         uint8 holdersFeeOnBuy;
564         uint8 holdersFeeOnSell;
565     }
566 
567     // Launch taxes
568     bool private _isLaunched;
569     uint256 private _launchStartTimestamp;
570     uint256 private _launchBlockNumber;
571 
572     // Base taxes
573     CustomTaxPeriod private _base = CustomTaxPeriod('base',0,0,2,2,3,3,3,3,3,3,4,4);
574 
575     mapping (address => bool) private _isExcludedFromFee;
576     mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
577     mapping (address => bool) private _isExcludedFromMaxWalletLimit;
578     mapping (address => bool) private _isBlocked;
579     mapping (address => bool) private _isAllowedToTradeWhenDisabled;
580     mapping (address => bool) private _feeOnSelectedWalletTransfers;
581     mapping (address => bool) public automatedMarketMakerPairs;
582 
583     uint8 private _liquidityFee;
584     uint8 private _operationsFee;
585     uint8 private _buyBackFee;
586     uint8 private _treasuryFee;
587     uint8 private _holdersFee;
588     uint8 private _totalFee;
589 
590     event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
591     event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
592     event WalletChange(string indexed indentifier, address indexed newWallet, address indexed oldWallet);
593     event FeeChange(string indexed identifier, uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee, uint8 treasuryFee, uint8 holdersFee);
594     event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
595     event BlockedAccountChange(address indexed holder, bool indexed status);
596     event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
597     event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
598     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
599     event ExcludeFromFeesChange(address indexed account, bool isExcluded);
600     event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
601     event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
602     event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
603     event DividendsSent(uint256 tokensSwapped);
604     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
605     event FeeOnSelectedWalletTransfersChange(address indexed account, bool newValue);
606     event ClaimETHOverflow(uint256 amount);
607     event ProcessedDividendTracker(
608         uint256 iterations,
609         uint256 claims,
610         uint256 lastProcessedIndex,
611         bool indexed automatic,
612         uint256 gas,
613         address indexed processor
614     );
615     event FeesApplied(uint8 liquidityFee, uint8 operationsFee, uint8 buyBackFee, uint8 treasuryFee, uint8 holdersFee, uint256 totalFee);
616 
617     constructor() ERC20(_name, _symbol) {
618         dividendTracker = new BACONDividendTracker();
619         dividendTracker.setUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
620         dividendTracker.setRewardToken(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48));
621 
622         liquidityWallet = owner();
623         operationsWallet = owner();
624         buyBackWallet = owner();
625         treasuryWallet = owner();
626 
627         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Mainnet
628         address _uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
629         uniswapV2Router = _uniswapV2Router;
630         uniswapV2Pair = _uniswapV2Pair;
631         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
632 
633         _isExcludedFromFee[owner()] = true;
634         _isExcludedFromFee[address(this)] = true;
635         _isExcludedFromFee[address(dividendTracker)] = true;
636 
637         dividendTracker.excludeFromDividends(address(dividendTracker));
638         dividendTracker.excludeFromDividends(address(this));
639         dividendTracker.excludeFromDividends(owner());
640         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
641 
642         _isAllowedToTradeWhenDisabled[owner()] = true;
643 
644         _isExcludedFromMaxTransactionLimit[address(dividendTracker)] = true;
645         _isExcludedFromMaxTransactionLimit[address(this)] = true;
646 
647         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
648         _isExcludedFromMaxWalletLimit[address(dividendTracker)] = true;
649         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
650         _isExcludedFromMaxWalletLimit[address(this)] = true;
651         _isExcludedFromMaxWalletLimit[owner()] = true;
652 
653         _mint(owner(), initialSupply);
654     }
655 
656     receive() external payable {}
657 
658     // Setters
659     function activateTrading() external onlyOwner {
660         isTradingEnabled = true;
661         if(_launchBlockNumber == 0) {
662             _launchBlockNumber = block.number;
663             _launchStartTimestamp = block.timestamp;
664             _isLaunched = true;
665         }
666     }
667     function deactivateTrading() external onlyOwner {
668         isTradingEnabled = false;
669     }
670     function allowTradingWhenDisabled(address account, bool allowed) external onlyOwner {
671 		_isAllowedToTradeWhenDisabled[account] = allowed;
672 		emit AllowedWhenTradingDisabledChange(account, allowed);
673 	}
674     function _setAutomatedMarketMakerPair(address pair, bool value) private {
675         require(automatedMarketMakerPairs[pair] != value, "BACON: Automated market maker pair is already set to that value");
676         automatedMarketMakerPairs[pair] = value;
677         if(value) {
678             dividendTracker.excludeFromDividends(pair);
679         }
680         emit AutomatedMarketMakerPairChange(pair, value);
681     }
682     function excludeFromFees(address account, bool excluded) external onlyOwner {
683         require(_isExcludedFromFee[account] != excluded, "BACON: Account is already the value of 'excluded'");
684         _isExcludedFromFee[account] = excluded;
685         emit ExcludeFromFeesChange(account, excluded);
686     }
687     function excludeFromDividends(address account) external onlyOwner {
688         dividendTracker.excludeFromDividends(account);
689     }
690     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
691         require(_isExcludedFromMaxTransactionLimit[account] != excluded, "BACON: Account is already the value of 'excluded'");
692         _isExcludedFromMaxTransactionLimit[account] = excluded;
693         emit ExcludeFromMaxTransferChange(account, excluded);
694     }
695     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
696         require(_isExcludedFromMaxWalletLimit[account] != excluded, "BACON: Account is already the value of 'excluded'");
697         _isExcludedFromMaxWalletLimit[account] = excluded;
698         emit ExcludeFromMaxWalletChange(account, excluded);
699     }
700     function blockAccount(address account) external onlyOwner {
701         require(!_isBlocked[account], "BACON: Account is already blocked");
702         if (_isLaunched) {
703             require((block.timestamp - _launchStartTimestamp) < 172800, "BACON: Time to block accounts has expired");
704         }
705         _isBlocked[account] = true;
706         emit BlockedAccountChange(account, true);
707     }
708     function unblockAccount(address account) external onlyOwner {
709         require(_isBlocked[account], "BACON: Account is not blocked");
710         _isBlocked[account] = false;
711         emit BlockedAccountChange(account, false);
712     }
713     function setFeeOnSelectedWalletTransfers(address account, bool value) external onlyOwner {
714 		require(_feeOnSelectedWalletTransfers[account] != value, "BACON: The selected wallet is already set to the value ");
715 		_feeOnSelectedWalletTransfers[account] = value;
716 		emit FeeOnSelectedWalletTransfersChange(account, value);
717 	}
718     function setWallets(address newLiquidityWallet, address newOperationsWallet, address newBuyBackWallet, address newTreasuryWallet) external onlyOwner {
719         if(liquidityWallet != newLiquidityWallet) {
720             require(newLiquidityWallet != address(0), "BACON: The liquidityWallet cannot be 0");
721             emit WalletChange('liquidityWallet', newLiquidityWallet, liquidityWallet);
722             liquidityWallet = newLiquidityWallet;
723         }
724         if(operationsWallet != newOperationsWallet) {
725             require(newOperationsWallet != address(0), "BACON: The operationsWallet cannot be 0");
726             emit WalletChange('operationsWallet', newOperationsWallet, operationsWallet);
727             operationsWallet = newOperationsWallet;
728         }
729         if(buyBackWallet != newBuyBackWallet) {
730             require(newBuyBackWallet != address(0), "BACON: The buyBackWallet cannot be 0");
731             emit WalletChange('buyBackWallet', newBuyBackWallet, buyBackWallet);
732             buyBackWallet = newBuyBackWallet;
733         }
734         if(treasuryWallet != newTreasuryWallet) {
735             require(newTreasuryWallet != address(0), "BACON: The treasuryWallet cannot be 0");
736             emit WalletChange('treasuryWallet', newTreasuryWallet, treasuryWallet);
737             treasuryWallet = newTreasuryWallet;
738         }
739     }
740     // Base fees
741     function setBaseFeesOnBuy(uint8 _liquidityFeeOnBuy, uint8 _operationsFeeOnBuy, uint8 _buyBackFeeOnBuy, uint8 _treasuryFeeOnBuy, uint8 _holdersFeeOnBuy) external onlyOwner {
742         _setCustomBuyTaxPeriod(_base, _liquidityFeeOnBuy, _operationsFeeOnBuy, _buyBackFeeOnBuy, _treasuryFeeOnBuy, _holdersFeeOnBuy);
743         emit FeeChange('baseFees-Buy', _liquidityFeeOnBuy, _operationsFeeOnBuy, _buyBackFeeOnBuy, _treasuryFeeOnBuy, _holdersFeeOnBuy);
744     }
745     function setBaseFeesOnSell(uint8 _liquidityFeeOnSell,uint8 _operationsFeeOnSell , uint8 _buyBackFeeOnSell, uint8 _treasuryFeeOnSell, uint8 _holdersFeeOnSell) external onlyOwner {
746         _setCustomSellTaxPeriod(_base, _liquidityFeeOnSell, _operationsFeeOnSell, _buyBackFeeOnSell, _treasuryFeeOnSell, _holdersFeeOnSell);
747         emit FeeChange('baseFees-Sell', _liquidityFeeOnSell, _operationsFeeOnSell, _buyBackFeeOnSell, _treasuryFeeOnSell, _holdersFeeOnSell);
748     }
749     function setUniswapRouter(address newAddress) external onlyOwner {
750         require(newAddress != address(uniswapV2Router), "BACON: The router already has that address");
751         emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
752         uniswapV2Router = IRouter(newAddress);
753         dividendTracker.setUniswapRouter(newAddress);
754     }
755     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
756         require(newValue != maxTxAmount, "BACON: Cannot update maxTxAmount to same value");
757         emit MaxTransactionAmountChange(newValue, maxTxAmount);
758         maxTxAmount = newValue;
759     }
760     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
761         require(newValue != maxWalletAmount, "BACON: Cannot update maxWalletAmount to same value");
762         emit MaxWalletAmountChange(newValue, maxWalletAmount);
763         maxWalletAmount = newValue;
764     }
765     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
766         require(newValue != minimumTokensBeforeSwap, "BACON: Cannot update minimumTokensBeforeSwap to same value");
767         emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
768         minimumTokensBeforeSwap = newValue;
769     }
770     function setMinimumTokenBalanceForDividends(uint256 newValue) external onlyOwner {
771         dividendTracker.setTokenBalanceForDividends(newValue);
772     }
773     function claim() external {
774         dividendTracker.processAccount(payable(msg.sender), false);
775     }
776     function claimETHOverflow() external onlyOwner {
777         uint256 amount = address(this).balance;
778         (bool success,) = address(owner()).call{value : amount}("");
779         if (success){
780             emit ClaimETHOverflow(amount);
781         }
782     }
783 
784     // Getters
785     function getTotalDividendsDistributed() external view returns (uint256) {
786         return dividendTracker.totalDividendsDistributed();
787     }
788     function withdrawableDividendOf(address account) public view returns(uint256) {
789         return dividendTracker.withdrawableDividendOf(account);
790     }
791     function getNumberOfDividendTokenHolders() external view returns(uint256) {
792         return dividendTracker.getNumberOfTokenHolders();
793     }
794     function getBaseBuyFees() external view returns (uint8, uint8, uint8, uint8, uint8) {
795         return (_base.liquidityFeeOnBuy, _base.operationsFeeOnBuy, _base.buyBackFeeOnBuy, _base.treasuryFeeOnBuy, _base.holdersFeeOnBuy);
796     }
797     function getBaseSellFees() external view returns (uint8, uint8, uint8, uint8, uint8) {
798         return (_base.liquidityFeeOnSell, _base.operationsFeeOnSell, _base.buyBackFeeOnSell, _base.treasuryFeeOnSell, _base.holdersFeeOnSell);
799     }
800 
801     // Main
802     function _transfer(
803         address from,
804         address to,
805         uint256 amount
806         ) internal override {
807         require(from != address(0), "ERC20: transfer from the zero address");
808         require(to != address(0), "ERC20: transfer to the zero address");
809 
810         if(amount == 0) {
811             super._transfer(from, to, 0);
812             return;
813         }
814 
815         bool isBuyFromLp = automatedMarketMakerPairs[from];
816         bool isSelltoLp = automatedMarketMakerPairs[to];
817 
818         if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
819             require(isTradingEnabled, "BACON: Trading is currently disabled.");
820             require(!_isBlocked[to], "BACON: Account is blocked");
821             require(!_isBlocked[from], "BACON: Account is blocked");
822             if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
823                 require(amount <= maxTxAmount, "BACON: Buy amount exceeds the maxTxBuyAmount.");
824             }
825             if (!_isExcludedFromMaxWalletLimit[to]) {
826                 require((balanceOf(to) + amount) <= maxWalletAmount, "BACON: Expected wallet amount exceeds the maxWalletAmount.");
827             }
828         }
829 
830         _adjustTaxes(isBuyFromLp, isSelltoLp, from , to);
831         bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
832 
833         if (
834             isTradingEnabled &&
835             canSwap &&
836             !_swapping &&
837             _totalFee > 0 &&
838             automatedMarketMakerPairs[to]
839         ) {
840             _swapping = true;
841             _swapAndLiquify();
842             _swapping = false;
843         }
844 
845         bool takeFee = !_swapping && isTradingEnabled;
846 
847         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
848             takeFee = false;
849         }
850 
851         if (takeFee && _totalFee > 0) {
852             uint256 fee = amount * _totalFee / 100;
853             amount = amount - fee;
854             super._transfer(from, address(this), fee);
855         }
856 
857         super._transfer(from, to, amount);
858 
859         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
860         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
861 
862         if(!_swapping) {
863             uint256 gas = gasForProcessing;
864             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
865                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
866             }
867             catch {}
868         }
869     }
870     function _adjustTaxes(bool isBuyFromLp, bool isSelltoLp, address from, address to) private {
871         _liquidityFee = 0;
872         _operationsFee = 0;
873         _buyBackFee = 0;
874         _treasuryFee = 0;
875         _holdersFee = 0;
876 
877         if (isBuyFromLp) {
878             if (block.number - _launchBlockNumber <= 5) {
879                 _liquidityFee = 100;
880             } else {
881                 _liquidityFee = _base.liquidityFeeOnBuy;
882                 _operationsFee = _base.operationsFeeOnBuy;
883                 _buyBackFee = _base.buyBackFeeOnBuy;
884                 _treasuryFee = _base.treasuryFeeOnBuy;
885                 _holdersFee = _base.holdersFeeOnBuy;
886             }
887         }
888         if (isSelltoLp) {
889             _liquidityFee = _base.liquidityFeeOnSell;
890             _operationsFee = _base.operationsFeeOnSell;
891             _buyBackFee = _base.buyBackFeeOnSell;
892             _treasuryFee = _base.treasuryFeeOnSell;
893             _holdersFee = _base.holdersFeeOnSell;
894         }
895         if (!isSelltoLp && !isBuyFromLp && (_feeOnSelectedWalletTransfers[from] || _feeOnSelectedWalletTransfers[to])) {
896 			_liquidityFee = _base.liquidityFeeOnSell;
897             _operationsFee = _base.operationsFeeOnSell;
898             _buyBackFee = _base.buyBackFeeOnSell;
899             _treasuryFee = _base.treasuryFeeOnSell;
900             _holdersFee = _base.holdersFeeOnSell;
901 		}
902         _totalFee = _liquidityFee + _operationsFee + _buyBackFee + _treasuryFee + _holdersFee;
903         emit FeesApplied(_liquidityFee, _operationsFee, _buyBackFee, _treasuryFee, _holdersFee, _totalFee);
904     }
905     function _setCustomSellTaxPeriod(CustomTaxPeriod storage map,
906         uint8 _liquidityFeeOnSell,
907         uint8 _operationsFeeOnSell,
908         uint8 _buyBackFeeOnSell,
909         uint8 _treasuryFeeOnSell,
910         uint8 _holdersFeeOnSell
911         ) private {
912         if (map.liquidityFeeOnSell != _liquidityFeeOnSell) {
913             emit CustomTaxPeriodChange(_liquidityFeeOnSell, map.liquidityFeeOnSell, 'liquidityFeeOnSell', map.periodName);
914             map.liquidityFeeOnSell = _liquidityFeeOnSell;
915         }
916         if (map.operationsFeeOnSell != _operationsFeeOnSell) {
917             emit CustomTaxPeriodChange(_operationsFeeOnSell, map.operationsFeeOnSell, 'operationsFeeOnSell', map.periodName);
918             map.operationsFeeOnSell = _operationsFeeOnSell;
919         }
920         if (map.buyBackFeeOnSell != _buyBackFeeOnSell) {
921             emit CustomTaxPeriodChange(_buyBackFeeOnSell, map.buyBackFeeOnSell, 'buyBackFeeOnSell', map.periodName);
922             map.buyBackFeeOnSell = _buyBackFeeOnSell;
923         }
924         if (map.treasuryFeeOnSell != _treasuryFeeOnSell) {
925             emit CustomTaxPeriodChange(_treasuryFeeOnSell, map.treasuryFeeOnSell, 'treasuryFeeOnSell', map.periodName);
926             map.treasuryFeeOnSell = _treasuryFeeOnSell;
927         }
928         if (map.holdersFeeOnSell != _holdersFeeOnSell) {
929             emit CustomTaxPeriodChange(_holdersFeeOnSell, map.holdersFeeOnSell, 'holdersFeeOnSell', map.periodName);
930             map.holdersFeeOnSell = _holdersFeeOnSell;
931         }
932     }
933     function _setCustomBuyTaxPeriod(CustomTaxPeriod storage map,
934         uint8 _liquidityFeeOnBuy,
935         uint8 _operationsFeeOnBuy,
936         uint8 _buyBackFeeOnBuy,
937         uint8 _treasuryFeeOnBuy,
938         uint8 _holdersFeeOnBuy
939         ) private {
940         if (map.liquidityFeeOnBuy != _liquidityFeeOnBuy) {
941             emit CustomTaxPeriodChange(_liquidityFeeOnBuy, map.liquidityFeeOnBuy, 'liquidityFeeOnBuy', map.periodName);
942             map.liquidityFeeOnBuy = _liquidityFeeOnBuy;
943         }
944         if (map.operationsFeeOnBuy != _operationsFeeOnBuy) {
945             emit CustomTaxPeriodChange(_operationsFeeOnBuy, map.operationsFeeOnBuy, 'operationsFeeOnBuy', map.periodName);
946             map.operationsFeeOnBuy = _operationsFeeOnBuy;
947         }
948         if (map.buyBackFeeOnBuy != _buyBackFeeOnBuy) {
949             emit CustomTaxPeriodChange(_buyBackFeeOnBuy, map.buyBackFeeOnBuy, 'buyBackFeeOnBuy', map.periodName);
950             map.buyBackFeeOnBuy = _buyBackFeeOnBuy;
951         }
952         if (map.treasuryFeeOnBuy != _treasuryFeeOnBuy) {
953             emit CustomTaxPeriodChange(_treasuryFeeOnBuy, map.treasuryFeeOnBuy, 'treasuryFeeOnBuy', map.periodName);
954             map.treasuryFeeOnBuy = _treasuryFeeOnBuy;
955         }
956         if (map.holdersFeeOnBuy != _holdersFeeOnBuy) {
957             emit CustomTaxPeriodChange(_holdersFeeOnBuy, map.holdersFeeOnBuy, 'holdersFeeOnBuy', map.periodName);
958             map.holdersFeeOnBuy = _holdersFeeOnBuy;
959         }
960     }
961     function _swapAndLiquify() private {
962         uint256 contractBalance = balanceOf(address(this));
963         uint256 initialETHBalance = address(this).balance;
964         uint8 _totalFeePrior = _totalFee;
965 
966         uint256 amountToLiquify = contractBalance * _liquidityFee / _totalFeePrior / 2;
967         uint256 amountToSwap = contractBalance - amountToLiquify;
968 
969         _swapTokensForETH(amountToSwap);
970 
971         uint256 ETHBalanceAfterSwap = address(this).balance - initialETHBalance;
972         uint256 totalETHFee = _totalFeePrior - (_liquidityFee / 2);
973         uint256 amountETHLiquidity = ETHBalanceAfterSwap * _liquidityFee / totalETHFee / 2;
974         uint256 amountETHOperations = ETHBalanceAfterSwap * _operationsFee / totalETHFee;
975         uint256 amountETHBuyBack = ETHBalanceAfterSwap * _buyBackFee / totalETHFee;
976         uint256 amountETHTreasury = ETHBalanceAfterSwap * _treasuryFee / totalETHFee;
977         uint256 amountETHHolders = ETHBalanceAfterSwap - (amountETHLiquidity + amountETHOperations + amountETHBuyBack + amountETHTreasury);
978 
979         payable(operationsWallet).transfer(amountETHOperations);
980         payable(buyBackWallet).transfer(amountETHBuyBack);
981         payable(treasuryWallet).transfer(amountETHTreasury);
982 
983         if (amountToLiquify > 0) {
984             _addLiquidity(amountToLiquify, amountETHLiquidity);
985             emit SwapAndLiquify(amountToSwap, amountETHLiquidity, amountToLiquify);
986         }
987 
988         (bool dividendSuccess,) = address(dividendTracker).call{value: amountETHHolders}("");
989         if(dividendSuccess) {
990             emit DividendsSent(amountETHHolders);
991         }
992 
993         _totalFee = _totalFeePrior;
994     }
995     function _swapTokensForETH(uint256 tokenAmount) private {
996         address[] memory path = new address[](2);
997         path[0] = address(this);
998         path[1] = uniswapV2Router.WETH();
999         _approve(address(this), address(uniswapV2Router), tokenAmount);
1000         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1001             tokenAmount,
1002             0, // accept any amount of ETH
1003             path,
1004             address(this),
1005             block.timestamp
1006         );
1007     }
1008     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1009         _approve(address(this), address(uniswapV2Router), tokenAmount);
1010         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1011             address(this),
1012             tokenAmount,
1013             0, // slippage is unavoidable
1014             0, // slippage is unavoidable
1015             liquidityWallet,
1016             block.timestamp
1017         );
1018     }
1019 }
1020 
1021 contract BACONDividendTracker is DividendPayingToken {
1022     using SafeMath for uint256;
1023     using SafeMathInt for int256;
1024     using IterableMapping for IterableMapping.Map;
1025 
1026     IterableMapping.Map private tokenHoldersMap;
1027 
1028     uint256 public lastProcessedIndex;
1029     mapping (address => bool) public excludedFromDividends;
1030     mapping (address => uint256) public lastClaimTimes;
1031     uint256 public claimWait;
1032     uint256 public minimumTokenBalanceForDividends;
1033 
1034     event ExcludeFromDividends(address indexed account);
1035     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1036 
1037     constructor() DividendPayingToken("BACON_Dividend_Tracker", "BACON_Dividend_Tracker") {
1038         claimWait = 3600;
1039         minimumTokenBalanceForDividends = 0 * (10**18);
1040     }
1041     function setRewardToken(address token) external onlyOwner {
1042         _setRewardToken(token);
1043     }
1044     function setUniswapRouter(address router) external onlyOwner {
1045         _setUniswapRouter(router);
1046     }
1047     function _transfer(address, address, uint256) internal override {
1048         require(false, "BACON_Dividend_Tracker: No transfers allowed");
1049     }
1050     function excludeFromDividends(address account) external onlyOwner {
1051         require(!excludedFromDividends[account]);
1052         excludedFromDividends[account] = true;
1053         _setBalance(account, 0);
1054         tokenHoldersMap.remove(account);
1055         emit ExcludeFromDividends(account);
1056     }
1057     function setTokenBalanceForDividends(uint256 newValue) external onlyOwner {
1058         require(minimumTokenBalanceForDividends != newValue, "BACON_Dividend_Tracker: minimumTokenBalanceForDividends already the value of 'newValue'.");
1059         minimumTokenBalanceForDividends = newValue;
1060     }
1061     function getNumberOfTokenHolders() external view returns(uint256) {
1062         return tokenHoldersMap.keys.length;
1063     }
1064     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1065         if(lastClaimTime > block.timestamp)  {
1066             return false;
1067         }
1068         return block.timestamp.sub(lastClaimTime) >= claimWait;
1069     }
1070     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1071         if(excludedFromDividends[account]) {
1072             return;
1073         }
1074         if(newBalance >= minimumTokenBalanceForDividends) {
1075             _setBalance(account, newBalance);
1076             tokenHoldersMap.set(account, newBalance);
1077         }
1078         else {
1079             _setBalance(account, 0);
1080             tokenHoldersMap.remove(account);
1081         }
1082         processAccount(account, true);
1083     }
1084     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1085         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1086         if(numberOfTokenHolders == 0) {
1087             return (0, 0, lastProcessedIndex);
1088         }
1089 
1090         uint256 _lastProcessedIndex = lastProcessedIndex;
1091         uint256 gasUsed = 0;
1092         uint256 gasLeft = gasleft();
1093         uint256 iterations = 0;
1094         uint256 claims = 0;
1095 
1096         while(gasUsed < gas && iterations < numberOfTokenHolders) {
1097             _lastProcessedIndex++;
1098             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1099                 _lastProcessedIndex = 0;
1100             }
1101             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1102             if(canAutoClaim(lastClaimTimes[account])) {
1103                 if(processAccount(payable(account), true)) {
1104                     claims++;
1105                 }
1106             }
1107 
1108             iterations++;
1109             uint256 newGasLeft = gasleft();
1110             if(gasLeft > newGasLeft) {
1111                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1112             }
1113             gasLeft = newGasLeft;
1114         }
1115         lastProcessedIndex = _lastProcessedIndex;
1116         return (iterations, claims, lastProcessedIndex);
1117     }
1118 
1119     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1120         uint256 amount = _withdrawDividendOfUser(account);
1121         if(amount > 0) {
1122             lastClaimTimes[account] = block.timestamp;
1123             emit Claim(account, amount, automatic);
1124             return true;
1125         }
1126         return false;
1127     }
1128 }